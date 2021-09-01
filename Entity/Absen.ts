export class Absen {
  public idabsen:number
  public idles:number
  public idguru:number
  public tglabsen:string
  public keterangan:string
  public flagabsen:number


  constructor({idabsen, idguru,tglabsen,keterangan,flagabsen,idles}:AbsenInterface) {
    this.idabsen = idabsen
    this.idguru = idguru
    this.tglabsen = tglabsen
    this.keterangan = keterangan
    this.flagabsen = flagabsen
    this.idles =idles
  }

  getDataWithoutID(){
    return {

      idguru:this.idguru,
      tglabsen:this.tglabsen,
      keterangan:this.keterangan,
      flagabsen:this.flagabsen,
      idles:this.idles
    }
  }

}


export type AbsenInterface = {
   idabsen:number
   idguru:number
   tglabsen:string
   keterangan:string
   flagabsen:number
   idles:number
}