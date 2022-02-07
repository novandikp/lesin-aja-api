
import {IDatabase, IMain} from 'pg-promise';
import { Guru, GuruInterface } from "../../Entity/Guru"
import FilterUpdate from "../../Util/FilterUpdate"
export default class GuruRepository {
    private limit:number = 10
    private offset:number=0
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    setOffset(page:number){
        this.offset = (page-1) * this.limit
    }

    all({page=1,guru="",orderBy="guru",sort="ASC"}:ParameterQuery) : Promise<Guru[]> {
        this.setOffset(page)
        return this.db.any("SELECT * FROM tblguru WHERE (guru ilike '%$1:raw%' or email ilike '%$1:raw%') ORDER BY $2:name $3:raw LIMIT $4 OFFSET $5",
          [guru, orderBy,sort,this.limit,this.offset]
        )
    }

    async getByEmail(email:String): Promise<Guru > {
        return this.db.one("SELECT * FROM tblguru where email=$1 LIMIT 1",[email])
    }

    async getByID(id:number):Promise<Guru>{
        return this.db.one("SELECT * FROM tblguru where idguru=$1 LIMIT 1",[id])
    }


    async add(guru : GuruInterface): Promise<Guru >{
        const dataGuru:Guru = new Guru(guru)
        return this.db.one("INSERT INTO tblguru (${this:name}) VALUES (${this:list}) RETURNING *", dataGuru.dataWithoutID())
    }

    async edit(guru :GuruInterface,idguru:number) :Promise<Guru>{
        const dataGuru:Guru = new Guru(guru)
        const data = new FilterUpdate(dataGuru.dataWithoutID(),this.pgp)
        return this.db.one("UPDATE tblguru set $1:raw WHERE idguru=$2 RETURNING *", [
            data, idguru
        ])
    }
    
}
type ParameterQuery ={
    page:number
    guru:String
    orderBy:String
    sort:String
}