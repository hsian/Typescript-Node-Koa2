import { BaseContext } from "koa";
import { getRepository, Like } from "typeorm";
import authorize from "../../../middleware/authorize";
import { Get, Post } from "../../../middleware/request";
import Exception from "../../../utils/exception";

import PostEntity from "../entity/post";
import Comment from "../entity/comment";
import User from "../../user/entity/user";
import Category from "../../category/entity/category";

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

    @authorize(false)
    @Get('/post')
    static async findPost(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        let {pageIndex, pageSize, category, keyword} = ctx.request.query;
        const cid = +category;

        pageIndex = pageIndex || 1;
        pageSize = pageSize || 10;

        const start = (pageIndex - 1) * pageSize;
        const limit = pageIndex * pageSize;

        try{ 

            let data: any = [];
            let total: number = 0;
            // 如果cid为0，表示获取关注的文章
            if(cid === 0 && ctx.state.user){
                const uid = ctx.state.user.id;
                const userRepository = getRepository(User);
                const user = await userRepository.findOne({id: uid}, { relations: ['follows'] });
                
                for(let i = 0, item; item = user.follows[i++];){
                    const res = await postRepository
                    .createQueryBuilder('post')
                    .where("post.open = :open", {open: 1})
                    .innerJoinAndSelect(
                        'post.user',
                        'user',
                        'user.id = :follow',
                        { follow: item.id }
                    )
                    .leftJoinAndSelect(
                        'post.categories',
                        'category'
                    )
                    .leftJoinAndSelect(
                        'post.comments',
                        'comment'
                    )
                    .leftJoinAndSelect(
                        'post.cover',
                        'upload'
                    )
                    .orderBy("post.id", "DESC") 
                    .getMany();

                    data = data.concat(res);
                }

                total = data.length;
                data = data.slice(start, limit);
            }else{
                const last_arg:any = cid && cid !== 999  ? { categoryId: cid } : '';
                const three_arg = cid && cid !== 999 ? 'category.id = :categoryId' : '';
                
                if(!ctx.state.postTotal || cid !== ctx.state.cid ){
                    // 是否有获取count的方法 ， typeorm?
                    const firstData = await postRepository
                    .createQueryBuilder('post')
                    .where("post.open = :open", {open: 1})
                    .innerJoinAndSelect(
                        'post.categories',
                        'category',
                        three_arg, 
                        last_arg, 
                    )        
                    .leftJoinAndSelect(
                        'post.user',
                        'user'
                    )
                    .leftJoinAndSelect(
                        'post.comments',
                        'comment'
                    )
                    .leftJoinAndSelect(
                        'post.cover',
                        'upload'
                    ).getMany();

                    ctx.state.postTotal = firstData.length;
                    ctx.state.cid = cid
                }
                
                data = await postRepository
                .createQueryBuilder('post')
                .where("post.open = :open", {open: 1})
                .innerJoinAndSelect(
                    'post.categories',
                    'category',
                    three_arg, 
                    last_arg, 
                )        
                .leftJoinAndSelect(
                    'post.user',
                    'user'
                )
                .leftJoinAndSelect(
                    'post.comments',
                    'comment'
                )
                .leftJoinAndSelect(
                    'post.cover',
                    'upload'
                )
                .orderBy("post.id", "DESC")
                .skip(start)
                .take(pageSize)
                .getMany();
            }

            data = data.map( (v:any) => {
                const {comments, ...props} = v;
                props.comment_length = comments.length;
                return props;
            })

            ctx.body = {
                data,
                total: total || ctx.state.postTotal
            }
        }catch(err){
            console.log(err)
            ctx.body = new Exception(400, "文章列表获取失败").toObject();
        }
    }

    @Get("/post_search")
    static async findPostByKeyword(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        let {keyword, pageIndex, pageSize} = ctx.request.query;

        pageIndex = pageIndex || 1;
        pageSize = pageSize || 10;

        const start = (pageIndex - 1) * pageSize;

        try{
            // 未分页，可能存在无效的文章
            // const data = await postRepository.find({
            //     title: Like(`%${keyword}%`),
            // });

            // 获取所有，加上关联条件确保都是有效的文章,是否有count方法？
            let totalData = await postRepository
            .createQueryBuilder("post")
            .where("post.title like :keyword", {keyword: '%' + keyword + '%' })
            .andWhere("post.open = :open", {open: 1})
            .leftJoinAndSelect(
                'post.user',
                'user'
            )
            .leftJoinAndSelect(
                'post.comments',
                'comment'
            )
            .leftJoinAndSelect(
                'post.cover',
                'upload'
            )
            .getMany();
            
            // 分页访问。当然可以优化
            let data = await postRepository
            .createQueryBuilder("post")
            .where("post.title like :keyword", {keyword: '%' + keyword + '%' })
            .andWhere("post.open = :open", {open: 1})
            .leftJoinAndSelect(
                'post.user',
                'user'
            )
            .leftJoinAndSelect(
                'post.comments',
                'comment'
            )
            .leftJoinAndSelect(
                'post.cover',
                'upload'
            )
            .skip(start)
            .take(pageSize)
            .getMany();

            data = data.map( (v:any) => {
                const {comments, ...props} = v;
                props.comment_length = comments.length;
                return props;
            })

            ctx.body = {
                data,
                total: totalData.length
            }
        }catch(err){
            ctx.body = new Exception(400, "文章列表获取失败").toObject();
        }
    }

    @Get("/post_search_recommend")
    static async findPostRecommend(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        let {keyword} = ctx.request.query;

        try{
            // 未分页
            const data = await postRepository.find({
                title: Like(`%${keyword}%`),
            });

            ctx.body = {
                data
            }
        }catch(err){
            ctx.body = new Exception(400, "文章列表获取失败").toObject();
        }
    }

    @authorize(false)
    @Get('/post/:id')
    static async findPostById(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        const userRepository = getRepository(User);
        const id = +ctx.params.id;

        try{
            const post = await postRepository.findOne({id}, {
                relations: ["like_users", "user", "comments", "cover", "categories"]
            });
            const {comments, like_users, ...props} = post;
            const data: any = {
                ...props, 
                has_follow: false, 
                has_star: false,
                has_like: false
            };

            // 转换成评论条数
            if(Array.isArray(comments)){
                data.comment_length = comments.length;
            }

            // 判断当前用户是否关注该作者
            const user = ctx.state.user;
            
            if(user){
                const uid = user.id;

                if(Array.isArray(like_users)){
                    data.has_like = like_users.some(v => {
                        return v.id === uid;
                    });

                    data.like_length = like_users.length;
                }

                const self = await userRepository.findOne({id: uid}, {
                    relations: ["follows", "post_star"]
                });
                
                data.has_star = self.post_star.some(v => {
                    return v.id === id;
                })

                data.has_follow = self.follows.some(v => {
                    return v.id === post.user.id;
                })
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
        //const limit = pageIndex * pageSize;

        try{
            const post = await postRepository.findOne({id});
            const comments = await cmtRepository.find({ 
                relations: ["parent", "user"],
                where: { post},
                skip: start, 
                take: pageSize,
                order: {
                    id: "DESC"
                }
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

            const restPost = self.post_star.filter(v => {
                return v.id !== post.id;
            });
            const isStar = restPost.length === self.post_star.length;

            // if(self.post_star.some(v => {
            //     return v.id === id;
            // })){
            //     return ctx.body = {
            //         message: "已收藏"
            //     };
            // }

            const userToSaved = {
                ...self,
                post_star: isStar ? [...self.post_star, post] :  restPost
            }

            const data = await userRepository.save(userToSaved);

            ctx.body = {
                message: isStar ? "收藏成功" : "取消成功",
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

            const restUsers = post.like_users.filter(v => {
                return v.id !== user.id;
            });
            const isLike = restUsers.length === post.like_users.length;

            // if(post.like_users.some(v => {
            //     return v.id === user.id;
            // })){
            //     return ctx.body = {
            //         message: "已经点赞"
            //     };
            // }

            const postToSaved = {
                ...post,
                like_users: isLike ? [...post.like_users, user] :  restUsers
            }

            await postRepository.save(postToSaved);

            ctx.body = {
                message: isLike ? "点赞成功" : "取消成功",
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

    @authorize()
    @Post("/post_update/:id")
    static async updatePost(ctx: BaseContext){
        const postRepository = getRepository(PostEntity);
        // const cateRepository = getRepository(Category);
        const params = ctx.request.body;  
        const id = +ctx.params.id;

        try{
            const post = await postRepository.findOne({id}, {relations: ['like_users']});

            if(!post){
                ctx.body = new Exception(400, "编辑文章失败，文章不存在").toObject();
                return;
            }

            // categories是栏目id的集合
            //const {categories, ...props} = params;

            // if(categories && Array.isArray(categories)){
            //     props.categories = [];

            //     for(let i = 0, cid; cid = categories[i++];){
            //         const c = await cateRepository.findOne({id: cid});
            //         props.categories.push(c);
            //     }
            // }

            const postToSaved = {
                id,
                ...params
            }

            await postRepository.save(postToSaved);

            ctx.body = {
                message: "文章编辑成功"
            }

        }catch(err){
            console.log(err);
            ctx.body = new Exception(400, "编辑文章失败，请检查参数").toObject();
        }
    }
}