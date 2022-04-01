export class BayarTutor  {
    public idbayartutor:number
    public idguru:number
    public idles:number
    public jumlah_gaji:number
    public bukti:string
    public tanggal_bayar:Date


    constructor({
        idguru,
        idles,
        jumlah_gaji,
        bukti,
        tanggal_bayar,
    }:BayarTutorInterface){
        this.idguru =idguru
        this.idles = idles
        this.jumlah_gaji = jumlah_gaji
        this.bukti = bukti
        this.tanggal_bayar = tanggal_bayar
    }


    dataWithoutID = ()=>{
        return {
            idguru :this.idguru,
            idles : this.idles,
            jumlah_gaji : this.jumlah_gaji,
            bukti : this.bukti,
            tanggal_bayar : this.tanggal_bayar
        }
    }
    

}


export type BayarTutorInterface ={
    idbayartutor:number
    idguru:number
    idles:number
    jumlah_gaji:number
    bukti:string
    tanggal_bayar:Date
}