export class Les  {
  public idles:number
  public idpaket:number
  public idsiswa:number
  public tglles:string
  public jamles:string
  public hari:string
  public statusles:number
  public prefrensi:string
  public tglperpanjang:string

  constructor({idles, idpaket,idsiswa, tglles,jamles,hari,statusles ,prefrensi, tglperpanjang=null }:LesInterface) {
      this.idles= idles
      this.idpaket=idpaket
      this.idsiswa=idsiswa
      this.tglles= tglles
      this.jamles=jamles
      this.hari = hari
      this.statusles = statusles
      this.prefrensi = prefrensi
      this.tglperpanjang = tglperpanjang
      
  }



  getDataWithoutID(){
    return {
      idpaket :this.idpaket,
      idsiswa:this.idsiswa,
      tglles :this.tglles,
      jamles : this.jamles,
      hari:this.hari,
      statusles:this.statusles,
      prefrensi:this.prefrensi,
      tglperpanjang:this.tglperpanjang
    }
  }
}


export type LesInterface = {
  idles:number,
  idpaket:number,
  idsiswa:number,
  tglles:string,
  jamles:string,
  hari:string,
  statusles:number,
  prefrensi:string,
  tglperpanjang:string
}


export type DetailLes ={
  idles:number,
  idpaket:number,
  idsiswa:number,
  tglles:string,
  jamles:string,
  hari:string,
  statusles:number
  siswa:number
  jenjang:number

}