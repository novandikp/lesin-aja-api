
import { User } from './../Entity/User';
import { UserBuilder } from './../Builder/UserBuilder';
import { db } from '../Database';
import { Wali } from './../Entity/Wali';



const register = async (body) =>{
    const userBuilder:UserBuilder = new UserBuilder(body)
    userBuilder.withWaliPosisition()
    userBuilder.withEnctyptPassword()
    try {
        const dataUser:User = await db.users.add(userBuilder.build())
        const dataWali:Wali = await db.wali.add(body)
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
    try {
        const dataWali:Wali = await db.wali.edit(body,body.idchild)
        return dataWali
    } catch (error) {
        return null       
    }
}

export {profile,setProfile,register}