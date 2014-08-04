unit UserUnit;
//----------------
// 用户信息
// 2004-03-22
//----------------

interface
uses
  Classes, IntegerListUnit;
type
  TPrivilege = record
    Id: Integer;
   // Name:string;
    Visible: boolean;
    Enabled: boolean;
  end;
  PPrivilege = ^TPrivilege;

  TUser = class(TObject)
  private
    FPassword: string;
    FPriList: TIntegerList;
    FPrivilegeList: array of TPrivilege;

    FUserGroupList: TintegerList;
    FroleID: integer;
    FUserStat: integer;
    FUserName: string;
    Fid: integer;
    FLoginDatetime: TDatetime;
    procedure SetroleID(const Value: integer);
    procedure SetUserName(const Value: string);
    procedure SetUserStat(const Value: integer);
    procedure Setid(const Value: integer);
    procedure SetPassword(const Value: string);
    function PrivilegeCount: integer;
    function GetPrivilege(Index: integer): TPrivilege;
  public
    constructor Create(const AName, APassword: string);
    destructor Destroy; override;

    { Procedure: AddPrivilege<br>
       为用户添加一个权限
       @param const APrivilegeValue: Integer 权限值
       @Return None
       @see @link()}
    //procedure AddPrivilege(const APrivilegeValue: Integer);
    function AddPrivilege(const APrivilegeID: Integer): PPrivilege;
    procedure ClearPrivilege;

    //为用户添加一个能打开（查看）组
    procedure AddGroup(const AGroupID: integer);

    { Procedure: HasPrivilege<br>
    返回该用户是否具有指定的权限
     @param const APrivilegeValue: Integer 需要判断的权限值
     @Return Boolean 返回是否有权限}
    function HasPrivilege(const APrivilegeID: Integer): TPrivilege;
   //用户能否打开（查看）某组
    function HasGroup(AGroupID: integer): boolean;

    property id: integer read Fid write Setid;
    property UserName: string read FUserName write SetUserName; //用户名称
    property Password: string read FPassword write SetPassword; // 用户的Password
    property roleID: integer read FroleID write SetroleID; //角色类型
    property UserStat: integer read FUserStat write SetUserStat;
    property Privilege[index: integer]: TPrivilege read GetPrivilege;
    property LoginDatetime: TDatetime read FLoginDatetime write FLoginDatetime;
  end;

  TSUser = class(TObject)
  private
    FUserId: Integer;
    FUserName: string;
  public
    constructor Create;
    destructor Destroy; override;
    property UserId: Integer read FUserId write FUserId;
    property UserName: string read FUserName write FUserName;
  end;


  TAllUserManage = class(TObject)
  private
    FList: TIntegerList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSUser;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(id: Integer): TSUser;
    function Find(id: Integer): TSUser;
    function Delete(id: Integer): Boolean;
    procedure Clear;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSUser read GetItem;

  end;

implementation

     { TUser }

function TUser.PrivilegeCount: integer;
begin
  Result := Length(FPrivilegeList);
end;

procedure TUser.AddGroup(const AGroupID: integer);
begin
  FUserGrouplist.Add(AGroupID);
end;

function TUser.AddPrivilege(const APrivilegeID: Integer): PPrivilege;
var
  i: Integer;
  find: Boolean;
begin
  Result := nil;
  find := False;
  for i := 0 to PrivilegeCount - 1 do
  begin
    if FPrivilegeList[i].Id = APrivilegeID then
    begin
      Result := @FPrivilegeList[i];
      find := True;
      Break;
    end;
  end;
  if not find then
  begin
    SetLength(FPrivilegeList, PrivilegeCount + 1); // .. Count=length(FConns)
    Result := @FPrivilegeList[PrivilegeCount - 1];
    FPrivilegeList[PrivilegeCount - 1].Id := APrivilegeID;
  end;
end;


procedure TUser.ClearPrivilege;
begin
  SetLength(FPrivilegeList, 0);
end;


constructor TUser.Create(const AName, APassword: string);
begin
  FUserName := AName;
  FPassword := APassword;

  FPriList := TIntegerList.Create;
  FUserGroupList := Tintegerlist.Create;
end;

destructor TUser.Destroy;
begin
  ClearPrivilege;
  FUserGroupList.Free;
  FPriList.Free;
  inherited;
end;


function TUser.HasGroup(AGroupID: integer): boolean;
begin
  Result := FUserGroupList.IndexOf(AGroupID) >= 0;
end;

function TUser.HasPrivilege(const APrivilegeID: Integer): TPrivilege;
var
  i: integer;
begin
  Result.Id := -1;
  Result.Visible := false;
  Result.Enabled := false;
  for i := 0 to PrivilegeCount - 1 do
  begin
    if Privilege[i].Id = APrivilegeID then
    begin
      Result := Privilege[i];
      exit;
    end;
  end;
end;



 {
procedure TUser.SetOwner(const Value: TOwner);
begin
  FOwner := Value;
end;}

procedure TUser.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TUser.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TUser.SetroleID(const Value: integer);
begin
  FroleID := Value;
end;

procedure TUser.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TUser.SetUserStat(const Value: integer);
begin
  FUserStat := Value;
end;

function TUser.GetPrivilege(Index: integer): TPrivilege;
begin
  Result := FPrivilegeList[Index];
end;



{ TSUser }

constructor TSUser.Create;
begin

end;

destructor TSUser.Destroy;
begin

  inherited;
end;

{ TAllUserManage }

function TAllUserManage.Add(id: Integer): TSUser;
var
  i: Integer;
begin
  i := FList.IndexOf(id);
  if i < 0 then
  begin
    Result := TSUser.Create;
    Result.UserId := id;
    FList.AddData(id, Result);
  end
  else
  begin
    Result := Items[i];
  end;
end;

procedure TAllUserManage.Clear;
begin
  while Count > 0 do
    Delete(Items[0].UserId);
end;

constructor TAllUserManage.Create;
begin
  FList := TIntegerList.Create;
end;

function TAllUserManage.Delete(id: Integer): Boolean;
var
  i: Integer;
  user: TSUser;
begin
  Result := False;
  i := FList.IndexOf(id);
  if i >= 0 then
  begin
    user := Items[i];
    FList.Delete(i);
    user.Free;
    Result := True;
  end;  
end;

destructor TAllUserManage.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TAllUserManage.Find(id: Integer): TSUser;
var
  i: Integer;
begin
  Result := nil;
  i := FList.IndexOf(id);
  if i >= 0 then
    Result := Items[i];
end;

function TAllUserManage.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TAllUserManage.GetItem(Index: Integer): TSUser;
begin
  Result := nil;
  if (Index >= 0) and (Index < FList.Count) then
    Result := TSUser(FList.Datas[Index]);
end;

end.
