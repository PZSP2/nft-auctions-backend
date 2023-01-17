import TagService from "../services/tagService";
import MapperUtils from "../utils/mapperUtils";
import { Request, Response } from "express";

export default class TagController {
  private readonly service: TagService;

  constructor(tagService: TagService) {
    this.service = tagService;
  }

  getAllTags = async (
    req: Request,
    res: Response,
    next: (err: Error) => void
  ): Promise<void> => {
    this.service
      .getAllTags()
      .then((tags) => {
        res
          .status(200)
          .json(tags.map((tag) => MapperUtils.mapTagToTagResponse(tag)));
      })
      .catch((err) => next(err));
  };
}
