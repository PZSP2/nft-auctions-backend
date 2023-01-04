import NftAuctionServiceError from "./NftAuctionServiceError";

export default class UniqueConstraintError extends NftAuctionServiceError {
  constructor(message: string) {
    super(message);
    this.name = "UniqueConstraintError";
  }
}
