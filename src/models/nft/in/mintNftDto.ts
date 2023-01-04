import { Schema } from "express-validator";

export default interface mintNftDto {
  readonly accountId: number;

  readonly name: string;

  readonly description: string;

  readonly uri: string;
}

export const nftIdSchema: Schema = {
  nftId: {
    in: "params",
    isInt: true,
    toInt: true,
  },
};
