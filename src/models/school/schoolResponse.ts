import MinimalAuctionResponse from "../auction/out/minimalAuctionResponse";

export default interface SchoolResponse {
  readonly schoolId: number;

  readonly name: string;

  readonly phone: string;

  readonly email: string;

  readonly address: string;

  readonly auctions: MinimalAuctionResponse[];
}
