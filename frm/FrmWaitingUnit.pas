unit FrmWaitingUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothPanel, AdvCircularProgress,
  Vcl.ComCtrls, AdvProgr, AdvSmoothProgressBar, W7Classes, W7ProgressBars,
  AdvSmoothLabel, RzBorder, CurvyControls, Vcl.Imaging.GIFImg, Vcl.ExtCtrls;

type
  TfrmWaiting = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    AdvCircularProgress1: TAdvCircularProgress;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure resetComponentPos();
    procedure hideProgressBar();
  public
    { Public declarations }
    procedure setWaitingTip(tip: string; isHideProgressBar: Boolean = False);
    procedure noticeTimeout;
    procedure noticeFail;
    procedure noticeMROK;
    procedure noticeRetry;
  end;

var
  frmWaiting: TfrmWaiting;

implementation

{$R *.dfm}

procedure TfrmWaiting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Caption := 'form closing';
end;

procedure TfrmWaiting.FormCreate(Sender: TObject);
//var
//  gif: TGIFImage;
begin
//  gif := TGIFImage.Create;
//  gif.LoadFromFile('d:\tempd\loading.gif');
//  gif.Animate := true;
//  img1.Picture.Assign(gif);
//  gif.Free;
  resetComponentPos;
end;

procedure TfrmWaiting.FormDestroy(Sender: TObject);
begin
  Caption := 'destroy';
end;

procedure TfrmWaiting.FormHide(Sender: TObject);
begin
  Caption := 'form hide';
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
  AdvSmoothLabel1.Align := alBottom;

  AdvCircularProgress1.Top := 15;
  AdvCircularProgress1.Left := (AdvSmoothPanel1.Width - AdvCircularProgress1.Width) div 2;
  AdvSmoothLabel1.Height := AdvSmoothPanel1.Height - (AdvCircularProgress1.Height + AdvCircularProgress1.Top);
end;

procedure TfrmWaiting.setWaitingTip(tip: string;isHideProgressBar: Boolean);
begin
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

end.
