import SchoolService from "../services/schoolService";
import { Request, Response } from "express";
import MapperUtils from "../utils/mapperUtils";
import { Prisma } from "@prisma/client";
import UniqueConstraintError from "../errors/uniqueConstraintError";

export default class SchoolController {
  private readonly schoolService: SchoolService;

  constructor(schoolService: SchoolService) {
    this.schoolService = schoolService;
  }

  getSchoolById = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    this.schoolService
      .getSchoolById(Number(req.params.schoolId))
      .then((school) =>
        res.status(200).json(MapperUtils.mapSchoolToSchoolResponse(school))
      )
      .catch((err) => next(err));
  };

  getAllSchools = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    this.schoolService
      .getAllSchools()
      .then((schools) =>
        res
          .status(200)
          .json(
            schools.map((school) =>
              MapperUtils.mapSchoolToSchoolResponse(school)
            )
          )
      )
      .catch((err) => next(err));
  };

  createSchool = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    this.schoolService
      .createSchool(req.body)
      .then((school) =>
        res.status(201).json(MapperUtils.mapSchoolToSchoolResponse(school))
      )
      .catch((err) => {
        if (err instanceof Prisma.PrismaClientKnownRequestError) {
          if (err.code === "P2002") {
            next(new UniqueConstraintError("Email already exists"));
          }
        } else {
          next(err);
        }
      });
  };

  updateSchool = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    this.schoolService
      .updateSchool(Number(req.params.schoolId), req.body)
      .then((school) =>
        res.status(200).json(MapperUtils.mapSchoolToSchoolResponse(school))
      )
      .catch((err) => next(err));
  };
}
