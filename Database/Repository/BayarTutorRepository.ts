import { BayarTutorInterface } from './../../Entity/BayarTutor';
import {IDatabase, IMain} from 'pg-promise';
export default class BayarTutorRepository{
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    async add(data:any): Promise<BayarTutorInterface> {
        data.tanggalbayar = new Date()
        return this.db.oneOrNone("INSERT INTO tblbayartutor (${this:name}) VALUES (${this:list}) RETURNING *", data)
    }
}