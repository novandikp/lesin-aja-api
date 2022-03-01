import { convertDate } from "../Util/DateUtil"
import Keuangan from "../Entity/Keungan"
import { db } from "../Database"

const tambahPemasukan=  ({jumlah,keterangan, tanggal = convertDate(new Date())})=>{
  const keuangan:Keuangan = new Keuangan(tanggal,jumlah,0,keterangan)
  return db.keuangan.add(keuangan)
}

const tambahPengeluaran=  ({jumlah,keterangan, tanggal = convertDate(new Date())})=>{
  const keuangan:Keuangan = new Keuangan(tanggal,0,jumlah,keterangan)
  return db.keuangan.add(keuangan)
}

const rekapKeuangan = (filter)=>{
  return db.keuangan.rekap(filter)
}


export {tambahPemasukan,tambahPengeluaran,rekapKeuangan}