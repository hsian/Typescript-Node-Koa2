import {Entity, Column, OneToMany, PrimaryGeneratedColumn} from "typeorm";
import PostComment from "../../post/entity/comment";
import Post from "../../post/entity/post";

@Entity()
export default class User {

    @PrimaryGeneratedColumn()
    id: number;

    @OneToMany(type => PostComment, comment => comment.user)
    post_comments: PostComment[]

    @OneToMany(type => Post, post => post.user)
    posts: Comment[]

    @Column({unique: true, length: 11})
    username: string;

    @Column({length: 18})
    password: string

    @Column({length: 10})
    nickname: string

    @Column({default: ""})
    head_img: string
}