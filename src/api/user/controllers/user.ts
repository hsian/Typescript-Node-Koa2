import { BaseContext } from "koa";
import {getRepository} from "typeorm";
import User from "../entity/user";
import { Post } from "../../../middleware/request";
import authorize from "../../../middleware/authorize";
import Exception from "../../../utils/exception";

export default class UserController {
    // can use this.userDB instead of getRepository(User) without static property
    // https://auth0.com/blog/building-and-securing-a-koa-and-angular2-app-with-jwt/
   //  private userDB;

    @authorize()
    @Post("/user/update/:id")
    static async  updateUser(ctx:  BaseContext, next: any){
        const userRepository = getRepository(User);
        const id = +ctx.params.id;

        if( id !==  ctx.state.user.id){
            ctx.body = new Exception(401, "用户信息验证失败!").toObject();
            return;
        }

        try{
            const userUpdate: User= ctx.request.body;
            const userBefore = await userRepository.findOne({ id });
            const userAfter = await userRepository.save({ 
                id,
                ...userUpdate
            });

            const { password,  ...user } = { ...userBefore, ...userAfter };

            ctx.body = {
                message: "修改成功",
                data: user
            };
        }catch(err){
            ctx.body = new Exception(401, "修改失败，请检查参数名称!").toObject();
        }
    }
}