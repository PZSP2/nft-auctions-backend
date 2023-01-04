export default interface CreateOfferDto {
  readonly accountAddress: string;
  readonly nftLedgerId: string;

  readonly amount: number;

  readonly otherAddress: string;

  readonly flags: number;
}
