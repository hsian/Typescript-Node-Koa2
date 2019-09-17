BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "category" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar NOT NULL,
	"is_top"	integer NOT NULL DEFAULT (0)
);
INSERT INTO "category" VALUES (1,'热点',1);

INSERT INTO "category" VALUES (2,'娱乐',1);
INSERT INTO "category" VALUES (3,'体育',1);
INSERT INTO "category" VALUES (4,'财经',1);
INSERT INTO "category" VALUES (5,'汽车',1);
INSERT INTO "category" VALUES (6,'军事',1);
INSERT INTO "category" VALUES (7,'男人',1);
INSERT INTO "category" VALUES (8,'视频',1);
INSERT INTO "category" VALUES (9,'科技',1);
INSERT INTO "category" VALUES (10,'手机',1);

INSERT INTO "category" VALUES (11,'女人',0);
INSERT INTO "category" VALUES (12,'数码',0);
INSERT INTO "category" VALUES (13,'段子',0);
INSERT INTO "category" VALUES (14,'时尚',0);
INSERT INTO "category" VALUES (15,'游戏',0);
INSERT INTO "category" VALUES (16,'教育',0);
INSERT INTO "category" VALUES (17,'健康',0);
INSERT INTO "category" VALUES (18,'旅游',0);
INSERT INTO "category" VALUES (19,'房产',0);
COMMIT;
