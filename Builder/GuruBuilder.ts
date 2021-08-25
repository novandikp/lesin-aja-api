import { Guru, GuruInterface } from './../Entity/Guru';
export class GuruBuilder  {
    public idguru:number
    public guru:String;
    public idprovinsi:number;
    public idkabupaten:number;
    public idkecamatan:number
    public iddesa:number;
    public alamat:String;
    public email:String;
    public telp:String;
    public perguruantinggi:String
    public jurusan:String
    public mapel:String
    public pernahmengajar:String
    public lokasimengajar:String
    public lamamengajar:number
    public rekening:String
    public bank:String
    public file_cv:String
    public jeniskelaminguru:String

    constructor({
        guru,
        idprovinsi,
        idkabupaten,
        idkecamatan,
        iddesa,
        alamat,
        email,
        telp,
        perguruantinggi,
        jurusan,
        mapel,
        pernahmengajar,
        lokasimengajar,
        lamamengajar,
        rekening,
        bank,
        file_cv,
        jeniskelaminguru 
    }:GuruInterface){
        this.jeniskelaminguru = jeniskelaminguru
        this.guru= guru,
        this.idprovinsi = idprovinsi,
        this.idkabupaten = idkabupaten,
        this.idkecamatan = idkecamatan,
        this.iddesa = iddesa,
        this.alamat = alamat,
        this.email = email,
        this.telp=telp,
        this.perguruantinggi= perguruantinggi
        this.jurusan=  jurusan
        this.mapel =  mapel
        this.pernahmengajar= pernahmengajar
        this.lokasimengajar= lokasimengajar
        this.lamamengajar = lamamengajar
        this.rekening= rekening
        this.bank= bank
        this.file_cv= file_cv
    }


    setIdGuru(idguru:number){
        this.idguru = idguru
    }
    
    build():Guru{
        return new Guru(this)
    }
}

