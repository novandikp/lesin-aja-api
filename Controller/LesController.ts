import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import {
  acceptLes,
  addLes,
  confirmLes,
  deleteLes,
  editLes,
  getHistoryWali,
  getLes,
  getTagihanWali,
  rejectLes
} from "../Service/LesService"
import WaliChecker from "../Middleware/WaliChecker"
import { absenPertemuan, editAbsen, izinPertemuan } from "../Service/AbsenService"


const router = Router()

router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getLes(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.get("/tagihan",WaliChecker,async (req:Request,res:Response,next:NextFunction)=>{

  let data = await getTagihanWali(req.query,req.context.idchild)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.get("/histori",WaliChecker,async (req:Request,res:Response,next:NextFunction)=>{
  let data = await getHistoryWali(req.query,req.context.idchild,req.query.status)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.post("/daftar",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await addLes(req.body)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi kesalahan saat mendaftar les"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/konfirmasi/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await confirmLes(req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi kesalahan saat mengkonfirmasi les"))

  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.post("/tolak/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await rejectLes(req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi kesalahan saat menolak les"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/terima/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await acceptLes(req.params.id,req.context.idchild)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi kesalahan saat menerima les"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.post("/present/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await absenPertemuan(req.params.id, req.body, req.context)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi kesalahan saat presen les"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/absent/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await izinPertemuan(req.params.id, req.body, req.context)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi kesalahan saat absen les"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/edit/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await editAbsen(req.params.id,req.body.tglabsen)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Terjadi kesalahan saat edit les"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

export default router