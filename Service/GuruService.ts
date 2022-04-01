
import { User } from './../Entity/User';
import { UserBuilder } from './../Builder/UserBuilder';
import { db } from '../Database';
import { Guru } from '../Entity/Guru';
import RekapLes from '../Entity/RekapLes';
import RekapMengajar from '../Entity/RekapMengajar';

const getGuru = async (filter)=>{
    try{
      return await db.guru.all(filter)
    }catch (e){
      return null
    }
}

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

const profile = async (id:number) =>{
    try {
        const dataGuru:Guru = await db.guru.getByID(id)
        return dataGuru
    } catch (error) {
        console.log(error)
        return null       
    }
}


const setProfile = async (body) =>{
    try {
        const dataGuru:Guru = await db.guru.edit(body,body.idguru)
        return dataGuru
    } catch (error) {
        console.error(error)
        return null       
    }
}


const getRekapMengajar = async (query)=>{
    try {
        const dataRekap:RekapMengajar[] = await db.les.getRekapMengajar(query)
        return dataRekap
    } catch (error) {
        console.error(error)
        return null       
    }
}

export {profile,setProfile,register,getGuru,getRekapMengajar}