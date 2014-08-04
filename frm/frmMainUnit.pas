unit frmMainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, WallPaper, AdvNavBar, AdvSmoothButton,
  AdvSmoothToggleButton, AdvSmoothDock, AdvSmoothCalculator, Vcl.StdCtrls,
  AdvSmoothEdit, AdvSmoothEditButton, AdvSmoothCalculatorDropDown, W7Classes,
  W7Panels, W7NaviButtons, Vcl.Imaging.jpeg, W7Images, AdvGlassButton,
  Vcl.ExtCtrls, RzPanel, RzCommon, CurvyControls, RzLabel, AdvSmoothLabel,
  AdvGroupBox, dxGDIPlusClasses, RzBorder, Vcl.ImgList, AdvGlowButton,
  frmProgressUnit,
  Vcl.Grids, AdvObj, BaseGrid, AdvGrid, cxStyles, cxClasses, AdvEdit, RzButton,
  RzRadChk, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxRadioGroup, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  Data.Bind.Components, ThreadsUnit;

type
  TfrmMain = class(TForm)
    W7Image1: TW7Image;
    RzPanel1: TRzPanel;
    pnlClient: TRzPanel;
    pnlBottom: TRzPanel;
    pnlTop: TRzPanel;
    pnlTimeBar: TRzPanel;
    btnTime: TAdvSmoothButton;
    Timer1: TTimer;
    Notebook1: TNotebook;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    AdvSmoothLabel2: TAdvSmoothLabel;
    RzPanel4: TRzPanel;
    AdvSmoothLabel3: TAdvSmoothLabel;
    AdvSmoothLabel4: TAdvSmoothLabel;
    btnHome: TAdvGlowButton;
    Timer2: TTimer;
    lblCountdown: TAdvSmoothLabel;
    Timer3: TTimer;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    pnlSelectPhoneChargeAmount: TRzPanel;
    pnlSelectPayType: TRzPanel;
    rbBank: TRzRadioButton;
    rbCityCard: TRzRadioButton;
    AdvSmoothButton14: TAdvSmoothButton;
    pnlBankCardNo: TRzPanel;
    pnlBankCardPass: TRzPanel;
    pnlOtherCardNoAndAmount: TRzPanel;
    pnlCreditCardInfoConfirm: TRzPanel;
    pnlWaterElectricGas: TRzPanel;
    BindingsList1: TBindingsList;
    pnlElectricInfo: TRzPanel;
    pnlFeePaid: TRzPanel;
    pnlCityCardBizSelection: TRzPanel;
    pnlGetCityCardBalance: TRzPanel;
    AdvSmoothLabel53: TAdvSmoothLabel;
    pnlChooseCityCardChargeAmout: TRzPanel;
    pnlSelectCityCardType: TRzPanel;
    pnlGetIDCardInfo: TRzPanel;
    pnlChooseAmountForNewCard: TRzPanel;
    RzPanel69: TRzPanel;
    RzGroupBox2: TRzGroupBox;
    AdvSmoothLabel59: TAdvSmoothLabel;
    AdvSmoothButton36: TAdvSmoothButton;
    RzPanel70: TRzPanel;
    pnlSuccess: TRzPanel;
    Image38: TImage;
    RzPanel72: TRzPanel;
    AdvSmoothButton10: TAdvSmoothButton;
    AdvSmoothButton11: TAdvSmoothButton;
    AdvSmoothButton9: TAdvSmoothButton;
    AdvSmoothButton7: TAdvSmoothButton;
    RzPanel73: TRzPanel;
    AdvSmoothButton25: TAdvSmoothButton;
    AdvSmoothButton26: TAdvSmoothButton;
    AdvSmoothButton24: TAdvSmoothButton;
    RzPanel74: TRzPanel;
    AdvSmoothLabel52: TAdvSmoothLabel;
    AdvSmoothLabel51: TAdvSmoothLabel;
    edtCityCardBalance: TAdvEdit;
    edtCityCardInfo: TAdvEdit;
    AdvSmoothButton27: TAdvSmoothButton;
    RzPanel75: TRzPanel;
    RzPanel76: TRzPanel;
    edtCityCardInfoWhenChosingAmount: TAdvEdit;
    AdvSmoothLabel62: TAdvSmoothLabel;
    AdvSmoothLabel63: TAdvSmoothLabel;
    edtCityCardBalanceWhenChosingAmount: TAdvEdit;
    AdvSmoothButton35: TAdvSmoothButton;
    AdvSmoothButton34: TAdvSmoothButton;
    AdvSmoothButton33: TAdvSmoothButton;
    AdvSmoothLabel54: TAdvSmoothLabel;
    RzPanel77: TRzPanel;
    AdvSmoothLabel64: TAdvSmoothLabel;
    RzPanel78: TRzPanel;
    Image34: TImage;
    AdvSmoothLabel61: TAdvSmoothLabel;
    RzPanel79: TRzPanel;
    AdvEdit2: TAdvEdit;
    AdvSmoothButton15: TAdvSmoothButton;
    AdvSmoothLabel40: TAdvSmoothLabel;
    Timer4: TTimer;
    RzPanel80: TRzPanel;
    AdvEdit1: TAdvEdit;
    AdvSmoothButton16: TAdvSmoothButton;
    AdvSmoothLabel41: TAdvSmoothLabel;
    RzPanel81: TRzPanel;
    AdvSmoothButton17: TAdvSmoothButton;
    AdvEdit4: TAdvEdit;
    AdvSmoothLabel43: TAdvSmoothLabel;
    AdvEdit3: TAdvEdit;
    AdvSmoothLabel42: TAdvSmoothLabel;
    RzPanel82: TRzPanel;
    RzGroupBox1: TRzGroupBox;
    AdvSmoothLabel44: TAdvSmoothLabel;
    AdvSmoothLabel45: TAdvSmoothLabel;
    AdvEdit5: TAdvEdit;
    AdvSmoothButton18: TAdvSmoothButton;
    AdvEdit6: TAdvEdit;
    RzPanel83: TRzPanel;
    AdvSmoothButton19: TAdvSmoothButton;
    AdvSmoothButton21: TAdvSmoothButton;
    AdvSmoothButton20: TAdvSmoothButton;
    RzPanel84: TRzPanel;
    AdvEdit8: TAdvEdit;
    AdvSmoothButton22: TAdvSmoothButton;
    AdvSmoothLabel48: TAdvSmoothLabel;
    AdvEdit7: TAdvEdit;
    AdvSmoothLabel47: TAdvSmoothLabel;
    RzPanel85: TRzPanel;
    AdvEdit9: TAdvEdit;
    AdvSmoothButton23: TAdvSmoothButton;
    AdvSmoothLabel50: TAdvSmoothLabel;
    AdvSmoothLabel49: TAdvSmoothLabel;
    RzPanel86: TRzPanel;
    AdvSmoothButton30: TAdvSmoothButton;
    AdvSmoothButton29: TAdvSmoothButton;
    RzPanel87: TRzPanel;
    AdvEdit13: TAdvEdit;
    AdvSmoothButton31: TAdvSmoothButton;
    AdvEdit12: TAdvEdit;
    AdvSmoothLabel56: TAdvSmoothLabel;
    AdvSmoothLabel55: TAdvSmoothLabel;
    RzPanel88: TRzPanel;
    AdvSmoothLabel57: TAdvSmoothLabel;
    AdvSmoothButton32: TAdvSmoothButton;
    AdvSmoothLabel58: TAdvSmoothLabel;
    RzPanel89: TRzPanel;
    RzGroupBox3: TRzGroupBox;
    AdvSmoothLabel60: TAdvSmoothLabel;
    AdvSmoothButton37: TAdvSmoothButton;
    AdvSmoothButton38: TAdvSmoothButton;
    AdvSmoothLabel65: TAdvSmoothLabel;
    AdvSmoothLabel66: TAdvSmoothLabel;
    AdvSmoothLabel69: TAdvSmoothLabel;
    AdvSmoothButton28: TAdvSmoothButton;
    AdvSmoothButton39: TAdvSmoothButton;
    AdvSmoothLabel46: TAdvSmoothLabel;
    RzPanel90: TRzPanel;
    RzPanel91: TRzPanel;
    AdvSmoothLabel67: TAdvSmoothLabel;
    AdvSmoothLabel68: TAdvSmoothLabel;
    AdvSmoothLabel70: TAdvSmoothLabel;
    AdvEdit14: TAdvEdit;
    AdvEdit17: TAdvEdit;
    AdvSmoothButton40: TAdvSmoothButton;
    AdvEdit18: TAdvEdit;
    AdvSmoothLabel71: TAdvSmoothLabel;
    AdvSmoothLabel72: TAdvSmoothLabel;
    RzPanel92: TRzPanel;
    AdvSmoothLabel33: TAdvSmoothLabel;
    AdvSmoothLabel38: TAdvSmoothLabel;
    AdvSmoothButton13: TAdvSmoothButton;
    edtPhoneNo: TAdvEdit;
    AdvSmoothButton41: TAdvSmoothButton;
    AdvSmoothButton42: TAdvSmoothButton;
    AdvSmoothButton43: TAdvSmoothButton;
    AdvSmoothButton44: TAdvSmoothButton;
    RzPanel93: TRzPanel;
    RzPanel94: TRzPanel;
    AdvSmoothButton12: TAdvSmoothButton;
    AdvSmoothButton8: TAdvSmoothButton;
    AdvSmoothLabel73: TAdvSmoothLabel;
    AdvSmoothButton45: TAdvSmoothButton;
    AdvSmoothLabel74: TAdvSmoothLabel;
    RzPanel95: TRzPanel;
    AdvSmoothLabel39: TAdvSmoothLabel;
    btnPayBankCard: TAdvSmoothButton;
    btnPayCash: TAdvSmoothButton;
    btnPayCityCard: TAdvSmoothButton;
    AdvSmoothLabel75: TAdvSmoothLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AdvSmoothButton3Click(Sender: TObject);
    procedure btnNormalClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure Notebook1PageChanged(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure btnExpertClick(Sender: TObject);
    procedure btnCheckInPageCheckFeeClick(Sender: TObject);
    procedure btnRegisterOkClick(Sender: TObject);
    procedure AdvSmoothButton4Click(Sender: TObject);
    procedure btnPayInPageQueryFeeUnpaidClick(Sender: TObject);
    procedure AdvSmoothButton11Click(Sender: TObject);
    procedure AdvSmoothButton13Click(Sender: TObject);
    procedure AdvSmoothButton14Click(Sender: TObject);
    procedure AdvSmoothButton15Click(Sender: TObject);
    procedure AdvSmoothButton16Click(Sender: TObject);
    procedure AdvSmoothButton12Click(Sender: TObject);
    procedure AdvSmoothButton17Click(Sender: TObject);
    procedure AdvSmoothButton18Click(Sender: TObject);
    procedure AdvSmoothButton8Click(Sender: TObject);
    procedure AdvSmoothButton10Click(Sender: TObject);
    procedure AdvSmoothButton20Click(Sender: TObject);
    procedure AdvSmoothButton19Click(Sender: TObject);
    procedure AdvSmoothButton21Click(Sender: TObject);
    procedure AdvSmoothButton22Click(Sender: TObject);
    procedure AdvSmoothButton23Click(Sender: TObject);
    procedure AdvSmoothButton7Click(Sender: TObject);
    procedure AdvSmoothButton25Click(Sender: TObject);
    procedure AdvSmoothButton26Click(Sender: TObject);
    procedure AdvSmoothButton24Click(Sender: TObject);
    procedure AdvSmoothButton27Click(Sender: TObject);
    procedure AdvSmoothButton29Click(Sender: TObject);
    procedure AdvSmoothButton31Click(Sender: TObject);
    procedure AdvSmoothButton32Click(Sender: TObject);
    procedure btnPayCashClick(Sender: TObject);
    procedure AdvSmoothButton36Click(Sender: TObject);
    procedure AdvSmoothButton38Click(Sender: TObject);
    procedure AdvSmoothButton37Click(Sender: TObject);
    procedure RzPanel2Resize(Sender: TObject);
    procedure AdvSmoothButton33Click(Sender: TObject);
    procedure AdvSmoothButton34Click(Sender: TObject);
    procedure AdvSmoothButton35Click(Sender: TObject);
    procedure btnPayBankCardClick(Sender: TObject);
    procedure AdvSmoothButton28Click(Sender: TObject);
    procedure AdvSmoothButton30Click(Sender: TObject);
    procedure btnPayCityCardClick(Sender: TObject);
    procedure AdvSmoothButton40Click(Sender: TObject);
    procedure AdvSmoothButton41Click(Sender: TObject);
    procedure AdvSmoothButton42Click(Sender: TObject);
    procedure AdvSmoothButton44Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private declarations }
    FDlgProgress: TfrmProgress;

    overTime: Integer; // �趨�ĳ�ʱʱ������λ����
    FIsPosSet: Boolean; // ��������Ҫ��Ե���λ�õ��Ƿ��ѵ�����

    bankTransferType: Byte; // ����ת������  0:���ÿ�  1:��ǿ�
    publicFeeType: Byte; // �����ɷ����� 0:ˮ 1:�� 2:ú
    cityCardBizType: Byte; // ����ҵ������ 0:��ֵ 1:����ѯ

    WaitForCityCardTimerFlag: Byte; // 0:��ʼ  1���Ѷ�ȡ������Ϣ
    WaitForCashTimerFlag: Byte; // 0:��ʼ  1���Ѷ�ȡ
    WaitForInsertBankCardFlag: Byte; // 0:��ʼ  1���Ѷ�ȡ
    waitForBankCardPassFlag: Byte; // 0:  1:
    waitForBankCardSuccessFlag: Byte; // 0:  1:
    waitForCityCardBalanceFlag: Byte; // 0:  1:
    waitForIDCardReadFlag: Byte; // 0:  1:
//    waitForNewCardReadFlag: Byte; // 0:  1:
    WaitForCityCardWhenPayTimerFlag: Byte; //
    waitForInputPhoneNumberTimerFlag: Byte; //
    waitForInputBankCardNoTimerFlag: Byte; //
    waitForInputWEGTimerFlag: Byte;

    amountPaid: Double; // ��ֵ�ֽ���
    cityCardBalance: Double; // ���񿨳�ֵ��Ƭ���
    isCityCardCharging: Boolean;
    isNewCard: Boolean; // �Ƿ�쿨

    amountCharged: Integer;//���񿨳�ֵ���
    threadCharge: TCityCardCharge;

    isIgnoreMainTimeOut: Boolean;//�Ƿ����������ĵ���ʱ

    procedure initMain;
    procedure loadParam;
    procedure connectToGateway;
    function isCheckModuleStatusOk: Boolean;
    procedure testTimer(Sender: TObject);
    procedure WaitForCityCardTimer(Sender: TObject);
    procedure waitForCashTimer(Sender: TObject);
    procedure waitForInsertBankCard(Sender: TObject);
    procedure waitForBankCardPassTimer(Sender: TObject);
    procedure WaitForBankCardSuccessTimer(Sender: TObject);
    procedure waitForCityCardBalanceTimer(Sender: TObject);
    procedure waitForIDCardReadTimer(Sender: TObject);
    procedure WaitForCityCardWhenPayTimer(Sender: TObject);
    procedure waitForInputPhoneNumberTimer(Sender: TObject);
    procedure waitForInputBankCardNoTimer(Sender: TObject);
    procedure waitForInputWEGTimer(Sender: TObject); // ˮ��ú
    procedure waitForGetPubFeeTimer(Sender: TObject);

    procedure setCountdownTimerEnabled(isEnabled: Boolean;
      overTimeSeconds: Integer = 60);
    procedure setPanelInvisible;
    procedure iniForm;
    function initDev: Boolean;
    procedure setTimeInfo();
    procedure setPanelInitPos;
    procedure setCompentInParentCenter(comp: TWinControl);
    procedure setBtnPayTypeVisible(btnCityCardVisible: Boolean;
      btnBankCardVisible: Boolean; btnCashVisible: Boolean);
//    procedure setProgressInCenter;
    procedure setProgressInTop;
//    procedure setProgressTopPos(iTop: Integer);
    procedure setDlgProgressTransparent(isTransparent: Boolean);

    procedure DoOnGetCityCardInfo(edt: TCustomEdit; cardInfo: string);
    procedure DoOnGetCityCardBalance(edt: TCustomEdit; balance: Integer);

    procedure DoOnGetMac2(ret: Byte; mac2: AnsiString);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.DateUtils, uGloabVar, drv_unit, GatewayServerUnit, FrmWaitingUnit,
  CmdStructUnit;

{$R *.dfm}

function getWeekDay(weekDay: Integer): string;
begin
  case weekDay of
    1:
      Result := '����һ';
    2:
      Result := '���ڶ�';
    3:
      Result := '������';
    4:
      Result := '������';
    5:
      Result := '������';
    6:
      Result := '������';
  else
    Result := '������'
  end;
end;

procedure TfrmMain.AdvSmoothButton10Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pagePublicFee';
end;

procedure TfrmMain.AdvSmoothButton11Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageMobileTopUp';
  edtPhoneNo.Text := '1';
  AdvSmoothButton13.Enabled := False;
  AdvSmoothButton41.Enabled := False;
  AdvSmoothButton42.Enabled := False;
  Timer4.Interval := 400;
  Timer4.OnTimer := waitForInputPhoneNumberTimer;
  waitForInputPhoneNumberTimerFlag := 0;
  Timer4.Enabled := True;
end;

procedure TfrmMain.AdvSmoothButton12Click(Sender: TObject);
begin
  bankTransferType := 0;
  AdvEdit3.Text := '';
  AdvEdit4.Text := '';
  AdvSmoothButton17.Enabled := False;
  AdvSmoothLabel42.Caption.Text := '���������ÿ���:';
  AdvSmoothLabel43.Caption.Text := '�����뻹����:';
  Timer4.OnTimer := waitForInputBankCardNoTimer;
  Timer4.Interval := 200;
  Timer4.Enabled := True;

  Notebook1.ActivePage := 'pageBankCardTransfer';
end;

procedure TfrmMain.AdvSmoothButton13Click(Sender: TObject);
begin
  amountPaid := 50;
  setBtnPayTypeVisible(True, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton14Click(Sender: TObject);
begin
  if rbBank.Checked then
  begin
    Notebook1.ActivePage := 'pagePayTypeBank';
  end
  else if rbCityCard.Checked then
  begin
    Notebook1.ActivePage := 'pagePayTypeCityCard';
  end;
end;

procedure TfrmMain.AdvSmoothButton15Click(Sender: TObject);
begin
  AdvEdit1.Text := '';
  AdvSmoothButton16.Enabled := False;
  Notebook1.ActivePage := 'pageInputBankPassword';
  Timer4.OnTimer := waitForBankCardPassTimer;
  waitForBankCardPassFlag := 0;
  Timer4.Interval := 300;
  Timer4.Enabled := True;
end;

procedure TfrmMain.AdvSmoothButton16Click(Sender: TObject);
begin
  AdvSmoothButton16.Enabled := False;
  FDlgProgress.RzMemo1.Text := '���ڴ������п���������,���Ժ�...';
  setDlgProgressTransparent(True);
  FDlgProgress.Timer1.OnTimer := WaitForBankCardSuccessTimer;
  FDlgProgress.Timer1.Interval := 3000;
  FDlgProgress.Show;
  waitForBankCardSuccessFlag := 0;
end;

procedure TfrmMain.AdvSmoothButton17Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageCreditCardConfirm';
  AdvEdit6.Text := AdvEdit3.Text;
  AdvEdit5.Text := AdvEdit4.Text;
  if bankTransferType = 0 then
  begin
    RzGroupBox1.Caption := '���ÿ��������Ϣȷ��';
    AdvSmoothLabel44.Caption.Text := '���ÿ���:';
    AdvSmoothLabel45.Caption.Text := '������:';
  end
  else if bankTransferType = 1 then
  begin
    RzGroupBox1.Caption := '��ǿ�ת�ˡ�����Ϣȷ��';
    AdvSmoothLabel44.Caption.Text := '�Է�����:';
    AdvSmoothLabel45.Caption.Text := 'ת�˽��:';
  end;
end;

procedure TfrmMain.AdvSmoothButton18Click(Sender: TObject);
begin
  AdvEdit2.Text := '';
  Notebook1.ActivePage := 'pagePayTypeBank';
  WaitForInsertBankCardFlag := 0;
  Timer4.OnTimer := waitForInsertBankCard;
  Timer4.Interval := 1000;
  Timer4.Enabled := True;
end;

procedure TfrmMain.AdvSmoothButton19Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageInputWaterCardInfo';
  publicFeeType := 1;
  AdvEdit7.Text := '�����е�����˾';
  AdvSmoothLabel48.Caption.Text := '�翨���ţ�';
  AdvSmoothButton22.Enabled := False;
  AdvEdit8.Text := '';
  Timer4.OnTimer := waitForInputWEGTimer;
  Timer4.Interval := 300;
  Timer4.Enabled := True;
end;

procedure TfrmMain.AdvSmoothButton20Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageInputWaterCardInfo';
  publicFeeType := 0;
  AdvEdit7.Text := '����������ˮ��˾';
  AdvSmoothLabel48.Caption.Text := 'ˮ�����ţ�';
  AdvEdit8.Text := '';
  AdvSmoothButton22.Enabled := False;
  Timer4.OnTimer := waitForInputWEGTimer;
  Timer4.Interval := 300;
  Timer4.Enabled := True;
end;

procedure TfrmMain.AdvSmoothButton21Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageInputWaterCardInfo';
  publicFeeType := 2;
  AdvEdit7.Text := '�����С���ȼ����˾';
  AdvSmoothLabel48.Caption.Text := '�������ţ�';
  AdvSmoothButton22.Enabled := False;
  AdvEdit8.Text := '';
  Timer4.OnTimer := waitForInputWEGTimer;
  Timer4.Interval := 300;
  Timer4.Enabled := True;
end;

procedure TfrmMain.AdvSmoothButton22Click(Sender: TObject);
begin
  AdvEdit9.Text := '';
  AdvSmoothButton23.Enabled := False;
  Notebook1.ActivePage := 'pagePubliGetFee';
  FDlgProgress.RzMemo1.Text := '���ڻ�ȡӦ�ɽ����Ժ�...';
  FDlgProgress.Timer1.Interval := 2000;
  FDlgProgress.Timer1.OnTimer := waitForGetPubFeeTimer;
  setDlgProgressTransparent(True);
  setProgressInTop;
  FDlgProgress.Show;
end;

procedure TfrmMain.AdvSmoothButton23Click(Sender: TObject);
begin
  amountPaid := StrToFloat(AdvEdit9.Text);
  Notebook1.ActivePage := 'pageSelectPayType';
  Self.setBtnPayTypeVisible(True, True, False);
end;

procedure TfrmMain.AdvSmoothButton24Click(Sender: TObject);
begin
  isCityCardCharging := True;
  Notebook1.ActivePage := 'pageCityCardNewCard';
end;

procedure TfrmMain.AdvSmoothButton25Click(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
  threadQueryCityCard: TQueryCityCardBalance;
begin
  isCityCardCharging := True;
  edtCityCardInfoWhenChosingAmount.Text := '';
  edtCityCardBalanceWhenChosingAmount.Text := '';
  Notebook1.ActivePage := 'pageCityCardChooseChargeAmount';
  cityCardBizType := 0;
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip('�뽫���񿨷����ڶ�����...');
    threadQueryCityCard := TQueryCityCardBalance.Create(True, dlg, 15,
      edtCityCardInfoWhenChosingAmount, edtCityCardBalanceWhenChosingAmount);
    threadQueryCityCard.OnGetCityCardInfo := DoOnGetCityCardInfo;
    threadQueryCityCard.OnGetCardBalance := DoOnGetCityCardBalance;
    threadQueryCityCard.Resume;
    mr := dlg.ShowModal;
    if mr = mrAbort then
    begin
      btnhome.Click;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.AdvSmoothButton26Click(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
  threadQueryCityCard: TQueryCityCardBalance;
begin
  edtCityCardBalance.Text := '';
  edtCityCardInfo.Text := '';
  AdvSmoothButton27.Caption := '������ҳ';
  Notebook1.ActivePage := 'pageCityCardCharge';
  cityCardBizType := 1;
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip('�뽫���񿨷����ڶ�����...');
    threadQueryCityCard := TQueryCityCardBalance.Create(True, dlg, 15, edtCityCardInfo, edtCityCardBalance);
    threadQueryCityCard.OnGetCityCardInfo := DoOnGetCityCardInfo;
    threadQueryCityCard.OnGetCardBalance := DoOnGetCityCardBalance;
    threadQueryCityCard.Resume;
    mr := dlg.ShowModal;
    if mr = mrAbort then
    begin
      btnhome.Click;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.AdvSmoothButton27Click(Sender: TObject);
begin
  if AdvSmoothButton27.Caption = '����' then
  begin
//    AdvEdit11.Text := '������(��С�� 2837277273730230)';
//    AdvEdit10.Text := '10.5';
    if cityCardBizType = 0 then
    begin
      AdvSmoothButton27.Caption := '��һ��';
    end
    else if cityCardBizType = 1 then
    begin
      AdvSmoothButton27.Caption := '������ҳ';
    end;
  end
  else if AdvSmoothButton27.Caption = '��һ��' then
  begin
    Notebook1.ActivePage := 'pageCityCardChooseChargeAmount';
  end
  else if AdvSmoothButton27.Caption = '������ҳ' then
  begin
    Notebook1.ActivePage := 'Default';
  end;
end;

procedure TfrmMain.AdvSmoothButton28Click(Sender: TObject);
begin
  amountPaid := 50;
  cityCardBalance := amountPaid - StrToFloat(AdvSmoothLabel69.Caption.Text);
  Self.setBtnPayTypeVisible(False, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton29Click(Sender: TObject);
begin
  isNewCard := True;
  Timer4.Interval := 1200;
  Timer4.OnTimer := waitForIDCardReadTimer;
  AdvEdit12.Text := '';
  AdvEdit13.Text := '';
  AdvSmoothButton31.Caption := '��һ��';
  AdvSmoothButton31.Enabled := False;
  Notebook1.ActivePage := 'pageCityCardIDCard';
  Timer4.Enabled := True;
end;

procedure TfrmMain.AdvSmoothButton30Click(Sender: TObject);
begin
  isNewCard := True;
  AdvSmoothLabel69.Caption.Text := '30';
  AdvSmoothLabel65.Visible := False;
  AdvSmoothButton28.Caption := '20Ԫ';
  AdvSmoothButton32.Caption := '70Ԫ';
  Notebook1.ActivePage := 'pageCityCardAmountForNewCard';
end;

procedure TfrmMain.AdvSmoothButton31Click(Sender: TObject);
begin
  if AdvSmoothButton31.Caption = '����' then
  begin
    AdvEdit12.Text := '32088298712130288';
    AdvEdit13.Text := '��С��';
    AdvSmoothButton31.Caption := '��һ��'
  end
  else if AdvSmoothButton31.Caption = '��һ��' then
  begin
    AdvSmoothLabel69.Caption.Text := '20';
    AdvSmoothLabel65.Visible := True;
    AdvSmoothButton28.Caption := '30Ԫ';
    AdvSmoothButton32.Caption := '80Ԫ';
    Notebook1.ActivePage := 'pageCityCardAmountForNewCard';
  end;
end;

procedure TfrmMain.AdvSmoothButton32Click(Sender: TObject);
begin
  amountPaid := 100;
  cityCardBalance := amountPaid - StrToFloat(AdvSmoothLabel69.Caption.Text);
  Self.setBtnPayTypeVisible(False, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton33Click(Sender: TObject);
begin
//  amountPaid := 50;
//  cityCardBalance := amountPaid + 10.5;
  amountCharged := 50;
  setBtnPayTypeVisible(False, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton34Click(Sender: TObject);
begin
//  amountPaid := 100;
//  cityCardBalance := amountPaid + 10.5;
  amountCharged := 100;
  setBtnPayTypeVisible(False, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton35Click(Sender: TObject);
begin
//  amountPaid := 200;
//  cityCardBalance := amountPaid + 10.5;
  amountCharged := 200;
  setBtnPayTypeVisible(False, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.btnPayBankCardClick(Sender: TObject);
begin
  AdvEdit2.Text := '';
  Notebook1.ActivePage := 'pagePayTypeBank';
  WaitForInsertBankCardFlag := 0;
  Timer4.OnTimer := waitForInsertBankCard;
  Timer4.Interval := 1000;
  Timer4.Enabled := True;
end;

procedure TfrmMain.btnPayCashClick(Sender: TObject);
var
  dlg: TfrmWaiting;
  mr: TModalResult;
  newBalance: Double;
begin
  Notebook1.ActivePage := 'pageCash';
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip('�뽫���񿨷����ڶ�����...');
    TGetCashAmount.Create(False, dlg, 55, amountCharged);
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      setCountdownTimerEnabled(True, 15);
      threadCharge := TCityCardCharge.Create(True, dlg, 10, amountCharged);
      try
        threadCharge.Resume;
        mr := dlg.ShowModal;
        if mr = mrOk then
        begin
          AdvSmoothLabel75.Visible := False;
          newBalance := threadCharge.BalanceAfterCharge * 1.0/100;
          AdvSmoothLabel74.Caption.Text := '��ֵ��Ƭ��' + FormatFloat('0.0#', newBalance) + 'Ԫ';
          AdvSmoothLabel74.Visible := True;
          Notebook1.ActivePage := 'pageMobileTopUpSuccess';
        end
        else if mr = mrAbort then
        begin
          btnHome.Click;
        end;
      finally
        threadCharge.Free;
        threadCharge := nil;
      end;
    end
    else if mr = mrAbort then
    begin
      btnhome.Click;
    end

  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.btnPayCityCardClick(Sender: TObject);
begin
  AdvEdit18.Text := FloatToStr(amountPaid);
  AdvSmoothButton40.Enabled := False;

  AdvEdit14.Text := '';
  AdvEdit17.Text := '';
  Notebook1.ActivePage := 'pagePayFromCityCard';
  FDlgProgress.Timer1.Interval := 1000;
  FDlgProgress.Timer1.OnTimer := WaitForCityCardWhenPayTimer;
  FDlgProgress.RzMemo1.Text := '���ڶ�ȡ���񿨣����Ժ�...';
  setDlgProgressTransparent(True);
  setProgressInTop;
  WaitForCityCardWhenPayTimerFlag := 0;
  FDlgProgress.Show;
end;

procedure TfrmMain.AdvSmoothButton36Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageCashConfirm';
end;

procedure TfrmMain.AdvSmoothButton37Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'default';
end;

procedure TfrmMain.AdvSmoothButton38Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageMobileTopUpSuccess';
end;

procedure TfrmMain.AdvSmoothButton3Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageRegister';
end;

procedure TfrmMain.AdvSmoothButton40Click(Sender: TObject);
begin
  try
    cityCardBalance := StrToFloat(AdvEdit17.Text) - StrToFloat(AdvEdit18.Text);
    isCityCardCharging := True;
  except

  end;
  FDlgProgress.RzMemo1.Text := '���ڴ������񿨽�������,���Ժ�...';
  setDlgProgressTransparent(True);
  FDlgProgress.Timer1.OnTimer := WaitForBankCardSuccessTimer;
  FDlgProgress.Timer1.Interval := 3000;
  waitForBankCardSuccessFlag := 0;
  setDlgProgressTransparent(True);
  setProgressInTop;
  FDlgProgress.Show;
end;

procedure TfrmMain.AdvSmoothButton41Click(Sender: TObject);
begin
  amountPaid := 100;
  setBtnPayTypeVisible(True, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton42Click(Sender: TObject);
begin
  amountPaid := 200;
  setBtnPayTypeVisible(True, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton44Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageBankBiz';
end;

procedure TfrmMain.AdvSmoothButton4Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageSelfPay';
  setCountdownTimerEnabled(True, 120);
end;

procedure TfrmMain.AdvSmoothButton7Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageCityCard';
end;

procedure TfrmMain.AdvSmoothButton8Click(Sender: TObject);
begin
  bankTransferType := 1;
  AdvEdit3.Text := '';
  AdvEdit4.Text := '';
  AdvSmoothButton17.Enabled := False;
  AdvSmoothLabel42.Caption.Text := '������Է���ǿ���:';
  AdvSmoothLabel43.Caption.Text := '������ת�˽��:';
  Timer4.OnTimer := waitForInputBankCardNoTimer;
  Timer4.Interval := 200;
  Timer4.Enabled := True;

  Notebook1.ActivePage := 'pageBankCardTransfer';
end;

procedure TfrmMain.btnBackClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageRegister';
end;

procedure TfrmMain.btnCheckInPageCheckFeeClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageEndRegister';
  setCountdownTimerEnabled(True, 15);
end;

procedure TfrmMain.btnExpertClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageExpert';
end;

procedure TfrmMain.btnHomeClick(Sender: TObject);
begin
  if not pnlClient.Enabled then
    pnlClient.Enabled := True;

  isIgnoreMainTimeOut := False;
  Notebook1.ActivePage := 'default';
end;

procedure TfrmMain.btnNormalClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageNormal';
end;

procedure TfrmMain.btnPayInPageQueryFeeUnpaidClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageEndSelfPay';
  setCountdownTimerEnabled(True, 15);
end;

procedure TfrmMain.btnRegisterOkClick(Sender: TObject);
begin
  btnHome.Click;
end;

procedure TfrmMain.connectToGateway;
begin
  DataServer.Host := GlobalParam.Gateway.Host;
  DataServer.Port := GlobalParam.Gateway.Port;
  DataServer.Active := True;
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := 33554432; // 0x 02 00 00 00
end;

procedure TfrmMain.DoOnGetCityCardBalance(edt: TCustomEdit; balance: Integer);
begin
  edt.Text := FormatFloat('0.##', balance / 100.0) + 'Ԫ';
end;

procedure TfrmMain.DoOnGetCityCardInfo(edt: TCustomEdit; cardInfo: string);
begin
  edt.Text := cardInfo;
end;

procedure TfrmMain.DoOnGetMac2(ret: Byte; mac2: AnsiString);
begin
  if threadCharge <> nil then
  begin
    threadCharge.noticeMac2Got(mac2);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  setPanelInvisible;
  setTimeInfo;
  Self.DoubleBuffered := True;
  RzPanel1.DoubleBuffered := True;

  initMain;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  iniForm;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  i: Integer;
begin
  pnlBottom.SetFocus;
  for i := Notebook1.Pages.Count - 1 downto 0 do
    Notebook1.PageIndex := i;
  if not initDev then
  begin
    Close;
  end;
end;

procedure TfrmMain.iniForm;
begin
  if FIsPosSet then
    Exit;

  FIsPosSet := True;

  // *************����������ҳ�İ�ť������ʱ��ǩ��λ��
  btnHome.Left := pnlTop.Width - btnHome.Width - 15;
  btnHome.Top := pnlTop.Height - btnHome.Height - 5;
  lblCountdown.Left := pnlTop.Width - lblCountdown.Width - 30;
  lblCountdown.Top := btnHome.Top - lblCountdown.Height - 5;
  lblCountdown.Parent.DoubleBuffered := True;
  // *************����������ҳ�İ�ť������ʱ��ǩ��λ��

  // *************����ʱ���λ��ʹ����У������½���ʾ��˾��Ϣ
  btnTime.Left := (pnlTimeBar.Width - btnTime.Width) div 2;
  btnTime.Top := (pnlTimeBar.Height - btnTime.Height) div 2;
  // lblCompany.Left := pnlBottom.Width - lblCompany.Width - 30;
  // *************����ʱ���λ��ʹ����У������½���ʾ��˾��Ϣ

  setPanelInitPos;
end;

function TfrmMain.initDev: Boolean;
begin
  Result := False;
  icdev := dc_init(GlobalParam.D8ComPort, GlobalParam.D8BaudRate);
  if icdev < 0 then
  begin
    ShowMessage('���񿨶�������ʼ��ʧ��');
    Exit;
  end;
  //dc_beep(icdev, 15);

  Result := True;
end;

procedure TfrmMain.initMain;
begin
  loadParam;

  DataServer := TGateWayServerCom.Create;
  DataServer.OnGetMac2 := DoOnGetMac2;
  connectToGateway;
end;

function TfrmMain.isCheckModuleStatusOk: Boolean;
begin
  Result := False;
end;

procedure TfrmMain.loadParam;
begin
  GlobalParam.LoadFromFile('st.config');
end;

procedure TfrmMain.Notebook1PageChanged(Sender: TObject);
begin
  if Notebook1.ActivePage = 'Default' then
  begin
    pnlBottom.Visible := True;
    setCountdownTimerEnabled(False);
    AdvSmoothLabel74.Visible := False;
    isCityCardCharging := False;
    isNewCard := False;
  end
  else
  begin
    setCountdownTimerEnabled(True);
    pnlBottom.Visible := False;
  end;
  pnlTimeBar.SetFocus;
end;

procedure TfrmMain.RzPanel2Resize(Sender: TObject);
begin
  RzPanel72.Left := RzPanel2.Width - RzPanel72.Width - 40;
  RzPanel72.Top := (RzPanel2.Height - RzPanel72.Height) div 2;
end;

procedure TfrmMain.setTimeInfo();
var
  dt: TDateTime;
  d, t: string;
  weekDay: string;
  cap: string;
begin
  dt := Now;
  d := FormatDateTime('yyyy��MM��dd��', dt);
  t := FormatDateTime('hhʱmm��', dt);
  weekDay := getWeekDay(DayOfTheWeek(dt));
  cap := Format('���ã�������%s %s %s', [d, weekDay, t]);
  if btnTime.Caption <> cap then
  begin
    btnTime.Caption := cap;
  end;
end;

procedure TfrmMain.testTimer(Sender: TObject);
begin
  pnlClient.Enabled := True;
  FDlgProgress.Hide;
end;

procedure TfrmMain.setBtnPayTypeVisible(btnCityCardVisible, btnBankCardVisible,
  btnCashVisible: Boolean);
begin
  Self.btnPayCityCard.Visible := btnCityCardVisible;
  Self.btnPayBankCard.Visible := btnBankCardVisible;
  Self.btnPayCash.Visible := btnCashVisible;
end;

procedure TfrmMain.setCompentInParentCenter(comp: TWinControl);
begin
  comp.Left := (comp.Parent.Width - comp.Width) div 2;
  comp.Top := (comp.Parent.Height - comp.Height) div 2;
end;

procedure TfrmMain.setCountdownTimerEnabled(isEnabled: Boolean;
  overTimeSeconds: Integer);
begin
  btnHome.Visible := isEnabled;
  overTime := overTimeSeconds;
  lblCountdown.Visible := isEnabled;
  if lblCountdown.Visible then
  begin
    lblCountdown.Caption.Text := IntToStr(overTime);
  end;
  Timer2.Enabled := isEnabled;
end;

procedure TfrmMain.setDlgProgressTransparent(isTransparent: Boolean);
begin
  if (FDlgProgress <> nil) then
  begin
    if isTransparent then
    begin
      FDlgProgress.WindowState := wsNormal;
      FDlgProgress.TransparentColor := True;
    end
    else
    begin
      FDlgProgress.WindowState := wsMaximized;
      FDlgProgress.TransparentColor := False;
    end;
  end;
end;

procedure TfrmMain.setPanelInitPos;
begin
  setCompentInParentCenter(RzPanel73);
  setCompentInParentCenter(RzPanel74);
  setCompentInParentCenter(RzPanel75);
  setCompentInParentCenter(RzPanel76);
  setCompentInParentCenter(RzPanel77);
  setCompentInParentCenter(RzPanel78);
  setCompentInParentCenter(RzPanel79);
  setCompentInParentCenter(RzPanel80);
  setCompentInParentCenter(RzPanel81);
  setCompentInParentCenter(RzPanel82);
  setCompentInParentCenter(RzPanel83);
  setCompentInParentCenter(RzPanel84);
  setCompentInParentCenter(RzPanel85);
  setCompentInParentCenter(RzPanel86);
  setCompentInParentCenter(RzPanel87);
  setCompentInParentCenter(RzPanel88);
  setCompentInParentCenter(RzPanel89);
  setCompentInParentCenter(RzPanel91);
  setCompentInParentCenter(RzPanel92);
  setCompentInParentCenter(RzPanel94);
  setCompentInParentCenter(RzPanel95);
end;

procedure TfrmMain.setPanelInvisible;
begin
  pnlTop.Caption := '';
  pnlTop.BorderInner := fsNone;
  pnlBottom.Caption := '';
  pnlBottom.BorderInner := fsNone;
  pnlClient.Caption := '';
  pnlClient.BorderInner := fsNone;
end;

procedure TfrmMain.setProgressInTop;
begin
  if FDlgProgress <> nil then
  begin
    FDlgProgress.Top := pnlClient.Top;
    FDlgProgress.Left := (Screen.Width - FDlgProgress.Width) div 2;
  end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  setTimeInfo();
end;

procedure TfrmMain.Timer2Timer(Sender: TObject);
begin
  if (overTime <= 1) then
  begin
    overTime := 60;
    btnHome.Click;
  end
  else
  begin
    overTime := overTime - 1;
    lblCountdown.Caption.Text := IntToStr(overTime);
  end;
  if Notebook1.ActivePage = 'pageSelfPay' then
  begin
  end;
end;

//��ʱ�ϱ��ն˸�ģ���״̬
{
  ģ��1:���񿨶�дģ��
  ģ��2:�ֽ�ģ��
  ģ��3:����ģ��
  ģ��4:��ӡģ��
  ģ��5:���֤��ȡģ��
  ģ��6:�������ģ��
  ...   ...
  .ģ��n:xxxx

  ��ǰ�ȴ�ģ��1��2��4
}
procedure TfrmMain.Timer3Timer(Sender: TObject);
var
  moduleStatus: array of Byte;
begin
  if not isCheckModuleStatusOk then
    Exit;

  SetLength(moduleStatus, 3 * 2);
  moduleStatus[0] := $01;
  moduleStatus[1] := MODULE_STATUS_OK;
  moduleStatus[2] := $02;
  moduleStatus[3] := MODULE_STATUS_OK;
  moduleStatus[4] := $04;
  moduleStatus[5] := MODULE_STATUS_OK;
  DataServer.SendCmdUploadModuleStatus(moduleStatus);
end;

procedure TfrmMain.waitForBankCardPassTimer(Sender: TObject);
begin
  if waitForBankCardPassFlag = 0 then
  begin
    AdvEdit1.Text := AdvEdit1.Text + '2';
    if length(AdvEdit1.Text) = 6 then
      waitForBankCardPassFlag := 1;
  end
  else if waitForBankCardPassFlag = 1 then
  begin
    Timer4.Enabled := False;
    AdvSmoothButton16.Enabled := True;
    FDlgProgress.Hide;
    // Notebook1.ActivePage := 'pageMobileTopUpSuccess';
  end;
end;

procedure TfrmMain.WaitForBankCardSuccessTimer(Sender: TObject);
begin
  // if waitForBankCardSuccessFlag = 0 then
  // begin
  // waitForBankCardSuccessFlag := 1;
  // end
  // else if waitForBankCardSuccessFlag = 1 then
  // begin
  // FDlgProgress.Hide;
  // Timer4.Enabled := False;
  // Notebook1.ActivePage := 'pageMobileTopUpSuccess';
  // end;
  FDlgProgress.Hide;
  Timer4.Enabled := False;
  if isCityCardCharging then
  begin
    AdvSmoothLabel74.Visible := True;
    AdvSmoothLabel74.Caption.Text := '��Ƭ���:' +
      FloatToStr(cityCardBalance) + 'Ԫ';
  end;
  Notebook1.ActivePage := 'pageMobileTopUpSuccess';
end;

procedure TfrmMain.waitForCashTimer(Sender: TObject);
begin
  if WaitForCashTimerFlag = 0 then
  begin
    FDlgProgress.RzMemo1.Text := '�����踶���' + FloatToStr(amountPaid) + 'Ԫ' +
      #13#10 + '������Ͷ�ҽ�' + FloatToStr(amountPaid) + 'Ԫ';
    WaitForCashTimerFlag := 1;
  end
  else if WaitForCashTimerFlag = 1 then
  begin
    FDlgProgress.Hide;

    AdvSmoothLabel75.Visible := isNewCard;

    if isCityCardCharging then
    begin
      AdvSmoothLabel74.Caption.Text := '��Ƭ���:' +
        FloatToStr(Self.cityCardBalance) + 'Ԫ';
      AdvSmoothLabel74.Visible := True;
    end;
    Notebook1.ActivePage := 'pageMobileTopUpSuccess';
  end;
end;

procedure TfrmMain.waitForCityCardBalanceTimer(Sender: TObject);
begin
  if waitForCityCardBalanceFlag = 0 then
  begin
//    AdvEdit11.Text := '������(��С�� 2837277273730230)';
//    AdvEdit10.Text := '10.5';
    FDlgProgress.Hide;
  end;
end;

procedure TfrmMain.WaitForCityCardTimer(Sender: TObject);
begin
  if WaitForCityCardTimerFlag = 0 then
  begin
//    AdvEdit15.Text := '������(��С�� 2837277273730230)';
//    AdvEdit16.Text := '10.5';
    WaitForCityCardTimerFlag := 1;
  end
  else if WaitForCityCardTimerFlag = 1 then
  begin
    FDlgProgress.Hide;
  end;
end;

procedure TfrmMain.WaitForCityCardWhenPayTimer(Sender: TObject);
begin
  if WaitForCityCardWhenPayTimerFlag = 0 then
  begin
    AdvEdit14.Text := '������(��С�� 2837277273730230)';
    AdvEdit17.Text := '207.8';
    WaitForCityCardWhenPayTimerFlag := 1;
  end
  else if WaitForCityCardWhenPayTimerFlag = 1 then
  begin
    AdvSmoothButton40.Enabled := True;
    FDlgProgress.Hide;
  end;
end;

procedure TfrmMain.waitForGetPubFeeTimer(Sender: TObject);
begin
  AdvEdit9.Text := '130.8';
  AdvSmoothButton23.Enabled := True;
  FDlgProgress.Hide;
end;

procedure TfrmMain.waitForIDCardReadTimer(Sender: TObject);
begin
  if waitForIDCardReadFlag = 0 then
  begin
    FDlgProgress.RzMemo1.Text := '���ڶ�ȡ���֤��Ϣ�����Ժ�...';
    setProgressInTop;
    setDlgProgressTransparent(True);
    FDlgProgress.Show;
    waitForIDCardReadFlag := 1;
  end
  else if waitForIDCardReadFlag = 1 then
  begin
    AdvEdit12.Text := '32088298712130288';
    AdvEdit13.Text := '��С��';
    FDlgProgress.Hide;
    Timer4.Enabled := False;
    AdvSmoothButton31.Enabled := True;
  end;
end;

procedure TfrmMain.waitForInputBankCardNoTimer(Sender: TObject);
const
  cardNo: array [0 .. 18] of char = ('4', '3', '9', '2', ' ', '4', '5', '3',
    '2', ' ', '7', '8', '9', '6', ' ', '2', '9', '4', '8');
  amount: array [0 .. 2] of char = ('8', '0', '0');
begin
  if waitForInputBankCardNoTimerFlag = 0 then
  begin
    if length(AdvEdit3.Text) < length(cardNo) then
    begin
      AdvEdit3.Text := AdvEdit3.Text + cardNo[length(AdvEdit3.Text)];
    end
    else if length(AdvEdit4.Text) < length(amount) then
    begin
      AdvEdit4.Text := AdvEdit4.Text + amount[length(AdvEdit4.Text)];
    end
    else
    begin
      Timer4.Enabled := False;
      AdvSmoothButton17.Enabled := True;
    end;
    // end
    // else if waitForInputBankCardNoTimerFlag = 1 then
    // begin

  end;

end;

procedure TfrmMain.waitForInputPhoneNumberTimer(Sender: TObject);
const
  phoneNo: array [0 .. 10] of char = ('1', '8', '6', '5', '2', '3', '3', '6',
    '7', '9', '8');
var
  len: Integer;

begin
  if waitForInputPhoneNumberTimerFlag = 0 then
  begin // 18628764523
    len := length(edtPhoneNo.Text);
    if len < 11 then
    begin
      edtPhoneNo.Text := edtPhoneNo.Text + phoneNo[len];
      len := len + 1;
    end;
    if len >= 11 then
    begin
      waitForInputPhoneNumberTimerFlag := 1;
    end;
  end
  else if waitForInputPhoneNumberTimerFlag = 1 then
  begin
    AdvSmoothButton13.Enabled := True;
    AdvSmoothButton41.Enabled := True;
    AdvSmoothButton42.Enabled := True;
  end;
end;

procedure TfrmMain.waitForInputWEGTimer(Sender: TObject);
const
  cardNo: array [0 .. 9] of char = ('0', '4', '2', '3', '8', '7', '4', '5',
    '1', '9');
begin
  if waitForInputWEGTimerFlag = 0 then
  begin
    if length(AdvEdit8.Text) < length(cardNo) then
    begin
      AdvEdit8.Text := AdvEdit8.Text + cardNo[length(AdvEdit8.Text)];
    end
    else
    begin
      Timer4.Enabled := False;
      AdvSmoothButton22.Enabled := True;
    end;
  end;
end;

procedure TfrmMain.waitForInsertBankCard(Sender: TObject);
begin
  if WaitForInsertBankCardFlag = 0 then
  begin
    AdvEdit2.Text := '6226 0229 3456 7892';
    WaitForInsertBankCardFlag := 1;
  end
  else if WaitForInsertBankCardFlag = 1 then
  begin
    Timer4.Enabled := False;
    AdvSmoothButton15.Click;
  end;
end;

end.
