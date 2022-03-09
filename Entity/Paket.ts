export default  class Paket {
  public idpaket:number
  public paket:string
  public jumlah_pertemuan:number
  public biaya:number
  public gaji:number
  public jenjang:string

  constructor({idpaket,paket,jumlah_pertemuan,biaya,gaji,jenjang}:PaketInterface) {
    this.gaji=gaji
    this.idpaket = idpaket
    this.paket = paket
    this.jumlah_pertemuan = jumlah_pertemuan
    this.biaya = biaya
    this.jenjang = jenjang
  }


  getDataWithoutID(){
    return {
      paket:this.paket,
      jumlah_pertemuan:this.jumlah_pertemuan,
      biaya:this.biaya,
      gaji:this.gaji,
      jenjang : this.jenjang
    }
  }
}



export type PaketInterface ={
   idpaket:number
   paket:string
   jumlah_pertemuan:number
   biaya:number
  gaji:number
  jenjang:string
}