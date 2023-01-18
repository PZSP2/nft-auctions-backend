import { Auction, Bid, NFT, Tag, User } from "@prisma/client";

export type NFTWithTags = NFT & { tags: Tag[] };

export type BidWithBidder = Bid & { bidder: User };

export type NFTWithTagsAndIssuer = NFT & { tags: Tag[]; issuer: User };

export type NFTWithTagsAndIssuerAndOwner = NFT & {
  tags: Tag[];
  issuer: User;
  owner: User;
};
export type AuctionWithNFTAndBids = Auction & {
  nft: NFTWithTagsAndIssuerAndOwner;
  bids: BidWithBidder[];
};

export type AuctionWithNFTWithoutIssuerAndBids = Auction & {
  nft: NFTWithTagsAndIssuer;
  bids: BidWithBidder[];
};

export type AuctionWithBidderAndNFT = Auction & {
  nft: NFT;
  bids: (Bid & { bidder: User })[];
};

export type AuctionUpdates = {
  ownedAuctions: AuctionWithBidderAndNFT[];
  biddenAuctions: AuctionWithBidderAndNFT[];
};
