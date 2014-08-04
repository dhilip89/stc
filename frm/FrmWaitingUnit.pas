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
  public
    { Public declarations }
    procedure setWaitingTip(tip: string);
    procedure noticeTimeout;
    procedure noticeMROK;
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
  AdvCircularProgress1.Top := 15;
  AdvCircularProgress1.Left := (AdvSmoothPanel1.Width - AdvCircularProgress1.Width) div 2;
  AdvSmoothLabel1.Height := AdvSmoothPanel1.Height - (AdvCircularProgress1.Height + AdvCircularProgress1.Top);
end;

procedure TfrmWaiting.FormDestroy(Sender: TObject);
begin
  Caption := 'destroy';
end;

procedure TfrmWaiting.FormHide(Sender: TObject);
begin
  Caption := 'form hide';
end;

procedure TfrmWaiting.noticeMROK;
begin
  ModalResult := mrOk;
end;

procedure TfrmWaiting.noticeTimeout;
begin
  ModalResult := mrAbort;
end;

procedure TfrmWaiting.setWaitingTip(tip: string);
begin
  AdvSmoothLabel1.Caption.Text := tip;
end;

end.
