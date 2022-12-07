import {NFT, PrismaClient, User} from '@prisma/client'
import XrpLedgerAdapter from '../ledger/XrpLedgerAdapter'
import CreateAccountDto from '../models/createAccountDTO'
import {AccountNFTsResponse, Wallet} from 'xrpl'

export default class AccountService {

    private prisma: PrismaClient
    private ledger: XrpLedgerAdapter

    constructor(prisma: PrismaClient, ledger: XrpLedgerAdapter) {
        this.prisma = prisma
        this.ledger = ledger
    }

    async getAccountByAccountId(accountId: number): Promise<User | null> {
        return await this.prisma.user.findFirst({
            where: {
                id: accountId
            }
        })
    }

    async createAccount(createAccountDTO: CreateAccountDto): Promise<User> {
        return await this.prisma.user.create({
            data: {
                email: createAccountDTO.email,
                password: createAccountDTO.password,
            }
        })
    }

    async fundAccountWallet(accountId: number): Promise<void> {
        this.ledger.fundWallet(null).then( async (wallet: Wallet | {
            wallet: Wallet
            balance: number
        }) => {
            console.log(wallet)
            if (wallet instanceof Wallet) {
                console.log('Updating wallet address - Wallet instance')
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
                console.log('Updating wallet address - Wallet with balance')
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

    async checkAccountWalletStatus(accountId: number): Promise<boolean> {
        const user = await this.prisma.user.findFirst({
            where: {
                id: accountId
            }
        })
        return user?.wallet_address != null;
    }

    async getAccountNFTs(accountId: number): Promise<NFT[]> {
        return await this.prisma.nFT.findMany({
            where: {
                issuer_id: accountId
            },
            include: {
                issuer: true
            }
        })
    }

    async updateAccount(accountId: number | null, account: CreateAccountDto): Promise<User | null> {
        if (accountId == null) return null
        const user = await this.prisma.user.findFirst({
            where: {
                id: accountId
            }
        })
        if (user == null) return null
        return await this.prisma.user.update({
            where: {
                id: accountId
            },
            data: {
                email: account.email,
                password: account.password
            }
        })
    }

    async getAccountOffers(accountId: number): Promise<AccountNFTsResponse | null> {
        const user = await this.prisma.user.findFirst({
            where: {
                id: accountId
            }
        })
        if (user?.wallet_address == null) return null
        return await this.ledger.getOffersByAccount(user.wallet_address)
    }
}
