unit FrmWaitingUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothPanel, AdvCircularProgress,
  Vcl.ComCtrls, AdvProgr, AdvSmoothProgressBar, W7Classes, W7ProgressBars,
  AdvSmoothLabel, RzBorder, CurvyControls, Vcl.Imaging.GIFImg, Vcl.ExtCtrls,
  AdvSmoothButton, RzPanel, Vcl.StdCtrls, AdvGlassButton, dxGDIPlusClasses;

type
  TfrmWaiting = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    AdvCircularProgress1: TAdvCircularProgress;
    RzPanel1: TRzPanel;
    AdvGlassButton1: TAdvGlassButton;
    Image1: TImage;
    tmr1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure AdvGlassButton1Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure AdvSmoothLabel1Click(Sender: TObject);
  private
    { Private declarations }
    procedure resetComponentPos();
    procedure hideProgressBar();
  public
    { Public declarations }
    procedure setWaitingTip(tip: string; isShowCancelBtn: Boolean = False; isHideProgressBar: Boolean = False);
    procedure noticeTimeout;
    procedure noticeFail;
    procedure noticeMROK;
    procedure noticeRetry;
    procedure startTimer(delayMilliseconds: Integer);
  end;

var
  frmWaiting: TfrmWaiting;

implementation
uses
  uGloabVar;

{$R *.dfm}

procedure TfrmWaiting.AdvGlassButton1Click(Sender: TObject);
begin
  addSysLog('btnCancel clicked');
  ModalResult := mrCancel;
end;

procedure TfrmWaiting.AdvSmoothLabel1Click(Sender: TObject);
begin
  if tmr1.Enabled then
  begin
    tmr1Timer(nil)
  end;
end;

procedure TfrmWaiting.FormCreate(Sender: TObject);
begin
  resetComponentPos;
  tmr1.Enabled := False;
end;

procedure TfrmWaiting.hideProgressBar;
begin
  AdvCircularProgress1.Visible := False;
  AdvSmoothLabel1.Align := alClient;
end;

procedure TfrmWaiting.noticeFail;
begin
  ModalResult := mrAbort;
end;

procedure TfrmWaiting.noticeMROK;
begin
  ModalResult := mrOk;
end;

procedure TfrmWaiting.noticeRetry;
begin
  ModalResult := mrRetry;
end;

procedure TfrmWaiting.noticeTimeout;
begin
  ModalResult := mrAbort;
end;

procedure TfrmWaiting.resetComponentPos;
begin
  AdvCircularProgress1.Visible := True;
  //RzPanel1.Align := alBottom;
  AdvSmoothLabel1.Align := alBottom;

  AdvCircularProgress1.Top := 15;
  AdvCircularProgress1.Left := (AdvSmoothPanel1.Width - AdvCircularProgress1.Width) div 2;
  if RzPanel1.Visible then
  begin
    Self.Height := 415;
    AdvSmoothLabel1.Height := AdvSmoothPanel1.Height - (AdvCircularProgress1.Height + AdvCircularProgress1.Top + RzPanel1.Height);
  end
  else
  begin
    Self.Height := 415 - 68;
    AdvSmoothLabel1.Height := AdvSmoothPanel1.Height - (AdvCircularProgress1.Height + AdvCircularProgress1.Top);
  end;
end;

procedure TfrmWaiting.setWaitingTip(tip: string; isShowCancelBtn: Boolean; isHideProgressBar: Boolean);
begin
  RzPanel1.Visible := isShowCancelBtn;

  if isHideProgressBar then
  begin
    hideProgressBar;
  end
  else
  begin
    resetComponentPos;
  end;
  AdvSmoothLabel1.Caption.Text := tip;
end;

procedure TfrmWaiting.startTimer(delayMilliseconds: Integer);
begin
  if delayMilliseconds < 500 then
  begin//时间太短，人看不清界面，就没意义了
    delayMilliseconds := 500;
  end;
  tmr1.Interval := delayMilliseconds;
  tmr1.Enabled := True;
end;

procedure TfrmWaiting.tmr1Timer(Sender: TObject);
begin
  tmr1.Enabled := False;
  ModalResult := mrOk;
end;

end.
