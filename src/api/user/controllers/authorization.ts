import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import { sign, verify } from "jsonwebtoken";
import authorize from "../../../middleware/authorize";
import { Get, Post } from "../../../middleware/request";
import Exception from "../../../utils/exception";
import User from "../models/user";
import UserController from "./user";
import {TOKEN_SECRET} from "../../../config/constant";

export default class Authorization {

    @Post("/login")
    static async login(ctx: BaseContext){
        const userRepository = getRepository(User);
        const {username, password} = ctx.request.body;  
        const user:User = await userRepository.findOne({username});

        if(user && user.password === password){
            const {password, ...profile} = user;

            console.log(ctx.body = 123)

            ctx.body = {
                token: sign({...profile}, TOKEN_SECRET),
                user
            };
        }else{
           ctx.body = new Exception(401, "用户不存在").toObject();
        }   
    }

    @Post("/register")
    static async register(ctx: BaseContext){
        const params = ctx.request.body;   
        const user = await UserController.createUser(params);

        if(user){
            ctx.body = user;
        }else{
            ctx.body = new Exception(400, '用户名已经存在').toObject();
        }
    }

    @authorize()
    @Get("/_users")
    static async getUser(ctx:any, next:any){
        ctx.body = '123'
    }
}
