import {Router,Response,Request,NextFunction} from "express"
import { GuruService } from "../Service"
import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import multer = require("multer");
import TeacherChecker from "../Middleware/TeacherChecker"
import AuthValidation from "../Validation/AuthValidation"
import ValidationHandler from "../Util/ValidationHandler"

const UPLOAD_PATH = 'public/uploads/cv';
const upload = multer({ storage:
      multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, UPLOAD_PATH)
      },

      filename: function (req, file, cb) {
        cb(null, file.originalname)
      },
    })
});
const router = Router()

router.post("/register",upload.any(),async (req:Request, res :Response, next:NextFunction)=>{
    if (!req.files) return next(new ErrorHandler(HTTPStatus.NOTACCEPT,"Harap Upload CV"))
    req.body.file_cv = req.files[0].filename
    return next()
})

router.post("/register",AuthValidation(),ValidationHandler,async (req:Request, res :Response, next:NextFunction)=>{
    const data = await GuruService.register(req.body)
    if(!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi Kesalahan"))
    return send(res,HTTPStatus.OK, {
         data :data,
         status:true,
         message:"Registrasi Berhasil silahkan Login"
    })
})

router.use(TeacherChecker)

router.get("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    const data = await GuruService.profile(req.context.email)
    if (!data) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
})

router.post("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    const data = await GuruService.setProfile(req.body)
    if (!data) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
})



export default router