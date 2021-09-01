import {Router,Response,Request,NextFunction} from "express"
import { PembayaranService, WaliService } from "../Service"
import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import WaliChecker from "../Middleware/WaliChecker"
import { addBayar } from "../Service/PembayaranService"

const router = Router()


router.post("/", async (req:Request,res:Response,next:NextFunction)=>{


})