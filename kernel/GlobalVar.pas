{*****************************************************
 @author:王磊（闲庭信步工作室 http://www.chinaworkroom.com）
 @created
 最后更新人:$Author: wfp $  <BR>
 当前版本:$Revision: 1.5 $  <BR>
*******************************************************}
unit GlobalVar;

interface
uses
  BusUnit, Types, Math, DriverUnit, CarUnit, IntegerListUnit, UserUnit, SysUtils;
type
  TStationByLineArr = array of TStationByLine;
var
    //===============================设置站台到车机
  CurrentDevIndex: integer; //当前发送到第几辆车
  CurrentStationIndex: integer; //当前发送到第几个站台


    //=================================================

  FStationList: TStationInfoList;
  FBusLineList: TBusLineList;
  FLineDevsList, LineDevsManage: TLineDevsManage;//2009-04-10 增加LineDevsManage 
  FInStationList: TInStationList;
  FCmdLineStationList: TCmdLineStationList;
  FCmdDevLineStationList: TCmdDevLineStationList; //将要发送的所有命令
  CurrentBuslineViewNo: Integer;
  //OtherSituationDevList: TOtherSituationDevList;
  SpeAreaTypesManage: TSpecialAreaTypeManage;
  SpeAreasManage: TSpecialAreaManage;
  DriversManage: TDriversManage;
  StewardsManage: TStewardManage;
  PlanRunTimeManage: TPlanRunTimeManage;
  GSelectBusLineId: Integer; //当前选择的线路

  OldPlanRunTimeManage: TPlanRunTimeManage;
  FLogInOrOffManage: TLogInOrOffManage;
  FRentCarInfoManage: TRentCarInfoManage;

  FIOReplacementDataManage: TIOReplacementDataManage;

  FixedRentCarRunTimeManage: TRentCarRunTimeManage;//固定包车
  TempRentCarRunTimeManage: TRentCarRunTimeManage;//临时包车
  SpecialRentCarRunTimeManage: TRentCarRunTimeManage;//特约包车
  IsSendMsgToGateway: Boolean;
  //FBusParkManage: TBusParkManage;

  //FBusLineDevWithNextPlanManage: TBusLineDevListWithoutFree;//该管理器删除成员时不释放，管理器销毁时也不释放，成员会由对应的FBusLineDevList去释放
  FLineDevPlanManage: TLineDevPlanManage;//用来存放有下一班的计划的设备的id和线路id
  FBoardLinesManage: TBoardLinesManage;
  FBoardBusStartInfoManage: TBoardBusStartInfoManage;
  FCheckersManage: TCheckerManage;
  FBusLineSectionInfoManage: TBusLineSectionInfoManage;
  FBusLineParamsManage: TBusLineParamsManage;
  FBusParkManage: TBusParkManage;
  FBusIOStationManage: TBusIOStationList;
  FBusIOParkParamsManage: TBusIOParkParamsManage;
  FBTZInfoManage: TBTZObjectsManage;
  FDevAdsManage: TDevAdsManage;
  FAllUserManage: TAllUserManage;

function GetDistance(oldLong, oldLat, newLong,
  newLat: Double): Double;
function GetBusParkName(parkNo: Integer): string;

implementation

initialization

  FStationList := TStationInfoList.Create;
  FBusLineList := TBusLineList.Create;
  FInStationList := TInStationList.Create;
  FCmdDevLineStationList := TCmdDevLineStationList.Create;
  FCmdLineStationList := TCmdLineStationList.Create;
  //OtherSituationDevList := TOtherSituationDevList.Create;
  FLineDevsList := TLineDevsManage.Create;
  LineDevsManage := TLineDevsManage.Create;//2009-04-09 WFP
  SpeAreaTypesManage := TSpecialAreaTypeManage.Create;
  SpeAreasManage := TSpecialAreaManage.Create;
  DriversManage := TDriversManage.Create;
  StewardsManage := TStewardManage.Create;
  PlanRunTimeManage := TPlanRunTimeManage.Create;
  OldPlanRunTimeManage := TPlanRunTimeManage.Create;
  FLogInOrOffManage := TLogInOrOffManage.Create;
  FRentCarInfoManage := TRentCarInfoManage.Create;
  FIOReplacementDataManage := TIOReplacementDataManage.Create;
  FixedRentCarRunTimeManage := TRentCarRunTimeManage.Create;
  TempRentCarRunTimeManage := TRentCarRunTimeManage.Create;
  SpecialRentCarRunTimeManage := TRentCarRunTimeManage.Create;
  //FBusLineDevWithNextPlanManage := TBusLineDevListWithoutFree.Create;
  FLineDevPlanManage := TLineDevPlanManage.Create;
  FBoardLinesManage := TBoardLinesManage.Create;
  FBoardBusStartInfoManage := TBoardBusStartInfoManage.Create;
  FCheckersManage := TCheckerManage.Create;
  FBusLineSectionInfoManage := TBusLineSectionInfoManage.Create;
  FBusLineParamsManage := TBusLineParamsManage.Create;
  FBusParkManage := TBusParkManage.Create;
  FBusIOStationManage := TBusIOStationList.Create;
  FBusIOParkParamsManage := TBusIOParkParamsManage.Create;
  FBTZInfoManage := TBTZObjectsManage.Create;
  FDevAdsManage := TDevAdsManage.Create;
  FAllUserManage := TAllUserManage.Create;
finalization
  FStationList.Free;
  FBusLineList.Free;
  FInStationList.Free;
  FCmdDevLineStationList.Free;
  FCmdLineStationList.Free;
  //OtherSituationDevList.Free;
  FLineDevsList.Free;
  LineDevsManage.Free;
  SpeAreaTypesManage.Free;
  SpeAreasManage.Free;
  DriversManage.Free;
  StewardsManage.Free;
  PlanRunTimeManage.Free;
  OldPlanRunTimeManage.Free;
  FLogInOrOffManage.Free;
  FRentCarInfoManage.Free;
  FIOReplacementDataManage.Free;
  FixedRentCarRunTimeManage.Free;
  TempRentCarRunTimeManage.Free;
  SpecialRentCarRunTimeManage.Free;
  //FBusLineDevWithNextPlanManage.Free;
  FLineDevPlanManage.Free;
  FBoardLinesManage.Free;
  FBoardBusStartInfoManage.Free;
  FCheckersManage.Free;
  FBusLineSectionInfoManage.Free;
  FBusLineParamsManage.Free;
  FBusParkManage.Free;
  FBusIOStationManage.Free;
  FBusIOParkParamsManage.Free;
  FBTZInfoManage.Free;
  FDevAdsManage.Free;
  FAllUserManage.Free;
end.
