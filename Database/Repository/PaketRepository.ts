import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import Paket, { PaketInterface } from "../../Entity/Paket"


export default class PaketRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  all({page=1,paket="",orderBy="paket",sort="ASC"}:ParameterQuery) : Promise<Paket[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblpaket WHERE paket ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [paket, orderBy,sort,this.limit,this.offset]
    )
  }


  get(index):Promise<Paket>{
    return this.db.one("SELECT * FROM tblpaket where idpaket = $1", [index])
  }

  add(paket:PaketInterface):Promise<Paket>{
    const dataPaket = new Paket(paket)
    return this.db.one("INSERT INTO tblpaket (${this:name}) VALUES (${this:list}) RETURNING *", dataPaket.getDataWithoutID())
  }

  edit(paket:PaketInterface, idpaket:number):Promise<Paket>{
    const dataPaket = new Paket(paket)
    const data = new FilterUpdate(dataPaket.getDataWithoutID(),this.pgp)
    return this.db.one("UPDATE tblpaket set $1:raw WHERE idpaket=$2 RETURNING *", [
      data,idpaket
    ])
  }


  remove(idpaket:number):Promise<Paket>{
    return this.db.one("DELETE FROM tblpaket WHERE idpaket=$1 RETURNING *",[
      idpaket
    ])
  }

}


type ParameterQuery ={
  page:number
  paket:String
  orderBy:String
  sort:String
}