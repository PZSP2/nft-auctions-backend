import { NFT, PrismaClient } from "@prisma/client";
import NFTMintDTO from "../models/nft/nftMintDTO";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import { convertStringToHex } from "xrpl";
import IpfsUtils from "../utils/ipfsUtils";

export default class NFTService {
  private ledger: XrpLedgerAdapter;
  private prisma: PrismaClient;

  constructor(ledger: XrpLedgerAdapter, prisma: PrismaClient) {
    this.ledger = ledger;
    this.prisma = prisma;
  }

  async getNFTIssuedByAccount(accountID: number): Promise<NFT[]> {
    return this.prisma.nFT.findMany({
      where: {
        issuer_id: accountID,
      },
    });
  }

  async getAllNFTs(): Promise<NFT[]> {
    // map nfts to NFTItem
    return await this.prisma.nFT.findMany({
      include: {
        issuer: true,
      },
    });
  }

  async getNFTById(nftId: number): Promise<NFT | null> {
    const nft = await this.prisma.nFT.findFirst({
      where: {
        id: nftId,
      },
    });
    if (nft == null) {
      return null;
    }
    return nft;
  }

  async createNFT(
    nftInfo: NFTMintDTO,
    file: Express.Multer.File
  ): Promise<NFT> {
    const uri = await IpfsUtils.ipfsFileUpload(file);
    if (uri != null) {
      nftInfo.uri = uri;
    }
    return this.prisma.nFT.create({
      data: {
        name: nftInfo.name,
        issuer_id: Number(nftInfo.accountId),
        uri: nftInfo.uri,
        description: nftInfo.description,
      },
    });
  }

  // TODO refactor
  async mintNFT(nftId: number): Promise<number | null> {
    const nft = await this.prisma.nFT.findFirst({
      where: {
        id: nftId,
      },
      include: {
        issuer: true,
      },
    });
    if (nft == null) {
      return null;
    }

    const walletSeed = nft.issuer.wallet_seed;
    if (walletSeed == null) return null;
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
  }

  async checkMintingProcess(nftID: number): Promise<boolean> {
    console.log(nftID);
    const nft = await this.prisma.nFT.findFirst({
      where: {
        id: nftID,
      },
    });
    return nft?.ledgerId != null;
  }
}
