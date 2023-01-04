import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import AccountService from "../services/accountService";
import AccountController from "../controller/accountController";
import { createAccountSchema } from "../models/account/createAccountDTO";
import { accountIdParams } from "../models/account/accountIdParams";
import schemaValidator from "../middleware/schemaValidator";
import { protectedPath } from "../middleware/passportMiddleware";

const accountService = new AccountService(
  new PrismaClient(),
  XrpLedgerAdapter.getInstance()
);
const accountController = new AccountController(accountService);

export const accountRouter = Router();

accountRouter.post(
  "/:accountId/wallet",
  protectedPath,
  schemaValidator({ schema: accountIdParams }),
  accountController.fundWallet
);

accountRouter.get(
  "/:accountId/wallet",
  protectedPath,
  schemaValidator({ schema: accountIdParams }),
  accountController.getWallet
);

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

accountRouter.put("/", protectedPath, accountController.updateAccount);
