import { BaseContext } from "koa";
import {getRepository} from "typeorm";

import { Get, Post } from "../../../middleware/request";
import authorize from "../../../middleware/authorize";
import Exception from "../../../utils/exception";

import User from "../entity/user";
import PostComment from "../../post/entity/comment";

export default class UserController {
    // can use this.userDB instead of getRepository(User) without static property
    // https://auth0.com/blog/building-and-securing-a-koa-and-angular2-app-with-jwt/
    //  private userDB;

    @authorize()
    @Get("/user/:id")
    static async findUser(ctx: BaseContext){
        const userRepository = getRepository(User);
        const id = +ctx.params.id;

        if( id !==  ctx.state.user.id){
            ctx.body = new Exception(401, "用户信息验证失败!").toObject();
            return;
        }

        try{
            const user = await userRepository.findOne({ id }, { 
                relations: ['post_comments', 'post_star', 'role'] 
            });
            const {post_comments, post_star, ...props } = user;
            const data = {
                ...props,
                post_comments: post_comments.length,
                post_star: post_star.length
            }
            
            ctx.body = {
                message: "获取成功",
                data
            };
        }catch(err){
            console.log(err);
            ctx.body = new Exception(401, "获取用户信息失败").toObject();
        }
    }

    @authorize()
    @Get("/user_follows/:id")
    static async userFollows(ctx: BaseContext){
        const userRepository = getRepository(User);
        const user = ctx.state.user;
        const id = +ctx.params.id;

        try{
            const self = await userRepository.findOne({id: user.id}, { relations: ['follows'] });
            const follow = await userRepository.findOne({id});

            if(!user){
                return ctx.body = new Exception(401, "关注失败，用户不存在").toObject();
            }

            const isExist = self.follows.some((v: any) => {
                return v.id === id;
            });

            if(isExist){
                return ctx.body = {
                    message: "已关注"
                };
            }

            const userToSaved = {
                ...user,
                follows: [ ...self.follows,  follow]
            }
            
            await userRepository.save(userToSaved)

            ctx.body = {
                message: "关注成功"
            }

        }catch(err){
            console.log(err);
            ctx.body = new Exception(401, "关注失败").toObject();
        }
    }

    @authorize()
    @Get("/user_unfollow/:id")
    static async userUnfollow(ctx: BaseContext){
        const userRepository = getRepository(User);
        const user = ctx.state.user;
        const id = +ctx.params.id;

        try{
            const self = await userRepository.findOne({id: user.id}, { relations: ['follows'] });
            const follow = await userRepository.findOne({id});

            if(!user){
                return ctx.body = new Exception(401, "关注失败，用户不存在").toObject();
            }

            const restFollows = self.follows.filter((v: any) => {
                return v.id !== id;
            });

            if(restFollows.length === self.follows.length ){
                return ctx.body = {
                    message: "未关注该用户"
                };
            }

            const userToSaved = {
                ...user,
                follows: restFollows
            }
            
            await userRepository.save(userToSaved)

            ctx.body = {
                message: "取消关注成功"
            }

        }catch(err){
            console.log(err);
            ctx.body = new Exception(401, "取消关注失败").toObject();
        }
    }

    @authorize()
    @Get("/user_follows")
    static async findUserFollows(ctx: BaseContext){
        const userRepository = getRepository(User);
        const {id} =  ctx.state.user;

        try{
            const user = await userRepository.findOne({id}, { relations: ['follows'] });
            const data = user.follows;

            ctx.body = {
                data
            }
        }catch(err){
            console.log(err)
            ctx.body = new Exception(401, "查询错误").toObject();
        }
    }

    @authorize()
    @Get("/user_comments")
    static async findUserComments(ctx: BaseContext){
        const cmtRepository = getRepository(PostComment);
        const {id} =  ctx.state.user;
        let {pageIndex, pageSize} = ctx.request.query;

        pageIndex = pageIndex || 1;
        pageSize = pageSize || 10;

        const start = (pageIndex - 1) * pageSize;
        // const limit = pageIndex * pageSize;

        try{
            const data = await cmtRepository.find({ 
                relations: ['post', 'parent', 'parent.user'],
                where: { user: id },
                skip: start, 
                take: pageSize
            })

            ctx.body = {
                message: "",
                data
            };
        }catch(err){
            console.log(err)
            ctx.body = new Exception(401, "查询错误").toObject();
        }
    }

    @authorize()
    @Get("/user_star")
    static async findUserStars(ctx: BaseContext){
        const userRepository = getRepository(User);
        const {id} =  ctx.state.user;

        try{
            const user = await userRepository.findOne({ id }, { 
                relations: ['post_star', 'post_star.cover', 'post_star.user', 'post_star.comments'] 
            });
            const {post_star} = user;
            
            ctx.body = {
                message: "",
                data: post_star
            };
        }catch(err){
            console.log(err);
            ctx.body = new Exception(401, "获取用户信息失败").toObject();
        }
    }

    @authorize()
    @Post("/user_update/:id")
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