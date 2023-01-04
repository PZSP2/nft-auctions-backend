import { Request, Response } from "express";
import { checkSchema, Schema, validationResult } from "express-validator";

export default function (options: { schema: Schema }) {
  return async function (req: Request, res: Response, next: () => void) {
    await checkSchema(options.schema).run(req);
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ message: errors.array() });
    }
    next();
  };
}
