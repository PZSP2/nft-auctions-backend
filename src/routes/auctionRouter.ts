import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import AuctionController from "../controller/auctionController";
import AuctionService from "../services/auctionService";
import { protectedPath } from "../middleware/passportMiddleware";
import { createAuctionSchema } from "../models/auction/in/createAuctionDTO";
import schemaValidator from "../middleware/schemaValidator";
import { auctionBidSchema } from "../models/auction/in/auctionBidDTO";
import {
  auctionIdSchema,
  getAllAuctionsSchema,
} from "../models/auction/in/auctionQuerySchema";

const auctionService = new AuctionService(new PrismaClient());
const auctionController = new AuctionController(auctionService);

export const auctionRouter = Router();

auctionRouter.get(
  "/",
  schemaValidator({ schema: getAllAuctionsSchema }),
  auctionController.getAllAuctions
);
auctionRouter.get(
  "/:auctionId",
  schemaValidator({ schema: auctionIdSchema }),
  auctionController.getAuctionByAuctionId
);
auctionRouter.post(
  "/",
  protectedPath,
  schemaValidator({ schema: createAuctionSchema }),
  auctionController.createAuction
);
auctionRouter.post(
  "/:auctionId/bid",
  protectedPath,
  schemaValidator({ schema: auctionBidSchema }),
  auctionController.bidOnAuction
);
auctionRouter.put(
  "/:auctionId/confirm",
  protectedPath,
  schemaValidator({ schema: auctionIdSchema }),
  auctionController.confirmAuction
);
