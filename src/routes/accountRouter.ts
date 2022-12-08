import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import AccountService from "../services/accountService";
import AccountController from "../controller/accountController";

const accountService = new AccountService(
  new PrismaClient(),
  XrpLedgerAdapter.getInstance()
);
const accountController = new AccountController(accountService);

export const accountRouter = Router();

accountRouter.post("/:accountId/wallet", accountController.fundWallet);

accountRouter.get("/:accountId", accountController.getAccount);

accountRouter.post("/", accountController.createAccount);

accountRouter.put("/:accountId", accountController.updateAccount);

accountRouter.get(
  "/:accountId/wallet",
  accountController.checkWalletStatus
);

accountRouter.get("/:accountId/offers", accountController.getOffers);
accountRouter.get("/brokerOffers", accountController.getBrokerOffers);
