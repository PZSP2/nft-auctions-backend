import { Wallet } from "xrpl";
import FinalizedAuctionDto from "../models/acceptOfferDTO";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import { BaseResponse } from "xrpl/dist/npm/models/methods/baseMethod";
import BuyOfferInfoModel from "../models/buyOfferInfoModel";
import { PrismaClient } from "@prisma/client";
import SellOfferInfoModel from "../models/sellOfferInfoModel";
import AuctionOffers from "../models/auction/auctionOffers";

// TODO refactor this class
export class BrokerService {
  private readonly brokerWallet: Wallet;
  private readonly ledgerAdapter: XrpLedgerAdapter;
  private readonly prisma: PrismaClient = new PrismaClient();

  private static instance: BrokerService;
  private constructor(ledgerAdapter: XrpLedgerAdapter, brokerWallet: Wallet) {
    this.ledgerAdapter = ledgerAdapter;
    this.brokerWallet = brokerWallet;
  }

  public static getInstance(): BrokerService {
    if (!BrokerService.instance) {
      BrokerService.instance = new BrokerService(
        XrpLedgerAdapter.getInstance(),
        XrpLedgerAdapter.getInstance().getWallet(
          "sEd7Wg2URHoHQjwNPA2iHssrErcUxGF"
        )
      );
    }
    return BrokerService.instance;
  }

  async createAuctionOffers(
    auctionId: number,
    nftId: string,
    price: number,
    buyerrId: number,
    sellerId: number
  ): Promise<AuctionOffers> {
    const sellerAddress = await this.prisma.user.findFirst({
      where: {
        id: sellerId,
      },
      select: {
        wallet_address: true,
        wallet_seed: true,
      },
    });
    const buyerAddress = await this.prisma.user.findFirst({
      where: {
        id: buyerrId,
      },
      select: {
        wallet_address: true,
        wallet_seed: true,
      },
    });
    if (
      sellerAddress?.wallet_address == null ||
      buyerAddress?.wallet_address == null
    ) {
      // TODO change to other custom errors
      throw new Error("Account not found");
    }
    const buyOfferInfo: BuyOfferInfoModel = {
      amount: price,
      flags: 0,
      nftTokenId: nftId,
      ownerAddress: sellerAddress?.wallet_address,
      accountAddress: this.brokerWallet.address,
    };

    const sellOfferInfo: SellOfferInfoModel = {
      amount: price,
      flags: 0,
      nftTokenId: nftId,
      accountAddress: sellerAddress?.wallet_address,
      destinationAddress: this.brokerWallet.address,
    };
    const sellOffer = await this.ledgerAdapter.createSellOffer(
      sellOfferInfo,
      this.ledgerAdapter.getWallet(sellerAddress?.wallet_seed ?? "")
    );
    const buyOffer = await this.ledgerAdapter.createBuyOffer(
      buyOfferInfo,
      this.brokerWallet
    );
    console.log("Created offers");
    return {
      auctionId: auctionId,
      bidAmount: price,
      bidderId: buyerrId,
      buyOfferId: buyOffer.id,
      sellOfferId: sellOffer.id,
      sellerId: sellerId,
    };
  }

  async getBookersOffers(): Promise<BaseResponse | null> {
    return await this.ledgerAdapter.getOffersByAccount(
      this.brokerWallet.address
    );
  }

  async finalizeAuction(offers: AuctionOffers): Promise<void> {
    const finalizedAuctionDto: FinalizedAuctionDto = {
      brokerAddress: this.brokerWallet.classicAddress,
      brokerFee: 0,
      ownerSellOfferID: offers.sellOfferId.toString(),
      winningBuyOfferID: offers.buyOfferId.toString(),
    };
    await this.ledgerAdapter.acceptNftOffer(
      finalizedAuctionDto,
      this.brokerWallet
    );
  }
}
