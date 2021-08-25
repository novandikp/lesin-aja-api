import express from "express";



import Route from "./Routes/Route";
import { handleError } from "./Util/ErrorHandler";
import AuthChecker from './Middleware/AuthChecker';
import Payload from './Entity/Payload';



declare global {
  namespace Express {
    interface Request {
      context: Payload
    }
  }
}

require("dotenv").config()
const port = process.env.PORT || 1000

const app =express()
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

//JWT Middleware
app.use(AuthChecker)

Route(app)

app.use(handleError)

app.listen(port, async () => {
  console.log(`REST at http://localhost:${port}`)
})

