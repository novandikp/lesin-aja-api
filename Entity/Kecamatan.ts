import  Region  from "./Region";

export default class Kecamatan implements Region{
    public id: number;
    public nama: string;
    public regency_id:number;
    constructor(id:number,nama:string,regency_id:number){
        this.id= id
        this.nama =nama
        this.regency_id= regency_id
    }

}