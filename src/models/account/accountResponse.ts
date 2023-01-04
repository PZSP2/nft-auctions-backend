import { Role } from "@prisma/client";
import MinimalNftResponse from "../nft/out/minimalNftResponse";
import MinimalAuctionResponse from "../auction/out/minimalAuctionResponse";

export default interface AccountResponse {
  readonly accountId: number;

  readonly email: string;

  readonly name: string;

  readonly role: Role;

  readonly walletAddress?: string;

  readonly walletBalance?: number;

  readonly ownedNfts: MinimalNftResponse[];

  readonly biddenAuctions: MinimalAuctionResponse[];
}
