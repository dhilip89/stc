unit ParamUnit;

interface
{$A+}
uses
  MSXML2_TLB, XMLDoc, XMLIntf, Graphics, Types;
type
  TAddrssParam = record
    Host: string;
    Port: Integer;
  end;

  TSystemParam = class
  private
    FGateway: TAddrssParam; //�����ط�����
    FIsUseGatewayBak: boolean;
    FGatewayBak: TAddrssParam; //�����ط�����
    FSkinName: string;
    FBusiness: TAddrssParam; //��ҵ�����
    FIsUseBusinessBak: boolean;
    FBusinessBak: TAddrssParam; //��ҵ�����

    FUserName: string;
    FUserPassword: string;
    FTerminalId: string;
    FD8ComPort: Integer;
    FD8BaudRate: Integer;
    FITLPort: Integer;
    FPrinterComPort: Integer;
    FPosId: string;
    FSAMID: string;
    FKeyBoardComPort: Integer;

    procedure SetGateway(const Value: TAddrssParam);
    procedure SetGatewayBak(const Value: TAddrssParam);
    procedure SetBusiness(const Value: TAddrssParam);
    procedure SetBusinessBak(const Value: TAddrssParam);

    procedure SetUserName(const Value: string);
    procedure SetUserPassword(const Value: string);
    procedure SetTerminalId(const Value: string);
    procedure SetPosId(const Value: string);
    procedure SetSAMID(const Value: string);

  protected
    function SaveToXML: TXMLDocument;
    procedure LoadFromXML(AXML: IXMLDOMDocument2);
  public
    constructor Create;
    procedure SaveToFile(const AFileName: string);
    procedure LoadFromFile(const AFileName: string);
    procedure loadFromRemote(const ARemoteString: string);
    property Gateway: TAddrssParam read FGateway write SetGateway; //������
    property IsUseGatewayBak: boolean read FIsUseGatewayBak write FIsUseGatewayBak; //�Ƿ�ʹ�ø�����
    property GatewayBak: TAddrssParam read FGatewayBak write SetGatewayBak; //������

    //-------���ز���
    property Business: TAddrssParam read FBusiness write SetBusiness; //��ҵ�������
    property IsUseBusinessBak: boolean read FIsUseBusinessBak write FIsUseBusinessBak; //�Ƿ�ʹ�ø�ҵ�������
    property BusinessBak: TAddrssParam read FBusinessBak write SetBusinessBak; //��ҵ�������

    property UserName: string read FUserName write SetUserName;
    property UserPassword: string read FUserPassword write SetUserPassword;

    property TerminalId: string read FTerminalId write SetTerminalId;
    property PosId: string read FPosId write SetPosId;
    property SAMID: string read FSAMID write SetSAMID;

    //---����������---
    property D8ComPort: Integer read FD8ComPort write FD8ComPort;
    property D8BaudRate: Integer read FD8BaudRate write FD8BaudRate;
    //---����������---

    //---ֽ�һ�����---
    property ITLPort: Integer read FITLPort write FITLPort;
    //---ֽ�һ�����---

    //---��ӡ������---
    property  PrinterComPort: Integer read FPrinterComPort write FPrinterComPort;
    //---��ӡ������---

    //---������̲���---
    property KeyBoardComPort: Integer read FKeyBoardComPort write FKeyBoardComPort;
    //---������̲���---

  end;
implementation

uses SysUtils;
{ TSystemParam }

constructor TSystemParam.Create;
begin
  FBusiness.Port := 211;
end;

procedure TSystemParam.LoadFromFile(const AFileName: string);
var
  x: TDOMDocument;
begin
  x := TDOMDocument.Create(nil);
  x.DefaultInterface.async := False;
  x.DefaultInterface.load(AFileName);
  LoadFromXML(x.DefaultInterface);
  x.Free;
end;

procedure TSystemParam.loadFromRemote(const ARemoteString: string);
var
  x: TDOMDocument;
begin
  x := TDOMDocument.Create(nil);
  x.DefaultInterface.async := False;
  x.DefaultInterface.loadXML(ARemoteString);
  LoadFromXML(x.DefaultInterface);
  x.Free;
end;

procedure TSystemParam.LoadFromXML(AXML: IXMLDOMDocument2);
  function GetBoolValue(node: IXMLDOMNode): Boolean;
  begin
    Result := node.text = 'True';
  end;
var
  r: IXMLDOMElement;
  n1, n2: IXMLDOMNode;
  nl1: IXMLDOMNodeList;
  x: IXMLDOMDocument2;
  i: Integer;
begin
  try
    x := AXML;
    r := x.DocumentElement;
    n1 := r.selectSingleNode('//system');
    if n1 <> nil then
    begin
      n2 := n1.selectSingleNode('gatewayhost');
      if n2 <> nil then
      begin
        FGateway.Host := Trim(n2.Text);
      end;

      n2 := n1.selectSingleNode('gatewayport');
      if n2 <> nil then
      begin
        FGateway.Port := StrToInt(n2.Text);
      end;

      n2 := n1.selectSingleNode('bizserverhost');
      if n2 <> nil then
      begin
        FBusiness.Host := Trim(n2.Text);
      end;

      n2 := n1.selectSingleNode('bizserverport');
      if n2 <> nil then
      begin
        FBusiness.Port := StrToInt(Trim(n2.text));
      end;

      n2 := n1.selectSingleNode('terminalId');
      if n2 <> nil then
      begin
        FTerminalId := Trim(n2.text);
      end;

      n2 := n1.selectSingleNode('D8ComPort');
      if n2 <> nil then
      begin
        FD8ComPort := StrToInt(Trim(n2.text));
      end;

      n2 := n1.selectSingleNode('D8BaudRate');
      if n2 <> nil then
      begin
        FD8BaudRate := StrToInt(Trim(n2.text));
      end;

      n2 := n1.selectSingleNode('ITLPort');
      if n2 <> nil then
      begin
        FITLPort := StrToInt(Trim(n2.text));
      end;

      n2 := n1.selectSingleNode('PrinterComPort');
      if (n2 <> nil) then
      begin
        FPrinterComPort := StrToInt(Trim(n2.text));
      end;

      n2 := n1.selectSingleNode('KeyBoardComPort');
      if (n2 <> nil) then
      begin
        FKeyBoardComPort := StrToInt(Trim(n2.text));
      end;

    end;
  except
    on E: Exception do
    begin
    end;
  end;
end;

procedure TSystemParam.SaveToFile(const AFileName: string);
var
  x: TXMLDocument;
begin
  x := SaveToXML;
  x.SaveToFile(AFileName);
  x.Free;
end;

function TSystemParam.SaveToXML: TXMLDocument;
  procedure SetXMLBoolean(node: IXMLNode; Value: Boolean);
  begin
    if Value then
      node.Text := '1'
    else
      node.Text := '0';
  end;
var
  x: TXMLDocument;
  r: IXMLNode;
  n, n1, n2: IXMLNode;
  namespace: string;
  i: Integer;
begin
  namespace := '';
  x := TXMLDocument.Create(nil);
  x.Active := True;
  x.Encoding := 'gb2312';
  r := x.CreateElement('param', namespace);
  x.DocumentElement := r;
  n := x.CreateElement('remote', namespace);
  r.ChildNodes.Add(n);
  n1 := x.CreateElement('map', namespace);
  n.ChildNodes.Add(n1);


  Result := x;
end;

procedure TSystemParam.SetBusiness(const Value: TAddrssParam);
begin
  FBusiness := Value;
end;

procedure TSystemParam.SetBusinessBak(const Value: TAddrssParam);
begin
  FBusinessBak := Value;
end;

procedure TSystemParam.SetGateway(const Value: TAddrssParam);
begin
  FGateway := Value;
end;

procedure TSystemParam.SetGatewayBak(const Value: TAddrssParam);
begin
  FGatewayBak := Value;
end;


procedure TSystemParam.SetPosId(const Value: string);
begin
  FPosId := Value;
end;

procedure TSystemParam.SetSAMID(const Value: string);
begin
  FSAMID := Value;
end;

procedure TSystemParam.SetTerminalId(const Value: string);
begin
  FTerminalId := Value;
end;

procedure TSystemParam.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TSystemParam.SetUserPassword(const Value: string);
begin
  FUserPassword := Value;
end;

end.
