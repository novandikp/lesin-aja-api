import { db } from '../Database';
import { Posisi } from '../Entity/Posisi';
import { generate } from '../Util/JWT';
import { User, UserInterface } from './../Entity/User';

 const login = async ({email, password }:UserInterface) =>{
    try {
        let idchild;
        const {posisi,iduser} = await db.users.getByUsernameAndPassword(email,password)
        if (posisi == Posisi.GURU){
          const  {idguru} = await db.guru.getByEmail(email)
          idchild=idguru
        }else{
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
        console.log(error)
        return null
    }
}


export {login,changePassword}