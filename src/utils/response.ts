import { BaseContext } from "koa";

export default class Response extends Error {
    private _statusCode: number;

    constructor(statusCode: number, message: string) {
        super(message);
        this._statusCode = statusCode;
    }

    get statusCode(): number {
        return this._statusCode;
    }

    public toObject(context?: BaseContext): Object {
        // 只能返回字符串
        // return context.throw(new Error(this.message), 403)

        // 可自定义返回
        context.response.status = this._statusCode;
        return context.body = {
            statusCode: this._statusCode,
            message: this.message
        }
    }
}