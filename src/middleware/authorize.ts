import {BaseContext} from "koa";
import { verify } from "jsonwebtoken";
import Exception from "../utils/exception";
import { TOKEN_SECRET } from "../config/constant";

interface Params {
    required?: Boolean;
    isAdmin?: Boolean;
}

const authorize = (params = <Params>{}) => {
    const {required, isAdmin} = params;

    return (context: any,  key: string, desc: PropertyDescriptor) => {

        context[key].authorize = (ctx: BaseContext, next: any) => {
            try{
                const token = ctx.request.headers['authorization'];
                if(required === false){
                    if(token){
                        ctx.state.user = verify(token.replace('Bearer ', ''), TOKEN_SECRET);
                    }
                    return next();
                }

                // default
                if(required !== false){
                    if(token){
                        ctx.state.user = verify(token.replace('Bearer ', ''), TOKEN_SECRET);
                        // 是否是管理员
                        if(isAdmin === true && ctx.state.user.role.type !== 'admin'){
                            return ctx.body = new Exception(401, "用户不是管理员").toObject();
                        }
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