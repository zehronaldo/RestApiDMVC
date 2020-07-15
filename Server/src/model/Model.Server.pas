unit Model.Server;

interface

uses
  MVCFramework.ActiveRecord,
  MVCFramework.Serializer.Commons,
  System.Generics.Collections;

type
  [MVCNameCase(TMVCNameCase.ncLowerCase)]
  [MVCTable('servers')]
  TServer = class(TMVCActiveRecord)
  private
    [MVCTableField('guid', [foPrimaryKey])]
    FGuid: String;
    [MVCTableField('name')]
    FName: String;
    [MVCTableField('ip')]
    FIp: String;
    [MVCTableField('port')]
    FPort: Integer;

    procedure SetGuid(const Value: String);
    procedure SetIp(const Value: String);
    procedure SetName(const Value: String);
    procedure SetPort(const Value: Integer);
  public
    constructor Create;override;
    destructor Destroy;override;

    property Guid : String read FGuid write SetGuid;
    property Name : String read FName write SetName;
    property Ip : String read FIp write SetIp;
    property Port: Integer read FPort write SetPort;
  end;

implementation

{ TServer }

constructor TServer.Create;
begin
  inherited Create;
end;

destructor TServer.Destroy;
begin
  inherited;
end;

procedure TServer.SetGuid(const Value: String);
begin
  FGuid := Value;
end;

procedure TServer.SetIp(const Value: String);
begin
  FIp := Value;
end;

procedure TServer.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TServer.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

end.
