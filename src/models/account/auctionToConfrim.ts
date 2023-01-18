export interface OwnedAuctionUpdates {
  readonly auctionId: number;
  readonly nftId: number;

  readonly nftName: string;

  readonly finalPrice?: number;
}

export interface BiddenAuctionUpdates {
  readonly auctionId: number;
  readonly nftId: number;

  readonly nftName: string;

  readonly endTime: string;

  readonly currentPrice?: number;

  readonly isLeading: boolean;
}
export type AuctionsUpdatesResponse = {
  ownedAuctionsUpdates: OwnedAuctionUpdates[];
  biddenAuctionsUpdates: BiddenAuctionUpdates[];
};
