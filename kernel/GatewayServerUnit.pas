unit GatewayServerUnit;

interface
uses
  CmdStructUnit, Windows, Winsock, extctrls, sysutils, ScktCompUnit, math,
  ConstDefineUnit, IntegerListUnit, ScktComp, Types, BusinessServerUnit,
  classes, SystemLog, SyncObjs;

const
  SAVE_CMD_COUNT = 500; //������������ִ�е�������Ϣ

type

  TOnGetMac2 = procedure (ret: Byte; mac2, tranSNo, errTip: ansistring) of object;
  TOnChargeDetailRsp = procedure(ret: Byte; recordId: Int64) of object;
  TOnRefundRsp = procedure(ret: Byte; recordId: LongWord) of object;
  TOnChargeCardCheckRsp = procedure(ret: Byte; amount:Integer) of object;
  TOnQueryQFTBalanceRsp = procedure(ret: Byte; amount:Integer) of object;
  TOnModifyZHBPassRsp = procedure(ret:Byte) of object;
  TOnLoginStatusChanged = procedure(loginStatus: Byte) of object;
  TOnGetCityCardType = procedure(ret: Byte) of object;

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

    procedure initCmd(var cmdHead: TSTHead; cmdId: Word; var cmdEnd: TSTEnd; cmdMinSize: Integer);

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
    function DirectSend(var buf; ABufSize: Integer): Boolean; //�����ڲ��ķ��ͺ���ֱ�ӷ�������
    function GetMaxCmdSNo: Word;
    procedure DealReceiveData; virtual; //���� ���յ��ķ���������,������Ҫ�Ƿּ칤��
  public
    constructor Create;
    destructor Destroy; override;
    procedure ResendData(var buf; ABufSize: Integer; tip: string);
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

    procedure SetFTimerEnabled(enabled: Boolean);

    property Host: string read FHost write SetHost; // Server Host ���ȼ���}
    property Address: string read FAddress write SetAddress; //Server Address IP ADDRESS
    property Port: Integer read FPort write SetPort;
    property UserId: Integer read FUserId write SetUserId;
    property UserPass: string read FUserPass write SetUserPass; //Register User Password
    property Active: Boolean read GetActive write SetActive; // Active��ʾ�˺ͷ�����������״̬
    property AutoLogin: Boolean read FAutoLogin write SetAutoLogin; // ����ͷ������Ͽ��Ƿ��Զ����µ�¼}
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
          S2C_LOGIN_RSP: dealCmdLoginRsp(buf);
          S2C_GET_MAC2_RSP: dealCmdGetMac2Rsp(buf);
          S2C_CHARGE_DETAIL_RSP: dealCmdChargeDetailRsp(buf);
          S2C_REFUND_RSP: dealCmdRefundRsp(buf);
          S2C_PRE_CARD_CHECK_RSP: dealCmdChargeCardCheckRsp(buf);
          S2C_QUERY_QFT_BALANCE: dealCmdQueryQFTBalanceRsp(buf);
          S2C_MODIFY_PASS_RSP: dealCmdModifyZHBPassRsp(buf);
          S2C_CHECK_CITY_CARD_TYPE_RSP: dealCmdCheckCityCardType(buf);
          S2C_ENABLE_STATUS_CHANGED:dealCmdEnableStatusChanged(buf);
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
        LoginToServer;
        FLoginStatus := LOGIN_STATUS_NO_RSP;
        if Assigned(FOnLoginStatusChanged) then
          FOnLoginStatusChanged(FLoginStatus);
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
end;

procedure TGateWayServerCom.SendCmdChargeDetail(cmd: TCmdChargeDetailC2S);
begin
  initCmd(cmd.CmdHead, C2S_CHARGE_DETAIL, cmd.CmdEnd, SizeOf(TCmdChargeDetailC2S));
  DirectSend(cmd, SizeOf(TCmdChargeDetailC2S));
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
end;

procedure TGateWayServerCom.SendCmdClearCashBox(cashAmount: Integer);
var
  cmd: TCmdClearCashBoxC2S;
begin
  initCmd(cmd.CmdHead, C2S_CLEAR_CASHBOX, cmd.CmdEnd, SizeOf(TCmdClearCashBoxC2S));
  cmd.CashAmount := ByteOderConvert_LongWord(cashAmount);
  DirectSend(cmd, SizeOf(TCmdClearCashBoxC2S));
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

  cmdHead.TerminalId := ByteOderConvert_LongWord(StrToInt(GlobalParam.TerminalId));
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
    cityCardNo := bytesToHexStr(pcmd^.CityCardNo);
    if cityCardNo <> currCityCardNo then
    begin//�������˷��ؿ����뵱ǰ��⵽�Ŀ��Ų�һ�£��������֮ǰ������أ��˴�ֱ�Ӳ�������
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
    terminalId := ByteOderConvert_LongWord(pcmd^.CmdHead.TerminalId);
    if GlobalParam.TerminalId = IntToStr(terminalId) then
    begin
      if Assigned(FOnLoginStatusChanged) then
      begin
        case pcmd^.Status of
          0: FOnLoginStatusChanged(0);//����
          1: FOnLoginStatusChanged(3);//��ͣ
        end;
      end;
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

procedure TGateWayServerCom.dealCmdLoginRsp(buf: array of Byte);
var
  pcmd: PCmdLoginRspS2C;
begin
  if Length(buf) >= SizeOf(TCmdLoginRspS2C) then
  begin
    pcmd := PCmdLoginRspS2C(@buf[0]);
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

