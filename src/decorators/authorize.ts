
import {BaseContext} from "koa";
import { sign, verify } from "jsonwebtoken";

const authorize = () => {
    return (ctrl: any,  key: string, desc: PropertyDescriptor) => {

        ctrl[key].authorize = (ctx: BaseContext, next: any) => {
            console.log(ctx.request.headers['authorization'])
            return false;
        }
        
        

        // return (ctx:BaseContext, next:any) => {
        //     //const token = ctx.request.headers['authorization'];
    
        //     console.log(123);
    
        //     callback(ctx, next);
        // }
    } 
}

export default authorize;