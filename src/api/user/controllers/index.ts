import {BaseContext} from "koa";
import {getRepository} from "typeorm";
import {Get, Post} from "../../../decorators/router";
import authorize from "../../../decorators/authorize";
import User from "../models/user";


export default class UserController {

    @authorize()
    @Get("/users")
    async getUser(ctx:any, next:any){
        ctx.body = '123'
    }

    @Post("/users")
    async createUser(ctx: BaseContext){

        const userRepository = getRepository(User);
        const {username, password, nickname} = ctx.request.body;   

        // build up entity user to be saved
        const user:User = new User();
        user.username = username;
        user.password = password;
        user.nickname = nickname;

        const isExsit = await userRepository.findOne({ username });

        if(isExsit){
            ctx.status = 400;
            ctx.body = '用户名已经存在';
        }else{
            await userRepository.save(user);
            delete user.password;
            ctx.status = 201;
            ctx.body = user;
        }   
    }
}