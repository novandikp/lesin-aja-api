export default class StatusLowongan{
  
  public static readonly PENDING:number = 0
  public static readonly MENUNGGU_KONFIRMASI:number = 1
  public static readonly TERAMBIL:number = 2
  public static readonly DIKONFIRMASI:number = 3
  public static readonly BATAL:number = 4
  public static getStatus(flag:number){
    const data =["PENDING","MENUNGGU KONFIRMASI","TERAMBIL","DIKONFIRMASI","BATAL"]
    if(flag< 0){
      return "BELUM DIAMBIL"
    }else{
      return data[flag]
    }
  }
}