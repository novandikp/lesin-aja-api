import * as promise from "bluebird"
import pgPromise from 'pg-promise'; 
import {IInitOptions, IDatabase, IMain} from 'pg-promise';
import {
    AbsenRepository,
    GuruRepository,
    IRepository, LesRepository,
    PaketRepository,
    RegionRepository,
    SiswaRepository,
    UserRepository,
    WaliRepository,KeuanganRepository,ApplyLowonganRepository,LowonganRepository,BayarTutorRepository, RekapMenagajarRepository, PenggantianGuruRepository

} from "./Repository"
import PembayaranRepository from "./Repository/PembayaranRepository"



type ExtendedProtocol = IDatabase<IRepository> & IRepository;

const initOptions: IInitOptions<IRepository> = {
    promiseLib: promise,
    extend(obj: ExtendedProtocol, dc: any) {
        obj.users = new UserRepository(obj, pgp);  
        obj.wali = new WaliRepository(obj,pgp)      
        obj.region = new RegionRepository(obj,pgp)
        obj.guru = new GuruRepository(obj,pgp)
        obj.paket = new PaketRepository(obj,pgp)
        obj.siswa = new SiswaRepository(obj,pgp)
        obj.les = new LesRepository(obj,pgp)
        obj.absen = new AbsenRepository(obj,pgp)
        obj.pembayaran = new PembayaranRepository(obj,pgp)
        obj.keuangan = new KeuanganRepository(obj,pgp)
        obj.lowongan = new LowonganRepository(obj,pgp)
        obj.applyLowongan = new ApplyLowonganRepository(obj,pgp)
        obj.bayarTutor = new BayarTutorRepository(obj,pgp)
        obj.rekap = new RekapMenagajarRepository(obj,pgp)
        obj.penggantian = new PenggantianGuruRepository(obj,pgp)
    }
};

const pgp: IMain = pgPromise(initOptions);

require("dotenv").config()

const db: ExtendedProtocol = pgp({
    // ssl: { rejectUnauthorized: false },
    database: process.env.NAME_DATABASE,
    host: process.env.HOST_DATABASE,
    user: process.env.USER_DATABASE,
    password: process.env.PASS_DATABASE,

});

export {db, pgp};