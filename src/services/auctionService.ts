import {Auction, Bid, NFT, PrismaClient} from '@prisma/client'
import AuctionBidDTO from '../models/auctionBidDTO';
import {CreateAuctionDTO} from '../models/createAuctionDTO';
import {BrokerService} from "./brokerService";
import { addMinutes } from 'date-fns';

export default class AuctionService {
    private readonly prisma: PrismaClient

    constructor(prisma: PrismaClient) {
        this.prisma = prisma
    }
    getAuctionByAuctionId = async (auctionId: number): Promise<Auction & { bids: Bid[]; nft: NFT; } | null> => await this.prisma.auction.findFirst({
        where: {
            id: auctionId
        },
        include: {
            bids: true,
            nft: true,
        }
    })

    getAllAuctions = async (nftId: number | null, isActive: boolean | null): Promise<(Auction & { bids: Bid[]; nft: NFT; })[]> => await this.prisma.auction.findMany(
        {
            where: {
                end_time: {
                    gt: isActive != null ? new Date() : undefined
                },
                nft_id: nftId != null ? nftId : undefined
            },
            include: {
                nft: true,
                bids: true
            }
        }
    );

    getHighestBid = (auctionId: number): Promise<Bid | null> => this.prisma.bid.findFirst({
        where: {
            auction_id: auctionId
        },
        orderBy: {
            bid_price: 'desc'
        },
        include: {
            bidder: true
        }
    })

    private checkIfAuctionIsActive = async (auction: Auction | null): Promise<boolean> => {
        if (auction == null) return true
        const now = new Date()
        return now < auction.end_time
    }

    // TODO refactor this shit
    bidOnAuction = async (auctionBid: AuctionBidDTO): Promise<Bid | null> => {
        const auction = await this.getAuctionByAuctionId(auctionBid.auctionId)
        const highestBid = (await this.getHighestBid(auctionBid.auctionId))?.bid_price ?? auction?.minimal_price ?? 0
        if (await this.checkIfAuctionIsActive(auction) && auctionBid.bidAmount > highestBid) {
            const newBid = await this.prisma.bid.create({
                data: {
                    auction_id: auctionBid.auctionId,
                    bidder_id: auctionBid.bidderId,
                    bid_price: auctionBid.bidAmount
                }
            })
            await this.prisma.auction.update({
                where: {
                    id: auctionBid.auctionId
                },
                data: {
                    end_time: new Date(addMinutes(new Date(), 5))
                }
            })
            return newBid
        } else {
            return null
        }
    }

    createAuction = async (createAuctionDTO: CreateAuctionDTO): Promise<Auction> => await this.prisma.auction.create({
        data: {
            nft_id: createAuctionDTO.nftId,
            minimal_price: createAuctionDTO.minimalPrice,
            start_time: createAuctionDTO.startTime,
            end_time: createAuctionDTO.endTime
        }
    })

    confirmAuction = async (auctionId: number): Promise<Auction | null> => {
        const auction = await this.getAuctionByAuctionId(auctionId)
        if (auction == null) return null
        if (await this.checkIfAuctionIsActive(auction)) {
            return null
        }
        const highestBid = await this.getHighestBid(auctionId)
        if (highestBid == null) {
            return null
        }
        const nftToken = auction.nft.ledgerId ?? ''
        const buyer = highestBid.bidder_id
        const seller = auction.nft.issuer_id
        const price = highestBid.bid_price

        const offers = await BrokerService.getInstance().createAuctionOffers(
            auctionId,
            nftToken,
            price,
            buyer,
            seller
        )
        await BrokerService.getInstance().finalizeAuction(offers)
        return auction
    }
}
