import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import {  getJadwal, getJadwalByLes, getJadwalBySiswa } from "../Service/LesService"



const router = Router()
router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
  let data = await getJadwal(req.query,req.context.idchild,req.context.posisi)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.get("/les/:id",async (req:Request,res:Response,next:NextFunction)=>{
  let data = await getJadwalByLes(req.query,req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.get("/siswa/:id",async (req:Request,res:Response,next:NextFunction)=>{
  let data = await getJadwalBySiswa(req.query,req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

export  default router
