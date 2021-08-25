import  UserRepository  from "./UserRepository";
import  WaliRepository  from './WaliRepository';
import  GuruRepository  from './GuruRepository';
import RegionRepository from "./RegionRepository";
import PaketRepository from "./PaketRepository"
import SiswaRepository from "./SiswaRepository"

interface IRepository{
    users : UserRepository
    wali:WaliRepository
    guru:GuruRepository
    region:RegionRepository
    paket:PaketRepository
    siswa:SiswaRepository
}


export{
    IRepository,UserRepository,WaliRepository,GuruRepository,RegionRepository,PaketRepository,SiswaRepository
}