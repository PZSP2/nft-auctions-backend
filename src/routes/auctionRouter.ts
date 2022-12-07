import { PrismaClient } from '@prisma/client';
import { Router } from 'express';
import AuctionController from '../controller/auctionController';
import AuctionService from '../services/auctionService';


const auctionService = new AuctionService(new PrismaClient())
const auctionController = new AuctionController(auctionService)

export const auctionRouter = Router()

auctionRouter.get('/', auctionController.getAllAuctions)
auctionRouter.get('/:auctionId', auctionController.getAuctionByAuctionId)
auctionRouter.post('/', auctionController.createAuction)
auctionRouter.post('/bid', auctionController.bidOnAuction)
auctionRouter.put('/:auctionId/confirm', auctionController.confirmAuction)

