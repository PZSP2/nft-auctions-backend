import ResourceNotFoundError from "../errors/resourceNotFoundError";
import { Response, Request } from "express";
import NftAuctionServiceError from "../errors/NftAuctionServiceError";
import NotAuthorizedError from "../errors/notAuthorizedError";

export async function onError(
  err: Error,
  req: Request,
  res: Response,
  next: () => void
) {
  if (process.env.deploy == "test") console.error(err.stack);
  console.log(err);
  if (err instanceof ResourceNotFoundError) {
    res.status(404);
  } else if (err instanceof NotAuthorizedError) {
    res.status(401);
  } else if (
    err instanceof NftAuctionServiceError
  ) {
    res.status(400);
  } else {
    res.status(500).json({ message: "Internal server error" });
    return;
  }
  res.json({ message: err.message });
}
