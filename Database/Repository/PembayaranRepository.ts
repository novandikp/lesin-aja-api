import { IDatabase, IMain } from "pg-promise"
import { Pembayaran, PembayaranInterface } from "../../Entity/Pembayaran"


export default class PembayaranRepository {
  private limit: number = 10
  private offset: number = 0

  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }
  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  add(pembayaran:PembayaranInterface):Promise<Pembayaran>{
    const dataBayar = new Pembayaran(pembayaran)
    return this.db.one("INSERT INTO tblbayar (${this:name}) VALUES (${this:list}) RETURNING *", dataBayar.getDataWithoutID())
  }

}
