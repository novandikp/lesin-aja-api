import { IDatabase, IMain } from "pg-promise"
import FilterUpdate from "../../Util/FilterUpdate"

import Keuangan from "../../Entity/Keungan"


export default class KeuanganRepository {
  private limit:number = 10
  private offset:number=0
  constructor(private db: IDatabase<any>, private pgp: IMain) {
  }

  setOffset(page:number){
    this.offset = (page-1) * this.limit
  }

  all({page=1,cari="",orderBy="idkeuangan",sort="ASC"}:ParameterQuery){
    this.setOffset(page)
    return this.db.any("SELECT * FROM tblkeuangan WHERE idkeuangan ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
      [cari, orderBy,sort,this.limit,this.offset]
    )
  }

   
  
  async rekap({page=1,cari="",orderBy="idkeuangan",sort="ASC", startDate=undefined,endDate=undefined}:ParameterQueryRekap){
    this.setOffset(page)
    
    const {saldo}= await  this.db.one("select COALESCE(sum(masuk -keluar)) as saldo from tblkeuangan")
    
    let rekap:Keuangan[]
   
    if (startDate && endDate){
      rekap = await this.db.any("select *,sum(masuk-keluar) over (order by tglkeuangan, idkeuangan) as saldo from tblkeuangan WHERE keterangan ilike '%$1:raw%' and tglkeuangan between '%$6:raw%' and '%$7:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
        [cari, orderBy,sort,this.limit,this.offset, startDate,endDate]
      )
     
    }else{
      rekap = await this.db.any("select *,sum(masuk-keluar) over (order by tglkeuangan, idkeuangan) as saldo from tblkeuangan WHERE keterangan ilike '%$1:raw%' ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
        [cari, orderBy,sort,this.limit,this.offset]
      )
    }
    let data:ResponseRekap = {data:rekap, saldo:saldo}
    return data;
  }

  getSaldo

  add(keuangan:Keuangan):Promise<Keuangan>{
    return this.db.one("INSERT INTO tblkeuangan (${this:name}) VALUES (${this:list}) RETURNING *", keuangan.getDataWithoutID())
  }

  edit(keuangan:Keuangan, idkeuangan:number):Promise<Keuangan>{

    const data = new FilterUpdate(keuangan.getDataWithoutID(),this.pgp)
    return this.db.one("UPDATE tblkeuangan set $1:raw WHERE idkeuangan=$2 RETURNING *", [
      data,idkeuangan
    ])
  }

  remove(idkeuangan:number):Promise<Keuangan>{
    return this.db.one("DELETE FROM tblkeuangan WHERE idkeuangan=$1 RETURNING *",[
      idkeuangan
    ])
  }

}
type ParameterQuery ={
  page:number
  cari:String
  orderBy:String
  sort:String
}

type ResponseRekap={
  saldo:number
  data:Keuangan[]
}

type ParameterQueryRekap ={
  page:number
  cari:String
  orderBy:String
  sort:String,
  startDate:String,
  endDate:String
}