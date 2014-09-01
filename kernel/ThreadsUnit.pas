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
    {0:正常  1: 返回继续循环执行  2：关键操作非等待可解决的直接退出，不继续
     3:执行失败，且需退钱  4:充值卡、账户宝密码错误，退出需用户重新确认
    }
    taskRet: Byte;
    amountRefund: Integer;//退款金额
    errInfo: string;//如果返回失败，填写错误提示
    FIsCmdRet: Boolean;
    procedure Execute; override;
    procedure setWaitingTip(tip: string;isHideProgressBar: Boolean = False);
    function doTask: Boolean; virtual; abstract;
    procedure DoOnTaskOK; virtual; //执行顺利
    procedure DoOnTaskTimeout; virtual;//执行超时
    procedure DoOnTaskFail; virtual;//任务中关键操作失败，非等待可解决的，提前退出
    procedure DoOnTaskWithRefund;virtual;//需要进行退钱打印凭条
    procedure DoOnTaskRetry; virtual;//需用户重新确认信息，界面不跳转
    procedure printRefundInfo(amount: Integer; cardNo: ansistring);

    function waitForCmdRet: Boolean;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer); virtual;
    destructor Destroy; override;
  end;

  //获取市民卡余额
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

  //查询交易明细
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

  //读取纸币总额
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

  //充值交易过程
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

  //充值卡校验查面额
  TChargeCardCheck = class(TBaseThread)
  private
    FCityCardNo: AnsiString;
    FPassword: AnsiString;

    FRet: Byte;
    FAmount: Integer;
  protected
    function doTask: Boolean; override;
    procedure DoOnTaskTimeout; override;//执行超时
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer;
      cityCardNo, password: AnsiString);virtual;

    procedure noticeCmdRet(ret: Byte; amount: Integer);
  end;

  //账户宝余额查询
  TQueryZHBBalance = class(TBaseThread)
  private
    FCityCardNo: AnsiString;
    FPassword: AnsiString;

    FRet: Byte;
    FAmount: Integer;
  protected
    function doTask: Boolean; override;
    procedure DoOnTaskTimeout; override;//执行超时
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
  cardInfo := tempStr;//'卡号:'
  currCityCardNo := tempStr;

//    Inc(offset, 20 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('卡片启用日期:' + tempStr);
//
//    Inc(offset, 4 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('卡片失效日期:' + tempStr);
  {
  //卡片基本信息
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
  cardInfo := cardInfo + '(' + bytesToStr(hexStrToByteBuf(tempStr, false)) + ')';//持卡人姓名  }
  if Assigned(FOnGetCityCardInfo) then
    FOnGetCityCardInfo(cardInfo);

//    Inc(offset, 20 * 2);
//    SetLength(tempStr, 18 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('持卡人证件号码:' + bytesToStr(hexStrToByteBuf(tempStr, false)));
//
//    Inc(offset, 23 * 2);
//    SetLength(tempStr, 20 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('联系电话:' + bytesToStr(hexStrToByteBuf(tempStr, false)));

  //卡片余额
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
  //Memo1.Lines.Add('卡片余额:' + FormatFloat('0.##', tempInt / 100.0) + '元');
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

  printInfo := '退款凭证'#13#10
             + '---------------------------'#13#10
             + '卡号:' + cardNo + #13#10
             + '金额:' + IntToStr(amount) + '元'#13#10
             + '时间:' + FormatDateTime('yyyy-MM-dd hh:nn:ss', now) + #13#10
             + '---------------------------'#13#10
             + '注:请带凭证到人工窗口退款';
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
    setWaitingTip('等待超时，请取回失败凭证');
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
  cashAmount: array[0..7] of Byte; //0用不到，通道号从1开始记
  channelCount: Integer;
  tempAmount: Integer;
  totalAmount: Integer;
  st: TDateTime;
begin
  Result := False;
  tip := '需 付 款 金 额:%-3d元'#13#10 +
         '已 投 币 金 额:%-3d元';
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

  //设置串口参数
  sspCmd.SSPAddress := 0;
  sspCmd.BaudRate := 9600;
  sspCmd.Timeout := 1000;
  sspCmd.RetryLevel := 3;
  sspCmd.PortNumber := GlobalParam.ITLPort;
  sspCmd.EncryptionStatus := 0;

  //打开串口
  try
//    addSysLog('open ssp com');
//    i := OpenSSPComPort(@sspCmd);
//    if (i = 0) then
//    begin
//      taskRet := 2;
//      errInfo := '纸币器无法正常工作';
//      //ShowMessage('串口打开失败');
//      Exit;
//    end;

    //发送 0x11 号命令查找识币器是否连接
    sspCmd.CommandData[0] := $11;
    sspCmd.CommandDataLength := 1;
    if SSPSendCommand(@sspCmd, @sspCmdInfo) = 0then
    begin
      taskRet := 2;
      errInfo := '纸币器无法正常工作';
      //ShowMessage('查找识币器是否连接命令执行失败');
      Exit;
    end;

    //读取通道配置
    sspCmd.CommandData[0] := $0E;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
    begin
      taskRet := 2;
      errInfo := '纸币器无法正常工作';
      //ShowMessage('读取通道配置命令执行失败');
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
      errInfo := '纸币器无法正常工作';
      //ShowMessage('disable失败');
      Exit;
    end;

    //set启用的通道
    sspCmd.CommandData[0] := $02;
    sspCmd.CommandData[1] := $B0;
    sspCmd.CommandData[2] := $00;
    sspCmd.CommandDataLength := 3;
    if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
    begin
      taskRet := 2;
      errInfo := '纸币器无法正常工作';
      //ShowMessage('启用通道设置失败');
      Exit;
    end;

    //enable
    sspCmd.CommandData[0] := $0A;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
    begin
      taskRet := 2;
      errInfo := '纸币器无法正常工作';
      //ShowMessage('enable失败');
      Exit;
    end;

    //poll
    st := now;
    while (SecondsBetween(st, Now) < Self.timeout) do
    begin
      if totalAmount - FAmountRead = 50 then
      begin//设置仅读50的
        sspCmd.CommandData[0] := $02;
        sspCmd.CommandData[1] := $90;
        sspCmd.CommandData[2] := $00;
        sspCmd.CommandDataLength := 3;
        if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
        begin
          taskRet := 3;
          errInfo := '纸币器无法正常工作';
          //ShowMessage('设置50元通道失败');
          Exit;
        end;
      end;

      sspCmd.CommandData[0] := $07;
      sspCmd.CommandDataLength := 1;
      if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
      begin
        taskRet := 3;
        errInfo := '纸币器无法正常工作';
        //ShowMessage('poll 失败');
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
      begin//在读钞过程中出现错误
        amountRefund := FAmountRead;
      end
      else
      begin//还没有吞过钞票则将状态改为2
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
  setWaitingTip('充值交易超时，请取回失败凭证');
  Sleep(3000);
  inherited;
end;

function TCityCardCharge.doTask: Boolean;
var
  tip: string;
  cardNo, asn, tsn: TByteDynArray;
  OperType: Byte; //操作类型 00现金充值，01银行卡充值，02充值卡充值，03账户宝充值/专有账户充值
  oldBalance: Integer;//充值前余额
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
//  tip := '正在进行充值处理，请勿移开卡片...';//#13#10 + '卡片读取中...';
//  setWaitingTip(tip);
  if not resetD8 then
  begin
    taskRet := 1;
    addSysLog('citycard charge reset d8 fail');
    Exit;
  end;

  //读出卡号和应用序列号
  sendHexStr := '00B0950000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 3;
    errInfo := '充值失败，请注意保留凭条';
    addSysLog('读卡号和应用序列化失败, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 8 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardNo := hexStrToBytes(tempStr);//卡号

  offset := 20;
  SetLength(tempStr, 10 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  asn := hexStrToBytes(tempStr);//应用序列号

  //读出卡类型
  sendHexStr := '00B0960000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 3;
    errInfo := '充值失败，请注意保留凭条';
    addSysLog('读卡类型失败, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 1 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardType := hexStrToBytes(tempStr)[0];//卡类型

  //圈存初始化
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
    errInfo := '充值失败，请注意保留凭条';
    addSysLog('initialize for load err, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  oldBalance := bytesToInt(hexStrToBytes(tempStr), 0, False);//充值前余额
  FBalanceAfterCharge := FChargeAmount + oldBalance;

  offset := 8;
  SetLength(tempStr, 4);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tsn := hexStrToBytes(tempStr);//交易序号

  offset := 16;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  fakeRandom := hexStrToBytes(tempStr);//随机数

  offset := 24;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  mac1 := hexStrToBytes(tempStr);//mac1

//  tip := '正在进行充值处理，请勿移开卡片'#13#10 + '卡片联机校验中...';
//  setWaitingTip(tip);
  chargeTime := hexStrToBytes(FormatDateTime('yyyyMMddhhnnss', Now));
  DataServer.SendCmdGetMac2(cardNo, asn, tsn, OperType, oldBalance, FChargeAmount, chargeTime, fakeRandom, mac1);
  if not waitForMac2 then
  begin//超时
    taskRet := 3;
    errInfo := '充值失败，请注意保留凭条';
    addSysLog('credit for load err, recvBuf:' + recvBuf);
    Exit;
  end;

//  tip := '正在进行充值处理，请勿移开卡片'#13#10 + '写卡中...';
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
    errInfo := '充值失败，请注意保留凭条';
    addSysLog('credit for load err, recvBuf:' + recvBuf);
    Exit;
  end;
  //圈存成功，获取tac值
  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tac := hexStrToBytes(tempStr);//随机数

  transSNo := getNextTSN;//获取交易流水号

  //充值成功后，上传交易记录到服务端
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
  //充值类型
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
  setWaitingTip('校验超时，请稍后再试');
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
    errInfo := '充值卡校验失败，请确认密码正确';
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
  setWaitingTip('查询账户宝余额超时，请稍后再试');
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
    errInfo := '账户宝余额查询失败，请确认密码';
    Exit;
  end;
  if (FRet = 2) then
  begin
    taskRet := 4;
    errInfo := '账户宝密码不正确，请确认';
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

  //交易明细  0018H
  for I := 1 to 10 do
  begin
    sendHexStr := '00B2' + inttohex(i, 2) +  'C400';//命令组成参见手册7.6.2
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

    { 1-2     交易序号
      3-5     透支限额

      6-9     交易金额
      10      交易类型标识
      11-16   终端编号
      17-20   交易日期
      21-23   交易时间
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
  OperType: Byte; //操作类型 00现金充值，01银行卡充值，02充值卡充值，03账户宝充值/专有账户充值
  oldBalance: Integer;//充值前余额
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
    begin//超时
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

  //读出卡号和应用序列号
  sendHexStr := '00B0950000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 1;
    addSysLog('读卡号和应用序列化失败, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 8 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardNo := hexStrToBytes(tempStr);//卡号

  offset := 20;
  SetLength(tempStr, 10 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  asn := hexStrToBytes(tempStr);//应用序列号

  //读出卡类型
  sendHexStr := '00B0960000';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    taskRet := 1;
    addSysLog('读卡类型失败, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 1 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  cardType := hexStrToBytes(tempStr)[0];//卡类型

  //圈存初始化
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
    errInfo := '充值失败，请注意保留凭条';
    addSysLog('initialize for load err, recvBuf:' + recvBuf);
    Exit;
  end;

  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  oldBalance := bytesToInt(hexStrToBytes(tempStr), 0, False);//充值前余额

  offset := 8;
  SetLength(tempStr, 4);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tsn := hexStrToBytes(tempStr);//交易序号

  offset := 16;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  fakeRandom := hexStrToBytes(tempStr);//随机数

  offset := 24;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  mac1 := hexStrToBytes(tempStr);//mac1

  chargeTime := hexStrToBytes(FormatDateTime('yyyyMMddhhnnss', Now));
  FIsCmdRet := False;
  DataServer.SendCmdModifyZHBPass(FOldPass, FNewPass, cardNo, asn, tsn, oldBalance, chargeTime, fakeRandom, mac1);
  if not waitForModifyRet then
  begin//超时
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
