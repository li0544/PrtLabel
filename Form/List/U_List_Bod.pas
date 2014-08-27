unit U_List_Bod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, ImgList, DB, ADODB, StdCtrls, Mask, RzEdit,
  RzLabel, jpeg, ExtCtrls, GridsEh, DBGridEh, RzButton, RzPanel, UADO, UPub,
  UList, UParam, UDebug, Menus, IniFiles, UChkUser, U_Prt_PrdIV, U_List_FB,
  U_Prt_Prd_DoorOth;

procedure ref_grd2;

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
    btnBack: TRzBitBtn;
    btnQry: TRzBitBtn;
    AQryBod: TADOQuery;
    dsBod: TDataSource;
    ImageListil1: TImageList;
    popupMenu1: TPopupMenu;
    N1: TMenuItem;
    groupBox2: TRzGroupBox;
    panel3: TRzPanel;
    btn6: TRzBitBtn;
    btn7: TRzBitBtn;
    btn8: TRzBitBtn;
    btn9: TRzBitBtn;
    btn10: TRzBitBtn;
    grid2: TDBGridEh;
    split1: TSplitter;
    AQryCab: TADOQuery;
    dsCab: TDataSource;
    radio1: TRadioButton;
    radio2: TRadioButton;
    N2: TMenuItem;
    btnBod: TButton;
    btnLS: TButton;
    btnDoorOth: TButton;
    procedure btnQryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_Click(Sender: TObject);
    procedure AQryBodAfterOpen(DataSet: TDataSet);
    procedure AQryCabAfterScroll(DataSet: TDataSet);
    procedure AQryCabAfterOpen(DataSet: TDataSet);
    procedure radio1Click(Sender: TObject);
    procedure radio2Click(Sender: TObject);
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

procedure ref_grd2;
var
  strSQL : string;
  inif: TIniFile;
  sCol: string;
begin
  with F_List_Bod do
  begin
    inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
    if radio1.Checked then
    begin
      sCol := inif.ReadString('List', 'List_Bod', '*');
      strSQL := 'SELECT ' + sCol + ' FROM TBod where ListID=''' + List.strListID + ''' '
        + ' AND CabIndex=' + VarToStr(AQryCab.FieldValues['CabIndex']);
    end
    else
    begin
      sCol := inif.ReadString('List', 'List_HDW', '*');
      strSQL := 'SELECT ' + sCol + ' FROM [THDWare] where ListID=''' + List.strListID + ''' '
        + ' AND CabIndex=' + VarToStr(AQryCab.FieldValues['CabIndex']);
    end;

    inif.Free;

    Send(strSQL);
    AQrySel(AQryBod, strSQL);
  end;

end;

procedure TF_List_Bod.AQryBodAfterOpen(DataSet: TDataSet);
var
  i: Integer;
begin
  for i := 0 to grid2.Columns.Count - 1 do
  begin
    if grid2.Columns[i].Width < 50 then grid2.Columns[i].Width := 50;
    if grid2.Columns[i].Width > 120 then grid2.Columns[i].Width := 120;
  end;
end;

procedure TF_List_Bod.AQryCabAfterOpen(DataSet: TDataSet);
var
  i: Integer;
begin
  for i := 0 to grid1.Columns.Count - 1 do
  begin
    if grid1.Columns[i].Width < 50 then grid1.Columns[i].Width := 50;
    if grid1.Columns[i].Width > 120 then grid1.Columns[i].Width := 120;
  end;
end;

procedure TF_List_Bod.AQryCabAfterScroll(DataSet: TDataSet);
begin
  ref_grd2;
end;

procedure TF_List_Bod.btnQryClick(Sender: TObject);
var
  strSQL : string;
  inif: TIniFile;
  sCol: string;
begin
  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  sCol := inif.ReadString('List','List_Cab','*');
  inif.Free;

  strSQL := 'SELECT ' + sCol + ' FROM TCab WHERE ListID=''' + List.strListID + '''';

  AQrySel(AQryCab, strSQL);

end;


procedure TF_List_Bod.FormCreate(Sender: TObject);
var
  strSQL : string;
begin
  groupBox1.Align := alClient;
  panel1.Visible := False;
  //grid1.ReadOnly := True;

  N1.Enabled := radio1.Checked;
  N2.Enabled := radio2.Checked;

  AQryCab.ConnectionString := getConStr;
  AQryBod.ConnectionString := getConStr;
  //strSQL := 'SELECT TOP  10 * FROM TBod WHERE ListID=''' + List.strListID + ''' ';
  //AQrySel(AQryBod, strSQL);
end;

procedure TF_List_Bod.radio1Click(Sender: TObject);
begin
  N1.Enabled := radio1.Checked;
  N2.Enabled := radio2.Checked;
  ref_grd2;
end;

procedure TF_List_Bod.radio2Click(Sender: TObject);
begin
  N1.Enabled := radio1.Checked;
  N2.Enabled := radio2.Checked;
  ref_grd2;
end;

procedure TF_List_Bod.btn_Click(Sender: TObject);
var
  i,j : Integer;
  i_btn : Integer;
  strSQL : string;
  ado1 : TADO;
  ado2 : TADO;
  ado3 : TADO;
  s1,s2: string;
begin


  i_btn := 0;
  if Sender is TRzButton then i_btn := (Sender as TRzButton).Tag;
  if Sender is TMenuItem then i_btn := TMenuItem(Sender).Tag;
  if Sender is TButton then i_btn := TButton(Sender).Tag;

  case i_btn of
    //生产制作单
    1:
    begin
      f_Prt_PrdIV.ShowModal;
    end;
    //拉手设置
    2:
    begin
      F_List_FB.ShowModal;
    end ;
    //门板配置
    3:
    begin
      F_Prt_Prd_DoorOth.ShowModal;
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
      AQryBod.Append;
    end;
    //修改
    102:
    begin
      AQryBod.Edit;
    end;
    //删除
    103:
    begin
      if Application.MessageBox('确定要删除吗？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = IDCANCEL then
      begin
        Exit;
      end;
      AQryBod.Delete;
    end;
    //编辑图片
    104:
    begin

    end;
    //刷新
    105:
    begin
      AQryBod.Close;
      AQryBod.Open;
    end;
    //保存
    106:
    begin
      if (AQryBod.State = dsEdit) or (AQryBod.State = dsInsert) then AQryBod.Post;
    end;
    201:
    //添加到标准件
    begin
      {$REGION '添加标准件'}
      //ado1 := TADO.Create(nil);

      if FChkUser.ShowModal = mrCancel then Exit;

      ado2 := TADO.Create(nil);
      ado3 := TADO.Create(nil);

      ado1 := TADO(AQryBod);

      for i := 0 to grid2.SelectedRows.Count - 1 do
      begin
        ado1.GotoBookmark(pointer(grid2.SelectedRows.Items[i])); //关键是这一句
        strSQL := 'SELECT * FROM TBod WHERE ListID=''' + List.strListID + ''' AND CabIndex=' + ado1.Fs('CabIndex') + ' AND BodIndex=' + ado1.Fs('BodIndex');
        Send(strSQL);
        ado2.Sel(strSQL);

        strSQL := 'DELETE FROM [TBod_Standard] '
          + ' WHERE [Name]=''' + ado2.Fs('BodName') + ''' '
          + ' AND H=' + ado2.Fs('长度')
          + ' AND W=' + ado2.Fs('宽度')
          + ' AND CZh='''+ ado2.Fs('材质') +''' '
          + ' AND GYi=''' + ado2.Fs('括号') + ''' ';
        Send(strSQL);
        ado3.Cmd(strSQL);

        strSQL := 'INSERT INTO [TBod_Standard]([Name],[H],[W],[CZh],[GYi],[Bar]) VALUES (''' + ado2.Fs('BodName') + ''','
          + ado2.Fs('长度') + ',' + ado2.Fs('宽度') + ','''+ ado2.Fs('材质') +''',''' + ado2.Fs('括号') + ''','''')';
        Send(strSQL);
        ado3.Cmd(strSQL);
      end;

      ado2.Free;
      ado3.Free;
      {$ENDREGION}
    end;
    202:
    //更新五金备注
    begin
      ado2 := TADO.Create(nil);
      ado3 := TADO.Create(nil);

      ado1 := TADO(AQryBod);

      for i := 0 to grid2.SelectedRows.Count - 1 do
      begin
        ado1.GotoBookmark(pointer(grid2.SelectedRows.Items[i])); //关键是这一句
        strSQL := 'SELECT * FROM THDWare '
          + ' WHERE ListID=''' + List.strListID + ''' '
          //+ ' AND CabIndex=' + ado1.Fs('CabIndex')
          + ' AND nam=''' + ado1.Fs('名称') + ''' '
          + ' AND oth=''' + ado1.Fs('备注') + '''';
        Send(strSQL);
        ado2.Sel(strSQL);

        strSQL := 'UPDATE [THDWare] SET Oth=''' + ado2.Fs('oth') + ''' '
          + ' WHERE ListID=''' + List.strListID + ''' '
          //+ ' AND CabIndex=' + ado1.Fs('CabIndex')
          + ' AND nam=''' + ado1.Fs('名称') + '''';
        Send(strSQL);
        ado3.Cmd(strSQL);
      end;

      ref_grd2;

      ado2.Free;
      ado3.Free;
    end;

  end;

end;


end.
