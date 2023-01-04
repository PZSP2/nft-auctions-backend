import { hash } from "bcryptjs";

export default class AuthUtils {
  static hashPassword = async (password: string): Promise<string> =>
    await hash(password, 10);
}
