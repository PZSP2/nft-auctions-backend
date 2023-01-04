import { Schema } from "express-validator";
import { Role } from "@prisma/client";

export default interface CreateAccountDto {
  readonly email: string;
  readonly password: string;

  readonly name: string;

  readonly role: Role;
}

export const createAccountSchema: Schema = {
  email: {
    in: "body",
    notEmpty: true,
    isEmail: true,
    errorMessage: "Invalid email",
  },
  password: {
    in: "body",
    isLength: {
      errorMessage: "Password length too short",
      options: { min: 7 },
    },
  },
  name: {
    in: "body",
    notEmpty: true,
  },
  role: {
    in: "body",
    matches: {
      options: [/\b(?:ADMIN|NORMAL_USER|SCHOOL)\b/],
      errorMessage: "Invalid role",
    },
    customSanitizer: {
      options: (value, { req }) => {
        return Role[req.body.role as keyof typeof Role];
      },
    },
  },
};
