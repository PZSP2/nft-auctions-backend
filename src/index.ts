import express from "express";
import { NFTRouter } from "./routes/NFTRouter";
import { json } from "body-parser";
import { accountRouter } from "./routes/accountRouter";
import { auctionRouter } from "./routes/auctionRouter";
import XrpLedgerAdapter from "./ledger/XrpLedgerAdapter";
import morgan from "morgan";
import { BrokerService } from "./services/brokerService";

const app = express();
const PORT = 3000;

app.use(morgan("common"));
app.use(json());
app.use("/nft/", NFTRouter);
app.use("/account/", accountRouter);
app.use("/auction/", auctionRouter);
app.get("/test", (req, res) => {
  res.json(BrokerService.getInstance().getBookersOffers());
});
app.listen(PORT, async () => {
  await XrpLedgerAdapter.getInstance().connectClient();
  console.log(`Server is running on port ${PORT}`);
});
