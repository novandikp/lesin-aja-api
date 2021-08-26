"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const Route_1 = __importDefault(require("./Routes/Route"));
const ErrorHandler_1 = require("./Util/ErrorHandler");
const AuthChecker_1 = __importDefault(require("./Middleware/AuthChecker"));
require("dotenv").config();
const port = process.env.PORT || 1000;
const morgan = require("morgan");
const compression = require("compression");
const app = express_1.default();
app.use(morgan("tiny"));
app.use(compression());
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: false }));
//JWT Middleware
app.use(AuthChecker_1.default);
Route_1.default(app);
app.use(ErrorHandler_1.handleError);
app.listen(port, () => __awaiter(void 0, void 0, void 0, function* () {
    console.log(`REST at http://localhost:${port}`);
}));
