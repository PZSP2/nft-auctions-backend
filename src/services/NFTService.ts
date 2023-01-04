import { NFT, PrismaClient, User } from "@prisma/client";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import { convertStringToHex, NFTokenCreateOffer } from "xrpl";
import IpfsUtils from "../utils/ipfsUtils";
import NftCreateError from "../errors/nftCreateError";
import ResourceNotFoundError from "../errors/resourceNotFoundError";
import NotAuthorizedError from "../errors/notAuthorizedError";
import mintNftDto from "../models/nft/in/mintNftDto";

export default class NFTService {
  private ledger: XrpLedgerAdapter;
  private prisma: PrismaClient;

  constructor(ledger: XrpLedgerAdapter, prisma: PrismaClient) {
    this.ledger = ledger;
    this.prisma = prisma;
  }

  getNFTIssuedByAccount = async (accountID: number): Promise<NFT[]> =>
    this.prisma.nFT.findMany({
      where: {
        issuer_id: accountID,
      },
    });

  getAllNFTs = async (): Promise<(NFT & { issuer: User; owner: User })[]> =>
    this.prisma.nFT.findMany({
      include: {
        issuer: true,
        owner: true,
      },
    });

  getNFTById = async (
    nftId: number
  ): Promise<NFT & { issuer: User; owner: User }> => {
    const nft = await this.prisma.nFT.findFirst({
      where: {
        id: nftId,
      },
      include: {
        issuer: true,
        owner: true,
      },
    });
    if (nft == null)
      throw new ResourceNotFoundError("NFT with id " + nftId + " not found");
    return nft;
  };

  createNFT = async (
    nftInfo: mintNftDto,
    file: Express.Multer.File
  ): Promise<NFT & { issuer: User; owner: User }> => {
    const uri = await IpfsUtils.ipfsFileUpload(file);
    return this.prisma.nFT.create({
      data: {
        name: nftInfo.name,
        issuer_id: Number(nftInfo.accountId),
        uri: uri ?? "",
        description: nftInfo.description,
        owner_id: Number(nftInfo.accountId),
        is_image: file.mimetype.startsWith("image"),
      },
      include: {
        issuer: true,
        owner: true,
      },
    });
  };

  mintNFT = async (nftId: number): Promise<number> => {
    const nft = await this.getNFTById(nftId);
    if (nft == null) {
      throw new ResourceNotFoundError("NFT with id " + nftId + " not found");
    }
    const walletSeed = nft.issuer.wallet_seed;
    if (walletSeed == null)
      throw new NftCreateError("Wallet seed of issuer not found");
    const wallet = await this.ledger.getWallet(walletSeed);
    this.ledger
      .mintNFT(nft.uri, wallet)
      .then(async () => {
        console.log("Minting process completed");
        const nfts = await this.ledger.getAccountNFTsResponse(
          wallet.classicAddress
        );
        const newNft = nfts?.result?.account_nfts?.find(
          (accountNft) => accountNft.URI === convertStringToHex(nft.uri)
        );
        if (newNft != null) {
          await this.prisma.nFT.update({
            where: {
              id: nft.id,
            },
            data: {
              ledgerId: newNft.NFTokenID,
            },
          });
        } else {
          console.log("NFT not found");
        }
      })
      .catch(async (err: Error) => {
        console.log("Minting process failed - " + err);
        await this.prisma.nFT.delete({
          where: {
            id: nft.id,
          },
        });
      });
    return nftId;
  };

  async checkMintingProcess(nftID: number): Promise<boolean> {
    const nft = await this.prisma.nFT.findFirst({
      where: {
        id: nftID,
      },
    });
    return nft?.ledgerId != null;
  }

  transferNFT = async (
    nftId: number,
    accountId: number,
    destinationAddress: string
  ): Promise<boolean | Error> => {
    const nft = await this.prisma.nFT.findFirst({
      where: {
        id: nftId,
      },
      include: {
        owner: true,
      },
    });
    if (nft == null)
      throw new ResourceNotFoundError("NFT with id " + nftId + " not found");

    if (nft.issuer_id !== accountId)
      throw new NotAuthorizedError("Account is not the owner of the NFT");

    const walletSeed = nft.owner.wallet_seed;
    if (!walletSeed || !nft.ledgerId) return false;
    const wallet = await this.ledger.getWallet(walletSeed);
    const offer: NFTokenCreateOffer = {
      Amount: "0",
      TransactionType: "NFTokenCreateOffer",
      Account: wallet.classicAddress,
      Destination: destinationAddress,
      NFTokenID: nft.ledgerId,
    };

    const result = await this.ledger.createSellOffer(offer, wallet);

    if (result.result.validated) {
      await this.prisma.nFT.update({
        where: {
          id: nft.id,
        },
        data: {
          owner_id: accountId,
        },
      });
    }
    return result.result.validated ?? false;
  };

  async ifNftExist(uri: string) {
    return (
      (await this.prisma.nFT.findFirst({
        where: {
          uri: uri,
        },
      })) != null
    );
  }
}
