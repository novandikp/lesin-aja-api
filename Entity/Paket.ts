export default  class Paket {
  public idpaket:number
  public paket:string
  public jumlah_pertemuan:number
  public biaya:number

  constructor({idpaket,paket,jumlah_pertemuan,biaya}:PaketInterface) {
    this.idpaket = idpaket
    this.paket = paket
    this.jumlah_pertemuan = jumlah_pertemuan
    this.biaya = biaya
  }


  getDataWithoutID(){
    return {
      paket:this.paket,
      jumlah_pertemuan:this.jumlah_pertemuan,
      biaya:this.biaya
    }
  }
}



export type PaketInterface ={
   idpaket:number
   paket:string
   jumlah_pertemuan:number
   biaya:number
}