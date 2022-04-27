export class Rekap_Mengajar {
    public idles: number;
    public idguru: number;
    public jumlahmengajar: number;
    public alasan: string;
    public statusles: number;

    constructor(idles,idguru,  alasan, statusles) {
        this.idles = idles;
        this.idguru = idguru;
        this.alasan = alasan;
        this.statusles = statusles;
    }

}


export default interface RekapMengajar{
    idles:number
    idguru:number
    guru:string
    siswa:string
    tglles:string
    jeniskelamin:string
    jumlah_pertemuan:number
    jumlah_mengajar:number
    gaji:number
    statusles:number
}