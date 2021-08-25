
import { User } from './../Entity/User';
import { UserBuilder } from './../Builder/UserBuilder';
import { db } from '../Database';
import { Guru } from '../Entity/Guru';


const register = async (body) =>{
    const userBuilder:UserBuilder = new UserBuilder(body)
    userBuilder.withTeacherPosisition()
    userBuilder.withEnctyptPassword()
    try {
        const dataUser:User = await db.users.add(userBuilder.build())
        const dataGuru:Guru = await db.guru.add(body)
        return dataGuru
    } catch (error) {
        console.error(error)
        return null       
    }
}

const profile = async (email:String) =>{
    try {
        const dataGuru:Guru = await db.guru.getByEmail(email)
        return dataGuru
    } catch (error) {
        return null       
    }
}


const setProfile = async (body) =>{
    try {
        const dataGuru:Guru = await db.guru.edit(body,body.idchild)
        return dataGuru
    } catch (error) {
        console.error(error)
        return null       
    }
}

export {profile,setProfile,register}