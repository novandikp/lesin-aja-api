import { Posisi } from "../Entity/Posisi"
import { Les, LesInterface } from './../Entity/Les';
import { encrypt } from "../Util/Encrypt"

export class LesBuilder{
  public idles:number
  public idpaket:number
  public idsiswa:number
  public tglles:string
  public jamles:string

  constructor({idpaket,idsiswa}:LesInterface){
    this.idpaket = idpaket
    this.idsiswa =idsiswa
    this.tglles = this.getDay()
    this.jamles = this.getTime()
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

  getTime(){
    const d = new Date()
    let hour = '' + (d.getHours()),
      minute = '' + d.getMinutes()

    return [hour,minute].join(':');
  }

  setJamLes(time){
    this.jamles = time
  }

  setTanggalLes(day){
    this.tglles = day
  }

  build() :Les{
    return new Les(this)
  }
}