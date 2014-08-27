unit U_List;

interface

{$DEFINE v1_72}       //1.71 ��ʾrave report��ǩ��ӡģʽ, 1.72 ��ʾfast report��ǩ��ӡģʽ

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

    strSQL := 'SELECT ListID AS �������, �������� AS ����ʱ��,����ʱ��, ��װ��ַ, �Ű����, '
    + '�������, ��������, �ͻ�����, ��ϵ��ʽ, ���������� AS ��������������, '
    + '���ϼƻ��� AS ���ϼƻ������, ���۵� AS ���۵�����,�Ű����,�������,�������� '
    + 'FROM List WHERE ListID LIKE ''%' + EdtListID.Text + '%'' '
    + 'AND �������� >='''+ FormatDateTime('yyyy-MM-dd',DateTimePickerStart.Date) +''' '
    + 'AND �������� <='''+ FormatDateTime('yyyy-MM-dd',DateTimePickerEnd.Date) +''' '
    + ' ORDER BY ����ʱ�� DESC, ListID ASC';
    //+ 'ORDER BY �������� DESC, ListID ASC';
    AQrySel(AQry1, strSQL);
    AQrySel(AQry2, strSQL);
    //FillListView(LVList, AQry1);

end;

procedure TF_List.ListRefreshAll();
var
  strSQL: string;
begin

    strSQL := 'SELECT top 10 ListID AS �������, �������� AS ����ʱ��,����ʱ��, ��װ��ַ, �Ű����, '
    + '�������, ��������, �ͻ�����, ��ϵ��ʽ, ���������� AS ��������������, '
    + '���ϼƻ��� AS ���ϼƻ������, ���۵� AS ���۵�����,�Ű����,�������,�������� '
    + 'FROM List WHERE ListID LIKE ''%' + EdtListID.Text + '%'' '
    + ' ORDER BY ����ʱ�� DESC, ListID ASC';
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
    ShowMessage('��ѡ��Ҫɾ���Ķ�����');
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
    ShowMessage('��ѡ��Ҫ�޸ĵĶ�����');
    Exit;
  end;
  strSQL := 'SELECT * FROM List WHERE ListID=''' + strNewID + '''' ;
  AQrySel(AQry1, strSQL);
  if AQry1.RecordCount > 0 then
  begin
    ShowMessage('�ñ���Ѵ��ڣ����������룡');
    Exit;
  end;
   for i :=0 to Length(S_TAB_NAME) - 1 do
  begin
    strSQL := 'UPDATE ' + S_TAB_NAME[i] + ' SET ListID=''' + strNewID + ''' WHERE ListID =''' + strOldID + '''; ' ;
    AQryCmd(AQry1, strSQL);
  end;
end;

//������ͬ����ͨ��ֵ
procedure TF_List.ReaddDefaultListInfo();
var
  strSQL : string;
begin
  strSQL := 'SELECT * FROM list WHERE ListID=''' + strListID + '''';
  AQrySel(AQry1, strSQL);

  strName         := FieldStr( AQry1 , '�ͻ�����'  ) ;     //�ͻ�����
  strPhone        := FieldStr( AQry1 , '��ϵ��ʽ'  ) ;     //��ϵ��ʽ
  strAddress      := FieldStr( AQry1 , '��װ��ַ'  ) ;     //��װ��ַ
  strSDate        := FieldStr( AQry1 , '��������'  ) ;     //��������
  strBod_Door     := FieldStr( AQry1 , '�Ű����'  ) ;     //�Ű����
  strBod_Body     := FieldStr( AQry1 , '��������') ;     //�������
  strBod_Back     := FieldStr( AQry1 , '�������'  ) ;     //�������
  strTabPrc       := FieldStr( AQry1 , '���۵�'    ) ;     //���۵�
  strTabPrd       := FieldStr( AQry1 , '����������') ;     //����������
  strTabPro       := FieldStr( AQry1 , '���ϼƻ���') ;     //���ϼƻ���
  strFBGY         := FieldStr( AQry1 , '��߹���'  ) ;     //��߹���

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
      if AQry1.RecordCount > 0 then ShowMessage('��ѡ�񶩵���')
      else ShowMessage('�뵼�붩����');
      Exit;
    end
    else
    begin
      F_Prt.ExeBodCount();
      ReaddDefaultListInfo();
    end;
  end;

  //���ر���Ĭ�ϲ���
  ReadIniFile();
  F_Prt_Opt.LoadListInfo();

  case tag of
    0:
    begin
      ListRefresh();
    end;
    101:
    begin
      //��ӡ��ǩ
      EnterMethod('��ӡ��ǩ');

      //��ȡ�������
      ReadBodDataFromDB();
      {ReadhdwDataFromDB();

      //�������������
      Stat_BodAreaPrc();
      Stat_hdwPrc(); //}
      Stat_BodLab();
      {$IFDEF v1_72}
      F_Prt_LabIII.ShowModal;
      {$ENDIF}
      {$IFDEF v1_71}
      F_Prt_Lab.ShowModal;
      {$ENDIF}
      ExitMethod('��ӡ��ǩ');
    end;
    102:
    begin
      //����������
      EnterMethod('����������');

      {//��ȡ�������
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //��ȡ���ʼ۸�
      ReadCZhPrc();

      //�������������
      Stat_BodAreaPrc();
      Stat_hdwPrc();

      //��ȡ����Ӽ۹�ʽ�����
      ReadTsPrc();

      //ͳ����������������
      Stat_BodPrd();

      F_Prt_Prd2.ShowModal;   }
      F_Prt_PrdIV.ShowModal;
      {ExeBoardPrice();
      F_Prt_Prd.RvSystem1.Execute;}
      ExitMethod('����������');
    end;
    103:
    begin
      //���ϼƻ���
      F_Prt_Proj2.btn1.Click;
    end;
    104:
    begin
      //_____________________________��ӡ���۵�_________________________________

      //��ȡ�������
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //��ȡ���ʼ۸�
      ReadCZhPrc();

      //����۸�
      Stat_BodAreaPrc();
      Stat_hdwPrc();
      
      //��ȡ����Ӽ۹�ʽ�����
      ReadTsPrc();

      //ͳ�Ƽ۸�
      F_Prt_Prc2.RvSystem1.Execute;
    end;
    105:
    begin
      //��ȡ�������
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //��ȡ���ʼ۸�
      ReadCZhPrc();

      //����۸�
      Stat_BodAreaPrc();
      Stat_hdwPrc();

      //����Excel
      F_Prt.OutputExcel();
    end;
    106:
    begin
      //����TXT
      F_Prt.OutputTXT();
    end;
    107:  //���װ��ǩ
    begin
      //��ȡ�������
      ReadBodDataFromDB();
      ReadhdwDataFromDB();

      //��ʾ��ӡ���ý���
      f_Prt_OutPacking_showModal;
    end;
    108:    //�༭������ϸ
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
    ShowMessage('��ѡ��Ҫ�޸ĵĶ�����');
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
    //�޸Ķ�����
    100:
    begin
      if strListID = '' then
      begin
        ShowMessage('��ѡ��Ҫ�޸ĵĶ�����');
        Exit;
      end;

      strNewListID := InputBox('�޸Ķ�����', '�����¶�����', strListID );
      if strNewListID = '' then
      begin
        ShowMessage('�����Ų���Ϊ�գ�');
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
        ShowMessage('��ѡ��Ҫ�޸ĵĶ�����');
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
        ShowMessage('��ѡ��Ҫɾ���Ķ�����');
        Exit;
      end;

      if MessageDlg('ȷ��Ҫɾ������[' + AQry2.FieldValues['�������'] + ']��',
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

    //��������
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
  strListID := AQry2.FieldValues['�������'];
  List.strListID := AQry2.FieldValues['�������'];

  AQrySel(F_Prt.ADOQry_List, 'SELECT * FROM List WHERE ListID=''' + List.strListID + '''');
end;

end.




