import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import { Siswa,SiswaInterface } from "../../Entity/Siswa"
import Lowongan from "../../Entity/Lowongan"
import StatusLowongan from "../../Entity/StatusLowongan"


export default class LowonganRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }



  getCurrentLowonganByLes(idles:number){
    return this.db.one("SELECT * FROM view_lowongan WHERE idles = $1 and statuslowongan=$2 LIMIT 1",[
      idles,StatusLowongan.PENDING
    ])
  }


  setStatusLowongan(idlowongan:number,status:number ){
    return this.db.none("UPDATE tbllowongan SET statuslowongan= $1 WHERE idlowongan = $2", [status,idlowongan]);
  }

  all({page=1,cari="",orderBy="idlowongan",sort="ASC"}:ParameterQuery){
    this.setOffset(page)
    return this.db.any("SELECT * FROM view_lowongan WHERE (paket ilike '%$1:raw%' or  jenjang ilike '%$1:raw%') ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [cari, orderBy,sort,this.limit,this.offset]
    )
  }

  getByRegion({page=1,cari="",orderBy="idlowongan",sort="ASC"}:ParameterQuery,tag_id){
    this.setOffset(page)
    return this.db.any("SELECT * FROM view_lowongan WHERE (paket ilike '%$1:raw%' or  jenjang ilike '%$1:raw%') and tag_id =$2  ORDER BY $3:name $4:raw LIMIT $5 OFFSET $6",
      [cari,tag_id, orderBy,sort,this.limit,this.offset]
    )
  }


  add(lowongan:Lowongan):Promise<Lowongan>{
    return this.db.one("INSERT INTO tbllowongan (${this:name}) VALUES (${this:list}) RETURNING *", lowongan.getDataWithoutId())
  }

  edit(lowongan:Lowongan, idlowongan:number):Promise<Lowongan>{

    const data = new FilterUpdate(lowongan.getDataWithoutId(),this.pgp)
    return this.db.one("UPDATE tbllowongan set $1:raw WHERE idlowongan=$2 RETURNING *", [
      data,idlowongan
    ])
  }

  remove(idlowongan:number):Promise<Lowongan>{
    return this.db.one("DELETE FROM tbllowongan WHERE idlowongan=$1 RETURNING *",[
      idlowongan
    ])
  }

}


type ParameterQuery ={
  page:number
  cari:String
  orderBy:String
  sort:String
}