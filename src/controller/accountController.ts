import CreateAccountDto from "../models/account/createAccountDTO";
import AccountService from "../services/accountService";
import { Request, Response } from "express";
import MapperUtils from "../utils/mapperUtils";
import { Prisma, User } from "@prisma/client";
import UniqueConstraintError from "../errors/uniqueConstraintError";

export default class AccountController {
  private service: AccountService;

  constructor(service: AccountService) {
    this.service = service;
  }

  createAccount = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const createAccountDTO: CreateAccountDto = req.body;
    this.service
      .createAccount(createAccountDTO)
      .then((account) => {
        req.login(account, () =>
          res.status(201).json({id: account.id, email: account.email, username: account.name})
        );
      })
      .catch((err) => {
        if (err instanceof Prisma.PrismaClientKnownRequestError) {
          if (err.code === "P2002") {
            next(new UniqueConstraintError("Email already exists"));
          }
        } else {
          next(err);
        }
      });
  };

  fundWallet = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const accountId = (req.user as User).id;
    this.service
      .fundAccountWallet(accountId, this.service.onWalletFunded)
      .then((wallet) => res.status(200).json(wallet))
      .catch((err) => next(err));
  };

  updateAccount = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const accountId = (req.user as User).id;
    const account = req.body;
    this.service
      .updateAccount(accountId, account)
      .then(() => res.status(200))
      .catch((err) => next(err));
  };

  getAccount = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const accountId = req.params.accountId as unknown as number;
    this.service
      .getAccountByAccountId(accountId)
      .then((account) =>
        res.status(200).json(MapperUtils.mapUserToAccountResponse(account))
      )
      .catch((err) => next(err));
  };
  getWallet = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const accountId = (req.user as User).id;
    this.service
      .getAccountBalance(accountId)
      .then((balance) =>
        res.status(200).json({
          walleAddress: balance.walletAddress,
          balance: balance.balance,
        })
      )
      .catch((err) => next(err));
  };

  checkAuctionUpdates = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const accountId = (req.user as User).id;
    this.service
      .checkAuctionsUpdate(accountId)
      .then((auctions) =>
        res.status(200).json(MapperUtils.mapAuctionUpdates(auctions, accountId))
      )
      .catch((err) => next(err));
  };

  addBalance = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    const accountId = (req.user as User).id;
    const balanceToAdd = req.body.balanceToAdd as number;
    this.service
      .addToBalance(accountId, balanceToAdd)
      .then((balance) => res.status(200).json(balance))
      .catch((err) => next(err));
  };
}
