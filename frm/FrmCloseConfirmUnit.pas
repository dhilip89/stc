unit FrmCloseConfirmUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothButton, Vcl.StdCtrls, AdvEdit,
  AdvSmoothPanel, CurvyControls, Vcl.ExtCtrls, RzPanel, RzBorder, AdvSmoothLabel,
  Vcl.Mask, RzEdit;

type
  TfrmCloseConfirm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    AdvSmoothButton1: TAdvSmoothButton;
    AdvSmoothButton2: TAdvSmoothButton;
    AdvEdit1: TAdvEdit;
    procedure FormShow(Sender: TObject);
    procedure AdvSmoothButton1Click(Sender: TObject);
    procedure AdvEdit1Enter(Sender: TObject);
    procedure AdvEdit1Exit(Sender: TObject);
  private
    { Private declarations }
    function isPasswordOK(): Boolean;
  public
    { Public declarations }
  end;

var
  frmCloseConfirm: TfrmCloseConfirm;

implementation
uses
  uGloabVar, frmMainUnit;

{$R *.dfm}

procedure TfrmCloseConfirm.AdvEdit1Enter(Sender: TObject);
begin
  frmMain.setKBReaderOutput(AdvEdit1);
end;

procedure TfrmCloseConfirm.AdvEdit1Exit(Sender: TObject);
begin
  frmMain.setKBReaderOutput(nil);
end;

procedure TfrmCloseConfirm.AdvSmoothButton1Click(Sender: TObject);
begin
  if isPasswordOK then
  begin
    ModalResult := mrOk;
  end;
end;

procedure TfrmCloseConfirm.FormShow(Sender: TObject);
begin
  DoubleBuffered := True;
  AdvEdit1.Text := '';
  AdvEdit1.SetFocus;
end;

function TfrmCloseConfirm.isPasswordOK: Boolean;
var
  pass: string;
begin
  Result := False;
  pass := Trim(AdvEdit1.Text);
  if pass <> GlobalParam.PasswordForQuit then
  begin
    ShowTips('请输入正确的管理密码', AdvEdit1);
    AdvEdit1.SetFocus;
    Exit;
  end;
  Result := True;
end;

end.
