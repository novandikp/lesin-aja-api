
import { User } from './../Entity/User';
import { UserBuilder } from './../Builder/UserBuilder';
import { db } from '../Database';
import { Wali } from './../Entity/Wali';


const getWali = async (filter)=>{
    try{
      return await db.wali.all(filter)
    }catch (e){
      return null
    }
}

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

const profile = async (id:number) =>{
    try {
        const dataWali:Wali = await db.wali.getById(id)
        return dataWali
    } catch (error) {
        return null       
    }
}


const setProfile = async (body) =>{
    try {
        const dataWali:Wali = await db.wali.edit(body,body.idwali)
        return dataWali
    } catch (error) {
        return null       
    }
}

export {profile,setProfile,register,getWali}