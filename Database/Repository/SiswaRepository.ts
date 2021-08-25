import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import { Siswa,SiswaInterface } from "../../Entity/Siswa"


export default class SiswaRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  all({page=1,siswa="",orderBy="siswa",sort="ASC"}:ParameterQuery) : Promise<Siswa[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblsiswa WHERE siswa ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [siswa, orderBy,sort,this.limit,this.offset]
    )
  }

  getByParent({page=1,siswa="",orderBy="siswa",sort="ASC"}:ParameterQuery,idparent:number) : Promise<Siswa[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblsiswa WHERE siswa ilike '%$1:raw%' and idortu=$2 ORDER BY $3:name $4:raw LIMIT $5 OFFSET $6",
      [siswa,idparent, orderBy,sort,this.limit,this.offset]
    )
  }

  add(siswa:SiswaInterface):Promise<Siswa>{
    const dataSiswa = new Siswa(siswa)
    return this.db.one("INSERT INTO tblsiswa (${this:name}) VALUES (${this:list}) RETURNING *", dataSiswa.getDataWithoutID())
  }

  edit(siswa:SiswaInterface, idsiswa:number):Promise<Siswa>{
    const dataSiswa = new Siswa(siswa)
    const data = new FilterUpdate(dataSiswa.getDataWithoutID(),this.pgp)
    return this.db.one("UPDATE tblsiswa set $1:raw WHERE idsiswa=$2 RETURNING *", [
      data,idsiswa
    ])
  }


  remove(idsiswa:number):Promise<Siswa>{
    return this.db.one("DELETE FROM tblsiswa WHERE idsiswa=$1 RETURNING *",[
      idsiswa
    ])
  }

}


type ParameterQuery ={
  page:number
  siswa:String
  orderBy:String
  sort:String
}