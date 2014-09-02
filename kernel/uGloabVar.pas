unit uGloabVar;

interface
uses
  comCtrls, SysUtils, classes, UserUnit, BusinessServerUnit, ParamUnit,
  Forms, windows, Messages, GatewayServerUnit, cxTL, StructDefUnit,
  SystemLog, ConstDefineUnit, system.Types, SPCOMM, BeansUnit, Vcl.Controls;

var
  current_user: TUser;
  Bs: TBusinessSeverCom; //业务服务器
  DataServer: TGateWayServerCom; //网关服务器

  GlobalParam: TSystemParam; //参数      管理器
  ACmdManage: TCmdManage; //命令      管理器
//  SystemLog: TSystemLog; //系统日志
  ExePath: string;
  FSysLog: TSystemLog;//该日志对象为立即写入，专门用来记录关键日志，防止异常后未能及时记录日志

  printerCom: TComm;
  isPrinterComOpen: Boolean;

  amountCharged: Integer;//市民卡充值金额 '单位:分'

  currCityCardNo: ansistring;    //当前市民卡卡号
  currCityCardBalance: Integer;  //当前市民卡余额  单位:分
  currPrepaidCardAmount: Integer;//当前充值卡面额 单位:分
  currZHBBalance: Integer;       //当前账户宝余额  单位:分
  currentTSN: LongWord = 0;
  currChargeType: Byte;//当前充值类型  0:现金 1:银联卡  2：充值卡  03企福通充值/专有账户充值
  bankCardNoOrPassword: ansistring;//充值时使用的银行卡号或者充值卡卡号

  FGlobalTip: TMyHintWindow;

function getCmdStat(stat: integer): string;
function PopMsg(Title: string; Msg: string): boolean;
function split(src,dec : string):TStringList;
function BCD2Byte(bcd: Byte): Byte;
procedure StrToBcdByteArray(const srcStr: string; var bcdAry: array of Byte; aryLength: Integer);

procedure initGlobalVar;
procedure addSysLog(logStr: string);
function resetD8: Boolean;
function bytesToStr(buf: array of Byte): ansistring;
function bytesToHexStr(buf: array of Byte): AnsiString;
function hexStrToByteBuf(const hexStr: ansiString; isIncludeFF: Boolean): TByteDynArray;
function bytesToInt(buf: array of byte; sIndex: Integer; isLittleEndian: Boolean = true): Integer;
function getFixedLenStr(srcStr:string; dstLen: Integer; fillchar: Char; isFillLeft: Boolean = True): string;
function hexStrToBytes(hexStr: string): TByteDynArray;
function intToBytes(iVal: Integer): TByteDynArray;
procedure initBytes(var buf: array of Byte; initByte: Byte);
function wordToBytes(wVal: Word): TByteDynArray;
function LongWordToBytes(lw: LongWord): TByteDynArray;
function initPrinterCom(): Boolean;
function freePrinterCom(): Boolean;
function printContent(content: AnsiString): Boolean;
function checkPrinterStatus(): Boolean;
function getNextTSN():Integer;
function getInitTSNFromFile: Integer;
function writeTSNToFile(tsn: Integer): Boolean;
procedure ShowTips(aTip: string; aCom: TControl);

implementation
uses
  Dialogs, drv_unit;

function getCmdStat(stat: integer): string;
begin
  case stat of
    CMD_SNDNODO: result := '正在发送...'; //  =0   // 已发送未执行
    CMD_DONE: result := '已执行!'; //  =1   // 已执行
    CMD_DOERROR: result := '执行错!'; //  =2   // 执行出错
    CMD_CANCELByUSER: result := '正在取消...'; //  =3   // 被用户取消
    CMD_CANCELED: result := '已取消!'; //  =4   // 已取消
    CMD_CANCELFAIL: result := '取消失败!'; //  =5   // 取消失败
    CMD_RESND: result := '再次发送...'; //  =6   // 重发
    CMD_DELETED: result := '被删除'; //  =7   // 被删除
    CMD_REPLACE: result := '被替代'; //  =8   // 被替代
    CMD_OVERTIME: result := '超时'; //  =9   // 超时
    CMD_SND2SMSSENDSVR: result := '已转给SMS发送服务器'; // =10
    CMD_INVALIDDEV: result := '无效的车机ID号'; //=11
  end;
end;

function split(src,dec : string):TStringList;
var
  i : integer;
  str : string;
begin
  result := TStringList.Create;
  repeat
    i := pos(dec,src);
    str := copy(src,1,i-1);
    if (str='') and (i>0) then
    begin
      delete(src,1,length(dec));
      continue;
    end;
    if i>0 then
    begin
      result.Add(str);
      delete(src,1,i+length(dec)-1);
    end;
  until i<=0;
  if src<>'' then
    result.Add(src);
end;


function PopMsg(Title: string; Msg: string): boolean;
begin
  {umainf.Mainf.MSNPopUp1.Title := Title + '  ';
  umainf.Mainf.MSNPopUp1.Text := Msg;
  Result := umainf.Mainf.MSNPopUp1.ShowPopUp; }
end;

function BCD2Byte(bcd: Byte): Byte;
begin
  Result := (bcd shr 4) * 10 + (bcd and $0F);
end;

procedure StrToBcdByteArray(const srcStr: string; var bcdAry: array of Byte; aryLength: Integer);
var
  s: string;
  i, j: Integer;
begin
  s := '';
  if (Length(srcStr) = 2 * aryLength) then
    s := srcStr
  else if (Length(srcStr) < 2 * aryLength) then
  begin
    j := Length(srcStr);
    for i := 0 to 2 * aryLength - j - 1 do
    begin
      s := s + '0';
    end;
    s := s + srcStr;
  end
  else
  begin
    s := Copy(srcStr, Length(srcStr) - 2 * aryLength + 1, 8);
  end;
  for i := 0 to aryLength - 1 do
  begin
    bcdAry[i] := StrToInt('$' + Copy(s, 2 * i + 1, 2));
  end;  
end;

procedure initGlobalVar;
begin
  currCityCardBalance := 0;
  currPrepaidCardAmount := 0;
  currZHBBalance := 0;
end;

function resetD8: Boolean;
var
  lw: LongWord;
  rlen: SmallInt;
  rdata: array[0..1023] of ansichar;

  sendLen, recvLen: SmallInt;
  sendBuf: array[0..512] of AnsiChar;
  recvBuf: array[0..512] of AnsiChar;
  ret: SmallInt;
  sendHexStr: ansistring;
  recvHexStr: AnsiString;
begin
  Result := False;
  ret := dc_reset(icdev, 5);
  if ret <> 0 then
  begin
    FSysLog.AddLog('dc_reset fail, ' + IntToStr(ret));
    Exit;
  end;  ;

  ret := dc_config_card(icdev, 'A');
  if ret <> 0 then
  begin
    FSysLog.AddLog('dc_config_card fail, ' + IntToStr(ret));
    Exit;
  end;

  ret := dc_card(icdev, 0, lw);
  if ret <> 0 then
  begin
    FSysLog.AddLog('no card, ' + IntToStr(ret));
    Exit;
  end;

  ret := dc_pro_reset_hex(icdev, rlen, rdata);
  if ret <> 0 then
  begin
    FSysLog.AddLog('dc_pro_reset_hex fail, ' + IntToStr(ret));
    Exit;
  end;

  sendHexStr := '00A404000F4D4F542E494E544552434954593031';
  CopyMemory(@sendBuf[0], @sendHexStr[1], Length(sendHexStr));

  sendLen := Length(sendHexStr) div 2;
  recvLen := 0;
  ret := dc_pro_commandlink_hex(icdev, sendLen, sendBuf, recvLen, recvBuf, 7, 56);
  if ret <> 0 then
  begin
    addSysLog('select file err,recvBuf:' + recvBuf);
    Exit;
  end;
  Result := True;
end;

procedure addSysLog(logStr: string);
begin
  if logStr <> '' then
    FSysLog.AddLog(logStr);
end;

function bytesToStr(buf: array of Byte): ansistring;
var
  bytes: TBytes;
  str: ansistring;
begin
  SetLength(str, Length(buf));
  CopyMemory(@str[1], @buf[0], Length(buf));
  Result := str;
end;

function bytesToHexStr(buf: array of Byte): AnsiString;
var
  hexStr: AnsiString;
  I: Integer;
begin
  hexStr := '';
  for I := Low(buf) to High(buf) do
  begin
    hexStr := hexStr + IntToHex(buf[i], 2);
  end;
  Result := hexStr;
end;

function hexStrToByteBuf(const hexStr: ansiString; isIncludeFF: Boolean): TByteDynArray;
var
  strBuf: AnsiString;
  retBuf: TByteDynArray;
  isBreaked: Boolean;
  i: Integer;
begin
  strBuf := hexStr;
  if Length(strBuf) mod 2 = 1 then
  begin
    strBuf := strBuf + 'F';
  end;
  SetLength(retBuf, Length(strBuf) div 2);

  isBreaked := False;
  for i := 0 to Length(retBuf) - 1 do
  begin
    retBuf[i] := StrToInt('$' + Copy(strBuf, 2 * i + 1, 2));
    if not isIncludeFF and (retBuf[i] = $FF)then
    begin
      isBreaked := True;
      Break;
    end;
  end;
  if isBreaked then
  begin
    SetLength(retBuf, i);
  end;
  result := retBuf;
end;

function bytesToInt(buf: array of byte; sIndex: Integer; isLittleEndian: Boolean = true): Integer;
var
  ret: Integer;
  i: Integer;
begin
  if (sIndex < 0) or (sIndex + 3 >= Length(buf)) then
  begin
    Result := 0;
    Exit;
  end;

  Result := 0;
  if isLittleEndian then
  begin
    Result := Result + buf[sIndex];
    Result := Result + buf[sIndex + 1] shl 8;
    Result := Result + buf[sIndex + 2] shl 16;
    Result := Result + buf[sIndex + 3] shl 24;
  end
  else
  begin
    Result := Result + buf[sIndex] shl 24;
    Result := Result + buf[sIndex + 1] shl 16;
    Result := Result + buf[sIndex + 2] shl 8;
    Result := Result + buf[sIndex + 3] ;
  end;
end;

function getFixedLenStr(srcStr:string; dstLen: Integer; fillchar: Char; isFillLeft: Boolean): string;
var
  dstStr: string;
  srcLen: Integer;
  I: Integer;
begin
  srcLen := Length(srcStr);
  dstStr := srcStr;
  if dstLen = srcLen then
  begin
    dstStr := srcStr;
  end
  else if dstLen > srcLen then
  begin
    dstStr := srcStr;
    for I := srcLen to dstLen - 1 do
    begin
      dstStr := fillchar + dstStr;
    end;
  end
  else
  begin
    SetLength(dstStr, dstLen);
  end;
  Result := dstStr;
end;

function hexStrToBytes(hexStr: string): TByteDynArray;
var
  strBuf: AnsiString;
  retBuf: TByteDynArray;
  i: Integer;
begin
  strBuf := hexStr;
  if Length(strBuf) mod 2 = 1 then
  begin
    strBuf := strBuf + 'F';
  end;
  SetLength(retBuf, Length(strBuf) div 2);

  for i := 0 to Length(retBuf) - 1 do
  begin
    retBuf[i] := StrToInt('$' + Copy(strBuf, 2 * i + 1, 2));
  end;
  result := retBuf;
end;

function intToBytes(iVal: Integer): TByteDynArray;
begin
  SetLength(Result, 4);
  CopyMemory(@Result[0], @iVal, 4);
end;

function wordToBytes(wVal: Word): TByteDynArray;
begin
  SetLength(Result, 2);
  CopyMemory(@Result[0], @wVal, 2);
end;

function LongWordToBytes(lw: LongWord): TByteDynArray;
begin
  SetLength(Result, 4);
  CopyMemory(@Result[0], @lw, 4);
end;

procedure initBytes(var buf: array of Byte; initByte: Byte);
var
  I: Integer;
begin
  for I := Low(buf) to High(buf) do
  begin
    buf[i] := initByte;
  end;
end;

function initPrinterCom(): Boolean;
begin
  if printerCom = nil then
  begin

    printerCom := TComm.Create(nil);
    printerCom.CommName := 'COM' + IntToStr(GlobalParam.PrinterComPort);
    printerCom.BaudRate := 115200;
    printerCom.Parity := None;
    printerCom.StopBits := _1;
    printerCom.ByteSize := _8;
    //printerCom.OnReceiveData := CommReceiveData;
    try
      printerCom.StartComm;
      isPrinterComOpen := True;
    except
      isPrinterComOpen := False;
    end;
  end;
  Result := True;
end;

function freePrinterCom(): Boolean;
begin
  if printerCom <> nil then
  begin
    printerCom.StopComm;
    printerCom.Free;
  end;
end;

function printContent(content: AnsiString): Boolean;
var
  buf: TByteDynArray;
begin
  if isPrinterComOpen and (content <> '') then
  begin
    //初始化、并设置汉字模式
    buf := hexStrToBytes('1B401C26');
    printerCom.WriteCommData(pansichar(@buf[0]), Length(buf));

    //发送内容
    SetLength(buf, Length(content));
    CopyMemory(@buf[0], @content[1], Length(buf));
    printerCom.WriteCommData(pansichar(@buf[0]), Length(buf));

    //打印并走纸，切纸
    buf := hexStrToBytes('1B640A1D5630');
    printerCom.WriteCommData(PAnsiChar(@buf[0]), Length(buf));
  end;
  Result := False;
end;

function checkPrinterStatus(): Boolean;
var
  buf: TByteDynArray;
begin
  if isPrinterComOpen then
  begin
    //初始化、并设置汉字模式
    buf := hexStrToBytes('1C76');
    printerCom.WriteCommData(pansichar(@buf[0]), Length(buf));
  end;
  Result := False;
end;

function getNextTSN():Integer;
begin
  Inc(currentTSN);
  Result := currentTSN;
  writeTSNToFile(currentTSN);
end;

function getInitTSNFromFile: Integer;
var
  fs: TFileStream;
  fileName: string;
  sno: AnsiString;
begin
  FileName := 'sno.txt';
  fs := nil;
  try
    try
      if FileExists(FileName) then
      begin
        fs := TFileStream.Create(FileName, fmOpenRead);
        SetLength(sno, fs.Size);
        fs.Read(sno[1], fs.Size);
        if Trim(sno) <> '' then
        begin
          currentTSN := StrToInt(sno);
        end
        else
        begin
          currentTSN := 0;
        end;
      end
      else
      begin
        fs := TFileStream.Create(FileName, fmCreate or fmOpenRead);
        currentTSN := 0;
      end;
    except

    end;
  finally
    if fs <> nil then
    begin
      fs.Free;
    end;
  end;
end;

function writeTSNToFile(tsn: Integer): Boolean;
var
  fs: TFileStream;
  fileName: string;
  sno: AnsiString;
begin
  FileName := 'sno.txt';
  fs := nil;
  sno := IntToStr(tsn);
  try
    try
      if FileExists(FileName) then
        fs := TFileStream.Create(FileName, fmOpenWrite)
      else
      begin
        fs := TFileStream.Create(FileName, fmCreate or fmOpenWrite);
      end;
      fs.Size := 0;
      fs.Write(sno[1], Length(sno));
    except
    end;
  finally
    if fs <> nil then
    begin
      fs.Free;
    end;
  end;
end;

procedure ShowTips(aTip: string; aCom: TControl);
begin
  FGlobalTip.ShowHint(aTip, aCom);
end;

initialization
  DateSeparator := '-';
  GlobalParam := TSystemParam.Create;
  ACmdManage := TCmdManage.create;

//  SystemLog := TSystemLog.Create;
  FSysLog := TSystemLog.Create;
  FSysLog.WriteImmediate := True;
  FSysLog.LogFile := ExePath + 'log\sysLog\data';
  getInitTSNFromFile();
  FGlobalTip := TMyHintWindow.Create(nil);

finalization
  //业务服务器在主窗口Free
  GlobalParam.Free;
  ACmdManage.Free;
  FSysLog.Free;
  FGlobalTip.Free;

end.

