import {Router,Response,Request,NextFunction} from "express"
import { WaliService } from "../Service"
import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";

const router = Router()


router.post("/register",async (req:Request, res :Response, next:NextFunction)=>{
    const data = await WaliService.register(req.body)
    
    if(data){
        return send(res,HTTPStatus.OK, {data :data,status:true,message:"Registrasi Berhasil silahkan Login"})
    }else{
       return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi Kesalahan"))
    }
})


router.get("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    const data = await WaliService.profile(req.context.email)
    if (data){
        return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
    }else{
        return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    }
})

router.post("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    
    const data = await WaliService.setProfile(req.body)
    if (data){
        return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
    }else{
        return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    }
})


export default router