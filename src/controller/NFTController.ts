import { Request, Response } from 'express'
import NFTService from '../services/NFTService'
// TODO Add validation and error handling etc

export default class NFTController {
    service: NFTService
    constructor(service: NFTService) {
        this.service = service
    }

    mintNFT = async (req: Request, res: Response): Promise<void> => {
        const nftInfo = req.body
        const nft = await this.service.mintNFT(nftInfo)
        res.status(200).json(nft)
    }

    getAllNfts = async (req: Request, res: Response): Promise<void> => {
        const nfts = await this.service.getAllNFTs()
        res.status(200).json(nfts)
    }

    getNFTById = async (req: Request, res: Response): Promise<void> => {
        const nftId = Number(req.params.nftId)
        const nft = await this.service.getNFTById(nftId)
        if (nft != null) {
            res.status(200).json(nft)
        } else {
            res.status(404).json({message: 'NFT not found'})
        }
    }

    getNFTMintStatus = async (req: Request, res: Response): Promise<void> => {   
        const result = await this.service.checkMintingProcess(Number(req.params.nftId))
        if (result != null) {
            res.status(200).json({'isMinted': result})
        } else {
            res.status(404).json({message: 'No nft found with this id'})
        }
    }
}
