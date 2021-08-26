import {Router,Response,Request,NextFunction} from "express"
import { WaliService } from "../Service"
import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import WaliChecker from "../Middleware/WaliChecker"

const router = Router()
router.use(WaliChecker)

router.get("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    const data = await WaliService.profile(req.context.idchild)
    if (!data) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
})
router.post("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    req.body.idwali = req.context.idchild
    const data = await WaliService.setProfile(req.body)
    if (!data) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
})


export default router