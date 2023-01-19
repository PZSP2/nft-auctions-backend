import { Schema } from "express-validator";

export default interface createNftDto {
  readonly accountId: number;

  readonly name: string;

  readonly description: string;

  readonly tags: number[];
}

export const createNftSchema: Schema = {
  name: {
    in: "body",
    notEmpty: true,
    errorMessage: "name is required",
  },
  description: {
    in: "body",
    notEmpty: true,
    errorMessage: "description is required",
  },
  file: {
    custom: {
      options: (value, { req }) => req.file != null,
      errorMessage: "file is required",
    },
  },
  tags: {
    in: "body",
    isArray: true,
    optional: true,
    toArray: true,
    errorMessage: "tagsIds must be an array",
  },
};
