export class Siswa {
  public idsiswa:number
  public idortu:number
  public siswa:string
  public jeniskelamin:string
  public jenjang:string
  public kelas:string
  public sekolah:string

  constructor(
    {
      idsiswa,
      idortu,
      siswa,
      jeniskelamin,
      jenjang,
      kelas,
      sekolah
    }:SiswaInterface) {
    this.idsiswa = idsiswa
    this.idortu = idortu
    this.siswa = siswa
    this.jeniskelamin = jeniskelamin
    this.jenjang =jenjang
    this.kelas=kelas
    this.sekolah=sekolah
  }

  getDataWithoutID(){
    return {
      idortu:this.idortu ,
      siswa:this.siswa ,
      jeniskelamin:this.jeniskelamin ,
      jenjang:this.jenjang ,
      kelas:this.kelas,
      sekolah:this.sekolah
    }
  }
}


export type SiswaInterface =  {
 idsiswa:number
 idortu:number
 siswa:string
 jeniskelamin:string
 jenjang:string
 kelas:string
 sekolah:string
}