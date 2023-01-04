import { Router } from "express";
import NFTController from "../controller/NFTController";
import NFTService from "../services/NFTService";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import { PrismaClient } from "@prisma/client";
import { createNftSchema } from "../models/nft/in/createNftDto";
import { protectedPath } from "../middleware/passportMiddleware";
import { nftIdSchema } from "../models/nft/in/mintNftDto";
import schemaValidator from "../middleware/schemaValidator";

export const NFTRouter = Router();

const ledger = XrpLedgerAdapter.getInstance();
const service = new NFTService(ledger, new PrismaClient());
const controller = new NFTController(service);

NFTRouter.post(
  "/",
  protectedPath,
  controller.uploadFile,
  schemaValidator({ schema: createNftSchema }),
  controller.uploadNft
);
NFTRouter.get("/", controller.getAllNfts);
NFTRouter.get(
  "/:nftId",
  schemaValidator({ schema: nftIdSchema }),
  controller.getNFTById
);
NFTRouter.post(
  "/:nftId/mint",
  protectedPath,
  schemaValidator({ schema: nftIdSchema }),
  controller.mintNFT
);
NFTRouter.get(
  "/:nftId/mint",
  protectedPath,
  schemaValidator({ schema: nftIdSchema }),
  controller.getNFTMintStatus
);
