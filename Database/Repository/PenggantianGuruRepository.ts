import {IDatabase, IMain} from 'pg-promise';
import Payload from '../../Entity/Payload';
import PenggantianGuru, { StatusPenggantian } from '../../Entity/PenggantianGuru';
import { Posisi } from '../../Entity/Posisi';
export default class PenggantianGuruRepository{
    private limit:number = 10
    private offset:number=0
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    setOffset(page:number){
        this.offset = (page-1) * this.limit
    }

    isExistsRequest(idles:number):Promise<any>{
        const sqlQuery = `SELECT idpenggantian FROM tblpenggantianguru WHERE idles = $1 and status= $2 limit 1`

        return this.db.oneOrNone(sqlQuery,[idles, StatusPenggantian.DELAY])
    }


    all(data:any, context:Payload):Promise<any>{
        const {page=1,cari="",orderBy="idpenggantian",sort="ASC", status="NONE"} = data
        const {posisi, idchild} = context;
        const statusData = [
            "PENDING",
            "TERKONFIRMASI",
            "DITOLAK"
        ]

        let filterStatus = ""
        if(statusData.indexOf(status) >= 0){
            filterStatus = " and tblpenggantianguru.status = " + statusData.indexOf(status)
        }
        this.setOffset(page)
        let sqlQuery;
        if(posisi == Posisi.WALI){
            sqlQuery = `SELECT idpenggantian, tblpenggantianguru.alasan, tglpenggantian,tblpenggantianguru.status ,tblles.*,tblguru.idguru,statuslowongan, idortu, tblpaket.jumlah_pertemuan, biaya,siswa, tblpaket.jenjang,kelas, tblsiswa.jeniskelamin,gaji,
            tblguru.guru 
            FROM tblpenggantianguru
            inner join tblles on tblpenggantianguru.idles = tblles.idles 
            inner join tblpaket on tblpaket.idpaket = tblles.idpaket
            inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
            left JOIN tbllowongan ON tbllowongan.idles = tblles.idles and statuslowongan=3
            left JOIN tblapplylowongan ON tblapplylowongan.idlowongan = tbllowongan.idlowongan and  tblapplylowongan.statusapply = 3
            left JOIN tblguru ON tblguru.idguru = tblapplylowongan.idguru
            WHERE (guru ILIKE '%${cari}%' or siswa ILIKE '%${cari}%') and idortu='${idchild}' ${filterStatus}
            ORDER BY "${orderBy}" ${sort} LIMIT ${this.limit} OFFSET ${this.offset}`
        }else{
            sqlQuery = `SELECT idpenggantian, tblpenggantianguru.alasan, tglpenggantian,tblpenggantianguru.status ,tblles.*,tblguru.idguru,statuslowongan, idortu, tblpaket.jumlah_pertemuan, biaya,siswa, tblpaket.jenjang,kelas, tblsiswa.jeniskelamin,gaji,
            tblguru.guru 
            FROM tblpenggantianguru
            inner join tblles on tblpenggantianguru.idles = tblles.idles 
            inner join tblpaket on tblpaket.idpaket = tblles.idpaket
            inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
            left JOIN tbllowongan ON tbllowongan.idles = tblles.idles and statuslowongan=3
            left JOIN tblapplylowongan ON tblapplylowongan.idlowongan = tbllowongan.idlowongan and  tblapplylowongan.statusapply = 3
            left JOIN tblguru ON tblguru.idguru = tblapplylowongan.idguru
            WHERE (guru ILIKE '%${cari}%' or siswa ILIKE '%${cari}%')  ${filterStatus}
            ORDER BY "${orderBy}" ${sort} LIMIT ${this.limit} OFFSET ${this.offset}`   
        }
        
        return this.db.any(sqlQuery);
    }


    get(idpenggantian:number):Promise<any>{
        const sqlQuery =`SELECT idpenggantian, tblpenggantianguru.alasan, tglpenggantian,tblpenggantianguru.status ,tblles.*,idguru,statuslowongan, idortu, tblpaket.jumlah_pertemuan, biaya,siswa, tblpaket.jenjang,kelas, tblsiswa.jeniskelamin,gaji
        FROM tblpenggantianguru
        inner join tblles on tblpenggantianguru.idles = tblles.idles 
        inner join tblpaket on tblpaket.idpaket = tblles.idpaket
        inner join tblsiswa on tblsiswa.idsiswa = tblles.idsiswa
        left JOIN tbllowongan ON tbllowongan.idles = tblles.idles and statuslowongan=3
        left JOIN tblapplylowongan ON tblapplylowongan.idlowongan = tbllowongan.idlowongan  and  tblapplylowongan.statusapply = 3 
        where idpenggantian = $1`;
        return this.db.oneOrNone(sqlQuery,[idpenggantian])
    }

    add(data:PenggantianGuru):Promise<PenggantianGuru>{
        const sqlQuery = `INSERT INTO tblpenggantianguru (idles,alasan,tglpenggantian,status) VALUES ($1,$2,$3,$4) RETURNING *`
        return this.db.oneOrNone(sqlQuery,[data.idles,data.alasan,data.tglpenggantian,data.status])
    }

    

    set(idpenggantian:number,data:PenggantianGuru):Promise<PenggantianGuru>{
        const sqlQuery = `UPDATE tblpenggantianguru SET idles=$1,alasan=$2,tglpenggantian=$3,status=$4 WHERE idpenggantian=$5 RETURNING *`
        return this.db.oneOrNone(sqlQuery,[data.idles,data.alasan,data.tglpenggantian,data.status,idpenggantian])
    }
}