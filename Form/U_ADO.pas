unit U_ADO;

interface

uses
  SysUtils, Classes, DB, ADODB, ExcelXP, OleServer;

type
  TD_ADO = class(TDataModule)
    AQry1: TADOQuery;
    AQry2: TADOQuery;
    AQry3: TADOQuery;
    ExlApp1: TExcelApplication;
    ExlWork1: TExcelWorkbook;
    ExlSheet1: TExcelWorksheet;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  D_ADO: TD_ADO;

implementation

uses UParam, UPub;

{$R *.dfm}

procedure TD_ADO.DataModuleCreate(Sender: TObject);
begin
  AQry1.ConnectionString := getConStr();
  AQry2.ConnectionString := getConStr();
  AQry3.ConnectionString := getConStr();
end;

end.


