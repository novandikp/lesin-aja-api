import { Express } from "express"
import {AuthController, GuruController, RegionController, WaliController} from "../Controller"

const route = (app : Express)=>{
    app.use("/auth",AuthController)
    app.use("/wali",WaliController)
    app.use("/daerah",RegionController)
    app.use("/guru",GuruController)
}

export default  route


