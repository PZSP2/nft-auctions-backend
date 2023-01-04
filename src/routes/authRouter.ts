import { PrismaClient, User } from "@prisma/client";
import passport from "passport";
import { Strategy as LocalStrategy } from "passport-local";
import { Router } from "express";
import { compare } from "bcryptjs";
import MapperUtils from "../utils/mapperUtils";

const prisma = new PrismaClient();

export const authRouter = Router();

passport.use(
  new LocalStrategy(async function (email, password, done) {
    const user = await prisma.user.findFirst({
      where: {
        email: email,
      },
    });
    if (!user) {
      return done(null, null, {
        message: "Couldn't find user with this email",
      });
    }
    if (await compare(password, user.password)) {
      return done(null, user);
    } else {
      return done(null, false, { message: "Incorrect username or password." });
    }
  })
);

passport.deserializeUser(async (id: string, done) => {
  try {
    const user = await prisma.user.findFirstOrThrow({
      where: {
        id: Number(id),
      },
    });
    done(null, user);
  } catch (error) {
    done(error);
  }
});

passport.serializeUser((user, done) => {
  done(null, (user as User).id);
});

authRouter.post("/login/", passport.authenticate("local"), (req, res) => {
  res.json(MapperUtils.mapUserToMinimalUserResponse(req.user as User));
});
