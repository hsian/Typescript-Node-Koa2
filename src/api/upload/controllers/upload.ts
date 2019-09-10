import path from "path";
import fs from "fs";

import { BaseContext } from "koa";
import {getRepository} from "typeorm";
import Upload from "../models/upload";
import { Post } from "../../../middleware/request";
import authorize from "../../../middleware/authorize";
import Exception from "../../../utils/exception";
import { PUBLIC_PATCH } from "../../../config/constant";

export default class UploadController {

    @authorize()
    @Post('/upload')
    static async uploadFile(ctx: BaseContext, next: any){
        const uploadRepository = getRepository(Upload);

        try{
            const file = ctx.request.files.file
            const fileType = file.type.split("\/")[1] || "";
            const filePath = `/uploads/IMG'${Date.now()}.${fileType}`;

            const reader = fs.createReadStream(file.path);
            const stream = fs.createWriteStream(path.join(
                PUBLIC_PATCH, 
                filePath
            ));
            reader.pipe(stream);
            
            const fileToSaved = {
                url: filePath,
                uid: ctx.state.user.id
            }
            const data = await uploadRepository.save(fileToSaved)

            ctx.body = {
                message: "图片上传成功",
                data
            }
        }catch(err){
            ctx.body = new Exception(400, '图片上传失败').toObject();
        }
    }
}
