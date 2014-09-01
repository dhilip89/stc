{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O-,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
unit ThreadsUnit;

interface
uses
  System.classes, FrmWaitingUnit;//, Vcl.StdCtrls;

type
  TOnGetCityCardInfo = procedure (cardInfo: string) of object;
  TOnGetCardBalance = procedure (cardBalance: Integer) of object;
  TOnQueryCityCardDetail = procedure (transDate, transTime, transTerminalId: ansistring;
                                      transType, transAmount: Integer) of object;
  TBaseThread = class(TThread)
  private
    frmWaiting: TfrmWaiting;
    timeout: Integer;
  protected
    {0:����  1: ���ؼ���ѭ��ִ��  2���ؼ������ǵȴ��ɽ����ֱ���˳���������
     3:ִ��ʧ�ܣ�������Ǯ  4:��ֵ�����˻�����������˳����û�����ȷ��
    }
    taskRet: Byte;
    amountRefund: Integer;//�˿���
    errInfo: string;//�������ʧ�ܣ���д������ʾ
    FIsCmdRet: Boolean;
    procedure Execute; override;
    procedure setWaitingTip(tip: string;isHideProgressBar: Boolean = False);
    function doTask: Boolean; virtual; abstract;
    procedure DoOnTaskOK; virtual; //ִ��˳��
    procedure DoOnTaskTimeout; virtual;//ִ�г�ʱ
    procedure DoOnTaskFail; virtual;//�����йؼ�����ʧ�ܣ��ǵȴ��ɽ���ģ���ǰ�˳�
    procedure DoOnTaskWithRefund;virtual;//��Ҫ������Ǯ��ӡƾ��
    procedure DoOnTaskRetry; virtual;//���û�����ȷ����Ϣ�����治��ת
    procedure printRefundInfo(amount: Integer; cardNo: ansistring);

    function waitForCmdRet: Boolean;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer); virtual;
    destructor Destroy; override;
  end;

  //��ȡ�������
  TQueryCityCardBalance = class(TThread)
  private
    frmWaiting: TfrmWaiting;
    timeout: Integer;
    FOnGetCityCardInfo: TOnGetCityCardInfo;
    FOnGetCardBalance: TOnGetCardBalance;
//    FEdtCardInfo: TCustomEdit;
//    FEdtCardBalance: TCustomEdit;
    function doTask: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer);//; edtCardInfo, edtCardBalance: TCustomEdit);
    destructor Destroy; override;

    property OnGetCityCardInfo: TOnGetCityCardInfo read FOnGetCityCardInfo write FOnGetCityCardInfo;
    property OnGetCardBalance: TOnGetCardBalance read FOnGetCardBalance write FOnGetCardBalance;
  end;

  //��ѯ������ϸ
  TQueryCityCardTransDetail = class(TBaseThread)
  private
    FOnQueryCityCardDetail: TOnQueryCityCardDetail;
    procedure SetOnQueryCityCardDetail(const Value: TOnQueryCityCardDetail);
  protected
    function doTask: Boolean; override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer);
    destructor Destroy; override;

    property OnQueryCityCardDetail: TOnQueryCityCardDetail read FOnQueryCityCardDetail write SetOnQueryCityCardDetail;
  end;

  //��ȡֽ���ܶ�
  TGetCashAmount = class(TBaseThread)
  private
    FCashAmount: Integer;
    FAmountRead: Integer;
  protected
    function doTask: Boolean;override;
    procedure DoOnTaskTimeout;override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting;
      timeout: Integer; cashAmount: Integer);
  end;

  //��ֵ���׹���
  TCityCardCharge = class(TBaseThread)
  private
    FChargeAmount: Integer;
    FMac2: AnsiString;
    FIsMac2Got: Boolean;
    FBalanceAfterCharge: Integer;
    function waitForMac2: Boolean;
  protected
    function doTask: Boolean; override;
    procedure DoOnTaskTimeout; override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout, cashAmount: Integer);

    procedure noticeMac2Got(mac2: AnsiString);

    property BalanceAfterCharge: Integer read FBalanceAfterCharge;
  end;

  //��ֵ��У������
  TChargeCardCheck = class(TBaseThread)
  private
    FCityCardNo: AnsiString;
    FPassword: AnsiString;

    FRet: Byte;
    FAmount: Integer;
  protected
    function doTask: Boolean; override;
    procedure DoOnTaskTimeout; override;//ִ�г�ʱ
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer;
      cityCardNo, password: AnsiString);virtual;

    procedure noticeCmdRet(ret: Byte; amount: Integer);
  end;

  //�˻�������ѯ
  TQueryZHBBalance = class(TBaseThread)
  private
    FCityCardNo: AnsiString;
    FPassword: AnsiString;

    FRet: Byte;
    FAmount: Integer;
  protected
    function doTask: Boolean; override;
    procedure DoOnTaskTimeout; override;//ִ�г�ʱ
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting;
      timeout: Integer; cityCardNo, password: string);

    procedure noticeCmdRet(ret: Byte; amount: Integer);
    property Balance: Integer read FAmount;
  end;

  TModifyZHBPass = class(TBaseThread)
  private
    FOldPass, FNewPass: AnsiString;
    FRet: Byte;

    function waitForModifyRet: Boolean;
  protected
    function doTask: Boolean; override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting;
      timeout: Integer; oldPass, newPass: ansistring);

    procedure noticeCmdRet(ret: Byte);
  end;

const
  BILL_OK = '9000';

implementation
uses
  System.Types, System.SysUtils, System.DateUtils, drv_unit, uGloabVar,
  Winapi.Windows, CmdStructUnit, itlssp, System.Math;

{ TQueryCityCardBalance }

function checkRecvBufEndWith9000(recvBuf: array of AnsiChar; dataLen: Integer): AnsiString;
var
  tempStr: AnsiString;
begin
  SetLength(tempStr, 4);
  CopyMemory(@tempStr[1], @recvBuf[dataLen * 2 - 4], 4);
  Result := tempStr;
end;

constructor TQueryCityCardBalance.Create(CreateSuspended:Boolean; dlg: TfrmWaiting;
  timeout: Integer);//; edtCardInfo, edtCardBalance: TCustomEdit);
begin
  inherited Create(CreateSuspended);
  Self.frmWaiting := dlg;
  Self.timeout := timeout;
//  FEdtCardInfo := edtCardInfo;
//  FEdtCardBalance := edtCardBalance;
  FreeOnTerminate := True;
end;

destructor TQueryCityCardBalance.Destroy;
begin
  inherited;
end;

function TQueryCityCardBalance.doTask: Boolean;
var
  sendLen, recvLen: SmallInt;
  sendBuf: array[0..512] of AnsiChar;
  recvBuf: array[0..512] of AnsiChar;
  ret: SmallInt;
  sendHexStr: ansistring;
  tempStr: AnsiString;
  offset:Integer;
  tempInt: Integer;
  cardInfo: string;
  balance: Integer;
begin
  {$IFDEF test}
    Sleep(1000);
    currCityCardNo := '1234567890123456';
    currCityCardBalance := 12345;

    if Assigned(FOnGetCityCardInfo) then
      FOnGetCityCardInfo(currCityCardNo);

    if Assigned(FOnGetCardBalance) then
      FOnGetCardBalance(currCityCardBalance);

    Result := True;
    Exit;
  {$ENDIF}

  Result := False;
  if not resetD8 then
  begin
    Exit;
  end;

  sendHexStr := '00B0950000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    addSysLog('read card base info err, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 8 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardInfo := tempStr;//'����:'
  currCityCardNo := tempStr;

//    Inc(offset, 20 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('��Ƭ��������:' + tempStr);
//
//    Inc(offset, 4 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('��ƬʧЧ����:' + tempStr);
  {
  //��Ƭ������Ϣ
  sendHexStr := '00B0960000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    addSysLog('read card user info err, recvBuf:' + recvBuf);
    Exit;
  end;
  offset := 2*2;
  SetLength(tempStr, 20 * 2);

  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardInfo := cardInfo + '(' + bytesToStr(hexStrToByteBuf(tempStr, false)) + ')';//�ֿ�������  }
  if Assigned(FOnGetCityCardInfo) then
    FOnGetCityCardInfo(cardInfo);

//    Inc(offset, 20 * 2);
//    SetLength(tempStr, 18 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('�ֿ���֤������:' + bytesToStr(hexStrToByteBuf(tempStr, false)));
//
//    Inc(offset, 23 * 2);
//    SetLength(tempStr, 20 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('��ϵ�绰:' + bytesToStr(hexStrToByteBuf(tempStr, false)));

  //��Ƭ���
  sendHexStr := '805C000204';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));
  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    addSysLog('read card balance err, recvBuf:' + recvBuf);
    Exit;
  end;
  offset := 0;
  SetLength(tempStr, 4 * 2);

  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tempInt := bytesToInt(hexStrToByteBuf(tempstr, False), 0, false);
  //Memo1.Lines.Add('��Ƭ���:' + FormatFloat('0.##', tempInt / 100.0) + 'Ԫ');
  balance := tempInt;
  currCityCardBalance := balance;
  if Assigned(FOnGetCardBalance) then
    FOnGetCardBalance(balance);

  Result := True;
end;

procedure TQueryCityCardBalance.Execute;
var
  sTime: TDateTime;
  isTimeout: Boolean;
begin
  sTime := Now;
  isTimeout := False;
  while not doTask do
  begin
    if SecondsBetween(now, stime) < timeout then
    begin
      Sleep(500);
      Continue;
    end;
    isTimeout := True;
    Break;
  end;
  if not isTimeout then
  begin
    frmWaiting.noticeMROK;
  end
  else
  begin
    frmWaiting.noticeTimeout;
  end;
end;

{ TBaseThread }

constructor TBaseThread.Create(CreateSuspended: Boolean; dlg: TfrmWaiting;
  timeout: Integer);
begin
  inherited Create(CreateSuspended);
  Self.frmWaiting := dlg;
  Self.timeout := timeout;
  FreeOnTerminate := True;
end;

destructor TBaseThread.Destroy;
begin
  inherited;
end;

procedure TBaseThread.DoOnTaskFail;
begin
  if errInfo <> '' then
  begin
    setWaitingTip(errInfo, True);
    Sleep(5000);
  end;
  frmWaiting.noticeFail;
end;

procedure TBaseThread.DoOnTaskOK;
begin
  frmWaiting.noticeMROK;
end;

procedure TBaseThread.DoOnTaskRetry;
begin
  if errInfo <> '' then
  begin
    setWaitingTip(errInfo, True);
    Sleep(3000);
  end;
  frmWaiting.noticeRetry;
end;

procedure TBaseThread.DoOnTaskTimeout;
begin
  frmWaiting.noticeTimeout;
end;

procedure TBaseThread.DoOnTaskWithRefund;
begin
  if errInfo <> '' then
  begin
    setWaitingTip(errInfo, True);
    Sleep(5000);
  end;
  printRefundInfo(amountRefund, currCityCardNo);
  frmWaiting.noticeFail;
end;

procedure TBaseThread.Execute;
var
  sTime: TDateTime;
  isTimeout: Boolean;
begin
  sTime := Now;
  isTimeout := False;
  taskRet := 0;
  addSysLog(Self.ClassName + ' execute');
  while not doTask do
  begin
    if taskRet in [2, 3, 4] then
    begin
      Break;
    end;

    if SecondsBetween(now, stime) < timeout then
    begin
      Sleep(500);
      Continue;
    end;
    isTimeout := True;
    Break;
  end;
  if not isTimeout then
  begin
    if taskRet = 0 then
    begin
      DoOnTaskOK;
    end
    else if taskRet = 2 then
    begin
      DoOnTaskFail;
    end
    else if taskRet = 3 then
    begin
      DoOnTaskWithRefund;
    end
    else if taskRet = 4 then
    begin
      DoOnTaskRetry;
    end;
  end
  else
  begin
    DoOnTaskTimeout;
  end;
end;

procedure TBaseThread.printRefundInfo(amount: Integer; cardNo: ansistring);
var
  cmd: TCmdRefundC2S;
  buf: TByteDynArray;

  printInfo: AnsiString;
begin
  buf := hexStrToBytes(cardNo);
  CopyMemory(@cmd.CityCardNo[0], @buf[0], Length(buf));
  cmd.Amount := ByteOderConvert_LongWord(amount * 100);
  buf := hexStrToBytes(FormatDateTime('yyyyMMddHHnnss', Now));
  CopyMemory(@cmd.Time[0], @buf[0], Length(buf));
  DataServer.SendCmdRefund(cmd);

  printInfo := '�˿�ƾ֤'#13#10
             + '---------------------------'#13#10
             + '����:' + cardNo + #13#10
             + '���:' + IntToStr(amount) + 'Ԫ'#13#10
             + 'ʱ��:' + FormatDateTime('yyyy-MM-dd hh:nn:ss', now) + #13#10
             + '---------------------------'#13#10
             + 'ע:���ƾ֤���˹������˿�';
  printContent(printInfo);
end;

procedure TBaseThread.setWaitingTip(tip: string; isHideProgressBar: Boolean);
begin
  frmWaiting.setWaitingTip(tip, isHideProgressBar);
end;

function TBaseThread.waitForCmdRet: Boolean;
var
  stime: TDateTime;
  isTimeout: Boolean;
begin
  stime := Now;
  isTimeout := False;
  while not FIsCmdRet do
  begin
    if SecondsBetween(Now, stime) < Self.timeout then
    begin
      Sleep(200);
      Continue;
    end;
    isTimeout := True;
    Break;
  end;
  Result := not isTimeout;
end;

{ TGetCashAmount }

constructor TGetCashAmount.Create(CreateSuspended: Boolean; dlg: TfrmWaiting;
  timeout, cashAmount: Integer);
begin
  inherited Create(CreateSuspended, dlg, timeout);
  FCashAmount := cashAmount;
end;

procedure TGetCashAmount.DoOnTaskTimeout;
begin
  if FAmountRead > 0 then
  begin
    setWaitingTip('�ȴ���ʱ����ȡ��ʧ��ƾ֤');
    Sleep(3000);
  end;
  inherited;
end;

function TGetCashAmount.doTask: Boolean;
var
  tip: string;
  sspCmd: TSSP_Command;
  sspCmdInfo: TSSP_Command_Info;
  i, j: Integer;
  cashAmount: array[0..7] of Byte; //0�ò�����ͨ���Ŵ�1��ʼ��
  channelCount: Integer;
  tempAmount: Integer;
  totalAmount: Integer;
  st: TDateTime;
begin
  Result := False;
  tip := '�� �� �� �� ��:%-3dԪ'#13#10 +
         '�� Ͷ �� �� ��:%-3dԪ';
  setWaitingTip(Format(tip, [FCashAmount div 100, 0]));

  {$IFDEF test}
    Sleep(2000);
    FAmountRead := FCashAmount div 100;
    setWaitingTip(Format(tip, [FCashAmount div 100, FAmountRead]));
    Sleep(2000);
    Result := True;
    taskRet := 0;
    Exit;
  {$ENDIF}

  totalAmount := FCashAmount;
  FAmountRead := 0;
  cashAmount[0] := 0;
  tempAmount := 0;

  //���ô��ڲ���
  sspCmd.SSPAddress := 0;
  sspCmd.BaudRate := 9600;
  sspCmd.Timeout := 1000;
  sspCmd.RetryLevel := 3;
  sspCmd.PortNumber := GlobalParam.ITLPort;
  sspCmd.EncryptionStatus := 0;

  //�򿪴���
  try
//    addSysLog('open ssp com');
//    i := OpenSSPComPort(@sspCmd);
//    if (i = 0) then
//    begin
//      taskRet := 2;
//      errInfo := 'ֽ�����޷���������';
//      //ShowMessage('���ڴ�ʧ��');
//      Exit;
//    end;

    //���� 0x11 ���������ʶ�����Ƿ�����
    sspCmd.CommandData[0] := $11;
    sspCmd.CommandDataLength := 1;
    if SSPSendCommand(@sspCmd, @sspCmdInfo) = 0then
    begin
      taskRet := 2;
      errInfo := 'ֽ�����޷���������';
      //ShowMessage('����ʶ�����Ƿ���������ִ��ʧ��');
      Exit;
    end;

    //��ȡͨ������
    sspCmd.CommandData[0] := $0E;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
    begin
      taskRet := 2;
      errInfo := 'ֽ�����޷���������';
      //ShowMessage('��ȡͨ����������ִ��ʧ��');
      Exit;
    end;
    if sspCmd.ResponseData[0] = $F0 then
    begin
      channelCount := sspCmd.ResponseData[1];
      for I := 2 to 2 + channelCount - 1 do
      begin
        cashAmount[i - 1] := sspCmd.ResponseData[I];
      end;
    end;
    //Memo1.Lines.Add(BufferToHex(@(cashAmount[1]), 6));

    //disable
    sspCmd.CommandData[0] := $09;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
    begin
      taskRet := 2;
      errInfo := 'ֽ�����޷���������';
      //ShowMessage('disableʧ��');
      Exit;
    end;

    //set���õ�ͨ��
    sspCmd.CommandData[0] := $02;
    sspCmd.CommandData[1] := $B0;
    sspCmd.CommandData[2] := $00;
    sspCmd.CommandDataLength := 3;
    if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
    begin
      taskRet := 2;
      errInfo := 'ֽ�����޷���������';
      //ShowMessage('����ͨ������ʧ��');
      Exit;
    end;

    //enable
    sspCmd.CommandData[0] := $0A;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
    begin
      taskRet := 2;
      errInfo := 'ֽ�����޷���������';
      //ShowMessage('enableʧ��');
      Exit;
    end;

    //poll
    st := now;
    while (SecondsBetween(st, Now) < Self.timeout) do
    begin
      if totalAmount - FAmountRead = 50 then
      begin//���ý���50��
        sspCmd.CommandData[0] := $02;
        sspCmd.CommandData[1] := $90;
        sspCmd.CommandData[2] := $00;
        sspCmd.CommandDataLength := 3;
        if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
        begin
          taskRet := 3;
          errInfo := 'ֽ�����޷���������';
          //ShowMessage('����50Ԫͨ��ʧ��');
          Exit;
        end;
      end;

      sspCmd.CommandData[0] := $07;
      sspCmd.CommandDataLength := 1;
      if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
      begin
        taskRet := 3;
        errInfo := 'ֽ�����޷���������';
        //ShowMessage('poll ʧ��');
        Exit;
      end;
  //    Memo1.Lines.Add(IntToStr(sspCmd.ResponseDataLength));
  //    Memo1.Lines.Add(BufferToHex(@(sspCmd.ResponseData[0]), sspCmd.ResponseDataLength));
      if sspCmd.ResponseData[0] = $F0 then
      begin
        j := 1;
        while j < sspCmd.ResponseDataLength do
        begin
          case sspCmd.ResponseData[j] of
            $CC:;//stacking
            $EB:
              begin
                Inc(FAmountRead, tempAmount);//stacked;
                tempAmount := 0;
                setWaitingTip(Format(tip, [FCashAmount div 100, FAmountRead]));
                //Memo1.Lines.Add('totalAmount:' + IntToStr(amountRead));
              end;
            $EC: tempAmount := 0;
            $ED: tempAmount := 0;
            $EE://detecting cash
              begin
                tempAmount := cashAmount[sspCmd.ResponseData[j + 1]];
                //Memo1.Lines.Add('tempAount=' + IntToStr(tempAmount));
                Inc(j);
              end;
            $EF:;//reading
          end;
          Inc(j);
        end;
      end;
      if (FAmountRead >= totalAmount) then
      begin
        Sleep(100);
        Break;
      end;
      Sleep(400);
    end;
    //Memo1.Lines.Add('totalAmount:' + IntToStr(amountRead));
  finally
//    addSysLog('close ssp com');
//    CloseSSPComPort;
    if taskRet = 3 then
    begin
      if FAmountRead > 0 then
      begin//�ڶ��������г��ִ���
        amountRefund := FAmountRead;
      end
      else
      begin//��û���̹���Ʊ��״̬��Ϊ2
        taskRet := 2;
      end;
    end;
  end;
  if (FAmountRead < totalAmount) then
  begin//timeout and amount is not enough
    Exit;
  end;
  taskRet := 0;
  Result := True;
end;

{ TCityCardCharge }

constructor TCityCardCharge.Create(CreateSuspended: Boolean; dlg: TfrmWaiting;
  timeout, cashAmount: Integer);
begin
  inherited Create(CreateSuspended, dlg, timeout);
  FreeOnTerminate := False;
  FChargeAmount := cashAmount * 100;
end;

procedure TCityCardCharge.DoOnTaskTimeout;
begin
  setWaitingTip('��ֵ���׳�ʱ����ȡ��ʧ��ƾ֤');
  Sleep(3000);
  inherited;
end;

function TCityCardCharge.doTask: Boolean;
var
  tip: string;
  cardNo, asn, tsn: TByteDynArray;
  OperType: Byte; //�������� 00�ֽ��ֵ��01���п���ֵ��02��ֵ����ֵ��03�˻�����ֵ/ר���˻���ֵ
  oldBalance: Integer;//��ֵǰ���
  chargeTime, fakeRandom, mac1: TByteDynArray;
  sendLen, recvLen: SmallInt;
  sendBuf: array[0..512] of AnsiChar;
  recvBuf: array[0..512] of AnsiChar;
  ret: SmallInt;
  sendHexStr: ansistring;
  tempStr: AnsiString;
  offset: Integer;
  lw: LongWord;
  tempBuf: TByteDynArray;
  strChargeAmount: string;
  strTerminalId: string;
  cardType: Byte;
  tac: TByteDynArray;
  transSNo: LongWord;
  cmd: TCmdChargeDetailC2S;
  billStatus: AnsiString;
begin
  {$IFDEF test}
    Sleep(1000);
    taskRet := 0;
    FBalanceAfterCharge := currCityCardBalance + amountCharged;
    Result := True;
    Exit;
  {$ENDIF}
  Result := False;
//  tip := '���ڽ��г�ֵ���������ƿ���Ƭ...';//#13#10 + '��Ƭ��ȡ��...';
//  setWaitingTip(tip);
  if not resetD8 then
  begin
    taskRet := 1;
    addSysLog('citycard charge reset d8 fail');
    Exit;
  end;

  //�������ź�Ӧ�����к�
  sendHexStr := '00B0950000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 3;
    errInfo := '��ֵʧ�ܣ���ע�Ᵽ��ƾ��';
    addSysLog('�����ź�Ӧ�����л�ʧ��, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 8 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardNo := hexStrToBytes(tempStr);//����

  offset := 20;
  SetLength(tempStr, 10 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  asn := hexStrToBytes(tempStr);//Ӧ�����к�

  //����������
  sendHexStr := '00B0960000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 3;
    errInfo := '��ֵʧ�ܣ���ע�Ᵽ��ƾ��';
    addSysLog('��������ʧ��, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 1 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardType := hexStrToBytes(tempStr)[0];//������

  //Ȧ���ʼ��
  lw := ByteOderConvert_LongWord(FChargeAmount);
  strChargeAmount := bytesToHexStr(LongWordToBytes(lw));
  strTerminalId := getFixedLenStr(GlobalParam.TerminalId, 12, '0');
  sendHexStr := '805000020B01' + strChargeAmount + strTerminalId + '10';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  billStatus := checkRecvBufEndWith9000(recvBuf, recvLen);
  if (ret <> 0) or (billStatus <> BILL_OK) then
  begin
    taskRet := 3;
    errInfo := '��ֵʧ�ܣ���ע�Ᵽ��ƾ��';
    addSysLog('initialize for load err, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  oldBalance := bytesToInt(hexStrToBytes(tempStr), 0, False);//��ֵǰ���
  FBalanceAfterCharge := FChargeAmount + oldBalance;

  offset := 8;
  SetLength(tempStr, 4);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tsn := hexStrToBytes(tempStr);//�������

  offset := 16;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  fakeRandom := hexStrToBytes(tempStr);//�����

  offset := 24;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  mac1 := hexStrToBytes(tempStr);//mac1

//  tip := '���ڽ��г�ֵ���������ƿ���Ƭ'#13#10 + '��Ƭ����У����...';
//  setWaitingTip(tip);
  chargeTime := hexStrToBytes(FormatDateTime('yyyyMMddhhnnss', Now));
  DataServer.SendCmdGetMac2(cardNo, asn, tsn, OperType, oldBalance, FChargeAmount, chargeTime, fakeRandom, mac1);
  if not waitForMac2 then
  begin//��ʱ
    taskRet := 3;
    errInfo := '��ֵʧ�ܣ���ע�Ᵽ��ƾ��';
    addSysLog('credit for load err, recvBuf:' + recvBuf);
    Exit;
  end;

//  tip := '���ڽ��г�ֵ���������ƿ���Ƭ'#13#10 + 'д����...';
//  setWaitingTip(tip);
  sendHexStr := '805200000B' + bytesToHexStr(chargeTime) + FMac2 + '04';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  billStatus := checkRecvBufEndWith9000(recvBuf, recvLen);
  if (ret <> 0) or (billStatus <> BILL_OK) then
  begin
    taskRet := 3;
    errInfo := '��ֵʧ�ܣ���ע�Ᵽ��ƾ��';
    addSysLog('credit for load err, recvBuf:' + recvBuf);
    Exit;
  end;
  //Ȧ��ɹ�����ȡtacֵ
  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tac := hexStrToBytes(tempStr);//�����

  transSNo := getNextTSN;//��ȡ������ˮ��

  //��ֵ�ɹ����ϴ����׼�¼�������
  CopyMemory(@cmd.ASN, @asn[0], Length(asn));
  CopyMemory(@cmd.TSN, @tsn[0], Length(tsn));
  initBytes(cmd.BankCardNo, $00);
  cmd.CardType := cardType;
  CopyMemory(@cmd.TransDate, @chargeTime[0], Length(cmd.TransDate));
  CopyMemory(@cmd.TransTime, @chargeTime[4], Length(cmd.TransTime));
  cmd.TransAmount := ByteOderConvert_LongWord(FChargeAmount);
  cmd.BalanceBeforeTrans := ByteOderConvert_LongWord(oldBalance);
  CopyMemory(@cmd.TAC, @tac[0], Length(tac));
  cmd.TransSNo := ByteOderConvert_LongWord(transSNo);
  //��ֵ����
  cmd.ChargeType := currChargeType;
  if (currChargeType <> 0) then
  begin
    CopyMemory(@cmd.BankCardNo[0], @BytesOf(bankCardNoOrPassword)[0], Min(Length(cmd.BankCardNo), Length(bankCardNoOrPassword)));
  end;
  CopyMemory(@cmd.CityCardNo, @cardNo[0], Length(cardNo));

  DataServer.SendCmdChargeDetail(cmd);

  Result := True;
end;

procedure TCityCardCharge.noticeMac2Got(mac2: AnsiString);
begin
  FMac2 := mac2;
  FIsMac2Got := True;
end;

function TCityCardCharge.waitForMac2: Boolean;
var
  stime: TDateTime;
  isTimeout: Boolean;
begin
  stime := Now;
  isTimeout := False;
  while not FIsMac2Got do
  begin
    if SecondsBetween(Now, stime) < Self.timeout then
    begin
      Sleep(500);
      Continue;
    end;
    isTimeout := True;
    Break;
  end;
  Result := not isTimeout;
end;

{ TChargeCardCheck }

constructor TChargeCardCheck.Create(CreateSuspended: Boolean; dlg: TfrmWaiting;
  timeout: Integer; cityCardNo, password: AnsiString);
begin
  inherited Create(CreateSuspended, dlg, timeout);
  FCityCardNo := cityCardNo;
  FPassword := password;
  FreeOnTerminate := False;
end;

procedure TChargeCardCheck.DoOnTaskTimeout;
begin
  setWaitingTip('У�鳬ʱ�����Ժ�����');
  Sleep(3000);
  inherited;
end;

function TChargeCardCheck.doTask: Boolean;
begin
  Result := False;

  FIsCmdRet := False;
  DataServer.SendCmdChargeCardCheck(FCityCardNo, FPassword);
  if not waitForCmdRet then
  begin
    Exit;
  end;

  if FRet = 0 then
  begin
    taskRet := 2;
    errInfo := '��ֵ��У��ʧ�ܣ���ȷ��������ȷ';
    Exit;
  end;

  taskRet := 0;
  Result := True;
end;

procedure TChargeCardCheck.noticeCmdRet(ret: Byte; amount: Integer);
begin
  FRet := ret;
  FAmount := amount;
  FIsCmdRet := True;
  currPrepaidCardAmount := FAmount;
end;

{ TQueryQFTBalance }

constructor TQueryZHBBalance.Create(CreateSuspended: Boolean; dlg: TfrmWaiting;
  timeout: Integer; cityCardNo, password: string);
begin
  inherited Create(CreateSuspended, dlg, timeout);
  FCityCardNo := cityCardNo;
  FPassword := password;
  FreeOnTerminate := False;
end;

procedure TQueryZHBBalance.DoOnTaskTimeout;
begin
  setWaitingTip('��ѯ�˻�����ʱ�����Ժ�����');
  Sleep(3000);
  inherited;
end;

function TQueryZHBBalance.doTask: Boolean;
begin
  addSysLog('query zhb balance');
  Result := False;

  FIsCmdRet := False;
  DataServer.SendCmdQueryQFTBalance(FCityCardNo, FPassword);
  if not waitForCmdRet then
  begin
    Exit;
  end;

  if FRet = 0 then
  begin
    taskRet := 2;
    errInfo := '�˻�������ѯʧ�ܣ���ȷ������';
    Exit;
  end;
  if (FRet = 2) then
  begin
    taskRet := 4;
    errInfo := '�˻������벻��ȷ����ȷ��';
    Exit;
  end;
  taskRet := 0;
  Result := True;
end;

procedure TQueryZHBBalance.noticeCmdRet(ret: Byte; amount: Integer);
begin
  FRet := ret;
  FAmount := amount;
  FIsCmdRet := True;
  currZHBBalance := FAmount;
end;

{ TQueryCityCardTransDetail }

constructor TQueryCityCardTransDetail.Create(CreateSuspended: Boolean;
  dlg: TfrmWaiting; timeout: Integer);
begin
  inherited Create(CreateSuspended, dlg, timeout);
end;

destructor TQueryCityCardTransDetail.Destroy;
begin
  inherited;
end;

function TQueryCityCardTransDetail.doTask: Boolean;
var
  sendLen, recvLen: SmallInt;
  sendBuf: array[0..512] of AnsiChar;
  recvBuf: array[0..512] of AnsiChar;
  ret: SmallInt;
  sendHexStr: ansistring;
  tempStr: AnsiString;
  offset:Integer;
  tempInt: Integer;
  cardInfo: string;
  balance: Integer;
  I: Integer;
  transDate, transTime, transTerminalId: ansistring;
  transType, transAmount: Integer;
begin
  {$IFDEF test}
    sleep(2000);
    for I := 1 to 10 do
    begin
      transAmount := 10000 + 30 * 1;
      transType := 2;
      transTerminalId := '9900112200' + IntToStr(10 + i);
      transDate := FormatDateTime('yyyy-MM-dd', Now);
      transTime := FormatDateTime('HH:nn:ss', Now);

      if Assigned(FOnQueryCityCardDetail) then
        FOnQueryCityCardDetail(transDate, transTime, transTerminalId, transType, transAmount);
      Sleep(10);
    end;
    Result := True;
    Exit;
  {$ENDIF}

  Result := False;
  if not resetD8 then
  begin
    taskRet := 1;
    Exit;
  end;

  //������ϸ  0018H
  for I := 1 to 10 do
  begin
    sendHexStr := '00B2' + inttohex(i, 2) +  'C400';//������ɲμ��ֲ�7.6.2
    CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

    sendLen := Length(sendHexStr) div 2;
    recvLen := 0;
    ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
    if (ret <> 0) or (checkRecvBufEndWith9000(recvBuf, recvLen) <> BILL_OK)
      or (recvLen < 23)then
    begin
      addSysLog('read card transaction detail err, recvBuf:' + recvBuf);
      Break;
    end;

    { 1-2     �������
      3-5     ͸֧�޶�

      6-9     ���׽��
      10      �������ͱ�ʶ
      11-16   �ն˱��
      17-20   ��������
      21-23   ����ʱ��
    }
    offset := 5 * 2;
    SetLength(tempStr, 4 * 2);
    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
    transAmount := bytesToInt(hexStrToByteBuf(tempstr, False), 0, false);

    Inc(offset, 4 * 2);
    SetLength(tempStr, 1 * 2);
    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
    transType := hexStrToByteBuf(tempStr, False)[0];

    Inc(offset, 1 * 2);
    SetLength(tempStr, 6 * 2);
    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
    transTerminalId := tempStr;

    Inc(offset, 6 * 2);
    SetLength(tempStr, 4 * 2);
    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
    transDate := tempStr;

    Inc(offset, 4 * 2);
    SetLength(tempStr, 3 * 2);
    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
    transTime := tempStr;


    if Assigned(FOnQueryCityCardDetail) then
      FOnQueryCityCardDetail(transDate, transTime, transTerminalId, transType, transAmount);
  end;
  taskRet := 0;
  Result := True;
end;

procedure TQueryCityCardTransDetail.SetOnQueryCityCardDetail(
  const Value: TOnQueryCityCardDetail);
begin
  FOnQueryCityCardDetail := Value;
end;

{ TModifyZHBPass }

constructor TModifyZHBPass.Create(CreateSuspended: Boolean; dlg: TfrmWaiting;
  timeout: Integer; oldPass, newPass: ansistring);
begin
  inherited Create(CreateSuspended, dlg, timeout);
  FOldPass := oldPass;
  FNewPass := newPass;
  FreeOnTerminate := False;
end;

function TModifyZHBPass.doTask: Boolean;
var
  tip: string;
  cardNo, asn, tsn: TByteDynArray;
  OperType: Byte; //�������� 00�ֽ��ֵ��01���п���ֵ��02��ֵ����ֵ��03�˻�����ֵ/ר���˻���ֵ
  oldBalance: Integer;//��ֵǰ���
  chargeTime, fakeRandom, mac1: TByteDynArray;
  sendLen, recvLen: SmallInt;
  sendBuf: array[0..512] of AnsiChar;
  recvBuf: array[0..512] of AnsiChar;
  ret: SmallInt;
  sendHexStr: ansistring;
  tempStr: AnsiString;
  offset: Integer;
  lw: LongWord;
  tempBuf: TByteDynArray;
  strChargeAmount: string;
  strTerminalId: string;
  cardType: Byte;
  tac: TByteDynArray;
  transSNo: LongWord;
  cmd: TCmdChargeDetailC2S;
  billStatus: AnsiString;
begin
  {$IFDEF test}
    Result := False;
    Sleep(1000);
    taskRet := 0;
    chargeTime := hexStrToBytes(FormatDateTime('yyyyMMddhhnnss', Now));
    FIsCmdRet := False;
    SetLength(cardNo, 8);
    SetLength(tsn, 2);
    SetLength(asn, 10);
    SetLength(mac1, 4);
    SetLength(fakeRandom, 4);
    DataServer.SendCmdModifyZHBPass(FOldPass, FNewPass, cardNo, asn, tsn, oldBalance, chargeTime, fakeRandom, mac1);
    if not waitForModifyRet then
    begin//��ʱ
      taskRet := 2;
      addSysLog('credit for load err, recvBuf:' + recvBuf);
      Exit;
    end;
    Result := True;
    Exit;
  {$ENDIF}
  Result := False;
  if not resetD8 then
  begin
    taskRet := 1;
    addSysLog('citycard charge reset d8 fail');
    Exit;
  end;

  //�������ź�Ӧ�����к�
  sendHexStr := '00B0950000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 1;
    addSysLog('�����ź�Ӧ�����л�ʧ��, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 8 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardNo := hexStrToBytes(tempStr);//����

  offset := 20;
  SetLength(tempStr, 10 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  asn := hexStrToBytes(tempStr);//Ӧ�����к�

  //����������
  sendHexStr := '00B0960000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 1;
    addSysLog('��������ʧ��, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 1 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardType := hexStrToBytes(tempStr)[0];//������

  //Ȧ���ʼ��
  lw := ByteOderConvert_LongWord(0);
  strChargeAmount := bytesToHexStr(LongWordToBytes(lw));
  strTerminalId := getFixedLenStr(GlobalParam.TerminalId, 12, '0');
  sendHexStr := '805000020B01' + strChargeAmount + strTerminalId + '10';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  billStatus := checkRecvBufEndWith9000(recvBuf, recvLen);
  if (ret <> 0) or (billStatus <> BILL_OK) then
  begin
    taskRet := 1;
    errInfo := '��ֵʧ�ܣ���ע�Ᵽ��ƾ��';
    addSysLog('initialize for load err, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  oldBalance := bytesToInt(hexStrToBytes(tempStr), 0, False);//��ֵǰ���

  offset := 8;
  SetLength(tempStr, 4);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tsn := hexStrToBytes(tempStr);//�������

  offset := 16;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  fakeRandom := hexStrToBytes(tempStr);//�����

  offset := 24;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  mac1 := hexStrToBytes(tempStr);//mac1

  chargeTime := hexStrToBytes(FormatDateTime('yyyyMMddhhnnss', Now));
  FIsCmdRet := False;
  DataServer.SendCmdModifyZHBPass(FOldPass, FNewPass, cardNo, asn, tsn, oldBalance, chargeTime, fakeRandom, mac1);
  if not waitForModifyRet then
  begin//��ʱ
    taskRet := 2;
    addSysLog('credit for load err, recvBuf:' + recvBuf);
    Exit;
  end;

  Result := True;
end;

procedure TModifyZHBPass.noticeCmdRet(ret: Byte);
begin
  FIsCmdRet := True;
  FRet := ret;
end;

function TModifyZHBPass.waitForModifyRet: Boolean;
var
  stime: TDateTime;
  isTimeout: Boolean;
begin
  stime := Now;
  isTimeout := False;
  while not FIsCmdRet do
  begin
    if SecondsBetween(Now, stime) < Self.timeout then
    begin
      Sleep(200);
      Continue;
    end;
    isTimeout := True;
    Break;
  end;
  Result := not isTimeout;
end;

end.
