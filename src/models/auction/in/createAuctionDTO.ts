import { Schema } from "express-validator";

export interface CreateAuctionDTO {
  readonly nftId: number;
  readonly startTime: Date;
  readonly endTime: Date;
  readonly minimalPrice: number;
  readonly schoolId: number;
}

export const createAuctionSchema: Schema = {
  nftId: {
    in: "body",
    isInt: true,
    toInt: true,
  },
  startTime: {
    in: "body",
    isISO8601: true,
    toDate: true,
  },
  endTime: {
    in: "body",
    isISO8601: true,
    toDate: true,
  },
  minimalPrice: {
    in: "body",
    isDecimal: {
      options: {
        decimal_digits: "0,2",
      },
      errorMessage: "Minimal price must be decimal",
    },
    toFloat: true,
  },
  schoolId: {
    in: "body",
    isInt: true,
    toInt: true,
  },
};

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
  isActive: {
    in: "query",
    optional: true,
    isBoolean: true,
    toBoolean: true,
    errorMessage: "isActive must be a boolean",
  },
  nftId: {
    in: "query",
    optional: true,
    isInt: true,
    toInt: true,
    errorMessage: "nftId must be an integer",
  },
};
