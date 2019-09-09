import {getRepository} from "typeorm";
import User from "../models/user";

export default class UserController {
    // can use this.userDB instead of getRepository(User) without static property
    // https://auth0.com/blog/building-and-securing-a-koa-and-angular2-app-with-jwt/
    //private userDB = getRepository(User); 

    static async createUser({username, password, nickname}: User){
        const userRepository = getRepository(User);

        // build up entity user to be saved
        const user:User = new User();
        user.username = username;
        user.password = password;
        user.nickname = nickname;

        const isExsit = await userRepository.findOne({ username });

        if(!isExsit){
            await userRepository.save(user);
            delete user.password;
            return user;    
        }   
    }
}