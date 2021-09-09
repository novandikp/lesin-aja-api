export default class ApplyLowongan{
  public idapplylowongan:number
  public idlowongan:number
  public idguru:number
  public statusapply:number


  constructor( idlowongan: number, idguru: number, statusapply: number) {
    this.idlowongan = idlowongan
    this.idguru = idguru
    this.statusapply = statusapply
  }

  getDataWithoutId(){
    return {
       idlowongan :this.idlowongan,
       idguru :this.idguru,
       statusapply :this.statusapply,
    }
  }
}