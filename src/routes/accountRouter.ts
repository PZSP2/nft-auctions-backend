import { PrismaClient } from "@prisma/client"
import { Router } from "express"
import { Request, Response } from "express"
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter"
import CreateAccountDto from "../models/createAccountDTO"
import AccountService from "../services/accountService"
import AccountController from "../controller/accountController"

const accountService = new AccountService(new PrismaClient(), XrpLedgerAdapter.getInstance())
const accountController = new AccountController(accountService)


export const accountRouter = Router()

accountRouter.post('/fundWallet', accountController.fundWallet)


accountRouter.post('/create', accountController.createAccount)


accountRouter.get("/checkWalletStatus/:accountId", accountController.checkWalletStatus)
