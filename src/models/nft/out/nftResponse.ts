import { MinimalAccountResponse } from "../../account/minimalAccountResponse";

export default interface NftResponse {
  readonly nftId: number;

  readonly name: string;

  readonly description?: string;

  readonly fileUri?: string;

  readonly isImage: boolean;
  readonly owner?: MinimalAccountResponse;

  readonly issuer?: MinimalAccountResponse;
}
