import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import { sign, verify } from "jsonwebtoken";
import Exception from "../../../middleware/exception";
import { Get, Post } from "../../../decorators/router";
import User from "../models/user";

export default class Authorization {

    @Post("/login")
    async login(ctx: BaseContext){
        const userRepository = getRepository(User);
        const {username, password} = ctx.request.body;  

        const user:User = await userRepository.findOne({username});

        if(user && user.password === password){
            ctx.body = {
                token: sign({...user}, "GG,GL,HF"),
                user
            };
        }else{
            throw new Exception(401, "用户不存在");
        }   
    }
}
