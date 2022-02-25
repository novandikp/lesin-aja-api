import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import { addSiswa, deleteSiswa, editSiswa, getSiswa, getSiswaByParent } from "../Service/SiswaService"
import WaliChecker from "../Middleware/WaliChecker"


const router = Router()
router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getSiswa(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})




router.get("/my/",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getSiswaByParent(req.query,req.context.idchild,req.context.posisi)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.use(WaliChecker)

router.post("/",async (req:Request,res:Response, next:NextFunction)=>{
  req.body.idortu = req.context.idchild
  const data = await addSiswa(req.body)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/:id",async (req:Request,res:Response, next:NextFunction)=>{
  req.body.idortu = req.context.idchild
  const data = await editSiswa(req.body,req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.delete("/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await deleteSiswa(req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


export default router