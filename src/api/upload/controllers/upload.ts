import path from "path";
import fs from "fs";
import fsa from "fs-extra";

import { BaseContext } from "koa";
import {getRepository} from "typeorm";
import Upload from "../entity/upload";
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
            let filePath = ""

            if(['jpg', 'jpeg', 'jiff', 'png', 'gif'].indexOf(fileType) > -1){
                fsa.ensureDirSync(path.join(PUBLIC_PATCH,`/uploads/image`));
                filePath = `/uploads/image/IMG${Date.now()}.${fileType}`;
            }else if(['mp4', 'mp3', 'avi', 'rmvb'].indexOf(fileType) > -1){
                fsa.ensureDirSync(path.join(PUBLIC_PATCH,`/uploads/media`));
                filePath = `/uploads/media/MEDIA${Date.now()}.${fileType}`;
            }else{
                return ctx.body = new Exception(400, '未知的文件格式').toObject();
            }

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
                message: "文件上传成功",
                data
            }
        }catch(err){
            console.log(err)
            ctx.body = new Exception(400, '文件上传失败').toObject();
        }
    }
}
