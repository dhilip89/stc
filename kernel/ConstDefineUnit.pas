{���ó�������
 @created(2003-09-04)
 @lastmod(GMT:$Date: 2010/01/15 07:30:28 $) <BR>
 ��������:$Author: wfp $ <BR>
 ��ǰ�汾:$Revision: 1.1.1.1 $ <BR>}



unit ConstDefineUnit;

interface
uses Messages;
const

  //ϵͳ�˳�ʱ��Ĭ������
  DEFAULT_PASSWORD_FOR_QUIT = '213000';

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
  TIP_CITY_CARD_BALANCE = '����ͨ��';
  TIP_CITY_CARD_NO = '����ͨ���ţ�';
  TIP_CITY_CARD_BALANCE_AFTER_CHARGED = '��ֵ������ͨ��';
  TIP_MODIFYING_ZHB_PASS = '�����޸��˻������룬�����ƿ���Ƭ...';

  LOGIN_STATUS_OK                      = 0;//��¼�ɹ�
  LOGIN_STATUS_LOGINED_FROM_OTHER_TER  = 1;//�ն˺��������豸�ϵ�¼
  LOGIN_STATUS_TER_NOT_EXIST           = 2;//�ն˲�����
  LOGIN_STATUS_TER_DISABLED            = 3;//�ն˱�ͣ��
  LOGIN_STATUS_SERVER_DISCONNECTED     = 99;//δ���͵�¼����
  LOGIN_STATUS_NO_RSP                  = 100;//��¼�����δӦ��

implementation


end.
