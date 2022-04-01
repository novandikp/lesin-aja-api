import { LesBuilder } from './../Builder/LesBuilder';
import { db } from "../Database"
import { Posisi } from "../Entity/Posisi"
import StatusAbsen from "../Entity/StatusAbsen"
import StatusLes from "../Entity/StatusLes"
import { rekapKeuangankeluar } from "./KeuanganService"

const absenPertemuan = async (idabsen, data , context)=>{
  try{

    if(!data.rating){
      data.rating=0
    }

    if (context.posisi == Posisi.GURU){
      const dataAbsen = await db.absen.get(idabsen)
      dataAbsen.flagabsen = StatusAbsen.HADIR
      dataAbsen.keterangan = data.keterangan

      const rekap =await db.les.cekStatusLes(dataAbsen.idles)
      
      if(rekap){
        if (rekap.statusles == StatusLes.SEDANG_BERLANGSUNG && rekap.jumlah_mengajar == rekap.jumlah_pertemuan){
          const dataLes = await db.les.get(dataAbsen.idles)
          const lesBuilder:LesBuilder = new LesBuilder(dataLes)
          lesBuilder.setSelesai()
          await db.les.edit(lesBuilder.build(),dataAbsen.idles)
        }
      }
      return await db.absen.edit(dataAbsen,idabsen)
    }else if (context.posisi == Posisi.WALI){
      const dataAbsen = await db.absen.get(idabsen)
      dataAbsen.flagabsenwali  = StatusAbsen.HADIR
      dataAbsen.rating = data.rating
      dataAbsen.keteranganwali = data.keterangan
      
      const rekap =await db.les.cekStatusLes(dataAbsen.idles)
      if(rekap){
        if (rekap.statusles == StatusLes.SEDANG_BERLANGSUNG && rekap.jumlah_mengajar == rekap.jumlah_pertemuan){
          const dataLes = await db.les.get(dataAbsen.idles)
          const lesBuilder:LesBuilder = new LesBuilder(dataLes)
          lesBuilder.setSelesai()
          await db.les.edit(lesBuilder.build(),dataAbsen.idles)
        }
      }
      

      return await db.absen.edit(dataAbsen,idabsen)
    }


  }catch (e){
    console.log(e);
    
    return null
  }
}


const izinPertemuan = async (idabsen, data , context)=>{
  try{
    if(!data.rating){
      data.rating=0
    }
    if (context.posisi == Posisi.GURU){
      const dataAbsen = await db.absen.get(idabsen)
      dataAbsen.flagabsen = StatusAbsen.TIDAKHADIR
      dataAbsen.keterangan = data.keterangan
      return await db.absen.edit(dataAbsen,idabsen)
    }else if (context.posisi == Posisi.WALI){
      const dataAbsen = await db.absen.get(idabsen)
      dataAbsen.flagabsenwali  = StatusAbsen.TIDAKHADIR
      dataAbsen.rating = data.rating
      dataAbsen.keteranganwali = data.keterangan
      return await db.absen.edit(dataAbsen,idabsen)
    }
  }catch (e){
    return null
  }
}

const editAbsen = async (idabsen,tglabsen)=>{
  try{
    const dataAbsen = await db.absen.get(idabsen)
    dataAbsen.tglabsen = tglabsen
    console.log(dataAbsen)
    return await  db.absen.edit(dataAbsen,idabsen)
  }catch (e){
    return null
  }
}



export  {absenPertemuan,editAbsen, izinPertemuan}