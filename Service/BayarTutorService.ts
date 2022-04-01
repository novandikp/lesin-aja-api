import { db } from "../Database"
import { BayarTutorInterface } from "../Entity/BayarTutor"
import { tambahPengeluaran } from "./KeuanganService";

const pembayaranTutor=async (data:any)=>{
    try {
        const bayar:BayarTutorInterface = await db.bayarTutor.add(data)

        
        if(bayar){
            tambahPengeluaran({
                jumlah:bayar.jumlah_gaji,
                keterangan:"Pembayaran Guru",
                tanggal:new Date().toDateString(),
            })
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