import {Entity, Column, OneToMany,  ManyToMany, JoinTable, PrimaryGeneratedColumn} from "typeorm";
import User from "./user"

@Entity()
export default class Role {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    type: string;

    @Column({type: "int", default: 0})
    permissions: number;

    @OneToMany(type => User, user => user.role)
    users: User[]
}