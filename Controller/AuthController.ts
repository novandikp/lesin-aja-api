import {Router,Response,Request,NextFunction} from "express"
import { AuthService } from "../Service"
import { HTTPStatus } from "../Util/HTTPStatus";
import { send } from "../Util/GlobalResponse";
import { ErrorHandler } from "../Util/ErrorHandler";

const router = Router()

router.post("/login",async (req:Request,res:Response, next:NextFunction)=>{    
    const data = await AuthService.login(req.body)
    if(data){
        return send(res,HTTPStatus.OK, {data :data,message:"Login Berhasil"})
    }else{
       return next(new ErrorHandler(HTTPStatus.NOTFOUND,"User dan password tidak ditemukan"))
    }
})

router.post("/change_password",async (req:Request,res:Response, next:NextFunction)=>{
    const data = await AuthService.changePassword(req.body)
    if(data){
        return send(res,HTTPStatus.OK, {data :data,status:true,message:"Password berhasil diganti"})
    }else{
       return next(new ErrorHandler(HTTPStatus.NOTFOUND,"User dan password tidak ditemukan"))
    }
})

export default router