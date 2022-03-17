import {Router,Response,Request,NextFunction} from "express"
import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import { addBayar } from "../Service/PembayaranService"
import path from "path"

const router = Router()
import multer = require("multer");

const UPLOAD_PATH = 'public/uploads/bukti';
const upload = multer({ storage:
    multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, UPLOAD_PATH)
      },

      filename: function (req, file, cb) {
        let ext = path.extname(file.originalname)
        let name= [req.context.iduser,req.context.posisi,new Date().getTime()].join("")
        let filename =`${name}${ext}`
        cb(null, filename)
      },
    })
});

router.post("/",upload.any(), async (req:Request,res:Response,next:NextFunction)=>{
  if (!req.files) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Harap Upload Bukti pembayaran"))
  req.body.bukti = req.files[0].filename
  return next()
})

router.post("/", async (req:Request,res:Response,next:NextFunction)=>{
    const dataBayar = await addBayar(req.body)\
    
    if (!dataBayar) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Terjadi kesalaham"))
    return send(res,HTTPStatus.OK,{status:true,data:dataBayar,message:"Berhasil"})
})

export default router