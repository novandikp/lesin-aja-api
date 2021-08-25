export class Status {
    public static readonly AKTIF = 1;
    public static readonly NONAKTIF = 0;

    public static getStatus(status:number){
        return status==this.AKTIF
    }
}