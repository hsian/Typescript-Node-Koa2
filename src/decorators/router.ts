import Router from "koa-router";

export const router = new Router();

export const Get = (path: string) => {
    return (
        ctrl: any,  
        prop: string, 
        desc: PropertyDescriptor
    ) => {
        router.get(path, (ctx, next) => {
            const authMiddleware = ctrl[prop].authorize;

            if(authMiddleware && typeof authMiddleware === 'function'){
                if(authMiddleware(ctx, next)){
                    console.log("验证通过");
                    next();
                }else{
                    console.log("验证失败");
                    ctx.body = "需要登录";
                }
            }else{
                next();
            }
        }, ctrl[prop]);
    }
}

export const Post = (path: string) => {
    return (
        ctrl: any,  
        prop: string, 
        desc: PropertyDescriptor
    ) => {
        router.post(path, ctrl[prop]);
    }
}
