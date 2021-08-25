import { Express } from "express"
import {
    AuthController,
    GuruController,
    PaketController,
    RegionController,
    SiswaController,
    WaliController
} from "../Controller"

const route = (app : Express)=>{
    app.use("/auth",AuthController)
    app.use("/wali",WaliController)
    app.use("/daerah",RegionController)
    app.use("/guru",GuruController)
    app.use("/paket",PaketController)
    app.use("/siswa",SiswaController)
}

export default  route


