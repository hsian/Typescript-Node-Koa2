
import { BaseContext } from "koa";
import {getRepository} from "typeorm";

import { Get, Post } from "../../../middleware/request";
import authorize from "../../../middleware/authorize";

import Role from "../entity/role";

interface Permissions {
    nomarl: number;
    admin: number;
}

export default class RoleController {

    @Get("/insert_role")
    async insertRole(ctx: BaseContext){
        const roleRepository = getRepository(Role);
        const data = await roleRepository.find();
        
        if(!data || data.length === 0){
            const roles: Permissions | any = {
                nomarl: 1,
                admin: 256
            }

            try{
                for(let key in roles){
                    await roleRepository.save({
                        type: key,
                        permissions: roles[key]
                    })
                }
            }catch(err){
                console.log(err)
            }
        }
    }
}