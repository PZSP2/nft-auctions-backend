import passport from "passport";
import { PrismaClient } from "@prisma/client";
import { Strategy as LocalStrategy } from "passport-local";
import AuthUtils from "../utils/AuthUtils";
import { Request, Response } from "express";
import NotAuthorizedError from "../errors/notAuthorizedError";

const prisma = new PrismaClient();

passport.use(
  new LocalStrategy(async function (username, password, done) {
    const user = await prisma.user.findFirst({
      where: {
        email: username,
        password: await AuthUtils.hashPassword(password),
      },
    });
    if (user) {
      return done(null, user);
    } else {
      return done(null, false, { message: "Incorrect username or password." });
    }
  })
);

export function protectedPath(req: Request, res: Response, next: () => void) {
  if (req.isUnauthenticated()) {
    throw new NotAuthorizedError("You must be logged in to make this request");
  } else {
    next();
  }
}
