unit BeansUnit;

interface

uses
  System.classes, Vcl.Controls, Vcl.ExtCtrls;

type
  TMyHintWindow = class(TComponent)
  private
    FHint: string;
    FHintWindow: THintWindow;
    FHintTimer: TTimer;
    procedure SetHint(const Value: string);

  protected
    procedure HideHint(Sender: TObject); virtual;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    property Hint: string read FHint write SetHint;
    property HintWindow: THintWindow read FHintWindow;
    property HintTimer: TTimer read FHintTimer;

    //procedure ShowHint(aHint: string); overload;
    procedure ShowHint(aHint: string; aComponent: TControl); overload;
  end;

implementation
uses
  Winapi.Windows, Vcl.Forms;

{ TMyHintWindow }

constructor TMyHintWindow.Create(aOwner: TComponent);
begin
  inherited;
  FHintWindow := THintWindowClass.Create(nil);
  FHintWindow.Color := $00D8D8AD;
  FHintTimer := TTimer.Create(nil);
  FHintTimer.Enabled := False;
  FHintTimer.OnTimer := HideHint;
  FHintTimer.Interval := 1500;
end;

destructor TMyHintWindow.Destroy;
begin
  FHintTimer.Enabled := False;
  FHintTimer.Free;
  FHintWindow.Free;
  inherited;
end;

procedure TMyHintWindow.HideHint(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  showwindow(FHintWindow.Handle, SW_HIDE);
end;

procedure TMyHintWindow.SetHint(const Value: string);
begin
  FHint := Value;
end;

procedure TMyHintWindow.ShowHint(aHint: string; aComponent: TControl);
var
  pt: TPoint;
  rect: TRect;
begin
  if aHint <> '' then
  begin
    if not IsWindowVisible(FHintWindow.Handle) or (FHintWindow.Caption <> aHint) then
    begin
      rect := FHintWindow.CalcHintRect(Screen.Width, aHint, nil);
      pt.X := aComponent.Left;
      pt.Y := aComponent.Top + aComponent.Height - 3;
      pt := aComponent.Parent.ClientToScreen(pt);
      Inc(rect.Left,pt.X);
      Inc(rect.Right,pt.X);
      Inc(rect.Top,pt.Y);
      Inc(rect.Bottom,pt.Y);
      FHintWindow.ActivateHint(rect,AHint);
      FHintTimer.Enabled:=true;
    end;
  end;
end;

end.
