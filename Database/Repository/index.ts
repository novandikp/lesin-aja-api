import  UserRepository  from "./UserRepository";
import  WaliRepository  from './WaliRepository';
import  GuruRepository  from './GuruRepository';
import RegionRepository from "./RegionRepository";

interface IRepository{
    users : UserRepository
    wali:WaliRepository
    guru:GuruRepository
    region:RegionRepository
}


export{
    IRepository,UserRepository,WaliRepository,GuruRepository,RegionRepository
}