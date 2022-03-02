import { Router } from "express";
import { GuruService } from "../Service";
import { send } from "../Util/GlobalResponse";
import { HTTPStatus } from "../Util/HTTPStatus";

const router: Router = Router();

//  Ambil Profil Guru
router.get("/guru/profile/:id", async (req, res, next) => {
    const idguru:number=parseInt(req.params.id);
    const data = await GuruService.profile(idguru);
    if (!data) return next(new Error("Data tidak ditemukan"));
    return send(res, HTTPStatus.OK, {data:data,status:true, message :""})
});


router.get("/access", async (req,res,next)=>{
    return send(res,HTTPStatus.OK, {data: req.context, status:true, message:"Akses masih berlaku"})
})



export default router;

