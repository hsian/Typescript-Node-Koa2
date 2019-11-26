import {Entity, Column, OneToMany, ManyToOne, ManyToMany, JoinTable, PrimaryGeneratedColumn, CreateDateColumn} from "typeorm";
import PostComment from "../../post/entity/comment";
import Post from "../../post/entity/post";
import Role from "./role"

@Entity()
export default class User {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({unique: true, length: 11})
    username: string;

    @Column({length: 18})
    password: string

    @Column({length: 10})
    nickname: string

    @Column({default: ""})
    head_img: string

    @Column({type: "int", default: 1})
    gender: number;

    @ManyToOne(type => Role, role => role.users)
    role: Role

    @ManyToMany(type => User)
    @JoinTable()
    follows: User[]

    @OneToMany(type => PostComment, comment => comment.user)
    post_comments: PostComment[]

    @OneToMany(type => Post, post => post.user)
    posts: Post[]

    @OneToMany(type => Post, post => post.like_users)
    like_posts: Post[]

    @ManyToMany(type => Post)
    @JoinTable()
    post_star: Post[];

    @CreateDateColumn()
    create_date: Date

    constructor(){
        this.head_img = "/uploads/image/default_avatar.jpg";
    }

    static validate(user: any){
        const rules: any = {
            'username': {
                rule: /^1[0-9]{10}/,
                err_message: "用户名格式错误",
            },
            'password': {
                rule: /^[0-9A-Za-z_]{6,18}/,
                err_message: "密码格式错误",
            },
            'nickname': {
                rule: /^[0-9A-Za-z_\u4e00-\u9fa5]{2,6}/,
                err_message: "昵称格式错误",
            }
        }

        let valid = true;
        let err_message = ""
        Object.keys(rules).forEach((key: any)=> {
            if(!valid) return;
            if(!user[key]){
                throw new Error(key + ' 值不能为空')
            }
            if( !(rules[key].rule.test(user[key])) ){
                valid = false;
                err_message = rules[key].err_message
            }
        })

        return {
            valid,
            err_message
        }
    }
}