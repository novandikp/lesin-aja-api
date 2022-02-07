
import {IDatabase, IMain} from 'pg-promise';
import { Wali, WaliInterface } from "../../Entity/Wali"
import  FilterUpdate  from '../../Util/FilterUpdate';
export default class WaliRepository {
    private limit:number = 10
    private offset:number=0
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    setOffset(page:number){
        this.offset = (page-1) * this.limit
    }

    all({page=1,wali="",orderBy="wali",sort="ASC"}:ParameterQuery) : Promise<Wali[]> {
        this.setOffset(page)
        return this.db.any("SELECT * FROM tblwali WHERE (wali ilike '%$1:raw%' or email ilike '%$1:raw%') ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
          [wali, orderBy,sort,this.limit,this.offset]
        )
    }


    async getByEmail(email:String): Promise<Wali > {
        return this.db.one("SELECT * FROM tblwali where email=$1 LIMIT 1",[email])
    }

    async getById(id:number): Promise<Wali > {
        return this.db.one("SELECT * FROM tblwali where idwali=$1 LIMIT 1",[id])
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

type ParameterQuery ={
    page:number
    wali:String
    orderBy:String
    sort:String
}