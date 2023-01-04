import NftAuctionServiceError from "./NftAuctionServiceError";

export default class AuctionConfirmError extends NftAuctionServiceError {
  constructor(message: string) {
    super(message);
    this.name = "AuctionConfirmError";
  }
}
