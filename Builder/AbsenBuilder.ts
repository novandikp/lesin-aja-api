import { Absen } from './../Entity/Absen';
import StatusAbsen from "../Entity/StatusAbsen"

export class AbsenBuilder{
  public idabsen:number
  public idles:number
  public idguru:number
  public tglabsen:string
  public keterangan:string =""
  public flagabsen:number
  
  public flagabsenwali:number
  public rating:number
  public keteranganwali:string

  constructor({idles,tglabsen}){
    this.idles = idles
    this.tglabsen =tglabsen
    this.flagabsenwali =0
    
  }

  removeTeacher(){
    this.idguru=null
    this.flagabsen=StatusAbsen.PENDING
  }


  setTeacher(idguru){
    this.idguru =idguru
  }

  setKeterangan(keterangan){
    this.keterangan =keterangan
  }

  assignAbcent(){
    this.flagabsen = StatusAbsen.HADIR
  }

  pendingAbcent(){
    this.flagabsen = StatusAbsen.PENDING
  }

  notAbcent(){
    this.flagabsen = StatusAbsen.TIDAKHADIR
  }

  getDay(){
    const d = new Date()
    let month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();
    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;
    return [year, month, day].join('-');
  }



  build() :Absen{
    return new Absen(this)
  }
}