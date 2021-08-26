import { CustomValidator,body} from "express-validator"
import { User } from "../Entity/User"
import { db } from "../Database"

function validate() {
  return [
    body("email").isEmail().withMessage("Email tidak valid"),
    body("email").custom(checkEmail),
    body("password").isLength({min:8}).withMessage("Password minimal 8 digit")
  ]
}

const checkEmail:CustomValidator =  (input, meta) =>{
  return  db.users.getByEmail(input).then((user:User)=>{
      if (user) return Promise.reject("Email telah terdaftar")
  })

}

export default validate
