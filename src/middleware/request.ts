import Router from "koa-router";
import {BaseContext} from "koa";

export const router = new Router();

const authMiddleware = (controller: any) => {
    return (ctx: BaseContext, next: any) => {
        const authorize = controller.authorize;

        // need to be verify token
        if(authorize && typeof authorize === 'function'){
            return authorize.call(null, ctx, next)
        }

        return next();
    };
}

export const Get = (path: string) => {
    return (
        context: any,  
        key: string, 
        desc: PropertyDescriptor
    ) => {
        const controller =  context[key];
        router.get(path, authMiddleware(controller), controller);
    }
}

export const Post = (path: string) => {
    return (
        context: any,  
        key: string, 
        desc: PropertyDescriptor
    ) => {
        const controller =  context[key];
        router.post(path, authMiddleware(controller), controller);
    }
}
