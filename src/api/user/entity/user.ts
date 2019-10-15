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
        this.head_img = "/uploads/image/IMG1568705287936.jpeg";
    }
}