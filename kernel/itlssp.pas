unit itlssp;

interface

type
  TResponseStatus = (PORT_CLOSED,
                     PORT_OPEN,
                     PORT_ERROR,
                     SSP_REPLY_OK,
                     SSP_PACKET_ERROR,
                     SSP_CMD_TIMEOUT);

  TSSP_Full_Key = packed record
    FixedKey: Int64;
    EncryptKey: Int64;
  end;

  TSSP_Command = packed record
    FullKey: TSSP_Full_Key;
    BaudRate: LongWord;
    Timeout: LongWord;
    PortNumber: Byte;
    SSPAddress: Byte;
    RetryLevel: Byte;
    EncryptionStatus: Byte;
    CommandDataLength: Byte;
    CommandData: array[0..254] of Byte;
    ResponseStatus: TResponseStatus;
    ResponseDataLength: Byte;
    ResponseData: array[0..254] of Byte;
    IgnoreError: Byte;
  end;
  PSSP_Command = ^TSSP_Command;

  TSSP_Packet = packed record
    packetTime: Word;
    packetLength: Byte;
    packetData: array[0..254] of Byte;
  end;

  TSSP_Command_Info = packed record
    commandName: AnsiString;
    logFileName: AnsiString;
    Encrypted: Byte;
    Transmit: TSSP_Packet;
    Receive: TSSP_Packet;
    PreEncryptedTransmit: TSSP_Packet;
    PreEncryptedReceive: TSSP_Packet;
  end;
  PSSP_Command_Info = ^TSSP_Command_Info;

  function OpenSSPComPort(ssp_cmd: PSSP_Command): Integer;stdcall; far; external 'ITLSSPProc.dll' name 'OpenSSPComPort';
  function CloseSSPComPort: Integer;stdcall; far; external 'ITLSSPProc.dll' name 'CloseSSPComPort';
  function SSPSendCommand(ssp_cmd: PSSP_Command; sspCmdInfo: PSSP_Command_Info): Integer;stdcall; far; external 'ITLSSPProc.dll' name 'SSPSendCommand';

implementation

end.
