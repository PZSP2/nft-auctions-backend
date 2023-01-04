import NftAuctionServiceError from "./NftAuctionServiceError";

export default class AuctionStatusError extends NftAuctionServiceError {
  constructor(message: string) {
    super(message);
    this.name = "AuctionStatusError";
  }
}
