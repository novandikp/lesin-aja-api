import  Region  from "./Region";

export default class Kota implements Region{
    public id: number;
    public nama: string;
    public province_id:number
    constructor(id:number,nama:string, province_id:number){
        this.id= id
        this.nama =nama
        this.province_id =province_id
    }

}