import { db } from "../Database"
import ApplyLowongan from "../Entity/ApplyLowongan"
import StatusLowongan from "../Entity/StatusLowongan"
import StatusLes from "../Entity/StatusLes"
import { LesBuilder } from "../Builder/LesBuilder"
import getIndexHari from "../Entity/Hari"
import { Absen } from "../Entity/Absen"

const getLowongan = async (filter)=>{
  try{
    return await db.lowongan.all(filter)
  }catch (e){
    return null
  }
}

const getPelamar = async (filter,idles)=>{
  try{
    return await db.applyLowongan.getByLes(filter,idles)
  }catch (e){
    return null
  }
}


const getLowonganByTag = async (filter,tag)=>{
  try{
    return await db.lowongan.getByRegion(filter,tag)
  }catch (e){
    return null
  }
}


const ajuanLowongan = async (idlowongan,idguru)=>{
  try{
    return await db.applyLowongan.add(new ApplyLowongan(idlowongan,idguru,StatusLowongan.PENDING))
  }catch (e){
    console.error(e)
    return null
  }
}


const acceptLowongan = async({ idapplylowongan, idles, tglmulai })=>{
  // cari tetang les dan lowongan
  const dataLes = await db.lowongan.getCurrentLowonganByLes(idles)
  if(dataLes){
    const lesBuilder = new LesBuilder(dataLes)
    if(dataLes.statusles == StatusLes.MENCARI_GURU){
      const ajuan =await db.applyLowongan.applyLowongan(idapplylowongan,dataLes.idlowongan,StatusLowongan.MENUNGGU_KONFIRMASI)
      if (ajuan){
        lesBuilder.setPending()
      }else{
        return null;
      }
    }else{
      const ajuan = await db.applyLowongan.applyLowongan(idapplylowongan,dataLes.idlowongan,StatusLowongan.DIKONFIRMASI)
      if (ajuan){
        await applyNewAbsen(tglmulai,dataLes,ajuan.idguru)
        lesBuilder.setBerlangsung()
      }else{
        return null;
      }
     
    }
    await db.lowongan.setStatusLowongan(dataLes.idlowongan, StatusLowongan.DIKONFIRMASI)
    return db.les.edit(lesBuilder.build(),idles)
  }else{
    return null;
  }
  

}


const applyNewAbsen=async (tanggalMulai,dataLes,idguru)=>{
  const hariTerpilih = dataLes.hari.split(",")
  const absenTersisa = await db.absen.getSisaJadwal(dataLes.idles)
  let tglmulailes:Date = new Date(tanggalMulai)
  let i=0
  while(i < absenTersisa.length){
    for (const hari of hariTerpilih) {
      if (tglmulailes.getDay() == getIndexHari(hari)){
        const absenBuilder:Absen = new Absen(
          absenTersisa[i]
        )
        absenBuilder.tglabsen = tglmulailes.toISOString().slice(0, 10);
        absenBuilder.idguru =idguru
        await db.absen.edit(absenBuilder,absenBuilder.idabsen)
        i++;
      }
    }
    tglmulailes.setDate(tglmulailes.getDate()+1)
  }
}

const getStatusLowongan = async (idlowongan,idguru)=>{
  try{
    const data = await db.applyLowongan.getStatus(idlowongan,idguru)
    data.statusapply = StatusLowongan.getStatus(data.statusapply)
    return data;
  }catch (e){
    return null
  }
}

export {getLowongan,getLowonganByTag,ajuanLowongan,getPelamar,acceptLowongan,getStatusLowongan}