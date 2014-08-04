{*****************************************************
 @author:���ڣ���ͥ�Ų������� http://www.chinaworkroom.com��
 @created
 ��������:$Author: wfp $  <BR>
 ��ǰ�汾:$Revision: 1.5 $  <BR>
*******************************************************}
unit GlobalVar;

interface
uses
  BusUnit, Types, Math, DriverUnit, CarUnit, IntegerListUnit, UserUnit, SysUtils;
type
  TStationByLineArr = array of TStationByLine;
var
    //===============================����վ̨������
  CurrentDevIndex: integer; //��ǰ���͵��ڼ�����
  CurrentStationIndex: integer; //��ǰ���͵��ڼ���վ̨


    //=================================================

  FStationList: TStationInfoList;
  FBusLineList: TBusLineList;
  FLineDevsList, LineDevsManage: TLineDevsManage;//2009-04-10 ����LineDevsManage 
  FInStationList: TInStationList;
  FCmdLineStationList: TCmdLineStationList;
  FCmdDevLineStationList: TCmdDevLineStationList; //��Ҫ���͵���������
  CurrentBuslineViewNo: Integer;
  //OtherSituationDevList: TOtherSituationDevList;
  SpeAreaTypesManage: TSpecialAreaTypeManage;
  SpeAreasManage: TSpecialAreaManage;
  DriversManage: TDriversManage;
  StewardsManage: TStewardManage;
  PlanRunTimeManage: TPlanRunTimeManage;
  GSelectBusLineId: Integer; //��ǰѡ�����·

  OldPlanRunTimeManage: TPlanRunTimeManage;
  FLogInOrOffManage: TLogInOrOffManage;
  FRentCarInfoManage: TRentCarInfoManage;

  FIOReplacementDataManage: TIOReplacementDataManage;

  FixedRentCarRunTimeManage: TRentCarRunTimeManage;//�̶�����
  TempRentCarRunTimeManage: TRentCarRunTimeManage;//��ʱ����
  SpecialRentCarRunTimeManage: TRentCarRunTimeManage;//��Լ����
  IsSendMsgToGateway: Boolean;
  //FBusParkManage: TBusParkManage;

  //FBusLineDevWithNextPlanManage: TBusLineDevListWithoutFree;//�ù�����ɾ����Աʱ���ͷţ�����������ʱҲ���ͷţ���Ա���ɶ�Ӧ��FBusLineDevListȥ�ͷ�
  FLineDevPlanManage: TLineDevPlanManage;//�����������һ��ļƻ����豸��id����·id
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
