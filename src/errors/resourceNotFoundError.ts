import NftAuctionServiceError from "./NftAuctionServiceError";

export default class ResourceNotFoundError extends NftAuctionServiceError {
  constructor(msg: string) {
    super(msg);
    this.name = "ResourceNotFoundError";
  }
}
