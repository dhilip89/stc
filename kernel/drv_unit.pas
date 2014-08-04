unit drv_unit;

interface
var
  icdev:longint;//COM1,COM2,ParallelPort 公用设备句柄
  st:smallint;

  procedure quit;
  //comm function
  function dc_init(port:integer;baud:longint):longint; stdcall; far;external 'DCRF32.dll' name 'dc_init';
  function dc_exit(icdev:longint):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_exit' ;
  function dc_card(icdev:longint;mode:smallint;var snr:longword):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_card';
  function dc_load_key_hex(icdev:longint;mode,secor:smallint;skey:pchar):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_load_key_hex';
  function dc_authentication(icdev:longint;mode,secor:smallint):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_authentication';
  function dc_read_hex(icdev:longint;adr:smallint;sdata :pchar):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_read_hex';
  function dc_write_hex(icdev:longint;adr:smallint;sdata :pchar):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_write_hex';
  function dc_halt(icdev:longint):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_halt';
  function dc_reset(icdev:longint;msc:smallint):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_reset';
  function dc_beep(icdev:longint;stime:smallint):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_beep';
  function dc_disp_str(icdev:longint;sdata :pchar):smallint; stdcall; far;external 'DCRF32.dll' name 'dc_disp_str';
  function dc_pro_reset(icdev:longint; var rLen:smallint; rData:pchar):smallint;stdcall;far;external 'DCRF32.dll' name 'dc_pro_reset';
  function dc_pro_reset_hex(icdev:longint; var rLen:smallint; rData:pansichar):smallint;stdcall;far;external 'DCRF32.dll' name 'dc_pro_reset_hex';
  function dc_pro_commandlink_hex(icdev:longint; sLen:smallint; sData:pansichar; var rLen:smallint;  rData:pansichar; t1:smallint; t2:smallint):smallint;stdcall;far; external 'dcrf32.dll' name 'dc_pro_commandlink_hex';
  function dc_config_card(icdev:longint; nType:char):smallint; stdcall;far; external 'DCRF32.dll' name 'dc_config_card';
  function dc_des(key:pchar;sour:pchar;dest:pchar;m:smallint): smallint;stdcall; far;external'DCRF32.dll'name'dc_des';
  function dc_des_hex(key:pchar;sour:pchar;dest:pchar;m:smallint): smallint;stdcall; far;external'DCRF32.dll'name'dc_des_hex';
  function a_hex(s:pchar;hex:pchar;m:smallint): smallint;stdcall; far;external'DCRF32.dll'name'a_hex';
  function dc_cpureset(icdev:longint; var rLen:smallint; rData:pchar):smallint;stdcall; far;external 'DCRF32.dll' name 'dc_cpureset';
  function dc_setcpu(icdev:longint; cardmode:smallint):smallint;stdcall; far;external 'DCRF32.dll' name 'dc_setcpu';
  function dc_cpuapdu(icdev:longint; sLen:smallint; sData:pchar; var rLen:smallint;  rData:pchar):smallint;stdcall; far;external 'DCRF32.dll' name 'dc_cpuapdu';
  function dc_setcpupara(icdev:longint; sLen:smallint; rLen:smallint;rData:smallint):smallint;stdcall; far;external 'DCRF32.dll' name 'dc_setcpupara';
  function dc_cpuapdu_hex(icdev:longint; sLen:smallint; sData:pchar; var rLen:smallint;  rData:pchar):smallint;stdcall; far;external 'DCRF32.dll' name 'dc_cpuapdu_hex';
  function dc_cpureset_hex(icdev:longint; var rLen:smallint; rData:pchar):smallint;stdcall; far;external 'DCRF32.dll' name 'dc_cpureset_hex';

implementation

procedure quit;
begin
  if icdev > 0 then
  begin
    st := dc_reset(icdev, 10);
    st := dc_exit(icdev);
    icdev := -1;
  end;
end;
{
initialization
begin

end;

finalization
begin
end;
 }
end.