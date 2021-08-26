import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import  { Les,LesInterface } from "../../Entity/Les"


export default class LesRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  all({page=1,les="",orderBy="les",sort="ASC"}:ParameterQuery) : Promise<Les[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblles WHERE les ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [les, orderBy,sort,this.limit,this.offset]
    )
  }

  add(les:LesInterface):Promise<Les>{
    const dataLes = new Les(les)
    return this.db.one("INSERT INTO tblles (${this:name}) VALUES (${this:list}) RETURNING *", dataLes.getDataWithoutID())
  }

  edit(les:LesInterface, idles:number):Promise<Les>{
    const dataLes = new Les(les)
    const data = new FilterUpdate(dataLes.getDataWithoutID(),this.pgp)
    return this.db.one("UPDATE tblles set $1:raw WHERE idles=$2 RETURNING *", [
      data,idles
    ])
  }


  remove(idles:number):Promise<Les>{
    return this.db.one("DELETE FROM tblles WHERE idles=$1 RETURNING *",[
      idles
    ])
  }

}


type ParameterQuery ={
  page:number
  les:String
  orderBy:String
  sort:String
}