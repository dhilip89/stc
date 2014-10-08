unit keyboard;

interface

  function kb_openCom(port:integer;baud:longint):longint; stdcall; far;external 'XZ_F64_API.dll' name 'SUNSON_OpenCom';
  function kb_closeCom: LongInt; stdcall; far; external 'XZ_F64_API.dll' name 'SUNSON_CloseCom';
  function kb_setWorkMode(mode: Byte): LongInt; stdcall; far; external 'XZ_F64_API.dll' name 'SUNSON_SetEppWorkMode';
  function kb_readOneChar(ret: pansichar): LongInt; stdcall; far; external 'XZ_F64_API.dll' name 'SUNSON_ReadOneByte';

implementation

end.
