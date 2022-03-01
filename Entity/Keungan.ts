export  default class Keuangan{
  public  idkeuangan:number
  public  tglkeuangan:string
  public  masuk:number
  public  keluar:number
  public  keterangan:string
  public  saldo:number

  constructor(tglkeuangan: string, masuk: number, keluar: number, keterangan: string) {
    this.tglkeuangan = tglkeuangan
    this.masuk = masuk
    this.keluar = keluar
    this.keterangan = keterangan
  }

  getDataWithoutID(){
    return {
       tglkeuangan :this.tglkeuangan,
       masuk :this.masuk,
       keluar :this.keluar,
       keterangan :this.keterangan,
    }
  }


}