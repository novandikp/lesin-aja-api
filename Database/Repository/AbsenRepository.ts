import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import  { Absen,AbsenInterface } from "../../Entity/Absen"


export default class AbsenRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  all({page=1,absen="",orderBy="absen",sort="ASC"}:ParameterQuery) : Promise<Absen[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblabsen WHERE absen ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [absen, orderBy,sort,this.limit,this.offset]
    )
  }

  add(absen:AbsenInterface):Promise<Absen>{
    const dataAbsen = new Absen(absen)
    return this.db.one("INSERT INTO tblabsen (${this:name}) VALUES (${this:list}) RETURNING *", dataAbsen.getDataWithoutID())
  }

  edit(absen:AbsenInterface, idabsen:number):Promise<Absen>{
    const dataAbsen = new Absen(absen)
    const data = new FilterUpdate(dataAbsen.getDataWithoutID(),this.pgp)
    return this.db.one("UPDATE tblabsen set $1:raw WHERE idabsen=$2 RETURNING *", [
      data,idabsen
    ])
  }


  remove(idabsen:number):Promise<Absen>{
    return this.db.one("DELETE FROM tblabsen WHERE idabsen=$1 RETURNING *",[
      idabsen
    ])
  }

}


type ParameterQuery ={
  page:number
  absen:String
  orderBy:String
  sort:String
}