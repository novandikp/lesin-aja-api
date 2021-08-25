import { Posisi } from "../Entity/Posisi"
import { User, UserInterface } from './../Entity/User';
import { encrypt } from "../Util/Encrypt"

export class UserBuilder{
    public iduser:number
    public status:boolean = true
    public posisi:number 
    public email:String
    public password:String
    
    constructor({email,password}:UserInterface){
        this.email =email
        this.password =password
    }

    withEnctyptPassword(){
        this.password = encrypt(this.password)
    }


    withTeacherPosisition(){
        this.posisi = Posisi.GURU
    }

    withAdminPosisition(){
        this.posisi = Posisi.ADMIN
    }

    withWaliPosisition(){
        this.posisi = Posisi.WALI
    }




    withNonAktif(){
        this.status = false
    }

    build() :User{
        return new User(this)
    }
}