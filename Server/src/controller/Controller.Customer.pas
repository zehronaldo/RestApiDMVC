unit Controller.Customer;

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
  Model.Customer,
  System.JSON,
  MVCFramework.Swagger.Commons;

type

  [MVCPath('/api')]
  TCustomerController = class(TMVCController)
  private
    FDConn : TFDConnection;
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/customers')]
    [MVCSwagSummary('Get Customer', 'Retorna todos os clientes')]
    [MVCSwagResponses(200, 'Success', TCustomer, True)]
    [MVCSwagResponses(500, 'Intenal server error')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCustomers;

    [MVCPath('/customers/($id)')]
    [MVCSwagSummary('Get Customer', 'Retorna o cliente do código enviado')]
    [MVCSwagParam(plPath, 'Id', 'Customer ID', ptInteger)]
    [MVCSwagResponses(200, 'Success', TCustomer, False)]
    [MVCSwagResponses(500, 'Intenal server error')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCustomer(id: Integer);

    [MVCPath('/customers')]
    [MVCHTTPMethod([httpPOST])]
    [MVCSwagSummary('Post Customer', 'Atualiza os dados do Cliente')]
    [MVCSwagParam(plBody, 'Entidade', 'Customer', TCustomer)]
    [MVCSwagResponses(200, 'Success', TCustomer, False)]
    [MVCSwagResponses(500, 'Intenal server error')]
    procedure CreateCustomer;

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpPUT])]
    [MVCSwagSummary('Put Customer', 'Atualiza os dados do Cliente')]
    [MVCSwagParam(plPath, 'Id', 'Customer ID', ptInteger)]
    [MVCSwagResponses(200, 'Success', TCustomer, False)]
    [MVCSwagResponses(500, 'Intenal server error')]

    procedure UpdateCustomer(id: Integer);

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    [MVCSwagSummary('Delete Customer', 'Retorna o cliente do código enviado')]
    [MVCSwagParam(plPath, 'Id', 'Customer ID', ptInteger)]
    [MVCSwagResponses(200, 'Success')]
    [MVCSwagResponses(500, 'Intenal server error')]

    procedure DeleteCustomer(id: Integer);

    constructor Create; override;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils;


procedure TCustomerController.OnAfterAction(Context: TWebContext; const AActionName: string); 
begin
  { Executed after each action }
  inherited;
end;

procedure TCustomerController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "Customer" entity
procedure TCustomerController.GetCustomers;
var
  lCustomers : TObjectList<TCustomer>;
begin
  lCustomers := TMVCActiveRecord.SelectRQL<TCustomer>('', 20);

  Render<TCustomer>(lCustomers);
end;

procedure TCustomerController.GetCustomer(id: Integer);
var
  lCustomer : TCustomer;
begin
  lCustomer := TMVCActiveRecord.GetByPK<TCustomer>(id);

  Render(lCustomer);
end;

constructor TCustomerController.Create;
const
  PATH_DB = 'D:\Frameworks\delphimvcframework\samples\data\activerecorddb.db';
  FILE_NOT_FOUND = 'File %s not found';
begin
  inherited;
  if not FileExists(PATH_DB) then
    raise Exception.Create(Format(FILE_NOT_FOUND, [PATH_DB]));

  FDConn := TFDConnection.Create(nil);
  FDConn.Params.Clear;
  FDConn.Params.Database := PATH_DB;
  FDConn.DriverName := 'SQLite';
  FDConn.Connected := True;

  ActiveRecordConnectionsRegistry.AddDefaultConnection(FDConn);
end;

procedure TCustomerController.CreateCustomer;
var
  lCustomer : TCustomer;
begin
  lCustomer := Context.Request.BodyAs<TCustomer>;

  lCustomer.Insert;
  Render(lCustomer);
end;

procedure TCustomerController.UpdateCustomer(id: Integer);
var
  lCustomer : TCustomer;
begin
  Writeln(Context.Request.Body);

  lCustomer := Context.Request.BodyAs<TCustomer>;
  lCustomer.id := id;

  lCustomer.Update;
  Render(lCustomer);
end;

procedure TCustomerController.DeleteCustomer(id: Integer);
var
  lCustomer : TCustomer;
begin
  lCustomer := TMVCActiveRecord.GetByPK<TCustomer>(id);
  lCustomer.Delete;

  Render(TJSONObject.Create(TJSONPair.Create('result', 'registro apagado com sucesso')));
end;



end.
