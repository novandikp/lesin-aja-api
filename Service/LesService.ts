import { db } from '../Database';
import { as } from "pg-promise"
import { Les } from "../Entity/Les"
import Paket from "../Entity/Paket"
import { AbsenBuilder } from "../Builder/AbsenBuilder"
import { LesBuilder } from "../Builder/LesBuilder"
import { AbsenInterface } from "../Entity/Absen"

const getLes = async (filter)=>{
  try{
    return await db.paket.all(filter)
  }catch (e){
    return null
  }
}

const addLes = async (data)  =>{
  try{

    const lesBuilder:LesBuilder = new LesBuilder(data)
    const dataLes = await db.les.add(lesBuilder.build())

    for (const tgl of data.tglles) {
      const absenBuilder:AbsenBuilder = new AbsenBuilder({idles:dataLes.idles,tglabsen:tgl})
      absenBuilder.removeTeacher()
      await db.absen.add(absenBuilder.build())
    }

    return dataLes

  }catch (e){
    console.error(e)
    return  null
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


export  {getLes, addLes,editLes,deleteLes}