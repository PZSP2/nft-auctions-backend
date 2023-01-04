import SchoolResponse from "../../school/schoolResponse";
import BidResponse from "./bidResponse";
import MinimalNftResponse from "../../nft/out/minimalNftResponse";
import { Status } from "@prisma/client";

export default interface AuctionResponse {
  readonly auctionId: number;

  readonly nft: MinimalNftResponse;

  readonly startingPrice: number;

  readonly currentPrice: number;

  readonly status: Status;

  readonly school?: SchoolResponse;

  readonly bids: BidResponse[];

  readonly endDate: Date;

  readonly startDate: Date;

  readonly winningBid?: BidResponse;
}
