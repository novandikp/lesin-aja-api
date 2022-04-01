import { log } from 'util';
import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"
import  { Absen,AbsenInterface } from "../../Entity/Absen"
import StatusAbsen from "../../Entity/StatusAbsen"
import RekapLes from '../../Entity/RekapLes';


export default class AbsenRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  all({page=1,cari="",orderBy="absen",sort="ASC"}:ParameterQuery) : Promise<Absen[]> {
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblabsen WHERE absen ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [cari, orderBy,sort,this.limit,this.offset]
    )
  }


  get(idabsen) {
    return this.db.one("SELECT * FROM tblabsen where idabsen=$1",[idabsen])
  }

  setGuruAbsen(idles, idguru){
    return this.db.any("UPDATE tblabsen SET idguru=$1,flagabsen=$2 where idles=$3 and flagabsen= 0 and idguru is null"
    ,[idguru,StatusAbsen.PENDING,idles])
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

  getBySiswa({page=1,cari="",orderBy="tglabsen",sort="ASC"}:ParameterQuery, idchild)  {
    this.setOffset(page)
    return this.db.any(`select idabsen,tblabsen.tglabsen, tblabsen.flagabsen,tblabsen.flagabsenwali,
    tblabsen.keterangan,tblabsen.keteranganwali,
    tblpaket.paket ,tblpaket.jumlah_pertemuan, 
    tblsiswa.siswa , tblsiswa.jenjang , tblsiswa.kelas,
    tblwali.alamat as alamat_wali,
    tblguru.guru ,tblguru.alamat as alamat_guru
     from tblabsen 
    inner join tblles  on tblles.idles = tblabsen.idles 
    inner join tblguru on tblguru.idguru  = tblabsen.idguru 
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket 
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa 
    inner join tblwali on tblwali.idwali  = tblsiswa.idortu
    where 
    (guru ilike '%$1:raw%' or paket ilike '%$1:raw%')
    and tblsiswa.idsiswa = $2
    order by $3:name $4:raw 
    limit $5:raw offset $6:raw`,
      [cari,idchild, orderBy,sort,this.limit,this.offset]
    )
  }


  getSisaJadwal(idchild)  {
    return this.db.query(`select idabsen,tblabsen.tglabsen, tblabsen.flagabsen,tblabsen.flagabsenwali,
    tblabsen.keterangan,tblabsen.keteranganwali,
    tblpaket.paket ,tblpaket.jumlah_pertemuan, 
    tblsiswa.siswa , tblsiswa.jenjang , tblsiswa.kelas,
    tblwali.alamat as alamat_wali,
    tblguru.guru ,tblguru.alamat as alamat_guru
     from tblabsen 
    inner join tblles  on tblles.idles = tblabsen.idles 
    inner join tblguru on tblguru.idguru  = tblabsen.idguru 
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket 
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa 
    inner join tblwali on tblwali.idwali  = tblsiswa.idortu
    WHERE idles=$1 and flagabsen=$2`,
      [idchild, StatusAbsen.PENDING]
    )
  }

  getByLes({page=1,cari="",orderBy="tglabsen",sort="ASC"}:ParameterQuery, idchild)  {
    this.setOffset(page)
    return this.db.any(`select idabsen,tblabsen.tglabsen, tblabsen.flagabsen,tblabsen.flagabsenwali,
    tblabsen.keterangan,tblabsen.keteranganwali,
    tblpaket.paket ,tblpaket.jumlah_pertemuan, 
    tblsiswa.siswa , tblsiswa.jenjang , tblsiswa.kelas,
    tblwali.alamat as alamat_wali,
    tblguru.guru ,tblguru.alamat as alamat_guru
     from tblabsen 
    inner join tblles  on tblles.idles = tblabsen.idles 
    inner join tblguru on tblguru.idguru  = tblabsen.idguru 
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket 
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa 
    inner join tblwali on tblwali.idwali  = tblsiswa.idortu
    where 
    (siswa ilike '%$1:raw%' or paket ilike '%$1:raw%')
    and tblles.idles = $2
    order by $3:name $4:raw 
    limit $5:raw offset $6:raw`,
      [cari,idchild, orderBy,sort,this.limit,this.offset]
    )
  }

  getByParent({page=1,cari="",orderBy="tglabsen",sort="ASC"}:ParameterQuery, idchild)  {
    this.setOffset(page)
    return this.db.any(`select idabsen,tblabsen.tglabsen, tblabsen.flagabsen, tblabsen.flagabsenwali,
    tblabsen.keterangan,tblabsen.keteranganwali,
    tblpaket.paket ,tblpaket.jumlah_pertemuan, 
    tblsiswa.siswa , tblsiswa.jenjang , tblsiswa.kelas,
    tblwali.alamat as alamat_wali,
    tblguru.guru ,tblguru.alamat as alamat_guru
     from tblabsen 
    inner join tblles  on tblles.idles = tblabsen.idles 
    inner join tblguru on tblguru.idguru  = tblabsen.idguru 
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket 
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa 
    inner join tblwali on tblwali.idwali  = tblsiswa.idortu
    where 
    (siswa ilike '%$1:raw%' or guru ilike '%$1:raw%' or paket ilike '%$1:raw%')
    and tblwali.idwali = $2
    order by $3:name $4:raw 
    limit $5:raw offset $6:raw`,
      [cari,idchild, orderBy,sort,this.limit,this.offset]
    )
  }

  getByTeacher({page=1,cari="",orderBy="tglabsen",sort="ASC"}:ParameterQuery, idchild)  {
    this.setOffset(page)
    return this.db.any(`select idabsen,tblabsen.tglabsen, tblabsen.flagabsen,tblabsen.flagabsenwali,
    tblabsen.keterangan,tblabsen.keteranganwali,
    tblpaket.paket ,tblpaket.jumlah_pertemuan, 
    tblsiswa.siswa , tblsiswa.jenjang , tblsiswa.kelas,
    tblwali.alamat as alamat_wali,
    tblguru.guru ,tblguru.alamat as alamat_guru
     from tblabsen 
    inner join tblles  on tblles.idles = tblabsen.idles 
    inner join tblguru on tblguru.idguru  = tblabsen.idguru 
    inner join tblpaket on tblpaket.idpaket = tblles.idpaket 
    inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa 
    inner join tblwali on tblwali.idwali  = tblsiswa.idortu
    where 
    (siswa ilike '%$1:raw%' or paket ilike '%$1:raw%')
    and tblguru.idguru = $2
    order by $3:name $4:raw 
    limit $5:raw offset $6:raw`,
      [cari,idchild, orderBy,sort,this.limit,this.offset]
    )
  }

 
}


type ParameterQuery ={
  page:number
  cari:String
  orderBy:String
  sort:String
}