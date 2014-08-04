unit ThreadsUnit;

interface
uses
  System.classes, FrmWaitingUnit, Vcl.StdCtrls;

type
  TOnGetCityCardInfo = procedure (edt: TCustomEdit; cardInfo: string) of object;
  TOnGetCardBalance = procedure (edt: TCustomEdit; cardBalance: Integer) of object;

  TBaseThread = class(TThread)
  private
    frmWaiting: TfrmWaiting;
    timeout: Integer;
  protected
    procedure Execute; override;
    procedure setWaitingTip(tip: string);
    function doTask: Boolean; virtual; abstract;
    procedure DoOnTaskOK; virtual;
    procedure DoOnTaskTimeout; virtual;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer); virtual;
    destructor Destroy; override;
  end;

  TQueryCityCardBalance = class(TThread)
  private
    frmWaiting: TfrmWaiting;
    timeout: Integer;
    FOnGetCityCardInfo: TOnGetCityCardInfo;
    FOnGetCardBalance: TOnGetCardBalance;
    FEdtCardInfo: TCustomEdit;
    FEdtCardBalance: TCustomEdit;
    function doTask: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer; edtCardInfo, edtCardBalance: TCustomEdit);
    destructor Destroy; override;

    property OnGetCityCardInfo: TOnGetCityCardInfo read FOnGetCityCardInfo write FOnGetCityCardInfo;
    property OnGetCardBalance: TOnGetCardBalance read FOnGetCardBalance write FOnGetCardBalance;
  end;

  TGetCashAmount = class(TBaseThread)
  private
    FCashAmount: Integer;
    FAmountRead: Integer;
  protected
    function doTask: Boolean;override;
    procedure doOnTaskTimeout;override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer; cashAmount: Integer);
  end;

  TCityCardCharge = class(TBaseThread)
  private
    FChargeAmount: Integer;
    FMac2: string;
    FIsMac2Got: Boolean;
    FBalanceAfterCharge: Integer;
    function waitForMac2: Boolean;
  protected
    function doTask: Boolean; override;
    procedure DoOnTaskTimeout; override;
  public
    constructor Create(CreateSuspended:Boolean; dlg: TfrmWaiting; timeout: Integer; cashAmount: Integer);

    procedure noticeMac2Got(mac2: string);

    property BalanceAfterCharge: Integer read FBalanceAfterCharge;
  end;

implementation
uses
  System.Types, System.SysUtils, System.DateUtils, drv_unit, uGloabVar,
  Winapi.Windows, CmdStructUnit, itlssp;

{ TQueryCityCardBalance }

constructor TQueryCityCardBalance.Create(CreateSuspended:Boolean; dlg: TfrmWaiting;
  timeout: Integer; edtCardInfo, edtCardBalance: TCustomEdit);
begin
  inherited Create(CreateSuspended);
  Self.frmWaiting := dlg;
  Self.timeout := timeout;
  FEdtCardInfo := edtCardInfo;
  FEdtCardBalance := edtCardBalance;
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
  recvHexStr: AnsiString;
  tempStr: AnsiString;
  offset:Integer;
  tempInt: Integer;
  cardInfo: string;
  balance: Integer;
begin
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

//    Inc(offset, 20 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('卡片启用日期:' + tempStr);
//
//    Inc(offset, 4 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('卡片失效日期:' + tempStr);

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
  cardInfo := cardInfo + '(' + bytesToStr(hexStrToByteBuf(tempStr, false)) + ')';//持卡人姓名
  if Assigned(FOnGetCityCardInfo) then
    FOnGetCityCardInfo(FEdtCardInfo, cardInfo);

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
  if Assigned(FOnGetCardBalance) then
    FOnGetCardBalance(FEdtCardBalance, balance);

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

procedure TBaseThread.DoOnTaskOK;
begin
  frmWaiting.noticeMROK;
end;

procedure TBaseThread.DoOnTaskTimeout;
begin
  frmWaiting.noticeTimeout;
end;

procedure TBaseThread.Execute;
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
    DoOnTaskOK;
  end
  else
  begin
    DoOnTaskTimeout;
  end;
end;

procedure TBaseThread.setWaitingTip(tip: string);
begin
  frmWaiting.setWaitingTip(tip);
end;

{ TGetCashAmount }

constructor TGetCashAmount.Create(CreateSuspended: Boolean; dlg: TfrmWaiting;
  timeout, cashAmount: Integer);
begin
  inherited Create(CreateSuspended, dlg, timeout);
  FCashAmount := cashAmount;
end;

procedure TGetCashAmount.doOnTaskTimeout;
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
  setWaitingTip(Format(tip, [FCashAmount, 0]));

  totalAmount := FCashAmount;
  FAmountRead := 0;
  cashAmount[0] := 0;

  //设置串口参数
  sspCmd.SSPAddress := 0;
  sspCmd.BaudRate := 9600;
  sspCmd.Timeout := 10000;
  sspCmd.PortNumber := GlobalParam.ITLPort;
  sspCmd.EncryptionStatus := 0;

  //打开串口
  try
    i := OpenSSPComPort(@sspCmd);
    if (i = 0) then
    begin
      //ShowMessage('串口打开失败');
      Exit;
    end;

    //发送 0x11 号命令查找识币器是否连接
    sspCmd.CommandData[0] := $11;
    sspCmd.CommandDataLength := 1;
    if SSPSendCommand(@sspCmd, @sspCmdInfo) = 0then
    begin
      //ShowMessage('查找识币器是否连接命令执行失败');
      Exit;
    end;

    //读取通道配置
    sspCmd.CommandData[0] := $0E;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
    begin
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
      //ShowMessage('启用通道设置失败');
      Exit;
    end;

    //enable
    sspCmd.CommandData[0] := $0A;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
    begin
      //ShowMessage('enable失败');
      Exit;
    end;

    //poll
    i := 0;
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
          //ShowMessage('设置50元通道失败');
          Exit;
        end;
      end;

      sspCmd.CommandData[0] := $07;
      sspCmd.CommandDataLength := 1;
      if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
      begin
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
                setWaitingTip(Format(tip, [FCashAmount, FAmountRead]));
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
    CloseSSPComPort;
  end;
  if (FAmountRead < totalAmount) then
  begin//timeout and amount is not enough
    Exit;
  end;
//  Sleep(2000);
//  setWaitingTip(Format(tip, [FCashAmount, 50]));
//  Sleep(2000);
//  setWaitingTip(Format(tip, [FCashAmount, 100]));
//  Sleep(2000);
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
  chargeTime: string;
  fakeRandom, mac1: string;

  sendLen, recvLen: SmallInt;
  sendBuf: array[0..512] of AnsiChar;
  recvBuf: array[0..512] of AnsiChar;
  ret: SmallInt;
  sendHexStr: ansistring;
  recvHexStr: AnsiString;
  tempStr: AnsiString;
  offset: Integer;
  lw: LongWord;

  strChargeAmount: string;
  strTerminalId: string;
begin
  Result := False;
  tip := '正在进行充值处理，请勿移开卡片'#13#10 + '卡片读取中...';
  setWaitingTip(tip);
  if not resetD8 then
  begin
    addSysLog('citycard charge reset d8 fail');
    Exit;
  end;

  lw := ByteOderConvert_LongWord(FChargeAmount);
  strChargeAmount := bytesToHexStr(LongWordToBytes(lw));
  strTerminalId := getFixedLenStr(GlobalParam.TerminalId, 12, '0');
  sendHexStr := '805000020B01' + strChargeAmount + strTerminalId + '10';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    addSysLog('initialize for load err, recvBuf:' + recvBuf);
    Exit;
  end;
  //0001134F000A010085ECC7494F9CFB6D9000  返回示例
  //0001134F    余额
  //        000A				交易序号
  //            01					密钥版本号
  //              00					算法标识
  //                4759EA92		伪随机数
  //                        BF76B198		MAC1
  //                                9000

  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  FBalanceAfterCharge := FChargeAmount + bytesToInt(hexStrToBytes(tempStr), 0, False);

  offset := 16;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  fakeRandom := tempStr;

  offset := 24;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  mac1 := tempStr;

  tip := '正在进行充值处理，请勿移开卡片'#13#10 + '卡片联机校验中...';
  setWaitingTip(tip);
  chargeTime := FormatDateTime('yyyyMMddhhnnss', Now);
  DataServer.SendCmdGetMac2(FChargeAmount, chargeTime, fakeRandom, mac1);

  if not waitForMac2 then
  begin//超时
    Exit;
  end;

  tip := '正在进行充值处理，请勿移开卡片'#13#10 + '写卡中...';
  setWaitingTip(tip);
  sendHexStr := '805200000B' + chargeTime + FMac2 + '04';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    addSysLog('credit for load err, recvBuf:' + recvBuf);
    Exit;
  end;

  Result := True;
end;

procedure TCityCardCharge.noticeMac2Got(mac2: string);
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

end.
