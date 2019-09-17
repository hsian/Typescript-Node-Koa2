import request from "supertest"
import server from "../src/server"
import { expect } from "chai"

describe("POST /login", () => {
    it("should return some defined error message with valid parameters", (done) => {
        return request(server).post("/login")
            .expect(200)
            .end(function(err, res) {
                expect(res.error).not.to.be.undefined;
                done();
            });

    });
});