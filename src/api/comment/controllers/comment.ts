import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import authorize from "../../../middleware/authorize";
import { Get, Post } from "../../../middleware/request";
import Exception from "../../../utils/exception";

import Comment from "../../post/entity/comment";

export default class CommentController {

    @authorize()
    @Post('/post_comment')
    static async createComment(ctx: BaseContext){
        const cmtRepository = getRepository(Comment);
        const params = ctx.request.body;  
        const cmtToSaved = {
            ...params,
            user: ctx.state.user
        }

        try{
            const data = await cmtRepository.save(cmtToSaved);
            ctx.body = {
                message: "评论发布成功",
                data,
            }
        }catch(err){
            ctx.body = new Exception(400, "评论发布失败，请检查参数").toObject();
        }  
    }
} 
