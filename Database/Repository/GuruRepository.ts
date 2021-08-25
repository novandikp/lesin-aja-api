
import {IDatabase, IMain} from 'pg-promise';
import { Guru } from '../../Entity/Guru';
import { Wali } from "../../Entity/Wali"
export default class GuruRepository {
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    async all(): Promise<Guru []> {
        return this.db.any("SELECT * FROM tblguru")
    }

    async getByEmail(email:String): Promise<Guru > {
        return this.db.one("SELECT * FROM tblguru where email=$1 LIMIT 1",[email])
    }


    async add(guru : Guru): Promise<Guru >{
        return this.db.one("INSERT INTO tblguru (${this:name}) VALUES (${this:list}) RETURNING *", guru.dataWithoutID())
    }
    // async edit(Guru :Guru) :Promise<Guru>{
    //     return
    // }
    
}