import  path from 'path';
import { Router,Request ,Response,NextFunction } from "express";
import AdminChecker from "../../Middleware/AdminChecker";
import { getGuru, getPembayaran, getRekapMengajar } from "../../Service/GuruService";
import { ErrorHandler } from "../../Util/ErrorHandler";
import { send } from "../../Util/GlobalResponse";
import { HTTPStatus } from "../../Util/HTTPStatus";

const router:Router = Router();

//Halaman Guru

router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
    const data = await getGuru(req.query)
    if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
    return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.get("/rekap", async (req:Request,res:Response,next:NextFunction)=>{
    const data = await getRekapMengajar(req.query)
    if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
    return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})



router.get("/pembayaran",async(req:Request,res:Response,next:NextFunction)=>{
    const data = await getPembayaran(req.query)
    if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
    return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


import multer = require("multer");
import { pembayaranTutor } from '../../Service/BayarTutorService';
const UPLOAD_PATH = 'public/uploads/buktibayar';
const upload = multer({ storage:
    multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, UPLOAD_PATH)
      },
      filename: function (req, file, cb) {
        let ext = path.extname(file.originalname)
        let name= [req.context.iduser,req.body.iguru,req.body.idles,new Date().getTime()].join("")
        let filename =`${name}${ext}`
        cb(null, filename)
      },
    })
});

router.post("/bayar",upload.any(), async (req:Request,res:Response,next:NextFunction)=>{
    
    
    if (!req.files) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Harap Upload Bukti pembayaran"))
    req.body.bukti = req.files[0].filename
    return next()
  })
  
router.post("/bayar", async (req:Request,res:Response,next:NextFunction)=>{
    const data= await  pembayaranTutor(req.body)
    if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
    return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

export default router;