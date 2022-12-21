import NFTItem from "../models/nft/NFTItem";
import { NFT } from "@prisma/client";
import IpfsUtils from "./ipfsUtils";

export default class NftUtils {
  static mapNftToNftResponse = async (nft: NFT): Promise<NFTItem> => {
    const image = await IpfsUtils.ipfsFileDownload(nft.uri);
    return {
      id: nft.id,
      name: nft.name,
      image: image != null ? image.toString("base64") : "",
      description: nft.description,
      issuerId: nft.issuer_id,
    };
  };
}
