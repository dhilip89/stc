unit FrmCloseConfirmUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothButton, Vcl.StdCtrls, AdvEdit,
  AdvSmoothPanel, CurvyControls, Vcl.ExtCtrls, RzPanel, RzBorder, AdvSmoothLabel,
  Vcl.Mask, RzEdit, dxGDIPlusClasses;

type
  TfrmCloseConfirm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    AdvEdit1: TAdvEdit;
    Image1: TImage;
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure AdvEdit1Enter(Sender: TObject);
    procedure AdvEdit1Exit(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FInputPasswordWrongCount: Integer;
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
  frmMain.setKBReaderOutput(AdvEdit1, Image1);
end;

procedure TfrmCloseConfirm.AdvEdit1Exit(Sender: TObject);
begin
  frmMain.setKBReaderOutput(nil);
end;

procedure TfrmCloseConfirm.FormCreate(Sender: TObject);
begin
  FInputPasswordWrongCount := 0;
end;

procedure TfrmCloseConfirm.FormShow(Sender: TObject);
begin
  DoubleBuffered := True;
  AdvEdit1.Text := '';
  AdvEdit1.SetFocus;
end;

procedure TfrmCloseConfirm.Image1Click(Sender: TObject);
begin
  if isPasswordOK then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    Inc(FInputPasswordWrongCount);
    if FInputPasswordWrongCount >= 3 then
    begin//输错密码3次，关闭窗口
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TfrmCloseConfirm.Image2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
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
    AdvEdit1.Text := '';
    AdvEdit1.SetFocus;
    Exit;
  end;
  Result := True;
end;

end.
