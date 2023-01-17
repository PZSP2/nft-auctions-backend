import {
  Auction,
  Bid,
  NFT,
  PrismaClient,
  Status,
  Tag,
  User,
} from "@prisma/client";
import AuctionBidDTO from "../models/auction/in/auctionBidDTO";
import { CreateAuctionDTO } from "../models/auction/in/createAuctionDTO";
import BidError from "./BidError";
import { NFTokenAcceptOffer, NFTokenCreateOffer } from "xrpl";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import NotAuthorizedError from "../errors/notAuthorizedError";
import ResourceNotFoundError from "../errors/resourceNotFoundError";
import AuctionConfirmError from "../errors/auctionConfirmError";
import AuctionStatusError from "../errors/auctionStatusError";
import { ScheduleUtils } from "../utils/scheduleUtils";
import NftCreateError from "../errors/nftCreateError";
import {
  BidWithBidder,
  NFTWithTags,
  NFTWithTagsAndIssuer,
} from "../models/types";

export default class AuctionService {
  private readonly prisma: PrismaClient;
  private readonly ledgerAdapter = XrpLedgerAdapter.getInstance();

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  getAllAuctions = async (
    schoolId: number | undefined,
    status: Status | undefined,
    nftId: number | undefined,
    issuerId: number | undefined,
    tagId: number | undefined
  ): Promise<(Auction & { nft: NFTWithTags; bids: BidWithBidder[] })[]> =>
    this.prisma.auction.findMany({
      where: {
        status: {
          equals: status ?? undefined,
        },

        nft_id: nftId,
        school_id: schoolId,
        nft: {
          issuer_id: issuerId,
          tags: {
            some: {
              id: tagId,
            },
          },
        },
      },
      include: {
        nft: {
          include: {
            tags: true,
          },
        },
        bids: {
          include: {
            bidder: true,
          },
        },
      },
    });

  getAuctionByAuctionId = async (
    auctionId: number
  ): Promise<
    Auction & {
      nft: NFT & { issuer: User; owner: User; tags: Tag[] };
      bids: BidWithBidder[];
    }
  > => {
    const auction = await this.prisma.auction.findFirst({
      where: {
        id: auctionId,
      },
      include: {
        bids: {
          include: {
            bidder: true,
          },
        },
        nft: {
          include: {
            issuer: true,
            owner: true,
            tags: true,
          },
        },
      },
    });
    if (auction == null) {
      throw new ResourceNotFoundError("Auction not found");
    } else {
      return auction;
    }
  };

  private getHighestBid = (
    auctionId: number
  ): Promise<(Bid & { bidder: User }) | null> =>
    this.prisma.bid.findFirst({
      where: {
        auction_id: auctionId,
      },
      orderBy: {
        bid_price: "desc",
      },
      include: {
        bidder: true,
      },
    });

  private checkIfAuctionIsActive = (auction: Auction): boolean => {
    if (auction == null) return true;
    return auction.status === Status.ACTIVE;
  };

  private updateAuctionStatus = async (
    auctionId: number,
    desiredStatus: Status
  ): Promise<Auction> =>
    await this.prisma.auction.update({
      where: {
        id: auctionId,
      },
      data: {
        status: desiredStatus,
      },
    });

  bidOnAuction = async (
    auctionId: number,
    bidderId: number,
    bid: AuctionBidDTO
  ): Promise<Bid & { bidder: User }> => {
    const auction = await this.getAuctionByAuctionId(auctionId);
    const highestBid =
      (await this.getHighestBid(auctionId))?.bid_price ??
      auction?.minimal_price ??
      0;
    const bidder = await this.prisma.user.findFirst({
      where: {
        id: bidderId,
      },
    });
    if (!this.checkIfAuctionIsActive(auction)) {
      throw new AuctionStatusError("Auction is not active");
    } else if (bid.bidAmount <= highestBid) {
      throw new BidError("Bid amount is too low");
    } else if (bidderId === auction.nft.owner_id) {
      throw new BidError("You cannot bid on your own NFT");
    } else if (bidder?.wallet_seed == null) {
      throw new BidError("You must have a wallet to bid on an auction");
    }
    const newBid = await this.prisma.bid.create({
      data: {
        auction_id: auctionId,
        bidder_id: bidderId,
        bid_price: bid.bidAmount,
      },
      include: {
        bidder: true,
      },
    });
    const updatedAuction = await this.prisma.auction.update({
      where: {
        id: auctionId,
      },
      data: {
        end_time: new Date(auction.end_time.getTime() + 1000 * 60 * 5),
      },
    });
    ScheduleUtils.getInstance().scheduleJob(
      updatedAuction.id,
      updatedAuction.end_time,
      async () => {
        await this.updateAuctionStatus(auctionId, Status.WON);
      }
    );
    return newBid;
  };

  createAuction = async (
    createAuctionDTO: CreateAuctionDTO,
    sellerId: number
  ): Promise<Auction & { nft: NFTWithTagsAndIssuer }> => {
    const nft = await this.prisma.nFT.findFirst({
      where: {
        id: createAuctionDTO.nftId,
      },
    });
    if (nft?.ledgerId == null) {
      throw new NftCreateError("NFT not minted");
    }
    if (nft?.owner_id !== sellerId) {
      throw new NotAuthorizedError("User has to be owner of the NFT");
    }

    const auction = await this.prisma.auction.create({
      data: {
        nft_id: createAuctionDTO.nftId,
        minimal_price: createAuctionDTO.minimalPrice,
        start_time: createAuctionDTO.startTime,
        end_time: createAuctionDTO.endTime,
        school_id: createAuctionDTO.schoolId,
        status: Status.ACTIVE,
      },
      include: {
        nft: {
          include: {
            issuer: true,
            tags: true,
          },
        },
        school: true,
      },
    });

    ScheduleUtils.getInstance().scheduleJob(
      auction.id,
      auction.end_time,
      async () => {
        const endingAuction = await this.getAuctionByAuctionId(auction.id);
        if (endingAuction.bids.length === 0) {
          await this.updateAuctionStatus(auction.id, Status.EXPIRED);
        } else {
          await this.updateAuctionStatus(auction.id, Status.WON);
        }
      }
    );
    return auction;
  };

  confirmAuction = async (
    auctionId: number,
    accountId: number
  ): Promise<Auction> => {
    const auction = await this.getAuctionByAuctionId(auctionId);
    if (auction.nft.owner_id !== accountId)
      throw new NotAuthorizedError("User has to be issuer of the NFT");
    const highestBid = await this.getHighestBid(auctionId);
    if (auction.status != Status.WON || highestBid == null)
      throw new AuctionConfirmError("Auction is not won");
    const nftToken = auction.nft.ledgerId ?? "";
    const buyer = highestBid.bidder_id;
    const seller = auction.nft.issuer_id;
    const price = highestBid.bid_price;

    if (!auction.nft.owner.wallet_seed || !highestBid.bidder.wallet_seed) {
      throw new AuctionConfirmError("Buyer or seller has no wallet seed");
    }

    const sellerWallet = this.ledgerAdapter.getWallet(
      auction.nft.owner.wallet_seed
    );
    const buyerWallet = this.ledgerAdapter.getWallet(
      highestBid.bidder.wallet_seed
    );
    const sellOfferInfo: NFTokenCreateOffer = {
      Account: sellerWallet.classicAddress,
      Destination: buyerWallet.classicAddress,
      Amount: price.toFixed(0),
      NFTokenID: nftToken,
      TransactionType: "NFTokenCreateOffer",
      Flags: 1,
    };

    const confirmedAuction = await this.updateAuctionStatus(
      auctionId,
      Status.CALL_FOR_CONFIRM
    );

    this.ledgerAdapter
      .createSellOffer(sellOfferInfo, sellerWallet)
      .then(async () => {
        const sellOffers = await this.ledgerAdapter.getNftsSellOffers(nftToken);

        const sellOfferId = sellOffers.result.offers[0].nft_offer_index;

        console.log("Created offers");

        const acceptOffer: NFTokenAcceptOffer = {
          Account: sellerWallet.classicAddress,
          TransactionType: "NFTokenAcceptOffer",
          NFTokenBuyOffer: sellOfferId,
        };

        await this.ledgerAdapter.acceptNftOffer(
          acceptOffer,
          sellerWallet,
          (result) => {
            if (result?.result.validated == true) {
              console.log("Accepted offer");
              this.updateNFTOwners(auction.nft.id, seller, buyer);
            }
          }
        );
        await this.updateAuctionStatus(auction.id, Status.CONFIRMED);
      });
    return confirmedAuction;
  };

  async updateNFTOwners(
    nftId: number,
    sellerId: number,
    buyerId: number
  ): Promise<void> {
    await this.prisma.nFT.updateMany({
      where: {
        id: nftId,
        owner_id: sellerId,
      },
      data: {
        owner_id: buyerId,
      },
    });
  }
}
