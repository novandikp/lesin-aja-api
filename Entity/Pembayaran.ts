export  class Pembayaran {
  public idbayar:number
  public idles:number
  public tglbayar:string
  public bukti:string
  public jumlahbayar:number

  constructor({idbayar,idles, tglbayar, bukti,jumlahbayar}:PembayaranInterface) {
    this.idbayar=idbayar
    this.idles=idles
    this.tglbayar = tglbayar
    this.bukti=bukti
    this.jumlahbayar=jumlahbayar
  }


  getDataWithoutID(){
    return {
      idles:this.idles,
      tglbayar :this. tglbayar,
      bukti:this.bukti,
      jumlahbayar:this.jumlahbayar
    }
  }
}
export  type PembayaranInterface ={
  idbayar:number
  idles:number
  tglbayar:string
  bukti:string
  jumlahbayar:number

}