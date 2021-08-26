import { CustomValidator,body} from "express-validator"
import { User } from "../Entity/User"
import { db } from "../Database"
import validate from "../Util/ValidationHandler"

function AuthValidation() {
  return [
    body("email").isEmail().withMessage("Email tidak valid"),
    body("email").custom(checkEmail),
  ]
}

const checkEmail:CustomValidator =  (input, meta) =>{
  return  db.users.getByEmail(input).then((user:User)=>{
      if (user) return Promise.reject("Email telah terdaftar")
  })

}

export default validate(AuthValidation())
