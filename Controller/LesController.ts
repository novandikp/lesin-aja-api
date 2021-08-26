import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import { addLes, deleteLes, editLes, getLes } from "../Service/LesService"


const router = Router()

router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getLes(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.post("/",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await addLes(req.body)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await editLes(req.body,req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.delete("/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await deleteLes(req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


export default router