import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
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



  getCurrentLowonganByLes(idles:number, status = StatusLowongan.PENDING){
    return this.db.oneOrNone("SELECT * FROM view_lowongan WHERE idles = $1 and statuslowongan=$2  order by idlowongan desc LIMIT 1",[
      idles,status
    ])
  }

  async disableRecent (idles)  {
    //  delete tblappylowongan
    await this.db.any(`update tblapplylowongan set statusapply=4 where idapplylowongan in 
     (select idapplylowongan from view_pelamar where statusapply=3 and idles=$1 ) `, [idles]);
     await this.db.any('update tbllowongan set statuslowongan=4 where idles=$1',[idles]);
     return true;
  }


  setStatusLowongan(idlowongan:number,status:number ){
    return this.db.none("UPDATE tbllowongan SET statuslowongan= $1 WHERE idlowongan = $2", [status,idlowongan]);
  }

  all({page=1,cari="",orderBy="idlowongan",sort="ASC", jenjang=undefined,prefrensi=''}:ParameterQuery){
    this.setOffset(page)

    let jenjangQuery = jenjang ? ` and jenjang = '$6:raw' ` : ""
    return this.db.any("SELECT * FROM view_lowongan WHERE paket ilike '%$1:raw%' "+jenjangQuery+" and (prefrensi = '$7:raw' or prefrensi = 'Bebas') ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [cari, orderBy,sort,this.limit,this.offset, jenjang, prefrensi]
    )
  }

  getByRegion({page=1,cari="",orderBy="idlowongan",sort="ASC", jenjang=undefined,prefrensi=''}:ParameterQuery,tag_id){
    this.setOffset(page)
    let jenjangQuery = jenjang ? ` and jenjang = '$7:raw' ` : ""
    return this.db.any("SELECT * FROM view_lowongan WHERE paket ilike '%$1:raw%' "+jenjangQuery+" and (prefrensi = '$8:raw' or prefrensi = 'Bebas')  and tag_id =$2  ORDER BY $3:name $4:raw LIMIT $5 OFFSET $6",
      [cari,tag_id, orderBy,sort,this.limit,this.offset,jenjang, prefrensi]
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

  batal(idles:number){
  // Batalkan apply lowongan
    this.db.none ("UPDATE tblapplylowongan SET statusapply = $1 WHERE idlowongan in (select idlowongan from tbllowongan where idles = $2)",[StatusLowongan.BATAL,idles])
    return this.db.none("UPDATE tbllowongan SET statuslowongan= $1 WHERE idles = $2", [StatusLowongan.BATAL,idles]);
  }

}


type ParameterQuery ={
  page:number
  cari:String
  orderBy:String
  sort:String,
  prefrensi:String,
  jenjang:String
}