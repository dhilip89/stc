{���ó�������
 @created(2003-09-04)
 @lastmod(GMT:$Date: 2010/01/15 07:30:28 $) <BR>
 ��������:$Author: wfp $ <BR>
 ��ǰ�汾:$Revision: 1.1.1.1 $ <BR>}



unit ConstDefineUnit;

interface
uses Messages;
const
//====================================================================
  INITDATA_HOUR = 4;
  MY_APP_NAME = 'VSMSClient_Taxi';
  CM_RESTORE = WM_USER + $1000; // -�Զ���ġ��ָ�����Ϣ
  CM_DATASERVER_SENDMSG = WM_USER + $1001; //
  CM_DevStat = WM_USER + $1002; // �豸״̬
  CM_DevParam_READOk = WM_USER + $1003; // ���豸����
  CM_DevNotifyStat = WM_USER + $1004; // �����������ݸ��µ�֪ͨ,֪ͨ�ͻ���Ҫˢ��ָ�����豸����Ϣ
  CM_DevToHost = WM_USER + $1005; // �յ�Dev���͵�Host������
  CM_RegUserErr = WM_USER + $1006; // �û���¼�����ط����� ����
  CM_DEVALARM = WM_USER + $1007; // ���յ���GPS�������� ����

  //ɾ��Խ���ʻ�뱨���б��е���س��� ������Ϣ�ɵ���Χ���б���ɾ��ʱ�����������档
  //--���û��ڵ���Χ���б���ɾ��ĳ���򣨶�Ӧ�ĳ�����ȫ���޶����� ��ĳ�����в����޶��ó�ʱ�����Խ���ʻ�뱨���б����иó����������뵽��ʷ��¼��
  CM_DELAlarmListDev_OutORInCA = WM_USER + $1008;

  CM_UPDATE = WM_USER + $1009; //���±�����,,����ر��Լ�,�����Ϣ���ɸ��³��򷢳�.
//  CM_PowerCut           =WM_USER+ $1010;  //�ϵ籨��

  //���������ִ��״̬
  CMD_SNDNODO = 0; // �ѷ���δִ��
  CMD_DONE = 1; // ��ִ��
  CMD_DOERROR = 2; // ִ�г���
  CMD_CANCELByUSER = 3; // ���û�ȡ��
  CMD_CANCELED = 4; // ��ȡ��
  CMD_CANCELFAIL = 5; // ȡ��ʧ��
  CMD_RESND = 6; // �ط�
  CMD_DELETED = 7; // ��ɾ��
  CMD_REPLACE = 8; // �����
  CMD_OVERTIME = 9; // ��ʱ
  CMD_SND2SMSSENDSVR = 10; // �ѷ��͵�SMS���ͷ�����
  CMD_INVALIDDEV = 11; //��Ч�ĳ���ID��

  ForDevLimit = 100; //��ǰ����� �鿴������
  UserDrawAreaLayerName = '����Χ���滭ͼ��'; //�����򡡵�ͼ��ġ�����
  SpecialAreaLayerName = '��������滭ͼ��'; //�޸�08-8-16AYH

  ALARM_OUT = 0; //Խ���硡����
  ALARM_IN = 1; //��硡������
  ALARM_OVER_SPEET = 2; //�����ٱ���
  ALARM_WAY_OUT = 3;
  ALARM_WAY_IN = 4;
  BUSLINE_WAY = 5;
//==========================================================================

  (*****�ͻ��ˡ�������****)
  RET_OK = $0;
  {����ִ�гɹ�}
  RET_CMDOK = $0;
  {ERR_��ͷ��Ϊ������}
  //���й���
  ERR_LED = $1;
  {��Ч�û���}
  ERR_INVALIDUSER = $1;
  {��������}
  ERR_INVALIDPASSWD = $2;
  {�û��������¼}
  ERR_USERDISABLED = $3;
  {�û��ѱ�ɾ��}
  ERR_USERDELETED = $4;
  {��������Ч}
  ERR_INVALIDOLDPASSWD = $5;
  {��������Ч}
  ERR_INVALIDNEWPASSWD = $6;
  {��δ��¼}
  ERR_NOTLOGIN = $7;
  {û��ȡ����Ҫ������}
  ERR_NODATA = $8;
  { �������Ҫ����������}
  ERR_DATALACK = $9;
  {��������ݸ�ʽ}
  ERR_INVALIDFORMAT = $A;
  {û��������Ҫͬ��}
  ERR_NOSYNC = $B;
  { д�����ݿ�ʧ��}
  ERR_Record = $C;
  {���汾�Ź���}
  ERR_ProtocalMajorOver = $D;
  {���汾�Ź�С}
  ERR_ProtocalMajorLack = $E;
  {�ΰ汾�Ź���}
  ERR_ProtocalMinorOver = $F;
  {�ΰ汾�Ź�С}
  ERR_ProtocalMinorLack = $10;
  {��Ч�İ汾��}
  ERR_INVALIDVER = $11;
  {�ظ���¼}
  ERR_Logged = $12;
  {��Ч�ĳ���}
  ERR_INVALIDDEV = $13;
  {��Ч���ƶ�Ŀ��}
  ERR_INVALIDTARGET = $14;
  {û��Ȩ��}
  ERR_NOPRIVILEGE = $15;
  {����ִ�г�ʱʧ��}
  ERR_TIMEOUT = $16;
  {�������޸ĺ�ִ��,������ִ���ڼ䱻һ���µ����ֻ�ǲ�����ͬ�����}
  RET_CMDMODIFY = $17;
  {�����ѷ��͵�SMS���ͷ�����}
  RET_CMDSnd2SMSSendSvr = $18;
  {�����ѱ�ɾ��}
  RET_ORDERDELETED = $19;
  {����ִ��ʧ��}
  RET_FAIL = $FE;
  {δ֪����}
  ERR_Unknown = $FF;
  {ͨ�ŷ����������û�,ΪXXXXX��md5ֵ}
  SYSTEM_SUPERUSER = '{F1F34647-81A5-48F6-A854-F8B469F64F67}';
  SYSTEM_SUPERPASS = '{A789376B-F01E-40A8-917A-DF5B34B200FE}';
  {���볤��}
  PassLength = 32;

//��Ϣ��������
  //��Ϣ����
  MSGTYPE_NORMAL = 0; //�ı�������Ϣ
  MSGTYPE_NEEDANSWER = 1; //��ظ��ĵ�����������
  //��Ϣ״̬
  MSGSTAT_UNSEND = 0; //��Ϣδ����
  MSGSTAT_SENDED = 1; //��Ϣ�ѷ���
  MSGSTAT_RECVED = 2; //�����ѽ�����Ϣ
  MSGSTAT_REPLYED = 3; //˾����Ӧ����Ϣ
  MSGSTAT_FAILED = 9; //��Ϣ����ʧ��
  //˾��Ӧ��
  MSGANSWERTYPE_YES = 1; //˾��Ӧ����
  MSGANSWERTYPE_NO = 0; //˾��Ӧ�𣭷�

//���������̼� ����
  UPDATEDEV_DEV = $0; //��������
  UPDATEDEV_DISPLAY = $1; //������ʾ��


//���ݿ�����
  DATABASE_NAME = 'VSMSdata';

//��ȡ�豸������
  DEVParam_Basic = 0; //��������
  DEVParam_Else = 1; //������ҵ��绰
  DEVParam_KeyPressTel = 2; //�����绰

  //����ͨ��
  COMMUNICATION_GRPS = 0; //GPRS��ʽ
  COMMUNICATION_SMS = 1; //����Ϣ��ʽ

  //�·���������������� û������Ӧ�������Զ�ɾ��
  TIMEOVER_DELORDER = 30000;
  //������״̬
  ORDERSTATE_NODEVANSWER_DEL = 0; //�����·�30���û�г�����Ӧ�������Զ�ɾ��
  ORDERSTATE_WAITGRAB = 1; //�ȴ�����������
  ORDERSTATE_DEVGRAB = 2; //  ���г�������
  ORDERSTATE_SENDINGDEVGRABOK = 3; //�����·������������ɹ�
  ORDERSTATE_SENDDEVGRABOK_FAIL = 4; //�·������������ɹ���ʧ�ܣ�����ûӦ���·������� ����Ҳ��Ӧ�𡣻����޳����ɷ���
  ORDERSTATE_DEVGRABOK = 5; //���������ɹ�
  ORDERSTATE_SRVCANCEL = 6; //����ȡ������
  ORDERSTATE_DEVCANCEL = 7; //����ȡ������

 //�̶��˵�����
  LCD_MENU_LENGTH = 39;
 //�̶��˵�����
  LCD_MENU_COUNT = 128;

 //������Ϣ��(PostMessage)����, //��Ӧ�ĺ���: ReturnMsgTypeState
  MSG_TYPE_LCD_MENU = 1; //�̶��˵�.
  MSG_TYPE_CONTRAL_INFO = 2; //������Ϣ.
  MSG_TYPE_TAXI_STOPTIME = 3; //�Ƽ���ͣ��ʱ��
  MSG_TYPE_SEV_INFO = 4; //������֪ͨ��Ϣ;
  MSG_TYPE_DEV_SEND_TO_HOST = 5; // �յ�Dev���͵�Host������
  MSG_TYPE_GPS_MODULE_ERROR = 24; //GPSģ�鷢������
  MSG_TYPE_GPS_LINE_ERROR = 25; //GPS����δ�ӻ򱻼���
  MSG_TYPE_LOW_V = 26; //��ѹ����
  MSG_TYPE_LCD_ERROR = 27; //LCD����
  MSG_TYPE_MEASURE_ERROR = 28; //�Ƽ�������
  MSG_TYPE_SIM_ERROR = 29; //SIM��δ���ã����߳�����ȡSIM����ʧ��

  //���Ͷϵ繩�͹��硡�����еľ�������
  CUT_OIL = 1; //����
  CUT_ELECTRICITY = 2; //�ϵ�
  FEED_OIL = 3; //����
  FEED_ELECTRICITY = 4; //����


//===================================================================


  //ϵͳ�����������ͨѶ
  SYSADM_USERID = $00FF00FF;
  SYSADM_USERPASS = '{B274AB8A-34D5-476F}';

  //������Web����ͨѶ       20070611
  SYSWEB_USERID = $1002;
  SYSWEB_USERPASS = '1';

  //���ȷ������� ����ġ�TCP�ͻ��� ��¼����
  DISPATCH_USERID = $00FF0100;
  DISPATCH_USERPASS = '{8707A054-5ADA-416B}';

  //������ͷ�������½����
  OTHERSERVER_USERID = $1000;
  //������صķ�������¼�û���
  CHECKGATAWAY_USERID = $1001;

  SWITCHBOARDON = 1;
  SWITCHBOARDOFF = 0;

  IOPARKTYPE_INPARKFROMS = 7;
  IOPARKTYPE_INPARKFROME = 8;
  IOPARKTYPE_OUTPARKTOS = 9;
  IOPARKTYPE_OUTPARKTOE = 10;

function ReturnMsgTypeState(State: integer): string;
//�õ����͵繩�͹���ľ�������
function ReturnCutOrFeedContent(ParamId: Byte): string;


implementation


function ReturnMsgTypeState(State: integer): string;
begin
  Result := '';
  case State of
    MSG_TYPE_LCD_MENU: Result := '�̶��˵�';
    MSG_TYPE_CONTRAL_INFO: Result := '������Ϣ';
    MSG_TYPE_TAXI_STOPTIME: Result := '�Ƽ���ͣ��ʱ��';
    MSG_TYPE_SEV_INFO: Result := '������֪ͨ��Ϣ';
    MSG_TYPE_DEV_SEND_TO_HOST: Result := '�յ����������ĵ�����';
    MSG_TYPE_GPS_MODULE_ERROR: Result := 'GPSģ�鷢������';
    MSG_TYPE_GPS_LINE_ERROR: Result := 'GPS����δ�ӻ򱻼���';
    MSG_TYPE_LOW_V: Result := '��ѹ����';
    MSG_TYPE_LCD_ERROR: Result := 'LCD����';
    MSG_TYPE_MEASURE_ERROR: Result := '�Ƽ�������';
     //MSG_TYPE_SIM_ERROR:Result          :='SIM��δ���ã����߳�����ȡSIM����ʧ��';
  end;
end;

function ReturnCutOrFeedContent(ParamId: Byte): string;
begin
  Result := '';
  case ParamId of
    CUT_OIL: Result := '����';
    CUT_ELECTRICITY: Result := '�ϵ�';
    FEED_OIL: Result := '����';
    FEED_ELECTRICITY: Result := '����';
  end;
end;

end.
