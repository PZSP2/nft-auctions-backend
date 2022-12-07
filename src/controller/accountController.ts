import CreateAccountDto from '../models/createAccountDTO'
import AccountService from '../services/accountService'
import {Request, Response} from 'express'
import {BrokerService} from "../services/brokerService";
// TODO Add validation and error handling etc

export default class AccountController {
    private service: AccountService

    constructor(service: AccountService) {
        this.service = service
    }

    createAccount = async (req: Request, res: Response): Promise<void> => {
        const createAccountDTO: CreateAccountDto = req.body

        if (createAccountDTO != null) {
            const account = await this.service.createAccount(createAccountDTO)
            res.status(200).json(account)
        } else {
            res.status(400).json('Bad request')
        }
    }

    fundWallet = async (req: Request, res: Response): Promise<void> => {
        const accountId: number = req.body.accountId
        if (accountId != null) {
            const wallet = await this.service.fundAccountWallet(accountId)
            res.status(200).json(wallet)
        } else {
            res.status(400).json({message: 'No account id provided'})
        }
    }

    checkWalletStatus = async (req: Request, res: Response): Promise<void> => {
        const accountId = Number(req.params.accountId)
        if (accountId != null) {
            const wallet = await this.service.checkAccountWalletStatus(accountId)
            res.status(200).json(wallet)
        } else {
            res.status(404).json({message: `No account with id ${accountId} found`})
        }
    }

    getNftsByAccountId = async (req: Request, res: Response): Promise<void> => {
        const accountId = Number(req.params.accountId)
        if (accountId != null) {
            const nfts = await this.service.getAccountNFTs(accountId)
            res.status(200).json(nfts)
        } else {
            res.status(404).json({message: `No account with id ${accountId} found`})
        }
    }
    updateAccount = async (req: Request, res: Response): Promise<void> => {
        const accountId = Number(req.params.accountId)
        const account = req.body
        const updatedAccount = this.service.updateAccount(accountId, account)
        if (updatedAccount != null) {
            res.status(200).json(updatedAccount)
        } else {
            res.status(404).json({message: `No account with id ${accountId} found`})
        }
    }

    getAccount = async (req: Request, res: Response): Promise<void> => {
        const accountId = Number(req.params.accountId)
        const account = await this.service.getAccountByAccountId(accountId)
        if (account != null) {
            res.status(200).json(account)
        } else {
            res.status(404).json({message: `No account with id ${accountId} found`})
        }
    }

    getOffers = async (req: Request, res: Response): Promise<void> => {
        const accountId = Number(req.params.accountId)
        const offers = await this.service.getAccountOffers(accountId)
        if (offers != null) {
            res.status(200).json(offers)
        } else {
            res.status(404).json({message: `No account with id ${accountId} found`})
        }
    }

    getBrokerOffers = async (req: Request, res: Response): Promise<void> => {
        const offers = await BrokerService.getInstance().getBookersOffers()
        if (offers != null) {
            res.status(200).json(offers)
        }
    }

}
