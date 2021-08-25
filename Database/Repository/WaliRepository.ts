
import {IDatabase, IMain} from 'pg-promise';
import { Wali, WaliInterface } from "../../Entity/Wali"
import  FilterUpdate  from '../../Util/FilterUpdate';
export default class WaliRepository {
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    async all(): Promise<Wali []> {
        return this.db.any("SELECT * FROM tblwali")
    }

    async getByEmail(email:String): Promise<Wali > {
        return this.db.one("SELECT * FROM tblwali where email=$1 LIMIT 1",[email])
    }

    async get(idwali:number): Promise<Wali > {
        return this.db.one("SELECT * FROM tblwali where idwali=$1 LIMIT 1",[idwali])
    }


    async add(wali : Wali): Promise<Wali >{
        return this.db.one("INSERT INTO tblwali (${this:name}) VALUES (${this:list}) RETURNING *", wali.dataWithoutId())
    }

    async edit(wali :WaliInterface,idwali:number) :Promise<Wali>{
        const dataWali:Wali = new Wali(wali)
        const data = new FilterUpdate(dataWali.dataWithoutId(),this.pgp)
        return this.db.one("UPDATE tblwali set $1:raw WHERE idwali=$2 RETURNING *", [
            data, idwali
        ])
    }
    
}