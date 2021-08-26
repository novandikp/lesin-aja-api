import { Posisi } from "../Entity/Posisi"
import { Absen, AbsenInterface } from './../Entity/Absen';
import { encrypt } from "../Util/Encrypt"
import Status from "../Entity/Status"

export class AbsenBuilder{
  public idabsen:number
  public idles:number
  public idguru:number
  public tglabsen:string
  public keterangan:string =""
  public flagabsen:number

  constructor({idles,tglabsen}){
    this.idles = idles
    this.tglabsen =tglabsen
  }

  removeTeacher(){
    this.idguru=null
    this.flagabsen=Status.PENDING
  }

  setKeterangan(keterangan){
    this.keterangan =keterangan
  }

  assignAbcent(){
    this.flagabsen = Status.HADIR
  }

  notAbcent(){
    this.flagabsen = Status.TIDAKHADIR
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