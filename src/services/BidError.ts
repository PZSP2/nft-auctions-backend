export default class BidError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "BidError";
  }
}
