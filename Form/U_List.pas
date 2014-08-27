unit U_List;

interface

{$DEFINE v1_72}       //1.71 显示rave report标签打印模式, 1.72 显示fast report标签打印模式

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, ExtCtrls, StdCtrls, U_Prt_Opt, EhlibAdo, 
  DB, ADODB, UPub, UParam, Menus, UList, RzPanel, DBGridEhGrouping,
  GridsEh, DBGridEh, U_Prt_LabIII, U_Prt_OutPacking, UDebug, UADO,
  U_List_Bod;
  

type
  TF_List = class(TForm)
    AQry1: TADOQuery;
    stat1: TStatusBar;
    Ds1: TDataSource;
    tbl1: TADOTable;
    PopupMenu1: TPopupMenu;
    MItemUpdate: TMenuItem;
    MItemDelete: TMenuItem;
    MItemRefresh: TMenuItem;
    MItemListOpt: TMenuItem;
    MItemLoadXls: TMenuItem;
    MItemOpt: TMenuItem;
    MItemPric: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    MItemQryDay: TMenuItem;
    MItemQryMonth: TMenuItem;
    RzPanel1: TRzPanel;
    BtnPrintLabel: TButton;
    btnMake: TButton;
    btnProject: TButton;
    btnPrice: TButton;
    Button5: TButton;
    Button1: TButton;
    Button6: TButton;
    RzPanel2: TRzPanel;
    LblHide: TLabel;
    Label1: TLabel;
    EdtListID: TEdit;
    Label2: TLabel;
    DateTimePickerStart: TDateTimePicker;
    Label3: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    BtnQuery: TButton;
    DBGridEh1: TDBGridEh;
    AQry2: TADOQuery;
    ds2: TDataSource;
    ATab2: TADOTable;
    btnBox: TButton;
    N1: TMenuItem;
    btnBod: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ToolBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MItemClick(Sender: TObject);
    procedure LblHideClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure AQry2AfterOpen(DataSet: TDataSet);
    procedure AQry2AfterScroll(DataSet: TDataSet);
    private
    { Private declarations }
     procedure ReaddDefaultListInfo();
    public
    { Public declarations }
      procedure ListRefresh();
      procedure ListRefreshAll();
      procedure ListDelete(strID: string);
      procedure ListUpdate(strOldID: string; strNewID: string);
    end;

var
  F_List: TF_List;
  i: Integer;
  sql: string;

implementation
uses
  U_Prt_Lab2, U_Prt, U_Prt_Proj2, U_List_Opt, U_Flash,
  U_Prt_Prc2, U_Prt_Prd3, U_List_PrcAdd, U_Prt_PrdIV;

{$R *.dfm}

procedure TF_List.FormCreate(Sender: TObject);
begin
  //LVList.Align := alClient;
  DBGridEh1.Align := alClient;
  DateTimePickerStart.Date := IncMonth(Date, -1); //StrToDate('2008-1-1');
  DateTimePickerEnd.Date := Date;
  AQry1.Close;
  AQry1.ConnectionString:= getConStr();
  PrcRound := 2 ;
  AreaRound := 3 ;

  {$IFDEF v1_71}
  btnBox.Visible := False;
  {$ENDIF}
end;

procedure TF_List.ListRefresh();
var
  strSQL: string;
begin

    strSQL := 'SELECT ListID AS 订单编号, 交货日期 AS 处理时间,导入时间, 安装地址, 门板材质, '
    + '背板材质, 柜体板材质, 客户姓名, 联系方式, 生产制作单 AS 生产制作单标题, '
    + '开料计划表 AS 开料计划表标题, 报价单 AS 报价单标题,门板面积,背板面积,柜体板面积 '
    + 'FROM List WHERE ListID LIKE ''%' + EdtListID.Text + '%'' '
    + 'AND 交货日期 >='''+ FormatDateTime('yyyy-MM-dd',DateTimePickerStart.Date) +''' '
    + 'AND 交货日期 <='''+ FormatDateTime('yyyy-MM-dd',DateTimePickerEnd.Date) +''' '
    + ' ORDER BY 导入时间 DESC, ListID ASC';
    //+ 'ORDER BY 交货日期 DESC, ListID ASC';
    AQrySel(AQry1, strSQL);
    AQrySel(AQry2, strSQL);
    //FillListView(LVList, AQry1);

end;

procedure TF_List.ListRefreshAll();
var
  strSQL: string;
begin

    strSQL := 'SELECT top 10 ListID AS 订单编号, 交货日期 AS 处理时间,导入时间, 安装地址, 门板材质, '
    + '背板材质, 柜体板材质, 客户姓名, 联系方式, 生产制作单 AS 生产制作单标题, '
    + '开料计划表 AS 开料计划表标题, 报价单 AS 报价单标题,门板面积,背板面积,柜体板面积 '
    + 'FROM List WHERE ListID LIKE ''%' + EdtListID.Text + '%'' '
    + ' ORDER BY 导入时间 DESC, ListID ASC';
    AQrySel(AQry1, strSQL);
    AQrySel(AQry2, strSQL);
    //FillListView(LVList, AQry1);

end;

procedure TF_List.ListDelete(strID: string);
var
  strSQL : string;
  i : Integer;
begin
  if strID = '' then
  begin
    ShowMessage('请选择要删除的订单！');
    Exit;
  end;

  for i :=0 to Length(S_TAB_NAME) - 1 do
  begin
    strSQL := 'DELETE FROM ' + S_TAB_NAME[i] + ' WHERE ListID =''' + strID + '''; ' ;
    AQryCmd(AQry1, strSQL);
  end;

end;

procedure TF_List.ListUpdate(strOldID: string; strNewID: string);
var
  strSQL : string;
  i : Integer;
begin
  if strOldID = '' then
  begin
    ShowMessage('请选择要修改的订单！');
    Exit;
  end;
  strSQL := 'SELECT * FROM List WHERE ListID=''' + strNewID + '''' ;
  AQrySel(AQry1, strSQL);
  if AQry1.RecordCount > 0 then
  begin
    ShowMessage('该编号已存在，请重新输入！');
    Exit;
  end;
   for i :=0 to Length(S_TAB_NAME) - 1 do
  begin
    strSQL := 'UPDATE ' + S_TAB_NAME[i] + ' SET ListID=''' + strNewID + ''' WHERE ListID =''' + strOldID + '''; ' ;
    AQryCmd(AQry1, strSQL);
  end;
end;

//订单不同报表通用值
procedure TF_List.ReaddDefaultListInfo();
var
  strSQL : string;
begin
  strSQL := 'SELECT * FROM list WHERE ListID=''' + strListID + '''';
  AQrySel(AQry1, strSQL);

  strName         := FieldStr( AQry1 , '客户姓名'  ) ;     //客户姓名
  strPhone        := FieldStr( AQry1 , '联系方式'  ) ;     //联系方式
  strAddress      := FieldStr( AQry1 , '安装地址'  ) ;     //安装地址
  strSDate        := FieldStr( AQry1 , '交货日期'  ) ;     //交货日期
  strBod_Door     := FieldStr( AQry1 , '门板材质'  ) ;     //门板材质
  strBod_Body     := FieldStr( AQry1 , '柜体板材质') ;     //柜体材质
  strBod_Back     := FieldStr( AQry1 , '背板材质'  ) ;     //背板材质
  strTabPrc       := FieldStr( AQry1 , '报价单'    ) ;     //报价单
  strTabPrd       := FieldStr( AQry1 , '生产制作单') ;     //生产制作单
  strTabPro       := FieldStr( AQry1 , '开料计划表') ;     //开料计划表
  strFBGY         := FieldStr( AQry1 , '封边工艺'  ) ;     //封边工艺

end;

procedure TF_List.ToolBtnClick(Sender: TObject);
var
  tag : Integer;
begin
  tag := (Sender AS TButton).Tag ;

  if tag > 100 then
  begin
    if strListID = '' then
    begin
      if AQry1.RecordCount > 0 then ShowMessage('请选择订单！')
      else ShowMessage('请导入订单！');
      Exit;
    end
    else
    begin
      F_Prt.ExeBodCount();
      ReaddDefaultListInfo();
    end;
  end;

  //加载报表默认参数
  ReadIniFile();
  F_Prt_Opt.LoadListInfo();

  case tag of
    0:
    begin
      ListRefresh();
    end;
    101:
    begin
      //打印标签
      EnterMethod('打印标签');

      //读取板材数据
      ReadBodDataFromDB();
      {ReadhdwDataFromDB();

      //计算面积和数量
      Stat_BodAreaPrc();
      Stat_hdwPrc(); //}
      Stat_BodLab();
      {$IFDEF v1_72}
      F_Prt_LabIII.ShowModal;
      {$ENDIF}
      {$IFDEF v1_71}
      F_Prt_Lab.ShowModal;
      {$ENDIF}
      ExitMethod('打印标签');
    end;
    102:
    begin
      //生产制作单
      EnterMethod('生产制作单');

      {//读取板材数据
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //读取材质价格
      ReadCZhPrc();

      //计算面积和数量
      Stat_BodAreaPrc();
      Stat_hdwPrc();

      //读取特殊加价公式及金额
      ReadTsPrc();

      //统计生产制作单数据
      Stat_BodPrd();

      F_Prt_Prd2.ShowModal;   }
      F_Prt_PrdIV.ShowModal;
      {ExeBoardPrice();
      F_Prt_Prd.RvSystem1.Execute;}
      ExitMethod('生产制作单');
    end;
    103:
    begin
      //开料计划表
      F_Prt_Proj2.btn1.Click;
    end;
    104:
    begin
      //_____________________________打印报价单_________________________________

      //读取板材数据
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //读取材质价格
      ReadCZhPrc();

      //计算价格
      Stat_BodAreaPrc();
      Stat_hdwPrc();
      
      //读取特殊加价公式及金额
      ReadTsPrc();

      //统计价格
      F_Prt_Prc2.RvSystem1.Execute;
    end;
    105:
    begin
      //读取板材数据
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //读取材质价格
      ReadCZhPrc();

      //计算价格
      Stat_BodAreaPrc();
      Stat_hdwPrc();

      //导出Excel
      F_Prt.OutputExcel();
    end;
    106:
    begin
      //导出TXT
      F_Prt.OutputTXT();
    end;
    107:  //外包装标签
    begin
      //读取板材数据
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //显示打印设置界面
      f_Prt_OutPacking_showModal;
    end;
    108:    //编辑订单明细
    begin
      showForm(F_List_Bod);
      F_List_Bod.btnQry.Click;
    end;
    7:
    begin
      Hide;
      F_Flash.Show();
    end;
  end;

end;

procedure TF_List.FormShow(Sender: TObject);
begin
  ListRefresh();
end;

procedure TF_List.MItemClick(Sender: TObject);
var
  tag : Integer;
  strNewListID : string;
  i : Integer;
  ado1: TADO;
  strSQL: string;
begin

  tag := (Sender AS TMenuItem).Tag ;

  if (tag < 900) AND (strListID = '') then
  begin
    ShowMessage('请选择要修改的订单！');
    Exit;
  end;

  case tag of
    //Load Excel File
    10:
    begin
      F_Prt.BtnLoadBoard.Click;
    end;
    //Print Option
    11:
    begin
      F_Prt.BtnOption.Click;
    end;
    //SET Price
    12:
    begin
      F_Prt.BtnSetPrice.Click;
    end;
    //修改订单号
    100:
    begin
      if strListID = '' then
      begin
        ShowMessage('请选择要修改的订单！');
        Exit;
      end;

      strNewListID := InputBox('修改订单号', '输入新订单号', strListID );
      if strNewListID = '' then
      begin
        ShowMessage('订单号不能为空！');
        Exit;
      end
      else
      begin
        if strNewListID = strListID then Exit ;
        ListUpdate(strListID, strNewListID);
        ListRefreshAll();
      end;
    end;
    //ListOption
    101:
    begin
      if strListID  = '' then
      begin
        ShowMessage('请选择要修改的订单！');
        Exit;
      end;
      F_List_Opt.ReadListInfo();
      F_List_Opt.ShowModal;
      ListRefreshAll();
    end;
    //DELETE
    102:
    begin
      if strListID = '' then
      begin
        ShowMessage('请选择要删除的订单！');
        Exit;
      end;

      if MessageDlg('确定要删除订单[' + AQry2.FieldValues['订单编号'] + ']吗？',
        mtInformation,[mbYes,mbNo],0) <> IDYES
      then  Exit;

      ado1 := TADO.Create(nil);
      for i := 0 to DBGridEh1.SelectedRows.Count - 1 do
      begin
        AQry2.GotoBookmark(Pointer(DBGridEh1.SelectedRows.Items[i]));

        strSQL := 'DELETE FROM List WHERE ListID=''' + List.strListID + '''';
        ado1.Cmd(strSQL);

        strSQL := 'DELETE FROM TCab WHERE ListID=''' + List.strListID + '''';
        ado1.Cmd(strSQL);

        strSQL := 'DELETE FROM TBod WHERE ListID=''' + List.strListID + '''';
        ado1.Cmd(strSQL);

        strSQL := 'DELETE FROM THDWare WHERE ListID=''' + List.strListID + '''';
        ado1.Cmd(strSQL);

      end;
      ado1.Free;
      ListRefresh();
      strListID := '' ;
    end;

    //其他费用
    110:
    begin
      F_List_PrcAdd.btnRef.Click;
      F_List_PrcAdd.ShowModal;
    end;

    //QryDay
    996:
    begin
      DateTimePickerStart.Date := Date;
      DateTimePickerEnd.Date   := Date;
      ListRefresh();
    end;
    //QryMonth
    997:
    begin
      DateTimePickerStart.Date := IncMonth(Date, -1);
      DateTimePickerEnd.Date   := Date;
      ListRefresh();
    end;
    //Refresh
    998:
    begin
      ListRefreshAll();
    end;
  end

end;

procedure TF_List.LblHideClick(Sender: TObject);
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

procedure TF_List.DBGridEh1DblClick(Sender: TObject);
begin
  if AQry2.RecordCount > 0 then
    MItemListOpt.Click;
end;

procedure TF_List.AQry2AfterOpen(DataSet: TDataSet);
var
  i : Integer;
  i_w : Integer;
begin
  {
  AQry2.AfterScroll := nil;
  for i := 0 to DBGridEh1.Columns.Count - 1 do
  begin
    //DBGridEh1.Columns[i].Width := 80;
    DBGridEh1.Columns[i].Title.TitleButton := True;
    DBGridEh1.Columns[i].OptimizeWidth;
    //i_w := getCNLength(DBGridEh1.Columns[i].Title.Caption) * FONT_SIZE;
    i_w := Length(DBGridEh1.Columns[i].Title.Caption) * 13;
    if DBGridEh1.Columns[i].Width < i_w then
    begin
      DBGridEh1.Columns[i].Width := i_w;
    end;
  end;
  AQry2.AfterScroll := AQry2AfterScroll;
  }
end;

procedure TF_List.AQry2AfterScroll(DataSet: TDataSet);
begin
  strListID := AQry2.FieldValues['订单编号'];
  List.strListID := AQry2.FieldValues['订单编号'];

  AQrySel(F_Prt.ADOQry_List, 'SELECT * FROM List WHERE ListID=''' + List.strListID + '''');
end;

end.




