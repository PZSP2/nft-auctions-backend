import { Schema } from "express-validator";

export default interface accountIdParams {
  readonly accountId: number;
}

export const accountIdParams: Schema = {
  accountId: {
    in: "params",
    isInt: true,
    toInt: true,
  },
};
