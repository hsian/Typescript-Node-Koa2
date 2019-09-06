import "reflect-metadata";
import {createConnection} from "typeorm";

import Models from "../../api/config/models";

export default async function connectionDatabse(){
    const connection = await createConnection({
        type: "sqlite",
        database: "./temp/mydb.sql",
        synchronize: true,
        logging: false,
        entities: [...Models]
    })

    return connection;
}




