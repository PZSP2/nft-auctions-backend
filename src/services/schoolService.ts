import { PrismaClient, School } from "@prisma/client";
import CreateSchoolDto from "../models/school/createSchoolDto";
import ResourceNotFoundError from "../errors/resourceNotFoundError";

export default class SchoolService {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  getSchoolById = async (schoolId: number): Promise<School> => {
    const school = await this.prisma.school.findFirst({
      where: {
        id: schoolId,
      },
      include: {
        auctions: {
          include: {
            nft: true,
            bids: true,
          },
        },
      },
    });
    if (school == null)
      throw new ResourceNotFoundError(
        "School with id " + schoolId + " not found"
      );
    return school;
  };

  getAllSchools = async (): Promise<School[]> =>
    await this.prisma.school.findMany({
      include: {
        auctions: {
          include: {
            nft: true,
            bids: true,
          },
        },
      },
    });

  createSchool = async (schoolDto: CreateSchoolDto): Promise<School> =>
    await this.prisma.school.create({
      data: {
        name: schoolDto.name,
        address: schoolDto.address,
        country: schoolDto.country,
        city: schoolDto.city,
        phone: schoolDto.phone,
        email: schoolDto.email,
      },
    });

  updateSchool = async (
    schoolId: number,
    schoolDto: CreateSchoolDto
  ): Promise<School> =>
    await this.prisma.school.update({
      where: {
        id: schoolId,
      },
      data: {
        name: schoolDto.name,
        address: schoolDto.address,
        country: schoolDto.country,
        city: schoolDto.city,
        phone: schoolDto.phone,
        email: schoolDto.email,
      },
    });
}
