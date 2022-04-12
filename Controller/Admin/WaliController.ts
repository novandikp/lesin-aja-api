import { Router,Request ,Response,NextFunction } from "express";
import { getRekapRefrensi, getWali } from "../../Service/WaliService";
import { ErrorHandler } from "../../Util/ErrorHandler";
import { send } from "../../Util/GlobalResponse";
import { HTTPStatus } from "../../Util/HTTPStatus";

const router:Router = Router();

//Halaman Guru

router.get("/",async (req:Request,res:Response,next:NextFunction)=>{
    const data = await getWali(req.query)
    if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
    return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


router.get("/refrensi",async (req:Request,res:Response,next:NextFunction)=>{
    const data = await getRekapRefrensi()
    if (!data) return next(new ErrorHandler(HTTPStatus.ERROR,"Data tidak ditemukan"))
    return send(res,HTTPStatus.OK,{data:data,status:true,message:""})
})


  
export default router;