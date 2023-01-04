import NftAuctionServiceError from "./NftAuctionServiceError";

export default class NftCreateError extends NftAuctionServiceError {
  constructor(message: string) {
    super(message);
    this.name = "NftCreateError";
  }
}
