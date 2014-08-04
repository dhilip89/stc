unit frmProgressUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvCircularProgress, AdvSmoothLabel,
  Vcl.ExtCtrls, RzPanel, Vcl.StdCtrls, RzEdit;

type
  TfrmProgress = class(TForm)
    RzPanel1: TRzPanel;
    progress: TAdvCircularProgress;
    Timer1: TTimer;
    RzMemo1: TRzMemo;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmProgress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmProgress.FormHide(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TfrmProgress.FormResize(Sender: TObject);
begin
  progress.Top := (progress.Parent.Height - progress.Height) div 2;
  progress.Left := (progress.Parent.Width - progress.Width - RzMemo1.Width) div 2;

  RzMemo1.Top := progress.Top + 10;
  RzMemo1.Left := progress.Left + progress.Width;
end;

procedure TfrmProgress.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TfrmProgress.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Hide;
end;

end.
