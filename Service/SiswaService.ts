import { db } from '../Database';


const getSiswa = async (filter)=>{
  try{
    return await db.siswa.all(filter)
  }catch (e){
    return null
  }
}

const getSiswaByParent = async (filter,idparent)=>{
  try{
    return await db.siswa.getByParent(filter,idparent)
  }catch (e){
    console.error(e)
    return null
  }
}

const addSiswa = async (data)  =>{
  data.idortu = data.idchild
  try{
    return await db.siswa.add(data)
  }catch (e){
    console.error(e)
    return  null
  }
}


const editSiswa = async (data,id) =>{
  data.idortu = data.idchild
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