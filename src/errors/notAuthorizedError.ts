import NftAuctionServiceError from "./NftAuctionServiceError";

export default class NotAuthorizedError extends NftAuctionServiceError {
  constructor(msg: string) {
    super(msg);
    this.name = "NotAuthorizedError";
  }
}
