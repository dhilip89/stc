unit uGloabVar;

interface
uses
  comCtrls, SysUtils, classes, UserUnit, BusinessServerUnit, ParamUnit,
  Forms, windows, Messages, GatewayServerUnit,
  cxTL, StructDefUnit, SystemLog, ConstDefineUnit, system.Types;

var
  current_user: TUser;
  Bs: TBusinessSeverCom; //业务服务器
  DataServer: TGateWayServerCom; //网关服务器

  GlobalParam: TSystemParam; //参数      管理器
  ACmdManage: TCmdManage; //命令      管理器
//  SystemLog: TSystemLog; //系统日志
  ExePath: string;
  FSysLog: TSystemLog;//该日志对象为立即写入，专门用来记录关键日志，防止异常后未能及时记录日志

function getCmdStat(stat: integer): string;
function PopMsg(Title: string; Msg: string): boolean;
function split(src,dec : string):TStringList;
function BCD2Byte(bcd: Byte): Byte;
procedure StrToBcdByteArray(const srcStr: string; var bcdAry: array of Byte; aryLength: Integer);

function resetD8: Boolean;
procedure addSysLog(logStr: string);
function bytesToStr(buf: array of Byte): ansistring;
function bytesToHexStr(buf: array of Byte): AnsiString;
function hexStrToByteBuf(const hexStr: ansiString; isIncludeFF: Boolean): TByteDynArray;
function bytesToInt(buf: array of byte; sIndex: Integer; isLittleEndian: Boolean = true): Integer;
function getFixedLenStr(srcStr:string; dstLen: Integer; fillchar: Char; isFillLeft: Boolean = True): string;
function hexStrToBytes(hexStr: string): TByteDynArray;
function intToBytes(iVal: Integer): TByteDynArray;
function wordToBytes(wVal: Word): TByteDynArray;
function LongWordToBytes(lw: LongWord): TByteDynArray;

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
  if dc_reset(icdev, 0) <> 0 then
  begin
    FSysLog.AddLog('dc_reset fail');
    Exit;
  end;  ;

  if dc_card(icdev, 0, lw) <> 0 then
  begin
    FSysLog.AddLog('no card');
    Exit;
  end;

  if dc_config_card(icdev, 'A') <> 0 then
  begin
    FSysLog.AddLog('dc_config_card fail');
    Exit;
  end;

  if dc_pro_reset_hex(icdev, rlen, rdata) <> 0 then
  begin
    FSysLog.AddLog('dc_pro_reset_hex fail');
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

initialization
  DateSeparator := '-';
  GlobalParam := TSystemParam.Create;
  ACmdManage := TCmdManage.create;

//  SystemLog := TSystemLog.Create;
  FSysLog := TSystemLog.Create;
  FSysLog.WriteImmediate := True;
  FSysLog.LogFile := ExePath + 'log\sysLog\data';
finalization
  //业务服务器在主窗口Free
  GlobalParam.Free;
  ACmdManage.Free;
  FSysLog.Free;

end.

