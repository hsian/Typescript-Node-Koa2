import {Entity, Column, ManyToMany, JoinTable, CreateDateColumn, PrimaryGeneratedColumn} from "typeorm";
import Post from "../../post/entity/post";

@Entity()
export default class Category {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column({type: "int", default: 0})
    is_top:  number;

    @ManyToMany(type => Post, post=> post.categories)
    @JoinTable()
    posts: Post[];

    @CreateDateColumn()
    create_date: Date;
}