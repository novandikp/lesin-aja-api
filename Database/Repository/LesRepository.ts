import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import  { Les,LesInterface } from "../../Entity/Les"
import { ViewLes } from "../../Entity/ViewLes"
import RekapLes from "../../Entity/RekapLes"
import RekapMengajar from "../../Entity/RekapMengajar"
import StatusLes from "../../Entity/StatusLes"


export default class LesRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }
  
  all({page=1,cari="",orderBy="paket",sort="ASC"}:ParameterQuery) : Promise<ViewLes[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM view_les WHERE (siswa ilike '%$1:raw%' or wali ilike '%$1:raw%') ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [cari, orderBy,sort,this.limit,this.offset]
    )
  }

  allWithStatus({page=1,cari="",orderBy="paket",sort="ASC"}:ParameterQuery,status) : Promise<ViewLes[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM view_les WHERE (siswa ilike '%$1:raw%' or wali ilike '%$1:raw%') and statusles = $2 ORDER BY $3:name $4:raw LIMIT $5 OFFSET $6",
      [cari,status, orderBy,sort,this.limit,this.offset]
    )
  }


  get(index){
      return this.db.one(`SELECT tblles.*,idguru,statuslowongan, idortu, tblpaket.jumlah_pertemuan, biaya,siswa, tblpaket.jenjang,kelas, jeniskelamin,gaji 
      FROM tblles 
      inner join tblpaket on tblpaket.idpaket = tblles.idpaket
      inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
      left JOIN tbllowongan ON tbllowongan.idles = tblles.idles and statuslowongan=3
      left JOIN tblapplylowongan ON tblapplylowongan.idlowongan = tbllowongan.idlowongan
    where tblles.idles = $1`, [index])
  }

  getByGuruStatus(idguru, statusLes = StatusLes.SELESAI){
    return this.db.any(`SELECT tblles.*,idguru,statuslowongan, idortu, tblpaket.jumlah_pertemuan, biaya,siswa, tblpaket.jenjang,kelas, jeniskelamin,gaji 
    FROM tblles 
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
    left JOIN tbllowongan ON tbllowongan.idles = tblles.idles and statuslowongan=3
    left JOIN tblapplylowongan ON tblapplylowongan.idlowongan = tbllowongan.idlowongan
  where tblapplylowongan.idguru = $1 and tblles.statusles=$2`, [idguru,statusLes])
}

  getApply(index){
    return this.db.one(`SELECT tblles.*,idguru,statuslowongan, tblpaket.jumlah_pertemuan, biaya,siswa, tblpaket.jenjang,kelas, jeniskelamin,gaji 
    FROM tblles 
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
    left JOIN tbllowongan ON tbllowongan.idles = tblles.idles and statuslowongan=3
    left JOIN tblapplylowongan ON tblapplylowongan.idlowongan = tbllowongan.idlowongan and  tblapplylowongan.statusapply = 1
  where tblles.idles = $1`, [index])
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

    return this.db.any(`SELECT tblles.*, tblpaket.paket, tblpaket.jumlah_pertemuan, biaya,siswa,
    tblpaket.jenjang,kelas, jeniskelamin,wali,guru  FROM tblles
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
    inner join tblwali on tblwali.idwali = tblsiswa.idortu
    left join tblabsen on tblabsen.idles = tblles.idles
    left join tblguru on tblabsen.idguru = tblguru.idguru
      where 
      (paket ilike '%$1:raw%' or siswa ilike '%$1:raw%') 
      and idwali = $2 
      group by tblles.idles, tblpaket.idpaket, tblguru.idguru, tblsiswa.idsiswa, tblwali.idwali
      order by $3:name $4:raw
      LIMIT $5 OFFSET $6`,
      [cari,idortu,orderBy,sort,this.limit,this.offset])
  }

  historyByParentStatus({page=1,cari="",orderBy="paket",sort="ASC"}:ParameterQuery, idortu, status){
    this.setOffset(page)

    return this.db.any(`SELECT tblles.*, tblpaket.paket, tblpaket.jumlah_pertemuan, biaya,siswa,
    tblpaket.jenjang,kelas, jeniskelamin,wali,guru  FROM tblles
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
    inner join tblwali on tblwali.idwali = tblsiswa.idortu
    left join tblabsen on tblabsen.idles = tblles.idles
    left join tblguru on tblabsen.idguru = tblguru.idguru
      where statusles = $1 and 
      (paket ilike '%$2:raw%' or siswa ilike '%$2:raw%') 
      and idwali = $3 
      group by tblles.idles, tblpaket.idpaket, tblguru.idguru, tblsiswa.idsiswa, tblwali.idwali
      order by $4:name $5:raw
      LIMIT $6 OFFSET $7`,
      [status,cari,idortu,orderBy,sort,this.limit,this.offset])
  }

  remove(idles:number):Promise<Les>{
    return this.db.one("DELETE FROM tblles WHERE idles=$1 RETURNING *",[
      idles
    ])
  }

  cekStatusLes(idabsen:number):Promise<RekapLes>{
    return this.db.oneOrNone(`select * from rekap_les where idles=$1`,idabsen)
  }

  getRekapMengajar({page=1,cari="",orderBy="paket",sort="ASC"}:ParameterQuery):Promise<RekapMengajar[]>{
    this.setOffset(page)
    return this.db.any(`select * from rekap_mengajar where   (guru ilike '%$1:raw%' or siswa ilike '%$1:raw%') 
    order by $2:name $3:raw
    LIMIT $4 OFFSET $5`,[cari,orderBy,sort,this.limit,this.offset]);
  }

  gerRekapMengajarByIdGuru(idguru:number):Promise<RekapMengajar>{
    return this.db.one(`select * from rekap_mengajar where idguru=$1`,idguru)
  }


}


type ParameterQuery ={
  page:number
  cari:String
  orderBy:String
  sort:String
}