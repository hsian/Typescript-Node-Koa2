import {Entity, Column, PrimaryGeneratedColumn} from "typeorm";

@Entity()
export default class Users {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({
        unique: true,
        length: 11
    })
    username: string;

    @Column({
        length: 18
    })
    password: string

    @Column({
        length: 10
    })
    nickname: string
}