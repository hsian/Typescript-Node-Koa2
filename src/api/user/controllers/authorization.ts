import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import { sign } from "jsonwebtoken";
import { Get, Post } from "../../../middleware/request";
import Response from "../../../utils/response";
import User from "../entity/user";
import Role from "../entity/role";
import {TOKEN_SECRET} from "../../../config/constant";

export default class Authorization {

    @Post("/login")
    static async login(ctx: BaseContext){
        const userRepository = getRepository(User);
        const {username, password} = ctx.request.body;  
        const user:User = await userRepository.findOne({username}, {
            relations: ['role']
        });

        if(user && user.password === password){
            const {password, ...profile} = user;

            new Response(200, "登录成功", {
                token: sign({...profile}, TOKEN_SECRET),
                user: profile
            }).toObject(ctx);

        }else{
           return new Response(400, "用户或密码错误").toObject(ctx);
        }   
    }

    @Post("/register")
    static async register(ctx: BaseContext){
        const userRepository = getRepository(User);
        const roleRepository = getRepository(Role);
        const params = ctx.request.body;   
        try{
            const role = await roleRepository.findOne({permissions: 1});

            // build up entity user to be saved
            const userInstance:User = new User();
            const userToSaved: User = {
                ...userInstance,
                ...params,
                role
            }
            const username = userToSaved.username;
            const validResulte = User.validate(userToSaved);
            
            if(validResulte.valid === false){
                return new Response(400, validResulte.err_message).toObject(ctx);
            }
            
            const isExsit = await userRepository.findOne({ username });
            if(!isExsit){
                const user = await userRepository.save(userToSaved);
                console.log(user)
                delete user.password;
                ctx.body = {
                    message: "注册成功",
                    data: user
                };
            }  else {
                return new Response(400, '用户名已经存在').toObject(ctx);
            }
        }catch(err){
            return new Response(400, '注册失败，请检查参数', err.message).toObject(ctx);
        }
    }

    // @authorize({isAdmin: true})
    @Get("/_users")
    static async getUser(ctx:any, next:any){
        new Response(200, {a: 1}).toObject(ctx)
    }
}
