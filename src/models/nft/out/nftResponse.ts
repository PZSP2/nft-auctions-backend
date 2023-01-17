import { MinimalAccountResponse } from "../../account/minimalAccountResponse";
import TagResponse from "./tagResponse";

export default interface NftResponse {
  readonly nftId: number;

  readonly name: string;

  readonly description?: string;

  readonly uri?: string;

  readonly isImage: boolean;
  readonly owner?: MinimalAccountResponse;

  readonly issuer?: MinimalAccountResponse;

  readonly tags: TagResponse[];
}
