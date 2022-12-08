import {
  AccountNFTsRequest,
  AccountNFTsResponse,
  AccountOffersResponse,
  Client,
  convertStringToHex,
  NFTBuyOffersRequest,
  NFTBuyOffersResponse,
  NFTokenAcceptOffer,
  NFTokenCreateOffer,
  NFTokenMint,
  TxResponse,
  Wallet,
} from "xrpl";
import SellOfferInfoModel from "../models/sellOfferInfoModel";
import BuyOfferInfoModel from "../models/buyOfferInfoModel";
import NFTMintDTO from "../models/nftMintDTO";
import AcceptOfferDTO from "../models/acceptOfferDTO";

// TODO REFATOR ALL THIS
enum NetType {
  MainNet = "wss://s1.ripple.com/",
  TestNet = "wss://s.altnet.rippletest.net/",
  DevNet = "wss://s.devnet.rippletest.net/",
}

export default class XrpLedgerAdapter {
  private static instance: XrpLedgerAdapter;
  private readonly client: Client;

  private static defaultNetType: NetType = NetType.TestNet;

  private constructor(netType: NetType) {
    this.client = new Client(netType);
  }

  public static getInstance(): XrpLedgerAdapter {
    if (!XrpLedgerAdapter.instance) {
      XrpLedgerAdapter.instance = new XrpLedgerAdapter(this.defaultNetType);
    }
    return XrpLedgerAdapter.instance;
  }

  async connectClient(): Promise<void> {
    if (!this.client.isConnected()) {
      console.log(
        "Connecting to client on net: " + XrpLedgerAdapter.defaultNetType
      );
      await this.client.connect();
    }
  }

  async disconnectClient(): Promise<void> {
    if (this.client.isConnected()) {
      console.log("Disconnecting client");
      await this.client.disconnect();
    }
  }

  async getWalletBalance(walletAddress: string): Promise<string> {
    return await this.client.getXrpBalance(walletAddress);
  }

  getWallet(seed: string): Wallet {
    console.log("Retrieving wallet");
    return Wallet.fromSeed(seed);
  }

  async getBalance(walletAddress: string): Promise<number> {
      return Number(await this.client.getXrpBalance(walletAddress));
  }
  async createSellOffer(
    sellOffer: SellOfferInfoModel,
    wallet: Wallet
  ): Promise<TxResponse> {
    const offer: NFTokenCreateOffer = {
      Account: sellOffer.accountAddress,
      TransactionType: "NFTokenCreateOffer",
      NFTokenID: sellOffer.nftTokenId,
      Amount: sellOffer.amount.toFixed(0),
      Destination: sellOffer.destinationAddress,
      Flags: 0x00000001,
    };
    return await this.client.submitAndWait(offer, { wallet: wallet });
  }

  async createBuyOffer(
    buyOffer: BuyOfferInfoModel,
    wallet: Wallet
  ): Promise<TxResponse> {
    const offer: NFTokenCreateOffer = {
      Account: buyOffer.accountAddress,
      TransactionType: "NFTokenCreateOffer",
      Owner: buyOffer.ownerAddress,
      NFTokenID: buyOffer.nftTokenId,
      Amount: buyOffer.amount.toFixed(0),
    };
    console.log("Creating buy offer");
    return await this.client.submitAndWait(offer, { wallet: wallet });
  }

  async mintNFT(nftInfo: NFTMintDTO, wallet: Wallet): Promise<TxResponse> {
    const mintTransaction: NFTokenMint = {
      TransactionType: "NFTokenMint",
      Account: wallet.classicAddress,
      URI: convertStringToHex(nftInfo.uri),
      Flags: nftInfo.flags,
      NFTokenTaxon: 0,
    };
    return await this.client.submitAndWait(mintTransaction, { wallet: wallet });
  }

  async getNftOffersByNftId(
    nftId: string
  ): Promise<NFTBuyOffersResponse | null> {
    const request: NFTBuyOffersRequest = {
      command: "nft_buy_offers",
      nft_id: nftId,
    };
    return await this.client.request(request).catch((err) => {
      console.log(err);
      return null;
    });
  }

  async getOffersByAccount(
    accountAddress: string
  ): Promise<AccountOffersResponse | null> {
    return await this.client
      .request({
        command: "account_offers",
        account: accountAddress,
      })
      .catch((err) => {
        console.log(err);
        return null;
      });
  }

  acceptNftOffer(offer: AcceptOfferDTO, wallet: Wallet): void {
    const transactionBlob: NFTokenAcceptOffer = {
      TransactionType: "NFTokenAcceptOffer",
      Account: offer.brokerAddress,
      NFTokenSellOffer: offer.ownerSellOfferID,
      NFTokenBuyOffer: offer.winningBuyOfferID,
      NFTokenBrokerFee: offer.brokerFee.toString(),
    };
    this.client
      .submitAndWait(transactionBlob, { wallet: wallet })
      .then((res) => {
        console.log(`Submitted transaction ${res}`);
      })
      .catch((err) => {
        console.log(`Error during accepting transaction: ${err}`);
      });
  }

  async fundWallet(
    seed: string | null
  ): Promise<Wallet | { wallet: Wallet; balance: number }> {
    console.log("Funding wallet");
    if (seed != null) {
      return Wallet.fromSeed(seed);
    } else {
      console.log("Funding a new wallet");
      return await this.client.fundWallet();
    }
  }

  async getAccountNFTsResponse(
    accountAddress: string
  ): Promise<AccountNFTsResponse | null> {
    const request: AccountNFTsRequest = {
      command: "account_nfts",
      account: accountAddress,
    };
    return await this.client.request(request).catch((err) => {
      console.log(err);
      return null;
    });
  }
}
