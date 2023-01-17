import express from "express";
import { NFTRouter } from "./routes/NFTRouter";
import { json } from "body-parser";
import { accountRouter } from "./routes/accountRouter";
import { auctionRouter } from "./routes/auctionRouter";
import XrpLedgerAdapter from "./ledger/XrpLedgerAdapter";
import morgan from "morgan";
import { authRouter } from "./routes/authRouter";
import session from "express-session";
import passport from "passport";
import { schoolRouter } from "./routes/schoolRouter";
import { onError } from "./middleware/errorMiddleware";
import { ScheduleUtils } from "./utils/scheduleUtils";
import { tagRouter } from "./routes/tagRouter";

const app = express();
const PORT = 3000;

app.use(
  session({
    secret: process.env.SERVER_SESSION_SECRET || "secret",
    resave: false,
    saveUninitialized: false,
    cookie: {
      maxAge: 1000 * 60 * 60 * 24 * 7, // 1 week
    },
  })
);

app.use(passport.initialize());
app.use(passport.session());

app.use(morgan("common"));
app.use(json());
app.use("/nft/", NFTRouter);
app.use("/account/", accountRouter);
app.use("/auction/", auctionRouter);
app.use("/auth/", authRouter);
app.use("/school/", schoolRouter);
app.use("/tag/", tagRouter);

app.use(onError);

app.listen(PORT, async () => {
  await XrpLedgerAdapter.getInstance().connectClient();
  console.log("Updating statuses");
  await ScheduleUtils.getInstance().updateStatuses();
  console.log(`Server is running on port ${PORT}`);
});
