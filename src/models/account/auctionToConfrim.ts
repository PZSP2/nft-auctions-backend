export default interface AuctionToConfirm {
  readonly auctionId: number;
  readonly nftId: number;

  readonly nftName: string;

  readonly finalPrice?: number;
}
