import { Request, Response } from "express";
import NFTService from "../services/NFTService";
import multer, { FileFilterCallback } from "multer";
import NftUtils from "../utils/nftUtils";
// TODO Add validation and error handling etc

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
      callback(new Error("Not an image! Please upload only images."));
    }
  };

  private upload = multer({
    storage: this.multerStorage,
    fileFilter: this.multerFilter,
  });

  uploadFile = this.upload.single("file");

  uploadNft = async (req: Request, res: Response): Promise<void> => {
    if (req.file == null) {
      res.status(400).send("File is null");
    } else {
      const nftInfo = req.body;
      const nftResult = await this.service.createNFT(nftInfo, req.file);
      res.json(nftResult);
    }
  };
  mintNFT = async (req: Request, res: Response): Promise<void> => {
    const id = Number(req.params.nftId);
    const nft = await this.service.mintNFT(id);
    if (nft == null) {
      res.status(404).send("NFT not found");
    } else {
      res.status(200).json({ id: nft });
    }
  };

  getAllNfts = async (req: Request, res: Response): Promise<void> => {
    const nfts = await this.service.getAllNFTs();
    // map nfts to NFTItem
    const nftItems = await Promise.all(
      nfts.map(async (nft) => {
        return await NftUtils.mapNftToNftResponse(nft);
      })
    );
    res.status(200).json(nftItems);
  };

  getNFTById = async (req: Request, res: Response): Promise<void> => {
    const nftId = Number(req.params.nftId);
    const nft = await this.service.getNFTById(nftId);
    if (nft != null) {
      // map to NFTItem
      res.status(200).json(await NftUtils.mapNftToNftResponse(nft));
    } else {
      res.status(404).json({ message: "NFT not found" });
    }
  };

  getNFTMintStatus = async (req: Request, res: Response): Promise<void> => {
    const result = await this.service.checkMintingProcess(
      Number(req.params.nftId)
    );
    if (result != null) {
      res.status(200).json({ isMinted: result });
    } else {
      res.status(404).json({ message: "No nft found with this id" });
    }
  };
}
