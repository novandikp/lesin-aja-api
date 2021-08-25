
import {IDatabase, IMain} from 'pg-promise';

import  FilterUpdate  from '../../Util/FilterUpdate';
import Provinsi from './../../Entity/Provinsi';
import Kota from './../../Entity/Kota';
import Kecamatan from '../../Entity/Kecamatan';
export default class RegionRepository {
    constructor(private db: IDatabase<any>, private pgp: IMain) {
    }

    async getProvince() : Promise<Provinsi []>{
        return   this.db.any("SELECT * FROM provinsi")
    }

    async getCity(idprovince:number) : Promise<Kota []>{
        return this.db.any("SELECT * FROM kota where province_id=$1",[idprovince])
    }


    async getDistrict(id_city:number):Promise<Kecamatan []>{
        return this.db.any("SELECT * FROM kecamatan where regency_id=$1",[id_city])
    }


    async getVillage(id_district:number):Promise<Kecamatan []>{
        return this.db.any("SELECT * FROM desa where district_id=$1",[id_district])
    }
    
}