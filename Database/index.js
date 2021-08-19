const promise = require("bluebird")
const pgPromise = require("pg-promise")
const {
  UserRoles,
  Users,
  DonationProgram,
  DonationCategory,
  HistoryTransaction,
  DonorDonation,
} = require("./Repository")
require("dotenv").config()

const initOptions = {
  promiseLib: promise,

  extend(obj) {
    obj.userRoles = new UserRoles(obj, pgp)
    obj.users = new Users(obj, pgp)
    obj.donationProgram = new DonationProgram(obj, pgp)
    obj.donationCategory = new DonationCategory(obj, pgp)
    obj.historyTransaction = new HistoryTransaction(obj, pgp)
    obj.donorDonation = new DonorDonation(obj, pgp)
  },
}
// Initializing the library:
const pgp = pgPromise(initOptions)
const connectionString = process.env.CONNECTION_STRING || ""

const db = pgp({
  ssl: { rejectUnauthorized: false },
  database: process.env.NAME_DATABASE,
  host: process.env.HOST_DATABASE,
  user: process.env.USER_DATABASE,
  password: process.env.PASS_DATABASE,
})

module.exports = { db, pgp }
