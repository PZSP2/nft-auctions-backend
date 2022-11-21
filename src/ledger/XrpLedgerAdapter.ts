import { NFTokenCreateOffer, Client, Wallet, NFTokenMint, TxResponse, NFTokenAcceptOffer } from "xrpl"
import SellOfferInfoModel from "../models/sellOfferInfoModel"
import BuyOfferInfoModel from "../models/buyOfferInfoModel"
import NFTMintDTO from "../models/nftMintDto"
import AcceptOfferDTO from "../models/acceptOfferDto"
import { time } from "console"

enum NetType {
    MainNet = "wss://s1.ripple.com/",
    TestNet = "wss://s.altnet.rippletest.net/",
    DevNet = "wss://s.devnet.rippletest.net/"
}

export default class XrpLedgerAdapter {
    private static instance: XrpLedgerAdapter 
    client: Client

    private static defaultNetType: NetType = NetType.TestNet

    private constructor(netType: NetType) {
        this.client = new Client(netType)
    }

    public static getInstance(): XrpLedgerAdapter {
        if (!XrpLedgerAdapter.instance) {
            XrpLedgerAdapter.instance = new XrpLedgerAdapter(this.defaultNetType)
        }
        return XrpLedgerAdapter.instance
    }


    async connectClient() {
        console.log(this.client.isConnected())
        if (!this.client.isConnected()) {
            console.log(Date.now().toString())
            console.log("Connecting to client on net: " + XrpLedgerAdapter.defaultNetType)
            await this.client.connect()
        }
    }

    async disconnectClient() {
        if (this.client.isConnected()) {
            console.log("Disconnecting client")
            await this.client.disconnect()
        }
    }

    getWallet(seed: string): Wallet {
        console.log("Retrieving wallet")
        return Wallet.fromSeed(seed)
    }

    async createSellOffer(sellOffer: SellOfferInfoModel): Promise<TxResponse> {
        const offer: NFTokenCreateOffer = {
            "Account": sellOffer.accountAddress,
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID":  sellOffer.nftTokenId,
            "Amount": sellOffer.amount.toString(),
            "Destination": sellOffer.destinationAddress,
            "Flags": sellOffer.flags,
        } 
        return await this.client.submitAndWait(offer)
    }
    
    async createBuyOffer(buyOffer: BuyOfferInfoModel): Promise<TxResponse> {
        const offer: NFTokenCreateOffer = {
            "Account": buyOffer.accountAddress,
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID":  buyOffer.nftTokenId,
            "Amount": buyOffer.amount.toString(),
            "Destination": buyOffer.destinationAddress,
            "Flags": buyOffer.flags,
        } 
        return await this.client.submitAndWait(offer)
    }

    async mintNFT(nftInfo: NFTMintDTO, wallet: Wallet): Promise<TxResponse> {
        const mintTransaction: NFTokenMint = {
            "TransactionType": "NFTokenMint",
            "Account": wallet.classicAddress,
            "URI": nftInfo.uri,
            "Flags": nftInfo.flags,
            "NFTokenTaxon": 0
        }
        return await this.client.submitAndWait(mintTransaction, {wallet: wallet})
    }

    async getNftOffersByNftId(nftId: string) {
        return await this.client.request({
            "command": "nft_buy_offers",
            "id": nftId
        }).catch((err) => { 
            console.log(err)
            return null
        })
    }

    // TODO - refactor this 
    async acceptNftOffer(offer: AcceptOfferDTO, wallet: Wallet): Promise<TxResponse> {
        const transactionBlob: NFTokenAcceptOffer = {
            "TransactionType": "NFTokenAcceptOffer",
            "Account": offer.brokerAddress,
            "NFTokenSellOffer": offer.ownerSellOfferID,
            "NFTokenBuyOffer": offer.winningBuyOfferID,
            "NFTokenBrokerFee": offer.brokerFee.toString(),
        }
        return await this.client.submitAndWait(transactionBlob, {wallet: wallet})
    } 

    async fundWallet(seed: string | null) {
        console.log("Funding wallet")
         if (seed != null) {
            return Wallet.fromSeed(seed) 
        } else {
            console.log("Funding a new wallet")
            return await this.client.fundWallet()
        } 
    }
}

