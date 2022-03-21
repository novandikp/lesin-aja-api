export class Absen {
  public idabsen:number
  public idles:number
  public idguru:number
  public tglabsen:string
  public keterangan:string
  public flagabsen:number
  public flagabsenwali:number
  public rating:number
  public keteranganwali:string


  constructor({idabsen, idguru,tglabsen,keterangan,flagabsen,idles, flagabsenwali,rating,keteranganwali}:AbsenInterface) {
    this.idabsen = idabsen
    this.idguru = idguru
    this.tglabsen = tglabsen
    this.keterangan = keterangan
    this.flagabsen = flagabsen
    this.idles =idles
    this.flagabsenwali =flagabsenwali
    this.rating=rating
    this.keteranganwali=keteranganwali
  }

  getDataWithoutID(){
    return {
      idguru:this.idguru,
      tglabsen:this.tglabsen,
      keterangan:this.keterangan,
      flagabsen:this.flagabsen,
      idles:this.idles,
      flagabsenwali:this.flagabsenwali,
      rating:this.rating,
      keteranganwali:this.keteranganwali
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
   
   flagabsenwali:number
   rating:number
   keteranganwali:string
}