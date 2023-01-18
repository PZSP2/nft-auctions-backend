import { Schema } from "express-validator";

export const accountIdParams: Schema = {
  accountId: {
    in: "params",
    isInt: true,
    toInt: true,
  },
};

export const balanceToAddParams: Schema = {
  balanceToAdd: {
    in: "body",
    isDecimal: true,
  },
};
