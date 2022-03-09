export default class Jenjang {
    public  static readonly DataJenjang:JenjangModel[] = [
        { jenjang :"PAUD"},
        { jenjang :"TK"},
        { jenjang :"SD"},
        { jenjang :"SMP"},
        { jenjang :"SMA"},
        { jenjang :"Umum"},
        { jenjang :"Agama"},
    ]

}

export type JenjangModel={
    jenjang:string
}