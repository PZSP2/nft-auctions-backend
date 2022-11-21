import { Client, TransactionMetadata, TxResponse, Wallet } from "xrpl"
import FinalizedAuctionDto from "../models/acceptOfferDto"
import XrpLedgerAdapter from "../ledger/XrpLedgerAdapter"

class BrokerService {
    private brokerWallet: Wallet
    private ledgerAdapter: XrpLedgerAdapter
    
    constructor(ledgerAdapter: XrpLedgerAdapter, brokerWallet: Wallet) {
        this.ledgerAdapter = ledgerAdapter
        this.brokerWallet = brokerWallet
    }

    async getBookersOffers(nftID: string) {
        return this.ledgerAdapter.getNftOffersByNftId(nftID)   
    }

    async finalizeAuction(finalizedAuction: FinalizedAuctionDto) {
        const response: TxResponse = await this.ledgerAdapter.acceptNftOffer(finalizedAuction, this.brokerWallet)
        if ((response.result.meta as TransactionMetadata).TransactionResult === "tesSUCCESS") {
            return true
        }
        return false
    }

}