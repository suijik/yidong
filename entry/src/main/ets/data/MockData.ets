import { CampusNewsItem } from '../model/CampusNews';
import { CourseItem } from '../model/Course';
import { WeatherData } from '../model/Weather';
import { QuickEntryItem } from '../model/QuickEntry';

// 校园公告模拟数据
export const MOCK_ANNOUNCEMENTS: CampusNewsItem[] = [
  {
    id: 1,
    title: '关于2025-2026学年第二学期期末考试安排的通知',
    summary: '各学院（部）：现将本学期期末考试工作安排通知如下，请各学院认真做好考前准备工作...',
    content: '各学院（部）：\n\n根据学校教学工作安排，2025-2026学年第二学期期末考试定于2026年7月1日至7月14日进行。现将有关事项通知如下：\n\n一、考试时间\n2026年7月1日（星期一）至7月14日（星期日），每天上午8:00-12:00，下午14:00-18:00。\n\n二、考试安排\n各科目具体考试时间及地点请登录教务系统查询。请各学院教学秘书于6月20日前完成考场安排。\n\n三、注意事项\n1. 学生须携带学生证和身份证参加考试，证件不齐者不得进入考场。\n2. 考试期间请严格遵守考场纪律，严禁携带手机等电子设备进入考场。\n3. 因特殊原因不能参加考试的学生，须提前办理缓考手续。\n\n请各学院认真做好考前准备工作，确保考试工作顺利进行。',
    source: '教务处',
    imageUrl: '',
    publishTime: '2026-06-10',
    category: '教务通知'
  },
  {
    id: 2,
    title: '图书馆暑期开放时间调整公告',
    summary: '根据学校暑期工作安排，图书馆自7月1日起调整开放时间，具体安排请参见附件...',
    content: '各位读者：\n\n根据学校暑期工作安排，图书馆自2026年7月1日至8月31日执行暑期开放时间，具体安排如下：\n\n一、开放区域\n主馆：一至三层阅览区正常开放。\n分馆：暂停开放。\n\n二、开放时间\n周一至周五：8:00-18:00\n周六、周日：9:00-17:00\n\n三、服务说明\n1. 暑期期间暂停馆际互借服务。\n2. 电子资源24小时正常访问。\n3. 暑期到期的图书自动延期至开学后两周。\n\n四、联系方式\n咨询电话：010-12345678\n\n特此公告。',
    source: '图书馆',
    imageUrl: '',
    publishTime: '2026-06-08',
    category: '图书馆'
  },
  {
    id: 3,
    title: '校园文化艺术节系列活动预告',
    summary: '为丰富校园文化生活，学校将于6月15日-20日举办校园文化艺术节系列活动...',
    content: '全校师生：\n\n为丰富校园文化生活，展示我校师生艺术风采，学校将于2026年6月15日至20日举办第十六届校园文化艺术节。具体活动安排如下：\n\n一、活动主题\n"青春飞扬，艺韵校园"\n\n二、活动安排\n\n6月15日 19:00 — 开幕式暨文艺晚会（校体育馆）\n6月16日 14:00 — 书法绘画作品展（艺术楼展厅）\n6月17日 19:00 — 校园歌手大赛决赛（学生活动中心）\n6月18日 15:00 — 戏剧小品专场演出（音乐厅）\n6月19日 10:00 — 传统文化体验日（文化广场）\n6月20日 19:00 — 闭幕式暨颁奖典礼（校体育馆）\n\n三、参与方式\n各项活动面向全校师生开放，部分活动需提前报名，详情请关注校团委微信公众号。\n\n欢迎广大师生积极参与！',
    source: '校团委',
    imageUrl: '',
    publishTime: '2026-06-05',
    category: '校园活动'
  }
];

// 校园资讯分类数据
export const MOCK_CAMPUS_NEWS: CampusNewsItem[] = [
  {
    id: 101,
    title: '我校计算机科学学科进入ESI全球前1%',
    summary: '据最新ESI数据统计，我校计算机科学学科首次进入ESI全球排名前1%，实现了历史性突破...',
    content: '据科睿唯安（Clarivate）2026年5月发布的最新ESI（Essential Science Indicators）数据显示，我校计算机科学学科首次进入ESI全球排名前1%，标志着该学科迈入了国际高水平学科行列。\n\nESI是衡量科学研究绩效、跟踪科学发展趋势的基本分析评价工具，已成为当今世界范围内普遍用以评价高校、学术机构、国家/地区国际学术水平及影响力的重要评价指标工具之一。\n\n近年来，学校高度重视学科建设工作，持续加大对计算机科学学科的投入力度，在人才引进、平台建设、科研创新等方面取得了显著成效。此次进入ESI全球前1%，是对我校计算机科学学科建设成果的充分肯定。\n\n学校将以此为契机，进一步优化学科布局，提升学科核心竞争力，推动更多学科进入国际先进行列。',
    source: '学科建设办公室',
    imageUrl: '',
    publishTime: '2026-05-28',
    category: '校园资讯'
  },
  {
    id: 102,
    title: '我校与华为签署校企合作协议',
    summary: '双方将在人才培养、科研合作、智慧校园建设等方面开展深度合作，共同推进产教融合...',
    content: '2026年5月20日，我校与华为技术有限公司校企合作签约仪式在行政楼报告厅隆重举行。校长李明院士、华为北京研究所所长张华出席签约仪式并代表双方签署合作协议。\n\n根据协议，双方将在以下方面开展深度合作：\n\n一、人才培养\n共建"华为创新实验班"，联合培养创新型IT人才。华为将选派资深工程师参与教学活动，并为学生提供实习实训基地。\n\n二、科研合作\n围绕人工智能、云计算、大数据等领域开展联合科研攻关，共建联合实验室。\n\n三、智慧校园建设\n华为将为我校智慧校园建设提供技术支持和解决方案，助力学校数字化转型。\n\n校长李明在致辞中表示，此次合作是学校推进产教融合、深化教育教学改革的重要举措，将为学校"双一流"建设注入新的动力。',
    source: '党委宣传部',
    imageUrl: '',
    publishTime: '2026-05-20',
    category: '校园资讯'
  },
  {
    id: 103,
    title: '校园快递服务中心正式启用',
    summary: '为方便师生收发快递，新建的校园快递服务中心已通过验收并将于6月1日正式投入运营...',
    content: '为切实解决师生快递收发难的问题，经过两个月的紧张施工，校园快递服务中心已通过竣工验收，将于2026年6月1日正式投入运营。\n\n服务中心位于学校北门东侧，建筑面积约200平方米，设有快递收发区、自助取件区和包裹暂存区。目前已与顺丰、中通、圆通、韵达、京东等主流快递公司完成对接。\n\n服务时间：每天8:00-20:00（节假日正常营业）\n\n取件方式：凭取件码或身份证自助取件\n\n快递中心采用智能化管理系统，师生可通过"校通Plus"APP实时查看快递状态，接收取件通知。',
    source: '后勤管理处',
    imageUrl: '',
    publishTime: '2026-05-25',
    category: '校园资讯'
  },
  {
    id: 201,
    title: '计算机协会举办AI编程马拉松比赛',
    summary: '计算机协会将于本周末在信息楼举办为期两天的AI编程马拉松，欢迎全校同学报名参加...',
    content: '计算机协会将于2026年6月20日至21日在信息楼举办"智创未来"AI编程马拉松比赛。本次活动旨在激发同学们对人工智能技术的兴趣，提升编程实践能力。\n\n比赛主题：利用人工智能技术解决校园生活中的实际问题\n\n参赛要求：\n1. 全校在校本科生、研究生均可报名\n2. 每队2-4人，可跨专业组队\n3. 需具备基本的编程能力\n\n奖项设置：\n一等奖（1队）：奖金3000元 + 荣誉证书\n二等奖（2队）：奖金2000元 + 荣誉证书\n三等奖（3队）：奖金1000元 + 荣誉证书\n\n报名截止时间：2026年6月18日\n报名方式：关注"计算机协会"微信公众号在线报名',
    source: '计算机协会',
    imageUrl: '',
    publishTime: '2026-06-12',
    category: '社团活动'
  },
  {
    id: 202,
    title: '青年志愿者协会暑期支教招募',
    summary: '2026年暑期支教活动正式启动招募，面向全校招募30名志愿者前往云南山区开展支教...',
    content: '校青年志愿者协会2026年暑期支教活动正式启动！本次支教地点为云南省昭通市镇雄县三所乡村小学，支教时间为7月15日至8月15日，现面向全校招募30名志愿者。\n\n招募要求：\n1. 全校在校生，专业不限\n2. 具有责任心和团队合作精神\n3. 有支教或志愿服务经验者优先\n4. 有音乐、美术、体育等特长者优先\n\n支教内容：\n- 语文、数学、英语基础课程辅导\n- 音乐、美术、体育等素质教育课程\n- 留守儿童心理健康辅导\n- 乡村教育现状调研\n\n报名方式：\n前往学生活动中心203室领取报名表，或关注"青协在线"微信公众号在线报名。\n报名截止：2026年6月25日\n面试时间：6月28日-29日',
    source: '青年志愿者协会',
    imageUrl: '',
    publishTime: '2026-06-10',
    category: '社团活动'
  },
  {
    id: 203,
    title: '摄影协会举办"最美校园"摄影大赛',
    summary: '用镜头记录校园之美，摄影协会诚邀全校师生参加"最美校园"主题摄影大赛...',
    content: '为了展现校园自然风光与人文魅力，摄影协会特举办"最美校园"主题摄影大赛。\n\n参赛对象：全校师生\n\n作品要求：\n1. 拍摄内容须为校园内的人、物、景\n2. 作品风格不限，彩色、黑白均可\n3. 每位参赛者最多可提交3幅作品\n4. 作品须为原创，不得抄袭\n\n投稿时间：2026年6月1日至6月30日\n\n投稿方式：\n将作品发送至摄影协会邮箱：photo@campus.edu，邮件标题格式为"【摄影大赛】姓名+学号/工号"\n\n评选方式：\n初选：摄影协会评审团评选出30幅入围作品\n终选：入围作品将在图书馆大厅展出，由师生投票（60%）+ 专家评审（40%）综合评定\n\n奖项设置：\n一等奖（1名）：拍立得相机 + 荣誉证书\n二等奖（3名）：摄影背包 + 荣誉证书\n三等奖（5名）：精美相册 + 荣誉证书\n优秀奖（10名）：荣誉证书',
    source: '摄影协会',
    imageUrl: '',
    publishTime: '2026-06-01',
    category: '社团活动'
  },
  {
    id: 301,
    title: '人工智能前沿进展学术报告',
    summary: '特邀清华大学计算机系张教授来校作"大模型时代的AI技术变革"学术报告...',
    content: '为促进学术交流，拓宽师生学术视野，学校特邀清华大学计算机科学与技术系张伟教授来校作学术报告。\n\n报告题目：大模型时代的AI技术变革\n\n报告人：张伟 教授（清华大学计算机系）\n\n时间：2026年6月18日 15:00-17:00\n\n地点：行政楼报告厅\n\n报告摘要：\n本报告将回顾大语言模型技术的发展历程，分析当前主流技术路线，探讨大模型在自然语言处理、计算机视觉、科学计算等领域的应用前景，并就大模型时代面临的技术挑战与机遇进行深入讨论。\n\n报告人简介：\n张伟，清华大学计算机系教授、博士生导师，国家杰出青年科学基金获得者。主要从事自然语言处理、大语言模型等方向的研究工作。在ACL、EMNLP、NeurIPS等顶级会议和期刊发表论文100余篇，引用超过20000次。\n\n欢迎广大师生踊跃参加！',
    source: '计算机学院',
    imageUrl: '',
    publishTime: '2026-06-09',
    category: '学术讲座'
  },
  {
    id: 302,
    title: '量子计算：从理论到实践——物理学院学术讲座',
    summary: '中科院物理所研究员将为大家带来量子计算领域的前沿知识分享与实验进展介绍...',
    content: '物理学院特邀中国科学院物理研究所王明远研究员来校进行学术交流。\n\n讲座题目：量子计算：从理论到实践\n\n主讲人：王明远 研究员（中科院物理研究所）\n\n时间：2026年6月22日 14:00-16:00\n\n地点：物理学院301会议室\n\n讲座内容：\n1. 量子计算的基本原理和发展历程\n2. 当前主流量子计算技术路线\n3. 量子计算的实验进展与挑战\n4. 量子计算的未来发展趋势\n\n本次讲座将从基础概念出发，逐步深入到前沿进展，适合对量子计算感兴趣的各专业师生参加。',
    source: '物理学院',
    imageUrl: '',
    publishTime: '2026-06-07',
    category: '学术讲座'
  },
  {
    id: 303,
    title: '数字经济与绿色发展论坛',
    summary: '经济管理学院主办的年度学术论坛，多位知名经济学家将就数字经济与绿色发展展开对话...',
    content: '经济管理学院主办的2026年度学术论坛——"数字经济与绿色发展"将于6月25日在校国际交流中心举行。\n\n本次论坛邀请了多位国内知名经济学家和行业专家，共同探讨数字经济如何赋能绿色发展。\n\n论坛议程：\n\n08:30-09:00 签到\n09:00-09:15 开幕式\n09:15-10:30 主旨报告：数字经济的绿色转型路径（北京大学 陈教授）\n10:30-10:45 茶歇\n10:45-12:00 专题报告：绿色金融与碳交易市场发展（中国人民大学 刘教授）\n12:00-13:30 午餐\n13:30-15:00 圆桌论坛：数字技术助力碳中和目标\n15:00-15:15 茶歇\n15:15-16:30 青年学者报告\n16:30-17:00 闭幕式\n\n参会方式：\n现场参会：国际交流中心二楼报告厅（限200人）\n线上参会：腾讯会议ID：123-456-789\n\n欢迎全校师生参加！',
    source: '经济管理学院',
    imageUrl: '',
    publishTime: '2026-06-03',
    category: '学术讲座'
  }
];

// 今日课程模拟数据（非空，供测试）
export const MOCK_TODAY_COURSES: CourseItem[] = [
  {
    id: 1,
    courseName: '数据结构与算法',
    teacher: '王教授',
    location: '教学楼A-301',
    timeSlot: '1-2节',
    startTime: '08:00',
    endTime: '09:35',
    dayOfWeek: 1,
    weeks: '1-16周'
  },
  {
    id: 2,
    courseName: '操作系统原理',
    teacher: '李副教授',
    location: '教学楼B-203',
    timeSlot: '3-4节',
    startTime: '10:10',
    endTime: '11:45',
    dayOfWeek: 1,
    weeks: '1-16周'
  },
  {
    id: 3,
    courseName: '大学英语（四）',
    teacher: '张老师',
    location: '外语楼-105',
    timeSlot: '6-7节',
    startTime: '14:00',
    endTime: '15:35',
    dayOfWeek: 1,
    weeks: '3-18周'
  }
];

// 空课程数据（供空状态测试）
export const MOCK_EMPTY_COURSES: CourseItem[] = [];

/**
 * 获取指定周的课程数据（1-20周，每周课程不同）
 */
export function getCoursesForWeek(week: number): CourseItem[] {
  const weekCourses: Record<number, CourseItem[]> = {
    1: [
      { id: 101, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 102, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 103, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 104, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 105, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 106, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 107, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' }
    ],
    2: [
      { id: 201, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 202, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 203, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 204, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 205, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 206, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 207, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' }
    ],
    3: [
      { id: 301, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 302, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 303, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 304, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 305, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 306, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 307, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 308, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' }
    ],
    4: [
      { id: 401, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 402, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 403, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 404, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 405, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 406, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 407, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 408, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 409, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' }
    ],
    5: [
      { id: 501, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 502, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 503, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 504, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 505, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 506, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 507, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 508, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 509, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' }
    ],
    6: [
      { id: 601, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 602, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 603, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 604, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 605, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 606, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 607, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 608, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 609, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' },
      { id: 610, courseName: '期中测验-数据结构', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-4节', startTime: '08:00', endTime: '11:45', dayOfWeek: 0, weeks: '6周' }
    ],
    7: [
      { id: 701, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 702, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 703, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 704, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 705, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 706, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 707, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 708, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 709, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' }
    ],
    8: [
      { id: 801, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 802, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 803, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 804, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 805, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 806, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 807, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 808, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 809, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' },
      { id: 810, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' }
    ],
    9: [
      { id: 901, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 902, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 903, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 904, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 905, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 906, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 907, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 908, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 909, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' },
      { id: 910, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' }
    ],
    10: [
      { id: 1001, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1002, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1003, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1004, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1005, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1006, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1007, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 1008, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 1009, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' },
      { id: 1010, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' },
      { id: 1011, courseName: '期中测验-操作系统', teacher: '李副教授', location: '教学楼B-203', timeSlot: '1-4节', startTime: '08:00', endTime: '11:45', dayOfWeek: 0, weeks: '10周' }
    ],
    11: [
      { id: 1101, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1102, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1103, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1104, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1105, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1106, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1107, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 1108, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 1109, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' },
      { id: 1110, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' }
    ],
    12: [
      { id: 1201, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1202, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1203, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1204, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1205, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1206, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1207, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 1208, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 1209, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' },
      { id: 1210, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' },
      { id: 1211, courseName: '学术讲座: AI前沿', teacher: '特邀专家', location: '行政楼报告厅', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 3, weeks: '12周' }
    ],
    13: [
      { id: 1301, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1302, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1303, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1304, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1305, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1306, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1307, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 1308, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 1309, courseName: '数据结构实验', teacher: '郑老师', location: '实验楼-405', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 4, weeks: '4-15周' },
      { id: 1310, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' }
    ],
    14: [
      { id: 1401, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1402, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1403, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1404, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1405, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1406, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1407, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 1408, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 1409, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' }
    ],
    15: [
      { id: 1501, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1502, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1503, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1504, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1505, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1506, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1507, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 1508, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 1509, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' },
      { id: 1510, courseName: '课程设计启动会', teacher: '王教授', location: '教学楼A-301', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 0, weeks: '15周' }
    ],
    16: [
      { id: 1601, courseName: '数据结构与算法', teacher: '王教授', location: '教学楼A-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1602, courseName: '操作系统原理', teacher: '李副教授', location: '教学楼B-203', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 1, weeks: '1-16周' },
      { id: 1603, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1604, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1605, courseName: '线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1606, courseName: '数字逻辑设计', teacher: '赵副教授', location: '信息楼-205', timeSlot: '3-4节', startTime: '10:10', endTime: '11:45', dayOfWeek: 3, weeks: '1-16周' },
      { id: 1607, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' },
      { id: 1608, courseName: '计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '1-2节', startTime: '08:00', endTime: '09:35', dayOfWeek: 5, weeks: '1-16周' },
      { id: 1609, courseName: '计算机网络实验', teacher: '钱老师', location: '实验楼-301', timeSlot: '3-5节', startTime: '10:10', endTime: '12:30', dayOfWeek: 5, weeks: '8-16周' }
    ],
    17: [
      { id: 1701, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1702, courseName: '程序设计实验', teacher: '周老师', location: '实验楼-402', timeSlot: '6-8节', startTime: '14:00', endTime: '16:30', dayOfWeek: 2, weeks: '2-17周' },
      { id: 1703, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' }
    ],
    18: [
      { id: 1801, courseName: '大学英语（四）', teacher: '张老师', location: '外语楼-105', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 2, weeks: '3-18周' },
      { id: 1802, courseName: '体育（四）', teacher: '刘老师', location: '体育馆', timeSlot: '6-7节', startTime: '14:00', endTime: '15:35', dayOfWeek: 4, weeks: '1-18周' }
    ],
    19: [
      { id: 1901, courseName: '期末考试周-自由复习', teacher: '', location: '图书馆/自习室', timeSlot: '全天', startTime: '08:00', endTime: '22:00', dayOfWeek: 1, weeks: '19周' },
      { id: 1902, courseName: '期末考试周-自由复习', teacher: '', location: '图书馆/自习室', timeSlot: '全天', startTime: '08:00', endTime: '22:00', dayOfWeek: 2, weeks: '19周' },
      { id: 1903, courseName: '期末考试周-自由复习', teacher: '', location: '图书馆/自习室', timeSlot: '全天', startTime: '08:00', endTime: '22:00', dayOfWeek: 3, weeks: '19周' },
      { id: 1904, courseName: '期末考试周-自由复习', teacher: '', location: '图书馆/自习室', timeSlot: '全天', startTime: '08:00', endTime: '22:00', dayOfWeek: 4, weeks: '19周' },
      { id: 1905, courseName: '期末考试周-自由复习', teacher: '', location: '图书馆/自习室', timeSlot: '全天', startTime: '08:00', endTime: '22:00', dayOfWeek: 5, weeks: '19周' }
    ],
    20: [
      { id: 2001, courseName: '期末考试-数据结构', teacher: '王教授', location: '教学楼A-301', timeSlot: '8:00-10:00', startTime: '08:00', endTime: '10:00', dayOfWeek: 1, weeks: '20周' },
      { id: 2002, courseName: '期末考试-操作系统', teacher: '李副教授', location: '教学楼B-203', timeSlot: '14:00-16:00', startTime: '14:00', endTime: '16:00', dayOfWeek: 1, weeks: '20周' },
      { id: 2003, courseName: '期末考试-线性代数', teacher: '陈教授', location: '教学楼A-101', timeSlot: '8:00-10:00', startTime: '08:00', endTime: '10:00', dayOfWeek: 3, weeks: '20周' },
      { id: 2004, courseName: '期末考试-计算机网络', teacher: '孙教授', location: '教学楼B-301', timeSlot: '14:00-16:00', startTime: '14:00', endTime: '16:00', dayOfWeek: 5, weeks: '20周' }
    ]
  };

  return weekCourses[week] || [];
}

// 天气模拟数据
export const MOCK_WEATHER: WeatherData = {
  temperature: '28°C',
  condition: '晴 微风',
  location: '北京·海淀',
  iconSymbol: $r('sys.symbol.sun_max'),
  highTemp: '32°C',
  lowTemp: '20°C'
};

// 快捷入口模拟数据
export const MOCK_QUICK_ENTRIES: QuickEntryItem[] = [
  { id: 1, label: '校园公告', iconSymbol: $r('sys.symbol.bell'), routeName: 'CampusNotice' },
  { id: 2, label: '课程表', iconSymbol: $r('sys.symbol.calendar'), routeName: 'Schedule' },
  { id: 3, label: '成绩查询', iconSymbol: $r('sys.symbol.checkmark'), routeName: 'GradeQuery' },
  { id: 4, label: '失物招领', iconSymbol: $r('sys.symbol.questionmark_circle'), routeName: 'LostFound' },
  { id: 5, label: '校园地图', iconSymbol: $r('sys.symbol.map'), routeName: 'CampusMap' },
  { id: 6, label: '图书馆', iconSymbol: $r('sys.symbol.book'), routeName: 'Library' },
  { id: 7, label: '校园美食', iconSymbol: $r('sys.symbol.cup'), routeName: 'CampusFood' },
  { id: 8, label: '音乐播放', iconSymbol: $r('sys.symbol.play_circle'), routeName: 'MusicPlayer' },
  { id: 9, label: '待办提醒', iconSymbol: $r('sys.symbol.list_bullet'), routeName: 'TodoReminder' },
  { id: 10, label: '更多功能', iconSymbol: $r('sys.symbol.ellipsis_circle'), routeName: 'MoreFeatures' }
];
