import { db } from '../Database';
import StatusLes from "../Entity/StatusLes"
import { LesBuilder } from "../Builder/LesBuilder"
const addBayar = async (data)  =>{
  try{
    const dataLes = await db.les.get(data.idles)
    if (dataLes.statusles === StatusLes.PENDING || dataLes.statusles === StatusLes.PEMBAYARANDITOLAK) {
      const lesBuilder: LesBuilder = new LesBuilder(dataLes)
      lesBuilder.setBayarBelumKonfirmasi()
      db.les.edit(lesBuilder.build(), data.idles)
      return await db.pembayaran.add(data)
    }
    return {error:dataLes.statusles}


  }catch (e){
    console.error(e)
    return  null
  }
}
export {addBayar}