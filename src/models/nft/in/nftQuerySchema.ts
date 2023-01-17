import { Schema } from "express-validator";

export const nftIdSchema: Schema = {
  nftId: {
    in: "params",
    isInt: true,
    toInt: true,
    errorMessage: "Nft id must be integer",
  },
};

export const nftQuerySchema: Schema = {
  name: {
    in: "query",
    optional: true,
  },
  issuerId: {
    in: "query",
    optional: true,
    isInt: true,
    toInt: true,
    errorMessage: "Issuer id must be integer",
  },
  schoolId: {
    in: "query",
    optional: true,
    isInt: true,
    toInt: true,
    errorMessage: "School id must be integer",
  },
  ownerId: {
    in: "query",
    optional: true,
    isInt: true,
    toInt: true,
    errorMessage: "Owner id must be integer",
  },
  tagId: {
    in: "query",
    optional: true,
    isInt: true,
    toInt: true,
    errorMessage: "Tag id must be integer",
  },
};
