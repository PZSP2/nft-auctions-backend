import { prisma, PrismaClient } from "@prisma/client"
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter"
import CreateAccountDto from "../models/createAccountDTO"
import { Wallet } from "xrpl"

export default class AccountService {

    private prisma: PrismaClient
    private ledger: XrpLedgerAdapter

    constructor(prisma: PrismaClient, ledger: XrpLedgerAdapter) {
        this.prisma = prisma
        this.ledger = ledger
    }

    async getAccountByAccountId(accountId: number) {
        return await this.prisma.user.findFirst({
            where: {
                id: accountId
            }
        })
    }

    async createAccount(createAccountDTO: CreateAccountDto) {
        return await this.prisma.user.create({
            data: {
                email: createAccountDTO.email,
                password: createAccountDTO.password,
            }
        })
    }

    async fundAccountWallet(accountId: number) {
        const account = await this.getAccountByAccountId(accountId)
        this.ledger.fundWallet(null).then( async (wallet: Wallet | {
            wallet: Wallet
            balance: number
        }) => {
            console.log(wallet)
            if (wallet instanceof Wallet) {
                console.log("Updating wallet address - if")
                await this.prisma.user.update({
                    where: {
                        id: accountId
                    },
                    data: {
                        wallet_seed: wallet.seed,
                        wallet_address: wallet.address
                    },
                })
            } else {
                console.log("Updating wallet address - else")
                await this.prisma.user.update({
                    where: {
                        id: accountId
                    },
                    data: {
                        wallet_seed: wallet.wallet.seed,
                        wallet_address: wallet.wallet.address
                    },
                })
            }
        })
    }

    async checkAccountWalletStatus(accountId: number) {
        const user = await this.prisma.user.findFirst({
            where: {
                id: accountId
            }
        })
        console.log(user)
        if (user?.wallet_address != null) {
            return true
        }
        return false
    }
}