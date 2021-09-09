import { db } from "../Database"
import ApplyLowongan from "../Entity/ApplyLowongan"
import StatusLowongan from "../Entity/StatusLowongan"

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


export {getLowongan,getLowonganByTag,ajuanLowongan,getPelamar}