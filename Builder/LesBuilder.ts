import { Posisi } from "../Entity/Posisi"
import { Les, LesInterface } from './../Entity/Les';
import { encrypt } from "../Util/Encrypt"
import StatusLes from "../Entity/StatusLes"

export class LesBuilder{
  public idles:number
  public idpaket:number
  public idsiswa:number
  public tglles:string
  public jamles:string
  public hari:string
  public statusles:number
  constructor({idpaket,idsiswa, tglles, jamles, hari}:LesInterface){
    this.idpaket = idpaket
    this.idsiswa =idsiswa
    this.tglles = tglles
    this.jamles = jamles
    this.hari =hari
  }

  setPending(){
    this.statusles = StatusLes.PENDING
  }

  setTungguKonfirmasi(){
    this.statusles = StatusLes.MENUNGGU_KONFIRMASI
  }

  setTolakPembayaran(){
    this.statusles = StatusLes.PEMBAYARANDITOLAK
  }

  setMencariGuru(){
    this.statusles = StatusLes.MENCARI_GURU
  }

  setMenemukanGuru(){
    this.statusles = StatusLes.MENDAPATKAN_GURU
  }

  setTanggalLes(day){
    this.tglles = day
  }

  build() :Les{
    return new Les(this)
  }
}