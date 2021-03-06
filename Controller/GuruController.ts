import {Router,Response,Request,NextFunction} from "express"
import { GuruService } from "../Service"
import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import multer = require("multer");
import TeacherChecker from "../Middleware/TeacherChecker"
import path from "path"
const UPLOAD_PATH = 'public/uploads/cv';
const upload = multer({ storage:
      multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, UPLOAD_PATH)
      },

      filename: function (req, file, cb) {
        let ext = path.extname(file.originalname)
        let name= [req.context.idchild,req.context.iduser,req.context.posisi].join("")
        let filename =`${name}${ext}`
        cb(null, filename)
      },
    })
});
const router = Router()

router.use(TeacherChecker)

router.get("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    const data = await GuruService.profile(req.context.idchild)
    if (!data) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
})

router.post("/profile",upload.any(),async (req:Request, res :Response, next:NextFunction)=>{
  if (req.files[0]) req.body.file_cv = req.files[0].filename
  return next()
})

router.post("/profile",async (req:Request, res:Response,next:NextFunction)=>{
    req.body.idguru = req.context.idchild
    const data = await GuruService.setProfile(req.body)
    if (!data) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan atau email telah digunakan"))
    return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
})

export default router