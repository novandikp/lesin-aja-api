import { Les, LesInterface } from './../Entity/Les';
import StatusLes from "../Entity/StatusLes"

export class LesBuilder{
  public idles:number
  public idpaket:number
  public idsiswa:number
  public tglles:string
  public jamles:string
  public hari:string
  public statusles:number
  public prefrensi:string
  constructor({idpaket,idsiswa, tglles, jamles, hari,prefrensi}:LesInterface){
    this.idpaket = idpaket
    this.idsiswa =idsiswa
    this.tglles = tglles
    this.jamles = jamles
    this.hari =hari
    this.prefrensi = prefrensi
  }

  setPending(){
    this.statusles = StatusLes.PENDING
  }



  setTolakPembayaran(){
    this.statusles = StatusLes.PEMBAYARANDITOLAK
  }

  setMencariGuru(){
    this.statusles = StatusLes.MENCARI_GURU
  }

  setBerlangsung(){
    this.statusles=StatusLes.SEDANG_BERLANGSUNG
  }

  setBayarBelumKonfirmasi(){
    this.statusles = StatusLes.BAYAR_BELUMKONFIRMASI
  }

  setSelesai(){
    this.statusles = StatusLes.SELESAI
  }


  setCancel(){
    this.statusles = StatusLes.DIBATALKAN
  }

  setTanggalLes(day){
    this.tglles = day
  }

  build() :Les{
    return new Les(this)
  }
}