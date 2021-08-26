import { NextFunction, Request ,Response} from "express"
import { Posisi } from "../Entity/Posisi"
import { HTTPStatus } from "../Util/HTTPStatus"
import { ErrorHandler } from "../Util/ErrorHandler"


const TeacherChecker = function (req:Request, res:Response, next:NextFunction) {
  if(req.context.posisi == Posisi.GURU) return next()
  return next(new ErrorHandler(HTTPStatus.UNAUTHORIZED, "Account Not has Access"))
}

export default  TeacherChecker
