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

  MODULE_STATUS_UNKNOWN = $00;//未知
  MODULE_STATUS_OK      = $01;//正常
  MODULE_STATUS_FAULT   = $02;//故障
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
    CmdEnd: TSTEnd;
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

function PtrAdd(p: pointer; offset: integer): pointer;

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
//procedure initCmd(var cmdHead: TSTHead; terminalId:string; cmdId, cmdSNo: Word;
//  var cmdEnd: TSTEnd; cmdMinSize: Integer);

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

//procedure initCmd(var cmdHead: TSTHead; cmdId: Word; var cmdEnd: TSTEnd;
//  cmdMinSize: Integer);
//var
//  terminalIdBuf: TByteDynArray;
//  cmdSNo: Word;
//begin
//  cmdSNo := getmx
//  cmdHead.StartFlag := CMD_START_FLAG;
//  cmdHead.CmdId := ByteOderConvert_Word(cmdId);
//  cmdHead.ClientType := 0;
//
//  terminalIdBuf := hexStrToByteBuf(getFixedLenStr(GlobalParam.TerminalId, 12, '0'), False);
//  CopyMemory(@(cmdHead.TerminalId[0]), @terminalIdBuf[0], SizeOf(cmdHead.TerminalId));
//  cmdHead.BodySize := ByteOderConvert_Word(cmdMinSize - SizeOf(TSTHead) - SizeOf(TSTEnd));
//  cmdHead.CmdSNo := ByteOderConvert_Word(cmdSNo);
//  cmdEnd.CheckSum := 0;
//  cmdEnd.EndFlag := CMD_END_FLAG;
//end;

function PtrAdd(p: pointer; offset: integer): pointer;
begin
  Result := Pointer(Integer(p) + offset);
end;

function GetCurrTime: string;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:nn:ss', Now);
end;


end.

