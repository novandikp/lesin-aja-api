
import {IDatabase, IMain} from 'pg-promise';
import { User, UserInterface } from '../../Entity/User';
import  FilterUpdate  from '../../Util/FilterUpdate';
export default class UserRepository {
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }


    async all(): Promise<User []> {
        return this.db.any("SELECT * FROM tbluser")
    }

    async get(iduser): Promise<UserInterface > {
        return this.db.one("SELECT * FROM tbluser where iduser=$1 LIMIT 1",[iduser])
    }

    async getByEmail(email:String): Promise<User > {
        return this.db.oneOrNone("SELECT * FROM tbluser where email=$1 LIMIT 1",[email])
    }

    async getByUsernameAndPassword(email:String,password:String) : Promise<User>{
        return this.db.one("select * from tbluser where status=true and email=$1 and password=$2",[email,password])
    }

    async add(user : User): Promise<User >{
        return this.db.one(
            "INSERT INTO tbluser (${this:name}) VALUES (${this:list}) RETURNING *"
            , 
        user.getDataWithoutID())
    }

    async edit(user :User, iduser:number) :Promise<User>{
        const data = new FilterUpdate(user,this.pgp)
        return this.db.one("UPDATE tbluser set $1:raw WHERE iduser=$2 RETURNING *", [
            data,iduser,
        ])
    }
}