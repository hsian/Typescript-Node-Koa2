import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import { sign } from "jsonwebtoken";
import authorize from "../../../middleware/authorize";
import { Get, Post } from "../../../middleware/request";
import Exception from "../../../utils/exception";
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

            ctx.body = {
                message: "登录成功",
                data: {
                    token: sign({...profile}, TOKEN_SECRET),
                    user: profile
                }
            };
        }else{
           ctx.body = new Exception(401, "用户不存在").toObject();
        }   
    }

    @Post("/register")
    static async register(ctx: BaseContext){
        const userRepository = getRepository(User);
        const roleRepository = getRepository(Role);
        const params = ctx.request.body;   
        
        const role = await roleRepository.findOne({permissions: 1});

        // build up entity user to be saved
        const userInstance:User = new User();
        const userToSaved: User = {
            ...userInstance,
            ...params,
            role
        }
        const username = userToSaved.username;

        try{
            const isExsit = await userRepository.findOne({ username });

            if(!isExsit){
                const user = await userRepository.save(userToSaved);
                delete user.password;
                ctx.body = {
                    message: "注册成功",
                    data: user
                };
            }  else {
                ctx.body = new Exception(400, '用户名已经存在').toObject();
            }
        }catch(err){
            ctx.body = new Exception(400, '注册失败，请检查参数').toObject();
        }
    }

    @authorize({isAdmin: true})
    @Get("/_users")
    static async getUser(ctx:any, next:any){
        ctx.body = '123'
    }
}
