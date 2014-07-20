unit U_List_PrcAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, Menus, DB, ADODB, StdCtrls, GridsEh, DBGridEh,
  ExtCtrls, RzPanel, UParam, UDebug;

type
  TF_List_PrcAdd = class(TForm)
    panel1: TRzPanel;
    grp2: TGroupBox;
    dbGrid1: TDBGridEh;
    panel2: TRzPanel;
    btnAdd: TButton;
    btnRef: TButton;
    btnDel: TButton;
    btnSave: TButton;
    ds1: TDataSource;
    AQry1: TADOQuery;
    pm1: TPopupMenu;
    MItemAdd: TMenuItem;
    MItemRefresh: TMenuItem;
    MItemDelete: TMenuItem;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AQry1AfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_List_PrcAdd: TF_List_PrcAdd;

implementation

uses U_Price, U_Flash, U_List;

{$R *.dfm}

procedure TF_List_PrcAdd.AQry1AfterInsert(DataSet: TDataSet);
begin
  try
    AQry1.FieldValues['订单编号'] := strListID;
  except
    on e: Exception do
    begin
      Send(e.Message);
    end;
  end;

end;

procedure TF_List_PrcAdd.btnAddClick(Sender: TObject);
var
  i : Integer;
  strCap : string;
begin

  if Sender is TButton then
  begin
    i := (Sender AS TButton).Tag;
    strCap := (Sender AS TButton).Caption;
  end;

//  if Sender is TRzButton then
//    i := (Sender AS TRzButton).Tag;

  if Sender is TMenuItem then
    i := (Sender AS TMenuItem).Tag;

  try
  case i of

    10:   //Add
    begin

      try
        AQry1.Append;

      except

      end;
    end;
    11:   //refresh
    begin
      try
        AQry1.SQL.Clear;
        AQry1.SQL.Add('SELECT * FROM TPrcAdd WHERE 订单编号 LIKE ''' + strListID + '''');
        AQry1.Open;

        List.strPrcOth := '';
        List.NumPrcOth := 0;
        for i := 0 to AQry1.RecordCount - 1 do
        begin
          List.strPrcOth := List.strPrcOth + AQry1.FieldValues['收费项目'] + ':'
            + VarToStr(AQry1.FieldValues['金额']) + '    ';
          List.NumPrcOth := List.NumPrcOth + StrToInt(VarToStr(AQry1.FieldValues['金额']));
          AQry1.Next;
        end;
        AQry1.First;
      except
        on e: Exception do
        begin
          Send(e.Message);
        end;
      end;

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

      except
        on e: Exception do
        begin
          Send(e.Message);
        end;
      end;
    end;


  end;
  except
    on e: Exception do
    begin
      Send(e.Message);
    end;
  end;

end;

procedure TF_List_PrcAdd.FormCreate(Sender: TObject);
begin
  btnRef.Click;
end;

end.
