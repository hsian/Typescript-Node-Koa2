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
        migrationsTableName: "migration_table",
        migrations: [
            __dirname + "/migrations/*{.js,.ts}"
        ],
        cli: {
            "migrationsDir": "migration"
        }
    })

    //await connection.runMigrations();
    
    return connection;
}




