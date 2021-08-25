
import { User } from './../Entity/User';
import { UserBuilder } from './../Builder/UserBuilder';
import { db } from '../Database';
import { Wali } from './../Entity/Wali';
import { WaliBuilder } from './../Builder/WaliBuilder';


const register = async (body) =>{
    const waliBuilder:WaliBuilder = new WaliBuilder(body)    
    const userBuilder:UserBuilder = new UserBuilder(body)
    userBuilder.withWaliPosisition()
    try {
                
        const dataUser:User = await db.users.add(userBuilder.build())
        const dataWali:Wali = await db.wali.add(waliBuilder.build())
        return dataWali
    } catch (error) {
        console.log(error)
        return null       
    }
}

const profile = async (email:String) =>{
    try {
        const dataWali:Wali = await db.wali.getByEmail(email)
        return dataWali
    } catch (error) {
        return null       
    }
}


const setProfile = async (body) =>{
    const waliBuilder:WaliBuilder = new WaliBuilder(body)
    waliBuilder.setIdWali(body.idchild)
    try {
        const dataWali:Wali = await db.wali.edit(waliBuilder.build())
        return dataWali
    } catch (error) {
        return null       
    }
}

export {profile,setProfile,register}