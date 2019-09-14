import {Entity, Column, ManyToOne, OneToMany, ManyToMany, JoinTable, PrimaryGeneratedColumn} from "typeorm";
import User from "../../user/entity/user";
import Comment from "./comment";

@Entity()
export default class Post {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    title: string;

    @Column("text")
    content: string;

    @ManyToOne(type => User, user => user.posts)
    user: User;

    @OneToMany(type => Comment, comment => comment.post)
    comments: Comment[]

    @ManyToMany(type => User)
    @JoinTable()
    like_users: User[];
}