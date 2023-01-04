import { Schema } from "express-validator";

export default interface AuctionBidDTO {
  readonly bidAmount: number;
}

export const auctionBidSchema: Schema = {
  auctionId: {
    in: "params",
    isInt: true,
    toInt: true,
  },
  bidAmount: {
    in: "body",
    isDecimal: {
      options: {
        decimal_digits: "0,2",
      },
      errorMessage: "Bid amount must be decimal",
    },
  },
};
