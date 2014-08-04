unit GatewayServerUnit;

interface
uses
  CmdStructUnit, Windows, Winsock, extctrls, sysutils, ScktCompUnit, math,
  ConstDefineUnit, IntegerListUnit, ScktComp, Types, BusinessServerUnit,
  classes, SystemLog, SyncObjs;

const
  SAVE_CMD_COUNT = 500; //������������ִ�е�������Ϣ

type

  TOnGetMac2 = procedure (ret: Byte; mac2: ansistring) of object;

  TCmdInfo = record //������Ϣ
    Id: integer; //����ID
    Flag: integer; //����ʲô����;
    DevId: integer; //����ID
    State: Byte; //0��ʾ�ѷ���δִ�У�1��ʾ��ִ�У�2��ʾִ�г���3��ʾ���û�ȡ�� , 4��ʾ��ȡ��,5��ʾȡ��ʧ�ܣ�6��ʾ�ط�  7-��ɾ����8-����� 9-��ʱ 10-��ʾ�Ѿ����͵�SMS���ͷ�����
    Desc: string; //��������
    SendTime: Tdatetime; //����ʱ��
    Replytime: Tdatetime; //ִ����ʱ��
    CancelTime: Tdatetime; //��ȡ��ʱ��
    Content: TByteDynArray; //�����������
    ContentSize: Integer;
    addesc: integer; //���״̬
    IsNeedResend: Boolean;//�Ƿ���Ҫ�ط�
    CheckCount: Byte;//����������ж�ʱ500ms���һ�ο����ط��������checkcount=4ʱ�����ط� ��֤��2~3�����·�
  end;
  PCmdInfo = ^TCmdInfo;

  //-------------���������
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

    function Add(const ACmdID: Integer): PCmdInfo; //--���һ������
    function Find(const ACmdID: Integer): PCmdInfo; //  Ѱ��һ������
    procedure Delete(const ACmdID: Integer); //  ɾ��һ������
    procedure ClearCmd; //�����������}
    property count: integer read GetCount; //---���������
    property Max_count: integer read FMax_count write SetMax_count; //----������������;
    property Items[Index: Integer]: PCmdInfo read GetItems; //======�����������  ��Ϣ
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
    procedure FSocketSocketEvent(Sender: TObject; Socket: TCustomWinSocket; SocketEvent: TSocketEvent);
    procedure FSockerWriteBufferOverflow(Sender: TObject);

    procedure dealCmdTYRet(buf: array of Byte);
    procedure dealCmdGetMac2Rsp(buf: array of Byte);
    procedure SetOnGetMac2(const Value: TOnGetMac2);

    procedure initCmd(var cmdHead: TSTHead; cmdId: Word; var cmdEnd: TSTEnd;
        cmdMinSize: Integer);

    function LoginToServer: Boolean;
  protected
    function DirectSend(var buf; ABufSize: Integer): Boolean; //�����ڲ��ķ��ͺ���ֱ�ӷ�������
    function GetMaxCmdSNo: Word;
    procedure DealReceiveData; virtual; //���� ���յ��ķ���������,������Ҫ�Ƿּ칤��
  public
    constructor Create;
    destructor Destroy; override;
    procedure ResendData(var buf; ABufSize: Integer; tip: string);
    procedure SendHeartbeat;
    procedure SendCmdGetMac2(chargeAmount: Integer; chargeTime, fakeRandom, mac1: string);
    procedure SendCmdUploadModuleStatus(moduleStatus: array of Byte);

    procedure SetFTimerEnabled(enabled: Boolean);

    property Host: string read FHost write SetHost; // Server Host ���ȼ���}
    property Address: string read FAddress write SetAddress; //Server Address IP ADDRESS
    property Port: Integer read FPort write SetPort;
    property UserId: Integer read FUserId write SetUserId;
    property UserPass: string read FUserPass write SetUserPass; //Register User Password
    property Active: Boolean read GetActive write SetActive; // Active��ʾ�˺ͷ�����������״̬
    property AutoLogin: Boolean read FAutoLogin write SetAutoLogin; // ����ͷ������Ͽ��Ƿ��Զ����µ�¼}
    property Socket: TClientSocketThread read FSocket;

    property OnGetMac2: TOnGetMac2 read FOnGetMac2 write SetOnGetMac2;
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

procedure TGateWayServerCom.DealReceiveData; // ������յ��ķ���������,������Ҫ�Ƿּ칤��
var
  readCount: Integer;
  buf: TByteDynArray;
  i: Integer;
  sIndex, eIndex: integer;
  cmdId: Word;
begin
  //first ���߳��ж�ȡ����,ע��,Ҫ�����̵߳�����ʱ��

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
          begin//�ҵ�β��ʶ
            if eIndex - sIndex + 1>= 14 then
            begin//�Ϸ���
              SetLength(buf, eIndex - sIndex + 1);
              CopyMemory(@buf[0], PtrAdd(FReadBuf.Data, sIndex), Length(buf));
              FReadBuf.WritePos := FReadBuf.WritePos - (eIndex + 1);
              CopyMemory(FReadBuf.Data, PtrAdd(FReadBuf.Data, eIndex + 1), FReadBuf.WritePos);
            end
            else
            begin//�ܰ������Ϸ���������ѭ��
              FReadBuf.WritePos := FReadBuf.WritePos - eIndex;
              CopyMemory(FReadBuf.Data, PtrAdd(FReadBuf.Data, eIndex), FReadBuf.WritePos);
              Continue;
            end;
          end
          else if (FReadBuf.writePos - sIndex <= 1024) then//�ȴ�������
          begin
            if sIndex > 0 then
            begin
              FReadBuf.WritePos := FReadBuf.WritePos - sIndex;
              CopyMemory(FReadBuf.Data, PtrAdd(FReadBuf.Data, sIndex), FReadBuf.WritePos);
              Break;
            end;
          end
          else
          begin//�޺Ϸ����ݣ�ֱ��ȫ������
            FReadBuf.WritePos := 0;
            Break;
          end;
        end
        else
        begin//�޺Ϸ����ݣ�ֱ��ȫ������
          FReadBuf.WritePos := 0;
          Break;
        end;

        buf := GetUnEscapedBuf(buf);
        cmdId := ByteOderConvert_Word(PWord(@buf[1])^);
        case cmdId of// PByte(PtrAdd(FReadBuf.Data, 2))^ of
          S2C_TYRET: dealCmdTYRet(buf);
          S2C_GET_MAC2_RSP: dealCmdGetMac2Rsp(buf);
        else
          begin
            FLog.AddLog('�������ݴ���:�����ֲ���ȷ ' + bytesToHexStr(wordToBytes(cmdId)));
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        FReadBuf.WritePos := 0;
        FLog.AddLog('�������ݴ���:�����쳣���쳣��ʾ:' + E.Message);
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

function TGateWayServerCom.DirectSend(var buf; ABufSize: Integer): Boolean; //�����ڲ��ķ��ͺ���ֱ�ӷ�������
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
      FSysLog.AddLog(' TGateWayServerCom.FTimerTimer��������: ', e.Message);
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

function TGateWayServerCom.LoginToServer: Boolean; // �û���¼���ط�����
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

procedure TGateWayServerCom.SendCmdGetMac2(chargeAmount: Integer;
  chargeTime, fakeRandom, mac1: string);
var
  cmd: TCmdGetMac2ForChargeC2S;
  tempBuf: TByteDynArray;
begin
  initCmd(cmd.CmdHead, C2S_GET_MAC2, cmd.CmdEnd, SizeOf(TCmdGetMac2ForChargeC2S));
  cmd.ChargeAmount := ByteOderConvert_LongWord(chargeAmount);
//  cmd.BizFlag := 0;
  tempBuf := hexStrToBytes(chargeTime);
  CopyMemory(@cmd.ChargeTime[0], @tempBuf[0], Min(Length(cmd.ChargeTime), Length(tempBuf)));
  tempBuf := hexStrToBytes(fakeRandom);
  CopyMemory(@cmd.FakeRandom[0], @tempBuf[0], Min(Length(cmd.FakeRandom), Length(tempBuf)));
  tempBuf := hexStrToBytes(mac1);
  CopyMemory(@cmd.Mac1[0], @tempBuf[0], Min(Length(cmd.Mac1), Length(tempBuf)));
  DirectSend(cmd, SizeOf(TCmdGetMac2ForChargeC2S));
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

  tempBuf[index] := CMD_END_FLAG;
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
  if not Active then PopMsg('������ʾ', '�����ط�����' + #13 + #10 + '���Ӳ�����' + #13 + #10 + ',���ܷ�������');
end;

procedure TGateWayServerCom.SendHeartbeat;
var
  cmd: TCmdHeartbeatC2S;
begin
  initCmd(cmd.CmdHead, C2S_HEARTBEAT, cmd.CmdEnd, SizeOf(TCmdHeartbeatC2S));

  DirectSend(cmd, SizeOf(TCmdHeartbeatC2S));
end;

procedure TGateWayServerCom.SetOnGetMac2(const Value: TOnGetMac2);
begin
  FOnGetMac2 := Value;
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
  //�������SAVE_CMD_COUNT������ɾ��ǰ��ġ�
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
        begin//����Ѿ��ﵽ4�����ط�
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

