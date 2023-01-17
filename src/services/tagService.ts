import { PrismaClient, Tag } from "@prisma/client";

export default class TagService {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  getAllTags = async (): Promise<Tag[]> => this.prisma.tag.findMany();
}
