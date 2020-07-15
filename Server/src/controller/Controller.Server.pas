unit Controller.Server;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  MVCFramework.SQLGenerators.Sqlite,
  System.Generics.Collections,
  Model.Server,
  System.JSON,
  MVCFramework.Swagger.Commons;

type

  [MVCPath('/api')]
  TServerController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/servers')]
    [MVCHTTPMethod([httpGET])]
    procedure GetServers;

    [MVCPath('/servers/($AGuid)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetServer(AGuid: String);

    [MVCPath('/servers')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateServer;

    [MVCPath('/servers/($AGuid)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateServer(AGuid: String);

    [MVCPath('/servers/($AGuid)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteServer(AGuid: String);

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, Model.Connection;


procedure TServerController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  inherited;
end;

procedure TServerController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  inherited;
end;

procedure TServerController.GetServers;
var
  vConn: TConnectionModel;
  vServers: TObjectList<TServer>;
begin
  vConn := TConnectionModel.Create;

  try
    try
      vServers := TMVCActiveRecord.SelectRQL<TServer>('', 10);
    except
      Render(500, 'Erro interno do servidor');
    end;
    Render(200, 'OK', '', vServers);
  finally
    vConn.Free;
  end;

end;

procedure TServerController.GetServer(AGuid: String);
var
  vConn: TConnectionModel;
  vServer: TServer;
begin
  vConn := TConnectionModel.Create;

  try
    try
      vServer := TMVCActiveRecord.GetByPK<TServer>(AGuid);
    except
      Render(500, 'Erro interno do servidor');
    end;
    
    Render(200, 'OK', '', vServer);
  finally
    vConn.Free;
  end;

end;

procedure TServerController.CreateServer;
var
  vConn: TConnectionModel;
  vServer: TServer;
begin
  vConn := TConnectionModel.Create;
  vServer := Context.Request.BodyAs<TServer>;

  try
    try
      vServer.Insert;
    except
      Render(500, 'Erro interno do servidor');
    end;

    Render(201, 'Servidor criado', '', vServer);
  finally
    vConn.Free;
  end;
end;

procedure TServerController.UpdateServer(AGuid: String);
var
  vConn: TConnectionModel;
  vServer: TServer;
begin
  vConn := TConnectionModel.Create;
  vServer := Context.Request.BodyAs<TServer>;
  vServer.Guid := AGuid;

  try
    try
      vServer.Update;
    except
      Render(500, 'Erro interno do servidor');
    end;

    Render(200, 'Registro atualizado com sucesso.', '', vServer);
  finally
    vConn.Free;
  end;
end;

procedure TServerController.DeleteServer(AGuid: String);
var
  vConn: TConnectionModel;
  vServer: TServer;
begin
  vConn := TConnectionModel.Create;
  vServer := TMVCActiveRecord.GetByPK<TServer>(AGuid);

  try
    try
      vServer.Delete;
    except
      Render(500, 'Erro interno do servidor');
    end;

    Render(204, 'Registro deletado com sucesso.');
  finally
    vConn.Free;
  end;
end;



end.
