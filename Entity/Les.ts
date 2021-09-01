export class Les  {
  public idles:number
  public idpaket:number
  public idsiswa:number
  public tglles:string
  public jamles:string
  public hari:string
  public statusles:number

  constructor({idles, idpaket,idsiswa, tglles,jamles,hari,statusles  }:LesInterface) {
      this.idles= idles
      this.idpaket=idpaket
      this.idsiswa=idsiswa
      this.tglles= tglles
      this.jamles=jamles
      this.hari = hari
      this.statusles = statusles
  }



  getDataWithoutID(){
    return {
      idpaket :this.idpaket,
      idsiswa:this.idsiswa,
      tglles :this.tglles,
      jamles : this.jamles,
      hari:this.hari,
      statusles:this.statusles
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
  statusles:number
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