BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "user" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"username"	varchar(11) NOT NULL,
	"password"	varchar(18) NOT NULL,
	"nickname"	varchar(10) NOT NULL,
	"head_img"	varchar NOT NULL DEFAULT (''),
	CONSTRAINT "UQ_78a916df40e02a9deb1c4b75edb" UNIQUE("username")
);
INSERT INTO "user" VALUES (2,'100861','123','广州新闻','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (3,'100862','123','娱乐在线','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (4,'100863','123','新华网','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (5,'100864','123','火星时报','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (6,'100865','123','银河护卫队','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (7,'100866','123','鲨鱼联盟','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (8,'100867','123','药材铺老板','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (9,'100868','123','大型止血贴','/uploads/image/IMG1568705287936.jpeg');
INSERT INTO "user" VALUES (10,'100869','123','三杯鸡养殖户','/uploads/image/IMG1568705287936.jpeg');
COMMIT;
