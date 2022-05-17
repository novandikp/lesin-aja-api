import {Client} from "onesignal-node"
import exp from "constants"

export default class OneSignalUtil{
  private static instance:OneSignalUtil
  private  client:Client
  private readonly tagsKelamin ="kelamin"
  private readonly tagsKecamatan ="idkecamatan"

  constructor() {
     this.client = new Client('1fa1745c-7727-40cb-b10e-1a3ae71da5cc'
       ,'MDk4MGY0ODQtMWIxMi00ZDM2LThkZTYtOWE3NDg4OTZhMWQ2'
       , { apiRoot: 'https://onesignal.com/api/v2'})
  }



  public  sendNotificationWithTag(text,idkecamatan, kelamin:string){
    const notification = {
      contents: {
        'id': text,
        'en': text,
      },
      filters: [
        { field: 'tag', key: this.tagsKecamatan, relation: '=', value: idkecamatan}
      ]
    };

    if(kelamin != Prefrensi.Umum){
      notification.filters.push({ field: 'tag', key: this.tagsKelamin, relation: '=', value: kelamin})
    }

    this.client.createNotification(notification).then((e)=>{

      console.log(e.body)
    }).catch((e)=>{
      console.error(e)
    })
  }

}

export enum Prefrensi{
  Umum = "Bebas",
  Pria = "Pria",
  Wanita = "Wanita",
}