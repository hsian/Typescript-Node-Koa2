import {BaseContext} from "koa";
import { verify } from "jsonwebtoken";
import Exception from "../utils/exception";
import { TOKEN_SECRET } from "../config/constant";

const authorize = (strict: Boolean = true) => {
    return (context: any,  key: string, desc: PropertyDescriptor) => {

        context[key].authorize = (ctx: BaseContext, next: any) => {
            try{
                const token = ctx.request.headers['authorization'];
                if(strict === false){
                    if(token){
                        ctx.state.user = verify(token.replace('Bearer ', ''), TOKEN_SECRET);
                    }
                    return next();
                }

                // default
                if(strict === true){
                    if(token){
                        ctx.state.user = verify(token.replace('Bearer ', ''), TOKEN_SECRET);
                        return next();
                    }
                }

                return ctx.body = new Exception(401, "用户信息验证失败").toObject();
            }catch(err){
                console.log(err);
                return ctx.body = new Exception(401, "用户信息验证失败").toObject();
            }
        }
    } 
}

export default authorize;