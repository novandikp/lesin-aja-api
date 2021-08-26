import { db } from '../Database';
import { Posisi } from '../Entity/Posisi';
import { generate } from '../Util/JWT';
import { User, UserInterface } from './../Entity/User';
import { encrypt } from "../Util/Encrypt"

const {OAuth2Client} = require('google-auth-library');
const CLIENT_ID:string =""

const loginAdmin= async ({email, password }:UserInterface) =>{
    try {
        let idchild=0;
      const {posisi,iduser} = await db.users.getByUsernameAndPassword(email,encrypt(password))
      if (posisi == Posisi.GURU){
        const  {idguru} = await db.guru.getByEmail(email)
        idchild=idguru
      }else if (posisi == Posisi.WALI){
        const  {idwali} = await db.wali.getByEmail(email)
        idchild=idwali
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
    return null
  }
}

const getTokenByEmailVerified=async (email:String)=>{
  try {
    let idchild=0;
    const dataUser:User= await db.users.getByEmail(email)

    if(!dataUser) return {isExist : false}

    const {posisi,iduser}  = dataUser
    if (posisi === Posisi.GURU){
      const  {idguru} = await db.guru.getByEmail(email)
      idchild=idguru
    }else if (posisi === Posisi.WALI){
      const  {idwali} = await db.wali.getByEmail(email)
      idchild=idwali
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
  }catch (e){
    return null
  }
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


export {loginWithGoogle,loginAdmin,changePassword}