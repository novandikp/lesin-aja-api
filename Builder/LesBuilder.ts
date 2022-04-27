import { Les, LesInterface } from './../Entity/Les';
import StatusLes from "../Entity/StatusLes"
import { db } from '../Database';
import { Rekap_Mengajar } from '../Entity/RekapMengajar';

export class LesBuilder{
  
  public idles:number
  public idpaket:number
  public idsiswa:number
  public tglles:string
  public jamles:string
  public hari:string
  public statusles:number
  public prefrensi:string
  public tglperpanjang:string
  constructor({idpaket,idsiswa, tglles, jamles, hari,prefrensi}:LesInterface){
    this.idpaket = idpaket
    this.idsiswa =idsiswa
    this.tglles = tglles
    this.jamles = jamles
    this.hari =hari
    this.prefrensi = prefrensi
  }


  setMencariGuruUlang() {
    this.statusles = StatusLes.MENCARI_GURU_ULANG

  }

  setPending(){
    this.statusles = StatusLes.PENDING
    this.tglperpanjang =null  
  }

  setIdLes(idles:number){
    this.idles = idles
  }

  setTolakPembayaran(){
    this.statusles = StatusLes.PEMBAYARANDITOLAK
  }

  setMencariGuru(){
    this.statusles = StatusLes.MENCARI_GURU
  }

  setTolakPerpanjangan() {
   this.statusles = StatusLes.TOLAK_PERPANJANGAN
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

  setPerpanjangan(tanggalPerpanjangan){
    this.tglperpanjang = tanggalPerpanjangan
    this.statusles = StatusLes.PROSESPERPANJANGAN
  }

  setKonfirmasiPerpanjangan(){
    this.statusles = StatusLes.KONFIRMASI_PERPANJANGAN
  }


  setCancel(){
    this.statusles = StatusLes.DIBATALKAN
  }

  

  build() :Les{
 
    return new Les(this)
  }
}