import { validationResult } from "express-validator"
import { ErrorHandler } from "./ErrorHandler"
import { HTTPStatus } from "./HTTPStatus"

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

const validate = validations => {
  return async (req, res, next) => {
    await Promise.all(validations.map(validation => validation.run(req)));
    const error = resultValidation(req)

    if (!error.isEmpty()) {
      return next(new ErrorHandler(HTTPStatus.NOTACCEPT, error.array()[0].message))
    } else {
      next()
    }
  };
};

export default validate
