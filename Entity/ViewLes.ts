import { type } from "os"

export class ViewLes{
    public idles:number
    public idpaket:number
    public idsiswa:number
    public tglles:string
    public jamles:string
    public hari:string
    public statusles:string
    public jumlah_pertemuan:number
    public biaya:number
    public siswa:string
    public jenjang:string
    public kelas:string
    public jeniskelamin:string
    public gaji:number
    public idwali:number
    public email:string
    public alamat:string

}

export type ViewLesInterface = {
     idles:number,
     idpaket:number,
     idsiswa:number,
     tglles:string,
     jamles:string,
     hari:string,
     statusles:string,
     jumlah_pertemuan:number,
     biaya:number,
     siswa:string,
     jenjang:string,
     kelas:string,
     jeniskelamin:string,
     gaji:number,
     idwali:number,
     email:string,
     alamat:string
}