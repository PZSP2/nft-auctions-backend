export default interface AuctionOffers {
    auctionId: number
    buyOfferId: string | number
    sellOfferId: string | number
    bidderId: number
    sellerId: number
    bidAmount: number
}