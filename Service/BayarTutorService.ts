import { db } from "../Database"
import { BayarTutorInterface } from "../Entity/BayarTutor"

const pembayaranTutor=async (data:any)=>{
    try {
        const bayar:BayarTutorInterface = await db.bayarTutor.add(data)
        console.log(bayar);
        
        if(bayar){
            return bayar
        }else{
            return null
        }
    } catch (error) {
        console.log(error);
        
        return null
    }
}

export  {pembayaranTutor}