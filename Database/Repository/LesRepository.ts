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

  all({page=1,cari="",orderBy="paket",sort="ASC"}:ParameterQuery) : Promise<Les[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblles WHERE les ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [cari, orderBy,sort,this.limit,this.offset]
    )
  }


  get(index){
      return this.db.one(`SELECT tblles.*, tblpaket.jumlah_pertemuan, biaya,siswa, jenjang,kelas, jeniskelamin,gaji 
      FROM tblles 
      inner join tblpaket on tblpaket.idpaket = tblles.idpaket
      inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
    where idles = $1`, [index])
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

  historyByParent({page=1,cari="",orderBy="paket",sort="ASC"}:ParameterQuery, idortu){
    this.setOffset(page)

    return this.db.any(`SELECT tblles.*, tblpaket.jumlah_pertemuan, biaya,siswa,
      jenjang,kelas, jeniskelamin,wali FROM tblles
      inner join tblpaket on tblpaket.idpaket = tblles.idpaket
      inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
      inner join tblwali on tblwali.idwali = tblsiswa.idortu
      where 
      (paket ilike '%$1:raw%' or siswa ilike '%$1:raw%') 
      and idwali = $2 
      order by $3:name $4:raw
      LIMIT $5 OFFSET $6`,
      [cari,idortu,orderBy,sort,this.limit,this.offset])
  }

  historyByParentStatus({page=1,cari="",orderBy="paket",sort="ASC"}:ParameterQuery, idortu, status){
    this.setOffset(page)

    return this.db.any(`SELECT tblles.*, tblpaket.jumlah_pertemuan, biaya,siswa,
      jenjang,kelas, jeniskelamin,wali FROM tblles
      inner join tblpaket on tblpaket.idpaket = tblles.idpaket
      inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
      inner join tblwali on tblwali.idwali = tblsiswa.idortu
      where statusles = $1 and 
      (paket ilike '%$2:raw%' or siswa ilike '%$2:raw%') 
      and idwali = $3 
      order by $4:name $5:raw
      LIMIT $6 OFFSET $7`,
      [status,cari,idortu,orderBy,sort,this.limit,this.offset])
  }


  remove(idles:number):Promise<Les>{
    return this.db.one("DELETE FROM tblles WHERE idles=$1 RETURNING *",[
      idles
    ])
  }

}


type ParameterQuery ={
  page:number
  cari:String
  orderBy:String
  sort:String
}