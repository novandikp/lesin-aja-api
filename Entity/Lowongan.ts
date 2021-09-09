export default class Lowongan{
  public idlowongan:number
  public idles:number
  public statuslowongan:number



  constructor(idles: number, statuslowongan: number) {
    this.idles = idles
    this.statuslowongan = statuslowongan

  }

  getDataWithoutId(){
    return {
      idles: this.idles,
      statuslowongan:this.statuslowongan,

    }
  }


}