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
