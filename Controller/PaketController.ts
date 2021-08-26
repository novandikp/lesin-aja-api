import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import { addPaket, deletePaket, editPaket, getPaket } from "../Service/PaketService"
import AdminChecker from "../Middleware/AdminChecker"


const router = Router()
// router.use(AdminChecker)
router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
  const data = await getPaket(req.query)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.post("/",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await addPaket(req.body)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.post("/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await editPaket(req.body,req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})

router.delete("/:id",async (req:Request,res:Response, next:NextFunction)=>{
  const data = await deletePaket(req.params.id)
  if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
  return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


export default router