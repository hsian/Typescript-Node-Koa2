import Router from "koa-router";

export const router = new Router();

export const Get = (path: string) => {
    return (controller: any,  propertyKey: string, descriptor: PropertyDescriptor) => {
        router.get(path, controller[propertyKey]);
    }
}

export const Post = (path: string) => {
    return (controller: any,  propertyKey: string, descriptor: PropertyDescriptor) => {
        router.post(path, controller[propertyKey]);
    }
}
