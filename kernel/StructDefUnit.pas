{*结构及常量定义}
unit StructDefUnit;

interface
const
  {*空闲，表明客户端处于等待接听电话状态}
  CLIENT_STATE_IDLE = 0; //
  {*接电话，客户端正在与外线通话中}
  CLIENT_STATE_BUSY = 1; //
  {*准备接电话，已向客户端振铃，等待摘机}
  CLIENT_STATE_READY = 2; //
  {*客户端暂时停止接听电话，客户端暂时不接听电话，该状态下，服务器将不向该客户端分配电话}
  CLIENT_STATE_PAUSE = 3; //

  {*调度坐席}
  CLIENT_TYPE_SCHEDULE = 0; //
  {*投诉客户端}
  CLIENT_TYPE_ACCUSE = 1; //


  {*客户端注册或改变状态命令标志}
  CMD_TS_REGISTER = $00;
  {*服务器响应客户端注册或改变状态命令标志}
  CMD_ST_REGISTER = $80;
  {*服务器通知客户端来电命令标志，客户端摘机后，接通外线会收到这个命令}
  CMD_ST_CALLIN = $01;
  {*保留未用}
  CMD_TS_CALLIN = $81;
  {*用户通道的事件，客户端的内线通道状态发生变化后收到此命令，事件代码定义见下以USER_EVENT_开头的常量定义}
  CMD_ST_USERCHANNEL_EVENT = $02;
  {*客户端数量发生变化后收到的命令，里面包含了各种状态客户端的当前数量}
  CMD_ST_CLIENT_COUNT_CHANGE = $03;
  {*客户端要求抢接正在等待的电话，当有外线等待接听时，客户端主动要求抢接电话}
  CMD_TS_SWITCH_TO_ME = $84;
  {*客户端通知服务器来电类型不对}
  CMD_TS_ERROR_CALLTYPE = $85;
  {*客户端要求 进行三方通话--拨打司机}
  CMD_TS_CALLTODRIVER = $06;
  {*电话服务器返回，拨打司机电话的结果}
  CMD_ST_CALLTODRIVER = $86;

  {*用户接通外线电话，用户摘机与外线接通后发生}
  USER_EVENT_TALKWITH = 0;
  {*用户自行摘机,非服务器预期的}
  USER_EVENT_PICKUP = 1;
  {*服务器分配给用户等待接听的外线，用户通道的电话开始响铃}
  USER_EVENT_RING = 2;
  {*用户还未摘机接听外线电话，等待接通的外线已挂断}
  USER_EVENT_WAIT_EXT_HANGUP = 3;
  {*用户正在与外线通话中,外线尚未挂机，用户首先挂机}
  USER_EVENT_TALK_HANGUP = 4;
  {*用户正在与外线通话中,外线首先挂机}
  USER_EVENT_TALK_EXTHANGUP = 5;
  {*用户与外线通话结束,外线挂机后,用户内线再挂机}
  USER_EVENT_TALK_FINISH_HANGUP = 6;
  {*服务器分配给用户的电话，在振铃超过N（3）声后，用户仍未接听电话,电话已被重新排队}
  USER_EVENT_WAIT_TIMEOUT = 7;
  {*用户在自行摘机后再挂机,非服务器预期的}
  USER_EVENT_HANGUP = 8;
  {*由于其它用户执行了抢接命令，分配给该用户的电话被其它客户端抢接了}
  USER_EVENT_STOP = 9;
  {*内部通话已结束，请对方挂电话}
  USER_EVENT_INNERTALKOVER = 10;

  //拨打外线通道，返回的结果
  {*没有空闲外线通道}
  CALL_DRIVER_NOIDLELINE = 0;
  {*错误的电话号码}
  CALL_DRIVER_ERRTELLNUM = 1;
  {*对方忙或长时间无人接听}
  CALL_DRIVER_NOLISTEN_OR_BUSY = 2;
  {*对方已摘机，进入三方通话}
  CALL_DRIVER_THIRDTALKING = 3;
type
  {*@abstract客户端数量结构
  客户端数量结构@html(<br/>)
  Idle 空闲数量@html(<br/>)
  Pause 暂停工作数量@html(<br/>)
  Ready 准备接听电话数量@html(<br/>)
  Busy 正在接听电话数量@html(<br/>)
  }
  TClientCountData = packed record
    Total: Integer;
    Idle: Integer;
    Pause: Integer;
    Ready: Integer;
    Busy: Integer;
  end;

  {*TCmdTSRegisterData的指针定义}
  PCmdTSRegisterData = ^TCmdTSRegisterData;

  {*@abstract客户端到服务器的注册数据
  客户端到服务器的注册数据@html(<br/>)
  Size 长度
  Flag 命令标志，应当为CMD_TS_REGISTER @html(<br/>)
  UserChannelNo 客户端的通道号@html(<br/>)
  UserState 客户端的状态，改变状态时有效@html(<br/>)
  UserType 客户端的类型}
  TCmdTSRegisterData = packed record
    {*长度}
    Size: Word;
    {*命令标志,应当为}
    Flag: Byte;
    {客户端的通道号}
    UserChannelNo: Byte;
    {*客户端申请的状态,改变状态时有效}
    UserState: Byte;
    {*客户端类型,投诉或调度}
    UserType: Byte;
  end;
  {*TCmdSTRegisterData的指针定义}
  PCmdSTRegisterData = ^TCmdSTRegisterData;
  {*@abstract服务器响应客户端的注册数据
  服务器响应客户端的注册数据@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志 应当为CMD_ST_REGISTER @html(<br/>)
  Ret 返回值@html(<br/>)
  State 客户端应当具有的状态}
  TCmdSTRegisterData = packed record
    Size: Word;
    Flag: Byte;
    Ret: Byte; //0 成功 1 通道号不存在 2 通道号已占用，3 允许改变状态 4 不允许改变状态 如果返回1,2，服务端将会断开连接
    State: Integer; //客户端的状态 如果连接未断开,此状态就是客户端当前的状态
  end;

  {*TCmdSTCallInData的指针定义}
  PCmdSTCallInData = ^TCmdSTCallInData;
  {*@abstract服务器来电信息
  服务器收到来电信息发到客户端的命令@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志 应当为CMD_ST_CALLIN @html(<br/>)
  CallNo 来电号码 @html(<br/>)
  CallID 来电记录ID}
  TCmdSTCallInData = packed record
    Size: Word;
    Flag: Byte;
    CallNo: string[20];
    CallID: Integer;
  end;

  {*TCmdTSCallInData的指针定义}
  PCmdTSCallInData = ^TCmdTSCallInData;
  {*@abstract保留未用
  客户端来电信息返回命令定义,暂时没用}
  TCmdTSCallInData = packed record
    Size: Word;
    Flag: Byte;
    Ret: Integer; //0 收到 服务器端在指定的时间内未收到，则重发
  end;
  {*@abstract当客户端注册的用户通道发生事件时，服务器通知客户端，其注册的用户通道的事件
  当客户端注册的用户通道发生事件时，服务器通知客户端，其注册的用户通道的事件@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志 应当为CMD_ST_USERCHANNEL_EVENT@html(<br/>)
  Event 发生的事件代码}
  TCmdSTUserChannelEventData = packed record
    Size: Word;
    Flag: Byte;
    Event: Byte;
  end;
  {*TCmdSTUserChannelEventData的指针定义}
  PCmdSTUserChannelEventData = ^TCmdSTUserChannelEventData;
  {*@abstract当在服务器上客户端的数量发生变化时,服务器通知客户端的命令
  当在服务器上客户端的数量发生变化时,服务器通知客户端的命令@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志 应当为CMD_ST_CLIENT_COUNT_CHANGE@html(<br/>)
  Client 客户端的情况@html(<br/>)
  }
  TCmdSTClientCountChangeData = packed record
    Size: Word;
    Flag: Byte;
    Client: TClientCountData;
  end;
  {*TCmdSTClientCountChangeData的指针定义}
  PCmdSTClientCountChangeData = ^TCmdSTClientCountChangeData;
  {*@abstract客户端需要抢接正在等待的电话
  客户端需要抢接正在等待的电话@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志}
  TCmdTSSwitchToMeData = packed record
    Size: Word;
    Flag: Byte;
  end;
  {*TCmdTSSwitchToMeData的指针定义}
  PCmdTSSwitchToMeData = ^TCmdTSSwitchToMeData;
  {*@abstract客户端通知服务器当前的电话类型错误，退回服务器重新排队
  客户端通知服务器当前的电话类型错误，退回服务器重新排队@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志@html(<br/>)
  CallType: 电话的正确类型 0 表示是叫车电话 1 表示是投诉电话
  }
  TCmdTSErrorCalLType = packed record
    Size: Word;
    Flag: Byte;
    CallType: Integer;
  end;
  {*TCmdTSErrorCalLType的指针定义}
  PCmdTSErrorCalLType = ^TCmdTSErrorCalLType;

  {*@abstract客户端要求 进行三方通话--要求电话服务器去拨打司机
  客户端要求 进行三方通话--要求电话服务器去拨打司机@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志 CMD_TS_CALLTODRIVER = $06 @html(<br/>)
  DriverTellNum 司机号码 @html(<br/>)}
  TCmdTSCallToDriver = packed record
    Size: Word;
    Flag: Byte;
    DriverTellNum: string[20];
  end;
  {*TCmdTSCallToDriver的指针定义}
  PCmdTSCallToDriver = ^TCmdTSCallToDriver;
  {*@abstract电话服务器返回，拨打司机电话的结果
  电话服务器返回，拨打司机电话的结果@html(<br/>)
  Size 长度@html(<br/>)
  Flag 命令标志 CMD_ST_CALLTODRIVER = $86; @html(<br/>)}
  TCmdSTCallToDriverRet = packed record
    Size: Word;
    Flag: Byte;
    Ret: Byte; //查看本单元中 以CALL_DRIVER开头的定义
  end;
  {*TCmdSTCallToDriverRet的指针定义}
  PCmdSTCallToDriverRet = ^TCmdSTCallToDriverRet;

{*获得客户端状态描述}
function GetClientStateDesc(AState: Integer): string;
{*获得用户通道事件描述}
function GetUserEventDesc(AEvent: Integer): string;
implementation

function GetClientStateDesc(AState: Integer): string;
begin
  case AState of
    CLIENT_STATE_IDLE: Result := '空闲';
    CLIENT_STATE_BUSY: Result := '繁忙';
    CLIENT_STATE_READY: Result := '准备';
    CLIENT_STATE_PAUSE: Result := '暂停';
  else
    Result := '未知状态';
  end;
end;

function GetUserEventDesc(AEvent: Integer): string;
begin
  case AEvent of
    USER_EVENT_TALKWITH: Result := '用户接通外线电话';
    USER_EVENT_PICKUP: Result := '用户摘机,非服务器预期的';
    USER_EVENT_RING: Result := '用户通道的电话开始响铃';
    USER_EVENT_WAIT_EXT_HANGUP: Result := '等待接通的外线已挂断';
    USER_EVENT_TALK_HANGUP: Result := '正在通话中,用户首先挂机';
    USER_EVENT_TALK_EXTHANGUP: Result := '正在通话中,外线首先挂机';
    USER_EVENT_TALK_FINISH_HANGUP: Result := '通话结束,外线挂机后,内线挂机';
    USER_EVENT_WAIT_TIMEOUT: Result := '用户超进未接听电话,电话已被重新排队';
    USER_EVENT_HANGUP: Result := '用户挂机,非服务器预期的';
    USER_EVENT_STOP: Result := '用户电话被抢接';
    USER_EVENT_INNERTALKOVER: Result := '内部通话已结束，请对方通道挂电话';
  else
    Result := '未知';
  end;
end;

end.
