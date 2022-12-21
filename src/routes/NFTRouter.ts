import { Router } from "express";
import NFTController from "../controller/NFTController";
import NFTService from "../services/NFTService";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import { PrismaClient } from "@prisma/client";

export const NFTRouter = Router();

const ledger = XrpLedgerAdapter.getInstance();
const service = new NFTService(ledger, new PrismaClient());
const controller = new NFTController(service);

NFTRouter.post("/", controller.uploadFile, controller.uploadNft);
NFTRouter.get("/", controller.getAllNfts);
NFTRouter.get("/:nftId", controller.getNFTById);
NFTRouter.post("/:nftId/mint", controller.mintNFT);
NFTRouter.get("/:nftId/mint", controller.getNFTMintStatus);
