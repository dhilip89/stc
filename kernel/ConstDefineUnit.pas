{公用常量定义
 @created(2003-09-04)
 @lastmod(GMT:$Date: 2010/01/15 07:30:28 $) <BR>
 最后更新人:$Author: wfp $ <BR>
 当前版本:$Revision: 1.1.1.1 $ <BR>}



unit ConstDefineUnit;

interface
uses Messages;
const

  VER = $0104;

  //市民卡LOGO图案的数据
  LOGO_BIT_DATA = '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0F0000000001C000' +
                  '0000000000001F00' +
                  '00000001F8000000' +
                  '000006101F000000' +
                  '0011FE0000000000' +
                  '073FFF00000003FF' +
                  'FF80000000003FFF' +
                  'EF0000003FFFFFC0' +
                  '000000003FFFE000' +
                  '00007FFFFFFB8000' +
                  '00001FDFE0000001' +
                  'FFFFFFFFC0000000' +
                  '3FFFE0000007FFFF' +
                  'FFFFE00000003FFF' +
                  'C000000FFFFFFFFF' +
                  'E00000003FFFC000' +
                  '001FFFFFFFFFF800' +
                  '00003FFFC000003F' +
                  'FE03FFFFF8000000' +
                  '3FFFF000007FF000' +
                  '3FFFF80000003FFF' +
                  'F00000FFE0001FFF' +
                  'F00000003FFFF000' +
                  '01FF80000FFF0000' +
                  '00007FFFF00003FF' +
                  '00000FFE00000000' +
                  '70DFF00003FE0000' +
                  '00FE000000002007' +
                  'C00003FC00000000' +
                  '0000000000000000' +
                  '07FC000000000000' +
                  '00000000000007F8' +
                  '0C00000000000000' +
                  '000000000FF03F06' +
                  'F81C000068000C07' +
                  '80000FF07F8FF9FF' +
                  'DFF87F000CFFE000' +
                  '0FF1FFDFF9FFDFF8' +
                  '7F001FFFE0000FF1' +
                  'FFDFF9FF8FFBFFC0' +
                  '7FFFC0000FF1FFDF' +
                  'F8FFCFFFFFC07FFF' +
                  '00000FF1FFDFF8FF' +
                  'DFFF7E003FFFC000' +
                  '0FE1FFDEDCDFDFFC' +
                  '7E000DFFC0000FE1' +
                  'EDDEDCDF9FFC6E00' +
                  '1FDFC0000BE06D88' +
                  '985D0C3860003FFF' +
                  'B0000BE0F800600F' +
                  'F00781803FFFF000' +
                  '0FE1FFFFFFDFFFF7' +
                  'FF803FFFF0000FF1' +
                  'BFFFFFFBFFF6FF80' +
                  '07A7F0000DF1FFFF' +
                  'FFFFFFF7FF800300' +
                  'C0000FF06FFFF6CE' +
                  'FFF37B0000000000' +
                  '0FF8000C00000000' +
                  '00000000000007F8' +
                  '0000000000000000' +
                  '0000000007F80000' +
                  '00000000000005FE' +
                  '0000037C0000003F' +
                  'F00000003DFE0000' +
                  '03FE000003FFF800' +
                  '00003CFC000001BF' +
                  '04003FFF9FFE0000' +
                  '3DFF000000FF87FF' +
                  'FFFBFFFFC0003FFF' +
                  '800000EFF3FFFFFF' +
                  'FFFF80007FFF8000' +
                  '0077FE7FFFFFFF80' +
                  '00007FFFC000003F' +
                  'FFFFFFFFF8000000' +
                  '3FFFE0000019FFFF' +
                  'FFFFC00000003BFF' +
                  'F0000000DFFFFFFC' +
                  '000000007FFFF000' +
                  '00000FFFFF800000' +
                  '00007FFFF0000000' +
                  '03FFFC0000000000' +
                  '1FFFE0000000003F' +
                  'FC000000000003FF' +
                  'C000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000' +
                  '0000000000000000';
  //系统退出时的默认密码
  DEFAULT_PASSWORD_FOR_QUIT = '000312';

  CHARGE_TYPE_CASH          = 0;//现金充值
  CHARGE_TYPE_BANK          = 1;//银行卡充值
  CHARGE_TYPE_PREPAID_CARD  = 2;//充值卡充值
  CHARGE_TYPE_ZHB           = 3;//账户宝充值
  //====================================================================
  AMOUNT_30_YUAN = 30 * 100;
  AMOUNT_50_YUAN = 50 * 100;
  AMOUNT_100_YUAN = 100 * 100;
  AMOUNT_200_YUAN = 200 * 100;

  MAX_AMOUNT_NAMED   = 5000 * 100;//记名卡最大金额
  MAX_AMOUNT_UNNAMED = 1000 * 100;//不记名卡最大金额

  CITY_CARD_TYPE_UNKNOWN = $FF;//未知
  CITY_CARD_TYPE_NAMED   = $00;//记名卡
  CITY_CARD_TYPE_UNNAMED = $01;//不记名卡
  CITY_CARD_TYPE_INVALID = $02;//无效卡
  CITY_CARD_TYPE_JFCARD  = $03;//金福卡

  SAMID = '990000000006';

  TIP_PUT_CITY_CARD                   = '请将龙城通卡放置在读卡区...';
  TIP_CAN_NOT_DETECT_CITY_CARD        = '未检测到龙城通卡，请将卡放置在读卡区...';
  TIP_DO_NOT_MOVE_CITY_CARD           = '正在进行充值处理，请勿移开卡片...';
  TIP_CHECKING_PREPAID_CARD           = '正在校验充值卡，请稍后...';
  TIP_GETTING_PREPAID_CARD_AMOUNT     = '正在获取充值面额,请稍后...';
  TIP_GETTING_ZHB_BALANCE             = '正在获取账户宝余额,请稍后...';
  TIP_CITY_CARD_BALANCE               = '龙城通余额：';
  TIP_CITY_CARD_NO                    = '龙城通卡号：';
  TIP_CITY_CARD_BALANCE_AFTER_CHARGED = '龙城通余额：';
  TIP_CITY_CARD_AMOUNT_CHARGED        = '充 值 金额：';
  TIP_MODIFYING_ZHB_PASS              = '正在修改账户宝密码，请勿移开卡片...';
  TIP_DO_NOT_CHANGE_CARD              = '充值过程中，请勿更换卡片...';

  TIP_BILL_VALIDATOR_NOT_WORKING      = '纸币器无法正常工作，请联系管理人员';
  TIP_BILL_VALIDATOR_IS_STUCKED       = '纸币器可能发生卡钞，请联系管理人员';
  TIP_BILL_VALIDATOR_CASHBOX_GONE     = '纸币器未检测到钱箱，请联系管理人员';
  TIP_BILL_VALIDATOR_CASHBOX_FULL     = '纸币器检测到钱箱已满，请联系管理人员';

  REFUND_REASON_VALIDATOR_NOT_WORKING = '纸币器异常';
  REFUND_REASON_VALIDATOR_SET_CHL_ERR = '设置识别纸币类型异常';
  REFUND_REASON_VALIDATOR_STUCKED     = '纸币器卡钞';
  REFUND_REASON_CASHBOX_FULL          = '纸币器钱箱满';

  LOGIN_STATUS_OK                      = 0;//登录成功或恢复启用
  LOGIN_STATUS_LOGINED_FROM_OTHER_TER  = 1;//终端号在其他设备上登录(即重复登录)
  LOGIN_STATUS_TER_NOT_EXIST           = 2;//终端不存在
  LOGIN_STATUS_TER_DISABLED            = 3;//终端被停用
  LOGIN_STATUS_SERVER_DISCONNECTED     = 4;//无法连接服务器
  LOGIN_STATUS_NO_RSP                  = 5;//登录命令发送未应答
  LOGIN_STATUS_OUT_SERVICE             = 6;//服务端通知暂停服务或人工暂停服务

  IS_PREPAID_CARD_CHARGE_NEED_CONFIRM = False;//充值卡充值是否需要显示面额并确认充值

  BILL_VALIDATOR_CMD_OK = $F0;//纸币器已成功执行命令

  TASK_RET_OK             = 0;//正常
  TASK_RET_CONTINUE_LOOP  = 1;//返回继续循环执行
  TASK_RET_QUIT_LOOP      = 2;//关键操作非等待可解决的直接退出，不继续
  TASK_RET_REFUND         = 3;//执行失败，且需退钱
  TASK_RET_PASSWORD_WRONG = 4;//充值卡、账户宝密码错误，退出需用户重新确认

  OPER_LOG_TYPE_PAUSE_SERVICE   = 4;//暂停服务
  OPER_LOG_TYPE_RECOVER_SERVICE = 9;//恢复服务


implementation


end.
