import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import AccountService from "../services/accountService";
import AccountController from "../controller/accountController";
import { createAccountSchema } from "../models/account/createAccountDTO";
import {
  accountIdParams,
  balanceToAddParams,
} from "../models/account/accountIdParams";
import schemaValidator from "../middleware/schemaValidator";
import { protectedPath } from "../middleware/passportMiddleware";

const accountService = new AccountService(
  new PrismaClient(),
  XrpLedgerAdapter.getInstance()
);
const accountController = new AccountController(accountService);

export const accountRouter = Router();

accountRouter.get(
  "/me/updates",
  protectedPath,
  accountController.checkAuctionUpdates
);

accountRouter.post("/wallet", protectedPath, accountController.fundWallet);

accountRouter.get("/wallet", protectedPath, accountController.getWallet);

accountRouter.get(
  "/:accountId",
  schemaValidator({ schema: accountIdParams }),
  accountController.getAccount
);

accountRouter.post(
  "/",
  schemaValidator({ schema: createAccountSchema }),
  accountController.createAccount
);
accountRouter.put(
  "/funds",
  protectedPath,
  schemaValidator({ schema: balanceToAddParams }),
  accountController.addBalance
);
accountRouter.put("/", protectedPath, accountController.updateAccount);
