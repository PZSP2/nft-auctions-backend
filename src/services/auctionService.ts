import { PrismaClient } from "@prisma/client"

export default class AuctionService {
    private prisma: PrismaClient

    constructor(prisma: PrismaClient) {
        this.prisma = prisma
    }


    async getAuctionByNFTId(nftId: number) {
        const auction = await this.prisma.auction.findFirst({
            where: {
                nft_id: nftId
            }
        })
        return auction
    }

    async getAuctionByAuctionId(auctionId: number) {
        const auction = await this.prisma.auction.findFirst({
            where: {
                id: auctionId
            }
        })
        return auction
    }

    async getAllAuctions() {
        const auctions = await this.prisma.auction.findMany()
        return auctions
    }
}