import  Region  from "./Region";

export default class Provinsi implements Region{
    public id: number;
    public nama: string;
    constructor(id:number,nama:string){
        this.id= id
        this.nama =nama
    }

}