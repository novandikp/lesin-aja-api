export default  class Paket {
  public idpaket:number
  public paket:string
  public jumlah_pertemuan:number
  public biaya:number
  public gaji:number

  constructor({idpaket,paket,jumlah_pertemuan,biaya,gaji}:PaketInterface) {
    this.gaji=gaji
    this.idpaket = idpaket
    this.paket = paket
    this.jumlah_pertemuan = jumlah_pertemuan
    this.biaya = biaya
  }


  getDataWithoutID(){
    return {
      paket:this.paket,
      jumlah_pertemuan:this.jumlah_pertemuan,
      biaya:this.biaya,
      gaji:this.gaji
    }
  }
}



export type PaketInterface ={
   idpaket:number
   paket:string
   jumlah_pertemuan:number
   biaya:number
    gaji:number
}