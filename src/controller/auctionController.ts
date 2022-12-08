import AuctionService from "../services/auctionService";
import { Request, Response } from "express";
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
      res.status(200).json(auction);
    } else {
      res.status(404).json({ message: "Auction not found" });
    }
  };

  getAllAuctions = async (req: Request, res: Response): Promise<void> => {
    const auctions = await this.service.getAllAuctions(
      Number(req.query.nftId) || null,
      Boolean(req.query.isActive)
    );
    res.status(200).json(auctions);
  };

  bidOnAuction = async (req: Request, res: Response): Promise<void> => {
    const auctionBid = req.body;
    const bid = await this.service.bidOnAuction(auctionBid);
    res.status(200).json(bid);
  };

  createAuction = async (req: Request, res: Response): Promise<void> => {
    const auction = req.body;
    const createdAuction = await this.service.createAuction(auction);
    res.status(200).json(createdAuction);
  };

  confirmAuction = async (req: Request, res: Response): Promise<void> => {
    const auctionId = Number(req.params.auctionId);
    const auction = await this.service.confirmAuction(auctionId);
    res.status(200).json(auction);
  };
}
