import CreateAccountDto from "../models/createAccountDTO"
import AccountService from "../services/accountService"
import { Request, Response } from "express"
// TODO Add validation and error handling etc

export default class AccountController {
    private service: AccountService

    constructor (service: AccountService) {
        this.service = service
    }

    createAccount = async (req: Request, res: Response) => {
        const createAccountDTO: CreateAccountDto = req.body
        console.log(createAccountDTO)
        
        if (createAccountDTO != null) {
            const account = await this.service.createAccount(createAccountDTO)
            res.status(200).json(account)
        } else {
            res.status(400).json("Bad request")
        }
    }

    fundWallet = async (req: Request, res: Response) => {
        const accountId: number = req.body.accountId
        if (accountId != null) {
            const wallet = await this.service.fundAccountWallet(accountId)
            res.status(200).json(wallet)
        } else {
            res.status(400).json({message: "No account id provided"})
        }
    }

    checkWalletStatus = async (req: Request, res: Response) => {
        const accountId: number = Number(req.params.accountId)
        if (accountId != null) {
            const wallet = await this.service.checkAccountWalletStatus(accountId)
            res.status(200).json(wallet)
        } else {
            res.status(400).json({message: "No account id provided"})
        }
    }

}