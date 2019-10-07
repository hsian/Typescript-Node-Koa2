BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "post_comment" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"content"	varchar NOT NULL,
	"userId"	integer,
	"postId"	integer,
	"parentId"	integer,
	CONSTRAINT "FK_c7fb3b0d1192f17f7649062f672" FOREIGN KEY("postId") REFERENCES "post"("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT "FK_5675870bd3124aeeaa476256062" FOREIGN KEY("userId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT "FK_8018bc65c89f9b88fdb38d02710" FOREIGN KEY("parentId") REFERENCES "post_comment"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "migrations" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"timestamp"	bigint NOT NULL,
	"name"	varchar NOT NULL
);
CREATE TABLE IF NOT EXISTS "user_post_star_post" (
	"userId"	integer NOT NULL,
	"postId"	integer NOT NULL,
	CONSTRAINT "FK_c5c365c016809e8aa4cfae53f65" FOREIGN KEY("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	PRIMARY KEY("userId","postId"),
	CONSTRAINT "FK_a62933d561c31fc90c5c2e8e7d2" FOREIGN KEY("postId") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "user_follows_user" (
	"userId_1"	integer NOT NULL,
	"userId_2"	integer NOT NULL,
	CONSTRAINT "FK_911345dc417fb10f25f7644cc60" FOREIGN KEY("userId_1") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	CONSTRAINT "FK_da5eb1d232421542d4fb33ac417" FOREIGN KEY("userId_2") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	PRIMARY KEY("userId_1","userId_2")
);
CREATE TABLE IF NOT EXISTS "post_categories_category" (
	"postId"	integer NOT NULL,
	"categoryId"	integer NOT NULL,
	CONSTRAINT "FK_93b566d522b73cb8bc46f7405bd" FOREIGN KEY("postId") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	CONSTRAINT "FK_a5e63f80ca58e7296d5864bd2d3" FOREIGN KEY("categoryId") REFERENCES "category"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	PRIMARY KEY("postId","categoryId")
);
CREATE TABLE IF NOT EXISTS "post_like_users_user" (
	"postId"	integer NOT NULL,
	"userId"	integer NOT NULL,
	CONSTRAINT "FK_e0c6eb857edb4374d07a7175a3d" FOREIGN KEY("postId") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	CONSTRAINT "FK_701dd0cfc5bc38ede4f8a11257f" FOREIGN KEY("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	PRIMARY KEY("postId","userId")
);
CREATE TABLE IF NOT EXISTS "post_cover_upload" (
	"postId"	integer NOT NULL,
	"uploadId"	integer NOT NULL,
	CONSTRAINT "FK_b9a00cd8d070cce5c13d43dbf50" FOREIGN KEY("postId") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	CONSTRAINT "FK_f69ff461a7d7a83b64e5ac5189a" FOREIGN KEY("uploadId") REFERENCES "upload"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	PRIMARY KEY("postId","uploadId")
);
CREATE TABLE IF NOT EXISTS "category_posts_post" (
	"categoryId"	integer NOT NULL,
	"postId"	integer NOT NULL,
	PRIMARY KEY("categoryId","postId"),
	CONSTRAINT "FK_3a1f3735235af2f4b702a3d3987" FOREIGN KEY("categoryId") REFERENCES "category"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
	CONSTRAINT "FK_0cb77d79c53f0759b8153ec8a62" FOREIGN KEY("postId") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "post" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"title"	varchar NOT NULL,
	"content"	text NOT NULL,
	"type"	integer NOT NULL DEFAULT (1),
	"userId"	integer,
	CONSTRAINT "FK_5c1cf55c308037b5aca1038a131" FOREIGN KEY("userId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "user" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"username"	varchar(11) NOT NULL,
	"password"	varchar(18) NOT NULL,
	"nickname"	varchar(10) NOT NULL,
	"head_img"	varchar NOT NULL DEFAULT (''),
	"gender"	integer NOT NULL DEFAULT (1),
	CONSTRAINT "UQ_78a916df40e02a9deb1c4b75edb" UNIQUE("username")
);
CREATE TABLE IF NOT EXISTS "upload" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"url"	varchar NOT NULL,
	"uid"	integer NOT NULL
);
CREATE TABLE IF NOT EXISTS "category" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar NOT NULL,
	"is_top"	integer NOT NULL DEFAULT (0)
);
INSERT INTO "user" ("id","username","password","nickname","head_img","gender") VALUES (1,'10086','123','官方认证火星网友','',1),
 (2,'100861','123','广州新闻','/uploads/image/IMG1568705287936.jpeg',1),
 (3,'100862','123','娱乐在线','/uploads/image/IMG1568705287936.jpeg',1),
 (4,'100863','123','新华网','/uploads/image/IMG1568705287936.jpeg',1),
 (5,'100864','123','火星时报','/uploads/image/IMG1568705287936.jpeg',1),
 (6,'100865','123','银河护卫队','/uploads/image/IMG1568705287936.jpeg',1),
 (7,'100866','123','鲨鱼联盟','/uploads/image/IMG1568705287936.jpeg',1),
 (8,'100867','123','药材铺老板','/uploads/image/IMG1568705287936.jpeg',1),
 (9,'100868','123','大型止血贴','/uploads/image/IMG1568705287936.jpeg',1),
 (10,'100869','123','三杯鸡养殖户','/uploads/image/IMG1568705287936.jpeg',1),
 (11,'10010','123','woshishui','',1);
INSERT INTO "upload" ("id","url","uid") VALUES (1,'/uploads/image/IMG1568705287936.jpeg',1),
 (2,'http://cms-bucket.ws.126.net/2019/09/17/703782e03135454781ae73ef602e71ba.jpeg?imageView&thumbnail=750x0&quality=85&type=jpg&interlace=1',1),
 (3,'http://cms-bucket.ws.126.net/2019/09/17/176598c5fa6d4810b25299ba51d9dada.png?imageView&thumbnail=750x0&quality=85&type=png&interlace=1',1),
 (4,'http://cms-bucket.ws.126.net/2019/09/17/124857fc2da04deca549bdf9e1fff676.jpeg?imageView&thumbnail=750x0&quality=85&type=jpg&interlace=1',1),
 (5,'https://timgmb04.bdimg.com/timg?searchbox_feed&quality=100&wh_rate=0&size=b576_324&ref=http%3A%2F%2Fwww.baidu.com&sec=1568739067&di=612dd27cae470b93b01a4b32ef72fbac&src=http%3A%2F%2Fpic.rmb.bdstatic.com%2Fe18c6ffa079441431f8988ca4c3ac106.jpeg',1),
 (6,'http://cms-bucket.ws.126.net/2019/09/18/3020045071c34d2ea4a574bdccee7136.png?imageView&thumbnail=750x0&quality=85&type=png&interlace=1',0),
 (7,'https://timgmb01.bdimg.com/timg?searchbox_feed&quality=100&wh_rate=0&size=b576_324&ref=http%3A%2F%2Fwww.baidu.com&sec=1568739067&di=13e00a6373de7a1a7b0dc83df25a8289&src=http%3A%2F%2Fpic.rmb.bdstatic.com%2Fb856dcd6884d81c688088626a9b8da60.jpeg',0),
 (8,'https://cms-bucket.ws.126.net/2019/09/17/47eb99111b8d48bfad3c0b377e5ac58c.png?imageView&thumbnail=234y146&quality=45&interlace=1&enlarge=1&type=webp',0),
 (9,'https://cms-bucket.ws.126.net/2019/09/17/0d8d568a0bf94cb29201e6b4892ca653.png?imageView&thumbnail=234y146&quality=45&interlace=1&enlarge=1&type=webp',0),
 (10,'https://cms-bucket.ws.126.net/2019/09/17/a7ed36f9236d49919f025268f51662e3.png?imageView&thumbnail=234y146&quality=45&interlace=1&enlarge=1&type=webp',0),
 (11,'/uploads/image/IMG1568820150584.jpeg',11),
 (12,'https://cms-bucket.ws.126.net/2019/09/20/5f7cbdce73d5470aa9145cac0d146568.png?imageView&thumbnail=234y146&quality=45&interlace=1&enlarge=1&type=webp',0),
 (13,'http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg?imageView&thumbnail=750x0&quality=85&type=jpg&interlace=1',0),
 (14,'/uploads/image/IMG1569379339406.png',11),
 (15,'/uploads/image/IMG1569379484583.png',11),
 (16,'/uploads/image/IMG1569379522459.png',11),
 (17,'/uploads/image/IMG1569380554436.png',11),
 (18,'/uploads/image/IMG1569380907715.png',11),
 (19,'/uploads/image/IMG1569381049794.jpeg',11),
 (20,'/uploads/image/IMG1569381068121.png',11),
 (21,'/uploads/image/IMG1569381163794.jpeg',11),
 (22,'/uploads/image/IMG1569382889487.png',11),
 (23,'/uploads/image/IMG1569393358174.jpeg',11),
 (24,'/uploads/image/IMG1569393370103.png',11);
INSERT INTO "category" ("id","name","is_top") VALUES (1,'热点',1),
 (2,'娱乐',1),
 (3,'体育',1),
 (4,'财经',1),
 (5,'汽车',1),
 (6,'军事',1),
 (7,'男人',1),
 (8,'视频',1),
 (9,'科技',1),
 (10,'手机',1),
 (11,'女人',0),
 (12,'数码',0),
 (13,'段子',0),
 (14,'时尚',0),
 (15,'游戏',0),
 (16,'教育',0),
 (17,'健康',0),
 (18,'旅游',0),
 (19,'房产',0);
 INSERT INTO "post" ("id","title","content","type","userId") VALUES (1,'阿信分享《说好不哭》幕后故事：只听一次就配唱','<div class=''content''><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/4835afb1bbb94383b7bf1294f4f725d5.jpeg''><img alt=''阿信发文谈与周杰伦合作'' data-src=''http://cms-bucket.ws.126.net/2019/09/17/4835afb1bbb94383b7bf1294f4f725d5.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/4835afb1bbb94383b7bf1294f4f725d5.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>阿信发文谈与周杰伦合作</span></a></div><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/703782e03135454781ae73ef602e71ba.jpeg''><img alt=''阿信与周杰伦合作新曲《说好不哭》'' data-src=''http://cms-bucket.ws.126.net/2019/09/17/703782e03135454781ae73ef602e71ba.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/703782e03135454781ae73ef602e71ba.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>阿信与周杰伦合作新曲《说好不哭》</span></a></div><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/0eb026854f514fc581788be59680c8d9.jpeg''><img alt=''阿信发长文谈与周杰伦合作'' data-src=''http://cms-bucket.ws.126.net/2019/09/17/0eb026854f514fc581788be59680c8d9.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/0eb026854f514fc581788be59680c8d9.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>阿信发长文谈与周杰伦合作</span></a></div><p>9月17日，阿信在个人社交平台上谈与<a href=''http://3g.163.com/touch/idol/star26''><font color=''#009ce5''>周杰伦</font></a>的合作新曲《说好不哭》，他写道：“音乐人的快乐，就是这么朴实无华，且保密。晚点再来跟大家分享这次合作，许多不能说的秘密。”周杰伦也在评论区打趣道：“文笔总是这么好”，阿信也搞怪回复“我有目击到你虐待绞尽脑汁的方文山”，二人隔空互动大秀友情。晚间，阿信发长文谈与周杰伦新歌合作。阿信称金曲奖典礼结束，在周杰伦的录音师完成了新歌《说好不哭》自己的部分。并自评与周杰伦的合作“朴实无华且随性”。</p><p>阿信全文：</p><p>音乐人的合作，就是这么朴实无华且随性。“哎唷，今天晚上要不要来合唱一下？”，“好啊，我晚上颁个奖就过去！”那天是金曲奖，典礼结束，直接轻装潜入杰伦的录音室，诺大的公司，只见到作词人方文山、录音师Gary、还有大家的哥中之哥。</p><p>那是大家少有机会看到的杰伦，一个存在了20年的却不轻易示人，在录音室里专心致意，全神凝聚的周杰伦。“好噢来听一下噢”，密密麻麻的编曲轨道播放，第一次听见这首注定成为经典的歌。这是杰伦只让我听了一次，就把我关进配唱间。一小时后，在杰伦的配唱之下完成了我的部分。“哎唷，是不是来吃个宵夜不错！”会议室的电视回放着当晚的金曲奖，我们吃着外带回来的干面、蛋花汤、当然，还有奶茶。“哎唷，原来你是去颁金曲奖”，原来埋首创作的哥，完全不知道今天是金曲奖，如果没有看到分轨上，一字排开数十轨亲自演唱的细腻和声，你不会知道他花了多少时间在作品上。我喜欢这种感觉，当大家庆祝着过去的成就，而录音室里的我们，正打造全新的作品，奔向未来。</p><p>20年，飞逝的青春，留下此刻的你我。很开心参与杰伦这次合作，过去的眼泪，未来的仿徨，希望这首歌陪伴你，说好不哭。</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：杨明_NV5736)</p></div></div></div>',1,2),
 (2,'52岁王祖贤餐厅独自就餐被拍 长发披肩颜值依旧','<div class=''content''><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/176598c5fa6d4810b25299ba51d9dada.png''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/176598c5fa6d4810b25299ba51d9dada.png'' src=''http://cms-bucket.ws.126.net/2019/09/17/176598c5fa6d4810b25299ba51d9dada.png?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=png&amp;interlace=1''><span></span></a></div><p><b>网易娱乐9月17日报道</b> 近日，有网友晒出了一组在餐厅偶遇王祖贤的照片。当天王祖贤一身黄色纱质上衣配牛仔裤，整个人看上去十分年轻漂亮，虽然素颜亮相依旧难掩气质。当天王祖贤一个人出来就餐，在餐桌上只是默默的刷手机，全神贯注丝毫不受外界的影响。</p><p>在王祖贤准备离开的时候，有粉丝上前求签名，王祖贤一脸灿笑开心答应，并且还在粉丝的手机壳上签名。</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/6f09bdef40c041eda45fb83e28209b7a.png''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/6f09bdef40c041eda45fb83e28209b7a.png'' src=''http://cms-bucket.ws.126.net/2019/09/17/6f09bdef40c041eda45fb83e28209b7a.png?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=png&amp;interlace=1''><span></span></a></div><p>据了解，2001年，王祖贤宣布退出演艺圈，2003年又复出拍了一部电影，之后就到加拿大开始了隐居生活。</p><p><div class=''pk_vote_wrapper'' id=''pkvote_70492''><div class=''words_wrapper''><div class=''red_options''><div class=''flag''><span></span>红方观点</div><p class=''words''>                                女神选择了自己喜欢的生活方式，她喜欢就好。</p></div><div class=''blue_options''><div class=''flag''><span></span>蓝方观点</div><p class=''words''>                                曾经红极一时，现在一个人生活难免有些落寞。</p></div></div><div class=''vote_wrapper''><div class=''red_vote_btn vote_btn'' data-pkvote-optionid=''283056''><span class=''hand''></span><span class=''num''>9981</span></div><div class=''blue_vote_btn vote_btn'' data-pkvote-optionid=''283057''><span class=''hand''></span><span class=''num''>801</span></div><div class=''bars_visual_wrapper''><div class=''bars_wrapper'' style=''transform: translateX(-3.71%);-webkit-transform: translateX(-3.71%);''><div class=''red_bars''></div><span class=''red_corner''></span><span class=''blue_corner''></span><div class=''blue_bars''></div></div></div></div></div></p><div class=''otitle_editor''><p class=''editor''>(责任编辑：马文静_NBJS9027)</p></div></div></div>',1,3),
 (3,'曝詹妮弗·劳伦斯现身婚姻登记处秘密完婚','<div class=''content''><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/124857fc2da04deca549bdf9e1fff676.jpeg''><img alt=''詹妮弗·劳伦斯（Jennifer Lawrence）与未婚夫Cooke Maroney'' data-src=''http://cms-bucket.ws.126.net/2019/09/17/124857fc2da04deca549bdf9e1fff676.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/124857fc2da04deca549bdf9e1fff676.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>詹妮弗·劳伦斯（Jennifer Lawrence）与未婚夫Cooke Maroney</span></a></div><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/905f970f79bc429caf8a529557e14afa.jpeg''><img alt=''詹妮弗·劳伦斯（Jennifer Lawrence）'' data-src=''http://cms-bucket.ws.126.net/2019/09/17/905f970f79bc429caf8a529557e14afa.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/905f970f79bc429caf8a529557e14afa.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>詹妮弗·劳伦斯（Jennifer Lawrence）</span></a></div><p><b>网易娱乐9月17日报道</b> 据香港媒体报道，奥斯卡金像影后詹妮弗·劳伦斯（Jennifer Lawrence）与未婚夫Cooke Maroney昨日被拍到穿便服现身纽约市曼哈顿婚姻注册署，在旁有两名保安、一名摄影师以及一名好友，未婚夫更被拍到手持一张疑似结婚证书的白纸，因而被怀疑二人已秘密结婚！</p><p>有目击者留言说：“当你去领结婚证，而詹妮弗·劳伦斯就在你眼前路过并去结婚，市政厅是个好去处！“有指二人计划于下个月大搞婚礼派对庆祝。詹妮弗·劳伦斯与Cooke于今年2月订婚，早前詹妮弗·劳伦斯接受受访时表示一直都未准备结婚，直至认识Cooke之后就想嫁给他，她说：“他是我最好的朋友，感觉好荣幸成为Maroney家族一份子。”詹妮弗·劳伦斯曾先后与乐队Coldplay主音Chris Martin、影星尼古拉斯霍特（Nicholas Hoult）以及导演Darren Aronofsky谈过恋爱。</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：杨明_NV5736)</p></div></div></div>',1,3),
 (4,'美女一首《亲爱的姑娘我爱你》，听得耳朵都酥了，不自觉就爱上了','https://vd4.bdstatic.com/mda-jigg7aap5hce06x7/sc/mda-jigg7aap5hce06x7.mp4?auth_key=1568740877-0-0-b643e61321c36c256a6985628ccce099&bcevod_channel=searchbox_feed&abtest=all',2,3),
 (5,'华为首发计算战略 推出全球最快AI训练集群Atlas900','<div class=''content''><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/18/3020045071c34d2ea4a574bdccee7136.png''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/18/3020045071c34d2ea4a574bdccee7136.png'' src=''http://cms-bucket.ws.126.net/2019/09/18/3020045071c34d2ea4a574bdccee7136.png?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=png&amp;interlace=1''><span></span></a></div><p>网易科技讯 9月18日消息，今天华为全联接大会在上海召开。大会上，华为副董事长胡厚崑表示华为现在状态非常不错，并且宣布了华为全新计算战略。</p><p>华为副董事长胡厚崑大会上提到，过去半年来，华为是顶着巨大压力过来的。华为现在状态非常不错，就像上海的天气一样，秋高气爽，云淡风轻。</p><p>“感谢在这个关键时刻对华为的支持。你们对我们的支持，给了华为淡定从容的定力，华为不会让你们失望的。”胡厚崑表示。</p><p>华为过去30年一直在做联接，但绝对不仅仅只做连接。胡厚崑表示，构建智能世界的两大关键技术就是联接和计算，就像两个孪生兄弟一样。其实，华为对计算的投入有10年时间了。面向未来，华为越来越意识到，计算是必须持续投入的领域。进入智能时代，计算将无处不在。</p><p>胡厚崑表示，未来十年将迎来计算新蓝图。来自Gartner的数据显示，未来5年计算产业每年将达2万亿美元市场。</p><p>因此，华为宣布了新的计算产业战略包括架构创新、投资全场景处理器、商业策略“有所为有所不为”、构建开放生态四部分。</p><p>在架构创新方面，主要是华为的达芬奇架构，这是打造智能战略的基础。</p><p>在处理器方面，华为意识到只有打造出更有竞争力的处理器，才能更有竞争力。华为已经推出了鲲鹏、昇腾、麒麟、鸿鹄四大系列处理器。</p><p>胡厚崑表示，未来华为将面向更多场景，推出更多处理器。</p><p>在商业策略方面，华为要有所为有所不为。</p><p>胡厚崑明确：“华为不准备独立对外销售处理器，但华为会向用户提供打包云服务，将AI模组和软件进行开放和开源；华为不做应用，但华为会投入专门的工具帮助伙伴做迁移。”</p><p>在生态建设方面，2015年华为发布了第一个版本沃土计划，经过四年发展，华为沃土计划发展了超过130万个开发者。</p><p>胡厚崑今天宣布了新一轮沃土计划，投资15亿美元，进一步扩大开发者，扩大到500万人的规模。</p><p>去年华为提出了全栈全场景AI解决方案，今天，胡厚崑表示该战略已经全面落地。同时，发布了Atlas900全球最快的AI训练集群。</p></div><div class=''page js-page''><p>在衡量AI计算能力的金标准ResNet-50模型训练中，Atlas 900只用了59.8秒就完成了训练，这比原来的世界记录还快了10秒。“这是什么概念？相当于短跑冠军跑完终点，喝完一瓶水才等到第二名。”胡厚崑提到。</p><p>胡厚崑分享了华为联合上海天文台与SKA共同打造的一个天文探索的案例。在南半球有20万颗星星，用人眼是看不见这么多星星的，当前条件下，天文学家要从这20万颗星星中，找出某种特征的星体，相当困难，需要169天的工作量。现在用上Atlas 900，只用10秒，就从20万颗星星中检索出了相应特征的星体。</p><p>胡厚崑表示，Atlas 900的超强算力已经部署在华为云上，欢迎各行业，各领域使用。（崔玉贤）</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：乔俊婧_NBJ11279)</p></div></div></div>',1,4),
 (7,'性感女歌手一首DJ《情火》，动感激情，听了一遍又一遍','https://vd4.bdstatic.com/mda-jigm2w3xxpfgfg9y/sc/mda-jigm2w3xxpfgfg9y.mp4?auth_key=1568816604-0-0-52d6f09c249827e9247fc0ef48f50024&bcevod_channel=searchbox_feed&abtest=all',2,4),
 (8,'最适合学外语的7部动画片 你看过几个？','<div class=''content''><div class=''page js-page on''><p>英语变成和Word一样普遍的必备技能时，学一门二外就被许多人提上了日程。</p><p>法语、日语、西班牙语、乃至德语、意大利语都成了心水的选项。</p><p>法语多浪漫啊，学好日语还可以去漫画圣地打卡。西语的机关枪语速、德语与英语的“亲戚关系”、意大利语难发的大舌音，每一个都让人好奇。</p><p>但考虑到英语学了十来年也谈不上精通，再加一门二外，岂不是捡芝麻丢西瓜？</p><p>别担心。都说小孩子是学语言最快最轻松的。他们常看的儿童节目也是重要的语言输入来源之一。</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/9284b6b83fdb416490c18ef26a928ee0.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/9284b6b83fdb416490c18ef26a928ee0.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/9284b6b83fdb416490c18ef26a928ee0.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div><p><strong>像小朋友一样学习一门语言</strong></p><p>Kids’ cartoons—even the silliest or action-oriented ones—are meant to be educational to some degree. Because they’re aimed at children, they introduce and reinforce important cultural aspects that adult dramas take for granted.</p><p>儿童卡通片，哪怕是有很多动作场面的蠢蠢的那种，也是有着教育意义的。正因为卡通片瞄准的受众是儿童，动画片会介绍和强调重要的文化背景，这类知识在成人电视剧里通常是一带而过。</p><p><strong>动画片很容易跟上</strong></p><p>The basic plot lines of kid’s cartoons are fairly simple and take place in familiar, everyday settings, such as schools and homes. That means you’ll become familiar with all the everyday phrases. The characters speak more slowly, and the dialogue is typically standard, casual language, without the idiomatic phrases or regional dialects that can make it hard to understand.</p></div><div class=''page js-page on''><p>儿童卡通的剧情线一般都很简单，故事场景也都是熟悉的日常生活场景，比方说学校和家里。也就是说你可以通过看动画片来熟悉日常短语的表达。动画角色的语速比较慢，对话也都是典型的标准非正式语言，不会牵涉到艰涩的习语和方言。</p><p><strong>动画片本身就很有趣</strong></p><p>Think Peppa Pig, the pink piggy who has gained worldwide popularity. There are even videos showing an American child speaking in a British accent to her mom after binge-watching the popular cartoon.</p><p>想想《小猪佩奇》，作为儿童卡通居然火遍全球。网上甚至还有视频显示一个美国小孩儿跟她妈妈说话带着英国口音，就是因为看多了这部动画。</p><p>刚开始学一门语言时，你发不准某个音的样子不是跟小朋友很像吗？来看看他们都看哪些节目吧↓↓↓</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/dd24c4b8bc584fb89c76b29ba87049a4.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/dd24c4b8bc584fb89c76b29ba87049a4.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/dd24c4b8bc584fb89c76b29ba87049a4.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div><p><strong>01?</strong><strong>英语</strong></p><p><strong>The Simpsons</strong><strong>《辛普森一家》</strong></p><p>The Simpsons in the ''90s was smart, culturally savvy, and unbelievably entertaining TV about an average American family. At its height, no show — animated or otherwise — could reach The Simpsons'' greatness. From the cleverness of ''Marge vs. the Monorail'' to everything Lisa Simpson ever said, ''90s era The Simpsons was fearless and game-changing television.</p></div><div class=''page js-page on''><p>《辛普森一家》是上世纪90年代一部很优秀且文化含义丰富的娱乐性电视卡通。它讲述的是一个普通美国家庭的故事。在该动画的鼎盛时期，没有哪一部动画片能企及《辛普森一家》的伟大成就。从《玛姬与单轨火车》的巧妙设计，到卡通角色丽萨·辛普森所说的所有台词，90年代的《辛普森一家》所向披靡，改变了电视行业的面貌。</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/4a266e3726e34fdaadb1c435b2675740.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/4a266e3726e34fdaadb1c435b2675740.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/4a266e3726e34fdaadb1c435b2675740.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div><p><strong>02英语</strong></p><p><strong>King of the Hill</strong><strong>《乡巴佬希尔一家的幸福生活》</strong></p><p>King of the Hill depicts an average middle-class family and their lives in a typical American town. It documents the Hills'' day-to-day-lives in the small Texas town of Arlen, exploring modern themes such as parent-child relationships, friendship, loyalty, and justice. As an animated sitcom, however, King of the Hill''s scope is generally larger than that of a regular sitcom.</p><p>《乡巴佬希尔一家的幸福生活》描绘了一个普通的中产阶级家庭和他们在一个典型的美国小镇上的生活。它记录了希尔在德克萨斯小镇阿伦的日常生活，探讨了诸多现代主题，如亲子关系、友谊、忠诚和正义。然而，作为一部动画情景喜剧，《乡巴佬希尔一家的幸福生活》的视野比普通情景喜剧要更大。</p><p>You most likely had to have parental supervision to watch King of the Hill, but the show''s depiction of small town life was so accurate and warm, it was worth sitting through the ''adult'' moments with mom and dad in the room.</p></div><div class=''page js-page on''><p>你最好是在父母的陪同之下观看《乡巴佬希尔一家的幸福生活》。这部动画对于小镇生活的刻画十分准确，又温暖人心。哪怕是里面有一些所谓“少儿不宜”的内容，它也值得你和父母坐在家里一起看完。</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/e43f116c7af74ea883722675464321c7.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/e43f116c7af74ea883722675464321c7.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/e43f116c7af74ea883722675464321c7.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div><p><strong>03</strong><strong>法语</strong></p><p><strong>Il était une fois</strong><strong>《曾几何时》</strong></p><p>Il était une fois, also called Once Upon a Time, is a French educational animation franchise, created by Procidis. There are seven distinct series, each focusing on different aspects of knowledge. These are mostly historical, with Once Upon a Time… Man being focused on the overall history of mankind, and most of the others are more focused on specified historical fields, such as the lives and exploits of the explorers or inventors. Life, however, featured an explanation on the workings of the body.</p><p>Ilétait une fois,又名《曾几何时》，是一部法国教育动画，由Procidis创建。该动画有七个不同的系列，每一个系列集中讲述人类知识的一个方面。这些知识大多是与历史有关的，比方说《曾几何时……人类》关注的就是整个人类的历史，而其他大多数系列关注的也是特定的历史切片，比如说探险家或发明家的丰功伟绩与生活。此外，另一个系列《曾几何时……生命》的关注点就是解释人体的运行机制。</p></div><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/d9278806fb764678b7f9cdf032adb7bf.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/d9278806fb764678b7f9cdf032adb7bf.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/d9278806fb764678b7f9cdf032adb7bf.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div><p><strong>04</strong><strong>日语</strong></p><p><strong>サザエさん(</strong><strong>さざえさん)</strong><strong>–Sazae-san</strong><strong>《海螺小姐》</strong></p><p>Sazae-san is more than a kids’ show. It’s a cultural institution, a national treasure and the longest-running animated series in the world, ever!</p><p>《海螺小姐》不仅仅是一部儿童动画。它已经成了一种文化，一种国家财富，同时也是世界上播放时间最长的动画连续剧。</p><p>It’s about a typical Japanese大家族(だいかぞく –big family) living together in Tokyo. The central character isサザエ, an outspoken but somewhat clumsy woman in her early 20s, living with her husband, son, father, mother, brother and sister all under one roof.</p><p>该动画讲述的是住在东京的一个大家族的故事。动画的主角是サザエ(Sazae)，一位20岁出头，有点笨拙却又大大咧咧的女孩儿，她和自己的丈夫、儿子、父母、还有兄弟姐妹住在同一个屋檐下。</p><p>All of the characters are colorful and funny, and all are named after fish! (サザエis horned turban, a seafood delicacy.)サザエさんstarted off as a comic strip, but is now better-known as a cartoon. It is not unusual for families to plan their Sundays around its 6:30 p.m. time slot.</p></div><div class=''page js-page on''><p>这部卡通的所有角色都很立体，也很有趣，而且所有角色的名字都和鱼类有关（サザエ就是“海螺”）。《海螺小姐》起初是连载漫画，后来才被制作成动画而广为人知。每个周日的下午六点半很多家庭都会围坐在一起看这部动画。</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/b14959c2769b4049bf3419325ad74e45.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/b14959c2769b4049bf3419325ad74e45.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/b14959c2769b4049bf3419325ad74e45.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div><p><strong>05</strong><strong>德语</strong></p><p><strong>Janoschs Traumstunde</strong><strong>《雅诺思的梦幻时刻》</strong></p><p>Janoschs Traumstunde is a German animated children''s television series that originally ran from 1986 to 1990. It is based on the works of German artist and children''s book author Janosch.</p><p>《雅诺思的梦幻时刻》最初是于1986-1990年在德国播出的少儿动画电视剧。该动画是从德国艺术家及童书作家雅诺思的作品衍生出来的。</p><p>It is a critically acclaimed and universally beloved cartoon series. Most of the episodes tell a number of self-contained stories, featuring popular characters from the author’s children’s books, such as “Tiger und B?r” and others.</p><p>该动画广受业内人士好评，同时也深受大众喜爱。大多数的剧集讲述的都是独立的故事，故事中会出现作者童书中人气很高的角色，比方说老虎和熊等。</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/a0f1363f667240ceaabf3f35f7b729cd.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/a0f1363f667240ceaabf3f35f7b729cd.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/a0f1363f667240ceaabf3f35f7b729cd.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div></div><div class=''page js-page on''><p><strong>06</strong><strong>德语</strong></p><p><strong>Kpt’n Blaub?r</strong><strong>《蓝熊船长》</strong></p><p>Based on the comics by Walter Moers, this German cartoon series deals with the adventures of the eponymous Captain Blaub?r, a blue bear spinning yarns about his journeys on the Seven Seas. Each episode is framed by a little story where the captain interacts with his grandchildren, and at its center there is an animated cartoon detailing the often hilarious tales of the old seaman.</p><p>这部动画片以沃尔特·莫尔斯的漫画为基础，讲述了蓝熊船长的冒险故事，他喜欢夸夸其谈地讲述自己在七大洋上旅行的事迹。该动画的每一集都有一个小故事作为框架，故事中的船长和他的孙子孙女们互动。故事的核心通常是蓝熊船长这位老海员的滑稽轶事。</p><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/17/c82fce0bfa2b403f81ed24b8fd962a4b.jpeg''><img alt='''' data-src=''http://cms-bucket.ws.126.net/2019/09/17/c82fce0bfa2b403f81ed24b8fd962a4b.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/17/c82fce0bfa2b403f81ed24b8fd962a4b.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span></span></a></div><p><strong>07?</strong><strong>西班牙语</strong></p><p><strong>El Oso Yogui</strong><strong>《瑜伽熊》</strong></p><p>Yogi Bear is an anthropomorphic funny animal who has appeared in numerous comic books, animated television shows and films. He was created by Hanna-Barbera.</p></div><div class=''page js-page on''><p>瑜伽熊是一个搞笑的拟人化动物角色，它曾出现在许多漫画书、动画电视节目和电影中。该角色由汉娜·巴贝拉创作。</p><p>The plot of most of Yogi''s cartoons centered on his antics in the fictional Jellystone Park, a variant of the real Yellowstone National Park. Yogi, accompanied by his constant companion Boo-Boo Bear, would often try to steal picnic baskets from campers in the park, much to the displeasure of Park Ranger Smith. Yogi''s girlfriend, Cindy Bear, sometimes appeared and usually disapproved of Yogi''s antics.</p><p>瑜珈熊动画的大部分情节都集中于他在 “酱石公园”里的滑稽行为之上，“酱石公园”对应的是真实世界里的黄石国家公园。瑜珈熊通常和他的同伴博博熊一起出现，他们经常试图从公园露营者那里偷野餐篮子，惹得公园管理员史密斯很不高兴。瑜珈熊的女朋友—辛迪熊，有时也出现在剧集里，通常很鄙夷瑜珈熊的滑稽行为。</p><p>看到这里，你种草了哪一门语言呢？</p><p>趁头发还有这么多，赶紧装作小朋友，学起来吧。</p><p><strong>Notes</strong></p><p>sitcom n.情景喜剧</p><p>reinforce v.加强；使更强烈</p><p>binge v.大吃大喝；狂欢作乐</p><p>depict v.描绘；描画；描述</p><p>acclaim n./v.赞扬；欢呼；欢迎</p><p>eponymous adj.（与标题）同名的</p><p>anthropomorphic adj.人格化的</p><p>antic adj.滑稽的；古怪的</p><p>variant n.变体；变形</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：杨卉_NQ4978)</p></div></div></div>',2,5),
 (9,'双语阅读：当代青年网恋观察 奔现就像买彩票','<div class=''content''><div class=''page js-page on''><p>As we spend more and more of our lives online, inevitably we discover ourselves flirting with people we have never met in real life - you might even call it having a crush.</p><p>我们花在网上的时间越来越多，自然而然就会更容易和现实中没见过的人撩起来，有人甚至会说“我网恋了”。</p><p>There’s something about the dynamism of social media that feels both more truthful and more mysterious. You have lots of intimate knowledge of a person but you can’t see them.</p><p>社交媒体的运行机制会让人觉得既有非常真实的一面，也有十分神秘的一面。你知道很多屏幕那头人的秘密，但你却从未见过他/她。</p><p><strong>01</strong><strong>奔现和买彩票差不多</strong></p><p>When we would eventually meet, sometimes it was pure magic, one of these rare times in a life when everything finally seemed to fit together and I felt I''d met my other half. Other times it was… well, less magic, because the spark in the person didn''t match the connection we made online.</p><p>有时候和网撩对象见面会很有化学反应，这种反应一辈子可能都少见，好像一切都很合拍，找到真爱了的感觉。不过有的时候见面就……呃，没那么合适，面对面的交流还没有网聊的时候有火花四溅的感觉。</p><p>Sometimes the other person and I would feel the same way, whether we were overwhelmed or underwhelmed. Even worse than both of us being disappointed was when one of us would be thrilled while the other was not, which would eventually result in hurt feelings on both sides.</p></div><div class=''page js-page''><p>有时候对方和我想得一样，不管是有被惊喜到还是感觉很无聊。但比我俩都很失望还要更糟糕的情况是这样的：我俩其中一位感觉对方很不错，但对方却无感。这种情况最终会伤害双方。</p><p>The first time I met an online love it was magic, and as a longtime romantic I simply assumed it would feel like that every time. So I was shocked when the second time I met someone I had connected with online, there was no magic, no spark, none of what I was so sure would happen because it had happened once before.</p><p>我第一次见网友的经历就很棒，非常浪漫，以至于我误以为网聊奔现都应该是这种美好的感觉。所以第二次奔现的时候就很幻灭，两人之间完全没有火花，根本不是我之前经历的那种浪漫状况。</p><p>On the bright side, she and I have been good friends ever since. And the few more times I have met someone online and then met in person some time later, the experience has been somewhere in between the first and second times—some spark but not fireworks.</p><p>不过也不完全是坏事儿，我和她后来成了朋友。后来几次我跟人网聊之后再奔现，感觉都处在最初两次的感受之间——有点化学反应，但并非一见钟情。</p><p><strong>02</strong><strong>糟糕，被发现了</strong></p><p>Once I had a crush on a guy. From the internet. And I was secretly watching a YouTube video that he had posted. And my finger slipped and I accidentally clicked ''like'' or ''thumbs up'' or whatever.</p></div><div class=''page js-page''><p>有次我对一个网撩的男生有好感。然后我就在网上看他发的视频，结果一不小心手滑，按了赞！</p><p>And this was the first time I realized that YouTube was directly, horrifyingly linked to my Gmail. So there was my face, next to a thumbs up of this video that I was secretly, creepily watching. And I freaked out. And was like ''Undo! Undo! Undo!!!</p><p>那时我才知道油管账号是直接跟我的邮箱绑定的。所以我的邮箱头像就出现在了视频底下的“点赞区”，显示出我在偷偷看他的视频。我吓坏了，疯狂找：“撤回，有没有撤回键！”</p><p>So then I clicked ''thumbs down'' thinking that would undo it somehow, but no, obviously that just meant that now my face was on the YouTube video next to a thumbs down icon and it was very embarrassing, and then when we met in real life, I pretended to barely know who he was even though obviously I''d watched his video.</p><p>结果我就点了“踩”……想着应该可以抵消那个赞。但是并没有，我的头像只是从“按赞区”移动到了“按踩区”，尴尬。之后我和他奔现的时候，我都装作不太了解他的样子，哪怕很显然我看过他的视频。</p><p><strong>03</strong><strong>看过你的历史，我们才有未来</strong></p><p>I started a new job about a year ago and was surprised to discover that my boss, the editor-in-chief, was a pretty young, kinda hot dude - in a hot dad way. But we never really interact in person since he''s not my direct boss.</p></div><div class=''page js-page''><p>一年前我换了份新工作，很惊喜地发现我的上司——也就是主编——还是蛮年轻的帅大叔。但其实我们并没有太多接触，因为他并不是我的直属上司。</p><p>But in my first week he started following me on Twitter, which I was really flattered by because he only follows a few hundred people on Twitter. Then I wrote something and he tweeted about it, so I faved that.</p><p>但工作的第一周他就在推特上关注了我，我有点受宠若惊，因为他也就关注了几百个人而已。我发过的推文也被他转发过，然后我就给他的转发点了赞。</p><p>Then I realized I was favoriting quite a few of his tweets, and then things got weird where I was like faving his tweets on Saturdays, or going back to old tweets and faving those. I think I thought I was being subtle and saying ''oh, heyyyyy,'' except it wasn''t subtle at all.</p><p>后来我发现我给他的很多条推文都点过赞。之后就越来越诡异了，周六休息日给他点赞也就算了，我还翻到他的历史推文里按赞。我内心想的是，这是很隐晦的表示“诶，我对你有意思”。但其实这么做简直昭然若揭啊。</p><p><strong>04朋友的朋友才是中奖的那个</strong></p><p>In 2009 I befriended a guy whom one of my other friends had gone out with a few times. Once he accepted my Facebook friend request, I naturally went to look at all of his recent photos. In his photos was another guy that caught my attention, so I went and looked at his profile and lurked behind all of his photos. ''What a babe,'' I thought. I was immediately obsessed.</p></div><div class=''page js-page''><p>2009年我加了一个男生，我有个朋友跟他出去玩儿过几次。他刚一接受我的脸书好友申请，我就自觉跑到他的相册里翻看。照片里有个男生吸引了我的注意力，然后我就点进去看他的主页，鬼鬼祟祟地翻看他的照片。“好帅啊”，我心想。我感觉我恋爱了。</p><p>I decided to take my virtual stalking offline by messaging our mutual friend and not-so-subtly asking for him to hook us up. Go big or go home, right?</p><p>我决定到线下去追这个男生。然后我就给我俩共同的朋友发了消息，明目张胆地叫他给我俩牵线搭桥。要么就玩大的，要么就别玩，不是吗？</p><p>To make a long story short, yadda yadda yadda, Billy and I got married in December 2013!</p><p>总而言之，啦啦啦哈哈哈哈，我和比利在2013年12月完婚啦！</p><p>There is always going to be a divide, however, between our public persona(e)—whether presented via Twitter or Facebook—and who we are in the physical realm.</p><p>我们用来社交的公共人格——无论是推特还是脸书上的形象——和现实中的我们肯定是有区别的。</p><p>On social media, you get all the fun, interesting parts of someone without having to deal with the things that are difficult or dull about them. They are not presenting to you, for the most part—or at least in any way that actually affects you—their idiosyncrasies, emotional unavailability, or the way they chew with their mouth open.</p></div><div class=''page js-page''><p>在社媒上，你只会看到别人生活中有趣好玩的部分，不会看到他们生活中的困难和乏味。绝大多数时候，至少为了不影响到你，他们不会向你展示他们的小癖好、不愿传递的情感、以及大声吧唧嘴的样子。</p><p>If you want my advice, don''t avoid making online connections—they can be marvelous experiences while they last. But I would recommend trying to meet each other before your feelings become so intense that you''ll be seriously heartbroken if that initial meeting doesn''t go well.</p><p>如果要我给建议，我会说一定要建立网撩关系——如果能长久，那必定是超棒的经历。不过我也会建议说，尽量在两人聊得热火朝天之前就奔现，这么做可以避免过高的期望值在不甚满意的初见打击下碎成一地的情况。</p><p>Think of it as having a crush for a long time: you may idealize someone to such an extent that when you finally get to meet them, you can''t help but be disappointed by the real person you actually meet.</p><p>想想暗恋某个人很长一段时间的体验：你会把对方理想化，程度越来越深。等到最终和对方奔现的时候，见到真实的人，你根本扛不住失望的心情。</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：郑娟_NQ0738)</p></div></div></div>',1,8),
 (10,'耿直！关晓彤大方回应私服争议：时好时坏吧','<div class=''content''><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg''><img alt=''关晓彤谈私服问题'' data-src=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>关晓彤谈私服问题</span></a></div><p> 近日，关晓彤接受某时尚媒体采被问及私服问题时，大方回应称，“（私服）时好时坏吧，因为我的衣服老把自己分好多节。”同时她还劝诫道：“个高的女生不适合get我的同款。”</p><p>对此，网友留言纷纷表示：“性格不错”、“智商情商都在线的女生”。</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：李思_NBJ11322)</p></div></div></div>',1,8),
 (11,'关晓彤回家吃饭了','<div class=''content''><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg''><img alt=''关晓彤谈私服问题'' data-src=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>关晓彤谈私服问题</span></a></div><p> 近日，关晓彤接受某时尚媒体采被问及私服问题时，大方回应称，“（私服）时好时坏吧，因为我的衣服老把自己分好多节。”同时她还劝诫道：“个高的女生不适合get我的同款。”</p><p>对此，网友留言纷纷表示：“性格不错”、“智商情商都在线的女生”。</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：李思_NBJ11322)</p></div></div></div>',1,8),
 (12,'关晓彤，下雨了回家收衣服吧','<div class=''content''><div class=''page js-page on''><div class=''photo''><a href=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg''><img alt=''关晓彤谈私服问题'' data-src=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg'' src=''http://cms-bucket.ws.126.net/2019/09/23/1129a4a737c5429d92f5d7478d19873d.jpeg?imageView&amp;thumbnail=750x0&amp;quality=85&amp;type=jpg&amp;interlace=1''><span>关晓彤谈私服问题</span></a></div><p> 近日，关晓彤接受某时尚媒体采被问及私服问题时，大方回应称，“（私服）时好时坏吧，因为我的衣服老把自己分好多节。”同时她还劝诫道：“个高的女生不适合get我的同款。”</p><p>对此，网友留言纷纷表示：“性格不错”、“智商情商都在线的女生”。</p><div class=''otitle_editor''><p class=''editor''>(责任编辑：李思_NBJ11322)</p></div></div></div>',1,8);

INSERT INTO "post_comment" ("id","content","userId","postId","parentId") VALUES (1,'123',11,1,NULL),
 (2,'234',11,1,NULL),
 (3,'111',11,1,NULL),
 (4,'444',11,1,2),
 (5,'222',11,1,3),
 (6,'22',11,1,3),
 (7,'333',11,1,3),
 (8,'444',11,1,7),
 (9,'555',11,1,7),
 (10,'666',11,1,7);
INSERT INTO "user_post_star_post" ("userId","postId") VALUES (5,1),
 (5,2),
 (11,2),
 (11,5),
 (11,4),
 (11,8),
 (11,1);
INSERT INTO "user_follows_user" ("userId_1","userId_2") VALUES (11,6),
 (11,3),
 (11,2);
INSERT INTO "post_categories_category" ("postId","categoryId") VALUES (1,1),
 (1,2),
 (2,1),
 (2,2),
 (2,11),
 (2,14),
 (3,1),
 (3,2),
 (3,11),
 (3,14),
 (4,1),
 (4,2),
 (4,7),
 (4,8),
 (4,11),
 (4,14),
 (5,1),
 (5,2),
 (5,7),
 (5,9),
 (5,12),
 (5,14),
 (5,16),
 (7,1),
 (7,2),
 (7,7),
 (7,8),
 (7,11),
 (7,14),
 (7,16),
 (7,17),
 (8,1),
 (8,10),
 (8,12),
 (8,13),
 (8,16),
 (8,17),
 (9,1),
 (9,4),
 (9,7),
 (9,13),
 (9,16),
 (9,17),
 (10,2),
 (10,14),
 (11,2),
 (11,14),
 (12,1),
 (12,2),
 (12,14);
INSERT INTO "post_like_users_user" ("postId","userId") VALUES (1,5),
 (2,11),
 (8,11),
 (1,11);
INSERT INTO "post_cover_upload" ("postId","uploadId") VALUES (1,2),
 (2,3),
 (3,4),
 (4,5),
 (5,6),
 (7,7),
 (8,8),
 (8,9),
 (8,10),
 (9,12),
 (10,13),
 (11,13),
 (12,9),
 (12,12),
 (12,13);

CREATE INDEX IF NOT EXISTS "IDX_a62933d561c31fc90c5c2e8e7d" ON "user_post_star_post" (
	"postId"
);
CREATE INDEX IF NOT EXISTS "IDX_c5c365c016809e8aa4cfae53f6" ON "user_post_star_post" (
	"userId"
);
CREATE INDEX IF NOT EXISTS "IDX_da5eb1d232421542d4fb33ac41" ON "user_follows_user" (
	"userId_2"
);
CREATE INDEX IF NOT EXISTS "IDX_911345dc417fb10f25f7644cc6" ON "user_follows_user" (
	"userId_1"
);
CREATE INDEX IF NOT EXISTS "IDX_a5e63f80ca58e7296d5864bd2d" ON "post_categories_category" (
	"categoryId"
);
CREATE INDEX IF NOT EXISTS "IDX_93b566d522b73cb8bc46f7405b" ON "post_categories_category" (
	"postId"
);
CREATE INDEX IF NOT EXISTS "IDX_701dd0cfc5bc38ede4f8a11257" ON "post_like_users_user" (
	"userId"
);
CREATE INDEX IF NOT EXISTS "IDX_e0c6eb857edb4374d07a7175a3" ON "post_like_users_user" (
	"postId"
);
CREATE INDEX IF NOT EXISTS "IDX_f69ff461a7d7a83b64e5ac5189" ON "post_cover_upload" (
	"uploadId"
);
CREATE INDEX IF NOT EXISTS "IDX_b9a00cd8d070cce5c13d43dbf5" ON "post_cover_upload" (
	"postId"
);
CREATE INDEX IF NOT EXISTS "IDX_0cb77d79c53f0759b8153ec8a6" ON "category_posts_post" (
	"postId"
);
CREATE INDEX IF NOT EXISTS "IDX_3a1f3735235af2f4b702a3d398" ON "category_posts_post" (
	"categoryId"
);
COMMIT;
