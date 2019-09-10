import {Entity, Column, PrimaryGeneratedColumn} from "typeorm";

@Entity()
export default class Upload {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    url: string;

    @Column()
    uid: number;
}