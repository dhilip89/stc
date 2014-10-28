{公用常量定义
 @created(2003-09-04)
 @lastmod(GMT:$Date: 2010/01/15 07:30:28 $) <BR>
 最后更新人:$Author: wfp $ <BR>
 当前版本:$Revision: 1.1.1.1 $ <BR>}



unit ConstDefineUnit;

interface
uses Messages;
const

  //系统退出时的默认密码
  DEFAULT_PASSWORD_FOR_QUIT = '213000';

  //====================================================================
  AMOUNT_30_YUAN = 30 * 100;
  AMOUNT_50_YUAN = 50 * 100;
  AMOUNT_100_YUAN = 100 * 100;
  AMOUNT_200_YUAN = 200 * 100;

  TIP_PUT_CITY_CARD = '请将龙城通卡放置在读卡区...';
  TIP_DO_NOT_MOVE_CITY_CARD = '正在进行充值处理，请勿移开卡片...';
  TIP_CHECKING_PREPAID_CARD = '正在校验充值卡，请稍后...';
  TIP_GETTING_PREPAID_CARD_AMOUNT = '正在获取充值面额,请稍后...';
  TIP_GETTING_ZHB_BALANCE = '正在获取账户宝余额,请稍后...';
  TIP_CITY_CARD_BALANCE = '龙城通余额：';
  TIP_CITY_CARD_NO = '龙城通卡号：';
  TIP_CITY_CARD_BALANCE_AFTER_CHARGED = '充值后龙城通余额：';
  TIP_MODIFYING_ZHB_PASS = '正在修改账户宝密码，请勿移开卡片...';

  LOGIN_STATUS_OK                      = 0;//登录成功
  LOGIN_STATUS_LOGINED_FROM_OTHER_TER  = 1;//终端号在其他设备上登录
  LOGIN_STATUS_TER_NOT_EXIST           = 2;//终端不存在
  LOGIN_STATUS_TER_DISABLED            = 3;//终端被停用
  LOGIN_STATUS_SERVER_DISCONNECTED     = 99;//未发送登录命令
  LOGIN_STATUS_NO_RSP                  = 100;//登录命令发送未应答

implementation


end.
