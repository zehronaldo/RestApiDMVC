unit Controller.Camera;

interface

uses
  System.SysUtils,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  MVCFramework.SQLGenerators.Sqlite,
  System.Generics.Collections,
  Model.Camera,
  System.JSON,
  MVCFramework.Swagger.Commons;

type

  [MVCPath('/api')]
  TCameraController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    constructor Create; override;

    [MVCPath('/servers/($AGuid)/cameras')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCameras(AGuid: string);

    [MVCPath('/servers/($AGuid)/cameras/($AnId)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCamera(AGuid: string; AnId: Integer);

    [MVCPath('/servers/($AGuid)/cameras')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateCamera(AGuid: string);

    [MVCPath('/servers/($AGuid)/cameras/($AnId)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateCamera(AGuid: string; AnId: Integer);

    [MVCPath('/servers/($AGuid)/cameras/($AnId)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteCamera(AGuid: string; AnId: Integer);

  end;

implementation

uses
  MVCFramework.Logger, System.StrUtils, Model.Connection;

procedure TCameraController.GetCameras(AGuid: string);
var
  vConn: TConnectionModel;
  vCameras : TObjectList<TCamera>;
begin
  vConn:= TConnectionModel.Create;
  try
    try
      vCameras:= TMVCActiveRecord.SelectRQL<TCamera>('', 10);
      Render(200, 'OK', '', vCameras);
    except
      on E: Exception do
        Render(500, 'Erro interno do servidor');
    end;

  finally
    vConn.Free;
  end;
end;

procedure TCameraController.GetCamera(AGuid: string; AnId: Integer);
var
  vConn: TConnectionModel;
  vCamera: TCamera;
begin
  vConn := TConnectionModel.Create;

  try
    try
      vCamera := TMVCActiveRecord.GetByPK<TCamera>(AnId);
      Render(200, 'OK', '', vCamera);
    except
      on E: EMVCActiveRecordNotFound do
        Render(404, 'Câmera inexistente neste servidor');
      on E: Exception do
        Render(500, 'Erro interno do servidor');
    end;

  finally
    vConn.Free;
  end;
end;

constructor TCameraController.Create;
begin
  inherited;
end;

procedure TCameraController.CreateCamera(AGuid: string);
var
  vConn: TConnectionModel;
  vCamera: TCamera;
begin
  vConn := TConnectionModel.Create;
  vCamera := Context.Request.BodyAs<TCamera>;

  try
    try
      vCamera.Insert;
      Render(201, 'Câmera criada', '', vCamera);
    except
      on E: Exception do
        Render(500, 'Erro interno do servidor');
    end;

  finally
    vConn.Free;
  end;
end;

procedure TCameraController.UpdateCamera(AGuid: string; AnId: Integer);
var
  vConn: TConnectionModel;
  vCamera: TCamera;
begin
  vConn := TConnectionModel.Create;
  vCamera := Context.Request.BodyAs<TCamera>;
  vCamera.id := AnId;

  try
    try
      vCamera.Update;
      Render(200, 'Dados da câmera atualizados com sucesso.', '', vCamera);
    except
      on E: EMVCActiveRecordNotFound do
        Render(404, 'Câmera inexistente neste servidor');
      on E: Exception do
        Render(500, 'Erro interno do servidor');
    end;

  finally
    vConn.Free;
  end;
end;

procedure TCameraController.DeleteCamera(AGuid: string; AnId: Integer);
var
  vConn: TConnectionModel;
  vCamera: TCamera;
begin
  vConn := TConnectionModel.Create;
  vCamera := TMVCActiveRecord.GetByPK<TCamera>(AnID);

  try
    try
      vCamera.Delete;
      Render(204, 'Câmera deletada com sucesso.', '', vCamera);
    except
      on E: EMVCActiveRecordNotFound do
        Render(404, 'Câmera inexistente neste servidor');
      on E: Exception do
        Render(500, 'Erro interno do servidor');
    end;

  finally
    vConn.Free;
  end;
end;

procedure TCameraController.OnAfterAction(Context: TWebContext;
  const AActionName: string);
begin
  inherited;

end;

procedure TCameraController.OnBeforeAction(Context: TWebContext;
  const AActionName: string; var Handled: Boolean);
begin
  inherited;

end;

end.
