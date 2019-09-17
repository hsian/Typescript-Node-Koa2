import app from "./app";
import colors from "colors";
import {PORT} from "./config/constant";

const server = app.listen(PORT || 3000, () => {
    console.log();
    console.log(colors.cyan(`服务器启动成功`));
    console.log(colors.cyan(`服务器本地地址：http://127.0.0.1:${PORT}`));
    console.log();
});

export default server;