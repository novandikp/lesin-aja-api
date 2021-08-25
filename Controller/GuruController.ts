import {Router,Response,Request,NextFunction} from "express"
import { GuruService } from "../Service"
import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import multer = require("multer");

const UPLOAD_PATH = 'public/uploads/cv';
const upload = multer({ dest: `${UPLOAD_PATH}/` });
const router = Router()

router.post("/register",upload.any(),async (req:Request, res :Response, next:NextFunction)=>{
    if (req.files) {
        req.body.file_cv = req.files[0].filename
        return next()
    }else{
        return next(new ErrorHandler(HTTPStatus.NOTACCEPT,"Harap Upload CV"))
    }
    
})

router.post("/register",async (req:Request, res :Response, next:NextFunction)=>{
    const data = await GuruService.register(req.body)
    if(data){
        return send(res,HTTPStatus.OK, {
            data :data,
            status:true,
            message:"Registrasi Berhasil silahkan Login"
        })
    }else{
       return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi Kesalahan"))
    }
})

router.get("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    const data = await GuruService.profile(req.context.email)
    if (data){
        return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
    }else{
        return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    }
})



export default router