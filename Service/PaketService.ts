import { db } from '../Database';
import { as } from "pg-promise"

const getPaket = async (filter)=>{
  try{
    return await db.paket.all(filter)
  }catch (e){
    return null
  }
}

const addPaket = async (data)  =>{
  try{
    return await db.paket.add(data)
  }catch (e){
    console.error(e)
    return  null
  }
}


const editPaket = async (data,id) =>{
  try{
    return await db.paket.edit(data,id)
  }catch (e){
    return  null
  }
}

const  deletePaket = async  (id) =>{
  try{
    return db.paket.remove(id)
  }catch (e){
    return  null
  }
}


export  {getPaket, addPaket,editPaket,deletePaket}