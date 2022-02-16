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
  public pekerjaan:String;


  constructor(email){
    this.email =email
  }

  build() :Wali{
    return new Wali(this)
  }
}