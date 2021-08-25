import { validationResult } from "express-validator"
import { ErrorHandler } from "./ErrorHandler"

const resultValidation = validationResult.withDefaults({
  formatter: (error) => {
    return {
      message: error.msg,
    }
  },
})

function handlerInput(req, res, next) {
  const error = resultValidation(req)
  if (!error.isEmpty()) {
    return next(new ErrorHandler(406, error.array()[0].message))
  } else {
    next()
  }
}

export default handlerInput
