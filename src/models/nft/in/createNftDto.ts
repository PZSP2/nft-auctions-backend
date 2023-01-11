import { Schema } from "express-validator";

export default interface CreateNftDto {
  readonly accountId: number;

  readonly name: number;

  readonly description: string;
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
};
