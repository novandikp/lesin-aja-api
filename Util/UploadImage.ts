// import { Multer,d} from "multer"


// export default class UploadImage {
//   public multer:Multer
//   public storage:Multer
//   constructor(multer:Multer, folder) {
//     this.multer = multer
//     this.storage = this.multer.diskStorage({
//       destination: function (req, file, cb) {
//         cb(null, "public/uploads/image/" + folder)
//       },

//       filename: function (req, file, cb) {
//         cb(null, file.originalname)
//       },
//     })
//     this.upload = multer({
//       storage: this.storage,
//       fileFilter: (req, file, cb) => {
//         if (
//           file.mimetype == "image/png" ||
//           file.mimetype == "image/jpg" ||
//           file.mimetype == "image/jpeg"
//         ) {
//           cb(null, true)
//         } else {
//           cb(null, false)
//           return cb(new Error("Only .png, .jpg and .jpeg format allowed!"))
//         }
//       },
//     })
//   }
// }


