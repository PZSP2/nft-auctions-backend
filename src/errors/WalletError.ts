import NftAuctionServiceError from "./NftAuctionServiceError";

export default class WalletError extends NftAuctionServiceError {
  constructor(message: string) {
    super(message);
    this.name = "WalletError";
  }
}
