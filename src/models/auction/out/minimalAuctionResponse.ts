import BidResponse from "./bidResponse";
import { Status } from "@prisma/client";

export default interface MinimalAuctionResponse {
  readonly auctionId: number;

  readonly status: Status;

  readonly lastBid?: BidResponse;

  readonly nftName: string;

  readonly nftUri: string;
}
