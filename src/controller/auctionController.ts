import AuctionService from "../services/auctionService";
import { Request, Response } from "express";
import MapperUtils from "../utils/mapperUtils";
import { User } from "@prisma/client";
import AuctionBidDTO from "../models/auction/in/auctionBidDTO";
export default class AuctionController {
  private readonly service: AuctionService;

  constructor(auctionService: AuctionService) {
    this.service = auctionService;
  }

  getAuctionByAuctionId = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const auctionId = Number(req.params.auctionId);
    this.service
      .getAuctionByAuctionId(auctionId)
      .then((auction) =>
        res.status(200).json(MapperUtils.mapAuctionToAuctionResponse(auction))
      )
      .catch((err) => next(err));
  };

  getAllAuctions = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    this.service
      .getAllAuctions(
        req.query.schoolId as unknown as number,
        req.query.isActivated as unknown as boolean,
        req.query.nftId as unknown as number
      )
      .then((auctions) =>
        res.status(200).json({
          auctions: auctions.map((auction) =>
            MapperUtils.mapAuctionToAuctionResponse(auction)
          ),
        })
      )
      .catch((err) => next(err));
  };

  bidOnAuction = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const auctionBid: AuctionBidDTO = req.body;
    const auctionId = Number(req.params.auctionId);
    this.service
      .bidOnAuction(auctionId, (req.user as User).id, auctionBid)
      .then((bid) => res.status(200).json(MapperUtils.mapBidToBidResponse(bid)))
      .catch((err) => next(err));
  };

  createAuction = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const createAuctionDTO = req.body;
    const accountId = (req.user as User).id;
    this.service
      .createAuction(createAuctionDTO, accountId)
      .then((auction) =>
        res
          .status(201)
          .json(MapperUtils.mapAuctionToMinimalAuctionResponse(auction))
      )
      .catch((err) => next(err));
  };

  confirmAuction = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const auctionId = Number(req.params.auctionId);
    const accountId = (req.user as User).id;
    this.service
      .confirmAuction(auctionId, accountId)
      .then((auction) => res.status(200).json({ auctionId: auction.id }))
      .catch((err) => next(err));
  };
}
