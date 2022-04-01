import { BayarTutorInterface } from './../../Entity/BayarTutor';
import {IDatabase, IMain} from 'pg-promise';
export default class BayarTutorRepository{
    private limit:number = 10
    private offset:number=0
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    setOffset(page:number){
        this.offset = (page-1) * this.limit
    }

    async all(data:any):Promise<any>{
        const {page=1,cari="",orderBy="idguru",sort="ASC"} = data
        this.setOffset(page)
        return this.db.any(`select tanggalbayar,jumlah_gaji,bukti, tblbayartutor.idles, tblbayartutor.idguru, guru, idsiswa, siswa, tglles, jeniskelamin, jumlah_pertemuan, jumlah_mengajar, gaji, statusles  from tblbayartutor inner join rekap_mengajar on rekap_mengajar.idles = tblbayartutor.idles and rekap_mengajar.idguru = tblbayartutor.idguru
        where   (guru ilike '%$1:raw%' or siswa ilike '%$1:raw%') 
            order by $2:name $3:raw
            LIMIT $4 OFFSET $5`,[cari,orderBy,sort,this.limit,this.offset])
    }

    async add(data:any): Promise<BayarTutorInterface> {
        data.tanggalbayar = new Date()
        return this.db.oneOrNone("INSERT INTO tblbayartutor (${this:name}) VALUES (${this:list}) RETURNING *", data)
    }
}