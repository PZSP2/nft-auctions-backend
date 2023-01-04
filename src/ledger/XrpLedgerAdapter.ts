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
  NFTSellOffersRequest,
  NFTSellOffersResponse,
  TxResponse,
  Wallet,
} from "xrpl";
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

  public static getInstance = (): XrpLedgerAdapter => {
    if (!XrpLedgerAdapter.instance) {
      XrpLedgerAdapter.instance = new XrpLedgerAdapter(this.defaultNetType);
    }
    return XrpLedgerAdapter.instance;
  };

  connectClient = async (): Promise<void> => {
    if (!this.client.isConnected()) {
      console.log(
        "Connecting to client on net: " + XrpLedgerAdapter.defaultNetType
      );
      await this.client.connect();
    }
  };

  disconnectClient = async (): Promise<void> => {
    if (this.client.isConnected()) {
      console.log("Disconnecting client");
      await this.client.disconnect();
    }
  };

  getWallet = (seed: string): Wallet => {
    console.log("Retrieving wallet");
    return Wallet.fromSeed(seed);
  };

  getBalance = async (walletAddress: string): Promise<number> =>
    Number(await this.client.getXrpBalance(walletAddress));

  createSellOffer = async (
    sellOffer: NFTokenCreateOffer,
    wallet: Wallet
  ): Promise<TxResponse> => {
    return await this.client.submitAndWait(sellOffer, {
      autofill: true,
      wallet: wallet,
    });
  };

  mintNFT = async (uri: string, wallet: Wallet): Promise<TxResponse> => {
    const mintTransaction: NFTokenMint = {
      TransactionType: "NFTokenMint",
      Account: wallet.classicAddress,
      URI: convertStringToHex(uri),
      Flags: 0x00000008,
      NFTokenTaxon: 0,
    };
    return await this.client.submitAndWait(mintTransaction, {
      autofill: true,
      wallet: wallet,
    });
  };

  getNftsBuyOffers = async (nftId: string): Promise<NFTBuyOffersResponse> => {
    const request: NFTBuyOffersRequest = {
      command: "nft_buy_offers",
      nft_id: nftId,
    };
    return await this.client.request(request);
  };

  getNftsSellOffers = async (nftId: string): Promise<NFTSellOffersResponse> => {
    const request: NFTSellOffersRequest = {
      command: "nft_sell_offers",
      nft_id: nftId,
    };
    return await this.client.request(request);
  };

  getOffersByAccount = async (
    accountAddress: string
  ): Promise<AccountOffersResponse | null> =>
    await this.client.request({
      command: "account_offers",
      account: accountAddress,
    });

  acceptNftOffer = (
    offer: NFTokenAcceptOffer,
    wallet: Wallet,
    callback: (result: TxResponse | null) => void
  ): void => {
    this.client
      .submitAndWait(offer, { autofill: true, wallet: wallet })
      .then((res) => {
        callback(res);
      })
      .catch((err) => {
        console.log(err);
        callback(null);
      });
  };

  fundWallet = async (seed: string | null): Promise<Wallet> => {
    console.log("Funding wallet");
    const wallet = await (seed != null
      ? Wallet.fromSeed(seed)
      : this.client.fundWallet());
    return wallet instanceof Wallet ? wallet : (await wallet).wallet;
  };

  getAccountNFTsResponse = async (
    accountAddress: string
  ): Promise<AccountNFTsResponse | null> => {
    const request: AccountNFTsRequest = {
      command: "account_nfts",
      account: accountAddress,
    };
    return await this.client.request(request).catch((err) => {
      console.log(err);
      return null;
    });
  };
}
