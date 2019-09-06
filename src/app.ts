import Koa from "koa";
import bodyParser from 'koa-bodyparser';
import connectionDatabase from "./config/database/connection";
import {router} from "./decorators/router";

import UserController from "./api/user/controllers";
import Authorization from "./api/user/controllers/authorization";

const app = new Koa();
const db = connectionDatabase();

new UserController();
new Authorization();

app.use(bodyParser());
app.use(router.routes())

export default app;



