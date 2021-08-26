"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const JWT_1 = require("../Util/JWT");
const AuthChecker = (req, res, next) => {
    let url = req.path.split("/");
    if (url.length > 1) {
        if ((url[2] === "login") || (url[2] === "register" || url[1] == "daerah")) {
            next();
        }
        else {
            JWT_1.verifyToken(req, res, next);
        }
    }
    else {
        JWT_1.verifyToken(req, res, next);
    }
};
exports.default = AuthChecker;
