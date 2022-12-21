import AuctionService from "../services/auctionService";
import { Request, Response } from "express";
import BidError from "../services/BidError";
import NftUtils from "../utils/nftUtils";
export default class AuctionController {
  private readonly service: AuctionService;

  constructor(auctionService: AuctionService) {
    this.service = auctionService;
  }

  getAuctionByAuctionId = async (
    req: Request,
    res: Response
  ): Promise<void> => {
    const auctionId = Number(req.params.auctionId);
    const auction = await this.service.getAuctionByAuctionId(auctionId);
    if (auction != null) {
      res.status(200).json({
        ...auction,
        nft: await NftUtils.mapNftToNftResponse(auction.nft),
      });
    } else {
      res.status(404).json({ message: "Auction not found" });
    }
  };

  getAllAuctions = async (req: Request, res: Response): Promise<void> => {
    const auctions = await this.service.getAllAuctions(
      Number(req.query.nftId) || null,
      req.query.isActive == "true"
    );
    const mappedAuctions = await Promise.all(
      auctions.map(async (auction) => {
        return {
          ...auction,
          nft: await NftUtils.mapNftToNftResponse(auction.nft),
        };
      })
    );
    res.status(200).json(mappedAuctions);
  };

  bidOnAuction = async (req: Request, res: Response): Promise<void> => {
    const auctionBid = req.body;
    const auctionId = Number(req.params.auctionId);
    const bid = await this.service.bidOnAuction(auctionId, auctionBid);
    // if bid is error return 400 else return 200
    if (bid instanceof BidError) {
      res.status(400).json({ message: bid.message });
    } else {
      res.status(200).json(bid);
    }
  };

  createAuction = async (req: Request, res: Response): Promise<void> => {
    const auction = req.body;
    const createdAuction = await this.service.createAuction(auction);

    res.status(200).json(createdAuction);
  };

  confirmAuction = async (req: Request, res: Response): Promise<void> => {
    const auctionId = Number(req.params.auctionId);
    const auction = await this.service.confirmAuction(auctionId);
    if (auction != null) {
      res.status(200).json(auction);
    } else {
      res.status(400).json({ message: "Auction not found" });
    }
  };
}
