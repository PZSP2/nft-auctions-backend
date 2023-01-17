import { Router } from "express";
import SchoolService from "../services/schoolService";
import { PrismaClient } from "@prisma/client";
import SchoolController from "../controller/schoolController";
import { protectedPath } from "../middleware/passportMiddleware";
import schemaValidator from "../middleware/schemaValidator";
import {
  createSchoolSchema,
  schoolIdSchema,
} from "../models/school/in/createSchoolDto";

export const schoolRouter = Router();

const schoolController = new SchoolController(
  new SchoolService(new PrismaClient())
);

schoolRouter.get("/", schoolController.getAllSchools);

schoolRouter.get("/:schoolId", schoolController.getSchoolById);

schoolRouter.post(
  "/",
  protectedPath,
  schemaValidator({ schema: createSchoolSchema }),
  schoolController.createSchool
);

schoolRouter.put(
  "/:schoolId",
  protectedPath,
  schemaValidator({ schema: schoolIdSchema }),
  schoolController.updateSchool
);
