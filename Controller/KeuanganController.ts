import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import { rekapKeuangan, rekapKeuangankeluar, rekapKeuanganmasuk, tambahPemasukan, tambahPengeluaran } from "../Service/KeuanganService"



const router = Router()

router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await rekapKeuangan(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.get("/pemasukan",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await rekapKeuanganmasuk(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.get("/pengeluaran",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await rekapKeuangankeluar(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/pemasukan",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await tambahPemasukan(req.body)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/pengeluaran",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await tambahPengeluaran(req.body)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

export default router