import Koa from "koa";
import koaBody from 'koa-body';
import koaStatic from "koa-static";
import connectionDatabase from "./config/database/connection";
import {router} from "./middleware/request";
import { PUBLIC_PATCH } from "./config/constant";

const app = new Koa();
const db = connectionDatabase();

import ("./api/user/controllers/user").then(Factor => { new Factor.default() });
import ("./api/user/controllers/authorization").then(Factor => { new Factor.default() });
import ("./api/upload/controllers/upload").then(Factor => { new Factor.default() });
import ("./api/post/controllers/post").then(Factor => { new Factor.default() });
import ("./api/category/controllers/category").then(Factor => { new Factor.default() });

app.use(koaStatic( PUBLIC_PATCH ));
app.use(koaBody({ multipart: true }));
app.use(router.routes())

export default app;



