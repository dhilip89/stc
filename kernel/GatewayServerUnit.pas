unit GatewayServerUnit;

interface
uses
  CmdStructUnit, Windows, Winsock, extctrls, sysutils, ScktCompUnit, math,
  ConstDefineUnit, IntegerListUnit, ScktComp, Types, BusinessServerUnit,
  classes, SystemLog, SyncObjs;

const
  SAVE_CMD_COUNT = 1000; //保存多少条最近执行的命令信息
  CMD_RESEND_INTERVAL = 10;//命令重发间隔

type

  TOnGetMac2 = procedure (ret: Byte; mac2, tranSNo, errTip: ansistring) of object;
  TOnChargeDetailRsp = procedure(ret: Byte; recordId: Int64) of object;
  TOnRefundRsp = procedure(ret: Byte; recordId: LongWord) of object;
  TOnChargeCardCheckRsp = procedure(ret: Byte; amount:Integer) of object;
  TOnQueryQFTBalanceRsp = procedure(ret: Byte; amount:Integer) of object;
  TOnModifyZHBPassRsp = procedure(ret:Byte) of object;
  TOnLoginStatusChanged = procedure(loginStatus: Byte) of object;
  TOnGetCityCardType = procedure(ret: Byte) of object;

  TCmdInfo = record //命令信息
    Id: integer; //命令流水号
    Flag: integer; //这是什么命令;
    DevId: integer; //车机ID
    State: Byte; //0
    LastSendTime: Tdatetime; //发出时间
    Content: TByteDynArray; //命令体的内容
    IsNeedPersistence: Boolean;//是否需要持久化
    ResendCount: Byte;//命令管理器中定时500ms检查一次可以重发的命令，当checkcount=4时可以重发 保证在2~3秒内下发
  end;
  PCmdInfo = ^TCmdInfo;

  //-------------命令管理器
  TCmdManage = class
  private
    FList: TIntegerList;
    FMax_count: integer;
    FTimer: TTimer;
    function GetCount: integer;
    function GetItems(Index: Integer): PCmdInfo;
    procedure SetMax_count(const Value: integer);
    procedure FTimerTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(const ACmdID: Integer): PCmdInfo; //--添加一个命令
    function Find(const ACmdID: Integer): PCmdInfo; //  寻找一个命令
    procedure Delete(const ACmdID: Integer); //  删除一个命令
    procedure ClearCmd; //清除所有命令}
    property count: integer read GetCount; //---命令的条数
    property Max_count: integer read FMax_count write SetMax_count; //----命令的最大条数;
    property Items[Index: Integer]: PCmdInfo read GetItems; //======根据索引获得  信息
  end;

  TGateWayServerCom = class
  private
    FSocket: TClientSocketThread;
    FActive: Boolean;
    FAutoLogin: Boolean;
    FPort: Integer;
    FAddress: string;
    FUserPass: string;
    FUserId: Integer;
    FHost: string;
    FMaxCmdSNo: Word;
    FReadBuf: TSocketBuffer;
    FTimer: TTimer;
    FLog: TSystemLog;

    FReadLock: TCriticalSection;
    function PtrAdd(p: pointer; offset: integer): pointer;

    procedure SetActive(const Value: Boolean);
    procedure SetAddress(const Value: string);
    procedure SetAutoLogin(const Value: Boolean);
    procedure SetHost(const Value: string);
    procedure SetPort(const Value: Integer);
    procedure SetUserPass(const Value: string);

    procedure FTimerTimer(Sender: TObject);
    procedure SetUserId(const Value: Integer);
    function GetActive: Boolean;
    function isActive: boolean;
    procedure LockRead;
    procedure UnLockRead;
  private
    FOnGetMac2: TOnGetMac2;
    FOnChargeDetailRsp: TOnChargeDetailRsp;
    FOnRefundRsp: TOnRefundRsp;
    FOnChargeCardCheckRsp: TOnChargeCardCheckRsp;
    FOnQueryQFTBalanceRsp: TOnQueryQFTBalanceRsp;
    FOnModifyZHBPassRsp: TOnModifyZHBPassRsp;
    FLoginStatus: Byte;
    FOnLoginStatusChanged: TOnLoginStatusChanged;
    FOnGetCityCardType: TOnGetCityCardType;
    procedure FSocketSocketEvent(Sender: TObject; Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
    procedure FSockerWriteBufferOverflow(Sender: TObject);

    procedure dealCmdTYRet(buf: array of Byte);
    procedure dealCmdLoginRsp(buf: array of Byte);
    procedure dealCmdGetMac2Rsp(buf: array of Byte);
    procedure dealCmdChargeDetailRsp(buf: array of Byte);
    procedure dealCmdRefundRsp(buf: array of Byte);
    procedure dealCmdChargeCardCheckRsp(buf: array of Byte);
    procedure dealCmdQueryQFTBalanceRsp(buf: array of Byte);
    procedure dealCmdModifyZHBPassRsp(buf: array of Byte);
    procedure dealCmdCheckCityCardType(buf: array of Byte);
    procedure dealCmdEnableStatusChanged(buf: array of Byte);
    procedure dealCmdAddCashBoxAmount(buf: array of Byte);
    procedure dealCmdGetServerRsp(buf: array of Byte);

    procedure initCmd(var cmdHead: TSTHead; cmdId: Word; var cmdEnd: TSTEnd; cmdMinSize: Integer);

    procedure AddCmdToList(cmdHead: TSTHead; cmdData: TByteDynArray; isNeedPersistence: Boolean = false);
    procedure AddCmdVoidToList(cmdHead: TSTHead; var cmd; cmdSize: Integer; isNeedPersistence: Boolean = false);
    procedure DeleteCmdFromList(cmdHead: TSTHead);

    function LoginToServer: Boolean;
    procedure SetOnGetMac2(const Value: TOnGetMac2);
    procedure SetOnChargeDetailRsp(const Value: TOnChargeDetailRsp);
    procedure SetOnRefundRsp(const Value: TOnRefundRsp);
    procedure SetOnChargeCardCheckRsp(const Value: TOnChargeCardCheckRsp);
    procedure SetOnQueryQFTBalanceRsp(const Value: TOnQueryQFTBalanceRsp);
    procedure SetOnModifyZHBPassRsp(const Value: TOnModifyZHBPassRsp);
    procedure SetOnLoginStatusChanged(const Value: TOnLoginStatusChanged);
    procedure SetOnGetCityCardType(const Value: TOnGetCityCardType);
  protected
    function DirectSend(var buf; ABufSize: Integer): Boolean; //调用内部的发送函数直接发送数据
    function GetMaxCmdSNo: Word;
    procedure DealReceiveData; virtual; //处理 接收到的服务器数据,这里主要是分检工作
    procedure resendData(buf: TByteDynArray);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SendHeartbeat;
    procedure SendCmdGetMac2(cardNo, password, asn, CardTradeNo: array of Byte;
                            OperType: Byte; OldBalance, chargeAmount: Integer;
                            chargeTime, fakeRandom, mac1: array of Byte; status: Byte);
    procedure SendCmdUploadModuleStatus(moduleStatus: array of Byte);
    procedure SendCmdChargeDetail(cmd: TCmdChargeDetailC2S);
    procedure SendCmdRefund(cmd: TCmdRefundC2S);
    procedure SendCmdChargeCardCheck(cityCardNo, password: AnsiString);
    procedure SendCmdQueryQFTBalance(cityCardNo, password: AnsiString);
    procedure SendCmdModifyZHBPass(oldPass, newPass: AnsiString;
                cardNo, asn, CardTradeNo: array of Byte; OldBalance: Integer;
                chargeTime, fakeRandom, mac1: array of Byte);
    procedure SendCmdCheckCityCardType(cityCardNo: AnsiString);
    procedure SendCmdClearCashBox(cashAmount: Integer);
    procedure SendCmdAddCashBoxAmount(amountAdd: Integer);
    procedure SendCmdOperLog(operType: Byte);
    procedure SendCmdGetServerTime();

    procedure SetFTimerEnabled(enabled: Boolean);

    property Host: string read FHost write SetHost; // Server Host 优先级高}
    property Address: string read FAddress write SetAddress; //Server Address IP ADDRESS
    property Port: Integer read FPort write SetPort;
    property UserId: Integer read FUserId write SetUserId;
    property UserPass: string read FUserPass write SetUserPass; //Register User Password
    property Active: Boolean read GetActive write SetActive; // Active表示了和服务器的连接状态
    property AutoLogin: Boolean read FAutoLogin write SetAutoLogin; // 如果和服务器断开是否自动重新登录}
    property Socket: TClientSocketThread read FSocket;

    property LoginStatus: Byte read FLoginStatus;

    property OnGetMac2: TOnGetMac2 read FOnGetMac2 write SetOnGetMac2;
    property OnChargeDetailRsp: TOnChargeDetailRsp read FOnChargeDetailRsp write SetOnChargeDetailRsp;
    property OnRefundRsp: TOnRefundRsp read FOnRefundRsp write SetOnRefundRsp;
    property OnChargeCardCheckRsp: TOnChargeCardCheckRsp read FOnChargeCardCheckRsp write SetOnChargeCardCheckRsp;
    property OnQueryQFTBalanceRsp: TOnQueryQFTBalanceRsp read FOnQueryQFTBalanceRsp write SetOnQueryQFTBalanceRsp;
    property OnModifyZHBPassRsp: TOnModifyZHBPassRsp read FOnModifyZHBPassRsp write SetOnModifyZHBPassRsp;
    property OnLoginStatusChanged: TOnLoginStatusChanged read FOnLoginStatusChanged write SetOnLoginStatusChanged;
    property OnGetCityCardType: TOnGetCityCardType read FOnGetCityCardType write SetOnGetCityCardType;
  end;


implementation
uses
  UGloabVar,
  ConvUtils,
  DateUtils,
  Forms,
  ComCtrls
{$IFOPT d+}, MemFormatUnit{$ENDIF};
const
  COM_MAJOR_VER = 1;
  COM_MINOR_VER = 0;
  CLIENT_MAJOR_VER = 3;
  CLIENT_MINOR_VER = 0;

  MAX_BUFF_SIZE = 1024 * 1024 * 10;


{ TGateWayServerCom }

procedure TGateWayServerCom.AddCmdToList(cmdHead: TSTHead; cmdData: TByteDynArray;
  isNeedPersistence: Boolean);
var
  cmdInfo: PCmdInfo;
  cmdSNo: Integer;
begin
  cmdSNo := ByteOderConvert_Word(cmdHead.CmdSNo);
  cmdInfo := ACmdManage.Add(cmdSno);
  cmdInfo^.Flag := cmdHead.CmdId;
  cmdInfo^.DevId := cmdHead.TerminalId;
  cmdInfo^.State := 0;
  cmdInfo^.LastSendTime := Now;
  cmdInfo^.IsNeedPersistence := isNeedPersistence;
  SetLength(cmdinfo^.Content, Length(cmdData));
  CopyMemory(@cmdInfo^.Content[0], @cmdData[0], Length(cmdData));
  addSysLog('add a new cmd, cmdSNo:' + IntToStr(cmdSNo));
end;

procedure TGateWayServerCom.AddCmdVoidToList(cmdHead: TSTHead; var cmd; cmdSize: Integer;
  isNeedPersistence: Boolean);
var
  byteBuf: TByteDynArray;
begin
  SetLength(byteBuf, cmdSize);
  CopyMemory(@byteBuf[0], @cmd, cmdSize);
  AddCmdToList(cmdHead, byteBuf, isNeedPersistence);
end;

constructor TGateWayServerCom.Create;
begin
  FLog := TSystemLog.Create;
  FLog.LogFile := ExePath + 'Log\Gateway\data';

  FSocket := TClientSocketThread.Create(True);
  FSocket.OnSocketEvent := FSocketSocketEvent;
  FSocket.OnWriteBufferOverflow := FSockerWriteBufferOverflow;
  ReallocMem(FSocket.WriteBuf.Data, 1024 * 8);
  FSocket.WriteBuf.Size := 1024 * 8;
  FSocket.Resume;

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 100;
  FTimer.Enabled := False;
  FTimer.OnTimer := FTimerTimer;

  FReadLock := TCriticalSection.Create;

  FReadBuf.ReadPos := 0;
  FReadBuf.WritePos := 0;
  FReadBuf.Size := 0;
  FReadBuf.Data := nil;
  ReallocMem(FReadBuf.Data, MAX_BUFF_SIZE);
  FReadBuf.Size := MAX_BUFF_SIZE;
  FLoginStatus := LOGIN_STATUS_SERVER_DISCONNECTED;

  FMaxCmdSNo := 0;
end;

procedure TGateWayServerCom.DealReceiveData; // 处理接收到的服务器数据,这里主要是分检工作
var
  readCount: Integer;
  buf: TByteDynArray;
  i: Integer;
  sIndex, eIndex: integer;
  cmdId: Word;
begin
  //first 从线程中读取数据,注意,要减少线程的锁定时间
  try
    FSocket.LockRead;
    if FSocket.ReadBuf.WritePos > 0 then
    begin
      readCount := Min(FSocket.ReadBuf.WritePos, FReadBuf.Size - FReadBuf.WritePos);
      CopyMemory(PtrAdd(FReadBuf.Data, FReadBuf.WritePos), FSocket.ReadBuf.Data, readCount);
      Inc(FReadBuf.WritePos, readCount);
      if FSocket.ReadBuf.WritePos = readCount then
        FSocket.ReadBuf.WritePos := 0
      else
      begin
        CopyMemory(FSocket.ReadBuf.Data, PtrAdd(FSocket.ReadBuf.Data, readCount),
          FSocket.ReadBuf.WritePos - readCount);
        FSocket.ReadBuf.WritePos := FSocket.ReadBuf.WritePos - readCount;
      end;
    end;
  finally
    FSocket.UnLockRead;
  end;
  try
    LockRead;
    try
      while (FReadBuf.WritePos >= 14) do
      begin
        sIndex := -1;
        eIndex := -1;
        for i := 0 to FReadBuf.WritePos - 1 do
        begin
          if PByte(PtrAdd(FReadBuf.Data, i))^ = CMD_START_FLAG then
          begin
            if sIndex = -1 then
            begin
              sIndex := i;
            end
            else if eIndex = -1 then
            begin
              eIndex := i;
              Break;
            end;
          end;
        end;
        if (sIndex >= 0) then
        begin
          if (eIndex >= 0) then
          begin//找到尾标识
            if eIndex - sIndex + 1>= 14 then
            begin//合法包
              SetLength(buf, eIndex - sIndex + 1);
              CopyMemory(@buf[0], PtrAdd(FReadBuf.Data, sIndex), Length(buf));
              FReadBuf.WritePos := FReadBuf.WritePos - (eIndex + 1);
              CopyMemory(FReadBuf.Data, PtrAdd(FReadBuf.Data, eIndex + 1), FReadBuf.WritePos);
            end
            else
            begin//总包长不合法，丢弃再循环
              FReadBuf.WritePos := FReadBuf.WritePos - eIndex;
              CopyMemory(FReadBuf.Data, PtrAdd(FReadBuf.Data, eIndex), FReadBuf.WritePos);
              Continue;
            end;
          end
          else if (FReadBuf.writePos - sIndex <= 1024) then//等待完整包
          begin
            if sIndex > 0 then
            begin
              FReadBuf.WritePos := FReadBuf.WritePos - sIndex;
              CopyMemory(FReadBuf.Data, PtrAdd(FReadBuf.Data, sIndex), FReadBuf.WritePos);
              Break;
            end;
          end
          else
          begin//无合法数据，直接全部抛弃
            FReadBuf.WritePos := 0;
            Break;
          end;
        end
        else
        begin//无合法数据，直接全部抛弃
          FReadBuf.WritePos := 0;
          Break;
        end;

        buf := GetUnEscapedBuf(buf);
        cmdId := ByteOderConvert_Word(PWord(@buf[1])^);
        case cmdId of// PByte(PtrAdd(FReadBuf.Data, 2))^ of
          S2C_TYRET: dealCmdTYRet(buf);
          S2C_LOGIN_RSP: dealCmdLoginRsp(buf);
          S2C_GET_MAC2_RSP: dealCmdGetMac2Rsp(buf);
          S2C_CHARGE_DETAIL_RSP: dealCmdChargeDetailRsp(buf);
          S2C_REFUND_RSP: dealCmdRefundRsp(buf);
          S2C_PRE_CARD_CHECK_RSP: dealCmdChargeCardCheckRsp(buf);
          S2C_QUERY_QFT_BALANCE: dealCmdQueryQFTBalanceRsp(buf);
          S2C_MODIFY_PASS_RSP: dealCmdModifyZHBPassRsp(buf);
          S2C_CHECK_CITY_CARD_TYPE_RSP: dealCmdCheckCityCardType(buf);
          S2C_ENABLE_STATUS_CHANGED:dealCmdEnableStatusChanged(buf);
          S2C_ADD_CASH_BOX_AMOUNT: dealCmdAddCashBoxAmount(buf);
          S2C_GET_SERVER_TIME: dealCmdGetServerRsp(buf);
        else
          begin
            FLog.AddLog('处理数据错误:命令字不正确 ' + bytesToHexStr(wordToBytes(cmdId)));
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        FReadBuf.WritePos := 0;
        FLog.AddLog('处理数据错误:发生异常，异常提示:' + E.Message);
      end;
    end;
  finally
    UnLockRead;
  end;
end;

procedure TGateWayServerCom.DeleteCmdFromList(cmdHead: TSTHead);
var
  cmdSNoResp: Word;
begin
  cmdSNoResp := ByteOderConvert_Word(cmdHead.CmdSNoResp);
  ACmdManage.Delete(cmdSNoResp);
  addSysLog('delete a responsed cmd, cmdSNo:' + IntToStr(cmdSNoResp));
end;

destructor TGateWayServerCom.Destroy;
begin
  FTimer.Enabled := False;
  FTimer.Free;
  ReallocMem(FReadBuf.Data, 0);
  FSocket.Terminate;
  FSocket.WaitFor;
  FSocket.Free;
  FReadLock.Free;
  FLog.Free;
  inherited;
end;

function TGateWayServerCom.DirectSend(var buf; ABufSize: Integer): Boolean; //调用内部的发送函数直接发送数据
var
  byteBuf: TByteDynArray;
  bufLen: Integer;
begin
  bufLen := ABufSize;
  SetLength(byteBuf, bufLen);
  CopyMemory(@byteBuf[0], @buf, bufLen);
  byteBuf := GetEscapedBuf(byteBuf);
  bufLen := Length(byteBuf);
  if FActive and FSocket.Active then
    Result := send(FSocket.SocketHandle, byteBuf[0], bufLen, 0) = bufLen
  else
    Result := false;
end;

procedure TGateWayServerCom.FSockerWriteBufferOverflow(Sender: TObject);
begin
  DealReceiveData;
end;

procedure TGateWayServerCom.FSocketSocketEvent(Sender: TObject;
  Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
begin
  case SocketEvent of
    seConnect:
      begin
        LoginToServer;
        FLoginStatus := LOGIN_STATUS_NO_RSP;
        if Assigned(FOnLoginStatusChanged) then
          FOnLoginStatusChanged(FLoginStatus);

        SendCmdGetServerTime;
      end;
    seDisconnect:
      begin
        FLoginStatus := LOGIN_STATUS_SERVER_DISCONNECTED;
        if Assigned(FOnLoginStatusChanged) then
          FOnLoginStatusChanged(FLoginStatus);
      end;
  end;
end;

procedure TGateWayServerCom.FTimerTimer(Sender: TObject);
begin
  try
    FTimer.Enabled := False;
    try
      DealReceiveData;
    finally
      FTimer.Enabled := True;
    end;
  except on E: Exception do
      FSysLog.AddLog(' TGateWayServerCom.FTimerTimer函数报错: ', e.Message);
  end;
end;

function TGateWayServerCom.GetActive: Boolean;
begin
  Result := FSocket.Active;
end;

function TGateWayServerCom.GetMaxCmdSNo: Word;
begin
  if FMaxCmdSNo >= $7FFF then
    FMaxCmdSNo := 0;
  Result := FMaxCmdSNo;
  Inc(FMaxCmdSNo);
end;

function TGateWayServerCom.LoginToServer: Boolean; // 用户登录网关服务器
var
  cmd: TCmdLoginC2S;
  buf: TByteDynArray;
begin
  initCmd(cmd.CmdHead, C2S_LOGIN, cmd.CmdEnd, SizeOf(TCmdLoginC2S));
  cmd.Ver := ByteOderConvert_Word(VER);
  buf := hexStrToBytes(getFixedLenStr(GlobalParam.PosId, 12, '0', True));
  CopyMemory(@cmd.PosID[0], @buf[0], Length(buf));

  buf := hexStrToBytes(getFixedLenStr(GlobalParam.SAMID, 12, '0', True));
  CopyMemory(@cmd.SAMID[0], @buf[0], Length(buf));

  Result := DirectSend(cmd, SizeOf(TCmdLoginC2S));
end;

function TGateWayServerCom.PtrAdd(p: pointer; offset: integer): pointer;
begin
  Result := Pointer(Integer(p) + offset);
end;

procedure TGateWayServerCom.resendData(buf: TByteDynArray);
begin
  DirectSend(buf[0], Length(buf));
end;

procedure TGateWayServerCom.SendCmdChargeCardCheck(cityCardNo,
  password: AnsiString);
var
  buf: TByteDynArray;
  cmd: TCmdChargeCardCheckC2S;
begin
  initCmd(cmd.CmdHead, C2S_CHARGE_CARD_CHECK, cmd.CmdEnd, SizeOf(TCmdChargeCardCheckC2S));

  buf := hexStrToBytes(cityCardNo);
  CopyMemory(@cmd.CityCardNo[0], @buf[0], Min(Length(buf), Length(cmd.CityCardNo)));

  buf := hexStrToBytes(password);
  CopyMemory(@cmd.Password[0], @buf[0], Min(Length(buf), Length(cmd.Password)));

  DirectSend(cmd, SizeOf(TCmdChargeCardCheckC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdChargeCardCheckC2S));
end;

procedure TGateWayServerCom.SendCmdChargeDetail(cmd: TCmdChargeDetailC2S);
begin
  initCmd(cmd.CmdHead, C2S_CHARGE_DETAIL, cmd.CmdEnd, SizeOf(TCmdChargeDetailC2S));
  DirectSend(cmd, SizeOf(TCmdChargeDetailC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdChargeDetailC2S), True);
end;

procedure TGateWayServerCom.SendCmdCheckCityCardType(cityCardNo: AnsiString);
var
  buf: TByteDynArray;
  cmd: TCmdCheckCityCardTypeC2S;
begin
  initCmd(cmd.CmdHead, C2S_CHECK_CITY_CARD_TYPE, cmd.CmdEnd, SizeOf(TCmdCheckCityCardTypeC2S));

  buf := hexStrToBytes(cityCardNo);
  CopyMemory(@cmd.CityCardNo[0], @buf[0], Min(Length(buf), Length(cmd.CityCardNo)));

  DirectSend(cmd, SizeOf(TCmdCheckCityCardTypeC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdCheckCityCardTypeC2S));
end;

procedure TGateWayServerCom.SendCmdClearCashBox(cashAmount: Integer);
var
  cmd: TCmdClearCashBoxC2S;
  tempBuf: TByteDynArray;
begin
  initCmd(cmd.CmdHead, C2S_CLEAR_CASHBOX, cmd.CmdEnd, SizeOf(TCmdClearCashBoxC2S));
  cmd.CashAmount := ByteOderConvert_LongWord(cashAmount);
  tempBuf := hexStrToBytes(FormatDateTime('yyMMddhhnnss', Now));
  CopyMemory(@cmd.OperTime[0], @tempBuf[0], Min(Length(tempBuf), Length(cmd.OperTime)));
  tempBuf := hexStrToBytes(FormatDateTime('yyMMddhhnnss', LastClearCashBoxTime));
  CopyMemory(@cmd.LastOperTime[0], @tempBuf[0], Min(Length(tempBuf), Length(cmd.LastOperTime)));
  DirectSend(cmd, SizeOf(TCmdClearCashBoxC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdClearCashBoxC2S), True);
end;

procedure TGateWayServerCom.SendCmdAddCashBoxAmount(amountAdd: Integer);
var
  cmd: TCmdAddCashBoxAmountC2S;
begin
  initCmd(cmd.CmdHead, C2S_ADD_CASH_BOX_AMOUNT, cmd.CmdEnd, SizeOf(TCmdAddCashBoxAmountC2S));
  cmd.AmountAdded := ByteOderConvert_LongWord(amountAdd);
  DirectSend(cmd, SizeOf(TCmdAddCashBoxAmountC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdAddCashBoxAmountC2S), True);
end;

procedure TGateWayServerCom.SendCmdGetMac2(cardNo, password, asn, CardTradeNo: array of Byte;
  OperType: Byte; OldBalance, chargeAmount: Integer;
  chargeTime, fakeRandom, mac1: array of Byte; status: Byte);
var
  cmd: TCmdGetMac2ForChargeC2S;
  terminalIdBuf: TByteDynArray;
  tempBuf: TByteDynArray;
begin
  initCmd(cmd.CmdHead, C2S_GET_MAC2, cmd.CmdEnd, SizeOf(TCmdGetMac2ForChargeC2S));
  cmd.OperType := OperType;
  CopyMemory(@cmd.cardNo[0], @cardNo[0], Min(Length(cmd.cardNo), Length(cardNo)));
  CopyMemory(@cmd.Password[0], @Password[0], Min(Length(cmd.Password), Length(Password)));
  terminalIdBuf := hexStrToByteBuf(getFixedLenStr(GlobalParam.TerminalId, 12, '0'), False);
  CopyMemory(@(cmd.TerminalId[0]), @terminalIdBuf[0], SizeOf(cmd.TerminalId));
  CopyMemory(@cmd.asn[0], @asn[0], Min(Length(cmd.asn), Length(asn)));
  CopyMemory(@cmd.FakeRandom[0], @fakeRandom[0], Min(Length(cmd.FakeRandom), Length(fakeRandom)));
  CopyMemory(@cmd.CardTradeNo[0], @CardTradeNo[0], Min(Length(cmd.CardTradeNo), Length(CardTradeNo)));
  cmd.CardOldBalance := ByteOderConvert_LongWord(currCityCardBalance);
  cmd.ChargeAmount := ByteOderConvert_LongWord(chargeAmount);
  CopyMemory(@cmd.Mac1[0], @mac1[0], Min(Length(cmd.Mac1), Length(mac1)));
  CopyMemory(@cmd.ChargeTime[0], @chargeTime[0], Min(Length(cmd.ChargeTime), Length(chargeTime)));
  cmd.Status := status;
  if status = 1 then
  begin
    tempBuf := hexStrToBytes(currTranSNoFromServer);
    CopyMemory(@cmd.TranSNo[0], @tempBuf[0], Min(Length(cmd.TranSNo), Length(tempBuf)));
  end;
  DirectSend(cmd, SizeOf(TCmdGetMac2ForChargeC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdGetMac2ForChargeC2S));
end;

procedure TGateWayServerCom.SendCmdGetServerTime;
var
  cmd: TCmdGetServerTimeC2S;
begin
  initCmd(cmd.CmdHead, C2S_GET_SERVER_TIME, cmd.CmdEnd, SizeOf(TCmdGetServerTimeC2S));
  DirectSend(cmd, SizeOf(TCmdGetServerTimeC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdGetServerTimeC2S));
end;

procedure TGateWayServerCom.SendCmdModifyZHBPass(oldPass, newPass: AnsiString;
  cardNo, asn, CardTradeNo: array of Byte; OldBalance: Integer;
  chargeTime, fakeRandom, mac1: array of Byte);
var
  cmd: TCmdModifyZHBPassC2S;
  tempBuf: TByteDynArray;
begin
  initCmd(cmd.CmdHead, C2S_MODIFY_PASS, cmd.CmdEnd, SizeOf(TCmdModifyZHBPassC2S));
  tempBuf := hexStrToByteBuf(oldPass, False);
  CopyMemory(@cmd.OldPass[0], @tempBuf[0], Min(Length(cmd.OldPass), Length(tempBuf)));
  tempBuf := hexStrToByteBuf(newPass, False);
  CopyMemory(@cmd.NewPass[0], @tempBuf[0], Min(Length(cmd.NewPass), Length(tempBuf)));
  CopyMemory(@cmd.cardNo[0], @cardNo[0], Min(Length(cmd.cardNo), Length(cardNo)));
  tempBuf := hexStrToByteBuf(getFixedLenStr(GlobalParam.TerminalId, 12, '0'), False);
  CopyMemory(@(cmd.TerminalId[0]), @tempBuf[0], SizeOf(cmd.TerminalId));
  CopyMemory(@cmd.asn[0], @asn[0], Min(Length(cmd.asn), Length(asn)));
  CopyMemory(@cmd.FakeRandom[0], @fakeRandom[0], Min(Length(cmd.FakeRandom), Length(fakeRandom)));
  CopyMemory(@cmd.CardTradeNo[0], @CardTradeNo[0], Min(Length(cmd.CardTradeNo), Length(CardTradeNo)));
  cmd.CardOldBalance := ByteOderConvert_LongWord(currCityCardBalance);
  CopyMemory(@cmd.Mac1[0], @mac1[0], Min(Length(cmd.Mac1), Length(mac1)));
  CopyMemory(@cmd.ChargeTime[0], @chargeTime[0], Min(Length(cmd.ChargeTime), Length(chargeTime)));
  DirectSend(cmd, SizeOf(TCmdModifyZHBPassC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdModifyZHBPassC2S));
end;

procedure TGateWayServerCom.SendCmdOperLog(operType: Byte);
var
  cmd: TCmdOperLogC2S;
begin
  initCmd(cmd.CmdHead, C2S_OPER_LOG, cmd.CmdEnd, SizeOf(TCmdOperLogC2S));
  cmd.OperType := operType;
  DirectSend(cmd, SizeOf(TCmdOperLogC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdOperLogC2S));
end;

procedure TGateWayServerCom.SendCmdQueryQFTBalance(cityCardNo,
  password: AnsiString);
var
  buf: TByteDynArray;
  cmd: TCmdQueryQFTBalanceC2S;
begin
  initCmd(cmd.CmdHead, C2S_QUERY_QFT_BALANCE, cmd.CmdEnd, SizeOf(TCmdQueryQFTBalanceC2S));
  buf := hexStrToBytes(cityCardNo);
  CopyMemory(@cmd.CityCardNo[0], @buf[0], Min(Length(buf), Length(cmd.CityCardNo)));

  buf := hexStrToBytes(password);
  CopyMemory(@cmd.Password[0], @buf[0], Min(Length(buf), Length(cmd.Password)));

  DirectSend(cmd, SizeOf(TCmdQueryQFTBalanceC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdQueryQFTBalanceC2S));
end;

procedure TGateWayServerCom.SendCmdRefund(cmd: TCmdRefundC2S);
begin
  initCmd(cmd.CmdHead, C2S_REFUND, cmd.CmdEnd, SizeOf(TCmdRefundC2S));
  DirectSend(cmd, SizeOf(TCmdRefundC2S));
  AddCmdVoidToList(cmd.CmdHead, cmd, SizeOf(TCmdRefundC2S), true);
end;

procedure TGateWayServerCom.SendCmdUploadModuleStatus(
  moduleStatus: array of Byte);
var
  cmd: TCmdTerminalModuleStatusC2S;
  tempBuf: TByteDynArray;
  index, count: Integer;
begin
  initCmd(cmd.CmdHead, C2S_TERMINAL_MODULE_STATUS, cmd.CmdEnd, SizeOf(TCmdTerminalModuleStatusC2S) + Length(moduleStatus));
  cmd.ModuleCount := Length(moduleStatus) div 2;
  SetLength(tempBuf, Length(moduleStatus) + SizeOf(TCmdTerminalModuleStatusC2S));

  index := 0;
  count := SizeOf(TCmdTerminalModuleStatusC2S) - SizeOf(TSTEnd);
  CopyMemory(@tempBuf[index], @cmd, count);
  Inc(index, count);

  count := Length(moduleStatus);
  CopyMemory(@tempBuf[index], @moduleStatus[0], count);
  Inc(index, count);

  tempBuf[index] := $00;
  tempBuf[index + 1] := CMD_END_FLAG;
  DirectSend(tempBuf[0], Length(tempBuf));
  AddCmdToList(cmd.CmdHead, tempBuf);
end;

procedure TGateWayServerCom.SetActive(const Value: Boolean);
begin
  if Value then
  begin
    FSocket.Address := Address;
    FSocket.Port := Port;
    FSocket.Host := Host;
  end;
  FSocket.Active := Value;
  FTimer.Enabled := Value;
  FActive := Value;
end;

procedure TGateWayServerCom.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TGateWayServerCom.SetAutoLogin(const Value: Boolean);
begin
  FAutoLogin := Value;
end;


procedure TGateWayServerCom.SetHost(const Value: string);
begin
  FHost := Value;
end;

procedure TGateWayServerCom.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

procedure TGateWayServerCom.SetUserId(const Value: Integer);
begin
  FUserId := Value;
end;

procedure TGateWayServerCom.SetUserPass(const Value: string);
begin
  FUserPass := Value;
end;

procedure TGateWayServerCom.initCmd(var cmdHead: TSTHead; cmdId: Word;
  var cmdEnd: TSTEnd; cmdMinSize: Integer);
var
  terminalIdBuf: TByteDynArray;
  cmdSNo: Word;
begin
  cmdSNo := GetMaxCmdSNo;
  cmdHead.StartFlag := CMD_START_FLAG;
  cmdHead.CmdId := ByteOderConvert_Word(cmdId);
  cmdHead.ClientType := 0;

  cmdHead.TerminalId := ByteOderConvert_LongWord(StrToInt(GlobalParam.TerminalId));
  cmdHead.BodySize := ByteOderConvert_Word(cmdMinSize - SizeOf(TSTHead) - SizeOf(TSTEnd));
  cmdHead.CmdSNo := ByteOderConvert_Word(cmdSNo);
  cmdEnd.CheckSum := 0;
  cmdEnd.EndFlag := CMD_END_FLAG;
end;

function TGateWayServerCom.isActive: boolean;
begin
  Result := Active;
  if not Active then PopMsg('错误提示', '与网关服务器' + #13 + #10 + '连接不正常' + #13 + #10 + ',不能发送命令');
end;

procedure TGateWayServerCom.SendHeartbeat;
var
  cmd: TCmdHeartbeatC2S;
begin
  initCmd(cmd.CmdHead, C2S_HEARTBEAT, cmd.CmdEnd, SizeOf(TCmdHeartbeatC2S));

  DirectSend(cmd, SizeOf(TCmdHeartbeatC2S));
end;

procedure TGateWayServerCom.SetOnChargeCardCheckRsp(
  const Value: TOnChargeCardCheckRsp);
begin
  FOnChargeCardCheckRsp := Value;
end;

procedure TGateWayServerCom.SetOnChargeDetailRsp(
  const Value: TOnChargeDetailRsp);
begin
  FOnChargeDetailRsp := Value;
end;

procedure TGateWayServerCom.SetOnGetCityCardType(
  const Value: TOnGetCityCardType);
begin
  FOnGetCityCardType := Value;
end;

procedure TGateWayServerCom.SetOnGetMac2(const Value: TOnGetMac2);
begin
  FOnGetMac2 := Value;
end;

procedure TGateWayServerCom.SetOnLoginStatusChanged(
  const Value: TOnLoginStatusChanged);
begin
  FOnLoginStatusChanged := Value;
end;

procedure TGateWayServerCom.SetOnModifyZHBPassRsp(
  const Value: TOnModifyZHBPassRsp);
begin
  FOnModifyZHBPassRsp := Value;
end;

procedure TGateWayServerCom.SetOnQueryQFTBalanceRsp(
  const Value: TOnQueryQFTBalanceRsp);
begin
  FOnQueryQFTBalanceRsp := Value;
end;

procedure TGateWayServerCom.SetOnRefundRsp(const Value: TOnRefundRsp);
begin
  FOnRefundRsp := Value;
end;

procedure TGateWayServerCom.LockRead;
begin
  try
    FReadLock.Enter;
  except
    on E: Exception do
    begin
      FLog.AddLog('LockRead Error:' + E.Message);
    end;
  end;
end;

procedure TGateWayServerCom.UnLockRead;
begin
  try
    FReadLock.Leave;
  except
    on E: Exception do
    begin
      FLog.AddLog('UnLockRead Error:' + E.Message);
    end;
  end;
end;

procedure TGateWayServerCom.dealCmdChargeDetailRsp(buf: array of Byte);
var
  pcmd: PCmdChargeDetailRspS2C;
begin
  if Length(buf) >= SizeOf(TCmdChargeDetailRspS2C) then
  begin
    pcmd := PCmdChargeDetailRspS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    if Assigned(FOnChargeDetailRsp) then
    begin
      FOnChargeDetailRsp(pcmd^.Ret, pcmd^.RecordId);
    end;
  end;
end;

procedure TGateWayServerCom.dealCmdCheckCityCardType(buf: array of Byte);
var
  pcmd: PCmdCheckCityCardTypeS2C;
  cityCardNo: AnsiString;
begin
  addSysLog('recv CmdCheckCityCardType');
  if Length(buf) >= SizeOf(TCmdCheckCityCardTypeS2C) then
  begin
    pcmd := PCmdCheckCityCardTypeS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    cityCardNo := bytesToHexStr(pcmd^.CityCardNo);
    if cityCardNo <> currCityCardNo then
    begin//如果服务端返回卡号与当前检测到的卡号不一致，则可能是之前的命令返回，此处直接不处理了
      Exit;
    end;
    if Assigned(FOnGetCityCardType) then
    begin
      FOnGetCityCardType(pcmd^.Ret);
    end;
  end;
end;

procedure TGateWayServerCom.dealCmdEnableStatusChanged(buf: array of Byte);
var
  pcmd: PCmdEnableStatusChangedS2C;
  status: Byte;
  terminalId: Integer;
begin
  if Length(buf) >= SizeOf(TCmdEnableStatusChangedS2C) then
  begin
    pcmd := PCmdEnableStatusChangedS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    terminalId := ByteOderConvert_LongWord(pcmd^.CmdHead.TerminalId);
    if GlobalParam.TerminalId = IntToStr(terminalId) then
    begin
      if Assigned(FOnLoginStatusChanged) then
      begin
        case pcmd^.Status of
          0: FOnLoginStatusChanged(0);//启用
          1: FOnLoginStatusChanged(3);//暂停
        end;
      end;
    end;
  end;
end;

procedure TGateWayServerCom.dealCmdAddCashBoxAmount(buf: array of Byte);
var
  pcmd: PCmdAddCashBoxAmountS2C;
  cashBoxTotalAmount: Integer;
begin
  if Length(buf) >= SizeOf(TCmdAddCashBoxAmountS2C) then
  begin
    pcmd := PCmdAddCashBoxAmountS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    cashBoxTotalAmount := ByteOderConvert_LongWord(pcmd^.CashBoxTotalAmount);
    if cashBoxTotalAmount > CurrCashBoxAmount then
    begin//如果服务端返回的钱箱总额大于本机的数据，则证明设备端数据需与服务端保持一致
      addSysLog('cashbox amount from server[' + IntToStr(cashBoxTotalAmount) + '] is greater than cashbox amount from local[' + IntToStr(CurrCashBoxAmount) + ']');
      CurrCashBoxAmount := cashBoxTotalAmount;
      updateCurrCashBoxAmountToFile;
    end;
  end;
end;

procedure TGateWayServerCom.dealCmdGetMac2Rsp(buf: array of Byte);
var
  pcmd: PCmdGetMac2ForChargeS2C;
  errTipLen: Byte;
  mac2, tranSNo, errTip: ansistring;
begin
  if Length(buf) >= SizeOf(TCmdGetMac2ForChargeS2C) then
  begin
    pcmd := PCmdGetMac2ForChargeS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    mac2 := bytesToHexStr(pcmd^.Mac2);
    tranSNo := bytesToHexStr(pcmd^.TranSNo);
    errTipLen := pcmd^.ErrTipLen;
    errTip := '';
    if errTipLen > 0 then
    begin
      errTipLen := math.Min(Length(buf) - SizeOf(TCmdGetMac2ForChargeS2C) - SizeOf(TSTEnd), errTipLen);
      addSysLog('pcmd^.ErrTipLen:' + IntToStr(pcmd^.ErrTipLen) + ',errTipLen:' + IntToStr(errTipLen));
      SetLength(errTip, errTipLen);
      CopyMemory(@errTip[1], PtrAdd(pcmd, SizeOf(TCmdGetMac2ForChargeS2C)), errTipLen);
    end;
    addSysLog('recv mac2 rsp, ret:' + IntToStr(pcmd^.Ret) + ',mac2:' + mac2 + ',tranSNo:' + tranSNo + ',errTip:[' + errTip + ']');
    if Assigned(FOnGetMac2) then
      FOnGetMac2(pcmd^.Ret, mac2, tranSNo, errTip);
  end;
end;

procedure TGateWayServerCom.dealCmdGetServerRsp(buf: array of Byte);
var
  pcmd: PCmdGetServerTimeS2C;
  sDate: string;
  dt: TDateTime;
begin
  if Length(buf) >= SizeOf(TCmdGetServerTimeS2C) then
  begin
    pcmd := PCmdGetServerTimeS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    sDate := byteToHexStr(pcmd^.ServerTime[0]) + byteToHexStr(pcmd^.ServerTime[1]) + '-'
           + byteToHexStr(pcmd^.ServerTime[2]) + '-'
           + byteToHexStr(pcmd^.ServerTime[3]) + ' '
           + byteToHexStr(pcmd^.ServerTime[4]) + ':'
           + byteToHexStr(pcmd^.ServerTime[5]) + ':'
           + byteToHexStr(pcmd^.ServerTime[6]);
    try
      dt := StrToDateTime(sDate);
      if MinutesBetween(dt, Now) > 10 then
      begin
        SetSystemDateTime(dt);
      end;
    except
      on E: Exception do
      begin

      end;
    end;
  end;
end;

procedure TGateWayServerCom.dealCmdLoginRsp(buf: array of Byte);
var
  pcmd: PCmdLoginRspS2C;
begin
  if Length(buf) >= SizeOf(TCmdLoginRspS2C) then
  begin
    pcmd := PCmdLoginRspS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    FLoginStatus := pcmd^.Ret;
    if Assigned(FOnLoginStatusChanged) then
      FOnLoginStatusChanged(FLoginStatus);
  end;
end;

procedure TGateWayServerCom.dealCmdModifyZHBPassRsp(buf: array of Byte);
var
  pcmd: PCmdModifyZHBPassRsp;
begin
  if Length(buf) >= SizeOf(TCmdModifyZHBPassRsp) then
  begin
    pcmd := PCmdModifyZHBPassRsp(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    if Assigned(FOnModifyZHBPassRsp) then
      FOnModifyZHBPassRsp(pcmd^.Ret);
  end;
end;

procedure TGateWayServerCom.dealCmdChargeCardCheckRsp(buf: array of Byte);
var
  pcmd: PCmdChargeCardCheckS2C;
begin
  if Length(buf) >= SizeOf(TCmdChargeCardCheckS2C) then
  begin
    pcmd := PCmdChargeCardCheckS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    if Assigned(FOnChargeCardCheckRsp) then
      FOnChargeCardCheckRsp(pcmd^.CheckRet, ByteOderConvert_LongWord(pcmd^.Amount));
  end;
end;

procedure TGateWayServerCom.dealCmdQueryQFTBalanceRsp(buf: array of Byte);
var
  pcmd: PCmdQueryQFTBalanceS2C;
begin
  if Length(buf) >= SizeOf(TCmdQueryQFTBalanceS2C) then
  begin
    pcmd := PCmdQueryQFTBalanceS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    if Assigned(FOnQueryQFTBalanceRsp) then
      FOnQueryQFTBalanceRsp(pcmd^.CheckRet, ByteOderConvert_LongWord(pcmd^.Balance));
  end;
end;

procedure TGateWayServerCom.dealCmdRefundRsp(buf: array of Byte);
var
  pcmd: PCmdRefundRspS2C;
begin
  if Length(buf) >= SizeOf(TCmdRefundRspS2C) then
  begin
    pcmd := PCmdRefundRspS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
    if Assigned(FOnRefundRsp) then
      FOnRefundRsp(pcmd^.Ret, pcmd^.RecordId);
  end;
end;

procedure TGateWayServerCom.dealCmdTYRet(buf: array of Byte);
var
  pCmd: PCmdTYRetS2C;
begin
  if Length(buf) >= SizeOf(TCmdTYRetS2C) then
  begin
    pCmd := PCmdTYRetS2C(@buf[0]);
    DeleteCmdFromList(pcmd^.CmdHead);
  end
end;

procedure TGateWayServerCom.SetFTimerEnabled(enabled: Boolean);
begin
  FTimer.Enabled := enabled;
end;

{ TCmdManage }

function TCmdManage.Add(const ACmdID: Integer): PCmdInfo;
var
  p: PCmdInfo;
begin
  New(p);
  p^.Id := ACmdID;
  FList.AddData(ACmdID, p);
  Result := p;
  p^.ResendCount := 0;
  p^.LastSendTime := Now;
  //如果多于SAVE_CMD_COUNT条，就删掉前面的。
  if FList.Count > SAVE_CMD_COUNT then
    delete(Items[0].Id);
end;

procedure TCmdManage.ClearCmd;
begin
  while count > 0 do
    Delete(Items[0].Id);
end;

constructor TCmdManage.Create;
begin
  FList := TIntegerList.Create;
  FList.Sorted := True;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 2500;
  FTimer.OnTimer := FTimerTimer;
  FTimer.Enabled := True;
end;

procedure TCmdManage.Delete(const ACmdID: Integer);
var
  i: Integer;
  p: PCmdInfo;
begin
  i := FList.IndexOf(ACmdID);
  if i >= 0 then
  begin
    p := FList.Datas[i];
    FList.Delete(i);
    Dispose(p);
    addSysLog('succeed to delete a cmd from cmdmanage:' + IntToStr(ACmdID));
  end;
end;

destructor TCmdManage.Destroy;
var
  i: Integer;
  p: PCmdInfo;
begin
  FTimer.Enabled := False;
  for i := 0 to FList.Count - 1 do
  begin
    p := FList.Datas[i];
    Dispose(p);
  end;
  FList.Free;
  FTimer.Free;
  inherited;
end;

function TCmdManage.Find(const ACmdID: Integer): PCmdInfo;
var
  i: Integer;
begin
  Result := nil;
  i := FList.IndexOf(ACmdID);
  if i >= 0 then
    Result := Items[i];
end;

procedure TCmdManage.FTimerTimer(Sender: TObject);
var
  i: Integer;
  pcmd: PCmdInfo;
  curTime: TDateTime;
begin
  i := 0;
  try
    curTime := Now;
    while FList.Count > i do
    begin
      pcmd := Items[i];
      if (pcmd <> nil) then
      begin
        if not pcmd^.IsNeedPersistence then
        begin//非长期保存的命令
          if pcmd^.ResendCount < 3 then
          begin
            if SecondsBetween(pcmd^.LastSendTime, curTime) >= CMD_RESEND_INTERVAL then
            begin//达到重发的时间
              pcmd^.LastSendTime := curTime;
              DataServer.resendData(pcmd^.Content);
              pcmd^.ResendCount := pcmd^.ResendCount + 3;
              addSysLog('resend cmd:' + IntToStr(pcmd^.Id));
            end;
          end
          else
          begin
            Delete(pcmd^.Id);
            Continue;
          end;
        end
        else
        begin
          if SecondsBetween(pcmd^.LastSendTime, curTime) >= CMD_RESEND_INTERVAL then
          begin//达到重发的时间
            pcmd^.LastSendTime := curTime;
            DataServer.resendData(pcmd^.Content);
            //pcmd^.ResendCount := pcmd^.ResendCount + 3;
            addSysLog('resend cmd:' + IntToStr(pcmd^.Id));
          end;
        end;
//        if pcmd^.CheckCount < 4 then
//          pcmd^.CheckCount := pcmd^.CheckCount + 1
//        else
//        begin//如果已经达到4，则重发
////          if Assigned(FOnResendData) then
////            FOnResendData(pcmd^.content[0], pcmd^.ContentSize, pcmd^.Desc);
//          Delete(pcmd^.Id);
//          Continue;
//        end;
      end;
      i := i + 1;
    end;
  except
    on E: Exception do
    begin
    end;
  end;
end;

function TCmdManage.GetCount: integer;
begin
  Result := FList.Count;
end;

function TCmdManage.GetItems(Index: Integer): PCmdInfo;
var p: PCmdInfo;
begin
  Result := nil;
  if (Index >= 0) and (Index < FList.Count) then
    result := FList.Datas[Index];
 // Result := TCmdInfo(FList.Datas[Index]);
end;

procedure TCmdManage.SetMax_count(const Value: integer);
begin
  FMax_count := Value;
end;

end.

