{-------------------------------------------------------------------------------
  ����:      JADIC
  ����:      2014-07-01
  ��������:  ͨѶ�ṹ����
-------------------------------------------------------------------------------}

unit CmdStructUnit;

interface
uses
  Windows, winsock, Types;

const
  VER = $0100;

{******************************�ն˷���������******************************}
  C2S_TYRET                  = $0001;//�ն�ͨ��Ӧ��
  C2S_HEARTBEAT              = $0002;//�ն�����
  C2S_LOGIN                  = $0003;//�ն�ע��
  C2S_TERMINAL_MODULE_STATUS = $0004;//�ն�ģ��״̬�㱨
  C2S_GET_MAC2               = $0005;//��ȡMAC2
{******************************�ն˷���������******************************}

{*****************************����˷���������*****************************}
  S2C_TYRET        = $7001;//ƽ̨ͨ��Ӧ��
  S2C_LOGIN_RSP    = $7003;//�ն�ע��Ӧ��
  S2C_GET_MAC2_RSP = $7005;//��ȡmac2Ӧ��
{*****************************����˷���������*****************************}
{*********************************��������*********************************}
  CMD_START_FLAG = $7E;
  CMD_END_FLAG = $7E;

  CMD_SPEC_FLAG_7E = $7E;
  CMD_SPEC_FLAG_7D = $7D;
{*********************************��������*********************************}
type
  {
    �����ն˵�ͨ��ͷ
  }
  TSTHead = packed record
    StartFlag: Byte;
    CmdId: Word;
    ClientType: Byte;
    TerminalId: array[0..5] of Byte;//BCD
    BodySize: Short;
    CmdSNo: Short;
  end;
  PSTHead = ^TSTHead;

  {
    �����ն˵�ͨ��β
  }
  TSTEnd = packed record
    CheckSum: Byte;
    EndFlag: Byte;
  end;
  PSTEnd = ^TSTEnd;
{******************************�ն˷�������******************************}
  //�ն�ͨ��Ӧ��
  TCmdTYRetC2S = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    CmdIdRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdTYRetC2S = ^TCmdTYRetC2S;

  //�ն�����
  TCmdHeartbeatC2S = packed record
    CmdHead: TSTHead;
    CmdEnd: TSTEnd;
  end;
  PCmdHeartbeatC2S = ^TCmdHeartbeatC2S;

  //�ն�ע��
  TCmdLoginC2S = packed record
    CmdHead: TSTHead;
    Ver: Word;
    CmdEnd: TSTEnd;
  end;
  PCmdLoginC2S = ^TCmdLoginC2S;

  //�ն�ģ��״̬�㱨
  {
    ģ��1:���񿨶�дģ��
    ģ��2:�ֽ�ģ��
    ģ��3:����ģ��
    ģ��4:��ӡģ��
    ģ��5:���֤��ȡģ��
    ģ��6:�������ģ��
  }
  TCmdTerminalModuleStatusC2S = packed record
    CmdHead: TSTHead;
    ModuleCount: Byte;
//  Module1Id: Byte;
//  Module1Status: Byte;
//  ...  ...
//  ModuleNId: Byte;
//  ModuleNStatus: Byte;
//  CmdEnd: TSTEnd;
  end;
  PCmdTerminalModuleStatusC2S = ^TCmdTerminalModuleStatusC2S;

  //��ȡmac2��Ϣ
  TCmdGetMac2ForChargeC2S = packed record
    CmdHead: TSTHead;
    OperType: Byte;
    CardNo: array[0..7] of Byte;
    ASN: array[0..9] of Byte;
    FakeRandom: array[0..3] of Byte;//α�����
    CardTradeNo: array[0..1] of Byte;//
    CardOldBalance: LongWord;
    ChargeAmount: LongWord;//��ֵ��� (��λ��)
    Mac1: array[0..3] of Byte;//mac1
    ChargeDate: array[0..3] of Byte;//��ֵʱ�� BCD 20 14 07 20 14 45 23
    ChargeTime: array[0..2] of Byte;//
    CmdEnd: TSTEnd;
  end;
  PCmdGetMac2ForChargeC2S = ^TCmdGetMac2ForChargeC2S;
{******************************�ն˷�������******************************}


{*****************************����˷�������*****************************}
  //ƽ̨ͨ��Ӧ��
  TCmdTYRetS2C = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    CmdIdRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdTYRetS2C = ^TCmdTYRetS2C;

  //�ն�ע��Ӧ��
  TCmdLoginRspS2C = packed record
    CmdHead: TSTHead;
    CmdSNoRsp: Word;
    Ret: Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdLoginRspS2C = ^TCmdLoginRspS2C;

  //��ȡmac2��ϢӦ��
  TCmdGetMac2ForChargeS2C = packed record
    CmdHead: TSTHead;
    Ret: Byte;//��ȡ���  1:�ɹ�  ����:��Ч
    Mac2: array[0..3] of Byte;
    CmdEnd: TSTEnd;
  end;
  PCmdGetMac2ForChargeS2C = ^TCmdGetMac2ForChargeS2C;
{*****************************����˷�������*****************************}


  {�汾���ݽṹ
  @TABB
  @H(��ʶ      |����       |����                  |�μ�)
  @R( MinorVer |Byte       |�ΰ汾��              |  )
  @R( MinorVer |Byte       |���汾��              |  )
  @R( Version  |Word       |��16λ���ͱ�ʾ�İ汾��ֵ| )
  @TABE}
  TVer = packed record
    case integer of
      0:
      (MinorVer, MajorVer: Byte; );
      1: (Version: Word);
      2: (DevMajorVer, DevMinorVer: Byte; );
  end;

type
  TMapxWorldPoint = packed record
    longtitude: double;
    lattitude: double;
  end;
  PMapxWorldPoint = ^TMapxWorldPoint;
  TMapxWorldPointAry = array of TMapxWorldPoint;
  TDateTime_V2 = array[0..4] of byte;

{*****************  ���������ط������Ϳͻ���֮�������ṹ ********************}

  {�ն�����������͵�ȷ������ͨѶЭ������
    @TABB
    @H(��ʶ |����    |����|�μ�)
    @R( size| Word   |���ݰ��ĳ���=sizeof(TCmdTermsrvRegverData) | | )
    @R( Flag| Byte   |=TERMSRV_REG| )     //�ǲ���Ӧ���á�TERMSRV_COMMVER  --shajp��
    @R( MajorVer|Byte|����Э�����汾 | )
    @R( MinorVer|Byte|����Э��ΰ汾 | )
    @TABE
    ����Э���ʽ˵��:<br>
    [������2Byte][��־1Byt][������]<br>
    ������=�������ݰ��ĳ���
  }
  TCmdTermsrvRegverData = packed record
    Size: Word;
    Flag: Byte;
    case integer of
      0: (MinorVer, MajorVer: Byte);
      1: (Ver: Word);
  end;
  PCmdTermsrvRegverData = ^TCmdTermsrvRegverData;
  {@link(TCmdTermsrvRegverData)����Ļظ�}
  TCmdSrvtermRegverData = packed record
    Size: Word;
    Flag: Byte;
    Ret: integer;
  end;
  PCmdSrvtermRegverData = ^TCmdSrvtermRegverData;

  {�û���¼���ط�����
   @TABB
   @H(��ʶ  |����    |����|�μ�)
   @R( size |Word    |���ݰ��ĳ���=sizeof(TCmdTermsrvRegUserData) | | )
   @R( Flag |Byte    |=TERMSRV_REG| )
   @R( MajorVer|Byte | �ͻ��˵����汾��)
   @R( MinorVer|Byte | �ͻ��˵�С�汾��)
   @R( UserID  |integer| �û�ID)
   @R( UserPass|stirng | �û�����)
   @TABE
  }
  TCmdTermsrvRegUserData = packed record
    Size: Word;
    Flag: Byte;
    MajorVer, MinorVer: Byte;
    UserID: integer;
    UserPass: string[20];
  end;
  PCmdTermsrvRegUserData = ^TCmdTermsrvRegUserData;
  {�û���¼����ķ���@link(TCmdTermsrvRegUserData)}
  TCmdSrvtermRegUserData = packed record
    Size: Word;
    Flag: Byte;
    Ret: integer;
    ServerVer: TVer;
  end;
  PCmdSrvtermRegUserData = ^TCmdSrvtermRegUserData;

  {�ն������ط����������ȡ�豸�����һ��λ�ã���Ч�ģ�״̬����
  @TABB
  @H(��ʶ  | ����    |����                  |�μ�)
  @R( size | Word    |���ݰ��ĳ���=sizeof() | | )
  @R( Flag | Byte    |=| )
  @R( CmdId| | )
  @R( DevId| | )
  @TABE}
  TCmdTermsrvGetlastPosData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetlastPosData = ^TCmdTermsrvGetlastPosData;
  TCmdTermsrvGetlastStation = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetlastStation = ^TCmdTermsrvGetlastStation;
  {��ȡ�ƶ�Ŀ������һ��λ��״̬��������ִ�еķ��ؽ��
    @TABB
    @H(��ʶ  | ����  |����         |�μ�)
    @R( Size | Word  | ���ݰ��ĳ���| )
    @R( Flag | Byte  | ����ı�־  | )
    @R( CmdId|Integer| ����ID      | )
    @R( Ret  |Integer| ����ֵ      | )
    @TABE
  }
  TCmdSrvtermGetlastPosData = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvtermGetlastPosData = ^TCmdSrvtermGetlastPosData;

  {��ȡGPS�豸״̬}
  TCmdTermsrvGetstatData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetstatData = ^TCmdTermsrvGetstatData;

  {��ȡGPS�豸״̬�ķ���ֵ}
  TCmdSrvtermGetstatData = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
    case integer of
      0: ();
      1: (
        MajorVer: Byte;
        MinorVer: Byte;
        Freq: Word;
        AutoSend: Byte;
         //BatteryVoltage: Word;
         //Batterytemperature: Word;
        HaveMoreInfo: Byte);
  end;
  PCmdSrvtermGetstatData = ^TCmdSrvtermGetstatData;

  {����GPS�豸�Ķ�λ����}
  TCmdSrvtermGpsdata = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    Long: integer;
    Lat: integer;
    GpsTime: array[0..5] of Byte;
    Altitude: Word;
    Speed: Word;
    Angle: Word;
    Stat: Byte;
    Switch: Byte;
  end;
  PCmdSrvtermGpsdata = ^TCmdSrvtermGpsdata;

  {�������GPS����}
  TGpsData = packed record
    Size: Byte;
    Id: integer;
    Long: Double;
    Lat: Double;
    GpsTime: TDateTime;
    Speed: integer;
    Altitude: integer;
    Angle: integer;
    IO: Word; //��8λ��ʾ��ͷ,��8λ��ʾ�豸״̬
    //��8λ��0λ��ʾ��λ״̬,1λ��ʾGPRS����״̬
  end;
  PGpsData = ^TGpsData;

  {���г�������
    @TABB
    @H(��ʶ      |����   |  ����                      |�μ�)
    @R( Size     | Word  |=sizeof(TCmdTermsrvCalldev) | )
    @R( Flag     | Byte  |=TERMSRV_CALLDEV            | )
    @R( CmdId    |Integer|����ID                      | )
    @R( DevId |Integer|Ҫ���е��ƶ�Ŀ��ID          | )
    @R( Freq     | Word  |���к������ݵ�Ƶ��        | )
    @R( HoldTime | Word  | ���г�����ʱ��             | )
    @R( AvailTime| Byte  |���������������б��е���Ч��(����)��������Ч����û�б�ִ�о�ȡ��| )
    @TABE
  }
  TCmdTermsrvCalldev = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
    Freq, HoldTime: Word;
    AvailTime: Byte;
  end;
  PCmdTermsrvCalldev = ^TCmdTermsrvCalldev;

  TCmdSrvtermCalldev = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId, Ret: integer;
    Freq, HoldTime: Word;
  end;
  PCmdSrvtermCalldev = ^TCmdSrvtermCalldev;

  {��������
    @TABB
    @H(��ʶ       | ����  |����                   |�μ�)
    @R( Size      |Word   |���ݰ�����             | )
    @R( Flag      |Byte   |�����־               | )
    @R( CmdID     |integer|������               | )
    @R( DevId  |integer|Ŀ��ID                 | )
    @R( SwitchId  | Byte  | �̵���ID              | )
    @R( SwitchStat| Stat  | �̵���״̬��0�Ͽ�����1����| )
    @TABE
  }
  TCmdTermsrvSwitchCtrlData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
    SwitchId, SwitchStat: Byte;
  end;
  PCmdTermsrvSwitchCtrlData = ^TCmdTermsrvSwitchCtrlData;

  TCmdSrvtermSwitchCtrlData = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId, Ret: integer;
    SwitchId, SwitchStat: Byte;
  end;
  PCmdSrvtermSwitchCtrlData = ^TCmdSrvtermSwitchCtrlData;

 {
  TERMSRV_SENDDEVMSG  = $08;
  SRVTERM_SENDDEVMSG  = $88;
  ���ͼ����Ϣ���豸}
  TCmdTermSrvDevMsgHeader = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word;
    MsgType: Byte
    //MsgContent:TBytes;
  end;
  PCmdTermSrvDevMsgHeader = ^TCmdTermSrvDevMsgHeader;

  {��������Ӧ�ͻ��˷��͵�����"���ͼ����Ϣ���豸"}
  TCmdSrvTermDevMsg = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word;
    Ret: integer;
  end;
  PCmdSrvTermDevMsg = ^TCmdSrvTermDevMsg;


  {�ͻ���PING������}
  TCmdTermsrvPingData = packed record
    Size: Word;
    Flag: Byte; //TERMSRV_PING
    CmdId, TimeStamp: Longword;
  end;
  PCmdTermsrvPingData = ^TCmdTermsrvPingData;
  {��������PING����Ӧ}
  TCmdSrvterPingData = packed record
    Size: Word;
    Flag: Byte; //SRVTERM_PING
    CmdId, TimeStamp: Longword;
  end;
  PCmdSrvterPingData = ^TCmdSrvterPingData;

  {�����������ݸ��µ�֪ͨ��
  ֪ͨ�ͻ���Ҫˢ��ָ�����豸����Ϣ}
  TSrvtermNotifystat = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    ChangeFlag: Byte;
  end;
  PSrvtermNOtifystat = ^TSrvtermNotifystat;

  {  ȡ������ִ�е�����
     @TABB
     @H(��ʶ|  ����   |����                             |�μ�)
     @R( Size| Word   |=sizeof(TCmdTermsrvCancelCmdData)|  )
     @R( Flag| Byte   |=TERMSRV_CANCELCMD               | )
     @R( CmdID|integer| ���������ID                    | )
     @R( CmdTobeCancel| integer| Ҫȡ��������ID         | )
     @TABE
  }
  TCmdTermsrvCancelCmd = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    CmdTobeCancel: integer;
  end;
  PCmdTermsrvCancelCmd = ^TCmdTermsrvCancelCmd;

  {  ȡ������ִ�е�����ķ�������������Ӧ
     @TABB
     @H(��ʶ|  ����   |����                             |�μ�)
     @R( Size| Word   |=sizeof(TCmdSrvTermCancelCmdData)|  )
     @R( Flag| Byte   |=SRVTERM_CANCELCMD               | )
     @R( CmdID|integer| ���������ID                    | )
     @R( CmdTobeCancel| integer| Ҫȡ��������ID         | )
     @R( Ret | integer| �������ķ���ֵ                | )
     @TABE
  }
  TCmdSrvTermCancelCmd = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    CmdTobeCancel: integer;
    Ret: integer;
  end;
  PCmdSrvTermCancelCmd = ^TCmdSrvTermCancelCmd;

 {   ����������DTE
     @TABB
     @H(��ʶ|  ����   |����                             |�μ�)
     @R( Size| Word   |=sizeof(TCmdSrvTermCancelCmdData)|  )
     @R( Flag| Byte   |=SRVTERM_CANCELCMD               | )
     @R( CmdID|integer| ���������ID                    | )
     @R( CmdTobeCancel| integer| Ҫȡ��������ID         | )
     @R( Ret | integer| �������ķ���ֵ                | )
     @TABE
  }
  TCmdTermSrvSendToDTEHeader = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    DataLen: Byte;
  end;
  PCmdTermSrvSendToDTEHeader = ^TCmdTermSrvSendToDTEHeader;

  {��������������Ӧ����}
  TCmdSrvTermSendToDTE = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvTermSendToDTE = ^TCmdSrvTermSendToDTE;

  {SRVTERM_DEVTOHOST,�յ�Dev���͵�Host������}
  TCmdSrvTermRecvFromDTEHeader = TCmdTermSrvSendToDTEHeader;
  PCmdSrvTermRecvFromDTEHeader = ^TCmdSrvTermRecvFromDTEHeader;

  {���ܷ��������͵�֪ͨ��Ϣ
  CmdFlag	1Byte	SRVTERM_SENDMSG
  Msg	1Byte
  Data	Bytes[DataLen]
  }
  TCmdSrvTermSendMsg = packed record
    Size: Word;
    Flag: Byte;
    MsgLen: Byte;
  end;
  PCmdSrvTermSendMsg = ^TCmdSrvTermSendMsg;

  {���ɾ����֪ͨ�ͻ���}
  TCmdSrvTermCmdDeleted = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer; //��ɾ��������ID
    DelType: Byte; //��ɾ����ԭ������ 1-ɾ����2-����� 3-��ʱ
  end;
  PCmdSrvTermCmdDeleted = ^TCmdSrvTermCmdDeleted;

  {
  �ͻ��˷��������ȡ�豸�Ĳ�����
  TERMSRV_READDEVPARAM
  }
  TcmdTermSrvReadDevParam = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ReadNum: Byte; // add by sha 2004-10-27
  end;
  PCmdTermSrvReadDevParam = ^TcmdTermSrvReadDevParam;

{���ص��豸�Ĳ������ݰ�ͷ �����������Ϊ([�������][����ֵ])
  SRVTERM_SETDEVPARAM}
  TCmdSrvTermReadDevParamRet = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
    //params
  end;
  PCmdSrvTermReadDevParamRet = ^TCmdSrvTermReadDevParamRet;

  {�����豸�Ĳ���@link(TCmdSrvTermReadDevParam)}
  TCmdTermSrvSetDevParam = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //params
  end;
  PCmdTermSrvSetDevParam = ^TCmdTermSrvSetDevParam;

  {�����豸����������ִ�з�������}
  TCmdSrvTermSetDevParamRet = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvTermSetDevParamRet = ^TCmdSrvTermSetDevParamRet;


  {ͨ��UDP�˿�֪ͨ��Ҫ�����ݿ���ˢ���µ����ݵ�����
    @TABB
    @H(��ʶ        |����   |����|�μ�)
    @R( Flag       |Byte   | �����ʶ=DBSRV_REFRESH| )
    @R( CmdId      |integer| ����ID| )
    @R( RefreshType|Byte   | ����ˢ�µ�����| )
    @TABE
    ����ˢ�����ͣ�
    <li>����������ϵ�����仯       =$01
    <li>���������鷽����Ϣ�����仯 =$02
    <li>����-������Ӧ�����仯      =$04
  }
  TCmdDBSrvRefresh = packed record
    CmdFlag: Word;
    ExeFlag: Byte;
    CmdId: integer;
    RefreshType: Byte;
  end;
  PCmdDBSrvRefresh = ^TCmdDBSrvRefresh;


  (**************�ͻ��������� V2.0�桡���������� ***********)
  {��ȡGPS�豸״̬}
  TCmdTermsrvGetstatData_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId, DevId: integer;
  end;
  PCmdTermsrvGetstatData_V2 = ^TCmdTermsrvGetstatData_V2;

  {��ȡGPS�豸״̬�ķ���ֵ}
  TCmdSrvtermGetstatData_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
    case integer of
      0: ();
      1: (
        DevVer: Word; //�����汾��
        DevRegTime: TDateTime; //������¼ʱ��
        );
  end;
  PCmdSrvtermGetstatData_V2 = ^TCmdSrvtermGetstatData_V2;

  {��λ���ȡ�ó����ĵ�ǰ��λ����   Flag= TERMSRV_GETPOSITION}
  TCmdTermSrvGetPosition = packed record
    Size: Word;
    Flag: Byte; //������
    CmdId: integer; //�������
    DevId: integer;
  end;
  PCmdTermSrvGetPosition = ^TCmdTermSrvGetPosition;
  {���ػظ���Flag= SRVTERM_GETPOSITION}
  TCmdSrvTermGetPosition = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermGetPosition = ^TCmdSrvTermGetPosition;
  {������ȡ�ó�����λ���� Flag= SRVTERM_GPSDATA_V2}
  TCmdSrvTermGpsData_V2 = packed record
    Size: Word;
    Flag: Byte;
    //CmdID:integer; ��CmdID
    DevId: integer;
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    Speed: Byte; //�ٶȡ���λ������/Сʱ����ʾ��Χ0��255
    Orientation: Byte; //������������Ϊ0�ȣ�˳ʱ�����ӣ���λ��2�ȣ���ֵ��Χ0��180��
    State: Longword; //32λ״̬λ
    GpsTime: array[0..5] of Byte; // GPSʱ��
  end;
  PCmdSrvTermGpsData_V2 = ^TCmdSrvTermGpsData_V2;

  TCmdSrvTermGpsData_XM = packed record //�޸�08-8-11(AYH)
    Size: word;
    Flag: Byte;
    DevId: integer;
    gpsType: byte; //GPS��������
    GpsTime: array[0..5] of Byte; // GPSʱ��
    IsLocat: Byte; //��λ״̬  0����λ 1������λ
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    High: integer; //�߶�
    Speed: integer; //�ٶ�
    Dir: integer; //����
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //����״̬
    runType: byte; //����״̬
    TotalCourse: array[0..2] of Byte;//�ۼ����
    //SpeedLimit: Byte;//����ֵ
  end;
  PCmdSrvTermGpsData_XM = ^TCmdSrvTermGpsData_XM;
  TGpsData_XM = packed record
    Size: Byte;
    ID: Integer;
    GpsType: Byte;
    GpsTime: TDateTime;
    Latitude: Double;
    Longitude: Double;
    High: Double;
    Speed: Integer;
    Dir: Double;
    IsLocate: Byte;
    S1: Byte;
    S2: Byte;
    S3: Byte;
    S4: Byte;
    RunType: Byte;
    TotalCourse: array[0..2] of Byte;//�ۼ����
    SpeedLimited: Byte; //����ֵ
    Temperature: SmallInt;
  end;
  PGpsData_XM = ^TGpsData_XM;

 {�ͻ��˴���ʱ���õ�GpsData_V2}
  TGpsData_V2 = packed record
    Size: Byte;
    Id: integer;
    Long: Double; //������ת�������� eg: 118.123456
    Lat: Double; //������ת����γ�� eg:  32.123456
    Speed: Byte; //�ٶȡ���λ������/Сʱ����ʾ��Χ0��255
    Orientation: Word; //������ת����������������Ϊ0�ȣ�˳ʱ�����ӣ���λ����
    State: Longword; //32λ״̬λ
    GpsTime: TDateTime;
  end;
  PGpsData_V2 = ^TGpsData_V2;


  {׷�ٳ��� �޸�08-8-11(AYH)
  @TABB
     @H(��ʶ           |  ����  |����                             |�μ�)
     @R( Size          | Word   |=sizeof(TCmdTermSrvPursue)       |  )
     @R( Flag          | Byte   |=TERMSRV_PURSUE                  | )
     @R( CmdID         | integer| ������������                  | )
     @R( DevID         | integer| Ҫ׷�ٳ���ID                    | )
     @R( PursueMinute  | Byte   | ��λ����                        | )
     @R( PursueSecond | Byte   | ��λ����                         | )
     @R( PursueNum    | Word    |׷�ٴ���                         | )
     @TABE
  }
  TCmdTermSrvPursue = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    PursueMinut: Byte;
    PursueSecond: Byte;
    PursueNum: Word;
  end;
  PCmdTermSrvPursue = ^TCmdTermSrvPursue;
  {���ػظ���SRVTERM_PURSUE}
  TCmdSrvTermPursue = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermPursue = ^TCmdSrvTermPursue;

  {���ò��� TERMSRV_SETDEVPARAM_V2}
  TCmdTermSrvSetDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ParamId: Word;
    //����ֵ ���Ȳ���
  end;
  PCmdTermSrvSetDevParam_V2 = ^TCmdTermSrvSetDevParam_V2;
  {���ػظ���SRVTERM_SETDEVPARAM_V2}
  TCmdSrvTermSetDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: integer;
  end;
  PCmdSrvTermSetDevParam_V2 = ^TCmdSrvTermSetDevParam_V2;
  TCmdSrvTermSetStationParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: byte;
  end;
  PCmdSrvTermSetStationParam_V2 = ^TCmdSrvTermSetStationParam_V2;
  {��ѯ���� TERMSRV_READDEVPARAM_V2}
  TCmdTermSrvReadDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ParamId: Word; //����ID
  end;
  PCmdTermSrvReadDevParam_V2 = ^TCmdTermSrvReadDevParam_V2;
  {���ػظ���SRVTERM_READDEVPARAM_V2}
  TCmdSrvTermReadDevParam_V2 = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ReadRet: Byte; //   ��ѯ���0���ɹ�  1��ʧ��
    ParamId: Word; //   ����ID
    ParamLen: Byte; //   ��������
    //����ֵ�������Ȳ���
  end;
  PCmdSrvTermReadDevParam_V2 = ^TCmdSrvTermReadDevParam_V2;
  TCmdSrvTermReadDevParam_Bus = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    ReadRet: Byte; //   ��ѯ���0���ɹ�  1��ʧ��
    ParamId: Word; //   ����ID
    ParamLen: Word; //   ��������
    //����ֵ�������Ȳ���
  end;
  PCmdSrvTermReadDevParam_Bus = ^TCmdSrvTermReadDevParam_Bus;
  {������� TERMSRV_REMOVEALARM}
  TCmdTermSrvRemoveAlarm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
  end;
  PCmdTermSrvRemoveAlarm = ^TCmdTermSrvRemoveAlarm;
  {���ػظ���SRVTERM_REMOVEALARM}
  TCmdSrvTermRemoveAlarm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermRemoveAlarm = ^TCmdSrvTermRemoveAlarm;

  {�����ı�������Ϣ TERMSRV_SENDCONTROLINFO}
  TCmdTermSrvSendControlInfo = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgLen: Byte; //��Ϣ����//�޸�08-8-11(AYH)
    //MsgID: Word; //������ϢID�������ݿ���ȡֵ
    //������Ϣ ������ ��<200Byte
  end;
  PCmdTermSrvSendControlInfo = ^TCmdTermSrvSendControlInfo;
  {���ػظ�}
  TCmdSrvTermSendControlInfo = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
   // MsgID: Word; //������ϢID�������ݿ���ȡֵ
    Ret: Byte;
  end;
  PCmdSrvTermSendControlInfo = ^TCmdSrvTermSendControlInfo;

  {������ظ��ĵ�����Ϣ TERMSRV_SENDCONTROLINFO_NEEDDEVANSWER}
  TCmdTermSrvSendControlInfo_NeedDevAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word; //������ϢID�������ݿ���ȡֵ
    //������Ϣ ������ ��<200Byte
  end;
  PCmdTermSrvSendControlInfo_NeedDevAnswer = ^TCmdTermSrvSendControlInfo_NeedDevAnswer;
  {���ػظ�}
  TCmdSrvTermSendControlInfo_NeedDevAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    MsgID: Word; //������ϢID�������ݿ���ȡֵ
    Ret: Byte;
  end;
  PCmdSrvTermSendControlInfo_NeedDevAnswer = ^TCmdSrvTermSendControlInfo_NeedDevAnswer;

  {���õ绰�� TERMSRV_SETTELLIST}
  TCmdTermSrvSetTelList = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //�绰�б� ������
  end;
  PCmdTermSrvSetTelList = ^TCmdTermSrvSetTelList;
  {���ػظ���SRVTERM_SETTELLIST}
  TCmdSrvTermSetTelList = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermSetTelList = ^TCmdSrvTermSetTelList;

  TCmdSrvTermAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermAnswer = ^TCmdSrvTermAnswer;

  {���������̼����� TERMSRV_UPDATEDEVFIRMWARE}
  TCmdTermSrvUpdateDevFirmware = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    UpdateType: Byte; //�����豸���ͣ���0����ʾ��������1����ʾ����������
    //URL��ַ ��������200Byte
  end;
  PCmdTermSrvUpdateDevFirmware = ^TCmdTermSrvUpdateDevFirmware;
  {���ػظ�}
  TCmdSrvTermUpdateDevFirmware = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermUpdateDevFirmware = ^TCmdSrvTermUpdateDevFirmware;

  {��ضˡ��������أ��Գ�������/�ϵ�/����/���硡TERMSRV_CUTORFEED_OIL_ELECTRICITY = $21;}
  TCmdTermSrvCutOrFeedOilOrElectricity = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Content: Byte; //����������ݣ�����/�ϵ�/����/����,�ó�����ʾ��
  end;
  PCmdTermSrvCutOrFeedOilOrElectricity = ^TCmdTermSrvCutOrFeedOilOrElectricity;
  {���ػظ��� SRVTERM_CUTORFEED_OIL_ELECTRICITY     = $C4;}
  TCmdSrvTermCutOrFeedOilOrElectricity = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermCutOrFeedOilOrElectricity = ^TCmdSrvTermCutOrFeedOilOrElectricity;

  {��ض˸�����������0200}
  {���ػظ���}
  TCmdSrvTermHeartBeat = packed record
    Size: Word; //=3
    Flag: Byte; // SRVTERM_HEARTBEAT =$F0;
  end;
  PCmdSrvTermHeartBeat = ^TCmdSrvTermHeartBeat;

  {��ض� -> ���� �������汾 TERMSRV_READDEVVER = $23}
  TCmdTermSrvReadDevVer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
  end;
  PCmdTermSrvReadDevVer = ^TCmdTermSrvReadDevVer;
  { ���ػظ��������ϴ��������汾��SRVTERM_READDEVVER = $C6}
  TCmdSrvTermReadDevVer = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
    //DevVer ���������Ϊ32�ֽ�
  end;
  PCmdSrvTermReadDevVer = ^TCmdSrvTermReadDevVer;

  //��ض� -> ���� ����˾����ϢTERMSRV_SETDRIVERS   = $24;
  TCmdTermSrvSetDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    DriverNo1: array[0..9] of char; //����.���㲿�ݲ�0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
  end;
  PCmdTermSrvSetDrivers = ^TCmdTermSrvSetDrivers;
  //���ػظ�      SRVTERM_SETDRIVERS  = $C7;
  TCmdSrvTermSetDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermSetDrivers = ^TCmdSrvTermSetDrivers;

  //��ض� -> ����  ��ȡ˾����ϢTERMSRV_READDRIVERS  = $25;
  TCmdTermSrvReadDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
  end;
  PCmdTermSrvReadDrivers = ^TCmdTermSrvReadDrivers;
  //���ػظ�     SRVTERM_READDRIVERS    = $C8;
  TCmdSrvTermReadDrivers = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    DriverNo1: array[0..9] of char; //����.���㲿�ݲ�0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
    Ret: Byte;
  end;
  PCmdSrvTermReadDrivers = ^TCmdSrvTermReadDrivers;

  //����-���ͻ���  �ϴ�������վ���վ SRVTERM_INORDOWNSTATION = $D5
  TCmdSrvTermInOrDownStation = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    StationNo: byte;
    Direct: Byte;
    InOrDown: Byte;
  end;
  PCmdSrvTermInOrDownStation = ^TCmdSrvTermInOrDownStation;

  TCmdSrvTermInOrDownStation_XM = packed record //�޸�
    Size: Word;
    Flag: Byte;
    DevId: Integer; //����ID
    StationNo: byte; //վ�����
    onOrDown: Byte; //0x01:����  0x02:����
    GTime: array[0..5] of byte; //������վʱ��
    STime: array[0..5] of byte; // ������վʱ�� ������ʱ��
    InOrOut: byte; //0x01:��վ  0x02:��վ
    SrcType: byte; //��Դ��־  0x01:����  0x02:��վ
    gpsType: byte; //GPS��������
    GpsTime: array[0..5] of Byte; // GPSʱ��
    IsLocat: Byte; //��λ״̬  0����λ 1������λ
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    High: integer; //�߶�
    Speed: integer; //�ٶ�
    Dir: integer; //����
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //����״̬
    runType: byte; //����״̬
    bSendAgain: Byte; //�Ƿ񲹷���0������ 1-��������
    TotalCourse: array[0..2] of Byte;//�ۼ����
    { ���Ϲ�64�ֽ�
      *******************������Ϣ*********************
      ������Ϣ����ɣ�������Ϣ����(N)��������Ϣ��N ���£�
        �ֶ�       	   ����	                  ����       ����(�ֽ�)	           ��ע
      ������Ϣ��  ������Ϣ���ܸ���            Byte          1
      ������Ϣ1   ������Ϣ1���               Byte          1            ���ݲ�ͬӦ��ϵͳ����Լ��
                  ������Ϣ1�����ֽ���         Byte          1
                  ������Ϣ1����               Byte(N)     ������         ���ݲ�ͬӦ��ϵͳ����Լ��
      ������Ϣ2   ������Ϣ2���               Byte          1            ���ݲ�ͬӦ��ϵͳ����Լ��
                  ������Ϣ2�����ֽ���         Byte          1
                  ������Ϣ2����               Byte(N)     ������         ���ݲ�ͬӦ��ϵͳ����Լ��
      ������	������	������
    }
  end;
  PCmdSrvTermInOrDownStation_XM = ^TCmdSrvTermInOrDownStation_XM;

  TCmdSrvTermInOrDownStation_XM_New = packed record //�޸�
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer; //����ID
    StationNo: byte; //վ�����
    onOrDown: Byte; //0x01:����  0x02:����
    GTime: array[0..5] of byte; //������վʱ��
    STime: array[0..5] of byte; // ������վʱ�� ������ʱ��
    InOrOut: byte; //0x01:��վ  0x02:��վ
    SrcType: byte; //��Դ��־  0x01:����  0x02:��վ
    gpsType: byte; //GPS��������
    GpsTime: array[0..5] of Byte; // GPSʱ��
    IsLocat: Byte; //��λ״̬  0����λ 1������λ
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    High: integer; //�߶�
    Speed: integer; //�ٶ�
    Dir: integer; //����
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //����״̬
    runType: byte; //����״̬
    bSendAgain: Byte; //�Ƿ񲹷���0������ 1-��������
    TotalCourse: array[0..2] of Byte;//�ۼ����
  end;
  PCmdSrvTermInOrDownStation_XM_New = ^TCmdSrvTermInOrDownStation_XM_New;


  //����->�ͻ���  �ϴ������ӷ�����ע��  SRVTERM_DEVLOGOUTFROMSRV = $B8;
  TCmdSrvTermDevLogOutFromSrv = packed record
    Size: Word;
    Flag: byte;
    DevId: integer;
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    Speed: Byte; //�ٶȡ���λ������/Сʱ����ʾ��Χ0��255
    Orientation: Byte; //������������Ϊ0�ȣ�˳ʱ�����ӣ���λ��2�ȣ���ֵ��Χ0��180��
    State: Longword; //32λ״̬λ
    GpsTime: array[0..5] of Byte;
  end;
  PCmdSrvTermDevLogOutFromSrv = ^TCmdSrvTermDevLogOutFromSrv;
  //����-���ͻ���  �ϴ��������ټ�¼  SRVTERM_OVERSPEEDINFO = $D7
  TCmdSrvTermOverSpeedInfo = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    AreaNo: integer;
    overSpeedTime: array[0..5] of byte;
    IsBengin: byte;
  end;
  PCmdSrvTermOverSpeedInfo = ^TCmdSrvTermOverSpeedInfo;
  //����-���ͻ���  �ϴ���ʻԱ��½������յ�վ
  TCmdSrvTermUploadStartOrEndStation = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    OnOrDown: Byte;
    StartOrEnd: Byte;
    TotalCourse: Double;
  end;
  PCmdSrvTermUploadStartOrEndStation = ^TCmdSrvTermUploadStartOrEndStation;

  //����-���ͻ���  �ϴ���ʻԱ��½������յ�վ(˼����˾��)
  TCmdSrvTermUploadStartOrEndStation_SM = packed record
    Size: Word;
    Flag: Byte;
    DevId: Integer;
    OnOrDown: Byte;
    StartOrEnd: Byte;
    //���ºͶ�λ������ͬ
    GpsData: TCmdSrvTermGpsData_XM;
//    gpsType: byte; //GPS��������
//    GpsTime: array[0..5] of Byte; // GPSʱ��
//    IsLocat: Byte; //��λ״̬  0����λ 1������λ
//    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
//    Longitude: integer; //���� X 100 0000
//    High: integer; //�߶�
//    Speed: integer; //�ٶ�
//    Dir: integer; //����
//    S1: byte;
//    S2: Byte;
//    S3: byte;
//    S4: byte;
//    S: array[0..3] of byte; //����״̬
//    runType: byte; //����״̬
  end;
  PCmdSrvTermUploadStartOrEndStation_SM = ^TCmdSrvTermUploadStartOrEndStation_SM;

  //����ת������ͨ�Ƽ���Ӫ������
  //����-���ͻ���  ˾����½  SRVTERM_DRIVERON = $DA
  TCmdSrvTermDriverOn = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//�ۼ����
    //UserId: Integer;
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOn = ^TCmdSrvTermDriverOn;
  //���� -���ͻ���  ˾���˳� SRVTERM_DRIVEROFF = $DB
  TCmdSrvTermDriverOff = packed record
    Size: Word;
    Flag: byte;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LogOutTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//�ۼ����
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOff = ^TCmdSrvTermDriverOff;

  TCmdSrvTermDriverOn_New = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//�ۼ����
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOn_New = ^TCmdSrvTermDriverOn_New;

  TCmdSrvTermDriverOnWithUser = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//�ۼ����
    UserId: Integer;
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOnWithUser = ^TCmdSrvTermDriverOnWithUser;

  //���� -���ͻ���  ˾���˳� SRVTERM_DRIVEROFF = $DB
  TCmdSrvTermDriverOff_New = packed record
    Size: Word;
    Flag: byte;
    CmdId: Integer;
    DevId: integer;
    DriverNo: array[0..9] of Byte;
    LogOutTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//�ۼ����
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdSrvTermDriverOff_New = ^TCmdSrvTermDriverOff_New;

   //�ͻ���->���� ���գ��ĵ�ǰ��Ƭ TERMSRV_GETAPIC= $27;
  TCmdTermSrvGetAPic = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    GetPicSize: Byte; //��Ƭ�ߴ��С 0=320x240  1=640x480  2-else
    CameraIndex: Byte; //����ͷ��
  end;
  PCmdTermSrvGetAPic = ^TCmdTermSrvGetAPic;
  //���ػظ�  SRVTERM_GETAPIC= $CB;
  TCmdSrvTermGetAPic = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermGetAPic = ^TCmdSrvTermGetAPic;
  //====================================================================================
  //�ͻ���-������  ��ȡ��ǰ����������վ����Ϣ     TERMSRV_DOWNLED_NEW
  TCmdSrvReadDevStation = packed record
    Size: word;
    Flag: byte;
    DevId: integer;
  end;
  PCmdSrvReadDevStation = ^TCmdSrvReadDevStation;
  //���ػظ�������վ��Ϣ

  // �ͻ���->���أ����ó����������Ⲧ��ļ������� 2007-9-24  TERMSRV_DOWNLISTENCALLNUM = $2E;
  TCmdTermSrvDownListenCallNum = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //ListenCallNum :<20 ASCII��
  end;
  PCmdTermSrvDownListenCallNum = ^TCmdTermSrvDownListenCallNum;
  //���ػظ�  SRVTERM_DOWNLISTENCALLNUM = $D2;
  TCmdSrvTermDownListenCallNum = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermDownListenCallNum = ^TCmdSrvTermDownListenCallNum;

  //�ͻ���->���أ��ͻ��˷���ͨ�õ�������ز�������� 2007-10-08  TERMSRV_DOWNGENERICCOMMAND = $2F
  TCmdTermSrvDownGenicCommand = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    //��������
  end;
  PCmdTermSrvDownGenicCommand = ^TCmdTermSrvDownGenicCommand;
  //���ػظ�   SRVTERM_DOWNGENERICCOMMAND = $D3
  TCmdSrvTermDownGeniccommand = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: Byte;
  end;
  PCmdSrvTermDownGeniccommand = ^TCmdSrvTermDownGeniccommand;

  (****����Ϊ�����������ͻ��˵�����***)
  {���ظ��ͻ��ˣ�˾���� ��ظ��ĵ�����Ϣ �Ļظ������ǡ��򡰷� SRVTERM_SENDCONTROLINFO_DRIVERANSWER}
  TCmdSrvTermSendControlInfo_DriverAnswer = packed record
    Size: Word;
    Flag: Byte;
    //CmdID:integer; ��CmcID
    DevId: integer;
    MsgID: Word; //������ϢID�������ݿ���ȡֵ
    AnswerInfo: Byte; //˾��������Ϣ - 0����  1����
  end;
  PCmdSrvTermSendControlInfo_DriverAnswer = ^TCmdSrvTermSendControlInfo_DriverAnswer;

  //���ظ�֪�ͻ��� �յ������ѳɹ��ϴ��µ���Ƭ SRVTERM_APICUPLOADED = $B5;
  TCmdSrvTermAPicUploaded = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    PicIndex: integer; //�ó�������Ƭ���
    CameraIndex: Byte; //����ͷ��
    PicReson: Byte; //����ԭ��
    DoneRet: Byte; //���ս����0-�ɹ���1-��Ƭ��������2-����ͷ����3-����ʧ��
  end;
  PCmdSrvTermAPicUploaded = ^TCmdSrvTermAPicUploaded;

{********************  �����Ƿ�������GPS�����豸֮�������ṹ   *********************}
  {IP��ַ��}
  TInetAddr = packed record
    a: Byte;
    b: Byte;
    c: Byte;
    d: Byte;
  end;

  {  1.1��ͳһ�ĳ����豸��������ͷ��ʽ
     @TABB
     @H( ��ʶ    | ����   | ����        |�μ�)
     @R( CmdFlag | byte   | �����־    | )
     @R( ExecFlag| byte   | ����ִ��״̬| )
     @R( DevID   | integer| �豸ID      | )
     @TABE
  }
  TCmdDevHeader = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    case integer of
      0: (Execute: Byte);
      1: (CheckSum: Byte);
  end;
  PCmdDevHeader = ^TCmdDevHeader;


  {�豸ע�������,�����豸���������������������֤��Ϣ
  DEV_LOGIN        =$FE;}
 {
  ������	1Byte	������Ϊ�������ݰ��ĳ��ȡ�
  �豸��ʶ	4Byte
  ������=0xFE	1Byte
  �豸IP	4Byte
  �豸Port	2Byte
  Э��汾	2Byte
  �豸�汾	2Byte
  У��	1Byte
 }
  TCmdDevSrvLogon = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    DevIP: TInetAddr;
    Port: Word;
    CommVer: TVer;
    DevVer: TVer;
    CheckSum: Byte;
  end;
  PCmdDevSrvLogon = ^TCmdDevSrvLogon;

  {ע������ķ���ֵ Ret 0x00-ע��ɹ�0x01-ע��ʧ��}
  TCmdDevSrvLogonRet = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    Ret: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvLogonRet = ^TCmdDevSrvLogonRet;

  {�豸ע��
  DEV_LOGOFF       =$FF;
  @TABB
  @H(��ʶ   | ����    |����                  |�μ�)
  @R( size  | Word    |���ݰ��ĳ���=sizeof() |  )
  @R( DevID | Byte    |�豸��ʶ              | )
  @R( CmdFlag |       |������                | )
  @R( Execute| Byte   |����ִ��״̬          | )
  @R(LogOffReason|Byte| ע��ԭ��)
  @R( CheckSum|Byte   |У�� )
  @TABE
  }
  TCmdDevSrvLogOff = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    Execute: Byte;
    LogOffReason: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvLogOff = ^TCmdDevSrvLogOff;

  {��ͨGPS���� DEV_NGPSDATA     =$10;
  ������=0x10	1Byte
  ����	4Byte	��λ��ddd��mm.mmm�֣�
  γ��	4Byte	��λ��ddd��mm.mmm�֣�
  �ٶ�	2Byte	��λ 0.1����/Сʱ = 0.1852����/Сʱ
  ʱ��	6Byte	YY-MM-DD HH mm SS
  �豸״̬	1Byte	Bit0 GPS��λ״̬  Bit1 GPRS����״̬  ��������
  OI״̬	  1Byte	Bit0 ��ʾ������ť
  ע����������û�� �߶� ����
  }
  TCmdDevSrvNGpsData = packed record
    Size: Byte;
    DevId: integer;
    Flag: Byte;
    Long: array[0..3] of Byte;
    Lat: array[0..3] of Byte;
    Speed: array[0..1] of Byte;
    GpsTime: array[0..5] of Byte;
    Stat: Byte;
    Switch: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvNGpsData = ^TCmdDevSrvNGpsData;


  {������GPS����,�豸���͵�����GPS���ݼ�¼
  }
  TBatchGpsData = packed record
    //Long: Integer;
    //Lat:  Integer;
    Long: array[0..3] of Byte;
    Lat: array[0..3] of Byte;
    //Speed: Word;
    Speed: array[0..1] of Byte;
    Stat: Byte;
    Switch: Byte;
  end;
  PBatchGpsData = ^TBatchGpsData;

  {����GPS����<br>
  DEV_BGPSDATA     =$12;
  @TABB
  @H(��ʶ    |����    |����                  |�μ�)
  @R( size   |Word    |������	1Byte	������Ϊ�������ݰ��ĳ���| )
  @R( DevID  |longword| �豸ID|)
  @R( CmdFlag|Byte    |=$12| )
  @R( ETime  |Byte[6] |���һ������ʱ��ʱ�� |)
  @R( InterVal|Word   |���ʱ��,�豸���͵�BigEnd�ֽ�˳�������| )
  @R( RecordCount|Byte|��¼���� n	1Byte )
  @TABE
  }
  TCmdDevSrvBGpsDataHeader = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ETime: array[0..5] of Byte;
    InterVal: Word;
    RecordCount: Byte;
    //n*record:  TBatchGpsData[]
    //CheckSum:Byte;
  end;
  PCmdDevSrvBGpsDataHeader = ^TCmdDevSrvBGpsDataHeader;

  {��������  DEV_TRACE        =$13;
  ������=0x13	1Byte
  ����ִ��״̬	1Byte
  ����ʱ����	1Byte	0~255��
  ���г���ʱ��	2Byte	0~3600��}
  TCmdSrvDevTrace = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    Freq: Byte;
    Time: Word;
    CheckSum: Byte;
  end;
  PCmdSrvDevTrace = ^TCmdSrvDevTrace;

  {Զ�̿���
  DEV_REMOTECTRL   =$14;
  ����ִ��״̬	1Byte
  �̵������	1Byte
  �̵���״̬	1Byte	��Ӧ��ÿһλ�ɱ�ʾһ���̵���
  }
  TCmdSrvDevRemoteCtrl = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    RelayNo: Byte;
    RelaySw: Byte;
    CheckSum: Byte;
  end;
  PCmdSrvDevRemoteCtrl = ^TCmdSrvDevRemoteCtrl;


  {���ò���
  DEV_SETPARAM     =$15;ʹ��ͨ�õ�����ͷ����}
  TCmdSrvDevSetParam = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    //[n of params]
    //CheckSum:Byte;
  end;
  PCmdSrvDevSetParam = ^TCmdSrvDevSetParam;

  {���ò���
  DEV_SETPARAM     =$15;ʹ��ͨ�õ�����ͷ����}
  TCmdDevSrvSetParamRet = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvSetParamRet = ^TCmdDevSrvSetParamRet;


  {��ȡ����
  DEV_READPARAM    =$16;
  ������	1Byte	������Ϊ�������ݰ��ĳ��ȡ�
  �豸��ʶ	4Byte
  ������=0x16	1Byte	��ȡ�豸����
  ����ִ��״̬	1Byte	CMD_REQUEST
  }
  TCmdSrvDevReadParam = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    ReadNum: Byte; // add by sha 2004-10-27
    CheckSum: Byte;
  end;
  PCmdSrvDevReadParam = ^TCmdSrvDevReadParam;


  {���ͼ����Ϣ
  DEV_SENDMSG      =$17;}
  TCmdSrvDevSendMsg = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    MsgID: Word;
    MsgType: Byte;
      //MsgContent[]Bytes
  end;
  PCmdSrvDevSendMsg = ^TCmdSrvDevSendMsg;

  {�豸�յ���ķ�������DEV_SENDMSG      =$17}
  TCmdDevSrvRecvmsg = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    MsgID: Word;
    AttValue: Word;
    CheckSum: Byte;
  end;
  PCmdDevSrvRecvmsg = ^TCmdDevSrvRecvmsg;

  {�������ݵ�DTE
  DEV_TODTE        =$18;}
  TCmdSrvDevSendToDTEHdr = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    DataID: Byte;
    DataLen: Byte;
      //..DataContent;   Bytes[]
      //..CheckSum:Byte;
  end;
  PCmdSrvDevSendToDTEHdr = ^TCmdSrvDevSendToDTEHdr;

  TCmdDevSrvSendToDTERet = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    DataID: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvSendToDTERet = ^TCmdDevSrvSendToDTERet;

  {�豸�������ݵ�������
  ��DTE��������
  DEV_TOHOST       =$19;}
  TCmdDevSrvSendToHost = packed record
    Size: Byte;
    DevId: Longword;
    CmdFlag: Byte;
    ExecFlag: Byte;
    DataID: Byte;
    DataLen: Byte;
      //..DataContent;   Bytes[]
      //..CheckSum:Byte;
  end;
  PCmdDevSrvSendToHost = ^TCmdDevSrvSendToHost;
  {��������Ӧ�豸���յ�����}
  TCmdSrvDevSendToHostRet = TCmdDevSrvSendToDTERet;
  PCmdSrvDevSendToHostRet = ^TCmdSrvDevSendToHostRet;
  //PING ����������
  //DEVSRV_PING         =$EC;

  (******�����복����V2.0 **********)
  {V2.0��ĳ�������ͷ}
  TCmdDevHeader_V2 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    //������
    //CheckSum     : Byte;  //У��
  end;
  PCmdDevHeader_V2 = ^TCmdDevHeader_V2;

  {���ĸ������ġ�ͨ��Ӧ�� CmdId=DEV_SRVRET_V2}
  TCmdSrvDevAnswer = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������$01
    Answer_CmdOrder: Word; //���� ������ʱ�� �������
    Answer_CmdFlag: Byte; //���� ������ʱ�� ����ID
    Ret: Byte; //������	0���ɹ���1��ʧ��
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevAnswer = ^TCmdSrvDevAnswer;

  {���������ĵġ�ͨ��Ӧ�� CmdId=DEV_DEVRET_V2}
  TCmdDevSrvAnswer = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������ $71
    Answer_CmdOrder: Word; //���ġ��·�����ʱ�� �������
    Answer_CmdFlag: Byte; //���ġ��·�����ʱ�� ����ID
    Ret: Byte; //������	0���ɹ���1��ʧ��
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvAnswer = ^TCmdDevSrvAnswer;

  {���������ĵ�ͨ��Ӧ�� ��У��� CmdId=DEV_DEVRET_V2��20070602}
  TCmdDevSrvAnswer_NoSum = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������ $71
    Answer_CmdOrder: Word; //���ġ��·�����ʱ�� �������
    Answer_CmdFlag: Byte; //���ġ��·�����ʱ�� ����ID
    Ret: Byte; //������	0���ɹ���1��ʧ��
    //CheckSum: Byte; //У��
  end;
  PCmdDevSrvAnswer_NoSum = ^TCmdDevSrvAnswer_NoSum;


  {���ģ�����������λ��CmdId=DEV_GETPOSITION_V2 =$02 }
  TCmdSrvDevGetPostion = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevGetPostion = ^TCmdSrvDevGetPostion;
  {���������ġ���λ������ CmdId=DEV_GPSDATA_V2=$72}
  TCmdDevSrvGpsData_V2 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    Speed: Byte; //�ٶȡ���λ������/Сʱ����ʾ��Χ0��255
    Orientation: Byte; //������������Ϊ0�ȣ�˳ʱ�����ӣ���λ��2�ȣ���ֵ��Χ0��180��
    State: Longword; //32λ״̬λ
    GpsTime: array[0..5] of Byte; //GPSʱ�䡡
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvGpsData_V2 = ^TCmdDevSrvGpsData_V2;

  //��У��ͣ���Gpsʱ��
  //���������ġ���λ������ CmdId=DEV_GPSDATA_V2=$72
  TCmdDevSrvGpsData_NoSum = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    Speed: Byte; //�ٶȡ���λ������/Сʱ����ʾ��Χ0��255
    Orientation: Byte; //������������Ϊ0�ȣ�˳ʱ�����ӣ���λ��2�ȣ���ֵ��Χ0��180��
    State: Longword; //32λ״̬λ
    GpsTime: array[0..5] of Byte; //GPSʱ�䡡
    //CheckSum: Byte; //У��
  end;
  PCmdDevSrvGpsData_NoSum = ^TCmdDevSrvGpsData_NoSum;

  {���ģ���������׷�١�CmdId=DEV_PURSUE_V2 =$03}
  TCmdSrvDevPursue = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    PursueInterval: Word; //׷�ټ��	��λ���룬��СΪ0��Ĭ��Ϊ30�����Ϊ65535��Լ18Сʱ��
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevPursue = ^TCmdSrvDevPursue;
  {���� ���� ͨ��Ӧ��}

  {���ģ������� �趨���� CmdId = DEV_SETPARAM_V2 = $04;}
  TCmdSrvDevSetParam_V2 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    ParamId: Word; //����ID
    //����ֵ ���Ȳ���
    //CheckSum     : Byte;  //У��
  end;
  PCmdSrvDevSetParam_V2 = ^TCmdSrvDevSetParam_V2;
  {���� ���� ͨ��Ӧ��}

  {���ģ������������������CmdId =DEV_REMOVEALARM_V2 =$05}
  TCmdSrvDevRemoveAlarm = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevRemoveAlarm = ^TCmdSrvDevRemoveAlarm;
  {���� ���� ͨ��Ӧ��}

  {���ģ������� �����ı�������Ϣ DEV_SENDCONTROLINFO_V2 = $09;}
  TCmdSrvDevSendControlInfo = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    //������Ϣ ������ ��<200Byte
    //CheckSum     : Byte;  //У��
  end;
  PCmdSrvDevSendControlInfo = ^TCmdSrvDevSendControlInfo;
  {���� ���� ͨ��Ӧ��}

  {���ģ������� ������ظ��ĵ�����Ϣ DEV_SENDCONTROLINFO_NEEDANSWER_V2 = $0A}
  TCmdSrvDevSendControlInfo_NeedAnswer = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    MsgID: Word; //������ϢID
    //������Ϣ ������ ��<200Byte
    //CheckSum     : Byte;  //У��
  end;
  PCmdSrvDevSendControlInfo_NeedAnswer = ^TCmdSrvDevSendControlInfo_NeedAnswer;
  {���� ���� ͨ��Ӧ��}

  {���ģ������� ���õ绰�� DEV_SETTELLIST_V2 = $0F;}
  TCmdSrvDevSetTelList = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    ////�绰�б� ������
    //CheckSum     : Byte;  //У��
  end;
  PCmdSrvDevSetTelList = ^TCmdSrvDevSetTelList;
  {���� ���� ͨ��Ӧ��}

  {���ģ������� �����̼� DEV_UPDATEFIRMWARE_V2 = $10}
  TCmdSrvDevUpdateFirmware = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    UpdateType: Byte; //�����豸���ͣ���0����ʾ��������1����ʾ����������
    //URL��ַ ��������200Byte
    //CheckSum     : Byte;  //У��
  end;
  PCmdSrvDevUpdateFirmware = ^TCmdSrvDevUpdateFirmware;
  {���� ���� ͨ��Ӧ��}

  {���ģ������� ������ DEV_READPARAM_V2 = $11}
  TCmdSrvDevReadParam_V2 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    ParamId: Word; //   ����ID
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevReadParam_V2 = ^TCmdSrvDevReadParam_V2;
  {�����������ġ�������Ӧ�𣭣��������ͨ��Ӧ������ϼ��ϲ���ֵ}
  TCmdDevSrvReadParam_V2 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������  = �ﳵ��Ӧ��ͨ�������֡�=DEV_DEVRET_V2=$71
    Answer_CmdOrder: Word; //���ġ��·�����ʱ�� �������
    Answer_CmdFlag: Byte; //���ġ��·�����ʱ�� ������ID  = DEV_READPARAM_V2 = $11
    Ret: Byte; //������	0���ɹ���1��ʧ��
    ParamId: Word; //   ����ID
    //����ֵ
    //CheckSum     : Byte;  //У��
  end;
  PCmdDevSrvReadParam_V2 = ^TCmdDevSrvReadParam_V2;
  {���ظ�����ͨ��Ӧ�� DEV_RETUPLOADDONEORDER      = $1A;}
  TCmdSrvDevRetUploadDoneOrder_4 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    OrderID: integer;
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevRetUploadDoneOrder_4 = ^TCmdSrvDevRetUploadDoneOrder_4;

  {������������ ˾���� ��ظ��ĵ�����Ϣ�� �ظ� DEV_SENDCONTROLINFO_DRIVERANSWER_V2= $74}
  TCmdDevSrvSendControlInfo_DriverAnswer = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    MsgID: Word; //������ϢID�������ݿ���ȡֵ
    AnswerInfo: Byte; //˾��������Ϣ - 0����  1����
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvSendControlInfo_DriverAnswer = ^TCmdDevSrvSendControlInfo_DriverAnswer;
  {�����ٸ���ͨ��Ӧ��}

  {������������  ������¼ DEV_LOGIN_V2  = $7B}
  TCmdDevSrvLogin_V2 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    Speed: Byte; //�ٶȡ���λ������/Сʱ����ʾ��Χ0��255
    Orientation: Byte; //������������Ϊ0�ȣ�˳ʱ�����ӣ���λ��2�ȣ���ֵ��Χ0��180��
    State: Longword; //32λ״̬λ
    GpsTime: array[0..5] of Byte;
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvLogin_V2 = ^TCmdDevSrvLogin_V2;
  {�����ٸ���ͨ��Ӧ��}
  {����->���� �����ӷ�����ע��  DEV_LOGOUT_V2 = $89 }
  TCmdDevSrvLogOut_V2 = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    Speed: Byte; //�ٶȡ���λ������/Сʱ����ʾ��Χ0��255
    Orientation: Byte; //������������Ϊ0�ȣ�˳ʱ�����ӣ���λ��2�ȣ���ֵ��Χ0��180��
    State: Longword; //32λ״̬λ
    GpsTime: array[0..5] of Byte;
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvLogOut_V2 = ^TCmdDevSrvLogOut_V2;
  {�����������ġ��ϴ��������ݲ���}
  TCmdDevSrvUpdateParam = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    ReadRet: Byte; //   ��ѯ���0���ɹ�  1��ʧ��
    ParamId: Word; //   ����ID
    ParamLen: Byte; //   ��������
    //����ֵ
    //CheckSum     : Byte;  //У��
  end;

  {���ĸ������·�����/�ϵ�/����/�������� DEV_CUTORFEED_OIL_ELECTRICITY     = $16; }
  TCmdSrvDevCutOrFeedOilOrElectricity = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    Content: Word; //��ϸ���ݣ� ����/�ϵ�/����/����
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevCutOrFeedOilOrElectricity = ^TCmdSrvDevCutOrFeedOilOrElectricity;
  {�����ٸ�ͨ��Ӧ��}
  {����-> ���� ���汾����  DEV_READDEVVER = $AB;}
  TCmdSrvDevReadDevVer = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevReadDevVer = ^TCmdSrvDevReadDevVer;
  {����-> ���� �ϴ������汾 DEV_UPLOADDEVVER= $FB}
  TCmdDevSrvRetReadDevVer = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    //�汾���ݡ�����32    AscII��         ��
    //CheckSum   : Byte;    //У��
  end;
  PCmdDevSrvRetReadDevVer = ^TCmdDevSrvRetReadDevVer;

  //����˾��������� 2006-8-25
  {����-> ���� ����˾����Ϣ DEV_SETDRIVERS  = $17;}
  TCmdSrvDevSetDrivers = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    DriverNo1: array[0..9] of char; //����.���㲿�ݲ�0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevSetDrivers = ^TCmdSrvDevSetDrivers;
  {��������ͨ��Ӧ��}

  {����-> ���� ��ȡ˾����Ϣ DEV_READDRIVERS   = $18;}
  TCmdSrvDevReadDrivers = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevReadDrivers = ^TCmdSrvDevReadDrivers;
  {�������ظ�}
  TCmdDevSrvRetReadDrivers = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    DriverNo1: array[0..9] of char; //����.���㲿�ݲ�0
    DriverName1: array[0..19] of char;
    DriverNo2: array[0..9] of char;
    DriverName2: array[0..19] of char;
    DriverNo3: array[0..9] of char;
    DriverName3: array[0..19] of char;
    DriverNo4: array[0..9] of char;
    DriverName4: array[0..19] of char;
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvRetReadDrivers = ^TCmdDevSrvRetReadDrivers;

  {����-> ���� ��ȡ��ǰ˾�� DEV_READCURRENTDRIVER = $19;}
  TCmdSrvDevReadCurrentDriver = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevReadCurrentDriver = ^TCmdSrvDevReadCurrentDriver;


  {���� ->���ġ��ϴ���ǰ˾����DEV_UPLOADCURRENTDRIVER = $7D;--���������Ķ�ȡ��Ӧ��Ҳ�����������ϴ���}
  TCmdDevSrvUploadCurrentDriver = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    DriverNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvUploadCurrentDriver = ^TCmdDevSrvUploadCurrentDriver;

  {����-������ �ϴ�������վ���վ DEV_INORDOWNSTATION=$84}
  TCmdDevSrvInOrDownStation = packed record
    Size: Word;
    DevFaction: Byte;
    DevId: integer;
    ComVer: Byte;
    CmdOrder: Word;
    CmdFlag: Byte;
    StationNo: Byte;
    Direct: Byte;
    InOrDown: Byte;
    CheckSum: Byte;
  end;
  PCmdDevSrvInOrDownStation = ^TCmdDevSrvInOrDownStation;
  {���� -> ���� �ϴ�˾���°��˳� DEV_UPLOADDRIVERLOGOUT }
  TCmdDevSrvUploadDriverLogOut = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    DriverNo: array[0..9] of Byte;
    LogOutTime: array[0..5] of Byte;
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvUploadDriverLogOut = ^TCmdDevSrvUploadDriverLogOut;
  {���ĸ���ͨ��Ӧ��}

  //����-> ���� �ó�����һ����ƬDEV_GETAPIC = $1B;
  TCmdSrvDevGetAPic = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    GetPicSize: Byte; //��Ƭ�ߴ��С 0=320x240  1=640x480  2-else
    CameraIndex: Byte; //����ͷ��
    CheckSum: Byte; //У��
  end;
  PCmdSrvDevGetAPic = ^TCmdSrvDevGetAPic;
  //�����ظ� ͨ��Ӧ��

   //���� -> ���� �����ѳɹ�����Ƭ�ϴ�  DEV_APICUPLOADED= $80
  TCmdDevSrvAPicUploaded = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    PicIndex: integer; //��������Ƭ���
    CameraIndex: Byte; //����ͷ��
    PicReson: Byte; //����ԭ��
    DoneRet: Byte; //���ս����0-�ɹ���1-��Ƭ��������2-����ͷ����3-����ʧ��
    CheckSum: Byte; //У��
  end;
  PCmdDevSrvAPicUploaded = ^TCmdDevSrvAPicUploaded;
  {���ĸ���ͨ��Ӧ��}
  //����->���������ó�����������ļ����绰����  DEV_DOWNLISTENCALLNUM = $24;  //2007-9-24
  TCmdSrvDevDownListenCallNum = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    //CallNum: ��20��ASCII��
    //CheckSum: Byte; //У��
  end;
  PCmdSrvDevDownListenCallNum = ^TCmdSrvDevDownListenCallNum;
  {�����ظ�ͨ������Ӧ��}
  //����->����������ͨ������
  TCmdSrcDevGenericCommand = packed record
    Size: Word;
    DevFactory: Byte; //��������
    DevId: integer;
    ComVer: Byte; //Э��汾
    CmdOrder: Word; //�������
    CmdFlag: Byte; //������
    //MinorCmdFlag : Byte; //��������
    //��������
    //CheckSum:Byte;//У��
  end;
  PCmdSrcDevGenericCommand = ^TCmdSrcDevGenericCommand;
  {�����ظ�ͨ������Ӧ��}
  {�����ظ�ͨ��Ӧ��}
  {*******************2006-5-30 ����WEB�����������ص�ͨѶЭ��********}
  //Web����������������� ͨ������ͷ
  TCmdWebSrvHeader = packed record
    Header: Word; //Э��ͷ���̶�Ϊ$FF FF
    Size: Word; //�ܳ���
    DevId: integer; //ȥ����һ������1��SIM������
    ComVer: Byte; //Э��汾��=2
    CmdOrder: Word; //�������
    CmdFlag: Byte;
    //���� ���ݣ�������Ȳ���
    //CheckSum
  end;
  PCmdWebSrvHeader = ^TCmdWebSrvHeader;
{****************************  ��������ṹ����   *****************************}
  (*****************���ȷ��������롡���ص�ͨѶ��2006-11-17 SHA**** 20070709 sha.��ӵ���������ϳɴ���2�ֶ���*****)
  {����->���ȷ��������������ĳ����б��������ɹ��ĳ����б� SRVDISPGRABDEVSANDGRABOKDEVS= $62;}

{*******************************ҵ��������Ϳͻ��˽ṹ����********************************}
  TMyPhoto = packed record
    Size: integer;
    PhotoReasonID: integer; //����ԭ��
    GpsTime: TDateTime; //GPSʱ��
    Longitude: Double; //����
    Latitude: Double; //γ��
    TakeBeginTime: TDateTime; //���տ�ʼʱ��
    TkeEndTime: TDateTime; //���ս���ʱ��
    PhotoSize: integer; //��Ƭ��С
    PhotoType: integer; //��Ƭ����
    PicIndex: integer; //��Ƭ���
    PhotoMeasure: integer; //��Ƭ�ߴ�
    CameraIndex: Byte;
    //Photo:TByteDynArray;     //��Ƭ����,��������С
  end;
  PMyPhoto = ^TMyPhoto;


{******************************************************************************}
//�趨��·���
  TCmdSrvTermSetBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    BusLineID: Integer; //��·���
  end;
  PCmdSrvTermSetBusLine = ^TCmdSrvTermSetBusLine;
  //���ػظ�
  TCmdTermSrvSetBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: byte;
  end;
  PCmdTermSrvSetBusLine = ^TCmdTermSrvSetBusLine;
//�趨��������
  TCmdSrvTermSetSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    AreaID: Integer; //������

    Longitude1_Integer: word;
    Longitude1_Decimal: word;
    Latitude1_Integer: word;
    Latitude1_Decimal: word;

    Longitude2_Integer: word;
    Longitude2_Decimal: word;
    Latitude2_Integer: word;
    Latitude2_Decimal: word;

    Longitude3_Integer: word;
    Longitude3_Decimal: word;
    Latitude3_Integer: word;
    Latitude3_Decimal: word;

    Longitude4_Integer: word;
    Longitude4_Decimal: word;
    Latitude4_Integer: word;
    Latitude4_Decimal: word;

    Longitude5_Integer: word;
    Longitude5_Decimal: word;
    Latitude5_Integer: word;
    Latitude5_Decimal: word;

    Longitude6_Integer: word;
    Longitude6_Decimal: word;
    Latitude6_Integer: word;
    Latitude6_Decimal: word;

    Longitude7_Integer: word;
    Longitude7_Decimal: word;
    Latitude7_Integer: word;
    Latitude7_Decimal: word;

    Longitude8_Integer: word;
    Longitude8_Decimal: word;
    Latitude8_Integer: word;
    Latitude8_Decimal: word;
  end;
  PCmdSrvTermSetSpeaArea = ^TCmdSrvTermSetSpeaArea;
  //���ػظ�
  TCmdTermSrvSetSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdId: integer;
    DevId: integer;
    Ret: byte;
  end;
  PCmdTermSrvSetSpeaArea = ^TCmdTermSrvSetSpeaArea;
//��ȡ��������
  TCmdSrvTermReadSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    AreaID: Integer; //������
  end;
  PCmdSrvTermReadSpeaArea = ^TCmdSrvTermReadSpeaArea;
  //���ػظ�
  TCmdTermSrvReadSpeaArea = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
    //������Ϣ  ������
  end;
  PCmdTermSrvReadSpeaArea = ^TCmdTermSrvReadSpeaArea;
  //��ѯ�洢����·
  TCmdSrvTermQueryBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
  end;
  PCmdSrvTermQueryBusLine = ^TCmdSrvTermQueryBusLine;
  //���ػظ�
  TCmdTermSrvQueryBusLine = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
    //��·��Ϣ  ������
  end;
  PCmdTermSrvQueryBusLine = ^TCmdTermSrvQueryBusLine;
  //���Ƽ�����Ӫ
  TCmdSrvTermSetJoinOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: integer;
    DevID: Integer;
    AutoFlag: Byte; //00�Զ���01�ֶ�
  end;
  PCmdSrvTermSetJoinOpera = ^TCmdSrvTermSetJoinOpera;
  //���ػظ�
  TCmdTermSrvSetJoinOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
  end;
  PCmdTermSrvSetJoinOpera = ^TCmdTermSrvSetJoinOpera;
  //�����˳���Ӫ
  TCmdSrvTermSetExitOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: integer;
    DevID: Integer;
    AutoFlag: Byte; //00�Զ���01�ֶ�
  end;
  PCmdSrvTermSetExitOpera = ^TCmdSrvTermSetExitOpera;
  //���ػظ�
  TCmdTermSrvSetExitOpera = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: byte;
  end;
  PCmdTermSrvSetExitOpera = ^TCmdTermSrvSetExitOpera;
  //����->�ͻ���     SRVTERM_UPLOADTEXT
  TCmdTermSrvUploadText = packed record
    Size: word;
    Flag: Byte;
    DevId: integer;
    //�ϴ�����Ϣ ������
  end;
  PCmdTermSrvUploadText = ^TCmdTermSrvUploadText;
  //�ϼ��ϴ���Ӫ����Ϣ����    SRVTERM_UPLOADNONSEC = $47;
  TCmdTermSrvRequestNonRun = packed record
    Size: Word;
    Flag: byte;
    DevId: integer;
    gpsData: array[0..71] of byte;
      //�������Ͳ�����
  end;
  PCmdTermSrvRequestNonRun = ^TCmdTermSrvRequestNonRun;
  //ָ���������з��������
  TCmdSrvTermDesignatedNonRun = packed record
    Size: Word;
    Flag: byte;
    CmdID: integer;
    DevId: integer;
    NonRunNo: integer;
    IsAllow: byte;
    //��������  ������
  end;
  PCmdSrvTermDesignatedNonRun = ^TCmdSrvTermDesignatedNonRun;
  TCmdTermSrvCompleteRequestNonRun = packed record
    Size: word;
    Flag: byte;
    CmdId: integer;
    DevId: integer;
    RequestNo: integer;
    course: integer;
    //gpsData: array[0..71] of byte;
  end;
  PCmdTermSrvCompleteRequestNonRun = ^TCmdTermSrvCompleteRequestNonRun;
  //ָ��������ʱ����
  TCmdSrvTemporaryRun = packed record
    Size: word;
    Flag: byte;
    CmdId: integer;
    DevId: integer;
    OnOrDown: Byte;
    StationNo: Byte;
    TemporaryRunType: Byte;
  end;
  PCmdSrvTemporaryRun = ^TCmdSrvTemporaryRun;
  TCmdSrvTemporaryRun_XM = packed record
    Size: word;
    Flag: byte;
    CmdId: integer;
    DevId: integer;
    //TemporaryData  ������
  end;
  PCmdSrvTemporaryRun_XM = ^TCmdSrvTemporaryRun_XM;
  //BUSͨ��Ӧ��
  TCmdTermSrvAnswer = packed record
    Size: Word;
    Flag: Byte;
    CmdID: Integer;
    DevID: Integer;
    Ret: Byte;
  end;
  PCmdTermSrvAnswer = ^TCmdTermSrvAnswer;
  //===================================================================����
  TCmdSrvTermGpsDataHis_XM = packed record
    Size: word;
    Flag: Byte;
    DevId: integer;
    gpsType: byte; //GPS��������
    GpsTime: array[0..5] of Byte; // GPSʱ��
    IsLocat: Byte; //��λ״̬  0����λ 1������λ
    Latitude: integer; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: integer; //���� X 100 0000
    High: integer; //�߶�
    Speed: integer; //�ٶ�
    Dir: integer; //����
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //����״̬
    runType: byte; //����״̬
    ISREPLACE: byte; //��������
    ISSTATION: byte; //����վ���������������
    STATION_ID: integer; //վ����
    AREA_ID: integer; //����������
  end;
  PCmdSrvTermGpsDataHis_XM = ^TCmdSrvTermGpsDataHis_XM;
  TGpsDataHis_XM = packed record
    Size: word;
    Flag: Byte;
    DevId: integer;
    gpsType: byte; //GPS��������
    GpsTime: TDateTime; // GPSʱ��
    IsLocat: Byte; //��λ״̬  0����λ 1������λ
    Latitude: Double; //γ�� X 100 0000 ��: ֵ32123456��ʾ��32.123456��
    Longitude: Double; //���� X 100 0000
    High: Double; //�߶�
    Speed: Integer; //�ٶ�
    Dir: Double; //����
    S1: byte;
    S2: Byte;
    S3: byte;
    S4: byte;
    S: array[0..3] of byte; //����״̬
    runType: byte; //����״̬
    ISREPLACE: byte; //��������
    ISSTATION: byte; //����վ���������������
    STATION_ID: integer; //վ����
    AREA_ID: integer; //����������
  end;
  PGpsDataHis_XM = ^TGpsDataHis_XM;

  //������ĩվ��
  TIOSEStation = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer; //�豸��
    OnOrDown: Byte; //1--��;2--����
    GTime: array[0..5] of Byte; //����վGPSʱ��
    STime: array[0..5] of Byte; //����վ������ʱ��
    InOrOut: Byte; //1--��վ��2������վ������վ��־
  end;
  PIOSEStation = ^TIOSEStation;

  //�޸�HR 090316
  TModifyPlanRunTime = packed record
    Size: Word;
    Flag: Byte;
    planID: Integer; //��μƻ�ΨһID
    busLineID: Integer; //��·ID
  end;
  PModifyPlanRunTime = ^TModifyPlanRunTime;

  //����->�ͻ��˨D�D֪ͨ�ͻ��˳������п�ʼ����
  TStartRentCar = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;
    RentCarPlanID: Integer;//�����ƻ�ID
    StartTime: array[0..5] of Byte;//����ʱ��
  end;
  PStartRentCar = ^TStartRentCar;

  //����->�ͻ��˨D�D֪ͨ�ͻ��˳����������
  TEndRentCar = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;
    RentCarPlanID: Integer;//�����ƻ�ID
    EndTime: array[0..5] of Byte;//���ʱ��
    Distance: Integer;//��ʻ���
  end;
  PEndRentCar = ^TEndRentCar;

  //����->�ͻ��˨D�D֪ͨ�ͻ��˳�����ǰ״̬
  TModifyDevStatus = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;
    CurrRunStatus: Byte;
  end;
  PModifyDevStatus = ^TModifyDevStatus;

  //�ͻ���->���بD�D֪ͨ����ȷ������������ʼվ�򷢳�
  TIOStartStation = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer; //�豸��
    OnOrDown: Byte; //1--��;2--����
    GTime: array[0..5] of Byte; //����վGPSʱ��
    STime: array[0..5] of Byte; //����վ������ʱ��
    InOrOut: Byte; //1--��վ��2������վ������վ��־
    RunNo: Integer;//��κ�
    OutStart_Type: Byte;//0x00:GPS��ʼվ 0x01:GPS����ʼվ 0x02:�ֶ�
    CurrentStationNo: Byte;//��ǰվ����
    CurrentTotalCourse: array[0..2] of Byte;//��ǰ�ۼ����(��λ:����)
    LineId: Integer;
  end;
  PIOStartStation = ^TIOStartStation;

  TInEndStation = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;//�豸��
    OnOrDown: Byte; //1--��;2--����
    GTime: array[0..5] of Byte; //����վGPSʱ��
    STime: array[0..5] of Byte; //����վ������ʱ��
    RunNo: Integer;//��κ�
    InEnd_Type: Byte;//0x00:GPS��ʼվ 0x01:GPS����ʼվ 0x02:�ֶ�
    RealCourse: Integer;//��λ: ��
    StationNumPassed: Byte;
    RunCompleteRate: Integer;//���������
    LineId: Integer;
  end;
  PInEndStation = ^TInEndStation;

  TStartOtherRun = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;            //�豸��
    RequestNo: Integer;        //��Ӫ�˺�
    STime: array[0..5] of Byte;//��ʼʱ��
    //��Ӫ����  ������
  end;
  PStartOtherRun = ^TStartOtherRun;

  TEndOtherRun = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;                //�豸��
    RequestNo: Integer;            //��Ӫ�˺�
    ETime: array[0..5] of Byte;    //����ʱ��
    RunCourse: Integer;             //ʵ����Ӫ���
    LineId: Integer;
  end;
  PEndOtherRun = ^TEndOtherRun;

  TOtherRunRequest = packed record
    Size: Word;
    Flag: Byte;
    CmdNo: Integer;        //�������
    DevID: Integer;        //�豸��
    OtherRunID: Integer;    //��Ӫ�˺�
    //��Ӫ������  ������
    //�ۼ���� {3�ֽ�}
    //��λ���� {δ�����ĳ������ػ��ڶ�λ���ݺ��3���ֽڷ����������û��}
  end;
  POtherRunRequest = ^TOtherRunRequest;

  TChangeDevStatus = packed record
    Size: Word;
    Flag: Byte;
    DevID: Integer;    //������
    OtherRunType: Byte;//��Ӫ������
  end;
  PChangeDevStatus = ^TChangeDevStatus;

  TRentCarStart = packed record
    Size: Word;
    Flag: Byte;
    CmdNo: Integer;             //�������
    DevId: Integer;             //�������
    RentCarType: Byte;          //�������� 0��δ֪���� 1���̶����� 2����ʱ����
    RentCarRunNo: Integer;      //������κ�
    BusLineId: Integer;         //��·��
    STime: array[0..5] of Byte; //��ʼʱ��
    OtherRunId: Integer;        //��Ӫ�˱��
  end;
  PRentCarStart = ^TRentCarStart;

  TRentCarEnd = packed record
    Size: Word;
    Flag: Byte;
    CmdNo: Integer;             //�������
    DevId: Integer;             //�������
    RentCarType: Byte;          //�������� 0��δ֪���� 1���̶����� 2����ʱ����
    RentCarRunNo: Integer;      //������κ�
    BusLineId: Integer;         //��·��
    ETime: array[0..5] of Byte; //��ʼʱ��
    RunCourse: Integer;            //�������
    OtherRunId: Integer;        
  end;
  PRentCarEnd = ^TRentCarEnd;

  TModifyRentCarPlan = packed record
    Size: Word;
    Flag: Byte;
    RentCarPlanId: Integer;
    RentCarType: Byte;
    BusLineId: Integer;
  end;
  PModifyRentCarPlan = ^TModifyRentCarPlan;

  TRetToGateway = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    Ret: Byte;
  end;
  PRetToGateway = ^TRetToGateway;

  TRetToGateway_N = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    RetFlag: Byte;//Ӧ������
    Ret: Byte;
  end;
  PRetToGateway_N = ^TRetToGateway_N;

  //====================================JNGJ====================================
  TPlanChanged = packed record//���֪ͨ���Ȱ�α仯
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    LineId: Integer;
    planId: Integer;//-1��ʾ������·
  end;
  PPlanChanged = ^TPlanChanged;

  TNoticeBusNextRun_C2G = packed record//����֪ͨ���س���ִ����һ��ƻ�
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId: Integer;
    PlanId: Integer;
    OnOrDown: Byte;
    StartTime: array[0..5] of Byte;
    Status: Byte; // 0������ 1��ȡ������
    MsgLen: Integer;
    //Msg: ������;
  end;
  PNoticeBusNextRun_C2G = ^TNoticeBusNextRun_C2G;

  TNoticeBusNextRun_G2C = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    StartTime: array[0..5] of Byte;
    LineId: Integer;
    PlanId: Integer;
    Status: Byte;//0:�ɵ�  1��ȡ���·�δִ�� 2:ȡ����ִ�а�� 3:ǿ�Ƴ�������
    OnOrDown: Byte;//1 on  2 down
  end;
  PNoticeBusNextRun_G2C = ^TNoticeBusNextRun_G2C;

  TBusWaitForNextRun_C2G = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
  end;
  PBusWaitForNextRun_C2G = ^TBusWaitForNextRun_C2G;

  TBusExecuteNewRun_C2G = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId: Integer;
    PlanId: Integer;
    OnOrDown: Byte;
  end;
  PBusExecuteNewRun_C2G = ^TBusExecuteNewRun_C2G;

  TBusStartInfoToBoard_C2G = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    BoardId: Integer;
    LineCount: Integer;
    //LineNameLen: Integer;
    //LineName: string;
    //CarNoLen: Integer;
    //CarNo: string;
    //StartTimeLen: Integer;
    //StartTime: string;
  end;
  PBusStartInfoToBoard_C2G = ^TBusStartInfoToBoard_C2G;

  TControlBusRunStatus = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    Status: Byte;//0�����Ƽ�����Ӫ 1�����Ƽ��� 5�����ư��� 2�����ϱ��� 4������ 51�������˳���Ӫ
  end;
  PControlBusRunStatus = ^TControlBusRunStatus;

  //�ϴ����鿨���ṹ������ͬ˾��ǩ��
  TUploadCheckCard = packed record
    Size: Word;
    Flag: Byte;
    DevId: integer;
    CheckerNo: array[0..9] of Byte;
    LoginTime: array[0..5] of Byte;
    TotalCourse: array[0..2] of Byte;//�ۼ����
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PUploadCheckCard = ^TUploadCheckCard;

  //֪ͨ�Ƿ�ֹͣ���͵�����Ϣ
  TNoticeIfDispatched = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    Status: Byte;//0:ֹͣ 1:����
  end;
  PNoticeIfDispatched = ^TNoticeIfDispatched;

  //ָ��������ʻԱ
  TNoticeDevDriver = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    DriverNo: array of Byte;
    LogInOrOut: Byte;//0��ǩ�� 1��ǩ��
  end;
  PNoticeDevDriver = ^TNoticeDevDriver;

  TSpecialRentCar = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    RentCarRunTimeId: Integer;
    Status: Byte;
  end;
  PSpecialRentCar = ^TSpecialRentCar;

  //ָ����ȡ��������������
  TLeaveImm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    Status: Byte;//1:ָ�� 2:ȡ��
  end;
  PLeaveImm = ^TLeaveImm;

  TNoticeNewPlanWhenLeaveImm = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    PlanRunTimeId: Integer;
    LineId: Integer;
  end;
  PNoticeNewPlanWhenLeaveImm = ^TNoticeNewPlanWhenLeaveImm;

  //����������׼�����(���������е�׼����㲻���Լƻ���ʼʱ���ʵ�ʿ�ʼʱ����������)
  TBusDelay = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    PlanRunTimeId: Integer;
    LineId: Integer;
    DelayType: Byte;//1����ǰ 2���Ƴ�  Ŀǰ���������е������2��ʾ  2010-05-25
    DelayTime: Word;//���ʱ��         Ŀǰ���������е����ʱ��Ϊ0  2010-05-25
  end;
  PBusDelay = ^TBusDelay;

  TUploadAlarmOverSpeed = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    AlarmSTime: array[0..5] of Byte;
    AlarmSLati: Integer;
    AlarmSLongi: Integer;
    AlarmETime: array[0..5] of Byte;
    AlarmELati: Integer;
    AlarmELongi: Integer;
    AlarmMaxSpeed: Byte;
    AlarmLimitedSpeed: Byte;
    AlarmAvgSpeed: Byte;
    AlarmAreaId: Word; 
  end;
  PUploadAlarmOverSpeed = ^TUploadAlarmOverSpeed;

  TCmdTermSrvSendSpecialRentPlan = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    RentCount: Integer;
  end;
 PCmdTermSrvSendSpecialRentPlan = ^TCmdTermSrvSendSpecialRentPlan;

  TSpecialRentCarInfo = packed record
    RentCarId: Integer;//����ID
    RentCarName: array [0..29] of Byte;//��������
  end;
  PSpecialRentCarInfo = ^TSpecialRentCarInfo;

  //====================================JNGJ====================================
  {*************************************������·*************************************}
  TUploadModifyLine = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId:Integer;
    QyRq:array[0..5] of Byte;
  end;
  PUploadModifyLine = ^TUploadModifyLine;
  TModifyBusLineOK = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    LineId:Integer;
    QyRq:array[0..5] of Byte;
  end;
  PModifyBusLineOK = ^TModifyBusLineOK;
  {*************************************������·*************************************}


  //ָ�������ļ�ʻԱǩ����ǩ�� TERMSRV_APPOINTDRIVERLOGONOROFF = $B3;
  TCmdTermSrvAppointDriverLogOnOrOff = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer; //�������
    DevId: integer;
    DriverCardId: Integer; //˾�����ں�
    DriverNo: array[0..9] of char; //˾������
    DriverName: array[0..9] of char; //˾������
    LogType: Byte; //0��ǩ�� 1��ǩ��
  end;

  //���������ϴ���Լ�����ƻ�
  TCmdSrvTermDevUploadSpecialPlanId = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer;
    DevId: Integer;
    RentPlanId: Integer;
  end;
  PCmdSrvTermDevUploadSpecialPlanId = ^TCmdSrvTermDevUploadSpecialPlanId;

  //ָ��������ͣ������ �ɰ�
  TCmdTermSrvAppointPauseOrStartPaiBan = packed record
    Size: Word;
    Flag: Byte;
    CmdId: Integer; //�������
    DevId: integer;
    PauseType: Byte; //0:ֹͣ 1������
  end;
  PCmdTermSrvAppointPauseOrStartPaiBan = ^TCmdTermSrvAppointPauseOrStartPaiBan;

{**************************���Ϲ���������������******************************}
  //������������ͷ
  TBusTaxiCmdHead = packed record
    Size: Word;        //������
    Flag: Byte;        //�����̶ֹ�Ϊ$F1
    ExtendedFlag: Byte;//��չ������
    Reserved: Integer; //����
    FactId: Byte;      //����
    CmdNo: Integer;    //�������
    DevId: Integer;    //�豸��
  end;
  PBusTaxiCmdHead = ^TBusTaxiCmdHead;

  //��ʱ���ط�����������ʾ��
  TSwitchBoard = packed record
    Head: TBusTaxiCmdHead;
    OnOrOff: Byte;
  end;
  PSwitchBoard = ^TSwitchBoard;

  //֪ͨ˾���ڵ�ǰ������������ɰ����
  TCmdTermSrvNoticeDriverRuninfoCount = packed record
    Head: TBusTaxiCmdHead;
    DriverRuninfoCount: Byte;
  end;

  TCmdDevIOPark = packed record
    Head: TBusTaxiCmdHead;
    BusParkNo: Integer;//ͣ�������
    IOType: Byte;//7�����س� 8���յ�س� 9���볡����� 10���볡���յ�
  end;
  PCmdDevIOPark = ^TCmdDevIOPark;

  TCmdDevIOParkRequest = packed record
    Head: TBusTaxiCmdHead;
    OtherRunId: Integer;
    BusParkNo: Integer;//ͣ�������
    IOType: Byte;//7�����س� 8���յ�س� 9���볡����� 10���볡���յ�
    TotalCourse: array[0..2] of Byte;
    GpsData: TCmdSrvTermGpsData_XM;
  end;
  PCmdDevIOParkRequest = ^TCmdDevIOParkRequest;

  TCmdDevIOParkStart = packed record
    Head: TBusTaxiCmdHead;
    OtherRunId: Integer;
    STime: array[0..5] of Byte;
    BusParkNo: Integer;//ͣ�������
    IOType: Byte;//7�����س� 8���յ�س� 9���볡����� 10���볡���յ�
  end;
  PCmdDevIOParkStart = ^TCmdDevIOParkStart;

  TCmdDevGetAd = packed record
    Head: TBusTaxiCmdHead;
    SNo: Integer;
    AdType: Byte;
    AdVer: array[0..6] of Byte;
  end;
  PCmdDevGetAd = ^TCmdDevGetAd;

  TCmdSendAdToDev = packed record
    Head: TBusTaxiCmdHead;
    SNo: Integer;
    CmdType: Byte;
    AdType: Byte;
    AdVer: array[0..6] of Byte;
    AdLen: shortint;
    //AdContent: string;
  end;
  PCmdSendAdToDev = ^TCmdSendAdToDev;

  TCmdDevAdChanged = packed record
    Head: TBusTaxiCmdHead;
    AdType: Byte;
  end;
  PCmdDevAdChanged = ^TCmdDevAdChanged;

  //ˢ������
  TCmdSrvTermLoginOrOff = packed record
    Head: TBusTaxiCmdHead;
    CardNo: array[0..9] of Byte;//10�ֽ�ASCII��
    StewardNo: array[0..9] of Byte;//10�ֽ�ASCII��
    LogTime: array[0..5] of Byte;//BCD���ʽ�ı���ʱ�� YY-MM-DD HH:MM:SS
    UserId: Integer; //ָ���û�ID(���������ϴ�Ĭ��Ϊ0)
    CardType: Byte;  //4������Ա��
    LogType: Byte;   //0��ǩ����1��ǩ��
    GpsData: TCmdSrvTermGpsData_XM;//��λ���ݰ�
  end;
  PCmdSrvTermLoginOrOff = ^TCmdSrvTermLoginOrOff;

  //��ȡ12���µĻ���Ʊ��
  TCmdSrvTermGet12MonthPrice = packed record
    Head: TBusTaxiCmdHead;
    LineNo: Integer;//��·��� �����ϴ��ı��
  end;
  PCmdSrvTermGet12MonthPrice = ^TCmdSrvTermGet12MonthPrice;

  //����12���µĻ���Ʊ��
  TCmdTermSrvSend12MonthPrice = packed record
    Head: TBusTaxiCmdHead;
    LineNo: Integer;
    LineNo_IC: array[0..3] of Byte;
    CollectSNo: array[0..3] of Byte;
    MonthPrice: array[0..11] of Word;
  end;
  PCmdTermSrvSend12MonthPrice = ^TCmdTermSrvSend12MonthPrice;

  //��ȡ����Ʊ��
  TCmdSrvTermGetLadderPrice = packed record
    Head: TBusTaxiCmdHead;
    LineNo: Integer;//��·��� �����ϴ��ı��
  end;
  PCmdSrvTermGetLadderPrice = ^TCmdSrvTermGetLadderPrice;

  TCmdTermSrvSendLadderPrice = packed record
    Head: TBusTaxiCmdHead;
    //����1����	4
    //����Ʊ�۷���1	1+4*N	��1���ֽ� 0:�����ã�1������
    //ÿ����¼4�ֽ�
    //�����У�1�ֽڣ�
    //վ����ţ�1�ֽڣ�
    //��վ����վ��۸�2�ֽڣ��Է�Ϊ��λ
    //����Ʊ�۷���1����ʱ��	6	BCD
    //����2����	4
    //����Ʊ�۷���2	1+4*N	��1���ֽ� 0:�����ã�1������
    //ÿ����¼4�ֽ�
    //�����У�1�ֽڣ�
    //վ����ţ�1�ֽڣ�
    //��վ����վ��۸�2�ֽڣ��Է�Ϊ��λ
    //����Ʊ�۷���2����ʱ��	6	BCD
  end;
  PCmdTermSrvSendLadderPrice = ^TCmdTermSrvSendLadderPrice;

  TCmdTermSrvSendLadderPrice_NoData = packed record
    Head: TBusTaxiCmdHead;
    P1Len: Integer;
    P1Enable: Byte;
    P1EnableDate: array[0..5] of Byte;
    P2Len: Integer;
    P2Enable: Byte;
    P2EnableDate: array[0..5] of Byte;
  end;
  PCmdTermSrvSendLadderPrice_NoData = ^TCmdTermSrvSendLadderPrice_NoData;

{**************************���Ϲ���������������******************************}


function PtrAdd(p: pointer; offset: integer): pointer;

function CmdToStr(P: Pointer): string;

  {��BCD��ʾ���޷��ų�����32bit��ת�����޷��ų�����}
function BcdToLong(pB: PByte): Longword;
  {��BCD��ʾ��16bit�޷�������ת����16bit�޷�������}
function BcdToWord(pB: PByte): Word;
  {��BCD��ʾ��8bit�޷�������ת����8bit�޷�������}
function BcdToByte(bcd: Byte): Byte;

  {�ֽ�˳��ת��}
function ByteOderConvert_Word(AValue: Word): Word;
function ByteOderConvert_Smallint(AValue: Smallint): Smallint;
  {�ֽ�˳��ת��
  @param AValue:longword
  @return longword
  }
function ByteOderConvert_LongWord(AValue: Longword): Longword;
function GetCurrTime: string;

function GetEscapedBuf(srcBuf: array of Byte): TByteDynArray;//ת������
function GetUnEscapedBuf(srcBuf: array of Byte): TByteDynArray;//��ȡת��ǰ������
procedure initCmd(var cmdHead: TSTHead; terminalId:string; cmdId, cmdSNo: Word;
  var cmdEnd: TSTEnd; cmdMinSize: Integer);

implementation
uses
  Sysutils, DateUtils, uGloabVar;

{�ֽ�˳��ת��,���������ֽ�˳��(LITTLE_END)ת��BIG_END
@param AValue:Word
@return Word
}

function ByteOderConvert_Word(AValue: Word): Word;
type
  TLongByte = packed record
    a, b: Byte;
  end;
var
  P: ^TLongByte;
  t: Byte;
begin
  P := @AValue;
  t := P^.a;
  P^.a := P^.b;
  P^.b := t;

  Result := AValue;
end;

function ByteOderConvert_Smallint(AValue: Smallint): Smallint;
type
  TLongByte = packed record
    a, b: Byte;
  end;
var
  P: ^TLongByte;
  t: Byte;
begin
  P := @AValue;
  t := P^.a;
  P^.a := P^.b;
  P^.b := t;

  Result := AValue;
end;

{�ֽ�˳��ת��
@param AValue:longword
@return longword
}

function ByteOderConvert_LongWord(AValue: Longword): Longword;
type
  TLongByte = packed record
    a, b, c, d: Byte;
  end;
var
  P: ^TLongByte;
  t: Byte;
begin
  P := @AValue;
  t := P^.a;
  P^.a := P^.d;
  P^.d := t;

  t := P^.b;
  P^.b := P^.c;
  P^.c := t;

  Result := AValue;
end;
{
bcd�б������4���ֽڵĸ����ʾ
"03201.831" ת������4���ֽڵ�bcd���ʾ���� <br>
0x03  0x20  0x18  0x31                     <br>
��0x03  0x20  0x18  0x31 ת��8���ֽ�       <br>
 0 ��3��2��0, 1��8��3��1                   <br>
 Ȼ��ƴ��һ��longword                      <br>
  (0*6000+3*600+2*60)*1000+
  (0*10000+1*1000+8*100+3*10+1)
 --------
 ���ͻ����ټ���ʱ���ٳ���1000*60
 =32.0305167
}

function BcdToLong(pB: PByte): Longword;
var
  b: array[0..7] of Byte;
  i: integer;
begin
  for i := 0 to 3 do
  begin
    b[i * 2] := pB^ shr 4;
    b[i * 2 + 1] := pB^ and $0F;
    inc(pB);
  end;

  Result :=
    (b[0] * 6000 + b[1] * 600 + b[2] * 60) * 1000 +
    (b[3] * 10000 + b[4] * 1000 + b[5] * 100 + b[6] * 10 + b[7]);
end;

{
bcd�б������2���ֽڵ����ͱ�ʾ
1204����������ʾ�ٶ�Ϊ120.4����ÿСʱ
�����������ֽڵ�bcd���ʾ[0x12,0x04]
��0x12 0x04 ת��4���ֽ�
    1,2,0,4
 Ȼ��ƴ��һ������
 1*1000+2*100+0*10+4;
}

function BcdToWord(pB: PByte): Word;
var
  b: array[0..3] of Byte;
begin

  b[0] := pB^ shr 4;
  b[1] := pB^ and $0F;
  inc(pB);
  b[2] := pB^ shr 4;
  b[3] := pB^ and $0F;

  Result := b[0] * 1000 + b[1] * 100 + b[2] * 10 + b[3];
end;

function BcdToByte(bcd: Byte): Byte;
begin
  Result := (bcd shr 4) * 10 + (bcd and $0F);
end;

function GetEscapedBuf(srcBuf: array of Byte): TByteDynArray;
var
  dstBuf: TByteDynArray;
  i, j: Integer;
begin
  SetLength(dstBuf, 2 * Length(srcBuf));
  dstBuf[0] := CMD_START_FLAG;
  j := 1;
  for i := 1 to Length(srcBuf) - 2 do
  begin
    if srcBuf[i] = CMD_SPEC_FLAG_7E then
    begin
      dstBuf[j] := CMD_SPEC_FLAG_7D;
      dstBuf[j + 1] := $02;
      Inc(j, 2);
    end
    else if srcBuf[i] = CMD_SPEC_FLAG_7D then
    begin
      dstBuf[j] := CMD_SPEC_FLAG_7D;
      dstBuf[j + 1] := $01;
      Inc(j, 2);
    end
    else
    begin
      dstBuf[j] := srcBuf[i];
      Inc(j);
    end;
  end;
  dstBuf[j] := CMD_END_FLAG;
  SetLength(dstBuf, j + 1);
  Result := dstBuf;
end;

function GetUnEscapedBuf(srcBuf: array of Byte): TByteDynArray;//��ȡת��ǰ������
var
  dstBuf: TByteDynArray;
  I: Integer;
  j: Integer;
begin
  j := 0;
  SetLength(dstBuf, length(srcBuf));
  i := 0;
  while i < length(srcBuf) do
  begin
    if srcBuf[I] = $7D then
    begin
      if srcBuf[I + 1] = $02 then
      begin
        dstBuf[j] := $7E;
        Inc(I);
      end
      else if srcBuf[I + 1] = $01 then
      begin
        dstBuf[j] := $7D;
        Inc(I);
      end
      else//��Э��Ҫ���ⲽӦ�ò����ߵ�
      begin
        dstBuf[j] := srcBuf[I];
      end;
    end
    else
    begin
      dstBuf[j] := srcBuf[I];
    end;
    Inc(i);
    Inc(j);
  end;
  SetLength(dstBuf, j);
  Result := dstBuf;
end;

procedure initCmd(var cmdHead: TSTHead; terminalId:string; cmdId, cmdSNo: Word;
  var cmdEnd: TSTEnd; cmdMinSize: Integer);
var
  terminalIdBuf: TByteDynArray;
begin
  cmdHead.StartFlag := CMD_START_FLAG;
  cmdHead.CmdId := ByteOderConvert_Word(cmdId);
  cmdHead.ClientType := 0;

  terminalIdBuf := hexStrToByteBuf(getFixedLenStr(GlobalParam.TerminalId, 12, '0'), False);
  CopyMemory(@(cmdHead.TerminalId[0]), @terminalIdBuf[0], SizeOf(cmdHead.TerminalId));
  cmdHead.BodySize := ByteOderConvert_Word(cmdMinSize - SizeOf(TSTHead) - SizeOf(TSTEnd));
  cmdHead.CmdSNo := ByteOderConvert_Word(cmdSNo);
  cmdEnd.CheckSum := 0;
  cmdEnd.EndFlag := CMD_END_FLAG;
end;

function PtrAdd(p: pointer; offset: integer): pointer;
begin
  Result := Pointer(Integer(p) + offset);
end;

function TransCmdGpsData(var AOrg: TCmdSrvtermGpsdata; var ANew: TGpsData): Boolean;
  function GetGpsTime(AOrg: array of Byte): TDateTime;
  var
    year, mon, day, hour, min, sec: Word;
  begin
    //-------------------���豸�յ�¼ʱ,��GPS���߻����й��ϣ����յ�ȫ��0������
    if (AOrg[1] = 0) and (AOrg[2] = 0) and (AOrg[3] = 0) and (AOrg[4] = 0) and (AOrg[5] = 0) then
    begin
      Result := EncodeDate(2000, 1, 1) + EncodeTime(0, 0, 0, 0);
      exit;
    end;
    //====================================================
    year := 2000 + AOrg[0];
    mon := AOrg[1];
    day := AOrg[2];
    hour := AOrg[3];
    min := AOrg[4];
    sec := AOrg[5];
    try
      Result := EncodeDate(year, mon, day) + EncodeTime(hour, min, sec, 0);
    except
      Result := 0; // EncodeDate(2000,1,1)+ EncodeTime(0,0,0,0);
    end;
  end;
begin
  Result := True;
  try
    ANew.Size := SizeOf(ANew);
    ANew.Id := AOrg.DevId;
    ANew.Long := AOrg.Long / 1000 / 60;
    ANew.Lat := AOrg.Lat / 1000 / 60;
    ANew.GpsTime := GetGpsTime(AOrg.GpsTime);
    ANew.Speed := AOrg.Speed;
    ANew.Altitude := AOrg.Altitude;
    ANew.Angle := AOrg.Angle;
    ANew.IO := AOrg.Stat;
    ANew.IO := (ANew.IO shl 8) or AOrg.Switch;
  except
    Result := False;
  end;
end;

function GetCurrTime: string;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:nn:ss', Now);
end;

function CmdToStr(P: Pointer): string;
  function GetTERMSRV_COMMVER(P: Pointer): string;
  begin
    with PCmdTermsrvRegverData(P)^ do
      Result := '�ͻ���ע��ͨѶЭ������ ' + IntToStr(MajorVer) + '.' + IntToStr(MinorVer);
  end;

  function GetSRVTERM_COMMVER(P: Pointer): string;
  begin
    with PCmdSrvtermRegverData(P)^ do
      Result := '��������Ӧע��ͨѶЭ������ ';
  end;

  function GetTERMSRV_REG(P: Pointer): string;
  begin
    with PCmdTermsrvRegUserData(P)^ do
      Result := '�ͻ���ע��,�û�:' + IntToStr(UserID) + ',Password:******' + '�ͻ��˰汾�� ' +
        IntToStr(MajorVer) + '.' + IntToStr(MinorVer);
  end;

  function GetSRVTERM_REG(P: Pointer): string;
  begin
    with PCmdSrvtermRegUserData(P)^ do
      Result := '��������Ӧע������' + IntToStr(PCmdSrvtermRegUserData(P)^.Ret);
  end;

  function GetTERMSRV_GETLASTPOS(P: Pointer): string;
  begin
    with PCmdTermsrvGetlastPosData(P)^ do
      Result := '�ͻ�������Ŀ������λ�ã�IDΪ' + IntToStr(PCmdTermsrvGetlastPosData(P)^.DevId);
  end;

  function GetSRVTERM_GETLASTPOS(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_GETSTAT(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_GETSTAT(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_GPSDATAV20(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_CALLDEV(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_CALLDEV(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_SWITCHCTRL(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_SWITCHCTRL(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_SENDDEVMSG(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_SENDMSG(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_PING(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_PING(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_NOTIFYSTAT(P: Pointer): string;
  begin

  end;

  function GetTERMSRV_CANCELCMD(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_CANCELCMD(P: Pointer): string;
  begin

  end;

  function GetSRVTERM_LASTGPSDATA(P: Pointer): string;
  begin

  end;

  function PtrAdd(P: Pointer; offset: integer): Pointer;
  begin
    Result := Pointer(integer(P) + offset);
  end;

begin
{
  case PByte(PtrAdd(P,2))^ of
    TERMSRV_COMMVER     :Result := GetTERMSRV_COMMVER(p)      ;//$01
    SRVTERM_COMMVER     :Result := GetSRVTERM_COMMVER(p)      ;//$81
    TERMSRV_REG         :Result := GetTERMSRV_REG(p)          ;//$02
    SRVTERM_REG         :Result := GetSRVTERM_REG(p)          ;//$82
    TERMSRV_GETLASTPOS  :Result := GetTERMSRV_GETLASTPOS(p)   ;//$03
    SRVTERM_GETLASTPOS  :Result := GetSRVTERM_GETLASTPOS(p)   ;//$83
    TERMSRV_GETDEVSTAT  :Result := GetTERMSRV_GETSTAT(p)      ;//$04
    SRVTERM_GETDEVSTAT  :Result := GetSRVTERM_GETSTAT(p)      ;//$84
    SRVTERM_GPSDATA     :Result := GetSRVTERM_GPSDATAV20(p)   ;//$85
    TERMSRV_CALLDEV     :Result := GetTERMSRV_CALLDEV(p)      ;//$06
    SRVTERM_CALLDEV     :Result := GetSRVTERM_CALLDEV(p)      ;//$86
    TERMSRV_SWCTRL      :Result := GetTERMSRV_SWITCHCTRL(p)   ;//$07
    SRVTERM_SWCTRL      :Result := GetSRVTERM_SWITCHCTRL(p)   ;//$87
    TERMSRV_SENDDEVMSG  :Result := GetTERMSRV_SENDDEVMSG(p)   ;//$08
    SRVTERM_SENDMSG     :Result := GetSRVTERM_SENDMSG(p)      ;//$89
    TERMSRV_PING        :Result := GetTERMSRV_PING(p)         ;//$0A
    SRVTERM_PING        :Result := GetSRVTERM_PING(p)         ;//$8A
    SRVTERM_NOTIFYMSG   :Result := GetSRVTERM_NOTIFYSTAT(p)   ;//$8B
    TERMSRV_CANCELCMD   :Result := GetTERMSRV_CANCELCMD(p)    ;//$0C
    SRVTERM_CANCELCMD   :Result := GetSRVTERM_CANCELCMD(p)    ;//$8C
    SRVTERM_LASTGPSDATA :Result := GetSRVTERM_LASTGPSDATA(p)  ;//$8D
  else
    Result := 'δ֪����';
  end;
 }
end;

end.

