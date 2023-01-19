export default interface MinimalNftResponse {
  readonly nftId: number;

  readonly name: string;

  readonly description: string;

  readonly uri: string;

  readonly isImage: boolean;

  readonly tags: string[];

  readonly mintedDate?: Date;

  readonly activeAuctionId?: number;
}
