import {sign,verify} from "jsonwebtoken"
import { User, UserInterface } from "../Entity/User"
import { Request,Response, NextFunction } from 'express';
import { HTTPStatus } from './HTTPStatus';
import Payload from './../Entity/Payload';
import { ErrorHandler } from "./ErrorHandler"


require("dotenv").config()
const key = process.env.JWT_KEY
const projectName = process.env.PROJECT_NAME



export const generate =({email,posisi,idchild,iduser}:Payload)=>{
  var payload:object ={ project: projectName ,email:email, posisi:posisi, idchild:idchild,iduser:iduser}
  return sign(payload,key)
}


export const verifyToken =(req:Request, res:Response, next:NextFunction) =>{
  try {
    const token = req.headers.authorization
    const decoded = verify(token, key)
    if (decoded.project == projectName) {
      if (req.method == "POST"){
        req.body.iduser = decoded.iduser  
        req.body.idchild = decoded.idchild
        req.body.email = decoded.email
      }
      req.context = decoded
      next()
    } else {
      return next(new ErrorHandler(HTTPStatus.UNAUTHORIZED, "Token is not valid"))
    }
  } catch (err) {
    return next(new ErrorHandler(HTTPStatus.UNAUTHORIZED, "Token is not valid"))
  }
}
