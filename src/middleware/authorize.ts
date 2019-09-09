import {BaseContext} from "koa";
import { verify } from "jsonwebtoken";
import Exception from "../utils/exception";
import { TOKEN_SECRET } from "../config/constant";

const authorize = () => {
    return (context: any,  key: string, desc: PropertyDescriptor) => {

        context[key].authorize = (ctx: BaseContext, next: any) => {
            const token = ctx.request.headers['authorization'];
            try{
                ctx.state.user = verify(token.replace('Bearer ', ''), TOKEN_SECRET);
                return next();
            }catch(err) {
                ctx.body = new Exception(401, "用户信息验证失败").toObject();
                return false;
            }
        }
    } 
}

export default authorize;