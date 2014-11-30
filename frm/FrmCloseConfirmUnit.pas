unit FrmCloseConfirmUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothButton, Vcl.StdCtrls, AdvEdit,
  AdvSmoothPanel, CurvyControls, Vcl.ExtCtrls, RzPanel, RzBorder, AdvSmoothLabel,
  Vcl.Mask, RzEdit, dxGDIPlusClasses;

type
  TOnPauseService = procedure () of object;
  TOnClearCashBox = procedure () of object;

  TfrmCloseConfirm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvSmoothPanel2: TAdvSmoothPanel;
    Notebook1: TNotebook;
    RzPanel1: TRzPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    Image2: TImage;
    AdvEdit1: TAdvEdit;
    Image1: TImage;
    RzPanel2: TRzPanel;
    btnClearCashBox: TAdvSmoothButton;
    btnCloseApp: TAdvSmoothButton;
    btnQuit: TAdvSmoothButton;
    btnPauseService: TAdvSmoothButton;
    procedure FormShow(Sender: TObject);
    procedure AdvEdit1Enter(Sender: TObject);
    procedure AdvEdit1Exit(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseAppClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnPauseServiceClick(Sender: TObject);
    procedure btnClearCashBoxClick(Sender: TObject);
  private
    { Private declarations }
    FInputPasswordWrongCount: Integer;
    FOnPauseService: TOnPauseService;
    FOnClearCashBox: TOnClearCashBox;
    function isPasswordOK(): Boolean;
  public
    { Public declarations }
    property OnPauseService: TOnPauseService read FOnPauseService write FOnPauseService;
    property OnClearCashBox: TOnClearCashBox read FOnClearCashBox write FOnClearCashBox;
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

procedure TfrmCloseConfirm.btnClearCashBoxClick(Sender: TObject);
begin
  if MessageBox(Handle, '您确认清空钱箱操作吗？', '确认', MB_YESNO + MB_ICONQUESTION) = ID_Yes then
  begin
    if Assigned(FOnClearCashBox) then
      FOnClearCashBox;
  end;
end;

procedure TfrmCloseConfirm.btnCloseAppClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmCloseConfirm.btnQuitClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCloseConfirm.btnPauseServiceClick(Sender: TObject);
begin
  if Assigned(FOnPauseService) then
    FOnPauseService;
  if FIsPausingService then
  begin
    btnPauseService.Caption := '恢复服务';
  end
  else
  begin
    btnPauseService.Caption := '暂停服务';
  end;
end;

procedure TfrmCloseConfirm.FormCreate(Sender: TObject);
begin
  FInputPasswordWrongCount := 0;
end;

procedure TfrmCloseConfirm.FormShow(Sender: TObject);
begin
  DoubleBuffered := True;
  Notebook1.ActivePage := 'Default';
  AdvEdit1.Text := '';
  AdvEdit1.SetFocus;
  if FIsPausingService then
  begin
    btnPauseService.Caption := '恢复服务';
  end
  else
  begin
    btnPauseService.Caption := '暂停服务';
  end;
end;

procedure TfrmCloseConfirm.Image1Click(Sender: TObject);
begin
  if isPasswordOK then
  begin
    //ModalResult := mrOk;
    Notebook1.ActivePage := 'Biz';
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
