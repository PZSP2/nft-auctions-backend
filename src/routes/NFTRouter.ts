import { Router } from 'express'
import NFTController from '../controller/NFTController'
import NFTService from '../services/NFTService'
import XrpLedgerAdapter from '../ledger/XrpLedgerAdapter'
import { PrismaClient } from '@prisma/client'

export const NFTRouter = Router()

const ledger = XrpLedgerAdapter.getInstance()
const service = new NFTService(ledger, new PrismaClient())
const controller = new NFTController(service)

NFTRouter.get('/', controller.getAllNfts)
NFTRouter.post('/mint', controller.mintNFT)
NFTRouter.get('/mintStatus/:nftId', controller.getNFTMintStatus)