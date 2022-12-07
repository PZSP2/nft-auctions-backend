import {NFT, PrismaClient} from '@prisma/client'
import NFTMintDTO from '../models/nftMintDTO'
import XrpLedgerAdapter from '../ledger/XrpLedgerAdapter'
import {convertStringToHex} from "xrpl";
export default class NFTService {
    private ledger: XrpLedgerAdapter
    private prisma: PrismaClient

    constructor(ledger: XrpLedgerAdapter, prisma: PrismaClient) {
        this.ledger = ledger
        this.prisma = prisma
    }

    async getNFTIssuedByAccount(accountID: number): Promise<NFT[]> {
        return this.prisma.nFT.findMany({
            where: {
                issuer_id: accountID
            }
        })
    }

    async getAllNFTs(): Promise<NFT[]> {
        return this.prisma.nFT.findMany()
    }

    async getNFTById(nftId: number): Promise<NFT | null> {
        return this.prisma.nFT.findFirst({
            where: {
                id: nftId
            }
        });
    }

    // TODO refactor
    async mintNFT(nftInfo: NFTMintDTO): Promise<NFT | null> {
        const walletDB = await this.prisma.user.findFirst({
                where: {
                    id: nftInfo.accountId
                }
            }
        )
        if (walletDB?.wallet_seed == null) return null
        const wallet = await this.ledger.getWallet(walletDB?.wallet_seed)
        const nft = await this.prisma.nFT.create({
            data: {
                name: nftInfo.name,
                issuer_id: nftInfo.accountId,
                uri: nftInfo.uri,
            }
        })
        this.ledger.mintNFT(nftInfo, wallet).then(async () => {
            console.log('Minting process completed')
            const nfts = await this.ledger.getAccountNFTsResponse(wallet.classicAddress)
            const newNft = nfts?.result?.account_nfts?.find(nft => nft.URI === convertStringToHex(nftInfo.uri))
            if (newNft != null) {
                await this.prisma.nFT.update({
                    where: {
                        id: nft.id
                    },
                    data: {
                        ledgerId: newNft.NFTokenID
                    }
                })
            } else {
                console.log('NFT not found')
            }
        }).catch(async (err: Error) => {
            console.log('Minting process failed - ' + err)
            await this.prisma.nFT.delete({
                where: {
                    id: nft.id
                }
            })
        })
        return nft
    }

    async checkMintingProcess(nftID: number): Promise<boolean> {
        console.log(nftID)
        const nft = await this.prisma.nFT.findFirst({
            where: {
                id: nftID
            }
        })
        return nft?.ledgerId != null
    }
}
