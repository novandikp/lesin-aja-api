import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import { Siswa,SiswaInterface } from "../../Entity/Siswa"
import ApplyLowongan from "../../Entity/ApplyLowongan"
import StatusLowongan from "../../Entity/StatusLowongan"


export default class ApplyLowonganRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  get(id:number){
    return this.db.one("SELECT * FROM tblapplylowongan WHERE idapplylowongan=$1",[id])
  }

  all({page=1,cari="",orderBy="idapplylowongan",sort="ASC"}:ParameterQuery){
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblapplylowongan WHERE siswa ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [cari, orderBy,sort,this.limit,this.offset]
    )
  }

  getByLes({page=1,cari="",orderBy="idapplylowongan",sort="ASC"}:ParameterQuery,tag_id){
    this.setOffset(page)
    console.log(this.pgp.as.format("SELECT * FROM view_pelamar WHERE (paket ilike '%$1:raw%' or  guru ilike '%$1:raw%') and idles =$2  ORDER BY $3:name $4:raw LIMIT $5 OFFSET $6",
      [cari,tag_id, orderBy,sort,this.limit,this.offset]))
    return this.db.any("SELECT * FROM view_pelamar WHERE (paket ilike '%$1:raw%' or  guru ilike '%$1:raw%') and idles =$2  ORDER BY $3:name $4:raw LIMIT $5 OFFSET $6",
      [cari,tag_id, orderBy,sort,this.limit,this.offset]
    )
  }

  add(lowongan:ApplyLowongan):Promise<ApplyLowongan>{
    return this.db.one("INSERT INTO tblapplylowongan (${this:name}) VALUES (${this:list}) RETURNING *", lowongan.getDataWithoutId())
  }

  async applyLowongan(id:number, idlowongan:number,statusKonfirmasi){
    // tolak lainnya
    this.db.none("UPDATE tblap  plylowongan SET statusapply = $1 where idapplylowongan!=$2 and idlowongan=$3",[
      StatusLowongan.TERAMBIL,id, idlowongan
    ])
    //terima salah satu proposal
    return this.db.one("UPDATE tblapplylowongan SET statusapply = $1 where idapplylowongan=$2 and idlowongan=$3 RETURNING *",[
      statusKonfirmasi,id, idlowongan
    ]);
  }



  edit(lowongan:ApplyLowongan, idapplylowongan:number):Promise<ApplyLowongan>{

    const data = new FilterUpdate(lowongan.getDataWithoutId(),this.pgp)
    return this.db.one("UPDATE tblapplylowongan set $1:raw WHERE idapplylowongan=$2 RETURNING *", [
      data,idapplylowongan
    ])
  }

  remove(idlowongan:number):Promise<ApplyLowongan>{
    return this.db.one("DELETE FROM tblapplylowongan WHERE idlowongan=$1 RETURNING *",[
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