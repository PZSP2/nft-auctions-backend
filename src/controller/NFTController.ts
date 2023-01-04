import { Request, Response } from "express";
import NFTService from "../services/NFTService";
import multer, { FileFilterCallback } from "multer";
import MapperUtils from "../utils/mapperUtils";
import mintNftDto from "../models/nft/in/mintNftDto";
import IpfsUtils from "../utils/ipfsUtils";
import NftCreateError from "../errors/nftCreateError";
import { User } from "@prisma/client";

export default class NFTController {
  service: NFTService;

  constructor(service: NFTService) {
    this.service = service;
  }

  private multerStorage = multer.memoryStorage();

  private multerFilter = (
    req: Request,
    file: Express.Multer.File,
    callback: FileFilterCallback
  ): void => {
    if (file.mimetype.startsWith("image")) {
      callback(null, true);
    } else {
      callback(new NftCreateError("Not an image! Please upload only images."));
    }
  };

  private upload = multer({
    storage: this.multerStorage,
    fileFilter: this.multerFilter,
  });

  uploadFile = this.upload.single("file");

  uploadNft = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    if (req.file == null) {
      next(new NftCreateError("Error uploading file"));
      return;
    } else {
      const uri = await IpfsUtils.ipfsFileUpload(req.file);
      if (uri == null) {
        next(new NftCreateError("Error uploading file to IPFS"));
        return;
      }
      if (await this.service.ifNftExist(uri)) {
        next(new NftCreateError("NFT already exists"));
        return;
      }
      const nftInfo: mintNftDto = {
        accountId: (req.user as User).id,
        description: req.body.description,
        name: req.body.name,
        uri: uri,
      };
      this.service
        .createNFT(nftInfo, req.file)
        .then((nft) =>
          res.status(201).json(MapperUtils.mapNftToNftResponse(nft))
        )
        .catch((err) => next(err));
    }
  };

  mintNFT = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const id = Number(req.params.nftId);
    this.service
      .mintNFT(id)
      .then((nftId) => res.status(200).json({ nftId: nftId }))
      .catch((err) => next(err));
  };

  getAllNfts = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    this.service
      .getAllNFTs()
      .then((nfts) => {
        res.status(200).json({
          nfts: nfts.map((nft) => MapperUtils.mapNftToNftResponse(nft)),
        });
      })
      .catch((err) => next(err));
  };

  getNFTById = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const nftId = Number(req.params.nftId);
    this.service
      .getNFTById(nftId)
      .then((nft) => res.status(200).json(MapperUtils.mapNftToNftResponse(nft)))
      .catch((err) => next(err));
  };

  getNFTMintStatus = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    await this.service
      .checkMintingProcess(Number(req.params.nftId))
      .then((isMinted) => res.status(200).json({ isMinted: isMinted }))
      .catch((err) => next(err));
  };
}
