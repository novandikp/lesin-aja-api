import { setegid } from "process"

export default class PenggantianGuru{
    public idpenggantian:number
    public idles:number
    public alasan:string
    public tglpenggantian:string
    public status:StatusPenggantian

    // constructor({idles,alasan}:any) {
    //     this.idles = idles
    //     this.alasan = alasan
    //     this.tglpenggantian = new Date().toISOString()
    //     this.status = StatusPenggantian.DELAY
    // }

     constructor(init?:Partial<PenggantianGuru>) {
        Object.assign(this, init);
        if(!this.status){
            this.status = StatusPenggantian.DELAY
        }
    }


    setConfirm(){
        this.status = StatusPenggantian.TERKONFIRMASI
    }

    setReject(){
        this.status = StatusPenggantian.DITOLAK
    }

    isDelayed(){
        return this.status == StatusPenggantian.DELAY
    }

    isConfirmed(){
        return this.status = StatusPenggantian.TERKONFIRMASI
    }

    isRejected(){
        return this.status = StatusPenggantian.DITOLAK
    }
}

export enum StatusPenggantian{
    DELAY=0,
    TERKONFIRMASI=1,
    DITOLAK=2
}