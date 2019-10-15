import {Entity, Column, PrimaryGeneratedColumn, CreateDateColumn} from "typeorm";

@Entity()
export default class Upload {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    url: string;

    @Column()
    uid: number;

    @CreateDateColumn()
    create_date: Date
}