import { db } from '../Database';
const addBayar = async (data)  =>{
  try{
    return await db.pembayaran.add(data)
  }catch (e){
    console.error(e)
    return  null
  }
}
export {addBayar}