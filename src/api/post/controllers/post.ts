import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import authorize from "../../../middleware/authorize";
import { Get, Post } from "../../../middleware/request";
import Exception from "../../../utils/exception";

import PostEntity from "../entity/post";
import Comment from "../entity/comment";

export default class PostController {

    @Get('/post/:id')
    static async findPost(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const id = +ctx.params.id;

        try{
            const data = await postRepository.findOne({id}, {relations: ["like_users", "user", "comments"]});
            
            ctx.body = {
                message: !data ? "文章不存在" : "",
                data,
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

        try{
            const post = await postRepository.findOne({id});
            const comments = await cmtRepository.find({ 
                relations: ["parent", "user"],
                where: { post, id:11},
             });

             async function _loop(item: any){
                const cmtRepository = getRepository(Comment);
                const p = item.parent;
                if(p){
                    const parent: Comment = await cmtRepository.findOne( {id: p.id}, {relations: ["parent"]});
                   console.log(1111111)
                    item.parent = parent;
            
                    _loop(item.parent);
                    
                }
                return item;
            }
            

            const data:any = [];
            for(let i = 0, item; item = comments[i++];){
            
                const _item =   _loop(item).then(res =>{
                    console.log(res)
                })
                console.log(2222222)
                data.push(_item);
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
                message: "评论发布成功",
                data,
            }
        }catch(err){
            console.log(err)
            ctx.body = new Exception(400, "评论失败").toObject();
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
            ctx.body = new Exception(400, "文章发布失败，请检查参数").toObject();
        }
    }
}