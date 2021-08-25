import { Response, text } from "express";

export const send = (resp:Response,statusCode :number, data:ResponseData)=>{
    resp.status(statusCode).json(data)
}



type ResponseData ={
    data:object,  
    status?:boolean,
    message:string
}