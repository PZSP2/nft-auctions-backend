import { MinimalAccountResponse } from "../../account/minimalAccountResponse";

export default interface BidResponse {
  readonly auctionId: number;

  readonly bidder: MinimalAccountResponse;

  readonly price: number;

  readonly createdAt: Date;
}
