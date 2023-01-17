import { PrismaClient } from "@prisma/client";
import TagService from "../services/tagService";
import TagController from "../controller/tagController";
import { Router } from "express";

const tagService = new TagService(new PrismaClient());
const tagController = new TagController(tagService);

export const tagRouter = Router();

tagRouter.get("/", tagController.getAllTags);
