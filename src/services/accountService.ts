import {
  Auction,
  Bid,
  NFT,
  PrismaClient,
  Role,
  School,
  Status,
  Tag,
  User,
} from "@prisma/client";
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter";
import CreateAccountDto from "../models/account/createAccountDTO";
import { Wallet } from "xrpl";
import AuthUtils from "../utils/AuthUtils";
import ResourceNotFoundError from "../errors/resourceNotFoundError";
import WalletError from "../errors/WalletError";
import {
  AuctionUpdates,
  NFTWithTags,
  NFTWithTagsAndIssuer,
} from "../models/types";


export default class AccountService {
  private prisma: PrismaClient;
  private ledger: XrpLedgerAdapter;

  constructor(prisma: PrismaClient, ledger: XrpLedgerAdapter) {
    this.prisma = prisma;
    this.ledger = ledger;
  }


  getAccountByAccountId = async (
    accountId: number
  ): Promise<
    User & {
      owned_nft: (NFTWithTags & {auctions: Auction[] })[];
      bid: (Bid & { auction: Auction & { nft: NFTWithTagsAndIssuer } })[];
    }
  > => {
    const account = await this.prisma.user.findFirst({
      include: {
        owned_nft: {
          include: {
            tags: true,
            auctions: {
              take: 1,
                where: {
                    status: {
                      in: [Status.ACTIVE, Status.CALL_FOR_CONFIRM, Status.WON],
                    }
                }
            }
          },
        },
        bid: {
          include: {
            auction: {
              include: {
                nft: {
                  include: {
                    tags: true,
                    issuer: true,
                  },
                },
              },
            },
          },
        },
      },
      where: {
        id: accountId,
      },
    });
    if (account == null)
      throw new ResourceNotFoundError(
        "Account with id " + accountId + " not found"
      );
    return account;
  };

  createAccount = async (createAccountDTO: CreateAccountDto): Promise<User> =>
    this.prisma.user.create({
      data: {
        account_type: Role[createAccountDTO.role as keyof typeof Role],
        email: createAccountDTO.email,
        name: createAccountDTO.name,
        password: await AuthUtils.hashPassword(createAccountDTO.password),
        balance: 1000,
      },
    });

  fundAccountWallet = async (
    accountId: number,
    onWalletFunded: (accountId: number, wallet: Wallet) => void
  ): Promise<void> => {
    const account = await this.getAccountByAccountId(accountId);
    if (account.wallet_address != null)
      throw new WalletError("Account already has a wallet");
    this.ledger
      .fundWallet(null)
      .then(async (wallet: Wallet | { wallet: Wallet; balance: number }) => {
        onWalletFunded(
          accountId,
          wallet instanceof Wallet ? wallet : wallet.wallet
        );
      });
  };
  getAccountNFTs = async (
    accountId: number
  ): Promise<(NFT & { issuer: User })[]> =>
    this.prisma.nFT.findMany({
      where: {
        issuer_id: accountId,
      },
      include: {
        issuer: true,
      },
    });

  updateAccount = async (
    accountId: number,
    account: CreateAccountDto
  ): Promise<
    User & {
      owned_nft: (NFT & { tags: Tag[] })[];
      bid: (Bid & { auction: Auction & { nft: NFT } })[];
    }
  > =>
    await this.prisma.user.update({
      where: {
        id: accountId,
      },
      data: {
        email: account.email,
        password: account.password,
      },
      include: {
        owned_nft: {
          include: {
            tags: true,
          },
        },
        bid: {
          include: {
            auction: {
              include: {
                nft: true,
              },
            },
          },
        },
      },
    });

  getAccountBids = async (
    accountId: number
  ): Promise<(Bid & { auction: Auction & { nft: NFT; school: School } })[]> => {
    return this.prisma.bid.findMany({
      where: {
        bidder_id: accountId,
      },
      include: {
        auction: {
          include: {
            nft: true,
            school: true,
          },
        },
      },
    });
  };

  onWalletFunded = async (accountId: number, wallet: Wallet) => {
    console.log("Wallet funded: " + wallet.address + " User id: " + accountId);
    const walletAddress = wallet.address;
    const walletSeed = wallet.seed;
    await this.prisma.user.update({
      where: {
        id: accountId,
      },
      data: {
        wallet_seed: walletSeed,
        wallet_address: walletAddress,
      },
    });
  };

  checkAuctionsUpdate = async (userId: number): Promise<AuctionUpdates> => {
    const ownedAuctionUpdates = await this.prisma.auction.findMany({
      where: {
        status: {
          in: [Status.WON],
        },
        nft: {
          issuer: {
            id: userId,
          },
        },
      },
      include: {
        nft: true,
        bids: {
          include: {
            bidder: true,
          },
        },
      },
    });
    const biddenAuctions = await this.prisma.auction.findMany({
      where: {
        status: Status.ACTIVE,
        bids: {
          some: {
            bidder_id: userId,
          },
        },
      },
      include: {
        nft: true,
        bids: {
          include: {
            bidder: true,
          },
        },
      },
    });
    return {
      ownedAuctions: ownedAuctionUpdates,
      biddenAuctions: biddenAuctions,
    };
  };

  getAccountBalance = async (
    accountId: number
  ): Promise<{ walletAddress: string; balance: number }> => {
    const user = await this.prisma.user.findFirst({
      where: {
        id: accountId,
      },
    });
    if (user?.wallet_address == null)
      throw new ResourceNotFoundError("Wallet not yet funded");
    return {
      walletAddress: user.wallet_address,
      balance: user.balance.toNumber(),
    };
  };

  addToBalance = async (
    accountId: number,
    balanceToAdd: number
  ): Promise<{ walletAddress: string; balance: number }> => {
    const account = await this.prisma.user.findFirst({
      select: {
        balance: true,
        wallet_address: true,
      },
      where: {
        id: accountId,
      },
    });
    if (account == null) {
      throw new ResourceNotFoundError(
        "Account with id " + accountId + " not found."
      );
    }
    if (account.wallet_address == null) {
      throw new WalletError("Wallet not yet funded");
    }
    const updatedBalance = await this.prisma.user.update({
      select: {
        balance: true,
      },
      where: {
        id: accountId,
      },
      data: {
        balance: balanceToAdd + account.balance.toNumber(),
      },
    });

    return {
      walletAddress: account.wallet_address,
      balance: updatedBalance.balance.toNumber(),
    };
  };
}
