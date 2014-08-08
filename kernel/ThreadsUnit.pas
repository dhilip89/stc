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
    procedure DoOnTaskTimeout;override;
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

  TThreadModuleChecker = class(TThread)
  private
  protected
    procedure Execute;
  public
    constructor Create(CreateSuspended:Boolean);
    destructor Destroy; override;
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
  cardInfo := tempStr;//'����:'

//    Inc(offset, 20 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('��Ƭ��������:' + tempStr);
//
//    Inc(offset, 4 * 2);
//    SetLength(tempStr, 4 * 2);
//    CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
//    Memo1.Lines.Add('��ƬʧЧ����:' + tempStr);

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
  cardInfo := cardInfo + '(' + bytesToStr(hexStrToByteBuf(tempStr, false)) + ')';//�ֿ�������
  if Assigned(FOnGetCityCardInfo) then
    FOnGetCityCardInfo(FEdtCardInfo, cardInfo);

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
  setWaitingTip(Format(tip, [FCashAmount, 0]));

  totalAmount := FCashAmount;
  FAmountRead := 0;
  cashAmount[0] := 0;
  tempAmount := 0;

  //���ô��ڲ���
  sspCmd.SSPAddress := 0;
  sspCmd.BaudRate := 9600;
  sspCmd.Timeout := 10000;
  sspCmd.PortNumber := GlobalParam.ITLPort;
  sspCmd.EncryptionStatus := 0;

  //�򿪴���
  try
    i := OpenSSPComPort(@sspCmd);
    if (i = 0) then
    begin
      //ShowMessage('���ڴ�ʧ��');
      Exit;
    end;

    //���� 0x11 ���������ʶ�����Ƿ�����
    sspCmd.CommandData[0] := $11;
    sspCmd.CommandDataLength := 1;
    if SSPSendCommand(@sspCmd, @sspCmdInfo) = 0then
    begin
      //ShowMessage('����ʶ�����Ƿ���������ִ��ʧ��');
      Exit;
    end;

    //��ȡͨ������
    sspCmd.CommandData[0] := $0E;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspCmd, @sspCmdInfo) = 0) then
    begin
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
      //ShowMessage('����ͨ������ʧ��');
      Exit;
    end;

    //enable
    sspCmd.CommandData[0] := $0A;
    sspCmd.CommandDataLength := 1;
    if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
    begin
      //ShowMessage('enableʧ��');
      Exit;
    end;

    //poll
    i := 0;
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
          //ShowMessage('����50Ԫͨ��ʧ��');
          Exit;
        end;
      end;

      sspCmd.CommandData[0] := $07;
      sspCmd.CommandDataLength := 1;
      if (SSPSendCommand(@sspcmd, @sspCmdInfo) = 0) then
      begin
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
  setWaitingTip('��ֵ���׳�ʱ����ȡ��ʧ��ƾ֤');
  Sleep(3000);
  inherited;
end;

function TCityCardCharge.doTask: Boolean;
var
  tip: string;
  cardNo, asn, tsn: TByteDynArray;
  OperType: Byte; //�������� 00�ֽ��ֵ��01���п���ֵ��02��ֵ����ֵ��03��ͨ��ֵ/ר���˻���ֵ
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
begin
  Result := False;
  tip := '���ڽ��г�ֵ���������ƿ���Ƭ'#13#10 + '��Ƭ��ȡ��...';
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
  //0001134F000A010085ECC7494F9CFB6D9000  ����ʾ��
  //0001134F    ���
  //        000A				�������
  //            01					��Կ�汾��
  //              00					�㷨��ʶ
  //                4759EA92		α�����
  //                        BF76B198		MAC1
  //                                9000

  offset := 0;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  oldBalance := bytesToInt(hexStrToBytes(tempStr), 0, False);
  FBalanceAfterCharge := FChargeAmount + oldBalance;

  offset := 8;
  SetLength(tempStr, 4);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  tsn := hexStrToBytes(tempStr);

  offset := 16;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  fakeRandom := hexStrToBytes(tempStr);

  offset := 24;
  SetLength(tempStr, 4 * 2);
  CopyMemory(@tempStr[1], @recvBuf[offset], Length(tempStr));
  mac1 := hexStrToBytes(tempStr);

  tip := '���ڽ��г�ֵ���������ƿ���Ƭ'#13#10 + '��Ƭ����У����...';
  setWaitingTip(tip);
  chargeTime := hexStrToBytes(FormatDateTime('yyyyMMddhhnnss', Now));
  DataServer.SendCmdGetMac2(cardNo, asn, tsn, OperType, oldBalance, FChargeAmount, chargeTime, fakeRandom, mac1);
  if not waitForMac2 then
  begin//��ʱ
    Exit;
  end;

  tip := '���ڽ��г�ֵ���������ƿ���Ƭ'#13#10 + 'д����...';
  setWaitingTip(tip);
  sendHexStr := '805200000B' + bytesToHexStr(chargeTime) + FMac2 + '04';
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

{ TThreadModuleChecker }

constructor TThreadModuleChecker.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
end;

destructor TThreadModuleChecker.Destroy;
begin
  inherited;
  FreeOnTerminate := False;
end;

procedure TThreadModuleChecker.Execute;
begin

end;

end.
