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
COMMIT;
