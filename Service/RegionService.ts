
import { db } from '../Database';
import Provinsi from '../Entity/Provinsi';

const getProvince = async() =>{
    try {
        const province:Provinsi[] = await db.region.getProvince()
        return province
    } catch (error) {
        return null       
    }
}


const getCity = async(idprovince) =>{
    try {
        const province:Provinsi[] = await db.region.getCity(idprovince)
        return province
    } catch (error) {
        
        return null       
    }
}



const getDistrict = async(idcity) =>{
    try {
        const province:Provinsi[] = await db.region.getDistrict(idcity)
        return province
    } catch (error) {
        return null       
    }
}



const getVillage = async(iddistrict) =>{
    try {
        const province:Provinsi[] = await db.region.getVillage(iddistrict)
        return province
    } catch (error) {
        return null       
    }
}


export {getProvince, getCity, getDistrict,getVillage}