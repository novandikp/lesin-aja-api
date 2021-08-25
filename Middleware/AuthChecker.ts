import { verifyToken } from '../Util/JWT';
import { NextFunction, Request, Response } from 'express';

const  AuthChecker =  (req : Request, res:Response, next:NextFunction)=> {
  let url = req.path.split("/")
  if (url.length > 1) {
    if ((url[2] === "login") || (url[2] === "register" || url[1]=="daerah" )) {
      
      next()
    } else {
      verifyToken(req, res, next)
    }
  } else {
    verifyToken(req, res, next)
  }
}
export default AuthChecker