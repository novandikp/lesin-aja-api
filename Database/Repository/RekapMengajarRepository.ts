import { Rekap_Mengajar } from './../../Entity/RekapMengajar';

import {IDatabase, IMain} from 'pg-promise';

export default class RekapMenagajarRepository {
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

   async addRekap(rekap:Rekap_Mengajar ):Promise<any>{
    const sqlJumlahMengajar = "SELECT count(*) as jumlah_mengajar from tblabsen where flagabsenwali=1 and flagabsen=1 and idles =$1 and idguru=$2"
    const {jumlah_mengajar} = await this.db.oneOrNone(sqlJumlahMengajar,[rekap.idles,rekap.idguru])
    const sqlInsert = "insert into tblrekapmengajar (idles, idguru,jumlah_mengajar, alasan, statusles) values ($1,$2,$3,$4,$5)";
    return this.db.none(sqlInsert, [rekap.idles, rekap.idguru, jumlah_mengajar, rekap.alasan, rekap.statusles])
    
   }
    
}