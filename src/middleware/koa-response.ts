import { BaseContext } from "koa";

interface BackRef {
    statusCode: number;
    message: string | Object;
    data?:Object
}
 
class Response {
    private _statusCode: BackRef['statusCode'];
    private _message: BackRef['message'];
    private _data: BackRef["data"];

    constructor(
        statusCode: BackRef['statusCode'], 
        message: BackRef['message'], 
        data?: BackRef['data']
    ) {
        
        this._statusCode = statusCode;
        const type = typeof message;

        if(type === 'string'){
            this._message = message;
        }else if(type === "object"){
            this._data = message;
        }

        if(data){
            this._data = data;
        }
    }

    get statusCode(): number {
        return this._statusCode;
    }

    public toObject(context?: BaseContext): BackRef {
        // 只能返回字符串
        // return context.throw(new Error(this.message), 403)

        // 可自定义返回
        context.response.status = this._statusCode;
        return context.body = {
            statusCode: this._statusCode,
            message: this._message,
            data: this._data
        }
    }
}

const _ = (ctx: BaseContext) => {
    ctx.content = () => {
        
    }
}

export default _;