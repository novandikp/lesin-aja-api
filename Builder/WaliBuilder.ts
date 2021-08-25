
import { Wali } from './../Entity/Wali';

export class WaliBuilder{
    public idwali:number
    public wali:String;
    public idprovinsi:number;
    public idkabupaten:number;
    public idkecamatan:number
    public iddesa:number;
    public alamat:String;
    public email:String;
    public telp:String;
    constructor({
        wali,
        idprovinsi,
        idkabupaten,
        idkecamatan,
        iddesa,
        alamat,
        email,
        telp,
    }){
        
        this.wali= wali,
        this.idprovinsi = idprovinsi,
        this.idkabupaten = idkabupaten,
        this.idkecamatan = idkecamatan,
        this.iddesa = iddesa,
        this.alamat = alamat,
        this.email = email,
        this.telp=telp
    }


    setIdWali(idwali){
        this.idwali =idwali
    }

    build():Wali{
        return new Wali(this)
    }
    


}