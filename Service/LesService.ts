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
import OneSignalUtil from "../Util/OneSignalUtil"
import { Posisi } from "../Entity/Posisi"
import StatusLowongan from "../Entity/StatusLowongan"
import Lowongan from "../Entity/Lowongan"
import ApplyLowongan from '../Entity/ApplyLowongan';

const getLes = async (filter)=>{
  const {status} = filter;
  try{
    if (status && StatusLes.STATUS_DATA.indexOf(status) > -1){
      
      return await db.les.allWithStatus(filter,StatusLes.STATUS_DATA.indexOf(status))
    }else{
      return await db.les.all(filter)
    }
    
  }catch (e){
    console.log(e)
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


const getJadwal =async(filter,idchild,role)=>{
  try{
    if(role == Posisi.WALI){
      return await db.absen.getByParent(filter,idchild)
    }else {
      return await db.absen.getByTeacher(filter,idchild)
    }
  }catch (e){
    console.log(e)
    return null
  }
}


const getJadwalByLes =async(filter,idles)=>{
  try{
    return await db.absen.getByLes(filter,idles)
  }catch (e){
    console.log(e)
    return null
  }
}

const getJadwalBySiswa =async(filter,idles)=>{
  try{
    return await db.absen.getBySiswa(filter,idles)
  }catch (e){
    console.log(e)
    return null
  }
}

const getTagihanWali = async (filter,idortu)=>{
  try{
    return await db.les.historyByParentStatus(filter,idortu,StatusLes.BAYAR_BELUMKONFIRMASI)
  }catch (e){

    return null
  }
}

const getTagihan = async (filter,idortu)=>{
  try{
    return await db.les.historyByParentStatus(filter,idortu,StatusLes.BAYAR_BELUMKONFIRMASI)
  }catch (e){

    return null
  }
}

const addLes = async (data)  =>{
  try{
    const lesBuilder:LesBuilder = new LesBuilder(data)
    lesBuilder.setMencariGuru()
    const dataLes:Les =await db.les.add(lesBuilder.build())
    await db.lowongan.add(new Lowongan(dataLes.idles,StatusLowongan.PENDING))
    // new OneSignalUtil().sendNotificationWithTag("Terdapat pesanan baru",1)
    return dataLes
  }catch (e){
    console.error(e)
    return  null
  }
}


const cancelLes = async (idles)=>{
  try{
    const data = await db.les.get(idles)
    console.log(data);
    if(data.statusles == StatusLes.MENCARI_GURU){
      const lesBuilder:LesBuilder = new LesBuilder(data)
      lesBuilder.setCancel()
      await db.lowongan.batal(idles);
      return db.les.edit(lesBuilder.build(),idles)
    }
    return null
  }catch (e){
    return null
  }
}

const confirmLes =  async (idles)  =>{
  try{
    const dataLes = await db.les.getApply(idles)
    if (dataLes.statusles === StatusLes.BAYAR_BELUMKONFIRMASI){
      const lesBuilder:LesBuilder = new LesBuilder(dataLes)
      lesBuilder.setBerlangsung()
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

              absenBuilder.setTeacher(dataLes.idguru)
              absenBuilder.pendingAbcent()
              const absen =await db.absen.add(absenBuilder.build())
              dataAbsen.push(absen)
          }
        }

        //tambah hari
        tglmulailes.setDate(tglmulailes.getDate()+1)
      }

      // Update data les
      const dataLowongan = await db.lowongan.getCurrentLowonganByLes(idles,StatusLowongan.DIKONFIRMASI)
      console.log(dataLowongan);
      
      db.applyLowongan.acceptLowongan(dataLowongan.idlowongan)
      const result = await db.les.edit(lesBuilder.build(),idles)
      result["absen"] = dataAbsen

      return result
    }else{
      return null
    }
  }catch (e) {
    console.log(e);
    return null
  }
}

const reselectTeacher = async (idles)=>{
  try{
    await db.lowongan.disableRecent(idles)
    const data = await db.les.get(idles)
    if(data.statusles == StatusLes.SEDANG_BERLANGSUNG){
      const lesBuilder:LesBuilder = new LesBuilder(data)
      lesBuilder.setMencariGuruUlang()
      await db.lowongan.add(new Lowongan(data.idles,StatusLowongan.PENDING))
      return db.les.edit(lesBuilder.build(),idles)
    }else{
      return null;
    }
 
  }catch (e){ 
    return null
  }
}

const acceptLes = async (idles,idguru) =>{
  try {
    const dataLes:Les = await  db.les.getApply(idles)
    if(dataLes.statusles == StatusLes.MENCARI_GURU){
      await  db.absen.setGuruAbsen(idles,idguru)
      const lesBuilder:LesBuilder = new LesBuilder(dataLes)
      lesBuilder.setPending()
      return db.les.edit(lesBuilder.build(),idles)
    }
    return null
  }catch (e){

    return null
  }
}

const rejectLes =  async (idles)  =>{
  try{
    const dataLes:Les = await db.les.getApply(idles)
    if (dataLes.statusles === StatusLes.BAYAR_BELUMKONFIRMASI){
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


const perpanjanganLes = async (id, tgl)=> {
  try{
    const data = await db.les.get(id)
    if(data.statusles == StatusLes.SELESAI){
      const lesBuilder:LesBuilder = new LesBuilder(data)
      lesBuilder.setPerpanjangan(tgl)
      return db.les.edit(lesBuilder.build(),id)
    }
    return null
  }catch (e){
    return null
  }
}

const getPermintaanLes = async(idguru)=>{
  try {
    return db.les.getByGuruStatus(idguru,StatusLes.PROSESPERPANJANGAN)
  } catch (error) {
    return null
  }
}

const terimaPerpanjanganLes = async (id)=> {
  try{
    const data = await db.les.get(id)
    if(data.statusles == StatusLes.PROSESPERPANJANGAN){
      const lesBuilder:LesBuilder = new LesBuilder(data)
      lesBuilder.setKonfirmasiPerpanjangan()
      await db.les.edit(lesBuilder.build(),id)
      lesBuilder.tglles = lesBuilder.tglperpanjang
      lesBuilder.setPending()
      const dataLes =await db.les.add(lesBuilder.build())
      const {idlowongan}= await db.lowongan.add(new Lowongan(dataLes.idles,StatusLowongan.DIKONFIRMASI))
      await db.applyLowongan.add(new ApplyLowongan(idlowongan,data.idguru, StatusLowongan.DIKONFIRMASI))
      return dataLes
    }
    return null
  }catch (e){
    return null
  }
}


const tolakPerpanjanganLes = async (id)=> {
  try{
    const data = await db.les.get(id)
    if(data.statusles == StatusLes.PROSESPERPANJANGAN){
      const lesBuilder:LesBuilder = new LesBuilder(data)
      lesBuilder.setTolakPerpanjangan()
      return db.les.edit(lesBuilder.build(),id)
    }
    return null
  }catch (e){
    return null
  }
}


const getLesPayed = async (query) =>{
  try {
    return db.les.lesPayed(query)
  } catch (error) {
    return null
  }
}


export  {reselectTeacher,getLesPayed,perpanjanganLes, tolakPerpanjanganLes, getPermintaanLes, terimaPerpanjanganLes,getLes,getHistoryWali,getTagihanWali, addLes, cancelLes,editLes,deleteLes,confirmLes, rejectLes,acceptLes,getJadwal,getJadwalByLes,getJadwalBySiswa}