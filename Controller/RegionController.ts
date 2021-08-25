import {Router,Response,Request,NextFunction} from "express"

import { HTTPStatus } from './../Util/HTTPStatus';
import { send } from './../Util/GlobalResponse';
import { ErrorHandler } from "../Util/ErrorHandler";
import { getCity, getDistrict, getProvince, getVillage } from "../Service/RegionService";

const router = Router()

router.get("/provinsi",async (req:Request,res:Response, next:NextFunction)=>{    
    const data = await getProvince()
    if(!data) return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    return send(res,HTTPStatus.OK, {data :data,message:"Data Ditemukan"})
})


router.get("/kota/:id",async (req:Request,res:Response, next:NextFunction)=>{    
    const data = await getCity(req.params.id)
    if(data){
        return send(res,HTTPStatus.OK, {data :data,message:"Data Ditemukan"})
    }else{
       return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    }
})



router.get("/kecamatan/:id",async (req:Request,res:Response, next:NextFunction)=>{    
    const data = await getDistrict(req.params.id)
    if(data){
        return send(res,HTTPStatus.OK, {data :data,message:"Data Ditemukan"})
    }else{
       return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    }
})


router.get("/desa/:id",async (req:Request,res:Response, next:NextFunction)=>{    
    const data = await getVillage(req.params.id)
    if(data){
        return send(res,HTTPStatus.OK, {data :data,message:"Data Ditemukan"})
    }else{
       return next(new ErrorHandler(HTTPStatus.NOTFOUND,"Data tidak ditemukan"))
    }
})

export default router