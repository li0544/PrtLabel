unit U_List_Standard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, ImgList, DB, ADODB, StdCtrls, RzLabel, jpeg,
  ExtCtrls, GridsEh, DBGridEh, RzButton, RzPanel, Mask, RzEdit, UParam, UADO;

type
  TF_List_Standard = class(TForm)
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
    btn6: TRzBitBtn;
    btnOth: TRzBitBtn;
    ADOQry1: TADOQuery;
    ds1: TDataSource;
    ImageListil1: TImageList;
    Lab1: TLabel;
    tboxName: TRzEdit;
    label3: TLabel;
    tboxCZh: TRzEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOthClick(Sender: TObject);
    procedure btn_Click(Sender: TObject);
    procedure ADOQry1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_List_Standard: TF_List_Standard;

implementation

uses
  U_Prt, U_List;

{$R *.dfm}

procedure TF_List_Standard.ADOQry1AfterOpen(DataSet: TDataSet);
var
  i: Integer;
begin
  for i := 0 to grid1.Columns.Count - 1 do
  begin
    if grid1.Columns[i].Width < 50 then grid1.Columns[i].Width := 50;
    if grid1.Columns[i].Width > 120 then grid1.Columns[i].Width := 120;
  end;
end;

procedure TF_List_Standard.btnOthClick(Sender: TObject);
var
  strSQL : string;
begin
  strSQL := 'SELECT Top 100 [Name] AS ����,H AS ����,W AS ���,CZh AS ����,GYi AS ����,Bar AS ��־���� '
    + ' FROM TBod_Standard where 1=1 ';
  if tboxName.Text <> '' then
  begin
    strSQL := strSQL + ' AND [Name] LIKE ''%' + tboxName.Text + '%'' ';
  end;
  if tboxCZh.Text <> '' then
  begin
    strSQL := strSQL + ' AND [CZh] LIKE ''%' + tboxCZh.Text + '%'' ';
  end;
  AQrySel(ADOQry1, strSQL);
end;

procedure TF_List_Standard.FormCreate(Sender: TObject);
begin
  ADOQry1.ConnectionString := getConStr;
  AQrySel(ADOQry1, 'SELECT Top 100 Name AS ����,H AS ����,W AS ���,CZh AS ����,GYi AS ����,Bar AS ��־���� '
    + ' FROM TBod_Standard ');
end;

procedure TF_List_Standard.btn_Click(Sender: TObject);
var
  i : Integer;
  i_btn : Integer;
begin


  i_btn := 0;
  if Sender is TRzButton then
    i_btn := (Sender as TRzButton).Tag;

  case i_btn of
    //�Ű�
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
    //���
    2:
    begin

    end ;
    //��Ʒ
    3:
    begin

    end;
    //����
    4:
    begin

    end;
    //�ͻ�
    5:
    begin

    end;
    //����
    6:
    begin

    end;
    //�ر�
    9:
    begin

      showForm(F_List);
    end;
    //���
    101:
    begin
      ADOQry1.Append;
    end;
    //�޸�
    102:
    begin
      ADOQry1.Edit;
    end;
    //ɾ��
    103:
    begin
      if Application.MessageBox('ȷ��Ҫɾ����', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = IDCANCEL then
      begin
        Exit;
      end;
      for i := 0 to grid1.SelectedRows.Count - 1 do
      begin
        ADOQry1.GotoBookmark(Pointer(grid1.SelectedRows.Items[i]));
        ADOQry1.Delete;
      end;
      //grid1.SelectedRows.Delete;
    end;
    //�༭ͼƬ
    104:
    begin

    end;
    //ˢ��
    105:
    begin
      ADOQry1.Close;
      ADOQry1.Open;
    end;
    //����
    106:
    begin
      if (ADOQry1.State = dsEdit) or (ADOQry1.State = dsInsert) then ADOQry1.Post;

    end;

  end;

end;

end.
