unit Model.Connection;

interface

uses
  FireDAC.Comp.Client,
  MVCFramework.ActiveRecord;

type
  TConnectionModel = class
  private
    FConn : TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    function GetConnection : TFDConnection;
  end;

implementation

uses
  System.SysUtils;

const
  PATH_DB = 'C:\workspace\cmp\delphimvcframework\samples\data\activerecorddb.db';
  FILE_NOT_FOUND = 'File %s not found';

{ TConnectionModel }

constructor TConnectionModel.Create;
begin
  inherited;

  if not FileExists(PATH_DB) then
  begin
    raise Exception.Create(Format(FILE_NOT_FOUND, [PATH_DB]));
  end;

  FConn := TFDConnection.Create(nil);
  FConn.Params.Clear;
  FConn.Params.Database := PATH_DB;
  FConn.DriverName := 'SQLite';
  FConn.Connected := True;

  ActiveRecordConnectionsRegistry.AddDefaultConnection(FConn);

end;

destructor TConnectionModel.Destroy;
begin
  FConn.Free;
  inherited;
end;

function TConnectionModel.GetConnection: TFDConnection;
begin
  Result := FConn;
end;

end.
