export class ErrorHandler extends Error{
    constructor(public statusCode:number, public message:string) {
        super()
    }
}


export const handleError = (err, req, res, next) => {
    try {
      const { statusCode, message } = err
      res.status(statusCode).json({
        status: false,
        data: {},
        message,
      })
    } catch (e) {
      res.status(500).json({
        status: false,
        data: {},
        message: "Something wrong from server",
      })
    }
  }
  