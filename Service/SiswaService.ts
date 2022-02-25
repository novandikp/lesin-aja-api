import { db } from '../Database';
import { Posisi } from '../Entity/Posisi';


const getSiswa = async (filter)=>{
  try{
    return await db.siswa.all(filter)
  }catch (e){
    return null
  }
}

const getSiswaByParent = async (filter,idparent,tipe)=>{
  
  try{
    if (tipe == Posisi.WALI){
      return await db.siswa.getByParent(filter,idparent)
    }else if(tipe == Posisi.GURU){
      return await db.siswa.getByTeacher(filter,idparent)
    }
    return null
  }catch (e){
    console.error(e)
    return null
  }
}

const addSiswa = async (data)  =>{

  try{
    return await db.siswa.add(data)
  }catch (e){
    console.error(e)
    return  null
  }
}


const editSiswa = async (data,id) =>{
  
  try{
    return await db.siswa.edit(data,id)
  }catch (e){
    return  null
  }
}

const  deleteSiswa = async  (id) =>{
  try{
    return db.siswa.remove(id)
  }catch (e){
    return  null
  }
}


export  {getSiswa, addSiswa,editSiswa,deleteSiswa, getSiswaByParent}