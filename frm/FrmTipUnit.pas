unit FrmTipUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothLabel, AdvSmoothPanel,
  Vcl.ExtCtrls;

type
  TFrmTip = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTip: TFrmTip;

implementation

{$R *.dfm}

procedure TFrmTip.Timer1Timer(Sender: TObject);
begin
  Hide;
end;

end.
