import { verifyToken } from '../Util/JWT';
import { NextFunction, Request, Response } from 'express';
const allowedURL = [
  "POST /auth/login",
  "POST /auth/admin/login",
  "POST /auth/register",
  "GET /daerah",
  
]
const  AuthChecker =  (req : Request, res:Response, next:NextFunction)=> {
  let url = `${req.method} ${req.path}`
  if (new RegExp(allowedURL.join("|")).test(url)) {
    next()
  } else {
    verifyToken(req, res, next)
  }
}
export default AuthChecker