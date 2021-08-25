
import { User } from './../Entity/User';
import { UserBuilder } from './../Builder/UserBuilder';
import { db } from '../Database';
import { Wali } from './../Entity/Wali';
import { WaliBuilder } from './../Builder/WaliBuilder';
import { GuruBuilder } from './../Builder/GuruBuilder';
import { Guru } from '../Entity/Guru';


const register = async (body) =>{
    const userBuilder:UserBuilder = new UserBuilder(body)
    userBuilder.withTeacherPosisition()
    const guruBuilder:GuruBuilder = new GuruBuilder(body)    

    try {
        const dataUser:User = await db.users.add(userBuilder.build())
        const dataGuru:Guru = await db.guru.add(guruBuilder.build())
        return dataGuru
    } catch (error) {
        console.error(error)
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


const setProfile = async (body, email:String) =>{
    const waliBuilder:WaliBuilder = new WaliBuilder(body)
    try {
        const dataWali:Wali = await db.wali.add(waliBuilder.build())
        return dataWali
    } catch (error) {
        return null       
    }
}

export {profile,setProfile,register}