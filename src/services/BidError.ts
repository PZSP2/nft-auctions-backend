import NftAuctionServiceError from "../errors/NftAuctionServiceError";

export default class BidError extends NftAuctionServiceError {
  constructor(message: string) {
    super(message);
    this.name = "BidError";
  }
}
