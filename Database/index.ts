import * as promise from "bluebird"
import pgPromise from 'pg-promise'; 
import {IInitOptions, IDatabase, IMain} from 'pg-promise';
import {
    GuruRepository,
    IRepository,
    PaketRepository,
    RegionRepository,
    SiswaRepository,
    UserRepository,
    WaliRepository
} from "./Repository"



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