import { PrismaClient } from "@prisma/client"
import NFTMintDTO from "../models/nftMintDto"
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter"
import { TransactionMetadata, TxResponse } from "xrpl"

export default class NFTService {
    private ledger: XrpLedgerAdapter
    private prisma: PrismaClient
    
    constructor(ledger: XrpLedgerAdapter, prisma: PrismaClient) {
        this.ledger = ledger
        this.prisma = prisma
    }

    async getNFTIssuedByAccount(accountID: number) {
        const nfts = this.prisma.nFT.findMany({
            where: {
                issuer_id: accountID
            }
        })
        return nfts
    }

    async getAllNFTs() {
        const nfts = this.prisma.nFT.findMany()
        return nfts
    }

    async getNFTById(nftId: number) {
        const nft = this.prisma.nFT.findFirst({
            where: {
                id: nftId
            }
        })
        return nft
    }

    async mintNFT(nftInfo: NFTMintDTO) {
        const walletDB = await this.prisma.user.findFirst({
            where: {
                id: nftInfo.accountId
            }
        }
    )   
        if (walletDB?.wallet_seed == null) return 
        const wallet = await this.ledger.getWallet(walletDB?.wallet_seed)
        const nftID = await this.prisma.nFT.create({
            data: {
                name: nftInfo.name,
                issuer_id: nftInfo.accountId,
                uri: nftInfo.uri,
            }
        })
        this.ledger.mintNFT(nftInfo, wallet).then(async (response: TxResponse) => {
            console.log("Minting process completed")
            await this.prisma.nFT.update({
                where: {
                    id: nftID.id
                },
                data: {
                    minted: true
                }
            })
        }).catch(async (err: any) => {
            console.log("Minting process failed - " + err)
            await this.prisma.nFT.delete({
                where: {
                    id: nftID.id
                }
            })
        })
    }

    async checkMintingProcess(nftID: number) {
        console.log(nftID)
        const nft = await this.prisma.nFT.findFirst({
            where: {
                id: nftID
            }
        })
        return nft?.minted
    }
}