{提供二进制缓存到可见字符之间的转换
 @author()
 @created(2002-11-04)
 @lastmod(GMT:$Date: 2010/01/15 07:30:28 $) <BR>
 最后更新人:$Author: wfp $  <BR>
 当前版本:$Revision: 1.1.1.1 $  <BR>}
unit MemFormatUnit;

interface
uses
  Sysutils;

  {将一段存内内容转换成十六进制表示的字符串
  @param ABuff:Pointer 要转换的内存的起地址
  @parem ALen:integer   转换数据长度
  @return 返回格式化后的字符串
  @ver(,2003-9-10,
  最后修改:NULL,2003-9-10)}
function BuffToHex(ABuff: Pointer; ALen: integer): string;

implementation
uses
  windows;

function BuffToHex(ABuff: Pointer; ALen: integer): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to ALen - 1 do
  begin
    Result := Result + InttoHex(PByte(ABuff)^, 2);
    inc(PByte(ABuff));
  end;
end;


end.
