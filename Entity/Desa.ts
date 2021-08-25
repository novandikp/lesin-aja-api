import  Region  from "Region";

export default class Desa implements Region{
    public id: number;
    public nama: string;
    public district_id:number
    constructor(id:number,nama:string,district_id:number){
        this.id= id
        this.nama =nama
        this.district_id =district_id
    }

}