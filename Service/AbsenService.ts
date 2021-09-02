import { db } from "../Database"
import StatusAbsen from "../Entity/StatusAbsen"

const absenPertemuan = async (idabsen)=>{
  try{
    const dataAbsen = await db.absen.get(idabsen)
    dataAbsen.flagabsen = StatusAbsen.HADIR
    return await  db.absen.edit(dataAbsen,idabsen)
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



export  {absenPertemuan,editAbsen}