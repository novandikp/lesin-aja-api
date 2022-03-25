import { db } from '../Database';
import { Posisi } from '../Entity/Posisi';
import { generate } from '../Util/JWT';
import { User, UserInterface } from './../Entity/User';
import { encrypt } from "../Util/Encrypt"
import { UserBuilder } from "../Builder/UserBuilder"
import { WaliBuilder } from "../Builder/WaliBuilder"
import { GuruBuilder } from "../Builder/GuruBuilder"

const {OAuth2Client} = require('google-auth-library');
const CLIENT_ID:string ="1074207251680-rfbkb2tqe7gchrk8vb1e9802en9rnsba.apps.googleusercontent.com"

const loginAdmin= async ({email, password }:UserInterface) =>{
    try {
      let idchild,topicID;
      const {posisi,iduser} = await db.users.getByUsernameAndPassword(email,encrypt(password))
      if (posisi == Posisi.GURU){
        const  {idguru,idkecamatan} = await db.guru.getByEmail(email)
        idchild=idguru
        topicID =idkecamatan
      }else if (posisi == Posisi.WALI){
        const  {idwali,idkecamatan} = await db.wali.getByEmail(email)
        idchild=idwali
        topicID =idkecamatan
      }
      const token = generate({
        iduser:iduser,
        email:email,
        posisi:posisi,
        idchild:idchild
      })
      return {
        token : token,
        email : email,
        posisi : Posisi.getPosisi(posisi),
        idchild:idchild,
      }
    } catch (error) {
        console.log(error)
        return null
    }
}

const loginWithGoogle = async (token) =>{
  try{
    const client = new OAuth2Client(CLIENT_ID)
    const dataUser = await client.verifyIdToken({
      idToken: token,
      audience: CLIENT_ID,
    });
    const { email } = dataUser.getPayload();
    return getTokenByEmailVerified(email)
  }catch (e){
    console.log(e)
    return null
  }
}

const getTokenByEmailVerified=async (email:String)=>{
  try {
    let idchild,topicID,editedProfile;
    let gender
    const dataUser:User= await db.users.getByEmail(email)
    if(!dataUser){
      const token = generate({
        iduser:0,
        email:"sample@email",
        posisi:Posisi.TAMU,
        idchild:idchild
      })
      return {isExist : false,token:token}
    } else{
      const {posisi,iduser}  = dataUser
      if (posisi === Posisi.GURU){
        const  {idguru,idkecamatan,guru,jeniskelaminguru} = await db.guru.getByEmail(email)
        idchild=idguru
        topicID = idkecamatan
        gender = jeniskelaminguru
        editedProfile = guru != null
      }else if (posisi === Posisi.WALI){
        const  {idwali,idkecamatan,wali} = await db.wali.getByEmail(email)
        idchild=idwali
        topicID = idkecamatan
        editedProfile = wali != null
      }
      if (!gender){
        gender ="-"
      }
      const token = generate({
        iduser:iduser,
        email:email,
        posisi:posisi,
        idchild:idchild,
      })
      return {
        token : token,
        email : email,
        posisi : Posisi.getPosisi(posisi),
        idchild:idchild,
        topicID:topicID,
        prefrensi:gender,
        editedProfile:editedProfile
      }
    }

  }catch (e){
    return null
  }
}

const insertDataByRole = async (data)=>{
  try{
    let idchild
    const {email,posisi}=data

    if (posisi != Posisi.WALI && posisi != Posisi.GURU) return  null

    const userBuilder:UserBuilder = new UserBuilder(data)
    if(posisi == Posisi.GURU){
      userBuilder.withTeacherPosisition()
      idchild = await initTeacher(email)
    }else{
      userBuilder.withWaliPosisition()
      idchild = await initWali(email)
    }

    const {iduser} = await db.users.add(userBuilder.build())
    const token = generate({
      iduser:iduser,
      email:email,
      posisi:posisi,
      idchild:idchild,
    })
    return {
      token : token,
      email : email,
      posisi : Posisi.getPosisi(posisi),
      idchild:idchild,
      editedProfile:false
    }
  }catch (e){
    return null
  }
}

const initTeacher = async (email) =>{
    const guruBuilder:GuruBuilder = new GuruBuilder(email)
    const {idguru}  = await db.guru.add(guruBuilder.build())
    return idguru
}

const initWali = async (email) =>{
  const guruBuilder:WaliBuilder = new WaliBuilder(email)
  const {idwali}  = await db.wali.add(guruBuilder.build())
  return idwali
}


const changePassword = async({iduser,password} :UserInterface) =>{
    try {
        const data:UserInterface = await db.users.get(iduser)
        const user:User = new User(data)
        user.setPassword(password)
        await db.users.edit(user,iduser)
        return {
            email : data.email,
            posisi : Posisi.getPosisi(data.posisi),
        }
    } catch (error) {
        return null
    }
}


export {loginWithGoogle,loginAdmin,changePassword,insertDataByRole,getTokenByEmailVerified}