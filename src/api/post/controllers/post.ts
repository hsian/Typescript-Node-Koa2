import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import authorize from "../../../middleware/authorize";
import { Get, Post } from "../../../middleware/request";
import Exception from "../../../utils/exception";

import PostEntity from "../entity/post";
import Comment from "../entity/comment";
import User from "../../user/entity/user";

const createCommentsParent = function (){
    const cmtRepository = getRepository(Comment);

    return async function _loop(item:any){
        const p = item.parent;
        if(p){
            const parent: Comment = await cmtRepository.findOne( {id: p.id}, {relations: ["parent", "user"]});
            item.parent = parent;
            await _loop(item.parent);
        }
        return item;
    }
}

export default class PostController {

    @Get('/post/:id')
    static async findPost(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const id = +ctx.params.id;

        try{
            const post = await postRepository.findOne({id}, {relations: ["like_users", "user", "comments"]});
            const {comments, ...props} = post;
            let data = {}

            if(Array.isArray(comments)){
                data = {
                    ...props,
                    comment_length: comments.length
                }
            }
            
            ctx.body = {
                message: !post ? "文章不存在" : "",
                data
            }
        }catch(err){
            ctx.body = new Exception(400, "文章不存在").toObject();
        }
    }

    @Get("/post_comment/:id")
    static async getComment(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const cmtRepository = getRepository(Comment);
        const id = +ctx.params.id;
        let {pageIndex, pageSize} = ctx.request.query;

        pageIndex = pageIndex || 1;
        pageSize = pageSize || 10;

        const start = (pageIndex - 1) * pageSize;
        const limit = pageIndex * pageSize;

        try{
            const post = await postRepository.findOne({id});
            const comments = await cmtRepository.find({ 
                relations: ["parent", "user"],
                where: { post },
                skip: start, 
                take: limit
            });
            const commentsParent = createCommentsParent();

            const data:any = [];
            for(let i = 0, item; item = comments[i++];){
                // 楼层数据
                const floor = await commentsParent(item);
                data.push(floor);
            }
            
             ctx.body = {
                data
             }

        }catch(err){
            console.log(err)
            ctx.body = new Exception(400, "获取评论失败").toObject();
        }
    }

    @authorize()
    @Post('/post_comment/:id')
    static async postComment(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const cmtRepository = getRepository(Comment);
        const id = +ctx.params.id;
        const params = ctx.request.body;  

        try{
            const post = await postRepository.findOne({id});

            if(!post){
                ctx.body = new Exception(400, "评论失败，文章不存在").toObject();
                return;
            }

            const cmtToSaved = {
                ...params,
                post_id: id,
                post_title: post.title,
                user: ctx.state.user,
                post
            }
            
            // 回复
            const pid: number = +params.parent_id;
            if(pid){
                const reply: Comment = await cmtRepository.findOne({id: pid});

                if(reply){
                    cmtToSaved.parent =  reply;
                }
            }
            
            const data = await cmtRepository.save(cmtToSaved);

            ctx.body = {
                message: "评论发布成功"
            }
        }catch(err){
            console.log(err)
            ctx.body = new Exception(400, "评论失败").toObject();
        }
    }

    @authorize()
    @Get('/post_star/:id')
    static async postStar(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const userRepository = getRepository(User);
        const user = ctx.state.user;
        const id = +ctx.params.id;

        try{
            const post = await postRepository.findOne({id});
            const self = await userRepository.findOne({ id: user.id }, { relations: ['post_star'] });

            if(!post){
                ctx.body = new Exception(400, "收藏失败，文章不存在").toObject();
                return;
            }

            if(self.post_star.some(v => {
                return v.id === id;
            })){
                return ctx.body = {
                    message: "已收藏"
                };
            }

            const userToSaved = {
                ...self,
                post_star: [ ...self.post_star, post ]
            }

            const data = await userRepository.save(userToSaved);

            ctx.body = {
                message: "收藏成功"
            }
        }catch(err){
            console.log(err);
            ctx.body = new Exception(400, "收藏失败，文章不存在").toObject();
        }

    }

    @authorize()
    @Get('/post_like/:id')
    static async postLike(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const user = ctx.state.user;
        const id = +ctx.params.id;

        try{
            const post = await postRepository.findOne({id}, {relations: ['like_users']});

            if(!post){
                ctx.body = new Exception(400, "点赞失败，文章不存在").toObject();
                return;
            }

            if(post.like_users.some(v => {
                return v.id === user.id;
            })){
                return ctx.body = {
                    message: "已经点赞"
                };
            }

            const postToSaved = {
                ...post,
                like_users: [...post.like_users, user]
            }

            const data = await postRepository.save(postToSaved);

            ctx.body = {
                message: "点赞成功",
                data
            }
        }catch(err){
            ctx.body = new Exception(400, "点赞失败").toObject();
        }
    }

    @authorize()
    @Post('/post')
    static async createPost(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const params = ctx.request.body;  

        const postToSaved = {
            ...params,
            user: ctx.state.user,
            comments: [],
            like_users: []
        }

        try{
            const data = await postRepository.save(postToSaved);

            ctx.body = {
                message: "文章发布成功",
                data,
            }
        }catch(err){
            console.log(err);
            ctx.body = new Exception(400, "文章发布失败，请检查参数").toObject();
        }
    }
}