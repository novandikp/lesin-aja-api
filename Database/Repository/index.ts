import  UserRepository  from "./UserRepository";
import  WaliRepository  from './WaliRepository';
import  GuruRepository  from './GuruRepository';
import RegionRepository from "./RegionRepository";
import PaketRepository from "./PaketRepository"
import SiswaRepository from "./SiswaRepository"
import LesRepository from "./LesRepository"
import AbsenRepository from "./AbsenRepository"
import PembayaranRepository from "./PembayaranRepository"

interface IRepository{
    users : UserRepository
    wali:WaliRepository
    guru:GuruRepository
    region:RegionRepository
    paket:PaketRepository
    siswa:SiswaRepository
    les:LesRepository
    absen:AbsenRepository
    pembayaran:PembayaranRepository
}


export{
    IRepository,UserRepository,WaliRepository,
    GuruRepository,RegionRepository,PaketRepository,
    SiswaRepository,LesRepository,AbsenRepository,PembayaranRepository
}