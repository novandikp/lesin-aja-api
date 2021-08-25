import { Status } from './Status';
import { Posisi } from './Posisi';
export class User {
    public iduser:number
    public email:String
    public password:String
    public posisi:number
    public status:boolean
    
    constructor({iduser,email, password, posisi , status}:UserInterface  ){
        this.email = email
        this.password = password
        this.posisi = posisi
        this.status = status 
        this.iduser = iduser
        
    }


    getDataWithoutID(){
        return {
            email : this.email,
            posisi : this.posisi,
            password:this.password,
            status : this.status,
            
        }
    }

    getBasicInfo(){
        return {
            email : this.email,
            posisi : Posisi.getPosisi(this.posisi),
            status : this.status 
        }
    }


    getAllDetails(){
        return this
    }


    setActive(){
        this.status = true
    }

    setNonActive(){
        this.status = false
    }

    getStatus(){
        return this.status
    }

    setPassword(password : String){
        this.password = password
    }

    getPassword():String{
        return this.password
    }   
}

export type UserInterface ={
     iduser:number
     email:String
     password:String
     posisi:number
     status:boolean
}