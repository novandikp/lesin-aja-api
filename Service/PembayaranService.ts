import { db } from '../Database';
import StatusLes from "../Entity/StatusLes"
import { LesBuilder } from "../Builder/LesBuilder"
const addBayar = async (data)  =>{
  try{
    const dataLes = await db.les.get(data.idles)
    if (dataLes.statusles === StatusLes.PENDING) {
      const lesBuilder: LesBuilder = new LesBuilder(dataLes)
      lesBuilder.setTungguKonfirmasi()
      db.les.edit(lesBuilder.build(), data.idles)
      return await db.pembayaran.add(data)
    }
    return null

  }catch (e){
    console.error(e)
    return  null
  }
}
export {addBayar}