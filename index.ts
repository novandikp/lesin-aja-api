import express, { Response } from "express";
import Route from "./Routes/Route";
import { handleError } from "./Util/ErrorHandler";
import AuthChecker from './Middleware/AuthChecker';
import Payload from './Entity/Payload';
import path from "path"
import { send } from './Util/GlobalResponse';
import { encrypt } from "./Util/Encrypt"


declare global {
  namespace Express {
    interface Request {
      context: Payload
    }
  }
}


require("dotenv").config()
const port = process.env.PORT || 1000
const morgan = require("morgan")
const compression = require("compression")
const app =express()
const Cors = require("cors")
const timeout = require("connect-timeout")

app.use(timeout("10s"))
app.use(morgan("tiny"))
app.use(compression())
app.use(Cors({ origin: true, credentials: true }))
app.use(express.static(path.join(__dirname, "..", "public", "uploads")))

app.use(express.json())
app.use(express.urlencoded({ extended: false }))

//JWT Middleware
app.use(AuthChecker)

Route(app)

app.use(handleError)
app.listen(port, async () => {

  console.log(`REST at http://localhost:${port}`)
})



export default  app
