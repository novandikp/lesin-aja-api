import { Posisi } from "../Entity/Posisi"
import { Guru, GuruInterface } from './../Entity/Guru';
import { encrypt } from "../Util/Encrypt"

export class GuruBuilder{
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
  constructor(email){
    this.email =email
  }

  build() :Guru{
    return new Guru(this)
  }
}