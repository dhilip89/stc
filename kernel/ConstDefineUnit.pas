{公用常量定义
 @created(2003-09-04)
 @lastmod(GMT:$Date: 2010/01/15 07:30:28 $) <BR>
 最后更新人:$Author: wfp $ <BR>
 当前版本:$Revision: 1.1.1.1 $ <BR>}



unit ConstDefineUnit;

interface
uses Messages;
const
//====================================================================
  INITDATA_HOUR = 4;
  MY_APP_NAME = 'VSMSClient_Taxi';
  CM_RESTORE = WM_USER + $1000; // -自定义的“恢复”消息
  CM_DATASERVER_SENDMSG = WM_USER + $1001; //
  CM_DevStat = WM_USER + $1002; // 设备状态
  CM_DevParam_READOk = WM_USER + $1003; // 读设备参数
  CM_DevNotifyStat = WM_USER + $1004; // 服务器有数据更新的通知,通知客户端要刷新指定的设备的信息
  CM_DevToHost = WM_USER + $1005; // 收到Dev发送到Host的数据
  CM_RegUserErr = WM_USER + $1006; // 用户登录到网关服务器 错误
  CM_DEVALARM = WM_USER + $1007; // 在收到的GPS数据中有 报警

  //删除越界或驶入报警列表中的相关车辆 ，此消息由电子围栏列表中删除时，发给主界面。
  //--当用户在电子围栏列表中删除某区域（对应的车辆将全不限定）或 从某区域中不再限定该车时，如果越界或驶入报警列表中有该车，则需移入到历史记录中
  CM_DELAlarmListDev_OutORInCA = WM_USER + $1008;

  CM_UPDATE = WM_USER + $1009; //更新本自已,,必须关闭自己,这个消息是由更新程序发出.
//  CM_PowerCut           =WM_USER+ $1010;  //断电报警

  //发出命令的执行状态
  CMD_SNDNODO = 0; // 已发送未执行
  CMD_DONE = 1; // 已执行
  CMD_DOERROR = 2; // 执行出错
  CMD_CANCELByUSER = 3; // 被用户取消
  CMD_CANCELED = 4; // 已取消
  CMD_CANCELFAIL = 5; // 取消失败
  CMD_RESND = 6; // 重发
  CMD_DELETED = 7; // 被删除
  CMD_REPLACE = 8; // 被替代
  CMD_OVERTIME = 9; // 超时
  CMD_SND2SMSSENDSVR = 10; // 已发送到SMS发送服务器
  CMD_INVALIDDEV = 11; //无效的车机ID号

  ForDevLimit = 100; //当前软件可 查看车辆数
  UserDrawAreaLayerName = '电子围栏绘画图层'; //画区域　的图层的　名称
  SpecialAreaLayerName = '特殊区域绘画图层'; //修改08-8-16AYH

  ALARM_OUT = 0; //越出界　报警
  ALARM_IN = 1; //入界　　报警
  ALARM_OVER_SPEET = 2; //区域超速报警
  ALARM_WAY_OUT = 3;
  ALARM_WAY_IN = 4;
  BUSLINE_WAY = 5;
//==========================================================================

  (*****客户端　与网关****)
  RET_OK = $0;
  {命令执行成功}
  RET_CMDOK = $0;
  {ERR_开头的为错误码}
  //屏有故障
  ERR_LED = $1;
  {无效用户名}
  ERR_INVALIDUSER = $1;
  {错误密码}
  ERR_INVALIDPASSWD = $2;
  {用户不允许登录}
  ERR_USERDISABLED = $3;
  {用户已被删除}
  ERR_USERDELETED = $4;
  {旧密码无效}
  ERR_INVALIDOLDPASSWD = $5;
  {新密码无效}
  ERR_INVALIDNEWPASSWD = $6;
  {尚未登录}
  ERR_NOTLOGIN = $7;
  {没有取到需要的数据}
  ERR_NODATA = $8;
  { 结果与需要的数量不符}
  ERR_DATALACK = $9;
  {错误的数据格式}
  ERR_INVALIDFORMAT = $A;
  {没有内容需要同步}
  ERR_NOSYNC = $B;
  { 写入数据库失败}
  ERR_Record = $C;
  {主版本号过大}
  ERR_ProtocalMajorOver = $D;
  {主版本号过小}
  ERR_ProtocalMajorLack = $E;
  {次版本号过大}
  ERR_ProtocalMinorOver = $F;
  {次版本号过小}
  ERR_ProtocalMinorLack = $10;
  {无效的版本号}
  ERR_INVALIDVER = $11;
  {重复登录}
  ERR_Logged = $12;
  {无效的车机}
  ERR_INVALIDDEV = $13;
  {无效的移动目标}
  ERR_INVALIDTARGET = $14;
  {没有权限}
  ERR_NOPRIVILEGE = $15;
  {命令执行超时失败}
  ERR_TIMEOUT = $16;
  {命令已修改后执行,在命令执行期间被一个新的命令（只是参数不同）替代}
  RET_CMDMODIFY = $17;
  {命令已发送到SMS发送服务器}
  RET_CMDSnd2SMSSendSvr = $18;
  {订单已被删除}
  RET_ORDERDELETED = $19;
  {命令执行失败}
  RET_FAIL = $FE;
  {未知错误}
  ERR_Unknown = $FF;
  {通信服务器保留用户,为XXXXX的md5值}
  SYSTEM_SUPERUSER = '{F1F34647-81A5-48F6-A854-F8B469F64F67}';
  SYSTEM_SUPERPASS = '{A789376B-F01E-40A8-917A-DF5B34B200FE}';
  {密码长度}
  PassLength = 32;

//消息常量定义
  //消息类型
  MSGTYPE_NORMAL = 0; //文本调度信息
  MSGTYPE_NEEDANSWER = 1; //需回复的调度孕育处　
  //消息状态
  MSGSTAT_UNSEND = 0; //消息未发送
  MSGSTAT_SENDED = 1; //消息已发送
  MSGSTAT_RECVED = 2; //车机已接收消息
  MSGSTAT_REPLYED = 3; //司机已应答消息
  MSGSTAT_FAILED = 9; //消息发送失败
  //司机应答
  MSGANSWERTYPE_YES = 1; //司机应答－是
  MSGANSWERTYPE_NO = 0; //司机应答－否

//升级车机固件 类型
  UPDATEDEV_DEV = $0; //升级主机
  UPDATEDEV_DISPLAY = $1; //升级显示屏


//数据库名称
  DATABASE_NAME = 'VSMSdata';

//读取设备参数号
  DEVParam_Basic = 0; //基本参数
  DEVParam_Else = 1; //监听及业务电话
  DEVParam_KeyPressTel = 2; //按键电话

  //数据通道
  COMMUNICATION_GRPS = 0; //GPRS方式
  COMMUNICATION_SMS = 1; //短消息方式

  //下发订单超过多少秒后 没车机响应，中心自动删除
  TIMEOVER_DELORDER = 30000;
  //订单的状态
  ORDERSTATE_NODEVANSWER_DEL = 0; //订单下发30秒后，没有车机响应，中心自动删除
  ORDERSTATE_WAITGRAB = 1; //等待车机来抢单
  ORDERSTATE_DEVGRAB = 2; //  已有车机抢单
  ORDERSTATE_SENDINGDEVGRABOK = 3; //正在下发给车机抢单成功
  ORDERSTATE_SENDDEVGRABOK_FAIL = 4; //下发给车机抢单成功，失败：车机没应答，下发给其它 车机也无应答。或已无车机可发。
  ORDERSTATE_DEVGRABOK = 5; //车机抢单成功
  ORDERSTATE_SRVCANCEL = 6; //中心取消订单
  ORDERSTATE_DEVCANCEL = 7; //车机取消订单

 //固定菜单长度
  LCD_MENU_LENGTH = 39;
 //固定菜单个数
  LCD_MENU_COUNT = 128;

 //发出信息的(PostMessage)类型, //对应的函数: ReturnMsgTypeState
  MSG_TYPE_LCD_MENU = 1; //固定菜单.
  MSG_TYPE_CONTRAL_INFO = 2; //调度信息.
  MSG_TYPE_TAXI_STOPTIME = 3; //计价器停机时间
  MSG_TYPE_SEV_INFO = 4; //服务器通知消息;
  MSG_TYPE_DEV_SEND_TO_HOST = 5; // 收到Dev发送到Host的数据
  MSG_TYPE_GPS_MODULE_ERROR = 24; //GPS模块发生故障
  MSG_TYPE_GPS_LINE_ERROR = 25; //GPS天线未接或被剪断
  MSG_TYPE_LOW_V = 26; //低压报警
  MSG_TYPE_LCD_ERROR = 27; //LCD故障
  MSG_TYPE_MEASURE_ERROR = 28; //计价器故障
  MSG_TYPE_SIM_ERROR = 29; //SIM卡未设置，或者车机读取SIM卡号失败

  //断油断电供油供电　命令中的具体内容
  CUT_OIL = 1; //断油
  CUT_ELECTRICITY = 2; //断电
  FEED_OIL = 3; //供油
  FEED_ELECTRICITY = 4; //供电


//===================================================================


  //系统管理端与网关通讯
  SYSADM_USERID = $00FF00FF;
  SYSADM_USERPASS = '{B274AB8A-34D5-476F}';

  //网关与Web服务　通讯       20070611
  SYSWEB_USERID = $1002;
  SYSWEB_USERPASS = '1';

  //调度服务器以 特殊的　TCP客户端 登录网关
  DISPATCH_USERID = $00FF0100;
  DISPATCH_USERPASS = '{8707A054-5ADA-416B}';

  //机场大巴服务器登陆网关
  OTHERSERVER_USERID = $1000;
  //检测网关的服务器登录用户名
  CHECKGATAWAY_USERID = $1001;

  SWITCHBOARDON = 1;
  SWITCHBOARDOFF = 0;

  IOPARKTYPE_INPARKFROMS = 7;
  IOPARKTYPE_INPARKFROME = 8;
  IOPARKTYPE_OUTPARKTOS = 9;
  IOPARKTYPE_OUTPARKTOE = 10;

function ReturnMsgTypeState(State: integer): string;
//得到断油电供油供电的具体内容
function ReturnCutOrFeedContent(ParamId: Byte): string;


implementation


function ReturnMsgTypeState(State: integer): string;
begin
  Result := '';
  case State of
    MSG_TYPE_LCD_MENU: Result := '固定菜单';
    MSG_TYPE_CONTRAL_INFO: Result := '调度信息';
    MSG_TYPE_TAXI_STOPTIME: Result := '计价器停机时间';
    MSG_TYPE_SEV_INFO: Result := '服务器通知消息';
    MSG_TYPE_DEV_SEND_TO_HOST: Result := '收到发给到中心的数据';
    MSG_TYPE_GPS_MODULE_ERROR: Result := 'GPS模块发生故障';
    MSG_TYPE_GPS_LINE_ERROR: Result := 'GPS天线未接或被剪断';
    MSG_TYPE_LOW_V: Result := '低压报警';
    MSG_TYPE_LCD_ERROR: Result := 'LCD故障';
    MSG_TYPE_MEASURE_ERROR: Result := '计价器故障';
     //MSG_TYPE_SIM_ERROR:Result          :='SIM卡未设置，或者车机读取SIM卡号失败';
  end;
end;

function ReturnCutOrFeedContent(ParamId: Byte): string;
begin
  Result := '';
  case ParamId of
    CUT_OIL: Result := '断油';
    CUT_ELECTRICITY: Result := '断电';
    FEED_OIL: Result := '供油';
    FEED_ELECTRICITY: Result := '供电';
  end;
end;

end.
