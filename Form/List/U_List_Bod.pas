unit U_List_Bod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, ImgList, DB, ADODB, StdCtrls, Mask, RzEdit,
  RzLabel, jpeg, ExtCtrls, GridsEh, DBGridEh, RzButton, RzPanel, UADO, UPub,
  UList, UParam, UDebug;

type
  TF_List_Bod = class(TForm)
    groupBox1: TRzGroupBox;
    panel1: TRzPanel;
    btn1: TRzBitBtn;
    btn2: TRzBitBtn;
    btn3: TRzBitBtn;
    btn4: TRzBitBtn;
    btn5: TRzBitBtn;
    grid1: TDBGridEh;
    panel2: TRzPanel;
    img1: TImage;
    label1: TRzLabel;
    Lab1: TLabel;
    btnBack: TRzBitBtn;
    btnQry: TRzBitBtn;
    tboxName: TRzEdit;
    ADOQry1: TADOQuery;
    ds1: TDataSource;
    ImageListil1: TImageList;
    procedure btnQryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_Click(Sender: TObject);
    procedure ADOQry1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_List_Bod: TF_List_Bod;

implementation

uses
  U_Prt, U_List;

{$R *.dfm}

procedure TF_List_Bod.ADOQry1AfterOpen(DataSet: TDataSet);
var
  i: Integer;
begin
  for i := 0 to grid1.Columns.Count - 1 do
  begin
    if grid1.Columns[i].Width < 50 then grid1.Columns[i].Width := 50;
    if grid1.Columns[i].Width > 120 then grid1.Columns[i].Width := 120;
  end;
end;

procedure TF_List_Bod.btnQryClick(Sender: TObject);
var
  strSQL : string;
begin
  strSQL := 'SELECT Top 100 * FROM TBod where ListID=''' + List.strListID + ''' ';
  if tboxName.Text <> '' then
  begin
    strSQL := strSQL + ' AND [Name] LIKE ''*' + tboxName.Text + '*'' ';
  end;
  Send(strSQL);
  AQrySel(ADOQry1, strSQL);
end;


procedure TF_List_Bod.FormCreate(Sender: TObject);
var
  strSQL : string;
begin
  ADOQry1.ConnectionString := getConStr;
  strSQL := 'SELECT TOP  100 * FROM TBod WHERE ListID=''' + List.strListID + ''' ';
  AQrySel(ADOQry1, strSQL);
end;

procedure TF_List_Bod.btn_Click(Sender: TObject);
var
  i : Integer;
  i_btn : Integer;
begin


  i_btn := 0;
  if Sender is TRzButton then
    i_btn := (Sender as TRzButton).Tag;

  case i_btn of
    //门板
    1:
    begin
      {
      btnPic.Visible := True;
      TAB_NAM := 'TLibBod';
      AQry1.SQL.Clear;
      AQry1.SQL.Add('select * from ' + TAB_NAM);
      AQry1.Open;}
      //FOpt_Bod.Show;

    end;
    //五金
    2:
    begin

    end ;
    //产品
    3:
    begin

    end;
    //分类
    4:
    begin

    end;
    //客户
    5:
    begin

    end;
    //其他
    6:
    begin

    end;
    //关闭
    9:
    begin

      showForm(F_List);
    end;
    //添加
    101:
    begin
      ADOQry1.Append;
    end;
    //修改
    102:
    begin
      ADOQry1.Edit;
    end;
    //删除
    103:
    begin
      if Application.MessageBox('确定要删除吗？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = IDCANCEL then
      begin
        Exit;
      end;
      ADOQry1.Delete;
    end;
    //编辑图片
    104:
    begin

    end;
    //刷新
    105:
    begin
      ADOQry1.Close;
      ADOQry1.Open;
    end;
    //保存
    106:
    begin
      if (ADOQry1.State = dsEdit) or (ADOQry1.State = dsInsert) then ADOQry1.Post;
    end;

  end;

end;


end.
