{*�ṹ����������}
unit StructDefUnit;

interface
const
  {*���У������ͻ��˴��ڵȴ������绰״̬}
  CLIENT_STATE_IDLE = 0; //
  {*�ӵ绰���ͻ�������������ͨ����}
  CLIENT_STATE_BUSY = 1; //
  {*׼���ӵ绰������ͻ������壬�ȴ�ժ��}
  CLIENT_STATE_READY = 2; //
  {*�ͻ�����ʱֹͣ�����绰���ͻ�����ʱ�������绰����״̬�£�������������ÿͻ��˷���绰}
  CLIENT_STATE_PAUSE = 3; //

  {*������ϯ}
  CLIENT_TYPE_SCHEDULE = 0; //
  {*Ͷ�߿ͻ���}
  CLIENT_TYPE_ACCUSE = 1; //


  {*�ͻ���ע���ı�״̬�����־}
  CMD_TS_REGISTER = $00;
  {*��������Ӧ�ͻ���ע���ı�״̬�����־}
  CMD_ST_REGISTER = $80;
  {*������֪ͨ�ͻ������������־���ͻ���ժ���󣬽�ͨ���߻��յ��������}
  CMD_ST_CALLIN = $01;
  {*����δ��}
  CMD_TS_CALLIN = $81;
  {*�û�ͨ�����¼����ͻ��˵�����ͨ��״̬�����仯���յ�������¼����붨�������USER_EVENT_��ͷ�ĳ�������}
  CMD_ST_USERCHANNEL_EVENT = $02;
  {*�ͻ������������仯���յ��������������˸���״̬�ͻ��˵ĵ�ǰ����}
  CMD_ST_CLIENT_COUNT_CHANGE = $03;
  {*�ͻ���Ҫ���������ڵȴ��ĵ绰���������ߵȴ�����ʱ���ͻ�������Ҫ�����ӵ绰}
  CMD_TS_SWITCH_TO_ME = $84;
  {*�ͻ���֪ͨ�������������Ͳ���}
  CMD_TS_ERROR_CALLTYPE = $85;
  {*�ͻ���Ҫ�� ��������ͨ��--����˾��}
  CMD_TS_CALLTODRIVER = $06;
  {*�绰���������أ�����˾���绰�Ľ��}
  CMD_ST_CALLTODRIVER = $86;

  {*�û���ͨ���ߵ绰���û�ժ�������߽�ͨ����}
  USER_EVENT_TALKWITH = 0;
  {*�û�����ժ��,�Ƿ�����Ԥ�ڵ�}
  USER_EVENT_PICKUP = 1;
  {*������������û��ȴ����������ߣ��û�ͨ���ĵ绰��ʼ����}
  USER_EVENT_RING = 2;
  {*�û���δժ���������ߵ绰���ȴ���ͨ�������ѹҶ�}
  USER_EVENT_WAIT_EXT_HANGUP = 3;
  {*�û�����������ͨ����,������δ�һ����û����ȹһ�}
  USER_EVENT_TALK_HANGUP = 4;
  {*�û�����������ͨ����,�������ȹһ�}
  USER_EVENT_TALK_EXTHANGUP = 5;
  {*�û�������ͨ������,���߹һ���,�û������ٹһ�}
  USER_EVENT_TALK_FINISH_HANGUP = 6;
  {*������������û��ĵ绰�������峬��N��3�������û���δ�����绰,�绰�ѱ������Ŷ�}
  USER_EVENT_WAIT_TIMEOUT = 7;
  {*�û�������ժ�����ٹһ�,�Ƿ�����Ԥ�ڵ�}
  USER_EVENT_HANGUP = 8;
  {*���������û�ִ�������������������û��ĵ绰�������ͻ���������}
  USER_EVENT_STOP = 9;
  {*�ڲ�ͨ���ѽ�������Է��ҵ绰}
  USER_EVENT_INNERTALKOVER = 10;

  //��������ͨ�������صĽ��
  {*û�п�������ͨ��}
  CALL_DRIVER_NOIDLELINE = 0;
  {*����ĵ绰����}
  CALL_DRIVER_ERRTELLNUM = 1;
  {*�Է�æ��ʱ�����˽���}
  CALL_DRIVER_NOLISTEN_OR_BUSY = 2;
  {*�Է���ժ������������ͨ��}
  CALL_DRIVER_THIRDTALKING = 3;
type
  {*@abstract�ͻ��������ṹ
  �ͻ��������ṹ@html(<br/>)
  Idle ��������@html(<br/>)
  Pause ��ͣ��������@html(<br/>)
  Ready ׼�������绰����@html(<br/>)
  Busy ���ڽ����绰����@html(<br/>)
  }
  TClientCountData = packed record
    Total: Integer;
    Idle: Integer;
    Pause: Integer;
    Ready: Integer;
    Busy: Integer;
  end;

  {*TCmdTSRegisterData��ָ�붨��}
  PCmdTSRegisterData = ^TCmdTSRegisterData;

  {*@abstract�ͻ��˵���������ע������
  �ͻ��˵���������ע������@html(<br/>)
  Size ����
  Flag �����־��Ӧ��ΪCMD_TS_REGISTER @html(<br/>)
  UserChannelNo �ͻ��˵�ͨ����@html(<br/>)
  UserState �ͻ��˵�״̬���ı�״̬ʱ��Ч@html(<br/>)
  UserType �ͻ��˵�����}
  TCmdTSRegisterData = packed record
    {*����}
    Size: Word;
    {*�����־,Ӧ��Ϊ}
    Flag: Byte;
    {�ͻ��˵�ͨ����}
    UserChannelNo: Byte;
    {*�ͻ��������״̬,�ı�״̬ʱ��Ч}
    UserState: Byte;
    {*�ͻ�������,Ͷ�߻����}
    UserType: Byte;
  end;
  {*TCmdSTRegisterData��ָ�붨��}
  PCmdSTRegisterData = ^TCmdSTRegisterData;
  {*@abstract��������Ӧ�ͻ��˵�ע������
  ��������Ӧ�ͻ��˵�ע������@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־ Ӧ��ΪCMD_ST_REGISTER @html(<br/>)
  Ret ����ֵ@html(<br/>)
  State �ͻ���Ӧ�����е�״̬}
  TCmdSTRegisterData = packed record
    Size: Word;
    Flag: Byte;
    Ret: Byte; //0 �ɹ� 1 ͨ���Ų����� 2 ͨ������ռ�ã�3 ����ı�״̬ 4 ������ı�״̬ �������1,2������˽���Ͽ�����
    State: Integer; //�ͻ��˵�״̬ �������δ�Ͽ�,��״̬���ǿͻ��˵�ǰ��״̬
  end;

  {*TCmdSTCallInData��ָ�붨��}
  PCmdSTCallInData = ^TCmdSTCallInData;
  {*@abstract������������Ϣ
  �������յ�������Ϣ�����ͻ��˵�����@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־ Ӧ��ΪCMD_ST_CALLIN @html(<br/>)
  CallNo ������� @html(<br/>)
  CallID �����¼ID}
  TCmdSTCallInData = packed record
    Size: Word;
    Flag: Byte;
    CallNo: string[20];
    CallID: Integer;
  end;

  {*TCmdTSCallInData��ָ�붨��}
  PCmdTSCallInData = ^TCmdTSCallInData;
  {*@abstract����δ��
  �ͻ���������Ϣ���������,��ʱû��}
  TCmdTSCallInData = packed record
    Size: Word;
    Flag: Byte;
    Ret: Integer; //0 �յ� ����������ָ����ʱ����δ�յ������ط�
  end;
  {*@abstract���ͻ���ע����û�ͨ�������¼�ʱ��������֪ͨ�ͻ��ˣ���ע����û�ͨ�����¼�
  ���ͻ���ע����û�ͨ�������¼�ʱ��������֪ͨ�ͻ��ˣ���ע����û�ͨ�����¼�@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־ Ӧ��ΪCMD_ST_USERCHANNEL_EVENT@html(<br/>)
  Event �������¼�����}
  TCmdSTUserChannelEventData = packed record
    Size: Word;
    Flag: Byte;
    Event: Byte;
  end;
  {*TCmdSTUserChannelEventData��ָ�붨��}
  PCmdSTUserChannelEventData = ^TCmdSTUserChannelEventData;
  {*@abstract���ڷ������Ͽͻ��˵����������仯ʱ,������֪ͨ�ͻ��˵�����
  ���ڷ������Ͽͻ��˵����������仯ʱ,������֪ͨ�ͻ��˵�����@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־ Ӧ��ΪCMD_ST_CLIENT_COUNT_CHANGE@html(<br/>)
  Client �ͻ��˵����@html(<br/>)
  }
  TCmdSTClientCountChangeData = packed record
    Size: Word;
    Flag: Byte;
    Client: TClientCountData;
  end;
  {*TCmdSTClientCountChangeData��ָ�붨��}
  PCmdSTClientCountChangeData = ^TCmdSTClientCountChangeData;
  {*@abstract�ͻ�����Ҫ�������ڵȴ��ĵ绰
  �ͻ�����Ҫ�������ڵȴ��ĵ绰@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־}
  TCmdTSSwitchToMeData = packed record
    Size: Word;
    Flag: Byte;
  end;
  {*TCmdTSSwitchToMeData��ָ�붨��}
  PCmdTSSwitchToMeData = ^TCmdTSSwitchToMeData;
  {*@abstract�ͻ���֪ͨ��������ǰ�ĵ绰���ʹ����˻ط����������Ŷ�
  �ͻ���֪ͨ��������ǰ�ĵ绰���ʹ����˻ط����������Ŷ�@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־@html(<br/>)
  CallType: �绰����ȷ���� 0 ��ʾ�ǽг��绰 1 ��ʾ��Ͷ�ߵ绰
  }
  TCmdTSErrorCalLType = packed record
    Size: Word;
    Flag: Byte;
    CallType: Integer;
  end;
  {*TCmdTSErrorCalLType��ָ�붨��}
  PCmdTSErrorCalLType = ^TCmdTSErrorCalLType;

  {*@abstract�ͻ���Ҫ�� ��������ͨ��--Ҫ��绰������ȥ����˾��
  �ͻ���Ҫ�� ��������ͨ��--Ҫ��绰������ȥ����˾��@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־ CMD_TS_CALLTODRIVER = $06 @html(<br/>)
  DriverTellNum ˾������ @html(<br/>)}
  TCmdTSCallToDriver = packed record
    Size: Word;
    Flag: Byte;
    DriverTellNum: string[20];
  end;
  {*TCmdTSCallToDriver��ָ�붨��}
  PCmdTSCallToDriver = ^TCmdTSCallToDriver;
  {*@abstract�绰���������أ�����˾���绰�Ľ��
  �绰���������أ�����˾���绰�Ľ��@html(<br/>)
  Size ����@html(<br/>)
  Flag �����־ CMD_ST_CALLTODRIVER = $86; @html(<br/>)}
  TCmdSTCallToDriverRet = packed record
    Size: Word;
    Flag: Byte;
    Ret: Byte; //�鿴����Ԫ�� ��CALL_DRIVER��ͷ�Ķ���
  end;
  {*TCmdSTCallToDriverRet��ָ�붨��}
  PCmdSTCallToDriverRet = ^TCmdSTCallToDriverRet;

{*��ÿͻ���״̬����}
function GetClientStateDesc(AState: Integer): string;
{*����û�ͨ���¼�����}
function GetUserEventDesc(AEvent: Integer): string;
implementation

function GetClientStateDesc(AState: Integer): string;
begin
  case AState of
    CLIENT_STATE_IDLE: Result := '����';
    CLIENT_STATE_BUSY: Result := '��æ';
    CLIENT_STATE_READY: Result := '׼��';
    CLIENT_STATE_PAUSE: Result := '��ͣ';
  else
    Result := 'δ֪״̬';
  end;
end;

function GetUserEventDesc(AEvent: Integer): string;
begin
  case AEvent of
    USER_EVENT_TALKWITH: Result := '�û���ͨ���ߵ绰';
    USER_EVENT_PICKUP: Result := '�û�ժ��,�Ƿ�����Ԥ�ڵ�';
    USER_EVENT_RING: Result := '�û�ͨ���ĵ绰��ʼ����';
    USER_EVENT_WAIT_EXT_HANGUP: Result := '�ȴ���ͨ�������ѹҶ�';
    USER_EVENT_TALK_HANGUP: Result := '����ͨ����,�û����ȹһ�';
    USER_EVENT_TALK_EXTHANGUP: Result := '����ͨ����,�������ȹһ�';
    USER_EVENT_TALK_FINISH_HANGUP: Result := 'ͨ������,���߹һ���,���߹һ�';
    USER_EVENT_WAIT_TIMEOUT: Result := '�û�����δ�����绰,�绰�ѱ������Ŷ�';
    USER_EVENT_HANGUP: Result := '�û��һ�,�Ƿ�����Ԥ�ڵ�';
    USER_EVENT_STOP: Result := '�û��绰������';
    USER_EVENT_INNERTALKOVER: Result := '�ڲ�ͨ���ѽ�������Է�ͨ���ҵ绰';
  else
    Result := 'δ֪';
  end;
end;

end.
