
import {BaseContext} from "koa";
import { sign, verify } from "jsonwebtoken";

const authorize = async (callback: any,  propertyKey: string, descriptor: PropertyDescriptor) => {

    console.log(callback, propertyKey)

    return (ctx:BaseContext, next:any) => {
        //const token = ctx.request.headers['authorization'];

        console.log(123);

        callback(ctx, next);
    }
}

export default authorize;