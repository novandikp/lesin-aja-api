import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import { addSiswa, deleteSiswa, editSiswa, getSiswa, getSiswaByParent } from "../Service/SiswaService"
import WaliChecker from "../Middleware/WaliChecker"
import { acceptLowongan, ajuanLowongan, getLowongan, getLowonganByTag, getPelamar } from "../Service/LowonganService"
import TeacherChecker from "../Middleware/TeacherChecker"


const router = Router()
router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getLowongan(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.get("/pelamar/:id",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getPelamar(req.query,req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.get("/:id",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getLowonganByTag(req.query,req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.post("/ajuan/:id", TeacherChecker,async (req:Request,res:Response,next:NextFunction)=>{
  const data = await ajuanLowongan(req.params.id,req.context.idchild)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Apply telah dilakukan atau data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/terima", WaliChecker,async (req:Request,res:Response,next:NextFunction)=>{
  const data = await acceptLowongan(req.body)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Apply telah dilakukan atau data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

export default router