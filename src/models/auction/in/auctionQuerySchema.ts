import { Schema } from "express-validator";

export const auctionIdSchema: Schema = {
  auctionId: {
    in: "params",
  },
};

export const getAllAuctionsSchema: Schema = {
  schoolId: {
    in: "query",
    optional: true,
    isInt: true,
    toInt: true,
    errorMessage: "School id must be integer",
  },
  nftId: {
    in: "query",
    isInt: true,
    optional: true,
    errorMessage: "Nft id must be integer",
    toInt: true,
  },
  issuerId: {
    in: "query",
    optional: true,
    isInt: true,
    errorMessage: "Issuer id must be integer",
    toInt: true,
  },
  status: {
    in: "query",
    optional: true,
    isString: true,
    toUpperCase: true,
    isIn: {
      options: [["ACTIVE", "EXPIRED", "WON", "CALL_FOR_CONFIRM", "CONFIRMED"]],
    },
    errorMessage:
      "State must be any of the following: ACTIVE, EXPIRED, WON, CALL_FOR_CONFIRM, CONFIRMED",
  },
  nftTagId: {
    in: "query",
    optional: true,
    isInt: true,
    toInt: true,
    errorMessage: "Nft tag id must be integer",
  },
};
