{-------------------------------------------------------------------------------
  作者:      JADIC
  日期:      2014-07-01
  功能描述:  通讯结构定义
-------------------------------------------------------------------------------}

unit CmdStructUnit;

interface
uses
  Windows, winsock, Types;

const
  VER = $0100;

{******************************终端发起命令字******************************}
  C2S_TYRET                  = $0001;//终端通用应答
  C2S_HEARTBEAT              = $0002;//终端心跳
  C2S_LOGIN                  = $0003;//终端注册
  C2S_TERMINAL_MODULE_STATUS = $0004;//终端模块状态汇报
  C2S_GET_MAC2               = $0005;//获取MAC2
{******************************终端发起命令字******************************}

{*****************************服务端发起命令字*****************************}
  S2C_TYRET        = $7001;//平台通用应答
  S2C_LOGIN_RSP    = $7003;//终端注册应答
  S2C_GET_MAC2_RSP = $7005;//获取mac2应答
{*****************************服务端发起命令字*****************************}
{*********************************公共常量*********************************}
  CMD_START_FLAG = $7E;
  CMD_END_FLAG = $7E;

  CMD_SPEC_FLAG_7E = $7E;
  CMD_SPEC_FLAG_7D = $7D;
{*********************************公共常量*********************************}
type
  {
    自助终端的通用头
  }
  TSTHead = packed record
    StartFlag: Byte;
    CmdId: Word;
    ClientType: Byte;
    TerminalId: array[0..5] of Byte;//BCD
    BodySize: Short;
    CmdSNo: Short;
  end;
  PSTHead = ^TSTHead;

  {
    自助终端的通用尾
  }
  TSTEnd = packed record
    CheckSum: Byte;
    EndFlag: Byte;
  end;
  PSTEnd = ^TSTEnd;
{******************************终端发起命令******************************}
  //终端通用应答
  TCmdTYRetC2S = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    CmdIdRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdTYRetC2S = ^TCmdTYRetC2S;

  //终端心跳
  TCmdHeartbeatC2S = packed record
    CmdHead: TSTHead;
    CmdEnd: TSTEnd;
  end;
  PCmdHeartbeatC2S = ^TCmdHeartbeatC2S;

  //终端注册
  TCmdLoginC2S = packed record
    CmdHead: TSTHead;
    Ver: Word;
    CmdEnd: TSTEnd;
  end;
  PCmdLoginC2S = ^TCmdLoginC2S;

  //终端模块状态汇报
  {
    模块1:市民卡读写模块
    模块2:现金模块
    模块3:银联模块
    模块4:打印模块
    模块5:身份证读取模块
    模块6:密码键盘模块
  }
  TCmdTerminalModuleStatusC2S = packed record
    CmdHead: TSTHead;
    ModuleCount: Byte;
//  Module1Id: Byte;
//  Module1Status: Byte;
//  ...  ...
//  ModuleNId: Byte;
//  ModuleNStatus: Byte;
//  CmdEnd: TSTEnd;
  end;
  PCmdTerminalModuleStatusC2S = ^TCmdTerminalModuleStatusC2S;

  //获取mac2信息
  TCmdGetMac2ForChargeC2S = packed record
    CmdHead: TSTHead;
    OperType: Byte;
    CardNo: array[0..7] of Byte;
    ASN: array[0..9] of Byte;
    FakeRandom: array[0..3] of Byte;//伪随机数
    CardTradeNo: array[0..1] of Byte;//
    CardOldBalance: LongWord;
    ChargeAmount: LongWord;//充值金额 (单位分)
    Mac1: array[0..3] of Byte;//mac1
    ChargeDate: array[0..3] of Byte;//充值时间 BCD 20 14 07 20 14 45 23
    ChargeTime: array[0..2] of Byte;//
    CmdEnd: TSTEnd;
  end;
  PCmdGetMac2ForChargeC2S = ^TCmdGetMac2ForChargeC2S;
{******************************终端发起命令******************************}


{*****************************服务端发起命令*****************************}
  //平台通用应答
  TCmdTYRetS2C = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    CmdIdRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdTYRetS2C = ^TCmdTYRetS2C;

  //终端注册应答
  TCmdLoginRspS2C = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdLoginRspS2C = ^TCmdLoginRspS2C;

  //获取mac2信息应答
  TCmdGetMac2ForChargeS2C = packed record
    CmdHead: TSTHead;
    Ret: Byte;//获取结果  1:成功  其他:无效
    Mac2: array[0..3] of Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdGetMac2ForChargeS2C = ^TCmdGetMac2ForChargeS2C;
{*****************************服务端发起命令*****************************}


  {版本数据结构
  @TABB
  @H(标识      |类型       |含义                  |参见)
  @R( MinorVer |Byte       |次版本号              |  )
  @R( MinorVer |Byte       |主版本号              |  )
  @R( Version  |Word       |用16位整型表示的版本数值| )
  @TABE}
  TVer = packed record
    case integer of
      0:
      (MinorVer, MajorVer: Byte; );
      1: (Version: Word);
      2: (DevMajorVer, DevMinorVer: Byte; );
  end;

type
  TMapxWorldPoint = packed record
    longtitude: double;
    lattitude: double;
  end;
  PMapxWorldPoint = ^TMapxWorldPoint;
  TMapxWorldPointAry = array of TMapxWorldPoint;
  TDateTime_V2 = array[0..4] of byte;

{*****************  以下是网关服务器和客户端之间的命令结构 ********************}

  {终端向服务器发送的确认数据通讯协议命令
    @TABB
    @H(标识 |类型    |含义|参见)
    @R( size| Word   |数据包的长度=sizeof(TCmdTermsrvRegverData) | | )
    @R( Flag| Byte   |=TERMSRV_REG| )     //是不是应该用　TERMSRV_COMMVER  --shajp？
    @R( MajorVer|Byte|数据协议主版本 | )
    @R( MinorVer|Byte|数据协议次版本 | )
    @TABE
    数据协议格式说明:<br>
    [包长度2Byte][标志1Byt][包内容]<br>
    包长度=整个数据包的长度
  }
  TCmdTermsrvRegverData = packed record
    Size: Word;
    Flag: Byte;
    case integer of
      0: (MinorVer, MajorVer: Byte);
      1: (Ver: Word);
  end;
  PCmdTermsrvRegverData = ^TCmdTermsrvRegverData;
  {@link(TCmdTermsrvRegverData)命令的回复}
  TCmdSrvtermRegverData = packed record
    Size: Word;
    Flag: Byte;
    Ret: integer;
  end;
  PCmdSrvtermRegverData = ^TCmdSrvtermRegverData;

  {用户登录网关服务器
   @TABB
   @H(标识  |类型    |含义|参见)
   @R( size |Word    |数据包的长度=sizeof(TCmdTermsrvRegUserData) | | )
   @R( Flag |Byte    |=TERMSRV_REG| )
   @R( MajorVer|Byte | 客户端的主版本号)
   @R( MinorVer|Byte | 客户端的小版本号)
   @R( UserID  |integer| 用户ID)
   @R( UserPass|stirng | 用户密码)
   @TABE
  }
  TCmdTermsrvRegUserData = packed record
    Size: Word;
    Flag: Byte;
    MajorVer, MinorVer: Byte;
    UserID: integer;
    UserPass: string[20];
  end;
  PCmdTermsrvRegUserData = ^TCmdTermsrvRegUserData;
  {用户登录命令的返回@link(TCmdTermsrvRegUserData)}
  TCmdSrvtermRegUserData = packed record
    Size: Word;
    Flag: Byte;
    Ret: integer;
    ServerVer: TVer;
  end;
  PCmdSrvtermRegUserData = ^TCmdSrvtermRegUserData;

  {终端向网关服务器请求获取设备的最后一条位置（有效的）状态数据
  @TABB
  @H(标识  | 类型    |含义                  |参见)
  @R( size | Word    |数据包的长度=sizeof() | | )
  @R( Flag | Byte    |=| )
  @R( CmdId| | )
  @R( DevId| | )
  @TABE}
  TCmdTermsrvGetlastPosData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetlastPosData = ^TCmdTermsrvGetlastPosData;
  TCmdTermsrvGetlastStation = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetlastStation = ^TCmdTermsrvGetlastStation;
  {获取移动目标的最后一条位置状态数据命令执行的返回结果
    @TABB
    @H(标识  | 类型  |含义         |参见)
    @R( Size | Word  | 数据包的长度| )
    @R( Flag | Byte  | 命令的标志  | )
    @R( CmdId|Integer| 命令ID      | )
    @R( Ret  |Integer| 返回值      | )
    @TABE
  }
  TCmdSrvtermGetlastPosData = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvtermGetlastPosData = ^TCmdSrvtermGetlastPosData;

  {获取GPS设备状态}
  TCmdTermsrvGetstatData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetstatData = ^TCmdTermsrvGetstatData;

  {获取GPS设备状态的返回值}
  TCmdSrvtermGetstatData = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
    case integer of
      0: ();
      1: (
        MajorVer: Byte;
        MinorVer: Byte;
        Freq: Word;
        AutoSend: Byte;
         //BatteryVoltage: Word;
         //Batterytemperature: Word;
        HaveMoreInfo: Byte);
  end;
  PCmdSrvtermGetstatData = ^TCmdSrvtermGetstatData;

  {接受GPS设备的定位数据}
  TCmdSrvtermGpsdata = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    Long: integer;
    Lat: integer;
    GpsTime: array[0..5] of Byte;
    Altitude: Word;
    Speed: Word;
    Angle: Word;
    Stat: Byte;
    Switch: Byte;
  end;
  PCmdSrvtermGpsdata = ^TCmdSrvtermGpsdata;

  {解析后的GPS数据}
  TGpsData = packed record
    Size: Byte;
    Id: integer;
    Long: Double;
    Lat: Double;
    GpsTime: TDateTime;
    Speed: integer;
    Altitude: integer;
    Angle: integer;
    IO: Word; //低8位表示接头,高8位表示设备状态
    //高8位的0位表示定位状态,1位表示GPRS在线状态
  end;
  PGpsData = ^TGpsData;

  {呼叫车机命令
    @TABB
    @H(标识      |类型   |  含义                      |参见)
    @R( Size     | Word  |=sizeof(TCmdTermsrvCalldev) | )
    @R( Flag     | Byte  |=TERMSRV_CALLDEV            | )
    @R( CmdId    |Integer|命令ID                      | )
    @R( DevId |Integer|要呼叫的移动目标ID          | )
    @R( Freq     | Word  |呼叫后发送数据的频率        | )
    @R( HoldTime | Word  | 呼叫持续的时间             | )
    @R( AvailTime| Byte  |这条命令在命令列表中的有效期(分钟)，超过有效期任没有被执行就取消| )
    @TABE
  }
  TCmdTermsrvCalldev = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
    Freq, HoldTime: Word;
    AvailTime: Byte;
  end;
  PCmdTermsrvCalldev = ^TCmdTermsrvCalldev;

  TCmdSrvtermCalldev = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId, Ret: integer;
    Freq, HoldTime: Word;
  end;
  PCmdSrvtermCalldev = ^TCmdSrvtermCalldev;

  {反控命令
    @TABB
    @H(标识       | 类型  |含义                   |参见)
    @R( Size      |Word   |数据包长度             | )
    @R( Flag      |Byte   |命令标志               | )
    @R( CmdID     |integer|命令编号               | )
    @R( DevId  |integer|目标ID                 | )
    @R( SwitchId  | Byte  | 继电器ID              | )
    @R( SwitchStat| Stat  | 继电器状态＝0断开，＝1吸合| )
    @TABE
  }
  TCmdTermsrvSwitchCtrlData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
    SwitchId, SwitchStat: Byte;
  end;
  PCmdTermsrvSwitchCtrlData = ^TCmdTermsrvSwitchCtrlData;

  TCmdSrvtermSwitchCtrlData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId, Ret: integer;
    SwitchId, SwitchStat: Byte;
  end;
  PCmdSrvtermSwitchCtrlData = ^TCmdSrvtermSwitchCtrlData;

 {
  TERMSRV_SENDDEVMSG  = $08;
  SRVTERM_SENDDEVMSG  = $88;
  发送简短消息到设备}
  TCmdTermSrvDevMsgHeader = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word;
    MsgType: Byte
    //MsgContent:TBytes;
  end;
  PCmdTermSrvDevMsgHeader = ^TCmdTermSrvDevMsgHeader;

  {服务器响应客户端发送的命令"发送简短消息到设备"}
  TCmdSrvTermDevMsg = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word;
    Ret: integer;
  end;
  PCmdSrvTermDevMsg = ^TCmdSrvTermDevMsg;


  {客户端PING服务器}
  TCmdTermsrvPingData = packed record
    Size: Word;
    Flag: Byte; //TERMSRV_PING
    CmdId, TimeStamp: Longword;
  end;
  PCmdTermsrvPingData = ^TCmdTermsrvPingData;
  {服务器对PING的响应}
  TCmdSrvterPingData = packed record
    Size: Word;
    Flag: Byte; //SRVTERM_PING
    CmdId, TimeStamp: Longword;
  end;
  PCmdSrvterPingData = ^TCmdSrvterPingData;

  {服务器有数据更新的通知，
  通知客户端要刷新指定的设备的信息}
  TSrvtermNotifystat = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    ChangeFlag: Byte;
  end;
  PSrvtermNOtifystat = ^TSrvtermNotifystat;

  {  取消正在执行的命令
     @TABB
     @H(标识|  类型   |含义                             |参见)
     @R( Size| Word   |=sizeof(TCmdTermsrvCancelCmdData)|  )
     @R( Flag| Byte   |=TERMSRV_CANCELCMD               | )
     @R( CmdID|integer| 这条命令的ID                    | )
     @R( CmdTobeCancel| integer| 要取消的命令ID         | )
     @TABE
  }
  TCmdTermsrvCancelCmd = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    CmdTobeCancel: integer;
  end;
  PCmdTermsrvCancelCmd = ^TCmdTermsrvCancelCmd;

  {  取消正在执行的命令的服务器处理结果响应
     @TABB
     @H(标识|  类型   |含义                             |参见)
     @R( Size| Word   |=sizeof(TCmdSrvTermCancelCmdData)|  )
     @R( Flag| Byte   |=SRVTERM_CANCELCMD               | )
     @R( CmdID|integer| 这条命令的ID                    | )
     @R( CmdTobeCancel| integer| 要取消的命令ID         | )
     @R( Ret | integer| 处理结果的返回值                | )
     @TABE
  }
  TCmdSrvTermCancelCmd = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    CmdTobeCancel: integer;
    Ret: integer;
  end;
  PCmdSrvTermCancelCmd = ^TCmdSrvTermCancelCmd;

 {   发送数据至DTE
     @TABB
     @H(标识|  类型   |含义                             |参见)
     @R( Size| Word   |=sizeof(TCmdSrvTermCancelCmdData)|  )
     @R( Flag| Byte   |=SRVTERM_CANCELCMD               | )
     @R( CmdID|integer| 这条命令的ID                    | )
     @R( CmdTobeCancel| integer| 要取消的命令ID         | )
     @R( Ret | integer| 处理结果的返回值                | )
     @TABE
  }
  TCmdTermSrvSendToDTEHeader = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    DataLen: Byte;
  end;
  PCmdTermSrvSendToDTEHeader = ^TCmdTermSrvSendToDTEHeader;

  {服务器给出的响应命令}
  TCmdSrvTermSendToDTE = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvTermSendToDTE = ^TCmdSrvTermSendToDTE;

  {SRVTERM_DEVTOHOST,收到Dev发送到Host的数据}
  TCmdSrvTermRecvFromDTEHeader = TCmdTermSrvSendToDTEHeader;
  PCmdSrvTermRecvFromDTEHeader = ^TCmdSrvTermRecvFromDTEHeader;

  {接受服务器发送的通知消息
  CmdFlag	1Byte	SRVTERM_SENDMSG
  Msg	1Byte
  Data	Bytes[DataLen]
  }
  TCmdSrvTermSendMsg = packed record
    Size: Word;
    Flag: Byte;
    MsgLen: Byte;
  end;
  PCmdSrvTermSendMsg = ^TCmdSrvTermSendMsg;

  {命令被删除后通知客户端}
  TCmdSrvTermCmdDeleted = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer; //被删除的命令ID
    DelType: Byte; //被删除的原因类型 1-删除，2-被替代 3-超时
  end;
  PCmdSrvTermCmdDeleted = ^TCmdSrvTermCmdDeleted;

  {
  客户端发送命令读取设备的参数，
  TERMSRV_READDEVPARAM
  }
  TcmdTermSrvReadDevParam = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ReadNum: Byte; // add by sha 2004-10-27
  end;
  PCmdTermSrvReadDevParam = ^TcmdTermSrvReadDevParam;

{返回的设备的参数数据包头 具体参数表现为([参数编号][参数值])
  SRVTERM_SETDEVPARAM}
  TCmdSrvTermReadDevParamRet = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
    //params
  end;
  PCmdSrvTermReadDevParamRet = ^TCmdSrvTermReadDevParamRet;

  {设置设备的参数@link(TCmdSrvTermReadDevParam)}
  TCmdTermSrvSetDevParam = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //params
  end;
  PCmdTermSrvSetDevParam = ^TCmdTermSrvSetDevParam;

  {设置设备参数的命令执行返回数据}
  TCmdSrvTermSetDevParamRet = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvTermSetDevParamRet = ^TCmdSrvTermSetDevParamRet;


  {通过UDP端口通知需要从数据库中刷新新的数据的命令
    @TABB
    @H(标识        |类型   |含义|参见)
    @R( Flag       |Byte   | 命令标识=DBSRV_REFRESH| )
    @R( CmdId      |integer| 命令ID| )
    @R( RefreshType|Byte   | 数据刷新的类型| )
    @TABE
    数据刷新类型：
    <li>车辆归属关系发生变化       =$01
    <li>车辆、分组方案信息发生变化 =$02
    <li>车辆-车机对应发生变化      =$04
  }
  TCmdDBSrvRefresh = packed record
    CmdFlag: Word;
    ExeFlag: Byte;
    CmdId: integer;
    RefreshType: Byte;
  end;
  PCmdDBSrvRefresh = ^TCmdDBSrvRefresh;


  (**************客户端与网关 V2.0版　新增的命令 ***********)
  {获取GPS设备状态}
  TCmdTermsrvGetstatData_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetstatData_V2 = ^TCmdTermsrvGetstatData_V2;

  {获取GPS设备状态的返回值}
  TCmdSrvtermGetstatData_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
    case integer of
      0: ();
      1: (
        DevVer: Word; //车机版本　
        DevRegTime: TDateTime; //车机登录时间
        );
  end;
  PCmdSrvtermGetstatData_V2 = ^TCmdSrvtermGetstatData_V2;

  {定位命令，取得车机的当前定位数据   Flag= TERMSRV_GETPOSITION}
  TCmdTermSrvGetPosition = packed record
    Size: Word;
    Flag: Byte; //命令字
    CmdId: integer; //命令序号
    DevId: integer;
  end;
  PCmdTermSrvGetPosition = ^TCmdTermSrvGetPosition;
  {网关回复　Flag= SRVTERM_GETPOSITION}
  TCmdSrvTermGetPosition = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermGetPosition = ^TCmdSrvTermGetPosition;
  {从网关取得车机定位数据 Flag= SRVTERM_GPSDATA_V2}
  TCmdSrvTermGpsData_V2 = packed record
    Size: Word;
    Flag: Byte;
    //CmdID:integer; 无CmdID
    DevId: integer;
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    Speed: Byte; //速度　单位：公里/小时，表示范围0～255
    Orientation: Byte; //方向　正北方向为0度，顺时针增加，单位：2度，数值范围0～180。
    State: Longword; //32位状态位
    GpsTime: array[0..5] of Byte; // GPS时间
  end;
  PCmdSrvTermGpsData_V2 = ^TCmdSrvTermGpsData_V2;

  TCmdSrvTermGpsData_XM = packed record //修改08-8-11(AYH)
    Size: word;
    Flag: Byte;
    DevId: integer;
    gpsType: byte; //GPS数据类型
    GpsTime: array[0..5] of Byte; // GPS时间
    IsLocat: Byte; //定位状态  0：定位 1：不定位
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    High: integer; //高度
    Speed: integer; //速度
    Dir: integer; //方向
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //保留状态
    runType: byte; //车次状态
    TotalCourse: array[0..2] of Byte;//累计里程
    //SpeedLimit: Byte;//限速值
  end;
  PCmdSrvTermGpsData_XM = ^TCmdSrvTermGpsData_XM;
  TGpsData_XM = packed record
    Size: Byte;
    ID: Integer;
    GpsType: Byte;
    GpsTime: TDateTime;
    Latitude: Double;
    Longitude: Double;
    High: Double;
    Speed: Integer;
    Dir: Double;
    IsLocate: Byte;
    S1: Byte;
    S2: Byte;
    S3: Byte;
    S4: Byte;
    RunType: Byte;
    TotalCourse: array[0..2] of Byte;//累计里程
    SpeedLimited: Byte; //限速值
    Temperature: SmallInt;
  end;
  PGpsData_XM = ^TGpsData_XM;

 {客户端处理时　用的GpsData_V2}
  TGpsData_V2 = packed record
    Size: Byte;
    Id: integer;
    Long: Double; //－已有转换　经度 eg: 118.123456
    Lat: Double; //－已有转换　纬度 eg:  32.123456
    Speed: Byte; //速度　单位：公里/小时，表示范围0～255
    Orientation: Word; //－已有转换　方向　正北方向为0度，顺时针增加，单位：度
    State: Longword; //32位状态位
    GpsTime: TDateTime;
  end;
  PGpsData_V2 = ^TGpsData_V2;


  {追踪车辆 修改08-8-11(AYH)
  @TABB
     @H(标识           |  类型  |含义                             |参见)
     @R( Size          | Word   |=sizeof(TCmdTermSrvPursue)       |  )
     @R( Flag          | Byte   |=TERMSRV_PURSUE                  | )
     @R( CmdID         | integer| 这条命令的序号                  | )
     @R( DevID         | integer| 要追踪车机ID                    | )
     @R( PursueMinute  | Byte   | 单位：分                        | )
     @R( PursueSecond | Byte   | 单位：秒                         | )
     @R( PursueNum    | Word    |追踪次数                         | )
     @TABE
  }
  TCmdTermSrvPursue = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    PursueMinut: Byte;
    PursueSecond: Byte;
    PursueNum: Word;
  end;
  PCmdTermSrvPursue = ^TCmdTermSrvPursue;
  {网关回复－SRVTERM_PURSUE}
  TCmdSrvTermPursue = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermPursue = ^TCmdSrvTermPursue;

  {设置参数 TERMSRV_SETDEVPARAM_V2}
  TCmdTermSrvSetDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ParamId: Word;
    //参数值 长度不定
  end;
  PCmdTermSrvSetDevParam_V2 = ^TCmdTermSrvSetDevParam_V2;
  {网关回复－SRVTERM_SETDEVPARAM_V2}
  TCmdSrvTermSetDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvTermSetDevParam_V2 = ^TCmdSrvTermSetDevParam_V2;
  TCmdSrvTermSetStationParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: byte;
  end;
  PCmdSrvTermSetStationParam_V2 = ^TCmdSrvTermSetStationParam_V2;
  {查询参数 TERMSRV_READDEVPARAM_V2}
  TCmdTermSrvReadDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ParamId: Word; //参数ID
  end;
  PCmdTermSrvReadDevParam_V2 = ^TCmdTermSrvReadDevParam_V2;
  {网关回复　SRVTERM_READDEVPARAM_V2}
  TCmdSrvTermReadDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ReadRet: Byte; //   查询结果0：成功  1：失败
    ParamId: Word; //   参数ID
    ParamLen: Byte; //   参数长度
    //参数值　，长度不定
  end;
  PCmdSrvTermReadDevParam_V2 = ^TCmdSrvTermReadDevParam_V2;
  TCmdSrvTermReadDevParam_Bus = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ReadRet: Byte; //   查询结果0：成功  1：失败
    ParamId: Word; //   参数ID
    ParamLen: Word; //   参数长度
    //参数值　，长度不定
  end;
  PCmdSrvTermReadDevParam_Bus = ^TCmdSrvTermReadDevParam_Bus;
  {解除报警 TERMSRV_REMOVEALARM}
  TCmdTermSrvRemoveAlarm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
  end;
  PCmdTermSrvRemoveAlarm = ^TCmdTermSrvRemoveAlarm;
  {网关回复　SRVTERM_REMOVEALARM}
  TCmdSrvTermRemoveAlarm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermRemoveAlarm = ^TCmdSrvTermRemoveAlarm;

  {发送文本调度信息 TERMSRV_SENDCONTROLINFO}
  TCmdTermSrvSendControlInfo = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgLen: Byte; //信息长度//修改08-8-11(AYH)
    //MsgID: Word; //调度信息ID，从数据库中取值
    //调度信息 不定长 ，<200Byte
  end;
  PCmdTermSrvSendControlInfo = ^TCmdTermSrvSendControlInfo;
  {网关回复}
  TCmdSrvTermSendControlInfo = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
   // MsgID: Word; //调度信息ID，从数据库中取值
    Ret: Byte;
  end;
  PCmdSrvTermSendControlInfo = ^TCmdSrvTermSendControlInfo;

  {发送需回复的调度信息 TERMSRV_SENDCONTROLINFO_NEEDDEVANSWER}
  TCmdTermSrvSendControlInfo_NeedDevAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word; //调度信息ID，从数据库中取值
    //调度信息 不定长 ，<200Byte
  end;
  PCmdTermSrvSendControlInfo_NeedDevAnswer = ^TCmdTermSrvSendControlInfo_NeedDevAnswer;
  {网关回复}
  TCmdSrvTermSendControlInfo_NeedDevAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word; //调度信息ID，从数据库中取值
    Ret: Byte;
  end;
  PCmdSrvTermSendControlInfo_NeedDevAnswer = ^TCmdSrvTermSendControlInfo_NeedDevAnswer;

  {设置电话本 TERMSRV_SETTELLIST}
  TCmdTermSrvSetTelList = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //电话列表 不定长
  end;
  PCmdTermSrvSetTelList = ^TCmdTermSrvSetTelList;
  {网关回复　SRVTERM_SETTELLIST}
  TCmdSrvTermSetTelList = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermSetTelList = ^TCmdSrvTermSetTelList;

  TCmdSrvTermAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermAnswer = ^TCmdSrvTermAnswer;

  {升级车机固件程序 TERMSRV_UPDATEDEVFIRMWARE}
  TCmdTermSrvUpdateDevFirmware = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    UpdateType: Byte; //升级设备类型－－0：表示升级主机1：表示升级调度屏
    //URL地址 不定长＜200Byte
  end;
  PCmdTermSrvUpdateDevFirmware = ^TCmdTermSrvUpdateDevFirmware;
  {网关回复}
  TCmdSrvTermUpdateDevFirmware = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermUpdateDevFirmware = ^TCmdSrvTermUpdateDevFirmware;

  {监控端　至　网关：对车机断油/断电/供油/供电　TERMSRV_CUTORFEED_OIL_ELECTRICITY = $21;}
  TCmdTermSrvCutOrFeedOilOrElectricity = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Content: Byte; //具体操作内容：断油/断电/供油/供电,用常数表示。
  end;
  PCmdTermSrvCutOrFeedOilOrElectricity = ^TCmdTermSrvCutOrFeedOilOrElectricity;
  {网关回复　 SRVTERM_CUTORFEED_OIL_ELECTRICITY     = $C4;}
  TCmdSrvTermCutOrFeedOilOrElectricity = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermCutOrFeedOilOrElectricity = ^TCmdSrvTermCutOrFeedOilOrElectricity;

  {监控端给网关心跳。0200}
  {网关回复　}
  TCmdSrvTermHeartBeat = packed record
    Size: Word; //=3
    Flag: Byte; // SRVTERM_HEARTBEAT =$F0;
  end;
  PCmdSrvTermHeartBeat = ^TCmdSrvTermHeartBeat;

  {监控端 -> 网关 读车机版本 TERMSRV_READDEVVER = $23}
  TCmdTermSrvReadDevVer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
  end;
  PCmdTermSrvReadDevVer = ^TCmdTermSrvReadDevVer;
  { 网关回复　车机上传　车机版本　SRVTERM_READDEVVER = $C6}
  TCmdSrvTermReadDevVer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
    //DevVer 不定长　最长为32字节
  end;
  PCmdSrvTermReadDevVer = ^TCmdSrvTermReadDevVer;

  //监控端 -> 网关 设置司机信息TERMSRV_SETDRIVERS   = $24;
  TCmdTermSrvSetDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    DriverNo1: array[0..9] of char; //定长.不足部份补0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
  end;
  PCmdTermSrvSetDrivers = ^TCmdTermSrvSetDrivers;
  //网关回复      SRVTERM_SETDRIVERS  = $C7;
  TCmdSrvTermSetDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermSetDrivers = ^TCmdSrvTermSetDrivers;

  //监控端 -> 网关  读取司机信息TERMSRV_READDRIVERS  = $25;
  TCmdTermSrvReadDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
  end;
  PCmdTermSrvReadDrivers = ^TCmdTermSrvReadDrivers;
  //网关回复     SRVTERM_READDRIVERS    = $C8;
  TCmdSrvTermReadDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    DriverNo1: array[0..9] of char; //定长.不足部份补0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
    Ret: Byte;
  end;
  PCmdSrvTermReadDrivers = ^TCmdSrvTermReadDrivers;

  //网关-》客户端  上传车辆进站或出站 SRVTERM_INORDOWNSTATION = $D5
  TCmdSrvTermInOrDownStation = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    StationNo: byte;
    Direct: Byte;
    InOrDown: Byte;
  end;
  PCmdSrvTermInOrDownStation = ^TCmdSrvTermInOrDownStation;

  TCmdSrvTermInOrDownStation_XM = packed record //修改
    Size: Word;
    Flag: Byte;
    DevId: Integer; //车载ID
    StationNo: byte; //站点序号
    onOrDown: Byte; //0x01:上行  0x02:下行
    GTime: array[0..5] of byte; //到、离站时间
    STime: array[0..5] of byte; // 到、离站时间 服务器时间
    InOrOut: byte; //0x01:到站  0x02:离站
    SrcType: byte; //来源标志  0x01:车载  0x02:场站
    gpsType: byte; //GPS数据类型
    GpsTime: array[0..5] of Byte; // GPS时间
    IsLocat: Byte; //定位状态  0：定位 1：不定位
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    High: integer; //高度
    Speed: integer; //速度
    Dir: integer; //方向
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //保留状态
    runType: byte; //车次状态
    bSendAgain: Byte; //是否补发，0－正常 1-补发数据
    TotalCourse: array[0..2] of Byte;//累计里程
    { 以上共64字节
      *******************附加信息*********************
      附加信息的组成：附加信息个数(N)＋附加信息×N 如下：
        字段       	   内容	                  类型       长度(字节)	           备注
      附加信息数  附加信息的总个数            Byte          1
      附加信息1   附加信息1类别               Byte          1            根据不同应用系统进行约定
                  附加信息1内容字节数         Byte          1
                  附加信息1内容               Byte(N)     不定长         根据不同应用系统进行约定
      附加信息2   附加信息2类别               Byte          1            根据不同应用系统进行约定
                  附加信息2内容字节数         Byte          1
                  附加信息2内容               Byte(N)     不定长         根据不同应用系统进行约定
      。。。	。。。	。。。
    }
  end;
  PCmdSrvTermInOrDownStation_XM = ^TCmdSrvTermInOrDownStation_XM;

  TCmdSrvTermInOrDownStation_XM_New = packed record //修改
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer; //车载ID
    StationNo: byte; //站点序号
    onOrDown: Byte; //0x01:上行  0x02:下行
    GTime: array[0..5] of byte; //到、离站时间
    STime: array[0..5] of byte; // 到、离站时间 服务器时间
    InOrOut: byte; //0x01:到站  0x02:离站
    SrcType: byte; //来源标志  0x01:车载  0x02:场站
    gpsType: byte; //GPS数据类型
    GpsTime: array[0..5] of Byte; // GPS时间
    IsLocat: Byte; //定位状态  0：定位 1：不定位
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    High: integer; //高度
    Speed: integer; //速度
    Dir: integer; //方向
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //保留状态
    runType: byte; //车次状态
    bSendAgain: Byte; //是否补发，0－正常 1-补发数据
    TotalCourse: array[0..2] of Byte;//累计里程
  end;
  PCmdSrvTermInOrDownStation_XM_New = ^TCmdSrvTermInOrDownStation_XM_New;


  //网关->客户端  上传车机从服务器注销  SRVTERM_DEVLOGOUTFROMSRV = $B8;
  TCmdSrvTermDevLogOutFromSrv = packed record
    Size: Word;
    Flag: byte;
    DevId: integer;
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    Speed: Byte; //速度　单位：公里/小时，表示范围0～255
    Orientation: Byte; //方向　正北方向为0度，顺时针增加，单位：2度，数值范围0～180。
    State: Longword; //32位状态位
    GpsTime: array[0..5] of Byte;
  end;
  PCmdSrvTermDevLogOutFromSrv = ^TCmdSrvTermDevLogOutFromSrv;
  //网关-》客户端  上传车辆超速记录  SRVTERM_OVERSPEEDINFO = $D7
  TCmdSrvTermOverSpeedInfo = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    AreaNo: integer;
    overSpeedTime: array[0..5] of byte;
    IsBengin: byte;
  end;
  PCmdSrvTermOverSpeedInfo = ^TCmdSrvTermOverSpeedInfo;
  //网关-》客户端  上传驾驶员登陆或进入终点站
  TCmdSrvTermUploadStartOrEndStation = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    OnOrDown: Byte;
    StartOrEnd: Byte;
    TotalCourse: Double;
  end;
  PCmdSrvTermUploadStartOrEndStation = ^TCmdSrvTermUploadStartOrEndStation;

  //网关-》客户端  上传驾驶员登陆或进入终点站(思明公司用)
  TCmdSrvTermUploadStartOrEndStation_SM = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    OnOrDown: Byte;
    StartOrEnd: Byte;
    //以下和定位数据相同
    GpsData: TCmdSrvTermGpsData_XM;
//    gpsType: byte; //GPS数据类型
//    GpsTime: array[0..5] of Byte; // GPS时间
//    IsLocat: Byte; //定位状态  0：定位 1：不定位
//    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
//    Longitude: integer; //经度 X 100 0000
//    High: integer; //高度
//    Speed: integer; //速度
//    Dir: integer; //方向
//    S1: byte;
//    S2: Byte;
//    S3: byte;
//    S4: byte;
//    S: array[0..3] of byte; //保留状态
//    runType: byte; //车次状态
  end;
  PCmdSrvTermUploadStartOrEndStation_SM = ^TCmdSrvTermUploadStartOrEndStation_SM;

  //网关转发的南通计价器营运数据
  //网关-》客户端  司机登陆  SRVTERM_DRIVERON = $DA
  TCmdSrvTermDriverOn = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//累计里程
    //UserId: Integer;
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOn = ^TCmdSrvTermDriverOn;
  //网关 -》客户端  司机退出 SRVTERM_DRIVEROFF = $DB
  TCmdSrvTermDriverOff = packed record
    Size: Word;
    Flag: byte;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LogOutTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//累计里程
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOff = ^TCmdSrvTermDriverOff;

  TCmdSrvTermDriverOn_New = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//累计里程
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOn_New = ^TCmdSrvTermDriverOn_New;

  TCmdSrvTermDriverOnWithUser = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//累计里程
    UserId: Integer;
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOnWithUser = ^TCmdSrvTermDriverOnWithUser;

  //网关 -》客户端  司机退出 SRVTERM_DRIVEROFF = $DB
  TCmdSrvTermDriverOff_New = packed record
    Size: Word;
    Flag: byte;
    CmdId: Integer;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LogOutTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//累计里程
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOff_New = ^TCmdSrvTermDriverOff_New;

   //客户端->网关 拍照，拍当前照片 TERMSRV_GETAPIC= $27;
  TCmdTermSrvGetAPic = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    GetPicSize: Byte; //照片尺寸大小 0=320x240  1=640x480  2-else
    CameraIndex: Byte; //摄像头号
  end;
  PCmdTermSrvGetAPic = ^TCmdTermSrvGetAPic;
  //网关回复  SRVTERM_GETAPIC= $CB;
  TCmdSrvTermGetAPic = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermGetAPic = ^TCmdSrvTermGetAPic;
  //====================================================================================
  //客户端-》网关  读取当前车辆所处的站点信息     TERMSRV_DOWNLED_NEW
  TCmdSrvReadDevStation = packed record
    Size: word;
    Flag: byte;
    DevId: integer;
  end;
  PCmdSrvReadDevStation = ^TCmdSrvReadDevStation;
  //网关回复车辆进站信息

  // 客户端->网关，设置车机主动向外拨打的监听号码 2007-9-24  TERMSRV_DOWNLISTENCALLNUM = $2E;
  TCmdTermSrvDownListenCallNum = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //ListenCallNum :<20 ASCII码
  end;
  PCmdTermSrvDownListenCallNum = ^TCmdTermSrvDownListenCallNum;
  //网关回复  SRVTERM_DOWNLISTENCALLNUM = $D2;
  TCmdSrvTermDownListenCallNum = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermDownListenCallNum = ^TCmdSrvTermDownListenCallNum;

  //客户端->网关，客户端发送通用的命令，网关不负责解析 2007-10-08  TERMSRV_DOWNGENERICCOMMAND = $2F
  TCmdTermSrvDownGenicCommand = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //命令内容
  end;
  PCmdTermSrvDownGenicCommand = ^TCmdTermSrvDownGenicCommand;
  //网关回复   SRVTERM_DOWNGENERICCOMMAND = $D3
  TCmdSrvTermDownGeniccommand = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermDownGeniccommand = ^TCmdSrvTermDownGeniccommand;

  (****以下为网关主动给客户端的数据***)
  {网关给客户端－司机对 需回复的调度信息 的回复－“是”或“否” SRVTERM_SENDCONTROLINFO_DRIVERANSWER}
  TCmdSrvTermSendControlInfo_DriverAnswer = packed record
    Size: Word;
    Flag: Byte;
    //CmdID:integer; 无CmcID
    DevId: integer;
    MsgID: Word; //调度信息ID，从数据库中取值
    AnswerInfo: Byte; //司机反馈信息 - 0：否  1：是
  end;
  PCmdSrvTermSendControlInfo_DriverAnswer = ^TCmdSrvTermSendControlInfo_DriverAnswer;

  //网关告知客户端 收到车机已成功上传新的照片 SRVTERM_APICUPLOADED = $B5;
  TCmdSrvTermAPicUploaded = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    PicIndex: integer; //该车机的照片序号
    CameraIndex: Byte; //摄像头号
    PicReson: Byte; //拍照原因
    DoneRet: Byte; //拍照结果　0-成功，1-照片缓冲区満2-摄像头故障3-传输失败
  end;
  PCmdSrvTermAPicUploaded = ^TCmdSrvTermAPicUploaded;

{********************  以下是服务器和GPS车载设备之间的命令结构   *********************}
  {IP地址的}
  TInetAddr = packed record
    a: Byte;
    b: Byte;
    c: Byte;
    d: Byte;
  end;

  {  1.1版统一的车机设备命令数据头格式
     @TABB
     @H( 标识    | 类型   | 含义        |参见)
     @R( CmdFlag | byte   | 命令标志    | )
     @R( ExecFlag| byte   | 命令执行状态| )
     @R( DevID   | integer| 设备ID      | )
     @TABE
  }
  TCmdDevHeader = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    case integer of
      0: (Execute: Byte);
      1: (CheckSum: Byte);
  end;
  PCmdDevHeader = ^TCmdDevHeader;


  {设备注册服务器,车载设备联网后向服务器发出的验证信息
  DEV_LOGIN        =$FE;}
 {
  包长度	1Byte	包长度为整个数据包的长度。
  设备标识	4Byte
  命令字=0xFE	1Byte
  设备IP	4Byte
  设备Port	2Byte
  协议版本	2Byte
  设备版本	2Byte
  校验	1Byte
 }
  TCmdDevSrvLogon = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    DevIP: TInetAddr;
    Port: Word;
    CommVer: TVer;
    DevVer: TVer;
    CheckSum: Byte;
  end;
  PCmdDevSrvLogon = ^TCmdDevSrvLogon;

  {注册命令的返回值 Ret 0x00-注册成功0x01-注册失败}
  TCmdDevSrvLogonRet = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    Ret: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvLogonRet = ^TCmdDevSrvLogonRet;

  {设备注销
  DEV_LOGOFF       =$FF;
  @TABB
  @H(标识   | 类型    |含义                  |参见)
  @R( size  | Word    |数据包的长度=sizeof() |  )
  @R( DevID | Byte    |设备标识              | )
  @R( CmdFlag |       |命令字                | )
  @R( Execute| Byte   |命令执行状态          | )
  @R(LogOffReason|Byte| 注销原因)
  @R( CheckSum|Byte   |校验 )
  @TABE
  }
  TCmdDevSrvLogOff = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    Execute: Byte;
    LogOffReason: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvLogOff = ^TCmdDevSrvLogOff;

  {普通GPS数据 DEV_NGPSDATA     =$10;
  命令字=0x10	1Byte
  经度	4Byte	单位（ddd度mm.mmm分）
  纬度	4Byte	单位（ddd度mm.mmm分）
  速度	2Byte	单位 0.1海里/小时 = 0.1852公里/小时
  时间	6Byte	YY-MM-DD HH mm SS
  设备状态	1Byte	Bit0 GPS定位状态  Bit1 GPRS在线状态  其他保留
  OI状态	  1Byte	Bit0 表示报警按钮
  注：此数据中没有 高度 数据
  }
  TCmdDevSrvNGpsData = packed record
    Size: Byte;
    DevId: integer;
    Flag: Byte;
    Long: array[0..3] of Byte;
    Lat: array[0..3] of Byte;
    Speed: array[0..1] of Byte;
    GpsTime: array[0..5] of Byte;
    Stat: Byte;
    Switch: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvNGpsData = ^TCmdDevSrvNGpsData;


  {批量的GPS数据,设备发送的批量GPS数据记录
  }
  TBatchGpsData = packed record
    //Long: Integer;
    //Lat:  Integer;
    Long: array[0..3] of Byte;
    Lat: array[0..3] of Byte;
    //Speed: Word;
    Speed: array[0..1] of Byte;
    Stat: Byte;
    Switch: Byte;
  end;
  PBatchGpsData = ^TBatchGpsData;

  {批量GPS数据<br>
  DEV_BGPSDATA     =$12;
  @TABB
  @H(标识    |类型    |含义                  |参见)
  @R( size   |Word    |包长度	1Byte	包长度为整个数据包的长度| )
  @R( DevID  |longword| 设备ID|)
  @R( CmdFlag|Byte    |=$12| )
  @R( ETime  |Byte[6] |最后一条数据时间时间 |)
  @R( InterVal|Word   |间隔时间,设备发送的BigEnd字节顺序的整型| )
  @R( RecordCount|Byte|记录个数 n	1Byte )
  @TABE
  }
  TCmdDevSrvBGpsDataHeader = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ETime: array[0..5] of Byte;
    InterVal: Word;
    RecordCount: Byte;
    //n*record:  TBatchGpsData[]
    //CheckSum:Byte;
  end;
  PCmdDevSrvBGpsDataHeader = ^TCmdDevSrvBGpsDataHeader;

  {跟踪命令  DEV_TRACE        =$13;
  命令字=0x13	1Byte
  命令执行状态	1Byte
  呼叫时间间隔	1Byte	0~255秒
  呼叫持续时间	2Byte	0~3600秒}
  TCmdSrvDevTrace = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    Freq: Byte;
    Time: Word;
    CheckSum: Byte;
  end;
  PCmdSrvDevTrace = ^TCmdSrvDevTrace;

  {远程控制
  DEV_REMOTECTRL   =$14;
  命令执行状态	1Byte
  继电器编号	1Byte
  继电器状态	1Byte	对应的每一位可表示一个继电器
  }
  TCmdSrvDevRemoteCtrl = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    RelayNo: Byte;
    RelaySw: Byte;
    CheckSum: Byte;
  end;
  PCmdSrvDevRemoteCtrl = ^TCmdSrvDevRemoteCtrl;


  {设置参数
  DEV_SETPARAM     =$15;使用通用的数据头处理}
  TCmdSrvDevSetParam = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    //[n of params]
    //CheckSum:Byte;
  end;
  PCmdSrvDevSetParam = ^TCmdSrvDevSetParam;

  {设置参数
  DEV_SETPARAM     =$15;使用通用的数据头处理}
  TCmdDevSrvSetParamRet = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvSetParamRet = ^TCmdDevSrvSetParamRet;


  {读取参数
  DEV_READPARAM    =$16;
  包长度	1Byte	包长度为整个数据包的长度。
  设备标识	4Byte
  命令字=0x16	1Byte	读取设备参数
  命令执行状态	1Byte	CMD_REQUEST
  }
  TCmdSrvDevReadParam = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    ReadNum: Byte; // add by sha 2004-10-27
    CheckSum: Byte;
  end;
  PCmdSrvDevReadParam = ^TCmdSrvDevReadParam;


  {发送简短消息
  DEV_SENDMSG      =$17;}
  TCmdSrvDevSendMsg = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    MsgID: Word;
    MsgType: Byte;
      //MsgContent[]Bytes
  end;
  PCmdSrvDevSendMsg = ^TCmdSrvDevSendMsg;

  {设备收到后的返回数据DEV_SENDMSG      =$17}
  TCmdDevSrvRecvmsg = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    MsgID: Word;
    AttValue: Word;
    CheckSum: Byte;
  end;
  PCmdDevSrvRecvmsg = ^TCmdDevSrvRecvmsg;

  {发送数据到DTE
  DEV_TODTE        =$18;}
  TCmdSrvDevSendToDTEHdr = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    DataID: Byte;
    DataLen: Byte;
      //..DataContent;   Bytes[]
      //..CheckSum:Byte;
  end;
  PCmdSrvDevSendToDTEHdr = ^TCmdSrvDevSendToDTEHdr;

  TCmdDevSrvSendToDTERet = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    DataID: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvSendToDTERet = ^TCmdDevSrvSendToDTERet;

  {设备发送数据到服务器
  从DTE接受数据
  DEV_TOHOST       =$19;}
  TCmdDevSrvSendToHost = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    DataID: Byte;
    DataLen: Byte;
      //..DataContent;   Bytes[]
      //..CheckSum:Byte;
  end;
  PCmdDevSrvSendToHost = ^TCmdDevSrvSendToHost;
  {服务器响应设备已收到数据}
  TCmdSrvDevSendToHostRet = TCmdDevSrvSendToDTERet;
  PCmdSrvDevSendToHostRet = ^TCmdSrvDevSendToHostRet;
  //PING 服务器命令
  //DEVSRV_PING         =$EC;

  (******网关与车机　V2.0 **********)
  {V2.0版的车机命令头}
  TCmdDevHeader_V2 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    //命令体
    //CheckSum     : Byte;  //校验
  end;
  PCmdDevHeader_V2 = ^TCmdDevHeader_V2;

  {中心给车机的　通用应答 CmdId=DEV_SRVRET_V2}
  TCmdSrvDevAnswer = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字$01
    Answer_CmdOrder: Word; //车机 发命令时的 命令序号
    Answer_CmdFlag: Byte; //车机 发命令时的 命令ID
    Ret: Byte; //处理结果	0：成功　1：失败
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevAnswer = ^TCmdSrvDevAnswer;

  {车机给中心的　通用应答 CmdId=DEV_DEVRET_V2}
  TCmdDevSrvAnswer = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字 $71
    Answer_CmdOrder: Word; //中心　下发命令时的 命令序号
    Answer_CmdFlag: Byte; //中心　下发命令时的 命令ID
    Ret: Byte; //处理结果	0：成功　1：失败
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvAnswer = ^TCmdDevSrvAnswer;

  {车机给中心的通用应答 无校验和 CmdId=DEV_DEVRET_V2　20070602}
  TCmdDevSrvAnswer_NoSum = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字 $71
    Answer_CmdOrder: Word; //中心　下发命令时的 命令序号
    Answer_CmdFlag: Byte; //中心　下发命令时的 命令ID
    Ret: Byte; //处理结果	0：成功　1：失败
    //CheckSum: Byte; //校验
  end;
  PCmdDevSrvAnswer_NoSum = ^TCmdDevSrvAnswer_NoSum;


  {中心－＞车机　定位　CmdId=DEV_GETPOSITION_V2 =$02 }
  TCmdSrvDevGetPostion = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevGetPostion = ^TCmdSrvDevGetPostion;
  {车机给中心　定位的数据 CmdId=DEV_GPSDATA_V2=$72}
  TCmdDevSrvGpsData_V2 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    Speed: Byte; //速度　单位：公里/小时，表示范围0～255
    Orientation: Byte; //方向　正北方向为0度，顺时针增加，单位：2度，数值范围0～180。
    State: Longword; //32位状态位
    GpsTime: array[0..5] of Byte; //GPS时间　
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvGpsData_V2 = ^TCmdDevSrvGpsData_V2;

  //无校验和，有Gps时间
  //车机给中心　定位的数据 CmdId=DEV_GPSDATA_V2=$72
  TCmdDevSrvGpsData_NoSum = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    Speed: Byte; //速度　单位：公里/小时，表示范围0～255
    Orientation: Byte; //方向　正北方向为0度，顺时针增加，单位：2度，数值范围0～180。
    State: Longword; //32位状态位
    GpsTime: array[0..5] of Byte; //GPS时间　
    //CheckSum: Byte; //校验
  end;
  PCmdDevSrvGpsData_NoSum = ^TCmdDevSrvGpsData_NoSum;

  {中心－＞车机　追踪　CmdId=DEV_PURSUE_V2 =$03}
  TCmdSrvDevPursue = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    PursueInterval: Word; //追踪间隔	单位：秒，最小为0，默认为30，最大为65535（约18小时）
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevPursue = ^TCmdSrvDevPursue;
  {车机 采用 通用应答}

  {中心－＞车机 设定参数 CmdId = DEV_SETPARAM_V2 = $04;}
  TCmdSrvDevSetParam_V2 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    ParamId: Word; //参数ID
    //参数值 长度不定
    //CheckSum     : Byte;  //校验
  end;
  PCmdSrvDevSetParam_V2 = ^TCmdSrvDevSetParam_V2;
  {车机 采用 通用应答}

  {中心－＞车机　解除报警　CmdId =DEV_REMOVEALARM_V2 =$05}
  TCmdSrvDevRemoveAlarm = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevRemoveAlarm = ^TCmdSrvDevRemoveAlarm;
  {车机 采用 通用应答}

  {中心－＞车机 发送文本调度信息 DEV_SENDCONTROLINFO_V2 = $09;}
  TCmdSrvDevSendControlInfo = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    //调度信息 不定长 ，<200Byte
    //CheckSum     : Byte;  //校验
  end;
  PCmdSrvDevSendControlInfo = ^TCmdSrvDevSendControlInfo;
  {车机 采用 通用应答}

  {中心－＞车机 发送需回复的调度信息 DEV_SENDCONTROLINFO_NEEDANSWER_V2 = $0A}
  TCmdSrvDevSendControlInfo_NeedAnswer = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    MsgID: Word; //调度信息ID
    //调度信息 不定长 ，<200Byte
    //CheckSum     : Byte;  //校验
  end;
  PCmdSrvDevSendControlInfo_NeedAnswer = ^TCmdSrvDevSendControlInfo_NeedAnswer;
  {车机 采用 通用应答}

  {中心－＞车机 设置电话本 DEV_SETTELLIST_V2 = $0F;}
  TCmdSrvDevSetTelList = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    ////电话列表 不定长
    //CheckSum     : Byte;  //校验
  end;
  PCmdSrvDevSetTelList = ^TCmdSrvDevSetTelList;
  {车机 采用 通用应答}

  {中心－＞车机 升级固件 DEV_UPDATEFIRMWARE_V2 = $10}
  TCmdSrvDevUpdateFirmware = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    UpdateType: Byte; //升级设备类型－－0：表示升级主机1：表示升级调度屏
    //URL地址 不定长＜200Byte
    //CheckSum     : Byte;  //校验
  end;
  PCmdSrvDevUpdateFirmware = ^TCmdSrvDevUpdateFirmware;
  {车机 采用 通用应答}

  {中心－＞车机 读参数 DEV_READPARAM_V2 = $11}
  TCmdSrvDevReadParam_V2 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    ParamId: Word; //   参数ID
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevReadParam_V2 = ^TCmdSrvDevReadParam_V2;
  {车机－＞中心　读参数应答－－　★★在通用应答基础上加上参数值}
  TCmdDevSrvReadParam_V2 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字  = ★车机应答通用命令字　=DEV_DEVRET_V2=$71
    Answer_CmdOrder: Word; //中心　下发命令时的 命令序号
    Answer_CmdFlag: Byte; //中心　下发命令时的 ★命令ID  = DEV_READPARAM_V2 = $11
    Ret: Byte; //处理结果	0：成功　1：失败
    ParamId: Word; //   参数ID
    //参数值
    //CheckSum     : Byte;  //校验
  end;
  PCmdDevSrvReadParam_V2 = ^TCmdDevSrvReadParam_V2;
  {网关给出非通用应答 DEV_RETUPLOADDONEORDER      = $1A;}
  TCmdSrvDevRetUploadDoneOrder_4 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    OrderID: integer;
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevRetUploadDoneOrder_4 = ^TCmdSrvDevRetUploadDoneOrder_4;

  {车机－＞中心 司机对 需回复的调度信息的 回复 DEV_SENDCONTROLINFO_DRIVERANSWER_V2= $74}
  TCmdDevSrvSendControlInfo_DriverAnswer = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    MsgID: Word; //调度信息ID，从数据库中取值
    AnswerInfo: Byte; //司机反馈信息 - 0：否  1：是
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvSendControlInfo_DriverAnswer = ^TCmdDevSrvSendControlInfo_DriverAnswer;
  {中心再给出通用应答}

  {车机－＞中心  车机登录 DEV_LOGIN_V2  = $7B}
  TCmdDevSrvLogin_V2 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    Speed: Byte; //速度　单位：公里/小时，表示范围0～255
    Orientation: Byte; //方向　正北方向为0度，顺时针增加，单位：2度，数值范围0～180。
    State: Longword; //32位状态位
    GpsTime: array[0..5] of Byte;
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvLogin_V2 = ^TCmdDevSrvLogin_V2;
  {中心再给出通用应答}
  {车机->中心 车机从服务器注销  DEV_LOGOUT_V2 = $89 }
  TCmdDevSrvLogOut_V2 = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    Speed: Byte; //速度　单位：公里/小时，表示范围0～255
    Orientation: Byte; //方向　正北方向为0度，顺时针增加，单位：2度，数值范围0～180。
    State: Longword; //32位状态位
    GpsTime: array[0..5] of Byte;
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvLogOut_V2 = ^TCmdDevSrvLogOut_V2;
  {车机－＞中心　上传参数，暂不做}
  TCmdDevSrvUpdateParam = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    ReadRet: Byte; //   查询结果0：成功  1：失败
    ParamId: Word; //   参数ID
    ParamLen: Byte; //   参数长度
    //参数值
    //CheckSum     : Byte;  //校验
  end;

  {中心给车机下发断油/断电/供油/供电命令 DEV_CUTORFEED_OIL_ELECTRICITY     = $16; }
  TCmdSrvDevCutOrFeedOilOrElectricity = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    Content: Word; //详细内容： 断油/断电/供油/供电
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevCutOrFeedOilOrElectricity = ^TCmdSrvDevCutOrFeedOilOrElectricity;
  {车机再给通用应答}
  {中心-> 车机 读版本数据  DEV_READDEVVER = $AB;}
  TCmdSrvDevReadDevVer = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevReadDevVer = ^TCmdSrvDevReadDevVer;
  {车机-> 中心 上传车机版本 DEV_UPLOADDEVVER= $FB}
  TCmdDevSrvRetReadDevVer = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    //版本数据　＜＝32    AscII码         　
    //CheckSum   : Byte;    //校验
  end;
  PCmdDevSrvRetReadDevVer = ^TCmdDevSrvRetReadDevVer;

  //新增司机相关命令 2006-8-25
  {中心-> 车机 设置司机信息 DEV_SETDRIVERS  = $17;}
  TCmdSrvDevSetDrivers = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    DriverNo1: array[0..9] of char; //定长.不足部份补0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevSetDrivers = ^TCmdSrvDevSetDrivers;
  {车机给出通用应答}

  {中心-> 车机 读取司机信息 DEV_READDRIVERS   = $18;}
  TCmdSrvDevReadDrivers = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevReadDrivers = ^TCmdSrvDevReadDrivers;
  {车机　回复}
  TCmdDevSrvRetReadDrivers = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    DriverNo1: array[0..9] of char; //定长.不足部份补0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvRetReadDrivers = ^TCmdDevSrvRetReadDrivers;

  {中心-> 车机 读取当前司机 DEV_READCURRENTDRIVER = $19;}
  TCmdSrvDevReadCurrentDriver = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevReadCurrentDriver = ^TCmdSrvDevReadCurrentDriver;


  {车机 ->中心　上传当前司机　DEV_UPLOADCURRENTDRIVER = $7D;--可能是中心读取的应答，也可能是主动上传的}
  TCmdDevSrvUploadCurrentDriver = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvUploadCurrentDriver = ^TCmdDevSrvUploadCurrentDriver;

  {车机-》中心 上传车辆进站或出站 DEV_INORDOWNSTATION=$84}
  TCmdDevSrvInOrDownStation = packed record
    Size: Word;
    DevFaction: Byte;
    DevId: integer;
    ComVer: Byte;
    CmdOrder: Word;
    CmdFlag: Byte;
    StationNo: Byte;
    Direct: Byte;
    InOrDown: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvInOrDownStation = ^TCmdDevSrvInOrDownStation;
  {车机 -> 中心 上传司机下班退出 DEV_UPLOADDRIVERLOGOUT }
  TCmdDevSrvUploadDriverLogOut = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    DriverNo: array[0..9] of Byte;
    LogOutTime: array[0..5] of Byte;
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvUploadDriverLogOut = ^TCmdDevSrvUploadDriverLogOut;
  {中心给出通用应答}

  //中心-> 车机 让车机拍一张照片DEV_GETAPIC = $1B;
  TCmdSrvDevGetAPic = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    GetPicSize: Byte; //照片尺寸大小 0=320x240  1=640x480  2-else
    CameraIndex: Byte; //摄像头号
    CheckSum: Byte; //校验
  end;
  PCmdSrvDevGetAPic = ^TCmdSrvDevGetAPic;
  //车机回复 通用应答

   //车机 -> 中心 车机已成功将照片上传  DEV_APICUPLOADED= $80
  TCmdDevSrvAPicUploaded = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    PicIndex: integer; //车机的照片序号
    CameraIndex: Byte; //摄像头号
    PicReson: Byte; //拍照原因
    DoneRet: Byte; //拍照结果　0-成功，1-照片缓冲区満2-摄像头故障3-传输失败
    CheckSum: Byte; //校验
  end;
  PCmdDevSrvAPicUploaded = ^TCmdDevSrvAPicUploaded;
  {中心给出通用应答}
  //网关->车机，设置车机主动拨打的监听电话号码  DEV_DOWNLISTENCALLNUM = $24;  //2007-9-24
  TCmdSrvDevDownListenCallNum = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    //CallNum: ＜20　ASCII码
    //CheckSum: Byte; //校验
  end;
  PCmdSrvDevDownListenCallNum = ^TCmdSrvDevDownListenCallNum;
  {车机回复通用命令应答}
  //网关->车机，发送通用命令
  TCmdSrcDevGenericCommand = packed record
    Size: Word;
    DevFactory: Byte; //车机厂商
    DevId: integer;
    ComVer: Byte; //协议版本
    CmdOrder: Word; //命令序号
    CmdFlag: Byte; //命令字
    //MinorCmdFlag : Byte; //次命令字
    //命令内容
    //CheckSum:Byte;//校验
  end;
  PCmdSrcDevGenericCommand = ^TCmdSrcDevGenericCommand;
  {车机回复通用命令应答}
  {车机回复通用应答}
  {*******************2006-5-30 增加WEB服务器与网关的通讯协议********}
  //Web服务器给网关命令的 通用命令头
  TCmdWebSrvHeader = packed record
    Header: Word; //协议头，固定为$FF FF
    Size: Word; //总长度
    DevId: integer; //去掉第一个数字1的SIM卡号码
    ComVer: Byte; //协议版本号=2
    CmdOrder: Word; //命令序号
    CmdFlag: Byte;
    //命令 内容：各命令长度不定
    //CheckSum
  end;
  PCmdWebSrvHeader = ^TCmdWebSrvHeader;
{****************************  其他命令结构定义   *****************************}
  (*****************调度服务器　与　网关的通讯　2006-11-17 SHA**** 20070709 sha.添加到此软件，合成处理2种订单*****)
  {网关->调度服务器　来抢单的车辆列表　及抢单成功的车辆列表 SRVDISPGRABDEVSANDGRABOKDEVS= $62;}

{*******************************业务服务器和客户端结构定义********************************}
  TMyPhoto = packed record
    Size: integer;
    PhotoReasonID: integer; //拍照原因
    GpsTime: TDateTime; //GPS时间
    Longitude: Double; //经度
    Latitude: Double; //纬度
    TakeBeginTime: TDateTime; //拍照开始时间
    TkeEndTime: TDateTime; //拍照结束时间
    PhotoSize: integer; //照片大小
    PhotoType: integer; //照片类型
    PicIndex: integer; //照片序号
    PhotoMeasure: integer; //照片尺寸
    CameraIndex: Byte;
    //Photo:TByteDynArray;     //照片内容,不定长大小
  end;
  PMyPhoto = ^TMyPhoto;


{******************************************************************************}
//设定线路编号
  TCmdSrvTermSetBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    BusLineID: Integer; //线路编号
  end;
  PCmdSrvTermSetBusLine = ^TCmdSrvTermSetBusLine;
  //网关回复
  TCmdTermSrvSetBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: byte;
  end;
  PCmdTermSrvSetBusLine = ^TCmdTermSrvSetBusLine;
//设定特殊区域
  TCmdSrvTermSetSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    AreaID: Integer; //区域编号

    Longitude1_Integer: word;
    Longitude1_Decimal: word;
    Latitude1_Integer: word;
    Latitude1_Decimal: word;

    Longitude2_Integer: word;
    Longitude2_Decimal: word;
    Latitude2_Integer: word;
    Latitude2_Decimal: word;

    Longitude3_Integer: word;
    Longitude3_Decimal: word;
    Latitude3_Integer: word;
    Latitude3_Decimal: word;

    Longitude4_Integer: word;
    Longitude4_Decimal: word;
    Latitude4_Integer: word;
    Latitude4_Decimal: word;

    Longitude5_Integer: word;
    Longitude5_Decimal: word;
    Latitude5_Integer: word;
    Latitude5_Decimal: word;

    Longitude6_Integer: word;
    Longitude6_Decimal: word;
    Latitude6_Integer: word;
    Latitude6_Decimal: word;

    Longitude7_Integer: word;
    Longitude7_Decimal: word;
    Latitude7_Integer: word;
    Latitude7_Decimal: word;

    Longitude8_Integer: word;
    Longitude8_Decimal: word;
    Latitude8_Integer: word;
    Latitude8_Decimal: word;
  end;
  PCmdSrvTermSetSpeaArea = ^TCmdSrvTermSetSpeaArea;
  //网关回复
  TCmdTermSrvSetSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: byte;
  end;
  PCmdTermSrvSetSpeaArea = ^TCmdTermSrvSetSpeaArea;
//读取特殊区域
  TCmdSrvTermReadSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    AreaID: Integer; //区域编号
  end;
  PCmdSrvTermReadSpeaArea = ^TCmdSrvTermReadSpeaArea;
  //网关回复
  TCmdTermSrvReadSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
    //区域信息  不定长
  end;
  PCmdTermSrvReadSpeaArea = ^TCmdTermSrvReadSpeaArea;
  //查询存储的线路
  TCmdSrvTermQueryBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
  end;
  PCmdSrvTermQueryBusLine = ^TCmdSrvTermQueryBusLine;
  //网关回复
  TCmdTermSrvQueryBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
    //线路信息  不定长
  end;
  PCmdTermSrvQueryBusLine = ^TCmdTermSrvQueryBusLine;
  //控制加入运营
  TCmdSrvTermSetJoinOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: integer;
    DevID: Integer;
    AutoFlag: Byte; //00自动，01手动
  end;
  PCmdSrvTermSetJoinOpera = ^TCmdSrvTermSetJoinOpera;
  //网关回复
  TCmdTermSrvSetJoinOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
  end;
  PCmdTermSrvSetJoinOpera = ^TCmdTermSrvSetJoinOpera;
  //控制退出运营
  TCmdSrvTermSetExitOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: integer;
    DevID: Integer;
    AutoFlag: Byte; //00自动，01手动
  end;
  PCmdSrvTermSetExitOpera = ^TCmdSrvTermSetExitOpera;
  //网关回复
  TCmdTermSrvSetExitOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
  end;
  PCmdTermSrvSetExitOpera = ^TCmdTermSrvSetExitOpera;
  //网络->客户端     SRVTERM_UPLOADTEXT
  TCmdTermSrvUploadText = packed record
    Size: word;
    Flag: Byte;
    DevId: integer;
    //上传的信息 不定长
  end;
  PCmdTermSrvUploadText = ^TCmdTermSrvUploadText;
  //上级上传非营运信息请求    SRVTERM_UPLOADNONSEC = $47;
  TCmdTermSrvRequestNonRun = packed record
    Size: Word;
    Flag: byte;
    DevId: integer;
    gpsData: array[0..71] of byte;
      //请求类型不定长
  end;
  PCmdTermSrvRequestNonRun = ^TCmdTermSrvRequestNonRun;
  //指定车辆进行非正查调度
  TCmdSrvTermDesignatedNonRun = packed record
    Size: Word;
    Flag: byte;
    CmdID: integer;
    DevId: integer;
    NonRunNo: integer;
    IsAllow: byte;
    //请求类型  不定长
  end;
  PCmdSrvTermDesignatedNonRun = ^TCmdSrvTermDesignatedNonRun;
  TCmdTermSrvCompleteRequestNonRun = packed record
    Size: word;
    Flag: byte;
    CmdId: integer;
    DevId: integer;
    RequestNo: integer;
    course: integer;
    //gpsData: array[0..71] of byte;
  end;
  PCmdTermSrvCompleteRequestNonRun = ^TCmdTermSrvCompleteRequestNonRun;
  //指定车辆临时调度
  TCmdSrvTemporaryRun = packed record
    Size: word;
    Flag: byte;
    CmdId: integer;
    DevId: integer;
    OnOrDown: Byte;
    StationNo: Byte;
    TemporaryRunType: Byte;
  end;
  PCmdSrvTemporaryRun = ^TCmdSrvTemporaryRun;
  TCmdSrvTemporaryRun_XM = packed record
    Size: word;
    Flag: byte;
    CmdId: integer;
    DevId: integer;
    //TemporaryData  不定长
  end;
  PCmdSrvTemporaryRun_XM = ^TCmdSrvTemporaryRun_XM;
  //BUS通用应答
  TCmdTermSrvAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: Byte;
  end;
  PCmdTermSrvAnswer = ^TCmdTermSrvAnswer;
  //===================================================================厦门
  TCmdSrvTermGpsDataHis_XM = packed record
    Size: word;
    Flag: Byte;
    DevId: integer;
    gpsType: byte; //GPS数据类型
    GpsTime: array[0..5] of Byte; // GPS时间
    IsLocat: Byte; //定位状态  0：定位 1：不定位
    Latitude: integer; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: integer; //经度 X 100 0000
    High: integer; //高度
    Speed: integer; //速度
    Dir: integer; //方向
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //保留状态
    runType: byte; //车次状态
    ISREPLACE: byte; //传输类型
    ISSTATION: byte; //进出站、或进出特殊区域
    STATION_ID: integer; //站点编号
    AREA_ID: integer; //特殊区域编号
  end;
  PCmdSrvTermGpsDataHis_XM = ^TCmdSrvTermGpsDataHis_XM;
  TGpsDataHis_XM = packed record
    Size: word;
    Flag: Byte;
    DevId: integer;
    gpsType: byte; //GPS数据类型
    GpsTime: TDateTime; // GPS时间
    IsLocat: Byte; //定位状态  0：定位 1：不定位
    Latitude: Double; //纬度 X 100 0000 如: 值32123456表示：32.123456度
    Longitude: Double; //经度 X 100 0000
    High: Double; //高度
    Speed: Integer; //速度
    Dir: Double; //方向
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //保留状态
    runType: byte; //车次状态
    ISREPLACE: byte; //传输类型
    ISSTATION: byte; //进出站、或进出特殊区域
    STATION_ID: integer; //站点编号
    AREA_ID: integer; //特殊区域编号
  end;
  PGpsDataHis_XM = ^TGpsDataHis_XM;

  //到离首末站点
  TIOSEStation = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer; //设备号
    OnOrDown: Byte; //1--上;2--下行
    GTime: array[0..5] of Byte; //到离站GPS时间
    STime: array[0..5] of Byte; //到离站服务器时间
    InOrOut: Byte; //1--进站；2－－出站；到离站标志
  end;
  PIOSEStation = ^TIOSEStation;

  //修改HR 090316
  TModifyPlanRunTime = packed record
    Size: Word;
    Flag: Byte;
    planID: Integer; //班次计划唯一ID
    busLineID: Integer; //线路ID
  end;
  PModifyPlanRunTime = ^TModifyPlanRunTime;

  //网关->客户端――通知客户端车辆进行开始包车
  TStartRentCar = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;
    RentCarPlanID: Integer;//包车计划ID
    StartTime: array[0..5] of Byte;//发车时间
  end;
  PStartRentCar = ^TStartRentCar;

  //网关->客户端――通知客户端车辆包车完成
  TEndRentCar = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;
    RentCarPlanID: Integer;//包车计划ID
    EndTime: array[0..5] of Byte;//完成时间
    Distance: Integer;//行驶里程
  end;
  PEndRentCar = ^TEndRentCar;

  //网关->客户端――通知客户端车辆当前状态
  TModifyDevStatus = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;
    CurrRunStatus: Byte;
  end;
  PModifyDevStatus = ^TModifyDevStatus;

  //客户端->网关――通知网关确定车机进入起始站或发车
  TIOStartStation = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer; //设备号
    OnOrDown: Byte; //1--上;2--下行
    GTime: array[0..5] of Byte; //到离站GPS时间
    STime: array[0..5] of Byte; //到离站服务器时间
    InOrOut: Byte; //1--进站；2－－出站；到离站标志
    RunNo: Integer;//班次号
    OutStart_Type: Byte;//0x00:GPS起始站 0x01:GPS非起始站 0x02:手动
    CurrentStationNo: Byte;//当前站点编号
    CurrentTotalCourse: array[0..2] of Byte;//当前累计里程(单位:公里)
    LineId: Integer;
  end;
  PIOStartStation = ^TIOStartStation;

  TInEndStation = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;//设备号
    OnOrDown: Byte; //1--上;2--下行
    GTime: array[0..5] of Byte; //到离站GPS时间
    STime: array[0..5] of Byte; //到离站服务器时间
    RunNo: Integer;//班次号
    InEnd_Type: Byte;//0x00:GPS起始站 0x01:GPS非起始站 0x02:手动
    RealCourse: Integer;//单位: 米
    StationNumPassed: Byte;
    RunCompleteRate: Integer;//班次完整率
    LineId: Integer;
  end;
  PInEndStation = ^TInEndStation;

  TStartOtherRun = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;            //设备号
    RequestNo: Integer;        //非营运号
    STime: array[0..5] of Byte;//开始时间
    //运营类型  不定长
  end;
  PStartOtherRun = ^TStartOtherRun;

  TEndOtherRun = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;                //设备号
    RequestNo: Integer;            //非营运号
    ETime: array[0..5] of Byte;    //结束时间
    RunCourse: Integer;             //实际运营里程
    LineId: Integer;
  end;
  PEndOtherRun = ^TEndOtherRun;

  TOtherRunRequest = packed record
    Size: Word;
    Flag: Byte;
    CmdNo: Integer;        //命令序号
    DevID: Integer;        //设备号
    OtherRunID: Integer;    //非营运号
    //非营运内容  不定长
    //累计里程 {3字节}
    //定位数据 {未升级的车机网关会在定位数据后加3个字节发，升级后的没有}
  end;
  POtherRunRequest = ^TOtherRunRequest;

  TChangeDevStatus = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;    //车机号
    OtherRunType: Byte;//非营运类型
  end;
  PChangeDevStatus = ^TChangeDevStatus;

  TRentCarStart = packed record
    Size: Word;
    Flag: Byte;
    CmdNo: Integer;             //命令序号
    DevId: Integer;             //车机编号
    RentCarType: Byte;          //包车类型 0：未知包车 1：固定包车 2：临时包车
    RentCarRunNo: Integer;      //包车班次号
    BusLineId: Integer;         //线路号
    STime: array[0..5] of Byte; //开始时间
    OtherRunId: Integer;        //非营运编号
  end;
  PRentCarStart = ^TRentCarStart;

  TRentCarEnd = packed record
    Size: Word;
    Flag: Byte;
    CmdNo: Integer;             //命令序号
    DevId: Integer;             //车机编号
    RentCarType: Byte;          //包车类型 0：未知包车 1：固定包车 2：临时包车
    RentCarRunNo: Integer;      //包车班次号
    BusLineId: Integer;         //线路号
    ETime: array[0..5] of Byte; //开始时间
    RunCourse: Integer;            //包车里程
    OtherRunId: Integer;        
  end;
  PRentCarEnd = ^TRentCarEnd;

  TModifyRentCarPlan = packed record
    Size: Word;
    Flag: Byte;
    RentCarPlanId: Integer;
    RentCarType: Byte;
    BusLineId: Integer;
  end;
  PModifyRentCarPlan = ^TModifyRentCarPlan;

  TRetToGateway = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    Ret: Byte;
  end;
  PRetToGateway = ^TRetToGateway;

  TRetToGateway_N = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    RetFlag: Byte;//应答命令
    Ret: Byte;
  end;
  PRetToGateway_N = ^TRetToGateway_N;

  //====================================JNGJ====================================
  TPlanChanged = packed record//监控通知调度班次变化
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    LineId: Integer;
    planId: Integer;//-1表示整条线路
  end;
  PPlanChanged = ^TPlanChanged;

  TNoticeBusNextRun_C2G = packed record//调度通知网关车辆执行哪一班计划
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId: Integer;
    PlanId: Integer;
    OnOrDown: Byte;
    StartTime: array[0..5] of Byte;
    Status: Byte; // 0：发车 1：取消发车
    MsgLen: Integer;
    //Msg: 不定长;
  end;
  PNoticeBusNextRun_C2G = ^TNoticeBusNextRun_C2G;

  TNoticeBusNextRun_G2C = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    StartTime: array[0..5] of Byte;
    LineId: Integer;
    PlanId: Integer;
    Status: Byte;//0:派单  1：取消下发未执行 2:取消已执行班次 3:强制车辆发车
    OnOrDown: Byte;//1 on  2 down
  end;
  PNoticeBusNextRun_G2C = ^TNoticeBusNextRun_G2C;

  TBusWaitForNextRun_C2G = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
  end;
  PBusWaitForNextRun_C2G = ^TBusWaitForNextRun_C2G;

  TBusExecuteNewRun_C2G = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId: Integer;
    PlanId: Integer;
    OnOrDown: Byte;
  end;
  PBusExecuteNewRun_C2G = ^TBusExecuteNewRun_C2G;

  TBusStartInfoToBoard_C2G = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    BoardId: Integer;
    LineCount: Integer;
    //LineNameLen: Integer;
    //LineName: string;
    //CarNoLen: Integer;
    //CarNo: string;
    //StartTimeLen: Integer;
    //StartTime: string;
  end;
  PBusStartInfoToBoard_C2G = ^TBusStartInfoToBoard_C2G;

  TControlBusRunStatus = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    Status: Byte;//0：控制加入运营 1：控制加油 5：控制包车 2：故障报修 4：其他 51：控制退出运营
  end;
  PControlBusRunStatus = ^TControlBusRunStatus;

  //上传检验卡，结构体内容同司机签到
  TUploadCheckCard = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    CheckerNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//累计里程
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PUploadCheckCard = ^TUploadCheckCard;

  //通知是否停止发送调度信息
  TNoticeIfDispatched = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    Status: Byte;//0:停止 1:启动
  end;
  PNoticeIfDispatched = ^TNoticeIfDispatched;

  //指定车辆驾驶员
  TNoticeDevDriver = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    DriverNo: array of Byte;
    LogInOrOut: Byte;//0：签到 1：签退
  end;
  PNoticeDevDriver = ^TNoticeDevDriver;

  TSpecialRentCar = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    RentCarRunTimeId: Integer;
    Status: Byte;
  end;
  PSpecialRentCar = ^TSpecialRentCar;

  //指定或取消车辆即到即走
  TLeaveImm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    Status: Byte;//1:指定 2:取消
  end;
  PLeaveImm = ^TLeaveImm;

  TNoticeNewPlanWhenLeaveImm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    PlanRunTimeId: Integer;
    LineId: Integer;
  end;
  PNoticeNewPlanWhenLeaveImm = ^TNoticeNewPlanWhenLeaveImm;

  //车机发车的准点误点(江宁公交中的准点误点不是以计划开始时间和实际开始时间来衡量的)
  TBusDelay = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    PlanRunTimeId: Integer;
    LineId: Integer;
    DelayType: Byte;//1：提前 2：推迟  目前江宁公交中的误点用2表示  2010-05-25
    DelayTime: Word;//误点时间         目前江宁公交中的误点时间为0  2010-05-25
  end;
  PBusDelay = ^TBusDelay;

  TUploadAlarmOverSpeed = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    AlarmSTime: array[0..5] of Byte;
    AlarmSLati: Integer;
    AlarmSLongi: Integer;
    AlarmETime: array[0..5] of Byte;
    AlarmELati: Integer;
    AlarmELongi: Integer;
    AlarmMaxSpeed: Byte;
    AlarmLimitedSpeed: Byte;
    AlarmAvgSpeed: Byte;
    AlarmAreaId: Word; 
  end;
  PUploadAlarmOverSpeed = ^TUploadAlarmOverSpeed;

  TCmdTermSrvSendSpecialRentPlan = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    RentCount: Integer;
  end;
 PCmdTermSrvSendSpecialRentPlan = ^TCmdTermSrvSendSpecialRentPlan;

  TSpecialRentCarInfo = packed record
    RentCarId: Integer;//包车ID
    RentCarName: array [0..29] of Byte;//包车名称
  end;
  PSpecialRentCarInfo = ^TSpecialRentCarInfo;

  //====================================JNGJ====================================
  {*************************************更改线路*************************************}
  TUploadModifyLine = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId:Integer;
    QyRq:array[0..5] of Byte;
  end;
  PUploadModifyLine = ^TUploadModifyLine;
  TModifyBusLineOK = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId:Integer;
    QyRq:array[0..5] of Byte;
  end;
  PModifyBusLineOK = ^TModifyBusLineOK;
  {*************************************更改线路*************************************}


  //指定车辆的驾驶员签到或签退 TERMSRV_APPOINTDRIVERLOGONOROFF = $B3;
  TCmdTermSrvAppointDriverLogOnOrOff = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer; //命令序号
    DevId: integer;
    DriverCardId: Integer; //司机卡内号
    DriverNo: array[0..9] of char; //司机工号
    DriverName: array[0..9] of char; //司机姓名
    LogType: Byte; //0：签到 1：签退
  end;

  //车机主动上传特约包车计划
  TCmdSrvTermDevUploadSpecialPlanId = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    RentPlanId: Integer;
  end;
  PCmdSrvTermDevUploadSpecialPlanId = ^TCmdSrvTermDevUploadSpecialPlanId;

  //指定车辆暂停或启用 派班
  TCmdTermSrvAppointPauseOrStartPaiBan = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer; //命令序号
    DevId: integer;
    PauseType: Byte; //0:停止 1：启动
  end;
  PCmdTermSrvAppointPauseOrStartPaiBan = ^TCmdTermSrvAppointPauseOrStartPaiBan;

{**************************整合公交、出租后的命令******************************}
  //公交出租命令头
  TBusTaxiCmdHead = packed record
    Size: Word;        //包长度
    Flag: Byte;        //命令字固定为$F1
    ExtendedFlag: Byte;//扩展命令字
    Reserved: Integer; //保留
    FactId: Byte;      //厂商
    CmdNo: Integer;    //命令序号
    DevId: Integer;    //设备号
  end;
  PBusTaxiCmdHead = ^TBusTaxiCmdHead;

  //定时开关发车公告牌显示屏
  TSwitchBoard = packed record
    Head: TBusTaxiCmdHead;
    OnOrOff: Byte;
  end;
  PSwitchBoard = ^TSwitchBoard;

  //通知司机在当前车辆当天已完成班次数
  TCmdTermSrvNoticeDriverRuninfoCount = packed record
    Head: TBusTaxiCmdHead;
    DriverRuninfoCount: Byte;
  end;

  TCmdDevIOPark = packed record
    Head: TBusTaxiCmdHead;
    BusParkNo: Integer;//停车场编号
    IOType: Byte;//7：起点回场 8：终点回场 9：离场到起点 10：离场到终点
  end;
  PCmdDevIOPark = ^TCmdDevIOPark;

  TCmdDevIOParkRequest = packed record
    Head: TBusTaxiCmdHead;
    OtherRunId: Integer;
    BusParkNo: Integer;//停车场编号
    IOType: Byte;//7：起点回场 8：终点回场 9：离场到起点 10：离场到终点
    TotalCourse: array[0..2] of Byte;
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdDevIOParkRequest = ^TCmdDevIOParkRequest;

  TCmdDevIOParkStart = packed record
    Head: TBusTaxiCmdHead;
    OtherRunId: Integer;
    STime: array[0..5] of Byte;
    BusParkNo: Integer;//停车场编号
    IOType: Byte;//7：起点回场 8：终点回场 9：离场到起点 10：离场到终点
  end;
  PCmdDevIOParkStart = ^TCmdDevIOParkStart;

  TCmdDevGetAd = packed record
    Head: TBusTaxiCmdHead;
    SNo: Integer;
    AdType: Byte;
    AdVer: array[0..6] of Byte;
  end;
  PCmdDevGetAd = ^TCmdDevGetAd;

  TCmdSendAdToDev = packed record
    Head: TBusTaxiCmdHead;
    SNo: Integer;
    CmdType: Byte;
    AdType: Byte;
    AdVer: array[0..6] of Byte;
    AdLen: shortint;
    //AdContent: string;
  end;
  PCmdSendAdToDev = ^TCmdSendAdToDev;

  TCmdDevAdChanged = packed record
    Head: TBusTaxiCmdHead;
    AdType: Byte;
  end;
  PCmdDevAdChanged = ^TCmdDevAdChanged;

  //刷卡处理
  TCmdSrvTermLoginOrOff = packed record
    Head: TBusTaxiCmdHead;
    CardNo: array[0..9] of Byte;//10字节ASCII码
    StewardNo: array[0..9] of Byte;//10字节ASCII码
    LogTime: array[0..5] of Byte;//BCD码格式的北京时间 YY-MM-DD HH:MM:SS
    UserId: Integer; //指定用户ID(车机主动上传默认为0)
    CardType: Byte;  //4：乘务员卡
    LogType: Byte;   //0：签到；1：签退
    GpsData: TCmdSrvTermGpsData_XM;//定位数据包
  end;
  PCmdSrvTermLoginOrOff = ^TCmdSrvTermLoginOrOff;

  //获取12个月的基础票价
  TCmdSrvTermGet12MonthPrice = packed record
    Head: TBusTaxiCmdHead;
    LineNo: Integer;//线路编号 车机上传的编号
  end;
  PCmdSrvTermGet12MonthPrice = ^TCmdSrvTermGet12MonthPrice;

  //发送12个月的基础票价
  TCmdTermSrvSend12MonthPrice = packed record
    Head: TBusTaxiCmdHead;
    LineNo: Integer;
    LineNo_IC: array[0..3] of Byte;
    CollectSNo: array[0..3] of Byte;
    MonthPrice: array[0..11] of Word;
  end;
  PCmdTermSrvSend12MonthPrice = ^TCmdTermSrvSend12MonthPrice;

  //获取阶梯票价
  TCmdSrvTermGetLadderPrice = packed record
    Head: TBusTaxiCmdHead;
    LineNo: Integer;//线路编号 车机上传的编号
  end;
  PCmdSrvTermGetLadderPrice = ^TCmdSrvTermGetLadderPrice;

  TCmdTermSrvSendLadderPrice = packed record
    Head: TBusTaxiCmdHead;
    //方案1长度	4
    //阶梯票价方案1	1+4*N	第1个字节 0:不启用；1：启用
    //每条记录4字节
    //上下行（1字节）
    //站点序号（1字节）
    //该站后续站点价格（2字节）以分为单位
    //阶梯票价方案1启用时间	6	BCD
    //方案2长度	4
    //阶梯票价方案2	1+4*N	第1个字节 0:不启用；1：启用
    //每条记录4字节
    //上下行（1字节）
    //站点序号（1字节）
    //该站后续站点价格（2字节）以分为单位
    //阶梯票价方案2启用时间	6	BCD
  end;
  PCmdTermSrvSendLadderPrice = ^TCmdTermSrvSendLadderPrice;

  TCmdTermSrvSendLadderPrice_NoData = packed record
    Head: TBusTaxiCmdHead;
    P1Len: Integer;
    P1Enable: Byte;
    P1EnableDate: array[0..5] of Byte;
    P2Len: Integer;
    P2Enable: Byte;
    P2EnableDate: array[0..5] of Byte;
  end;
  PCmdTermSrvSendLadderPrice_NoData = ^TCmdTermSrvSendLadderPrice_NoData;

{**************************整合公交、出租后的命令******************************}


function PtrAdd(p: pointer; offset: integer): pointer;

function CmdToStr(P: Pointer): string;

  {将BCD表示的无符号长整型32bit，转换成无符号长整型}
function BcdToLong(pB: PByte): Longword;
  {将BCD表示的16bit无符号整型转换成16bit无符号整型}
function BcdToWord(pB: PByte): Word;
  {将BCD表示的8bit无符号整型转换成8bit无符号整型}
function BcdToByte(bcd: Byte): Byte;

  {字节顺序转换}
function ByteOderConvert_Word(AValue: Word): Word;
function ByteOderConvert_Smallint(AValue: Smallint): Smallint;
  {字节顺序转换
  @param AValue:longword
  @return longword
  }
function ByteOderConvert_LongWord(AValue: Longword): Longword;
function GetCurrTime: string;

function GetEscapedBuf(srcBuf: array of Byte): TByteDynArray;//转义数据
function GetUnEscapedBuf(srcBuf: array of Byte): TByteDynArray;//获取转义前的数据
procedure initCmd(var cmdHead: TSTHead; terminalId:string; cmdId, cmdSNo: Word;
  var cmdEnd: TSTEnd; cmdMinSize: Integer);

implementation
uses
  Sysutils, DateUtils, uGloabVar;

{字节顺序转换,将本机的字节顺序(LITTLE_END)转成BIG_END
@param AValue:Word
@return Word
}

function ByteOderConvert_Word(AValue: Word): Word;
type
  TLongByte = packed record
    a, b: Byte;
  end;
var
  P: ^TLongByte;
  t: Byte;
begin
  P := @AValue;
  t := P^.a;
  P^.a := P^.b;
  P^.b := t;

  Result := AValue;
end;

function ByteOderConvert_Smallint(AValue: Smallint): Smallint;
type
  TLongByte = packed record
    a, b: Byte;
  end;
var
  P: ^TLongByte;
  t: Byte;
begin
  P := @AValue;
  t := P^.a;
  P^.a := P^.b;
  P^.b := t;

  Result := AValue;
end;

{字节顺序转换
@param AValue:longword
@return longword
}

function ByteOderConvert_LongWord(AValue: Longword): Longword;
type
  TLongByte = packed record
    a, b, c, d: Byte;
  end;
var
  P: ^TLongByte;
  t: Byte;
begin
  P := @AValue;
  t := P^.a;
  P^.a := P^.d;
  P^.d := t;

  t := P^.b;
  P^.b := P^.c;
  P^.c := t;

  Result := AValue;
end;
{
bcd中保存的是4个字节的浮点表示
"03201.831" 转换成用4个字节的bcd码表示的数 <br>
0x03  0x20  0x18  0x31                     <br>
将0x03  0x20  0x18  0x31 转成8个字节       <br>
 0 ，3，2，0, 1，8，3，1                   <br>
 然后拼成一个longword                      <br>
  (0*6000+3*600+2*60)*1000+
  (0*10000+1*1000+8*100+3*10+1)
 --------
 到客户端再计算时，再除以1000*60
 =32.0305167
}

function BcdToLong(pB: PByte): Longword;
var
  b: array[0..7] of Byte;
  i: integer;
begin
  for i := 0 to 3 do
  begin
    b[i * 2] := pB^ shr 4;
    b[i * 2 + 1] := pB^ and $0F;
    inc(pB);
  end;

  Result :=
    (b[0] * 6000 + b[1] * 600 + b[2] * 60) * 1000 +
    (b[3] * 10000 + b[4] * 1000 + b[5] * 100 + b[6] * 10 + b[7]);
end;

{
bcd中保存的是2个字节的整型表示
1204，可用来表示速度为120.4公里每小时
将其用两个字节的bcd码表示[0x12,0x04]
将0x12 0x04 转成4个字节
    1,2,0,4
 然后拼成一个浮点
 1*1000+2*100+0*10+4;
}

function BcdToWord(pB: PByte): Word;
var
  b: array[0..3] of Byte;
begin

  b[0] := pB^ shr 4;
  b[1] := pB^ and $0F;
  inc(pB);
  b[2] := pB^ shr 4;
  b[3] := pB^ and $0F;

  Result := b[0] * 1000 + b[1] * 100 + b[2] * 10 + b[3];
end;

function BcdToByte(bcd: Byte): Byte;
begin
  Result := (bcd shr 4) * 10 + (bcd and $0F);
end;

function GetEscapedBuf(srcBuf: array of Byte): TByteDynArray;
var
  dstBuf: TByteDynArray;
  i, j: Integer;
begin
  SetLength(dstBuf, 2 * Length(srcBuf));
  dstBuf[0] := CMD_START_FLAG;
  j := 1;
  for i := 1 to Length(srcBuf) - 2 do
  begin
    if srcBuf[i] = CMD_SPEC_FLAG_7E then
    begin
      dstBuf[j] := CMD_SPEC_FLAG_7D;
      dstBuf[j + 1] := $02;
      Inc(j, 2);
    end
    else if srcBuf[i] = CMD_SPEC_FLAG_7D then
    begin
      dstBuf[j] := CMD_SPEC_FLAG_7D;
      dstBuf[j + 1] := $01;
      Inc(j, 2);
    end
    else
    begin
      dstBuf[j] := srcBuf[i];
      Inc(j);
    end;
  end;
  dstBuf[j] := CMD_END_FLAG;
  SetLength(dstBuf, j + 1);
  Result := dstBuf;
end;

function GetUnEscapedBuf(srcBuf: array of Byte): TByteDynArray;//获取转义前的数据
var
  dstBuf: TByteDynArray;
  I: Integer;
  j: Integer;
begin
  j := 0;
  SetLength(dstBuf, length(srcBuf));
  i := 0;
  while i < length(srcBuf) do
  begin
    if srcBuf[I] = $7D then
    begin
      if srcBuf[I + 1] = $02 then
      begin
        dstBuf[j] := $7E;
        Inc(I);
      end
      else if srcBuf[I + 1] = $01 then
      begin
        dstBuf[j] := $7D;
        Inc(I);
      end
      else//按协议要求这步应该不会走到
      begin
        dstBuf[j] := srcBuf[I];
      end;
    end
    else
    begin
      dstBuf[j] := srcBuf[I];
    end;
    Inc(i);
    Inc(j);
  end;
  SetLength(dstBuf, j);
  Result := dstBuf;
end;

procedure initCmd(var cmdHead: TSTHead; terminalId:string; cmdId, cmdSNo: Word;
  var cmdEnd: TSTEnd; cmdMinSize: Integer);
var
  terminalIdBuf: TByteDynArray;
begin
  cmdHead.StartFlag := CMD_START_FLAG;
  cmdHead.CmdId := ByteOderConvert_Word(cmdId);
  cmdHead.ClientType := 0;

  terminalIdBuf := hexStrToByteBuf(getFixedLenStr(GlobalParam.TerminalId, 12, '0'), False);
  CopyMemory(@(cmdHead.TerminalId[0]), @terminalIdBuf[0], SizeOf(cmdHead.TerminalId));
  cmdHead.BodySize := ByteOderConvert_Word(cmdMinSize - SizeOf(TSTHead) - SizeOf(TSTEnd));
  cmdHead.CmdSNo := ByteOderConvert_Word(cmdSNo);
  cmdEnd.CheckSum := 0;
  cmdEnd.EndFlag := CMD_END_FLAG;
end;

function PtrAdd(p: pointer; offset: integer): pointer;
begin
  Result := Pointer(Integer(p) + offset);
end;

function TransCmdGpsData(var AOrg: TCmdSrvtermGpsdata; var ANew: TGpsData): Boolean;
  function GetGpsTime(AOrg: array of Byte): TDateTime;
  var
    year, mon, day, hour, min, sec: Word;
  begin
    //-------------------在设备刚登录时,在GPS天线坏或有故障，会收到全是0的数据
    if (AOrg[1] = 0) and (AOrg[2] = 0) and (AOrg[3] = 0) and (AOrg[4] = 0) and (AOrg[5] = 0) then
    begin
      Result := EncodeDate(2000, 1, 1) + EncodeTime(0, 0, 0, 0);
      exit;
    end;
    //====================================================
    year := 2000 + AOrg[0];
    mon := AOrg[1];
    day := AOrg[2];
    hour := AOrg[3];
    min := AOrg[4];
    sec := AOrg[5];
    try
      Result := EncodeDate(year, mon, day) + EncodeTime(hour, min, sec, 0);
    except
      Result := 0; // EncodeDate(2000,1,1)+ EncodeTime(0,0,0,0);
    end;
  end;
begin
  Result := True;
  try
    ANew.Size := SizeOf(ANew);
    ANew.Id := AOrg.DevId;
    ANew.Long := AOrg.Long / 1000 / 60;
    ANew.Lat := AOrg.Lat / 1000 / 60;
    ANew.GpsTime := GetGpsTime(AOrg.GpsTime);
    ANew.Speed := AOrg.Speed;
    ANew.Altitude := AOrg.Altitude;
    ANew.Angle := AOrg.Angle;
    ANew.IO := AOrg.Stat;
    ANew.IO := (ANew.IO shl 8) or AOrg.Switch;
  except
    Result := False;
  end;
end;

function GetCurrTime: string;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:nn:ss', Now);
end;

function CmdToStr(P: Pointer): string;
  function GetTERMSRV_COMMVER(P: Pointer): string;
  begin
    with PCmdTermsrvRegverData(P)^ do
      Result := '客户端注册通讯协议命令 ' + IntToStr(MajorVer) + '.' + IntToStr(MinorVer);
  end;

  function GetSRVTERM_COMMVER(P: Pointer): string;
  begin
    with PCmdSrvtermRegverData(P)^ do
      Result := '服务器响应注册通讯协议命令 ';
  end;

  function GetTERMSRV_REG(P: Pointer): string;
  begin
    with PCmdTermsrvRegUserData(P)^ do
      Result := '客户端注册,用户:' + IntToStr(UserID) + ',Password:******' + '客户端版本号 ' +
        IntToStr(MajorVer) + '.' + IntToStr(MinorVer);
  end;

  function GetSRVTERM_REG(P: Pointer): string;
  begin
    with PCmdSrvtermRegUserData(P)^ do
      Result := '服务器响应注册请求，' + IntToStr(PCmdSrvtermRegUserData(P)^.Ret);
  end;

  function GetTERMSRV_GETLASTPOS(P: Pointer): string;
  begin
    with PCmdTermsrvGetlastPosData(P)^ do
      Result := '客户端请求目标的最后位置，ID为' + IntToStr(PCmdTermsrvGetlastPosData(P)^.DevId);
  end;

  function GetSRVTERM_GETLASTPOS(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_GETSTAT(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_GETSTAT(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_GPSDATAV20(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_CALLDEV(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_CALLDEV(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_SWITCHCTRL(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_SWITCHCTRL(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_SENDDEVMSG(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_SENDMSG(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_PING(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_PING(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_NOTIFYSTAT(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_CANCELCMD(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_CANCELCMD(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_LASTGPSDATA(P: Pointer): string;
  begin

  end;

  function PtrAdd(P: Pointer; offset: integer): Pointer;
  begin
    Result := Pointer(integer(P) + offset);
  end;

begin
{
  case PByte(PtrAdd(P,2))^ of
    TERMSRV_COMMVER     :Result := GetTERMSRV_COMMVER(p)      ;//$01
    SRVTERM_COMMVER     :Result := GetSRVTERM_COMMVER(p)      ;//$81
    TERMSRV_REG         :Result := GetTERMSRV_REG(p)          ;//$02
    SRVTERM_REG         :Result := GetSRVTERM_REG(p)          ;//$82
    TERMSRV_GETLASTPOS  :Result := GetTERMSRV_GETLASTPOS(p)   ;//$03
    SRVTERM_GETLASTPOS  :Result := GetSRVTERM_GETLASTPOS(p)   ;//$83
    TERMSRV_GETDEVSTAT  :Result := GetTERMSRV_GETSTAT(p)      ;//$04
    SRVTERM_GETDEVSTAT  :Result := GetSRVTERM_GETSTAT(p)      ;//$84
    SRVTERM_GPSDATA     :Result := GetSRVTERM_GPSDATAV20(p)   ;//$85
    TERMSRV_CALLDEV     :Result := GetTERMSRV_CALLDEV(p)      ;//$06
    SRVTERM_CALLDEV     :Result := GetSRVTERM_CALLDEV(p)      ;//$86
    TERMSRV_SWCTRL      :Result := GetTERMSRV_SWITCHCTRL(p)   ;//$07
    SRVTERM_SWCTRL      :Result := GetSRVTERM_SWITCHCTRL(p)   ;//$87
    TERMSRV_SENDDEVMSG  :Result := GetTERMSRV_SENDDEVMSG(p)   ;//$08
    SRVTERM_SENDMSG     :Result := GetSRVTERM_SENDMSG(p)      ;//$89
    TERMSRV_PING        :Result := GetTERMSRV_PING(p)         ;//$0A
    SRVTERM_PING        :Result := GetSRVTERM_PING(p)         ;//$8A
    SRVTERM_NOTIFYMSG   :Result := GetSRVTERM_NOTIFYSTAT(p)   ;//$8B
    TERMSRV_CANCELCMD   :Result := GetTERMSRV_CANCELCMD(p)    ;//$0C
    SRVTERM_CANCELCMD   :Result := GetSRVTERM_CANCELCMD(p)    ;//$8C
    SRVTERM_LASTGPSDATA :Result := GetSRVTERM_LASTGPSDATA(p)  ;//$8D
  else
    Result := '未知命令';
  end;
 }
end;

end.

