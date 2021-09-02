export class Wali  {
    public idwali:number
    public wali:String;
    public idprovinsi:number;
    public idkabupaten:number;
    public idkecamatan:number
    public iddesa:number;
    public alamat:String;
    public email:String;
    public telp:String;
    public pekerjaan:String;
    constructor({
        idwali,
        wali,
        idprovinsi,
        idkabupaten,
        idkecamatan,
        iddesa,
        alamat,
        email,
        telp,
        pekerjaan
    }:WaliInterface){
        this.idwali=idwali
        this.wali= wali,
        this.idprovinsi = idprovinsi,
        this.idkabupaten = idkabupaten,
        this.idkecamatan = idkecamatan,
        this.iddesa = iddesa,
        this.alamat = alamat,
        this.email = email,
        this.telp=telp,
        this.pekerjaan=pekerjaan
    }


    dataWithoutId = ()=>{
        return {
            wali :this.wali,
            idprovinsi : this.idprovinsi,
            idkabupaten  : this.idkabupaten,
            idkecamatan : this.idkecamatan,
            iddesa : this.iddesa,
            alamat : this.alamat,
            email : this.email,
            telp : this.telp,
            pekerjaan:this.pekerjaan
        }
    }
    

}


export type WaliInterface ={
    idwali:number
    wali:String,
    idprovinsi:number,
    idkabupaten:number,
    idkecamatan:number
    iddesa:number,
    alamat:String,
    email:String,
    telp:String
    pekerjaan:String
}