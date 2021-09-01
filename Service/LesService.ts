import { db } from '../Database';
import { as } from "pg-promise"
import { Les } from "../Entity/Les"
import Paket from "../Entity/Paket"
import { AbsenBuilder } from "../Builder/AbsenBuilder"
import { LesBuilder } from "../Builder/LesBuilder"
import { Absen, AbsenInterface } from "../Entity/Absen"
import StatusLes from "../Entity/StatusLes"
import getIndexHari from "../Entity/Hari"
import { convertDate } from "../Util/DateUtil"
import { log } from "util"

const getLes = async (filter)=>{
  try{
    return await db.les.all(filter)
  }catch (e){
    return null
  }
}

const getHistoryWali =async(filter,idortu,status)=>{
  try{
    if(!status){
      return await db.les.historyByParent(filter,idortu)
    }else {
      return await db.les.historyByParentStatus(filter,idortu,status)
    }
  }catch (e){
    console.log(e)
    return null
  }
}

const getTagihanWali = async (filter,idortu)=>{
  try{
    return await db.les.historyByParentStatus(filter,idortu,StatusLes.PENDING)
  }catch (e){

    return null
  }
}

const addLes = async (data)  =>{
  try{
    const lesBuilder:LesBuilder = new LesBuilder(data)
    lesBuilder.setPending()
    return await db.les.add(lesBuilder.build())
  }catch (e){
    console.error(e)
    return  null
  }
}

const confirmLes =  async (idles)  =>{
  try{
    const dataLes = await db.les.get(idles)
    if (dataLes.statusles === StatusLes.PENDING){
      const lesBuilder:LesBuilder = new LesBuilder(dataLes)
      lesBuilder.setMencariGuru()
      //Generate Absen
      let tglmulailes:Date = new Date(dataLes.tglles)
      let dataAbsen:Absen[] =[];
      const hariTerpilih = dataLes.hari.split(",")
      while(dataAbsen.length < dataLes.jumlah_pertemuan){

        for (const hari of hariTerpilih) {

          if (tglmulailes.getDay() == getIndexHari(hari)){
              const absenBuilder:AbsenBuilder = new AbsenBuilder(
                {
                  idles: dataLes.idles,
                  tglabsen:convertDate(tglmulailes)}
              )

              absenBuilder.removeTeacher()

              const absen =await db.absen.add(absenBuilder.build())
              dataAbsen.push(absen)
          }
        }

        //tambah hari
        tglmulailes.setDate(tglmulailes.getDate()+1)
      }

      // Update data les
      const result = await db.les.edit(lesBuilder.build(),idles)

      result["absen"] = dataAbsen
      return result
    }else{
      return null
    }
  }catch (e) {
    return null
  }
}

const acceptLes = async (idles,idguru) =>{
  try {
    const dataLes:Les = await  db.les.get(idles)
    const dataAbsen:Absen[]=[];
    if (dataAbsen.length == 0){
      return {statusFailed : false}
    }else{
      for (const value of dataAbsen) {
        value.idguru =idguru
        await db.absen.edit(value, value.idabsen)
      }
    }
    const lesBuilder:LesBuilder = new LesBuilder(dataLes)
    lesBuilder.setMenemukanGuru()
    return db.les.edit(lesBuilder.build(),idles)
  }catch (e){
    return null
  }
}

const rejectLes =  async (idles)  =>{
  try{
    const dataLes:Les = await db.les.get(idles)
    if (dataLes.statusles === StatusLes.PENDING){
      const lesBuilder:LesBuilder = new LesBuilder(dataLes)
      lesBuilder.setTolakPembayaran()
      return db.les.edit(lesBuilder.build(),idles)
    }else{
      return null
    }
  }catch (e) {
    return null
  }
}



const editLes = async (data,id) =>{
  try{
    return await db.paket.edit(data,id)
  }catch (e){
    return  null
  }
}

const  deleteLes = async  (id) =>{
  try{
    return db.paket.remove(id)
  }catch (e){
    return  null
  }
}


export  {getLes,getHistoryWali,getTagihanWali, addLes,editLes,deleteLes,confirmLes, rejectLes}