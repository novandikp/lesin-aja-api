import {createCipheriv,createDecipheriv} from "crypto"
require("dotenv").config()
const key = process.env.PUBLIC_KEY_ENCRYPT
const iva = Buffer.from(process.env.PRIVATE_KEY_ENCRYPT, "hex")

function encrypt(text) {
  const cipher = createCipheriv("aes-256-cbc", Buffer.from(key), iva)
  let encrypted = cipher.update(text)
  encrypted = Buffer.concat([encrypted, cipher.final()])
  return encrypted.toString("hex")
}

function decrypt(text) {
  const encryptedText = Buffer.from(text, "hex")
  const decipher = createDecipheriv("aes-256-cbc", Buffer.from(key), iva)
  let decrypted = decipher.update(encryptedText)
  decrypted = Buffer.concat([decrypted, decipher.final()])
  return decrypted.toString()
}


export  {encrypt,decrypt}