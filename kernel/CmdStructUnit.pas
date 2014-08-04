{-------------------------------------------------------------------------------
  ����:      JADIC
  ����:      2014-07-01
  ��������:  ͨѶ�ṹ����
-------------------------------------------------------------------------------}

unit CmdStructUnit;

interface
uses
  Windows, winsock, Types;

const
  VER = $0100;

{******************************�ն˷���������******************************}
  C2S_TYRET                  = $0001;//�ն�ͨ��Ӧ��
  C2S_HEARTBEAT              = $0002;//�ն�����
  C2S_LOGIN                  = $0003;//�ն�ע��
  C2S_TERMINAL_MODULE_STATUS = $0004;//�ն�ģ��״̬�㱨
  C2S_GET_MAC2               = $0005;//��ȡMAC2
{******************************�ն˷���������******************************}

{*****************************����˷���������*****************************}
  S2C_TYRET        = $7001;//ƽ̨ͨ��Ӧ��
  S2C_LOGIN_RSP    = $7003;//�ն�ע��Ӧ��
  S2C_GET_MAC2_RSP = $7005;//��ȡmac2Ӧ��
{*****************************����˷���������*****************************}
{*********************************��������*********************************}
  CMD_START_FLAG = $7E;
  CMD_END_FLAG = $7E;

  CMD_SPEC_FLAG_7E = $7E;
  CMD_SPEC_FLAG_7D = $7D;

  MODULE_STATUS_UNKNOWN = $00;//δ֪
  MODULE_STATUS_OK      = $01;//����
  MODULE_STATUS_FAULT   = $02;//����
{*********************************��������*********************************}
type
  {
    �����ն˵�ͨ��ͷ
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
    �����ն˵�ͨ��β
  }
  TSTEnd = packed record
    CheckSum: Byte;
    EndFlag: Byte;
  end;
  PSTEnd = ^TSTEnd;
{******************************�ն˷�������******************************}
  //�ն�ͨ��Ӧ��
  TCmdTYRetC2S = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    CmdIdRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdTYRetC2S = ^TCmdTYRetC2S;

  //�ն�����
  TCmdHeartbeatC2S = packed record
    CmdHead: TSTHead;
    CmdEnd: TSTEnd;
  end;
  PCmdHeartbeatC2S = ^TCmdHeartbeatC2S;

  //�ն�ע��
  TCmdLoginC2S = packed record
    CmdHead: TSTHead;
    Ver: Word;
    CmdEnd: TSTEnd;
  end;
  PCmdLoginC2S = ^TCmdLoginC2S;

  //�ն�ģ��״̬�㱨
  {
    ģ��1:���񿨶�дģ��
    ģ��2:�ֽ�ģ��
    ģ��3:����ģ��
    ģ��4:��ӡģ��
    ģ��5:���֤��ȡģ��
    ģ��6:�������ģ��
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

  //��ȡmac2��Ϣ
  TCmdGetMac2ForChargeC2S = packed record
    CmdHead: TSTHead;
    OperType: Byte;
    CardNo: array[0..7] of Byte;
    ASN: array[0..9] of Byte;
    FakeRandom: array[0..3] of Byte;//α�����
    CardTradeNo: array[0..1] of Byte;//
    CardOldBalance: LongWord;
    ChargeAmount: LongWord;//��ֵ��� (��λ��)
    Mac1: array[0..3] of Byte;//mac1
    ChargeDate: array[0..3] of Byte;//��ֵʱ�� BCD 20 14 07 20 14 45 23
    ChargeTime: array[0..2] of Byte;//
    CmdEnd: TSTEnd;
  end;
  PCmdGetMac2ForChargeC2S = ^TCmdGetMac2ForChargeC2S;
{******************************�ն˷�������******************************}


{*****************************����˷�������*****************************}
  //ƽ̨ͨ��Ӧ��
  TCmdTYRetS2C = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    CmdIdRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdTYRetS2C = ^TCmdTYRetS2C;

  //�ն�ע��Ӧ��
  TCmdLoginRspS2C = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdLoginRspS2C = ^TCmdLoginRspS2C;

  //��ȡmac2��ϢӦ��
  TCmdGetMac2ForChargeS2C = packed record
    CmdHead: TSTHead;
    Ret: Byte;//��ȡ���  1:�ɹ�  ����:��Ч
    Mac2: array[0..3] of Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdGetMac2ForChargeS2C = ^TCmdGetMac2ForChargeS2C;
{*****************************����˷�������*****************************}

function PtrAdd(p: pointer; offset: integer): pointer;

  {��BCD��ʾ���޷��ų�����32bit��ת�����޷��ų�����}
function BcdToLong(pB: PByte): Longword;
  {��BCD��ʾ��16bit�޷�������ת����16bit�޷�������}
function BcdToWord(pB: PByte): Word;
  {��BCD��ʾ��8bit�޷�������ת����8bit�޷�������}
function BcdToByte(bcd: Byte): Byte;

  {�ֽ�˳��ת��}
function ByteOderConvert_Word(AValue: Word): Word;
function ByteOderConvert_Smallint(AValue: Smallint): Smallint;
  {�ֽ�˳��ת��
  @param AValue:longword
  @return longword
  }
function ByteOderConvert_LongWord(AValue: Longword): Longword;
function GetCurrTime: string;

function GetEscapedBuf(srcBuf: array of Byte): TByteDynArray;//ת������
function GetUnEscapedBuf(srcBuf: array of Byte): TByteDynArray;//��ȡת��ǰ������
//procedure initCmd(var cmdHead: TSTHead; terminalId:string; cmdId, cmdSNo: Word;
//  var cmdEnd: TSTEnd; cmdMinSize: Integer);

implementation
uses
  Sysutils, DateUtils, uGloabVar;

{�ֽ�˳��ת��,���������ֽ�˳��(LITTLE_END)ת��BIG_END
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

{�ֽ�˳��ת��
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
bcd�б������4���ֽڵĸ����ʾ
"03201.831" ת������4���ֽڵ�bcd���ʾ���� <br>
0x03  0x20  0x18  0x31                     <br>
��0x03  0x20  0x18  0x31 ת��8���ֽ�       <br>
 0 ��3��2��0, 1��8��3��1                   <br>
 Ȼ��ƴ��һ��longword                      <br>
  (0*6000+3*600+2*60)*1000+
  (0*10000+1*1000+8*100+3*10+1)
 --------
 ���ͻ����ټ���ʱ���ٳ���1000*60
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
bcd�б������2���ֽڵ����ͱ�ʾ
1204����������ʾ�ٶ�Ϊ120.4����ÿСʱ
�����������ֽڵ�bcd���ʾ[0x12,0x04]
��0x12 0x04 ת��4���ֽ�
    1,2,0,4
 Ȼ��ƴ��һ������
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

function GetUnEscapedBuf(srcBuf: array of Byte): TByteDynArray;//��ȡת��ǰ������
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
      else//��Э��Ҫ���ⲽӦ�ò����ߵ�
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

