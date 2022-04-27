import  UserRepository  from "./UserRepository";
import  WaliRepository  from './WaliRepository';
import  GuruRepository  from './GuruRepository';
import RegionRepository from "./RegionRepository";
import PaketRepository from "./PaketRepository"
import SiswaRepository from "./SiswaRepository"
import LesRepository from "./LesRepository"
import AbsenRepository from "./AbsenRepository"
import PembayaranRepository from "./PembayaranRepository"
import KeuanganRepository from "./KeuanganRepository"
import LowonganRepository from "./LowonganRepository"
import BayarTutorRepository from "./BayarTutorRepository"
import ApplyLowonganRepository from "./ApplyLowonganRepository"
import RekapMenagajarRepository from "./RekapMengajarRepository";

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
    keuangan:KeuanganRepository
    lowongan:LowonganRepository
    applyLowongan:ApplyLowonganRepository
    bayarTutor:BayarTutorRepository
    rekap:RekapMenagajarRepository
}


export{
    IRepository,UserRepository,WaliRepository,
    GuruRepository,RegionRepository,PaketRepository,
    SiswaRepository,LesRepository,AbsenRepository,PembayaranRepository,
  KeuanganRepository,ApplyLowonganRepository,LowonganRepository,BayarTutorRepository,RekapMenagajarRepository
}