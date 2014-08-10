unit GatewayServerUnit;

interface
uses
  CmdStructUnit, Windows, Winsock, extctrls, sysutils, ScktCompUnit, math,
  ConstDefineUnit, IntegerListUnit, ScktComp, Types, BusinessServerUnit,
  classes, SystemLog, SyncObjs;

const
  SAVE_CMD_COUNT = 500; //保存多少条最近执行的命令信息

type

  TOnGetMac2 = procedure (ret: Byte; mac2: ansistring) of object;
  TOnChargeDetailRsp = procedure(ret: Byte; recordId: Int64) of object;
  TOnRefundRsp = procedure(ret: Byte; recordId: LongWord) of object;

  TCmdInfo = record //命令信息
    Id: integer; //命令ID
    Flag: integer; //这是什么命令;
    DevId: integer; //车机ID
    State: Byte; //0表示已发送未执行，1表示已执行，2表示执行出错，3表示被用户取消 , 4表示已取消,5表示取消失败，6表示重发  7-被删除，8-被替代 9-超时 10-表示已经发送到SMS发送服务器
    Desc: string; //命令描述
    SendTime: Tdatetime; //发出时间
    Replytime: Tdatetime; //执行完时间
    CancelTime: Tdatetime; //被取消时间
    Content: TByteDynArray; //命令体的内容
    ContentSize: Integer;
    addesc: integer; //广告状态
    IsNeedResend: Boolean;//是否需要重发
    CheckCount: Byte;//命令管理器中定时500ms检查一次可以重发的命令，当checkcount=4时可以重发 保证在2~3秒内下发
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
    FMaxCmdSNo: SHORT;
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
    procedure FSocketSocketEvent(Sender: TObject; Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
    procedure FSockerWriteBufferOverflow(Sender: TObject);

    procedure dealCmdTYRet(buf: array of Byte);
    procedure dealCmdGetMac2Rsp(buf: array of Byte);
    procedure dealCmdChargeDetailRsp(buf: array of Byte);
    procedure dealCmdRefundRsp(buf: array of Byte);

    procedure initCmd(var cmdHead: TSTHead; cmdId: Word; var cmdEnd: TSTEnd; cmdMinSize: Integer);

    function LoginToServer: Boolean;
    procedure SetOnGetMac2(const Value: TOnGetMac2);
    procedure SetOnChargeDetailRsp(const Value: TOnChargeDetailRsp);
    procedure SetOnRefundRsp(const Value: TOnRefundRsp);
  protected
    function DirectSend(var buf; ABufSize: Integer): Boolean; //调用内部的发送函数直接发送数据
    function GetMaxCmdSNo: Word;
    procedure DealReceiveData; virtual; //处理 接收到的服务器数据,这里主要是分检工作
  public
    constructor Create;
    destructor Destroy; override;
    procedure ResendData(var buf; ABufSize: Integer; tip: string);
    procedure SendHeartbeat;
    procedure SendCmdGetMac2(cardNo, asn, CardTradeNo: array of Byte;
                            OperType: Byte; OldBalance, chargeAmount: Integer;
                            chargeTime, fakeRandom, mac1: array of Byte);
    procedure SendCmdUploadModuleStatus(moduleStatus: array of Byte);
    procedure SendCmdChargeDetail(cmd: TCmdChargeDetailC2S);
    procedure SendCmdRefund(cmd: TCmdRefundC2S);

    procedure SetFTimerEnabled(enabled: Boolean);

    property Host: string read FHost write SetHost; // Server Host 优先级高}
    property Address: string read FAddress write SetAddress; //Server Address IP ADDRESS
    property Port: Integer read FPort write SetPort;
    property UserId: Integer read FUserId write SetUserId;
    property UserPass: string read FUserPass write SetUserPass; //Register User Password
    property Active: Boolean read GetActive write SetActive; // Active表示了和服务器的连接状态
    property AutoLogin: Boolean read FAutoLogin write SetAutoLogin; // 如果和服务器断开是否自动重新登录}
    property Socket: TClientSocketThread read FSocket;

    property OnGetMac2: TOnGetMac2 read FOnGetMac2 write SetOnGetMac2;
    property OnChargeDetailRsp: TOnChargeDetailRsp read FOnChargeDetailRsp write SetOnChargeDetailRsp;
    property OnRefundRsp: TOnRefundRsp read FOnRefundRsp write SetOnRefundRsp;
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
          S2C_GET_MAC2_RSP: dealCmdGetMac2Rsp(buf);
          S2C_CHARGE_DETAIL_RSP: dealCmdChargeDetailRsp(buf);
          S2C_REFUND_RSP: dealCmdRefundRsp(buf);
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
  if FActive then
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
        if LoginToServer then
        begin
          //GetAllPos;
          {f GlobalParam.isUseDriverCard then
          begin
            for i := 0 to ADeviceManage.Count - 1 do
            begin
              Self.ReadDriverNO(ADeviceManage.Items[i]);
            end;
          end; }
        end;
{$IFDEF debug_sha}
        TDebug.GetInstance.SendDebug('FSocketSocketEvent: Logined Server');
{$ENDIF}
      end;
    seDisconnect:
      begin
        addSysLog('disconnect from server');
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
begin
  initCmd(cmd.CmdHead, C2S_LOGIN, cmd.CmdEnd, SizeOf(TCmdLoginC2S));
  cmd.Ver := ByteOderConvert_Word(VER);
  Result := DirectSend(cmd, SizeOf(TCmdLoginC2S));
end;

function TGateWayServerCom.PtrAdd(p: pointer; offset: integer): pointer;
begin
  Result := Pointer(Integer(p) + offset);
end;

procedure TGateWayServerCom.SendCmdChargeDetail(cmd: TCmdChargeDetailC2S);
begin
  initCmd(cmd.CmdHead, C2S_CHARGE_DETAIL, cmd.CmdEnd, SizeOf(TCmdChargeDetailC2S));
  DirectSend(cmd, SizeOf(TCmdChargeDetailC2S));
end;

procedure TGateWayServerCom.SendCmdGetMac2(cardNo, asn, CardTradeNo: array of Byte;
  OperType: Byte; OldBalance, chargeAmount: Integer;
  chargeTime, fakeRandom, mac1: array of Byte);
var
  cmd: TCmdGetMac2ForChargeC2S;
  terminalIdBuf: TByteDynArray;
begin
  initCmd(cmd.CmdHead, C2S_GET_MAC2, cmd.CmdEnd, SizeOf(TCmdGetMac2ForChargeC2S));
  cmd.OperType := OperType;
  CopyMemory(@cmd.cardNo[0], @cardNo[0], Min(Length(cmd.cardNo), Length(cardNo)));
  terminalIdBuf := hexStrToByteBuf(getFixedLenStr(GlobalParam.TerminalId, 12, '0'), False);
  CopyMemory(@(cmd.TerminalId[0]), @terminalIdBuf[0], SizeOf(cmd.TerminalId));
  CopyMemory(@cmd.asn[0], @asn[0], Min(Length(cmd.asn), Length(asn)));
  CopyMemory(@cmd.FakeRandom[0], @fakeRandom[0], Min(Length(cmd.FakeRandom), Length(fakeRandom)));
  CopyMemory(@cmd.CardTradeNo[0], @CardTradeNo[0], Min(Length(cmd.CardTradeNo), Length(CardTradeNo)));
  cmd.CardOldBalance := 0;
  cmd.ChargeAmount := ByteOderConvert_LongWord(chargeAmount);
  CopyMemory(@cmd.Mac1[0], @mac1[0], Min(Length(cmd.Mac1), Length(mac1)));
  CopyMemory(@cmd.ChargeTime[0], @chargeTime[0], Min(Length(cmd.ChargeTime), Length(chargeTime)));
  DirectSend(cmd, SizeOf(TCmdGetMac2ForChargeC2S));
end;

procedure TGateWayServerCom.SendCmdRefund(cmd: TCmdRefundC2S);
begin
  initCmd(cmd.CmdHead, C2S_REFUND, cmd.CmdEnd, SizeOf(TCmdRefundC2S));
  DirectSend(cmd, SizeOf(TCmdRefundC2S));
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

  terminalIdBuf := hexStrToByteBuf(getFixedLenStr(GlobalParam.TerminalId, 12, '0'), False);
  CopyMemory(@(cmdHead.TerminalId[0]), @terminalIdBuf[0], SizeOf(cmdHead.TerminalId));
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

procedure TGateWayServerCom.SetOnChargeDetailRsp(
  const Value: TOnChargeDetailRsp);
begin
  FOnChargeDetailRsp := Value;
end;

procedure TGateWayServerCom.SetOnGetMac2(const Value: TOnGetMac2);
begin
  FOnGetMac2 := Value;
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
    if Assigned(FOnChargeDetailRsp) then
      FOnChargeDetailRsp(pcmd^.Ret, pcmd^.RecordId);
  end;
end;

procedure TGateWayServerCom.dealCmdGetMac2Rsp(buf: array of Byte);
var
  pcmd: PCmdGetMac2ForChargeS2C;
  mac2: ansistring;
begin
  if Length(buf) >= SizeOf(TCmdGetMac2ForChargeS2C) then
  begin
    pcmd := PCmdGetMac2ForChargeS2C(@buf[0]);
    mac2 := bytesToHexStr(pcmd^.Mac2);
    if Assigned(FOnGetMac2) then
      FOnGetMac2(pcmd^.Ret, mac2);
  end;
end;

procedure TGateWayServerCom.dealCmdRefundRsp(buf: array of Byte);
var
  pcmd: PCmdRefundRspS2C;
begin
  if Length(buf) >= SizeOf(TCmdRefundRspS2C) then
  begin
    pcmd := PCmdRefundRspS2C(@buf[0]);
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
    //FSysLog.AddLog(IntToStr(pCmd^.Ret));
  end
end;

procedure TGateWayServerCom.SetFTimerEnabled(enabled: Boolean);
begin
  FTimer.Enabled := enabled;
end;

procedure TGateWayServerCom.ResendData(var buf; ABufSize: Integer; tip: string);
begin
  try
    DirectSend(buf, ABufSize);
  except

  end;
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
  p^.IsNeedResend := False;
  p^.CheckCount := 0;
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
begin
  i := 0;
  try
    while FList.Count > i do
    begin
      pcmd := Items[i];
      if (pcmd <> nil) and pcmd^.IsNeedResend then
      begin
        if pcmd^.CheckCount < 4 then
          pcmd^.CheckCount := pcmd^.CheckCount + 1
        else
        begin//如果已经达到4，则重发
//          if Assigned(FOnResendData) then
//            FOnResendData(pcmd^.content[0], pcmd^.ContentSize, pcmd^.Desc);
          Delete(pcmd^.Id);
          Continue;
        end;
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

