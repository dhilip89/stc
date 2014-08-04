{*****************************************************
 @author:王磊（闲庭信步工作室 http://www.wl7989.cn）
 @created
 最后更新人:$Author: wfp $  <BR>
 当前版本:$Revision: 1.12 $  <BR>
*******************************************************}


unit BusinessServerUnit;

interface
uses
  Classes, SConnect, DBClient, Controls, Forms, types, Windows, Variants, SysUtils,
  Dialogs, UserUnit, DB, ExtCtrls, CmdStructUnit, InvokeRegistry, SOAPHTTPClient, OPConvert;
type
  TBusinessSevercom = class(TObject)
  private
    FUserName: string;
    FUserPass: string;
    FUserId: integer;
    FHost: string;
    FPort: Word;
    FHostBak: string;
    FPortBak: Word;
    FHostCurrent: string;
    FPortCurrent: Word;
    FTemp: Tclientdataset;
    FTimer: TTimer;

    FWServiceAMDAddr: string;
    FWServiceQAddr: string;

    procedure SetUserName(const Value: string);
    procedure SetUserPass(const Value: string);
    procedure SetUserId(const Value: integer);
//    function check_return(Ainfo: oleVariant): Boolean;
//    procedure FSocketAfterConnected(Sender: TObject);
    procedure FTimerTimer(Sender: TObject);
//    function GetActive: Boolean;
//  protected
//    FCancelMenuData: Tclientdataset;
  public
    constructor Create;
    destructor Destroy; override;
//    procedure ConnectServer; // 检查同应用服务器的连接，如果没有连接，则开始连接
//    procedure DisConnectServer; // 如果连接，则断开
    procedure SetWServiceAddr();
//    function userlogin(Auser: Tuser): Boolean; //用户登录
  public
    property UserId: integer read FUserId write SetUserId;
    property UserName: string read FUserName write SetUserName;
    property UserPass: string read FUserPass write SetUserPass;
    ///property Active: Boolean read GetActive;
    property Host: string read FHost write FHost;
    property Port: Word read FPort write FPort;
    property HostBak: string read FHostBak write FHostBak;
    property PortBak: Word read FPortBak write FPortBak;
    property Temp: TClientDataSet read FTemp write FTemp;//
  end;

implementation
uses
  uGloabVar, DateUtils, StrUtils, {systemlog, uFrmRefreshProgress,} ShellAPI
{$IFDEF ForAddEKey}, EKeyUseUnit{$ENDIF};
{ TBusinessSevercom }


constructor TBusinessSevercom.Create;
begin
  inherited;
//  FSocket := TSocketConnection.Create(nil);
//  FSocket.AfterConnect := FSocketAfterConnected;
  FTemp := Tclientdataset.Create(nil);
  FTemp.PacketRecords := 100;
//  FCancelMenuData := Tclientdataset.Create(nil);
//  FTimer := TTimer.Create(nil);
//
end;

destructor TBusinessSevercom.Destroy;
begin
//  FTimer.Enabled := False;
//  FTimer.Free;
//  FSocket.Free;
  FTemp.Free;
//  FCancelMenuData.Free;
  inherited;
end;

procedure TBusinessSevercom.SetUserId(const Value: integer);
begin
  FUserId := Value;
end;

procedure TBusinessSevercom.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TBusinessSevercom.SetUserPass(const Value: string);
begin
  FUserPass := Value;
end;

procedure TBusinessSevercom.FTimerTimer(Sender: TObject);
begin
  //DisConnectServer;
end;

procedure TBusinessSevercom.SetWServiceAddr;
begin
  FWServiceQAddr := 'http://' + GlobalParam.Business.Host + ':' + IntToStr(GlobalParam.Business.Port) + '/bsappservice/BSAppWebServiceQ?wsdl';
  FWServiceAMDAddr := 'http://' + GlobalParam.Business.Host + ':' + IntToStr(GlobalParam.Business.Port) + '/bsappservice/BSAppWebServiceAMD?wsdl';
end;


end.
