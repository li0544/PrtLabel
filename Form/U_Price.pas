unit U_Price;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids, UADO,
  U_Price_Add, Menus, ExtCtrls, UPub, UParam, DBGridEhGrouping, GridsEh,
  DBGridEh, RzPanel, RzButton;

type
  TF_Price = class(TForm)
    ds1: TDataSource;
    AQry1: TADOQuery;
    pm1: TPopupMenu;
    MItemAdd: TMenuItem;
    MItemDelete: TMenuItem;
    MItemRefresh: TMenuItem;
    Panel1: TPanel;
    BtnBodPrice: TButton;
    BtnHDPrice: TButton;
    BtnLSPrice: TButton;
    LblHide: TLabel;
    RzPanel1: TRzPanel;
    grp2: TGroupBox;
    DBGridEh1: TDBGridEh;
    RzPanel2: TRzPanel;
    btnAdd: TButton;
    btnRef: TButton;
    btnDel: TButton;
    RzButton1: TRzButton;
    Button1: TButton;
    RzStatusBar1: TRzStatusBar;
    btnSave: TButton;

    procedure FormCreate(Sender: TObject);
    procedure LblHideClick(Sender: TObject);
    procedure BtnPriceClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    procedure Edit();
    procedure GridRefresh();
    procedure BtnEnable(b1 : Boolean);
  end;

var
  F_Price: TF_Price;
  v1: string;
  v2: Double;
  v3: string;
  v4: Boolean;
  tab: Integer;
  typ: Integer;
implementation

uses
  U_Prt, U_Flash;
{$R *.dfm}
var
  sql: string;
  ds: TDataSet;
  IType: Integer;

procedure TF_Price.Edit();
begin
  if IType = 3 then Exit;
  v1 := FieldStr(AQry1, '名称');
  v2 := FieldDob(AQry1, '价格');
  v3 := FieldStr(AQry1, '单位');
  v4 := FieldBoo(AQry1, '参与计算');
  F_Price_Add := TF_Price_Add.Create(nil);
  F_Price_Add.Edit(IType, v1, v2, v3, v4);
  F_Price_Add.ShowModal;

end;

procedure TF_Price.GridRefresh();
var
  strSQL : string;
begin

  case IType of
    1..2 :
    begin
      strSQL := 'SELECT nam AS 名称,prc AS 价格,unt AS 单位,chk AS 参与计算,type AS 分类'
        + ' FROM TPrice WHERE Type=' + ItoS(iType) + ' ORDER BY nam';
      AQrySel(AQry1, strSQL);
      DBGridEh1.Columns[3].PickList.Clear;
      DBGridEh1.Columns[3].PickList.Add('True');
      DBGridEh1.Columns[3].PickList.Add('False');

    end;
    3:
    begin
      strSQL := 'SELECT nam AS 名称,prc AS 加价金额,unt AS 公式,chk AS 参与计算,type AS 分类'
        + ' FROM TPrice WHERE Type=' + ItoS(iType) + ' ORDER BY nam';
      AQrySel(AQry1, strSQL);
      DBGridEh1.Columns[3].PickList.Clear;
      DBGridEh1.Columns[3].PickList.Add('True');
      DBGridEh1.Columns[3].PickList.Add('False');
      
    end;
    4:
    begin
      strSQL := 'SELECT nam AS 名称,prc AS 价格,unt AS 单位,chk AS 参与计算,type AS 分类'
        + ' FROM TPrice WHERE Type=' + ItoS(iType) + ' ORDER BY nam';
      AQrySel(AQry1, strSQL);
      DBGridEh1.Columns[3].PickList.Clear;
      DBGridEh1.Columns[3].PickList.Add('0');
      DBGridEh1.Columns[3].PickList.Add('1');
    end;
  end;

  BtnEnable(True);

end;

procedure TF_Price.FormCreate(Sender: TObject);
begin
  AQry1.Close;
  AQry1.ConnectionString := getConStr();

  RzPanel1.Align := alClient;
  grp2.Align := alClient;
  DBGridEh1.Align := alClient;

  BtnBodPrice.Click;
end;

procedure TF_Price.LblHideClick(Sender: TObject);
begin
  if LblHide.Caption = '<<' then
  begin
    LblHide.Caption := '>>';
    F_Prt.Panel2.Hide;
  end
  else
  begin
    LblHide.Caption := '<<';
    F_Prt.Panel2.Show;
  end;
end;

procedure TF_Price.BtnEnable(b1 : Boolean);
begin
  btnAdd.Enabled := b1;
  btnDel.Enabled := b1;
  btnSave.Enabled := not b1;
end;

procedure TF_Price.BtnPriceClick(Sender: TObject);
var
  i : Integer;
  strCap : string;
begin

  if Sender is TButton then
  begin
    i := (Sender AS TButton).Tag;
    strCap := (Sender AS TButton).Caption;
  end;

  if Sender is TRzButton then
    i := (Sender AS TRzButton).Tag;

  if Sender is TMenuItem then
    i := (Sender AS TMenuItem).Tag;

  case i of
    1..4 :
    begin
      IType := i;
      grp2.Caption := strCap;
      GridRefresh();

    end;
    9:    //exit
    begin
      F_Price.Hide;
      F_Flash.Show;
    end;
    10:   //Add
    begin

      try
        AQry1.Append;
        AQry1.FieldValues['分类'] := IType;
        BtnEnable(False);
      except

      end;
    end;
    11:   //refresh
    begin
      GridRefresh();
      
    end;
    12:   //DELETE
    begin
      if Application.MessageBox('确定要删除选定的数据吗？', '删除',
        MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
      begin
        AQry1.Edit;
        AQry1.DELETE;
      end;

    end;
    13:   //save
    begin
      try
        AQry1.Post;
        BtnEnable(True);
      except

      end;  
    end;


  end;

end;

end.



