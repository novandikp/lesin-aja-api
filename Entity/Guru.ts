export class Guru  {
    public idguru:number
    public guru:String;
    public jeniskelaminguru:String;
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


    constructor({
        idguru,
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
        this.idguru =idguru
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
        this.jeniskelaminguru =jeniskelaminguru
    }


    dataWithoutID = ()=>{
        return {
            guru: this.guru,
            jeniskelaminguru:this.jeniskelaminguru,
            idprovinsi : this.idprovinsi,
            idkabupaten : this.idkabupaten,
            idkecamatan : this.idkecamatan,
            iddesa : this.iddesa,
            alamat : this.alamat,
            email : this.email,
            telp:this.telp,
            perguruantinggi: this.perguruantinggi,
            jurusan: this. jurusan,
            mapel : this. mapel,
            pernahmengajar: this.pernahmengajar,
            lokasimengajar: this.lokasimengajar,
            lamamengajar : this.lamamengajar,
            rekening: this.rekening,
            bank: this.bank,
            file_cv: this.file_cv,
        }
    }
    

}


export type GuruInterface ={
    idguru:number,
    guru:String,
    idprovinsi:number,
    idkabupaten:number,
    idkecamatan:number
    iddesa:number,
    alamat:String,
    email:String,
    telp:String
    perguruantinggi:String
    jurusan:String
    mapel:String
    pernahmengajar:String
    lokasimengajar:String
    lamamengajar:number
    rekening:String
    bank:String
    file_cv:String
    jeniskelaminguru:String
}