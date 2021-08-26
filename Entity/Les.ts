export class Les  {
  public idles:number
  public idpaket:number
  public idsiswa:number
  public tglles:string
  public jamles:string

  constructor({idles, idpaket,idsiswa, tglles,jamles  }:LesInterface) {
      this.idles= idles
      this.idpaket=idpaket
      this.idsiswa=idsiswa
      this.tglles= tglles
      this.jamles=jamles
  }


  getDataWithoutID(){
    return {
      idpaket :this.idpaket,
      idsiswa:this.idsiswa,
      tglles :this.tglles,
      jamles : this.jamles,
    }
  }
}


export type LesInterface = {
  idles:number,
  idpaket:number,
  idsiswa:number,
  tglles:string,
  jamles:string
}