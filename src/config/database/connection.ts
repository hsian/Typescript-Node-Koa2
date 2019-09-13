import "reflect-metadata";
import {createConnection} from "typeorm";

export default async function connectionDatabse(){
    const connection = await createConnection({
        type: "sqlite",
        database: "./temp/sqlite.db",
        synchronize: true,
        entities: ["dist/api/**/entity/*.js"],
        logging: ["query", "error"],
        logger: "file",
        migrations: [
            __dirname + "/migrations/*{.js,.ts}"
        ]
    })

    await connection.runMigrations();
    
    return connection;
}




