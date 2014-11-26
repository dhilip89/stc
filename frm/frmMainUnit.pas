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
  Data.Bind.Components, ThreadsUnit, FrmWaitingUnit, AsgListb, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, Vcl.ComCtrls, cxTreeView,
  cxContainer, cxEdit, cxListBox, RzListVw, RzBmpBtn;

type
  TfrmMain = class(TForm)
    backgroudSub: TW7Image;
    RzPanel1: TRzPanel;
    pnlClient: TRzPanel;
    pnlBottom: TRzPanel;
    pnlTop: TRzPanel;
    pnlTimeBar: TRzPanel;
    xbtnTime: TAdvSmoothButton;
    Timer1: TTimer;
    Notebook1: TNotebook;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    AdvSmoothLabel1: TAdvSmoothLabel;
    AdvSmoothLabel2: TAdvSmoothLabel;
    RzPanel4: TRzPanel;
    AdvSmoothLabel3: TAdvSmoothLabel;
    AdvSmoothLabel4: TAdvSmoothLabel;
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
    RzPanel70: TRzPanel;
    pnlSuccess: TRzPanel;
    RzPanel73: TRzPanel;
    xbtnCityCardCharge: TAdvSmoothButton;
    AdvSmoothButton24: TAdvSmoothButton;
    RzPanel74: TRzPanel;
    RzPanel75: TRzPanel;
    RzPanel76: TRzPanel;
    xbtnCashCharge200: TAdvSmoothButton;
    xbtnCashCharge100: TAdvSmoothButton;
    xbtnCashCharge50: TAdvSmoothButton;
    AdvSmoothLabel54: TAdvSmoothLabel;
    RzPanel77: TRzPanel;
    RzPanel78: TRzPanel;
    Image34: TImage;
    AdvSmoothLabel61: TAdvSmoothLabel;
    RzPanel79: TRzPanel;
    AdvEdit2: TAdvEdit;
    AdvSmoothButton15: TAdvSmoothButton;
    AdvSmoothLabel40: TAdvSmoothLabel;
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
    RzPanel93: TRzPanel;
    RzPanel94: TRzPanel;
    AdvSmoothButton12: TAdvSmoothButton;
    AdvSmoothButton8: TAdvSmoothButton;
    AdvSmoothLabel74: TAdvSmoothLabel;
    RzPanel95: TRzPanel;
    AdvSmoothLabel39: TAdvSmoothLabel;
    AdvSmoothLabel75: TAdvSmoothLabel;
    RzPanel5: TRzPanel;
    btnPayCityCard: TAdvSmoothButton;
    borderRight: TRzBorder;
    border4: TRzBorder;
    btnChargeCard: TAdvSmoothButton;
    borderLeft: TRzBorder;
    border1: TRzBorder;
    border2: TRzBorder;
    btnPayBankCard: TAdvSmoothButton;
    btnPayCash: TAdvSmoothButton;
    btnQFTCard: TAdvSmoothButton;
    border3: TRzBorder;
    RzBorder7: TRzBorder;
    pnlPasswordForChargeCard: TRzPanel;
    RzPanel6: TRzPanel;
    lblPassword4ChargeCardOrQFT: TAdvSmoothLabel;
    edtPasswordForChargeCard: TAdvEdit;
    btnPasswordOK: TAdvSmoothButton;
    RzPanel7: TRzPanel;
    xbtnCityCardQuery: TAdvSmoothButton;
    xbtnModifyZHBPassword: TAdvSmoothButton;
    pnlSelectChargeType: TRzPanel;
    RzPanel8: TRzPanel;
    btnCashCharge: TAdvSmoothButton;
    btnPrepaidCardCharge: TAdvSmoothButton;
    btnZHBCharge: TAdvSmoothButton;
    pnlInputPrepaidCardPassword: TRzPanel;
    RzPanel9: TRzPanel;
    AdvSmoothLabel5: TAdvSmoothLabel;
    edtPrepaidCardPassword: TAdvEdit;
    btnInputPrepaidCardPasswordOk: TAdvSmoothButton;
    pnlPrepaidCardAmountConfirm: TRzPanel;
    RzPanel11: TRzPanel;
    AdvSmoothLabel6: TAdvSmoothLabel;
    AdvSmoothLabel7: TAdvSmoothLabel;
    lblCityCardBalanceOnPnlPrepaidCard: TAdvSmoothLabel;
    lblPrepaidCardAmount: TAdvSmoothLabel;
    btnPrepaidCardAmountConfirm: TAdvSmoothButton;
    pnlInputZHBPassword: TRzPanel;
    RzPanel12: TRzPanel;
    AdvSmoothLabel10: TAdvSmoothLabel;
    edtZHBPassword: TAdvEdit;
    btnZHBPasswordOk: TAdvSmoothButton;
    pnlZHBBalanceConfirm: TRzPanel;
    RzPanel10: TRzPanel;
    AdvSmoothLabel11: TAdvSmoothLabel;
    AdvSmoothLabel12: TAdvSmoothLabel;
    lblCityCardBalanceOnPnlZHB: TAdvSmoothLabel;
    lblZHBBalance: TAdvSmoothLabel;
    AdvSmoothLabel15: TAdvSmoothLabel;
    btnZHBCharge50: TAdvSmoothButton;
    btnZHBCharge100: TAdvSmoothButton;
    btnZHBCharge200: TAdvSmoothButton;
    btnZHBCharge30: TAdvSmoothButton;
    btnZHBChargeAllBalance: TAdvSmoothButton;
    AdvSmoothLabel8: TAdvSmoothLabel;
    AdvSmoothButton3: TAdvSmoothButton;
    AdvSmoothButton4: TAdvSmoothButton;
    pnlQueryBiz: TRzPanel;
    RzPanel13: TRzPanel;
    btnCityCardBalanceQuery: TAdvSmoothButton;
    btnCityCardDetailQuery: TAdvSmoothButton;
    btnZHBBalanceQuery: TAdvSmoothButton;
    pnlModifyZHBPass: TRzPanel;
    pnlCityCardTransDetail: TRzPanel;
    RzPanel16: TRzPanel;
    cxStyle3: TcxStyle;
    gridCityCardTransDetail: TAdvStringGrid;
    AdvSmoothLabel9: TAdvSmoothLabel;
    RzPanel14: TRzPanel;
    AdvSmoothLabel13: TAdvSmoothLabel;
    edtOldPass: TAdvEdit;
    RzBorder1: TRzBorder;
    AdvSmoothLabel14: TAdvSmoothLabel;
    edtNewPass1: TAdvEdit;
    RzBorder2: TRzBorder;
    AdvSmoothLabel16: TAdvSmoothLabel;
    edtNewPass2: TAdvEdit;
    btnModifyZHBPassConfirm: TAdvSmoothButton;
    pnlZHBBalance: TRzPanel;
    RzPanel15: TRzPanel;
    lblBalance: TAdvSmoothLabel;
    AdvSmoothButton1: TAdvSmoothButton;
    AdvSmoothButton2: TAdvSmoothButton;
    pnlModifyZHBPassSucc: TRzPanel;
    RzPanel17: TRzPanel;
    Image1: TImage;
    lblModifyZHBPassSucc: TAdvSmoothLabel;
    AdvSmoothButton25: TAdvSmoothButton;
    AdvSmoothButton33: TAdvSmoothButton;
    lblCityCardBalanceOnPanelCashCharge: TAdvSmoothLabel;
    lblCityCardBalance: TAdvSmoothLabel;
    lblCityCardNo: TAdvSmoothLabel;
    RzPanel18: TRzPanel;
    pnlMainBtn: TRzPanel;
    xbtn2: TAdvSmoothButton;
    xbtn4: TAdvSmoothButton;
    xbtn6: TAdvSmoothButton;
    xbtn1: TAdvSmoothButton;
    xbtn5: TAdvSmoothButton;
    xbtn3: TAdvSmoothButton;
    btnLoginStatus: TAdvGlowButton;
    btn5: TImage;
    btn3: TImage;
    btn1: TImage;
    btn4: TImage;
    btn2: TImage;
    btn6: TImage;
    btnTime: TAdvSmoothLabel;
    btnCityCardCharge: TImage;
    btnModifyZHBPassword: TImage;
    btnCityCardQuery: TImage;
    backgroudMain: TW7Image;
    btnCashCharge50: TImage;
    btnCashCharge100: TImage;
    btnCashCharge200: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image12: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    kbReadTimer: TTimer;
    Image30: TImage;
    Image31: TImage;
    Image32: TImage;
    AdvSmoothLabel17: TAdvSmoothLabel;
    btnHome: TAdvGlowButton;
    btnPrevious: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnNormalClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure Notebook1PageChanged(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure btnExpertClick(Sender: TObject);
    procedure btnCheckInPageCheckFeeClick(Sender: TObject);
    procedure btnRegisterOkClick(Sender: TObject);
    procedure btnPrepaidCardChargeClick(Sender: TObject);
    procedure btnPayInPageQueryFeeUnpaidClick(Sender: TObject);
    procedure xbtn4Click(Sender: TObject);
    procedure AdvSmoothButton13Click(Sender: TObject);
    procedure AdvSmoothButton14Click(Sender: TObject);
    procedure AdvSmoothButton15Click(Sender: TObject);
    procedure AdvSmoothButton16Click(Sender: TObject);
    procedure AdvSmoothButton12Click(Sender: TObject);
    procedure AdvSmoothButton17Click(Sender: TObject);
    procedure AdvSmoothButton18Click(Sender: TObject);
    procedure AdvSmoothButton8Click(Sender: TObject);
    procedure xbtn2Click(Sender: TObject);
    procedure AdvSmoothButton20Click(Sender: TObject);
    procedure AdvSmoothButton19Click(Sender: TObject);
    procedure AdvSmoothButton21Click(Sender: TObject);
    procedure AdvSmoothButton22Click(Sender: TObject);
    procedure AdvSmoothButton23Click(Sender: TObject);
    procedure xbtn1Click(Sender: TObject);
    procedure xbtnCityCardChargeClick(Sender: TObject);
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
    procedure xbtnCashCharge50Click(Sender: TObject);
    procedure xbtnCashCharge100Click(Sender: TObject);
    procedure xbtnCashCharge200Click(Sender: TObject);
    procedure btnPayBankCardClick(Sender: TObject);
    procedure AdvSmoothButton28Click(Sender: TObject);
    procedure AdvSmoothButton30Click(Sender: TObject);
    procedure btnPayCityCardClick(Sender: TObject);
    procedure AdvSmoothButton40Click(Sender: TObject);
    procedure AdvSmoothButton41Click(Sender: TObject);
    procedure AdvSmoothButton42Click(Sender: TObject);
    procedure xbtn3Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQFTCardClick(Sender: TObject);
    procedure btnChargeCardClick(Sender: TObject);
    procedure btnPasswordOKClick(Sender: TObject);
    procedure edtPasswordForChargeCardKeyPress(Sender: TObject; var Key: Char);
    procedure edtPasswordForChargeCardKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzPanel7Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RzPanel7DblClick(Sender: TObject);
    procedure btnCashChargeClick(Sender: TObject);
    procedure btnZHBChargeClick(Sender: TObject);
    procedure edtPrepaidCardPasswordKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnInputPrepaidCardPasswordOkClick(Sender: TObject);
    procedure btnPrepaidCardAmountConfirmClick(Sender: TObject);
    procedure btnZHBPasswordOkClick(Sender: TObject);
    procedure edtZHBPasswordKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnZHBChargeAllBalanceClick(Sender: TObject);
    procedure btnZHBCharge100Click(Sender: TObject);
    procedure btnZHBCharge200Click(Sender: TObject);
    procedure btnZHBCharge30Click(Sender: TObject);
    procedure btnZHBCharge50Click(Sender: TObject);
    procedure AdvSmoothButton39Click(Sender: TObject);
    procedure AdvSmoothButton4Click(Sender: TObject);
    procedure xbtnCityCardQueryClick(Sender: TObject);
    procedure btnCityCardDetailQueryClick(Sender: TObject);
    procedure xbtnModifyZHBPasswordClick(Sender: TObject);
    procedure edtOldPassKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnModifyZHBPassConfirmClick(Sender: TObject);
    procedure btnZHBBalanceQueryClick(Sender: TObject);
    procedure AdvSmoothButton3Click(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnCityCardBalanceQueryClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure kbReadTimerTimer(Sender: TObject);
    procedure edtZHBPasswordExit(Sender: TObject);
    procedure edtOldPassExit(Sender: TObject);
    procedure edtNewPass1Exit(Sender: TObject);
    procedure edtNewPass2Exit(Sender: TObject);
    procedure edtPhoneNoClick(Sender: TObject);
    procedure edtPhoneNoExit(Sender: TObject);
    procedure edtPrepaidCardPasswordExit(Sender: TObject);
    procedure edtPasswordForChargeCardEnter(Sender: TObject);
    procedure edtPrepaidCardPasswordEnter(Sender: TObject);
    procedure edtZHBPasswordEnter(Sender: TObject);
    procedure edtOldPassEnter(Sender: TObject);
    procedure edtNewPass2Enter(Sender: TObject);
    procedure edtNewPass1Enter(Sender: TObject);
    procedure Image6Click(Sender: TObject);
  private
    { Private declarations }
    FDlgProgress: TfrmProgress;

    overTime: Integer; // 设定的超时时长，单位：秒
    FIsPosSet: Boolean; // 界面上需要相对调整位置的是否已调整过
    FIsPnlPosSet: Boolean;//各个子界面的按钮是否调整了

    bankTransferType: Byte; // 银行转账类型  0:信用卡  1:借记卡
    publicFeeType: Byte; // 公共缴费类型 0:水 1:电 2:煤
    cityCardBizType: Byte; // 市民卡业务类型 0:充值 1:余额查询

    amountPaid: Double; // 充值现金金额
    cityCardBalance: Double; // 市民卡充值后卡片余额
    isCityCardCharging: Boolean;
    isNewCard: Boolean; // 是否办卡

    threadQueryCityCardBalance: TQueryCityCardBalance;
    threadCharge: TCityCardCharge;
    threadChargeCardCheck: TChargeCardCheck;
    threadQueryQFTBalance: TQueryZHBBalance;
    threadModifyZHBPass: TModifyZHBPass;

    clickCount: Integer;
    firstTime: TDateTime;

    queryZHBBalanceFlag: Byte;//查询账户宝余额标识  1:单纯查询余额  2:充值时查询余额
    queryCityCardBalanceFlag: Byte;//查询市民卡余额标识  1:纯查余额信息  2:现金充值时查询余额信息

    pageHistory: array[0..19] of string;
    currPageIndex: Integer;
    isPreviousOperation: Boolean;

    currInputEdit: TAdvEdit;
    componentOK: TControl;

    FPauseServiceFrm: TfrmWaiting;

    procedure initMain;
    procedure loadParam;
    procedure connectToGateway;
    function isCheckModuleStatusOk: Boolean;//当下是否可以检测模块状态，防止检测过程中数据冲突
    function getD8Status: Byte;
    function getBillAcceptorStatus: Byte;
    function getPrinterStatus: Byte;
    function getKeyboardStatus: Byte;
    procedure initPnlPassword4ChargeCard(flag: Byte; maxLength: Integer);//flag 0:充值卡 1:账户宝
    procedure backToMainFrame;//回到主界面
    procedure clearDefaultTip;
    procedure doCityCardCharge(dlg: TfrmWaiting);
    procedure DoOnPayCash();
    procedure setBtnZHBBalanceChargeEnabled;
    procedure clearCityCardTransDetailGrid;
    procedure addCityCardTransDetailToGrid(transDate, transTime, transTerminalId: ansistring;
                                      transType, transAmount: Integer);

    procedure resetPageHistory;
    procedure setCountdownTimerEnabled(isEnabled: Boolean;
      overTimeSeconds: Integer = 60);
    procedure setPanelInvisible;
    procedure iniForm;
    procedure initDev;
    function initD8: Boolean;
    function initBillAcceptor: Boolean;
    function initPrinter: Boolean;
    function initKeyBoard: Boolean;
    procedure setTimeInfo();
    procedure setPanelInitPos;
    procedure resetMainBtnPos;//初始化主界面上的按钮位置
    procedure resetCityCardBizBtnPos;//初始化市民卡业务上的按钮位置
    procedure resetBackgroudImg;//重设背景图
    procedure setCompentInParentCenter(comp: TWinControl);
    procedure setBtnPayTypeVisible(btnCityCardVisible,btnBankCardVisible,
      btnCashVisible, btnChargeCardVisible, btnQFTCardVisible: Boolean);
//    procedure setProgressInCenter;
    procedure setProgressInTop;
//    procedure setProgressTopPos(iTop: Integer);
    procedure setDlgProgressTransparent(isTransparent: Boolean);

    procedure initThreads;

    procedure DoOnGetCityCardInfo(cardInfo: string);
    procedure DoOnGetCityCardBalance(balance: Integer);

    procedure DoOnLoginStatusChanged(loginStatus: Byte);
    procedure DoOnGetMac2(ret: Byte; mac2, tranSNo, errTip: AnsiString);
    procedure DoOnChargeCardCheckRsp(ret: Byte; amount: Integer);
    procedure DoOnQueryQFTBalanceRsp(ret: Byte; balance: Integer);
    procedure DoOnModifyZHBPassRsp(ret: Byte);
    procedure DoOnGetCityCardType(ret: Byte);

    procedure DoOnPrinterComRecvData(Sender:TObject;Buffer:Pointer;BufferLength:Word);

    function isTotalAmountOverMax(currBalance, chargeAmount: Integer): Boolean;

    procedure DoOnAppException(Sender: TObject; E: Exception);
    procedure doOnFunctionNotReleased;
    procedure DoOnClickTopLeftToQuit;
    procedure showOutOfServiceFrm(isFrmVisible: Boolean; status: Byte = 0);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure setKBReaderOutput(advEdit: TAdvEdit; compOK: TControl = nil);
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.DateUtils, uGloabVar, drv_unit, GatewayServerUnit,
  CmdStructUnit, itlssp, ConstDefineUnit, keyboard, FrmCloseConfirmUnit;

{$R *.dfm}

function getWeekDay(weekDay: Integer): string;
begin
  case weekDay of
    1:
      Result := '星期一';
    2:
      Result := '星期二';
    3:
      Result := '星期三';
    4:
      Result := '星期四';
    5:
      Result := '星期五';
    6:
      Result := '星期六';
  else
    Result := '星期日'
  end;
end;

  procedure setBtnLeftTop(btn: TAdvSmoothButton; x, y: Integer);overload;
  begin
    btn.Left := x;
    btn.Top := y;
  end;
  procedure setBtnLeftTop(btn: TImage; x, y: Integer);overload;
  begin
    btn.Left := x;
    btn.Top := y;
  end;

procedure TfrmMain.addCityCardTransDetailToGrid(transDate, transTime,
  transTerminalId: ansistring; transType, transAmount: Integer);
  function getTransType(transType: Integer): string;
  begin
    case transType of
      2: Result := '圈存';
      6: Result := '消费';
    else
      Result := '其他[' + IntToHex(transType, 2) + ']';
    end;
  end;
var
  i: Integer;
  tempStr: AnsiString;
begin
  if Notebook1.ActivePage <> 'pageCityCardTransDetail' then
  begin
    Notebook1.ActivePage := 'pageCityCardTransDetail';
  end;

  with gridCityCardTransDetail do
  begin
    if (RowCount = 2) and (Cells[0, 1] = '') then
    begin
      i := 1;
    end
    else
    begin
      RowCount := RowCount + 1;
      i := RowCount - 1;
    end;


    tempStr := Copy(transDate, 1, 4) + '-' + Copy(transDate, 5, 2) + '-' + Copy(transDate, 7, 2);
    Cells[0, i] := tempStr;

    tempStr := Copy(transTime, 1, 2) + ':' + Copy(transTime, 3, 2) + ':' + Copy(transTime, 5, 2);
    Cells[1, i] := tempStr;

    Cells[2, i] := getTransType(transType);
    Cells[3, i] := FormatFloat('0.00', transAmount * 1.0/100) + '元';
    Cells[4, i] := transTerminalId;
  end;
  gridCityCardTransDetail.SelectRows(i, 1);;
end;

procedure TfrmMain.xbtn2Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pagePublicFee';
end;

procedure TfrmMain.xbtn4Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageMobileTopUp';
  edtPhoneNo.Text := '1';
  AdvSmoothButton13.Enabled := False;
  AdvSmoothButton41.Enabled := False;
  AdvSmoothButton42.Enabled := False;
end;

procedure TfrmMain.AdvSmoothButton12Click(Sender: TObject);
begin
  bankTransferType := 0;
  AdvEdit3.Text := '';
  AdvEdit4.Text := '';
  AdvSmoothButton17.Enabled := False;
  AdvSmoothLabel42.Caption.Text := '请输入信用卡号:';
  AdvSmoothLabel43.Caption.Text := '请输入还款金额:';
  Notebook1.ActivePage := 'pageBankCardTransfer';
end;

procedure TfrmMain.AdvSmoothButton13Click(Sender: TObject);
begin
  amountPaid := 50;
  //setBtnPayTypeVisible(True, True, True);
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
end;

procedure TfrmMain.AdvSmoothButton16Click(Sender: TObject);
begin
  AdvSmoothButton16.Enabled := False;
  FDlgProgress.RzMemo1.Text := '正在处理银行卡交易请求,请稍后...';
  setDlgProgressTransparent(True);
  FDlgProgress.Timer1.Interval := 3000;
  FDlgProgress.Show;
end;

procedure TfrmMain.AdvSmoothButton17Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageCreditCardConfirm';
  AdvEdit6.Text := AdvEdit3.Text;
  AdvEdit5.Text := AdvEdit4.Text;
  if bankTransferType = 0 then
  begin
    RzGroupBox1.Caption := '信用卡还款——信息确认';
    AdvSmoothLabel44.Caption.Text := '信用卡号:';
    AdvSmoothLabel45.Caption.Text := '还款金额:';
  end
  else if bankTransferType = 1 then
  begin
    RzGroupBox1.Caption := '借记卡转账——信息确认';
    AdvSmoothLabel44.Caption.Text := '对方卡号:';
    AdvSmoothLabel45.Caption.Text := '转账金额:';
  end;
end;

procedure TfrmMain.AdvSmoothButton18Click(Sender: TObject);
begin
  AdvEdit2.Text := '';
  Notebook1.ActivePage := 'pagePayTypeBank';
end;

procedure TfrmMain.AdvSmoothButton19Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageInputWaterCardInfo';
  publicFeeType := 1;
  AdvEdit7.Text := '××市电力公司';
  AdvSmoothLabel48.Caption.Text := '电卡户号：';
  AdvSmoothButton22.Enabled := False;
  AdvEdit8.Text := '';
end;

procedure TfrmMain.xbtnCityCardQueryClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageQueryBiz';
end;

procedure TfrmMain.btnPasswordOKClick(Sender: TObject);
var
  dlg: TfrmWaiting;
  mr: TModalResult;
begin
  dlg := TfrmWaiting.Create(nil);
  try
    if currChargeType = 2 then
    begin
      dlg.setWaitingTip(TIP_CHECKING_PREPAID_CARD);
      threadChargeCardCheck := TChargeCardCheck.Create(True, dlg, 10, currCityCardNo, Trim(edtPasswordForChargeCard.Text));
      threadChargeCardCheck.start;
      try
        mr := dlg.ShowModal;
        if mr = mrOk then
        begin
          doCityCardCharge(dlg);
        end
        else if mr = mrAbort then
        begin
          backToMainFrame;
        end;
      finally
        threadChargeCardCheck.WaitFor;
        threadChargeCardCheck.Free;
        threadChargeCardCheck := nil;
      end;
    end
    else
    begin
      dlg.setWaitingTip(TIP_GETTING_ZHB_BALANCE);
      threadQueryQFTBalance := TQueryZHBBalance.Create(True, dlg, 10, currCityCardNo, Trim(edtPasswordForChargeCard.Text));
      try
        threadQueryQFTBalance.start;
        mr := dlg.ShowModal;
        if mr = mrOk then
        begin
          doCityCardCharge(dlg);
        end
        else if mr = mrAbort then
        begin
          backToMainFrame;
        end;
      finally
        threadQueryQFTBalance.WaitFor;
        threadQueryQFTBalance.Free;
        threadQueryQFTBalance := nil;
      end;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.btnCashChargeClick(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
begin
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    addSysLog('cash charge start');
    threadQueryCityCardBalance := TQueryCityCardBalance.Create(True, dlg, 15, True);
    threadQueryCityCardBalance.FreeOnTerminate := False;
    queryCityCardBalanceFlag := 2;
    threadQueryCityCardBalance.OnGetCardBalance := DoOnGetCityCardBalance;
    threadQueryCityCardBalance.Start;
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      currChargeType := 0;
      isCityCardCharging := True;
      Notebook1.ActivePage := 'pageCityCardChooseChargeAmount';
      cityCardBizType := 0;
    end
    else if (mr = mrCancel) then
    begin
      threadQueryCityCardBalance.stop;
      backToMainFrame;
      addSysLog('cash charge cancel');
    end;
  finally
    if threadQueryCityCardBalance <> nil then
    begin
      threadQueryCityCardBalance.WaitFor;
      threadQueryCityCardBalance.Free;
      threadQueryCityCardBalance := nil;
      addSysLog('cash charge free thread');
    end;
    dlg.Free;
  end;
end;

procedure TfrmMain.btnChargeCardClick(Sender: TObject);
begin
  currChargeType := 2;
  initPnlPassword4ChargeCard(0, 16);
  Notebook1.ActivePage := 'pagePasswordForChargeCardOrQFT';
end;

procedure TfrmMain.AdvSmoothButton20Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageInputWaterCardInfo';
  publicFeeType := 0;
  AdvEdit7.Text := '××市自来水公司';
  AdvSmoothLabel48.Caption.Text := '水卡户号：';
  AdvEdit8.Text := '';
  AdvSmoothButton22.Enabled := False;
end;

procedure TfrmMain.AdvSmoothButton21Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageInputWaterCardInfo';
  publicFeeType := 2;
  AdvEdit7.Text := '××市××燃气公司';
  AdvSmoothLabel48.Caption.Text := '气卡户号：';
  AdvSmoothButton22.Enabled := False;
  AdvEdit8.Text := '';
end;

procedure TfrmMain.AdvSmoothButton22Click(Sender: TObject);
begin
  AdvEdit9.Text := '';
  AdvSmoothButton23.Enabled := False;
  Notebook1.ActivePage := 'pagePubliGetFee';
  FDlgProgress.RzMemo1.Text := '正在获取应缴金额，请稍后...';
  FDlgProgress.Timer1.Interval := 2000;
  setDlgProgressTransparent(True);
  setProgressInTop;
  FDlgProgress.Show;
end;

procedure TfrmMain.AdvSmoothButton23Click(Sender: TObject);
begin
  amountPaid := StrToFloat(AdvEdit9.Text);
  Notebook1.ActivePage := 'pageSelectPayType';
  //Self.setBtnPayTypeVisible(True, True, False);
end;

procedure TfrmMain.AdvSmoothButton24Click(Sender: TObject);
begin
  isCityCardCharging := True;
  Notebook1.ActivePage := 'pageCityCardNewCard';
end;

procedure TfrmMain.btnCityCardBalanceQueryClick(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
  threadQueryCityCard: TQueryCityCardBalance;
begin
  Notebook1.ActivePage := 'pageGetCityCardBalance';
  cityCardBizType := 1;
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    addSysLog('query city card balance start');
    threadQueryCityCard := TQueryCityCardBalance.Create(True, dlg, 30);
    threadQueryCityCard.FreeOnTerminate := False;
    queryCityCardBalanceFlag := 1;
    threadQueryCityCard.OnGetCityCardInfo := DoOnGetCityCardInfo;
    threadQueryCityCard.OnGetCardBalance := DoOnGetCityCardBalance;
    threadQueryCityCard.Start;
    mr := dlg.ShowModal;
    if (mr = mrAbort) or (mr = mrCancel) then
    begin
      threadQueryCityCard.stop;
      backToMainFrame;
    end;
  finally
    if threadQueryCityCard <> nil then
    begin
      threadQueryCityCard.WaitFor;
      threadQueryCityCard.Free;
      threadQueryCityCard := nil;
    end;
    dlg.Free;
  end;
end;

procedure TfrmMain.xbtnCityCardChargeClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageSelectChargeType';
end;

procedure TfrmMain.AdvSmoothButton27Click(Sender: TObject);
begin
//  if AdvSmoothButton27.Caption = '读卡' then
//  begin
////    AdvEdit11.Text := '记名卡(王小明 2837277273730230)';
////    AdvEdit10.Text := '10.5';
//    if cityCardBizType = 0 then
//    begin
//      AdvSmoothButton27.Caption := '下一步';
//    end
//    else if cityCardBizType = 1 then
//    begin
//      AdvSmoothButton27.Caption := '返回首页';
//    end;
//  end
//  else if AdvSmoothButton27.Caption = '下一步' then
//  begin
//    Notebook1.ActivePage := 'pageCityCardChooseChargeAmount';
//  end
//  else if AdvSmoothButton27.Caption = '返回首页' then
//  begin
//    Notebook1.ActivePage := 'Default';
//  end;
end;

procedure TfrmMain.AdvSmoothButton28Click(Sender: TObject);
begin
  amountPaid := 50;
  cityCardBalance := amountPaid - StrToFloat(AdvSmoothLabel69.Caption.Text);
  //Self.setBtnPayTypeVisible(False, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton29Click(Sender: TObject);
begin
  isNewCard := True;
  AdvEdit12.Text := '';
  AdvEdit13.Text := '';
  AdvSmoothButton31.Caption := '下一步';
  AdvSmoothButton31.Enabled := False;
  Notebook1.ActivePage := 'pageCityCardIDCard';
end;

procedure TfrmMain.btnModifyZHBPassConfirmClick(Sender: TObject);
var
  mr: TModalResult;
  dlg: TfrmWaiting;
  oldPass, newPass: AnsiString;
begin
  if Length(edtOldPass.Text) < edtOldPass.MaxLength then
  begin
    ShowTips('账户宝密码长度为' + IntToStr(edtOldPass.MaxLength) + '位，请确认输入', edtOldPass);
    edtOldPass.SetFocus;
    Exit;
  end;

  if Length(edtNewPass1.Text) < edtNewPass1.MaxLength then
  begin
    ShowTips('账户宝密码长度为' + IntToStr(edtOldPass.MaxLength) + '位，请确认输入', edtNewPass1);
    edtNewPass1.SetFocus;
    Exit;
  end;

  if Length(edtNewPass2.Text) < edtNewPass2.MaxLength then
  begin
    ShowTips('账户宝密码长度为' + IntToStr(edtOldPass.MaxLength) + '位，请确认输入', edtNewPass2);
    edtNewPass2.SetFocus;
    Exit;
  end;

  if edtNewPass1.Text <> edtNewPass2.Text then
  begin
    ShowTips('两次输入的密码不一致，请确认', edtNewPass2);
    edtNewPass2.SetFocus;
    Exit;
  end;

  oldPass := AnsiString(Trim(edtOldPass.Text));
  newPass := AnsiString(Trim(edtNewPass1.Text));

  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_MODIFYING_ZHB_PASS);
    threadModifyZHBPass := TModifyZHBPass.Create(True, dlg, 30, oldPass, newPass);
    threadModifyZHBPass.Start;
    try
      mr := dlg.ShowModal;
      if mr = mrOk then
      begin
        Notebook1.ActivePage := 'pageModifyZHBPassSuccess';
      end
      else if mr = mrCancel then
      begin
        threadModifyZHBPass.stop;
        backToMainFrame;
      end;
    finally
      threadChargeCardCheck.WaitFor;
      threadChargeCardCheck.Free;
      threadChargeCardCheck := nil;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.xbtnModifyZHBPasswordClick(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
  threadQueryCityCard: TQueryCityCardBalance;
begin
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    threadQueryCityCard := TQueryCityCardBalance.Create(True, dlg, 15);
    threadQueryCityCard.FreeOnTerminate := False;
    threadQueryCityCard.Start;
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      edtOldPass.Text := '';
      edtNewPass1.Text := '';
      edtNewPass2.Text := '';
      btnModifyZHBPassConfirm.Enabled := False;
      Notebook1.ActivePage := 'pageModifyPasswordBiz';
      edtOldPass.SetFocus;
    end
    else if mr = mrCancel then
    begin
      threadQueryCityCard.stop;
      backToMainFrame;
    end;
  finally
    if threadQueryCityCard <> nil then
    begin
      threadQueryCityCard.WaitFor;
      threadQueryCityCard.Free;
    end;
    dlg.Free;
  end;
end;

procedure TfrmMain.btnQFTCardClick(Sender: TObject);
begin
  currChargeType := 3;
  initPnlPassword4ChargeCard(1, 6);
  Notebook1.ActivePage := 'pagePasswordForChargeCardOrQFT';
end;

procedure TfrmMain.AdvSmoothButton30Click(Sender: TObject);
begin
  isNewCard := True;
  AdvSmoothLabel69.Caption.Text := '30';
  AdvSmoothLabel65.Visible := False;
  AdvSmoothButton28.Caption := '20元';
  AdvSmoothButton32.Caption := '70元';
  Notebook1.ActivePage := 'pageCityCardAmountForNewCard';
end;

procedure TfrmMain.AdvSmoothButton31Click(Sender: TObject);
begin
  if AdvSmoothButton31.Caption = '读卡' then
  begin
    AdvEdit12.Text := '32088298712130288';
    AdvEdit13.Text := '王小明';
    AdvSmoothButton31.Caption := '下一步'
  end
  else if AdvSmoothButton31.Caption = '下一步' then
  begin
    AdvSmoothLabel69.Caption.Text := '20';
    AdvSmoothLabel65.Visible := True;
    AdvSmoothButton28.Caption := '30元';
    AdvSmoothButton32.Caption := '80元';
    Notebook1.ActivePage := 'pageCityCardAmountForNewCard';
  end;
end;

procedure TfrmMain.AdvSmoothButton32Click(Sender: TObject);
begin
  amountPaid := 100;
  cityCardBalance := amountPaid - StrToFloat(AdvSmoothLabel69.Caption.Text);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.xbtnCashCharge50Click(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, AMOUNT_50_YUAN) then
  begin
    Exit;
  end;
  amountCharged := AMOUNT_50_YUAN;
  DoOnPayCash;
end;

procedure TfrmMain.xbtnCashCharge100Click(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, AMOUNT_100_YUAN) then
  begin
    Exit;
  end;
  amountCharged := AMOUNT_100_YUAN;
  DoOnPayCash;
end;

procedure TfrmMain.xbtnCashCharge200Click(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, AMOUNT_200_YUAN) then
  begin
    Exit;
  end;
  amountCharged := AMOUNT_200_YUAN;
  DoOnPayCash;
end;

procedure TfrmMain.btnPayBankCardClick(Sender: TObject);
begin
  AdvEdit2.Text := '';
  Notebook1.ActivePage := 'pagePayTypeBank';
  currChargeType := 1;
end;

procedure TfrmMain.btnPayCashClick(Sender: TObject);
var
  dlg: TfrmWaiting;
  mr: TModalResult;
  newBalance: Double;
begin
  currChargeType := 0;
  Notebook1.ActivePage := 'pageCash';
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD);
    TGetCashAmount.Create(False, dlg, 55, amountCharged);
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      setCountdownTimerEnabled(True, 15);
      threadCharge := TCityCardCharge.Create(True, dlg, 10, amountCharged);
      try
        threadCharge.Start;
        mr := dlg.ShowModal;
        if mr = mrOk then
        begin
          AdvSmoothLabel75.Visible := False;
          newBalance := threadCharge.BalanceAfterCharge * 1.0/100;
          AdvSmoothLabel74.Caption.Text := TIP_CITY_CARD_BALANCE_AFTER_CHARGED + FormatFloat('0.0#', newBalance) + '元';
          AdvSmoothLabel74.Visible := True;
          AdvSmoothLabel17.Caption.Text := TIP_CITY_CARD_AMOUNT_CHARGED + FormatFloat('0.#', amountCharged*1.0 / 100) + '元';
          AdvSmoothLabel17.Visible := True;
          Notebook1.ActivePage := 'pageMobileTopUpSuccess';
        end
        else if mr = mrAbort then
        begin
          backToMainFrame;
        end;
      finally
        threadCharge.WaitFor;
        threadCharge.Free;
        threadCharge := nil;
      end;
    end
    else if mr = mrAbort then
    begin
      backToMainFrame;
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
  FDlgProgress.RzMemo1.Text := '正在读取龙城通卡，请稍后...';
  setDlgProgressTransparent(True);
  setProgressInTop;
  FDlgProgress.Show;
end;

procedure TfrmMain.AdvSmoothButton36Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageCashConfirm';
end;

procedure TfrmMain.AdvSmoothButton37Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'Default';
end;

procedure TfrmMain.AdvSmoothButton38Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageMobileTopUpSuccess';
end;

procedure TfrmMain.AdvSmoothButton39Click(Sender: TObject);
begin
  backToMainFrame;
end;

procedure TfrmMain.AdvSmoothButton3Click(Sender: TObject);
var
  content: AnsiString;
begin
  AdvSmoothButton3.Enabled := False;
  Image17.Enabled := False;

  content := ' 卡    号：' + currCityCardNo + #13#10 +
             ' 交易类型：' + getChargeType + '充值'#13#10 +
             ' 交易时间：' + FormatDateTime('HH:nn:ss', Now) + #13#10 +
             ' 交易金额：' + FormatFloat('0.#', amountCharged * 1.0/100) + '元'#13#10 +
             ' 卡 余 额：' + FormatFloat('0.0#', (amountCharged + currCityCardBalance) * 1.0/100) + '元'#13#10;
//  if currChargeType = 3 then
//  begin
//    content := content +
//             ' 账户宝余额：' + FormatFloat('0.0#', (currZHBBalance - amountCharged) * 1.0/100) + '元'#13#10;
//  end;

  content := content +
             ' 自助编号：' + GlobalParam.TerminalId + #13#10 +
             ' 流 水 号：ZZZD' + currTranSNoFromServer + #13#10;

  printContent('自助业务回单', content);
end;

procedure TfrmMain.AdvSmoothButton40Click(Sender: TObject);
begin
  try
    cityCardBalance := StrToFloat(AdvEdit17.Text) - StrToFloat(AdvEdit18.Text);
    isCityCardCharging := True;
  except

  end;
  FDlgProgress.RzMemo1.Text := '正在处理龙城通卡交易请求,请稍后...';
  setDlgProgressTransparent(True);
  FDlgProgress.Timer1.Interval := 3000;
  setProgressInTop;
  FDlgProgress.Show;
  setDlgProgressTransparent(True);
end;

procedure TfrmMain.AdvSmoothButton41Click(Sender: TObject);
begin
  amountPaid := 100;
  //setBtnPayTypeVisible(True, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.AdvSmoothButton42Click(Sender: TObject);
begin
  amountPaid := 200;
  //setBtnPayTypeVisible(True, True, True);
  Notebook1.ActivePage := 'pageSelectPayType';
end;

procedure TfrmMain.xbtn3Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageBankBiz';
end;

procedure TfrmMain.AdvSmoothButton4Click(Sender: TObject);
begin
  initGlobalVar;
  Notebook1.ActivePage := 'pageSelectChargeType';
end;

procedure TfrmMain.btnPrepaidCardAmountConfirmClick(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, currPrepaidCardAmount) then
  begin
    Exit;
  end;
  amountCharged := currPrepaidCardAmount;
  doCityCardCharge(nil);
end;

procedure TfrmMain.btnPrepaidCardChargeClick(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
begin
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    addSysLog('prepaid card start');
    threadQueryCityCardBalance := TQueryCityCardBalance.Create(True, dlg, 15, True);
    threadQueryCityCardBalance.FreeOnTerminate := False;
    threadQueryCityCardBalance.Start;
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      currChargeType := 2;
      btnInputPrepaidCardPasswordOk.Enabled := False;
      edtPrepaidCardPassword.Text := '';
      Notebook1.ActivePage := 'pageInputPrepaidCardPassword';
      edtPrepaidCardPassword.SetFocus;
    end
    else if(mr = mrCancel) then
    begin
      threadQueryCityCardBalance.stop;
      backToMainFrame;
      addSysLog('prepaidCard charge cancel');
    end;
  finally
    if threadQueryCityCardBalance <> nil then
    begin
      threadQueryCityCardBalance.WaitFor;
      threadQueryCityCardBalance.Free;
      threadQueryCityCardBalance := nil;
      addSysLog('prepaidCard charge free thread');
    end;
    dlg.Free;
  end;
end;

procedure TfrmMain.btnPreviousClick(Sender: TObject);
begin
  isPreviousOperation := True;
  currPageIndex := currPageIndex - 1;
  Notebook1.ActivePage := pageHistory[currPageIndex];
end;

procedure TfrmMain.xbtn1Click(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageCityCard';
end;

procedure TfrmMain.AdvSmoothButton8Click(Sender: TObject);
begin
  bankTransferType := 1;
  AdvEdit3.Text := '';
  AdvEdit4.Text := '';
  AdvSmoothButton17.Enabled := False;
  AdvSmoothLabel42.Caption.Text := '请输入对方借记卡号:';
  AdvSmoothLabel43.Caption.Text := '请输入转账金额:';
  Notebook1.ActivePage := 'pageBankCardTransfer';
end;

procedure TfrmMain.backToMainFrame;
begin
  clearDefaultTip;
  initGlobalVar;
  queryZHBBalanceFlag := 0;
  btnHome.Click;
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

procedure TfrmMain.btnCityCardDetailQueryClick(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
  queryCityCardDetail: TQueryCityCardTransDetail;
begin
  clearCityCardTransDetailGrid;
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    queryCityCardDetail := TQueryCityCardTransDetail.Create(True, dlg, 30);
    queryCityCardDetail.FreeOnTerminate := False;
    queryCityCardDetail.OnQueryCityCardDetail := addCityCardTransDetailToGrid;
    queryCityCardDetail.Start;
    mr := dlg.ShowModal;
    if (mr = mrAbort) or (mr = mrCancel) then
    begin
      queryCityCardDetail.stop;
      backToMainFrame;
    end;
  finally
    if (queryCityCardDetail <> niL) then
    begin
      queryCityCardDetail.WaitFor;
      queryCityCardDetail.Free;
    end;
    dlg.Free;
  end;
end;

procedure TfrmMain.btnExpertClick(Sender: TObject);
begin
  Notebook1.ActivePage := 'pageExpert';
end;

procedure TfrmMain.btnHomeClick(Sender: TObject);
begin
  if not pnlClient.Enabled then
    pnlClient.Enabled := True;

  Notebook1.ActivePage := 'Default';
end;

procedure TfrmMain.btnInputPrepaidCardPasswordOkClick(Sender: TObject);
var
  password: ansistring;
  dlg: TfrmWaiting;
  mr: TModalResult;
begin
  password := AnsiString(Trim(edtPrepaidCardPassword.Text));
  if (password = '') or (Length(password) <> edtPrepaidCardPassword.MaxLength) then
  begin
    ShowTips('充值卡密码为' + IntToStr(edtPrepaidCardPassword.MaxLength) + '位，请确认输入', edtPrepaidCardPassword);
    edtPrepaidCardPassword.SetFocus;
    Exit;
  end;

  //获取面额
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_GETTING_PREPAID_CARD_AMOUNT, True);
    threadChargeCardCheck := TChargeCardCheck.Create(True, dlg, 10, currCityCardNo, password);
    threadChargeCardCheck.start;
    try
      mr := dlg.ShowModal;
      if mr = mrOk then
      begin
        bankCardNoOrPassword := password;
        if IS_PREPAID_CARD_CHARGE_NEED_CONFIRM then
        begin
          lblCityCardBalanceOnPnlPrepaidCard.Caption.Text := FormatFloat('0.00', currCityCardBalance * 1.0 / 100) + '元';
          lblPrepaidCardAmount.Caption.Text := FormatFloat('0.00', currPrepaidCardAmount * 1.0 / 100) + '元';
          Notebook1.ActivePage := 'pagePrepaidCardAmountConfirm';
        end
        else
        begin//充值面额验证后，直接进入充值环节，省略确认充值环节
          if isTotalAmountOverMax(currCityCardBalance, currPrepaidCardAmount) then
          begin
            Exit;
          end;
          amountCharged := currPrepaidCardAmount;
          doCityCardCharge(dlg);
        end;
      end
      else if mr = mrCancel then
      begin
        threadChargeCardCheck.stop;
        backToMainFrame;
      end;
    finally
      threadChargeCardCheck.WaitFor;
      threadChargeCardCheck.Free;
      threadChargeCardCheck := nil;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.btnZHBPasswordOkClick(Sender: TObject);
var
  password: ansistring;
  dlg: TfrmWaiting;
  mr: TModalResult;
begin
  password := AnsiString(Trim(edtZHBPassword.Text));
  if (password = '') or (Length(password) <> edtZHBPassword.MaxLength) then
  begin
    ShowTips('账户宝密码为' + IntToStr(edtZHBPassword.MaxLength) + '位，请确认输入', edtZHBPassword);
    edtZHBPassword.SetFocus;
    Exit;
  end;

  //获取余额
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_GETTING_ZHB_BALANCE, True);
    threadQueryQFTBalance := TQueryZHBBalance.Create(True, dlg, 20, currCityCardNo, password);
    try
      threadQueryQFTBalance.start;
      mr := dlg.ShowModal;
      if mr = mrCancel then
      begin
        threadQueryQFTBalance.stop;
        backToMainFrame;
      end
      else
      begin
        if queryZHBBalanceFlag = 1 then
        begin
          if mr = mrOk then
          begin
            lblBalance.Caption.Text := '账户宝余额：'
              + FormatFloat('0.00', threadQueryQFTBalance.Balance * 1.0/100) + '元';
            Notebook1.ActivePage := 'pageZHBBalance';
          end;
        end
        else if queryZHBBalanceFlag = 2 then
        begin
          if mr = mrOk then
          begin
            bankCardNoOrPassword := password;
            setBtnZHBBalanceChargeEnabled;
            lblCityCardBalanceOnPnlZHB.Caption.Text := FormatFloat('0.00', currCityCardBalance * 1.0 / 100) + '元';
            lblZHBBalance.Caption.Text := FormatFloat('0.00', currZHBBalance * 1.0 / 100) + '元';
            Notebook1.ActivePage := 'pageZHBBalanceConfirm';
          end
          else if mr = mrRetry then
          begin
            edtZHBPassword.Text := '';
            edtZHBPassword.SetFocus;
          end;
        end;
      end;
    finally
      threadQueryQFTBalance.WaitFor;
      threadQueryQFTBalance.Free;
      threadQueryQFTBalance := nil;
    end;
  finally
    dlg.Free;
  end;
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
  backToMainFrame;
end;

procedure TfrmMain.btnZHBBalanceQueryClick(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
  thread: TQueryCityCardBalance;
begin
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    addSysLog('zhb balance query start');
    thread := TQueryCityCardBalance.Create(True, dlg, 15);
    thread.FreeOnTerminate := False;
    thread.Start;
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      queryZHBBalanceFlag := 1;
      btnZHBPasswordOk.Enabled := False;
      edtZHBPassword.Text := '';
      Notebook1.ActivePage := 'pageInputZHBPassword';
      edtZHBPassword.SetFocus;
    end
    else if mr = mrCancel then
    begin
      backToMainFrame;
      thread.stop;
    end;
  finally
    dlg.Free;
    if (thread <> nil) then
    begin
      thread.WaitFor;
      thread.Free;
      thread := nil;
    end;
  end;
end;

procedure TfrmMain.btnZHBCharge100Click(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, AMOUNT_100_YUAN) then
  begin
    Exit;
  end;

  if currZHBBalance < AMOUNT_100_YUAN then
    Exit;

  amountCharged := AMOUNT_100_YUAN;
  doCityCardCharge(nil);
end;

procedure TfrmMain.btnZHBCharge200Click(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, AMOUNT_200_YUAN) then
  begin
    Exit;
  end;

  if currZHBBalance < AMOUNT_200_YUAN then
    Exit;

  amountCharged := AMOUNT_200_YUAN;
  doCityCardCharge(nil);
end;

procedure TfrmMain.btnZHBCharge30Click(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, AMOUNT_30_YUAN) then
  begin
    Exit;
  end;

  if currZHBBalance < AMOUNT_30_YUAN then
    Exit;

  amountCharged := AMOUNT_30_YUAN;
  doCityCardCharge(nil);
end;

procedure TfrmMain.btnZHBCharge50Click(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, AMOUNT_50_YUAN) then
  begin
    Exit;
  end;

  if currZHBBalance < AMOUNT_50_YUAN then
    Exit;

  amountCharged := AMOUNT_50_YUAN;
  doCityCardCharge(nil);
end;

procedure TfrmMain.btnZHBChargeAllBalanceClick(Sender: TObject);
begin
  if isTotalAmountOverMax(currCityCardBalance, currZHBBalance) then
  begin
    Exit;
  end;

  if currZHBBalance <= 0 then
    Exit;

  amountCharged := currZHBBalance;
  doCityCardCharge(nil);
end;

procedure TfrmMain.btnZHBChargeClick(Sender: TObject);
var
  dlg: Tfrmwaiting;
  mr: TModalResult;
//  threadQueryCityCard: TQueryCityCardBalance;
begin
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    addSysLog('zhb charge start');
    threadQueryCityCardBalance := TQueryCityCardBalance.Create(True, dlg, 15, True);
    threadQueryCityCardBalance.FreeOnTerminate := False;
    threadQueryCityCardBalance.Start;
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      queryZHBBalanceFlag := 2;
      currChargeType := 3;
      btnZHBPasswordOk.Enabled := False;
      edtZHBPassword.Text := '';
      Notebook1.ActivePage := 'pageInputZHBPassword';
      edtZHBPassword.SetFocus;
    end
    else if mr = mrCancel then
    begin
      threadQueryCityCardBalance.stop;
      backToMainFrame;
      addSysLog('zhb charge cancel');
    end;
  finally
    dlg.Free;
    if threadQueryCityCardBalance <> nil then
    begin
      threadQueryCityCardBalance.WaitFor;
      threadQueryCityCardBalance.Free;
      threadQueryCityCardBalance := nil;
      addSysLog('zhb charge free thread');
    end;
  end;
end;

procedure TfrmMain.DoOnPayCash;
var
  dlg: TfrmWaiting;
  mr: TModalResult;
  newBalance: Double;
  thread: TGetCashAmount;
begin
  currChargeType := 0;
  Notebook1.ActivePage := 'pageCash';
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip(TIP_PUT_CITY_CARD, True);
    thread := TGetCashAmount.Create(True, dlg, 55, amountCharged);
    thread.FreeOnTerminate := False;
    thread.Start;
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      setCountdownTimerEnabled(True, 30);
      dlg.setWaitingTip(TIP_DO_NOT_MOVE_CITY_CARD);
      threadCharge := TCityCardCharge.Create(True, dlg, 20, amountCharged);
      try
        threadCharge.Start;
        mr := dlg.ShowModal;
        if mr = mrOk then
        begin
          AdvSmoothLabel75.Visible := False;
          newBalance := threadCharge.BalanceAfterCharge * 1.0/100;
          AdvSmoothLabel74.Caption.Text := TIP_CITY_CARD_BALANCE_AFTER_CHARGED + FormatFloat('0.0#', newBalance) + '元';
          AdvSmoothLabel74.Visible := True;
          AdvSmoothLabel17.Caption.Text := TIP_CITY_CARD_AMOUNT_CHARGED + FormatFloat('0.#', amountCharged*1.0 / 100) + '元';
          AdvSmoothLabel17.Visible := True;
          Notebook1.ActivePage := 'pageMobileTopUpSuccess';
        end
        else if mr = mrAbort then
        begin
          backToMainFrame;
        end;
      finally
        threadCharge.WaitFor;
        threadCharge.Free;
        threadCharge := nil;
      end;
    end
    else if (mr = mrAbort) or (mr = mrCancel) then
    begin
      thread.stop;
      backToMainFrame;
    end
  finally
    if thread <> nil then
    begin
      thread.WaitFor;
      thread.Free;
    end;
    dlg.Free;
  end;
end;

procedure TfrmMain.DoOnPrinterComRecvData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
  pb: PByte;
  status: Byte;
begin
  addSysLog('recv printer comm data, len:' + IntToStr(BufferLength));
  if BufferLength = 1 then
  begin
    pb := PByte(Buffer);
    status := pb^;
    addSysLog('recv printer data:' + IntToHex(status,2));
    if ((status shr 4) and $01) = $01 then
    begin
      printerStatus := MODULE_PRINTER_PAPER_OUT;
    end
    else if ((status shr 2) and $01) = $01 then
    begin
      printerStatus := MODULE_PRINTER_PAPER_LESS;
    end
    else
    begin
      printerStatus := MODULE_STATUS_OK;
    end;
  end;
end;

procedure TfrmMain.DoOnQueryQFTBalanceRsp(ret: Byte; balance: Integer);
begin
  if threadQueryQFTBalance <> nil then
  begin
    threadQueryQFTBalance.noticeCmdRet(ret, balance);
  end;
end;

procedure TfrmMain.edtNewPass1Enter(Sender: TObject);
begin
  setKBReaderOutput(edtNewPass1, Image27);
end;

procedure TfrmMain.edtNewPass1Exit(Sender: TObject);
begin
  setKBReaderOutput(nil);
end;

procedure TfrmMain.edtNewPass2Enter(Sender: TObject);
begin
  setKBReaderOutput(edtNewPass2, Image27);
end;

procedure TfrmMain.edtNewPass2Exit(Sender: TObject);
begin
  setKBReaderOutput(nil);
end;

procedure TfrmMain.edtOldPassEnter(Sender: TObject);
begin
  setKBReaderOutput(edtOldPass, Image27);
end;

procedure TfrmMain.edtOldPassExit(Sender: TObject);
begin
  setKBReaderOutput(nil);
end;

procedure TfrmMain.edtOldPassKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  btnModifyZHBPassConfirm.Enabled := False;
  if (Length(edtOldPass.Text) = 6)
    and (Length(edtNewPass1.Text) = 6)
    and (Length(edtNewPass2.Text) = 6)then
  begin
    btnModifyZHBPassConfirm.Enabled := True;
  end;

end;

procedure TfrmMain.edtPasswordForChargeCardEnter(Sender: TObject);
begin
  setKBReaderOutput(edtPasswordForChargeCard);
end;

procedure TfrmMain.edtPasswordForChargeCardKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TfrmMain.edtPasswordForChargeCardKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edtPasswordForChargeCard.MaxLength <> 0 then
  begin
    if Length(Trim(edtPasswordForChargeCard.Text)) = edtPasswordForChargeCard.MaxLength then
       btnPasswordOK.Enabled := True
    else
      btnPasswordOK.Enabled := False;
  end
  else
  begin
    btnPasswordOK.Enabled := Length(edtPasswordForChargeCard.Text) > 0;
  end;
end;

procedure TfrmMain.edtPhoneNoClick(Sender: TObject);
begin
  setKBReaderOutput(edtPhoneNo);
end;

procedure TfrmMain.edtPhoneNoExit(Sender: TObject);
begin
  setKBReaderOutput(nil);
end;

procedure TfrmMain.edtPrepaidCardPasswordEnter(Sender: TObject);
begin
  setKBReaderOutput(edtPrepaidCardPassword, Image12);
end;

procedure TfrmMain.edtPrepaidCardPasswordExit(Sender: TObject);
begin
  setKBReaderOutput(nil);
end;

procedure TfrmMain.edtPrepaidCardPasswordKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Length(Trim(edtPrepaidCardPassword.Text)) = edtPrepaidCardPassword.MaxLength then
    btnInputPrepaidCardPasswordOk.Enabled := True
  else
    btnInputPrepaidCardPasswordOk.Enabled := False;
end;

procedure TfrmMain.edtZHBPasswordEnter(Sender: TObject);
begin
  setKBReaderOutput(edtZHBPassword, Image26);
end;

procedure TfrmMain.edtZHBPasswordExit(Sender: TObject);
begin
  setKBReaderOutput(nil);
end;

procedure TfrmMain.edtZHBPasswordKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Length(Trim(edtZHBPassword.Text)) = edtZHBPassword.MaxLength then
    btnZHBPasswordOk.Enabled := True
  else
    btnZHBPasswordOk.Enabled := False;
end;

procedure TfrmMain.clearCityCardTransDetailGrid;
begin
  if gridCityCardTransDetail.RowCount > 1 then
  begin
    if (gridCityCardTransDetail.RowCount > 2) then
    begin
      gridCityCardTransDetail.RemoveRows(2, gridCityCardTransDetail.RowCount - 2);
    end;
    gridCityCardTransDetail.Rows[1].Clear;
  end;
end;

procedure TfrmMain.clearDefaultTip;
begin
  lblCityCardBalanceOnPanelCashCharge.Caption.Text := '';
  lblCityCardNo.Caption.Text := '';
  lblCityCardBalance.Caption.Text := '';
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

procedure TfrmMain.doCityCardCharge(dlg: TfrmWaiting);
var
  mr: TModalResult;
  newBalance: Double;
  isNewDlg: Boolean;
begin
  isNewDlg := False;
  if dlg = nil then
  begin
    isNewDlg := True;
    dlg := TfrmWaiting.Create(nil);
  end;

  setCountdownTimerEnabled(True, 35);
  threadCharge := TCityCardCharge.Create(True, dlg, 30, amountCharged);
  try
    threadCharge.Start;
    dlg.setWaitingTip(TIP_DO_NOT_MOVE_CITY_CARD);
    mr := dlg.ShowModal;
    if mr = mrOk then
    begin
      AdvSmoothLabel75.Visible := False;
      newBalance := threadCharge.BalanceAfterCharge * 1.0/100;
      AdvSmoothLabel74.Caption.Text := TIP_CITY_CARD_BALANCE_AFTER_CHARGED + FormatFloat('0.0#', newBalance) + '元';
      AdvSmoothLabel74.Visible := True;
      AdvSmoothLabel17.Caption.Text := TIP_CITY_CARD_AMOUNT_CHARGED + FormatFloat('0.#', amountCharged*1.0 / 100) + '元';
      AdvSmoothLabel17.Visible := True;
      Notebook1.ActivePage := 'pageMobileTopUpSuccess';
    end
    else if mr = mrAbort then
    begin
      backToMainFrame;
    end;
  finally
    threadCharge.WaitFor;
    threadCharge.Free;
    threadCharge := nil;
    if isNewDlg then
    begin
      dlg.Free;
    end;
  end;
end;

procedure TfrmMain.DoOnAppException(Sender: TObject; E: Exception);
var
  s: string;
begin
  try
    s := DatetimeToStr(now) + '未捕获的异常:ExceptionClassName:' + E.ClassName;
    s := s + '   SenderClassName:' + Sender.ClassName;
    //判断是不是TComponent,如果是并记录TComponent.Name
    if Sender is TComponent then
    begin
      s := s + '   SendCompName:' + TComponent(Sender).Name;
        //判断是不是TWinControl,并有Parent,就记录Parent.Name
      if Sender is TWinControl then
      begin
        if TWinControl(Sender).Parent <> nil then
        begin
          s := s + '   SendCompNameParent:' + TWinControl(Sender).Parent.Name;
        end;
      end;
    end;
    s := s + ' E.Message:' + E.Message;
    s := s + ' HelpContext:' + IntToStr(E.HelpContext);
    s := s + ' StackTrace:' + E.StackTrace;
  finally
    addSysLog(s);
  end;
end;

procedure TfrmMain.DoOnChargeCardCheckRsp(ret: Byte; amount: Integer);
begin
  if threadChargeCardCheck <> nil then
  begin
    threadChargeCardCheck.noticeCmdRet(ret, amount);
  end;
end;

procedure TfrmMain.DoOnClickTopLeftToQuit;
begin
  if MilliSecondsBetween(firstTime, Now) <= 5000 then
  begin
    Inc(clickCount);
  end
  else
  begin
    clickCount := 1;
    firstTime := Now;
  end;
  if (clickCount >= 6) then
  begin
    Close;
  end;
end;

procedure TfrmMain.doOnFunctionNotReleased;
var
  dlg: TfrmWaiting;
begin
  dlg := TfrmWaiting.Create(nil);
  try
    dlg.setWaitingTip('功能暂未开放，敬请期待...', False, True);
    dlg.startTimer(2000);
    dlg.ShowModal;
  finally
    dlg.Free;
  end;
  Exit;
end;

procedure TfrmMain.DoOnGetCityCardType(ret: Byte);
begin
  currCityCardType := ret;
  if threadQueryCityCardBalance <> nil then
  begin
    threadQueryCityCardBalance.noticeCmdRet(ret);
  end;
end;

procedure TfrmMain.DoOnGetCityCardBalance(balance: Integer);
begin
  addSysLog('DoOnGetCityCardInfo ' + IntToStr(balance));
  if queryCityCardBalanceFlag = 1 then
  begin
    lblCityCardBalance.Caption.Text := TIP_CITY_CARD_BALANCE
                                + FormatFloat('0.00', balance / 100.0) + '元';
  end
  else if queryCityCardBalanceFlag = 2 then
  begin
    lblCityCardBalanceOnPanelCashCharge.Caption.Text := TIP_CITY_CARD_BALANCE
                                + FormatFloat('0.00', balance / 100.0) + '元';
  end;
end;

procedure TfrmMain.DoOnGetCityCardInfo(cardInfo: string);
begin
  addSysLog('DoOnGetCityCardInfo ' + cardInfo);
  if queryCityCardBalanceFlag = 1 then
  begin
    lblCityCardNo.Caption.Text := TIP_CITY_CARD_NO + cardInfo;
  end
  else if queryCityCardBalanceFlag = 2 then
  begin

  end;
end;

procedure TfrmMain.DoOnGetMac2(ret: Byte; mac2, tranSNo, errTip: AnsiString);
begin
  if threadCharge <> nil then
  begin
    threadCharge.noticeMac2Got(ret, mac2, tranSNo, errTip);
  end;
end;

procedure TfrmMain.DoOnLoginStatusChanged(loginStatus: Byte);
begin
  addSysLog('loginStatus:' + IntToStr(loginStatus));
  btnLoginStatus.Visible := loginStatus <> LOGIN_STATUS_OK;
  btnLoginStatus.Caption := '未登录成功[' + IntToStr(loginStatus) + ']';
  showOutOfServiceFrm(loginStatus <> LOGIN_STATUS_OK, loginStatus);
end;

procedure TfrmMain.DoOnModifyZHBPassRsp(ret: Byte);
begin
  if threadModifyZHBPass <> nil then
  begin
    threadModifyZHBPass.noticeCmdRet(ret);
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//var
//  dlg: TfrmCloseConfirm;
begin
//  dlg := TfrmCloseConfirm.Create(nil);
//  try
//    CanClose := dlg.ShowModal = mrOk;
//  finally
//    dlg.Free;
//  end;
  if MessageBox(Handle, '您确认关闭自助服务系统吗？', '确认', MB_YESNO + MB_ICONQUESTION) = ID_NO then
  begin
    CanClose := False;
  end
  else
  begin
    CanClose := True;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF test}
    RzPanel7.Caption := 'DEMO';
  {$ENDIF}
  setPanelInvisible;
  setTimeInfo;
  Self.DoubleBuffered := True;
  RzPanel1.DoubleBuffered := True;
  firstTime := Now;
  clickCount := 0;
  resetPageHistory;
  FIsPnlPosSet := False;
  FIsPosSet := False;
  setKBReaderOutput(nil);
  FPauseServiceFrm := TfrmWaiting.Create(nil);
  FPauseServiceFrm.WindowState := wsMaximized;
  FPauseServiceFrm.AdvSmoothLabel1.Caption.Font.Size := 60;
  Application.OnException := DoOnAppException;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if FPauseServiceFrm <> nil then
  begin
    FPauseServiceFrm.Free;
  end;

  DataServer.Active := False;
  DataServer.Free;
  CloseSSPComPort;
  FreePrinterCom;
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
//  for i := Notebook1.Pages.Count - 1 downto 0 do
  //Notebook1.PageIndex := 0;
  Notebook1.ActivePage := 'Default';
  FIsPnlPosSet := False;
  FIsPosSet := False;
  initMain;
  initDev;
  clearDefaultTip;
end;

function TfrmMain.getBillAcceptorStatus: Byte;
var
  sspCmd: TSSP_Command;
  sspCmdInfo: TSSP_Command_Info;
begin
  Result := MODULE_STATUS_FAULT;

  sspCmd.SSPAddress := 0;
  sspCmd.BaudRate := 9600;
  sspCmd.Timeout := 1000;
  sspCmd.RetryLevel := 3;
  sspCmd.PortNumber := GlobalParam.ITLPort;
  sspCmd.EncryptionStatus := 0;

  //发送 0x11 号命令查找识币器是否连接
  sspCmd.CommandData[0] := $11;
  sspCmd.CommandDataLength := 1;
  if SSPSendCommand(@sspCmd, @sspCmdInfo) = 0then
  begin
    Exit;
  end;

  Result := MODULE_STATUS_OK
end;

function TfrmMain.getD8Status: Byte;
begin
  if icdev > 0 then
    Result := MODULE_STATUS_OK
  else
    Result := MODULE_STATUS_FAULT;
end;

function TfrmMain.getKeyboardStatus: Byte;
begin
  if isKeyBoardComOpen then
    Result := MODULE_STATUS_OK
  else
    Result := MODULE_STATUS_FAULT;
end;

function TfrmMain.getPrinterStatus: Byte;
begin
  Result := printerStatus;
  getPrinterNewStatus;
end;

procedure TfrmMain.Image6Click(Sender: TObject);
begin
  doOnFunctionNotReleased;
end;

procedure TfrmMain.iniForm;
begin
  if FIsPosSet then
    Exit;

  FIsPosSet := True;

  // *************调整返回首页的按钮及倒计时标签的位置
//  btnHome.Left := pnlTop.Width - btnHome.Width - 15;
//  btnHome.Top := pnlTop.Height - btnHome.Height - 5;
//  btnPrevious.Left := btnHome.Left - btnPrevious.Width - 15;
//  btnPrevious.Top := btnHome.Top;
  lblCountdown.Left := pnlTop.Width - lblCountdown.Width - 30;
  lblCountdown.Top := btnHome.Top - lblCountdown.Height - 5;
  lblCountdown.Parent.DoubleBuffered := True;
  // *************调整返回首页的按钮及倒计时标签的位置

  // *************调整时间的位置使其居中，在右下角显示公司信息
  btnTime.Left := (pnlTimeBar.Width - btnTime.Width) div 2;
  btnTime.Top := (pnlTimeBar.Height - btnTime.Height) div 2;
  // lblCompany.Left := pnlBottom.Width - lblCompany.Width - 30;
  // *************调整时间的位置使其居中，在右下角显示公司信息
  resetMainBtnPos;
  resetCityCardBizBtnPos;
end;

function TfrmMain.initBillAcceptor: Boolean;
var
  sspCmd: TSSP_Command;
  sspCmdInfo: TSSP_Command_Info;
  i: Integer;
begin
  Result := False;

  {$IFDEF test}
    Exit;
  {$ENDIF}

  sspCmd.SSPAddress := 0;
  sspCmd.BaudRate := 9600;
  sspCmd.Timeout := 1000;
  sspCmd.RetryLevel := 3;
  sspCmd.PortNumber := GlobalParam.ITLPort;
  sspCmd.EncryptionStatus := 0;
  sspCmd.CommandDataLength := 0;
  //打开串口
  try
    addSysLog('open ssp com');
    i := OpenSSPComPort(@sspCmd);
    if (i = 0) then
    begin
      Exit;
    end;


    //发送 0x11 号命令查找识币器是否连接
    sspCmd.CommandData[0] := $11;
    sspCmd.CommandDataLength := 1;
    if SSPSendCommand(@sspCmd, @sspCmdInfo) = 0then
    begin
      Exit;
    end;
  finally
    addSysLog('close ssp com');
    //CloseSSPComPort;
  end;

  Result := True;
end;

function TfrmMain.initD8: Boolean;
begin
  Result := False;
  icdev := dc_init(GlobalParam.D8ComPort, GlobalParam.D8BaudRate);
  if icdev < 0 then
  begin
    addSysLog('dc init fail');
    Exit;
  end;
  dc_beep(icdev, 15);

  Result := True;
end;

procedure TfrmMain.initDev;
begin
  initD8;
  initBillAcceptor;
  initPrinter;
  initKeyBoard;
end;

function TfrmMain.initKeyBoard: Boolean;
var
  i: Integer;
begin
  i := kb_openCom(GlobalParam.KeyBoardComPort, 9600);
  isKeyBoardComOpen := i >= 0;
  Result := isKeyBoardComOpen;
end;

procedure TfrmMain.initPnlPassword4ChargeCard(flag: Byte; maxLength: Integer);
begin
  edtPasswordForChargeCard.Text := '';
  edtPasswordForChargeCard.MaxLength := maxLength;
  if flag = 0 then
  begin
    lblPassword4ChargeCardOrQFT.Caption.Text := '充值卡密码：';
  end
  else if flag = 1 then
  begin
    lblPassword4ChargeCardOrQFT.Caption.Text := '账户宝密码：';
  end;
  btnPasswordOK.Enabled := False;
end;

procedure TfrmMain.initMain;
begin
  loadParam;

  DataServer := TGateWayServerCom.Create;
  DataServer.OnGetMac2 := DoOnGetMac2;
  DataServer.OnChargeCardCheckRsp := DoOnChargeCardCheckRsp;
  DataServer.OnQueryQFTBalanceRsp := DoOnQueryQFTBalanceRsp;
  DataServer.OnModifyZHBPassRsp := DoOnModifyZHBPassRsp;
  DataServer.OnLoginStatusChanged := DoOnLoginStatusChanged;
  DataServer.OnGetCityCardType := DoOnGetCityCardType;
  connectToGateway;
end;

function TfrmMain.initPrinter: Boolean;
begin
  if initPrinterCom then
  begin
    printerCom.OnReceiveData := DoOnPrinterComRecvData;
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

procedure TfrmMain.initThreads;
begin
  threadQueryCityCardBalance := nil;
  threadCharge := nil;
  threadChargeCardCheck := nil;
  threadQueryQFTBalance := nil;
  threadModifyZHBPass := nil;
end;

function TfrmMain.isCheckModuleStatusOk: Boolean;
begin
  Result := not isCityCardCharging;
end;

function TfrmMain.isTotalAmountOverMax(currBalance,
  chargeAmount: Integer): Boolean;
var
  dlg: TfrmWaiting;
begin
  Result := False;
  if currCityCardType = CITY_CARD_TYPE_NAMED then
  begin
    Result := (currBalance + chargeAmount) > MAX_AMOUNT_NAMED;
    if Result then
    begin
      dlg := TfrmWaiting.Create(nil);
      try
        dlg.setWaitingTip('记名卡余额加充值金额不能超过5000元', False, True);
        dlg.startTimer(4000);
        dlg.ShowModal;
      finally
        dlg.Free;
      end;
    end;
  end
  else if currCityCardType = CITY_CARD_TYPE_UNNAMED then
  begin
    Result := (currBalance + chargeAmount) > MAX_AMOUNT_UNNAMED;
    if Result then
    begin
      dlg := TfrmWaiting.Create(nil);
      try
        dlg.setWaitingTip('不记名卡余额加充值金额不能超过1000元', False, True);
        dlg.startTimer(4000);
        dlg.ShowModal;
      finally
        dlg.Free;
      end;
    end;
  end
  else if currCityCardType = CITY_CARD_TYPE_INVALID then
  begin
    Result := True;
    if Result then
    begin
      dlg := TfrmWaiting.Create(nil);
      try
        dlg.setWaitingTip('卡片无效，请确认', False, True);
        dlg.startTimer(2000);
        dlg.ShowModal;
      finally
        dlg.Free;
      end;
    end;
  end
  else if currCityCardType = CITY_CARD_TYPE_JFCARD then
  begin
    Result := True;
    if Result then
    begin
      dlg := TfrmWaiting.Create(nil);
      try
        dlg.setWaitingTip('金福卡无法充值，请确认');
        dlg.startTimer(2500);
        dlg.ShowModal;
      finally
        dlg.Free;
      end;
    end;
  end;
end;

procedure TfrmMain.loadParam;
begin
  GlobalParam.LoadFromFile('st.config');
end;

procedure TfrmMain.Notebook1PageChanged(Sender: TObject);
var
  currPageName: string;
begin
  currPageName := Notebook1.ActivePage;
  if not isPreviousOperation then
  begin
    currPageIndex := currPageIndex + 1;
    pageHistory[currPageIndex] := currPageName;
  end;
  isPreviousOperation := False;
  if currPageName = 'Default' then
  begin
    pnlBottom.Visible := True;
    setCountdownTimerEnabled(False);
    AdvSmoothLabel74.Visible := False;
    AdvSmoothLabel17.Visible := False;
    isCityCardCharging := False;
    isNewCard := False;
    resetPageHistory;
  end
  else if (currPageName = 'pageMobileTopUpSuccess')
    or (currPageName = 'pageModifyZHBPassSuccess')
    or (currPageName = 'pageCityCardTransDetail') then
  begin
    setCountdownTimerEnabled(True, 30);
    if Notebook1.ActivePage = 'pageMobileTopUpSuccess' then
    begin
      AdvSmoothButton3.Enabled := True;
      Image17.Enabled := True;
    end;
  end
  else
  begin
    setCountdownTimerEnabled(True);
    pnlBottom.Visible := False;
  end;
  pnlTimeBar.SetFocus;

  if (currPageName = 'pageMobileTopUpSuccess') or (currPageName = 'pageModifyZHBPassSuccess') then
  begin
    resetPageHistory;
  end;

  resetBackgroudImg;
  setPanelInitPos;
end;

procedure TfrmMain.resetBackgroudImg;
var
  isShowMain: Boolean;
begin
  isShowMain := False;

  if (Notebook1.ActivePage = 'Default') or (Notebook1.ActivePage = 'pageCityCard') then
  begin
    isShowMain := True;
  end;

  backgroudMain.Visible := isShowMain;
  backgroudSub.Visible := not isShowMain;
end;

procedure TfrmMain.resetCityCardBizBtnPos;
var
  xDistance, yDistance: Integer;
  btnWidth, btnHeight: Integer;
begin
  btnWidth := btnCityCardCharge.Width;
  btnHeight := btnCityCardCharge.Height;
  xDistance := (RzPanel73.Width - btnWidth) div 2;
  yDistance := (RzPanel73.Height - 3 * btnHeight) div 4;


  setBtnLeftTop(btnCityCardCharge, xDistance, yDistance);
  setBtnLeftTop(btnCityCardQuery, xDistance, 2 * yDistance + btnHeight);
  setBtnLeftTop(btnModifyZHBPassword, xDistance, 3 * yDistance + 2 * btnHeight);
end;

procedure TfrmMain.resetMainBtnPos;
var
  xDistance, yDistance: Integer;
  btnWidth, btnHeight: Integer;
begin
  btnWidth := btn1.Width;
  btnHeight := btn1.Height;
  xDistance := (pnlMainBtn.Width - 2 * btnWidth) div 3;
  yDistance := (pnlMainBtn.Height - 3 * btnHeight) div 4;


  setBtnLeftTop(btn1, xDistance, yDistance);
  setBtnLeftTop(btn2, 2 * xDistance + btnWidth, btn1.Top);
  setBtnLeftTop(btn3, btn1.Left, 2 * yDistance + btnHeight);
  setBtnLeftTop(btn4, btn2.Left, btn3.Top);
  setBtnLeftTop(btn5, btn1.Left, 3 * yDistance + 2 * btnHeight);
  setBtnLeftTop(btn6, btn2.Left, btn5.Top);
end;

procedure TfrmMain.resetPageHistory;
var
  I: Integer;
begin
  currPageIndex := 0;
  pageHistory[0] := 'Default';
  for I := 1 to Length(pageHistory) - 1 do
  begin
    pageHistory[I] := '';
  end;
end;

procedure TfrmMain.RzPanel2Resize(Sender: TObject);
begin
//  RzPanel72.Left := RzPanel2.Width - RzPanel72.Width - 40;
//  RzPanel72.Top := (RzPanel2.Height - RzPanel72.Height) div 2;
end;

procedure TfrmMain.RzPanel7Click(Sender: TObject);
begin
  DoOnClickTopLeftToQuit;
end;

procedure TfrmMain.RzPanel7DblClick(Sender: TObject);
begin
  DoOnClickTopLeftToQuit;
end;

procedure TfrmMain.setTimeInfo();
var
  dt: TDateTime;
  d, t: string;
  weekDay: string;
  cap: string;
begin
  dt := Now;
  d := FormatDateTime('yyyy年MM月dd日', dt);
  t := FormatDateTime('hh时mm分', dt);
  weekDay := getWeekDay(DayOfTheWeek(dt));
  cap := Format('%s %s %s', [d, weekDay, t]);
  if btnTime.Caption.Text <> cap then
  begin
    btnTime.Caption.Text := cap;
  end;
end;

procedure TfrmMain.showOutOfServiceFrm(isFrmVisible: Boolean; status: Byte);
var
  tip: string;
begin
  if isFrmVisible then
  begin
    tip := '暂  停  服  务';
    if status > 0 then
      tip := tip + '[' + IntToStr(status) + ']';
    FPauseServiceFrm.setWaitingTip(tip, False, True);
    FPauseServiceFrm.ShowModal;
  end
  else
  begin
    FPauseServiceFrm.Hide;
  end;
end;

procedure TfrmMain.setBtnPayTypeVisible(btnCityCardVisible, btnBankCardVisible,
  btnCashVisible, btnChargeCardVisible, btnQFTCardVisible: Boolean);
const
  BORDER_DEFAULT_WIDTH = 28;
var
  incWidth: Integer;
begin
  borderLeft.Width := BORDER_DEFAULT_WIDTH;
  borderRight.Width := BORDER_DEFAULT_WIDTH;
  incWidth := btnPayBankCard.Width div 2 + 14;

  btnPayBankCard.Visible := btnBankCardVisible;
  border1.Visible := btnBankCardVisible;

  btnPayCash.Visible := btnCashVisible;
  border2.Visible := btnCashVisible;

  btnChargeCard.Visible := btnChargeCardVisible;
  border3.Visible := btnChargeCardVisible;

  btnQFTCard.Visible := btnQFTCardVisible;
  border4.Visible := btnQFTCardVisible;

  btnPayCityCard.Visible := btnCityCardVisible;

  if not btnBankCardVisible then
  begin
    borderLeft.Width := borderLeft.Width + incWidth;
    borderRight.Width := borderRight.Width + incWidth;
  end;

  if not btnCashVisible then
  begin
    borderLeft.Width := borderLeft.Width + incWidth;
    borderRight.Width := borderRight.Width + incWidth;
  end;

  if not btnChargeCardVisible then
  begin
    borderLeft.Width := borderLeft.Width + incWidth;
    borderRight.Width := borderRight.Width + incWidth;
  end;

  if not btnQFTCardVisible then
  begin
    borderLeft.Width := borderLeft.Width + incWidth;
    borderRight.Width := borderRight.Width + incWidth;
  end;

  if not btnCityCardVisible then
  begin
    borderLeft.Width := borderLeft.Width + btnPayBankCard.Width div 2;
    borderRight.Width := borderRight.Width + btnPayBankCard.Width div 2;
  end;
end;

procedure TfrmMain.setBtnZHBBalanceChargeEnabled;
begin
//  btnZHBCharge30.Visible := currZHBBalance >= AMOUNT_30_YUAN;
//  btnZHBCharge50.Visible := currZHBBalance >= AMOUNT_50_YUAN;
//  btnZHBCharge100.Visible := currZHBBalance >= AMOUNT_100_YUAN;
//  btnZHBCharge200.Visible := currZHBBalance >= AMOUNT_200_YUAN;
//  btnZHBChargeAllBalance.Visible := currZHBBalance > 0;
  Image13.Visible := currZHBBalance >= AMOUNT_30_YUAN;
  Image14.Visible := currZHBBalance >= AMOUNT_50_YUAN;
  Image15.Visible := currZHBBalance >= AMOUNT_100_YUAN;
  Image16.Visible := currZHBBalance >= AMOUNT_200_YUAN;
  Image20.Visible := currZHBBalance > 0;
end;

procedure TfrmMain.setCompentInParentCenter(comp: TWinControl);
begin
  comp.Left := (comp.Parent.Width - comp.Width) div 2;
  comp.Top := (comp.Parent.Height - comp.Height - 100) div 2;
end;

procedure TfrmMain.setCountdownTimerEnabled(isEnabled: Boolean;
  overTimeSeconds: Integer);
begin
  btnHome.Visible := isEnabled;
  btnPrevious.Visible := isEnabled;
  overTime := overTimeSeconds;
  lblCountdown.Visible := isEnabled;
  if lblCountdown.Visible then
  begin
    lblCountdown.Caption.Text := IntToStr(overTime);
  end;
  Timer2.Enabled := isEnabled;

  if Notebook1.ActivePage = 'pageMobileTopUpSuccess' then
  begin
    btnPrevious.Visible := False;
  end;
  if isEnabled then
  begin
    lblCountdown.Left := 0;
    btnHome.Left := 0;
    if btnPrevious.Visible then
    begin
      btnPrevious.Left := 0;
    end;
  end;
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

procedure TfrmMain.setKBReaderOutput(advEdit: TAdvEdit; compOK: TControl);
begin
  currInputEdit := advEdit;
  componentOK := compOK;
  kbReadTimer.Enabled := (currInputEdit <> nil);
  if advEdit <> nil then
  begin
    addSysLog('setKBReaderOutput, advEdit:' + advEdit.Name );
  end
  else
  begin
    addSysLog('setKBReaderOutput, advEdit:nil');
  end;
  if compOK <> nil then
  begin
    addSysLog('setKBReaderOutput, compOK:' + compOK.Name );
  end
  else
  begin
    addSysLog('setKBReaderOutput, compOK:nil');
  end;
end;

procedure TfrmMain.setPanelInitPos;
begin
//  if FIsPnlPosSet then
//    Exit;
//
//  FIsPnlPosSet := True;

  setCompentInParentCenter(RzPanel6);
  setCompentInParentCenter(RzPanel8);
  setCompentInParentCenter(RzPanel9);
  setCompentInParentCenter(RzPanel10);
  setCompentInParentCenter(RzPanel11);
  setCompentInParentCenter(RzPanel12);
  setCompentInParentCenter(RzPanel13);
  setCompentInParentCenter(RzPanel14);
  setCompentInParentCenter(RzPanel15);
  setCompentInParentCenter(RzPanel16);
  setCompentInParentCenter(RzPanel17);
  //setCompentInParentCenter(RzPanel73);
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
    backToMainFrame;
  end
  else
  begin
    overTime := overTime - 1;
    lblCountdown.Caption.Text := IntToStr(overTime);
  end;
end;

//定时上报终端各模块的状态
{
  模块1:市民卡读写模块
  模块2:现金模块
  模块3:银联模块
  模块4:打印模块
  模块5:身份证读取模块
  模块6:密码键盘模块
  ...   ...
  .模块n:xxxx

  当前先传模块1、2、4
}
procedure TfrmMain.Timer3Timer(Sender: TObject);
var
  moduleStatus: array of Byte;
begin
  if DataServer.Active and isCheckModuleStatusOk then
  begin
    SetLength(moduleStatus, 3 * 2);
    moduleStatus[0] := $01;
    moduleStatus[1] := getD8Status;
    moduleStatus[2] := $02;
    moduleStatus[3] := getBillAcceptorStatus;
    moduleStatus[4] := $04;
    moduleStatus[5] := getPrinterStatus;
    moduleStatus[6] := $06;
    moduleStatus[7] := getKeyboardStatus;
    DataServer.SendCmdUploadModuleStatus(moduleStatus);
  end;
end;

procedure TfrmMain.kbReadTimerTimer(Sender: TObject);
var
  recvData: array[0..9] of AnsiChar;
  i: Integer;
  hexVal: Integer;
  currEdtText: string;
  currEdtTextLen: Integer;
  okImg: TImage;
begin
  if (currInputEdit = nil) then
    Exit;

  i := kb_readOneChar(recvData);
  if i >= 0 then
  begin
    currEdtText := Trim(currInputEdit.Text);
    currEdtTextLen := Length(currEdtText);
    hexVal := Ord(recvData[0]);
    case hexVal of
      $08://*或退格
        begin
          if currEdtTextLen > 0 then
          begin
            currEdtText := Copy(currEdtText, 1, currEdtTextLen - 1);
            currInputEdit.Text := currEdtText;
            currInputEdit.SelStart := Length(currInputEdit.Text);
          end;
        end;
      $0D://确定
        begin
          if componentOK <> nil then
          begin
            //现在界面上的确定按钮都是Image图片
            if componentOK is TImage then
            begin
              okImg := TImage(componentOK);
              if Assigned(okImg.OnClick) then
              begin
                kbReadTimer.Enabled := False;
                okImg.OnClick(nil);
                kbReadTimer.Enabled := True;
              end;
            end;
          end;
          //PostMessage(Handle, WM_KEYDOWN, VK_TAB, 0);
        end;
      $1B://退出
        begin
        end;
      $21://上翻
        begin
        end;
      $22://下翻
        begin
        end;
      $2E://.(小数点)
        begin
        end;
      $30,$31,$32,$33,$34,$35,$36,$37,$38,$39://0-9数字
        begin
          if (currInputEdit.MaxLength > 0) and (currEdtTextLen >= currInputEdit.MaxLength) then
          begin//已达到最大允许输入长度，则不再接受输入
            Exit;
          end;
          currInputEdit.Text := currInputEdit.Text + recvData[0];
          currInputEdit.SelStart := Length(currInputEdit.Text);
        end;
    end;
  end;
end;

end.
