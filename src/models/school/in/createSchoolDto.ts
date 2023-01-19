import { Schema } from "express-validator";

export default interface CreateSchoolDto {
  readonly name: string;

  readonly phone: string;

  readonly email: string;

  readonly country: string;

  readonly city: string;

  readonly address: string;

  readonly photoUrl: string;
}

export const createSchoolSchema: Schema = {
  name: {
    in: "body",
    notEmpty: true,
  },
  email: {
    in: "body",
    notEmpty: true,
    isEmail: true,
    errorMessage: "Invalid email",
  },
  phone: {
    in: "body",
    isMobilePhone: true,
    errorMessage: "Invalid phone number",
  },
  country: {
    in: "body",
    notEmpty: true,
  },
  city: {
    in: "body",
    notEmpty: true,
  },
  address: {
    in: "body",
    notEmpty: true,
  },
    photoUrl: {
    in: "body",
    notEmpty: true,
    }
};

export const schoolIdSchema: Schema = {
  schoolId: {
    in: "params",
    isInt: true,
    toInt: true,
  },
};

export const getSchoolsSchema: Schema = {
  name: {
    in: "query",
    optional: true,
  },
};
