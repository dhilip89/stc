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
  AMOUNT_30_YUAN = 30 * 100;
  AMOUNT_50_YUAN = 50 * 100;
  AMOUNT_100_YUAN = 100 * 100;
  AMOUNT_200_YUAN = 200 * 100;

  TIP_PUT_CITY_CARD = '�뽫����ͨ�������ڶ�����...';
  TIP_DO_NOT_MOVE_CITY_CARD = '���ڽ��г�ֵ���������ƿ���Ƭ...';
  TIP_CHECKING_PREPAID_CARD = '����У���ֵ�������Ժ�...';
  TIP_GETTING_PREPAID_CARD_AMOUNT = '���ڻ�ȡ��ֵ���,���Ժ�...';
  TIP_GETTING_ZHB_BALANCE = '���ڻ�ȡ�˻������,���Ժ�...';
  TIP_BALANCE_AFTER_CHARGED = '��ֵ������ͨƬ��';
  TIP_MODIFYING_ZHB_PASS = '�����޸��˻������룬�����ƿ���Ƭ...';

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


implementation


end.
