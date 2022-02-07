import { Router } from "express"
import AdminChecker from "../../Middleware/AdminChecker";
import GuruController  from "./GuruController"
import WaliController from "./WaliController";

const router:Router = Router();
router.use(AdminChecker)
router.use("/guru",GuruController);
router.use("/wali",WaliController);

export default router;