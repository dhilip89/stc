program stclient;

uses
  Vcl.Forms,
  frmMainUnit in 'frm\frmMainUnit.pas' {frmMain},
  frmProgressUnit in 'frm\frmProgressUnit.pas' {frmProgress},
  BeansUnit in 'kernel\BeansUnit.pas',
  MemFormatUnit in 'kernel\MemFormatUnit.pas',
  ScktCompUnit in 'kernel\ScktCompUnit.pas',
  SystemLog in 'kernel\SystemLog.pas',
  uGloabVar in 'kernel\uGloabVar.pas',
  UserUnit in 'kernel\UserUnit.pas',
  ParamUnit in 'kernel\ParamUnit.pas',
  CmdStructUnit in 'kernel\CmdStructUnit.pas',
  BusinessServerUnit in 'kernel\BusinessServerUnit.pas',
  MSXML2_TLB in 'kernel\MSXML2_TLB.pas',
  ConstDefineUnit in 'kernel\ConstDefineUnit.pas',
  IntegerListUnit in 'kernel\IntegerListUnit.pas',
  GatewayServerUnit in 'kernel\GatewayServerUnit.pas',
  drv_unit in 'kernel\drv_unit.pas',
  FrmWaitingUnit in 'frm\FrmWaitingUnit.pas' {frmWaiting},
  ThreadsUnit in 'kernel\ThreadsUnit.pas',
  FrmTipUnit in 'frm\FrmTipUnit.pas' {FrmTip},
  itlssp in 'kernel\itlssp.pas',
  SPCOMM in 'kernel\SPCOMM.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmWaiting, frmWaiting);
  Application.CreateForm(TFrmTip, FrmTip);
  Application.Run;
end.
