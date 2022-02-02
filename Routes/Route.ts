import { Express } from "express"
import {
    AuthController,
    GuruController,
    PaketController,
    RegionController,
    SiswaController,
    WaliController,
    LesController,
    PembayaranController, JadwalController, LowonganController, KeuanganController
} from "../Controller"

const route = (app : Express)=>{
    app.use("/auth",AuthController)
    app.use("/wali",WaliController)
    app.use("/daerah",RegionController)
    app.use("/guru",GuruController)
    app.use("/paket",PaketController)
    app.use("/siswa",SiswaController)
    app.use("/les",LesController)
    app.use("/bayar",PembayaranController)
    app.use("/jadwal",JadwalController)
    app.use("/lowongan",LowonganController)
    app.use("/keuangan",KeuanganController)
}

export default  route


