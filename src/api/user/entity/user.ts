import {Entity, Column, OneToMany, ManyToMany, JoinTable, PrimaryGeneratedColumn} from "typeorm";
import PostComment from "../../post/entity/comment";
import Post from "../../post/entity/post";

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
}