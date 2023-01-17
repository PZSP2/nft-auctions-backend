import { Auction, Bid, NFT, Role, School, Tag, User } from "@prisma/client";
import NftResponse from "../models/nft/out/nftResponse";
import AccountResponse from "../models/account/accountResponse";
import { MinimalAccountResponse } from "../models/account/minimalAccountResponse";
import AuctionResponse from "../models/auction/out/auctionResponse";
import BidResponse from "../models/auction/out/bidResponse";
import MinimalAuctionResponse from "../models/auction/out/minimalAuctionResponse";
import MinimalNftResponse from "../models/nft/out/minimalNftResponse";
import MinimalSchoolResponse from "../models/school/minimalSchoolResponse";
import SchoolResponse from "../models/school/schoolResponse";
import TagResponse from "../models/nft/out/tagResponse";
import { NFTWithTags, NFTWithTagsAndIssuer } from "../models/types";

export default class MapperUtils {
  static mapNftToNftResponse = (
    nft: NFT & { issuer: User; owner: User; tags: Tag[] }
  ): NftResponse => ({
    nftId: nft.id,
    name: nft.name,
    description: nft.description != null ? nft.description : undefined,
    uri: nft.uri,
    isImage: nft.is_image,
    issuer:
      nft.issuer != null
        ? MapperUtils.mapUserToMinimalUserResponse(nft.issuer)
        : undefined,
    owner:
      nft.owner != null
        ? MapperUtils.mapUserToMinimalUserResponse(nft.owner)
        : undefined,
    tags: nft.tags.map((tag) => this.mapTagToTagResponse(tag)),
  });

  static mapUserToMinimalUserResponse(user: User): MinimalAccountResponse {
    return {
      accountId: user.id,
      name: user.name ?? user.email,
    };
  }

  static mapUserToAccountResponse(
    user: User & {
      owned_nft?: NFTWithTags[];
      bid?: (Bid & { auction: Auction & { nft: NFTWithTagsAndIssuer } })[];
    }
  ): AccountResponse {
    return {
      role: user.accountType ?? Role.NORMAL_USER,
      accountId: user.id,
      biddenAuctions:
        user.bid?.map((bid) =>
          this.mapAuctionToMinimalAuctionResponse(bid.auction)
        ) ?? [],
      email: user.email,
      name: user.name ?? user.email,
      ownedNfts:
        user.owned_nft?.map((nft) => this.mapNftToMinimalResponse(nft)) ?? [],
    };
  }

  static mapNftToMinimalResponse(nft: NFTWithTags): MinimalNftResponse {
    return {
      nftId: nft.id,
      name: nft.name,
      description: nft.description ?? "",
      uri: nft.uri,
      isImage: nft.is_image,
      tags: nft.tags.map((tag) => this.mapTagToString(tag)),
    };
  }

  static mapTagToTagResponse(tag: Tag): TagResponse {
    return {
      tagId: tag.id,
      name: tag.name,
    };
  }

  static mapTagToString(tag: Tag): string {
    return tag.name;
  }

  static mapAuctionToMinimalAuctionResponse(
    auction: Auction & {
      nft: NFTWithTagsAndIssuer;
      bids?: (Bid & { bidder: User })[];
    }
  ): MinimalAuctionResponse {
    const winningBid = auction.bids?.reduce((a, b) =>
      a.timestamp > b.timestamp ? a : b
    );
    return {
      auctionId: auction.id,
      lastBid:
        winningBid != null ? this.mapBidToBidResponse(winningBid) : undefined,
      nftName: auction.nft.name,
      nftUri: auction.nft.uri,
      status: auction.status,
      nftId: auction.nft_id,
      nftTags: auction.nft.tags.map((tag) => this.mapTagToString(tag)),
      nftIssuer: auction.nft.issuer.name ?? "",
    };
  }

  static mapAuctionToAuctionResponse(
    auction: Auction & {
      bids?: (Bid & { bidder: User })[];
      nft: NFT & { tags: Tag[] };
    }
  ): AuctionResponse {
    const winningBid =
      auction.bids?.length ?? 0 > 0
        ? auction.bids?.reduce((a, b) => (a.timestamp > b.timestamp ? a : b))
        : undefined;

    return {
      auctionId: auction.id,
      bids: auction.bids?.map((bid) => this.mapBidToBidResponse(bid)) ?? [],
      currentPrice: winningBid?.bid_price ?? auction.minimal_price,
      endDate: auction.end_time,
      status: auction.status,
      nft: this.mapNftToMinimalResponse(auction.nft),
      school: undefined,
      startDate: auction.start_time,
      startingPrice: 0,
      winningBid:
        winningBid != null ? this.mapBidToBidResponse(winningBid) : undefined,
    };
  }

  static mapBidToBidResponse(bid: Bid & { bidder: User }): BidResponse {
    return {
      auctionId: bid.auction_id,
      createdAt: bid.timestamp,
      bidder: this.mapUserToMinimalUserResponse(bid.bidder),
      price: bid.bid_price,
    };
  }

  static mapSchoolToMinimalSchoolResponse(
    school: School
  ): MinimalSchoolResponse {
    return {
      schoolId: school.id,
      name: school.name,
    };
  }

  static mapSchoolToSchoolResponse(
    school: School & { auctions?: (Auction & { nft: NFTWithTagsAndIssuer })[] }
  ): SchoolResponse {
    return {
      schoolId: school.id,
      name: school.name,
      phone: school.phone,
      email: school.email,
      address: school.country + " " + school.city + " " + school.address,
      auctions:
        school.auctions?.map((auction) =>
          this.mapAuctionToMinimalAuctionResponse(auction)
        ) ?? [],
    };
  }
}
