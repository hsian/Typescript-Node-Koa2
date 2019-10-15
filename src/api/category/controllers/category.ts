import { BaseContext } from "koa";
import { getRepository } from "typeorm";
import authorize from "../../../middleware/authorize";
import { Get, Post } from "../../../middleware/request";
import Exception from "../../../utils/exception";

import PostEntity from "../../post/entity/post";
import Category from "../entity/category";

export default class CategoryController {

    @authorize({required: false})
    @Get("/category")
    static async findCategories(ctx: BaseContext){
        const cateRepository = getRepository(Category);
        const data:any = await cateRepository.find();
        const user = ctx.state.user;

        data.unshift({
            id: 999,
            name: "头条",
            is_top: 1
        });

        if(user){
            data.unshift({
                id: 0,
                name: "关注",
                is_top: 1
            });
        }

        ctx.body = {
            data
        }
    }

    @authorize()
    @Post("/category")
    static async createCategory(ctx: BaseContext){
       //  const postRepository = getRepository(PostEntity);
        const cateRepository = getRepository(Category);
        const  params = ctx.request.body;

        try{
            const cateToSaved = {
                ...params
            }

            await cateRepository.save(cateToSaved);

            ctx.body = {
                message: "栏目添加成功"
            }

        }catch(err){
            console.log(err);
            ctx.body = new Exception(400, "栏目添加失败，请检查参数").toObject();
        }
    }
}
