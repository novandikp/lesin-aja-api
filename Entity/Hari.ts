const namaHari:String[] = ["SENIN","SELASA","RABU","KAMIS","JUMAT","SABTU","MINGGU"]
const getIndexHari = (hari:string)=>{
  return namaHari.indexOf(hari)
}
export default getIndexHari