export default class IpfsUtils {
  static projectId = "2JEzLvIfHqPUucF61Ofnl9xvyyn";
  static projectSecret = "3c3df67ff3113d2558455d69d83af7ef";
  static auth =
    "Basic " +
    Buffer.from(this.projectId + ":" + this.projectSecret).toString("base64");

  static ipfsFileUpload = async (
    file: Express.Multer.File
  ): Promise<string | null> => {
    try {
      const IPFS = await import("ipfs-http-client");
      const client = IPFS.create({
        host: "ipfs.infura.io",
        port: 5001,
        protocol: "https",
        headers: {
          authorization: this.auth,
        },
      });
      const fileAdded = await client.add({
        content: file.buffer,
      });
      return fileAdded.cid.toString();
    } catch (e) {
      console.log("Error uploading file to IPFS: ", e);
      return null;
    }
  };

  static ipfsFileDownload = async (cid: string): Promise<Buffer | null> => {
    try {
      const IPFS = await import("ipfs-http-client");
      const client = IPFS.create({
        host: "ipfs.infura.io",
        port: 5001,
        protocol: "https",
        headers: {
          authorization: this.auth,
        },
      });
      // get whole image and convert it to base64
      const file = await client.cat(cid);
      let data = Buffer.from([]);
      for await (const chunk of file) {
        data = Buffer.concat([data, chunk]);
      }
      return data;
    } catch (e) {
      console.log(e);
      return null;
    }
  };
}
