unit U_Prt;

interface

//1.72b 2013-04-11 �������������ؼ۸���Ϣ
//1.72  2013-04-02 ����fastReport��ӡ��ǩ�����װ�Ĺ���

{$DEFINE v1_72}       //1.71 ʹ��raveReport��ӡ��ǩ���ϲ��Ű��ǩ�ͱ����ǩ

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, ADODB, ExcelXP, OleServer, U_Reg,
  U_Price, ComObj, U_RegI, U_Prt_Edit, UDebug, UADO,
  U_Prt_Opt, Clipbrd, U_Debug, ExtCtrls,
  OleCtrls, UParam, UPub, U_List, U_Flash, DateUtils,
  IniFiles, UList, CnClasses, CnSkinMagic,
  WinSkinData, RzPanel, RzSplit, frxDesgn, frxClass, RzGroupBar, frxDBSet,
  U_List_Standard, U_List_Bod, U_Prt_Prd_Opt;

procedure showForm(form1: TForm);

type
  TF_Prt = class(TForm)
    ExcelApp1: TExcelApplication;
    ExcelWorkbook1: TExcelWorkbook;
    OpenDialog1: TOpenDialog;
    dlgSave1: TSaveDialog;
    qry1: TADOQuery;
    qry2: TADOQuery;
    qry3: TADOQuery;
    Panel1: TPanel;
    Panel3: TRzSizePanel;
    BtnLoadBoard: TButton;
    BtnOption: TButton;
    BtnSetPrice: TButton;
    BtnQuery: TButton;
    BtnQryDay: TButton;
    BtnQryMonth: TButton;
    btnPrtEdit: TButton;
    Panel2: TRzGroupBar;
    RzGroup1: TRzGroup;
    RzGroup2: TRzGroup;
    RzGroup3: TRzGroup;
    Splitter1: TSplitter;
    RzGroup4: TRzGroup;
    ADOQry_List: TADOQuery;
    frxDs_List: TfrxDBDataset;
    ADOQry_ListListID: TWideStringField;
    ADOQry_List��������: TWideStringField;
    ADOQry_List��װ��ַ: TWideStringField;
    ADOQry_List�Ű����: TWideStringField;
    ADOQry_List�������: TWideStringField;
    ADOQry_List��������: TWideStringField;
    ADOQry_List�ͻ�����: TWideStringField;
    ADOQry_List��ϵ��ʽ: TWideStringField;
    ADOQry_List�����С: TSmallintField;
    ADOQry_List����������: TWideStringField;
    ADOQry_List���ϼƻ���: TWideStringField;
    ADOQry_List���۵�: TWideStringField;
    ADOQry_List��ĺ��: TFloatField;
    ADOQry_List��߹���: TWideStringField;
    ADOQry_List����: TWideStringField;
    ADOQry_List����嵥��: TWideStringField;
    ADOQry_List�Ű嵥��: TWideStringField;
    ADOQry_List���嵥��: TWideStringField;
    ADOQry_List��������: TFloatField;
    ADOQry_List�Ű����: TFloatField;
    ADOQry_List�������: TFloatField;
    ADOQry_List�����۸�: TFloatField;
    ADOQry_List�Ű�۸�: TFloatField;
    ADOQry_List����۸�: TFloatField;
    ADOQry_List����۸�: TFloatField;
    ADOQry_List����ϼƽ��: TWideStringField;
    ADOQry_List���۸�: TFloatField;
    ADOQry_List����Ӽ�: TFloatField;
    ADOQry_List�ϼƽ��: TFloatField;
    ADOQry_List����ʱ��: TDateTimeField;
    procedure BtnLoadBoardClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOptionClick(Sender: TObject);
    procedure BtnSetPriceClick(Sender: TObject);
    procedure BtnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnQryDayClick(Sender: TObject);
    procedure BtnQryMonthClick(Sender: TObject);
    procedure btnPrtEditClick(Sender: TObject);
    procedure BtnClick(Sender: TObject);
    //function IsStrANumber(NumStr : string) : bool;
  private
    { Private declarations }
    function CheckXlsType( strXlsFile : string ) : Integer ;
    function LoadBodFromExcel( strXlsFile : string ) : Boolean ;
    function LoadHDWareFromExcel( strXlsFile : string ) : Boolean ;
  public
    { Public declarations }
    cStr1: string;
    procedure ExeBodCount();        //ͳ���ظ��������
    procedure CheckNewCZh();        //��۸�������TBod
    procedure CheckDodAndLS();      //�����˿�װ������

    procedure DeleteHistoryPic();   //ɾ����ʷ�۸��¼
    procedure SaveCZhToCab();       //������ʵ������б�
    procedure OpenFlash();
    procedure CloseFlash();
    procedure OutputExcel();
    procedure OutputTXT();
  end;

var
  F_Prt: TF_Prt;
  sql1, sql2, sql3, sql4: string;
  str1, str2, str3, str4: string;
  s0, s1, s2, s3, s4, s5, s6, s7: string;
  p, s_dbg: string;
  TemForm: TForm;
implementation

uses U_List_Import, U_Prt_PrdIV;

{$R *.dfm}

/// <summary>
/// �ж��Ƿ�Ϊ����
/// </summary>
/// <param name="NumStr"></param>
/// <returns></returns>
function IsStrANumber(NumStr: string): bool;
begin
  result := true;
  try
    StrToInt(NumStr);
  except
    result := false;
  end;
end;

procedure showForm(form1: TForm);
begin
  SetFormParent(form1, F_Prt.Panel1);

  TemForm.Hide;
  TemForm := form1;
  TemForm.Show;
end;

/// <summary>
/// ������ͳ�ư������
/// </summary>
procedure TF_Prt.ExeBodCount();
var
  strSQL : string ;
  strBodCount : string ;
  i : Integer ;
  ado1: TADO;
begin
  ado1 := TADO.Create(nil);
  //_________________������ͳ�ư������_________________
  strSQL := 'DELETE FROM BoardSum WHERE ListID=''' + strListID + '''';
  AQryCmd(qry1, strSQL ) ;

  strSQL := 'SELECT sum(����) AS Num, BodName FROM TBod WHERE ListID='''+ strListID +''' GROUP BY BodName;';
  AQrySel(qry1, strSQL);

  for i := 0 to qry1.RecordCount - 1 do
  begin
    strSQL := 'INSERT INTO BoardSum VALUES('+ FieldStr(qry1,'Num') +','''+ FieldStr(qry1,'BodName') +''','''+ strListID +''')';
    AQryCmd(qry2, strSQL);
    qry1.Next;

  end;

  //___________________ͳ���ظ������__________________

  strSQL := 'SELECT * FROM TBod WHERE ListID=''' + strListID + '''';
  AQrySel( qry1 , strSQL ) ;
  for i := 0 to qry1.RecordCount - 1 do
  begin
    strSQL := 'SELECT sum(����) AS BodCount FROM TBod '
    + 'WHERE ����  = '  + FieldStr( qry1 , '����' ) + '  '
    + 'AND   ���  = '  + FieldStr( qry1 , '���' ) + '  '
    + 'AND   ����  =''' + FieldStr( qry1 , '����' ) + ''' '
    + 'AND   ListID=''' + strListID                 + '''' ;
    ado1.Sel(strSQL) ;
    strBodCount := ItoS(ado1.Fi('BodCount')) ;

    strSQL := 'Update TBod SET BodCount=' + strBodCount + ' WHERE ID=' + FieldStr(qry1 , 'ID' ) ;
    AQryCmd( qry2 , strSQL);
    qry1.Next;
  end;
  ado1.Free;
end;

/// <summary>
/// ��۸��������²���
/// </summary>
procedure TF_Prt.CheckNewCZh();
var
  s1: string;
  strSQL : string;
  i: Integer;
begin
    //��۸���������TBod
  with F_Prt do
  begin
    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhDoor + '''';
    if AQrySel(qry1, strSQL) = 0 then
    begin
      strSQL := 'INSERT Into TPrice(Nam,Unt,Type) VALUES(''' + List.CZhDoor + ''','''',1)';
      AQryCmd(qry1, strSQL);
    end;

    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhBody + '''';
    if AQrySel(qry1, strSQL) = 0 then
    begin
      strSQL := 'INSERT Into TPrice(Nam,Unt,Type) VALUES(''' + List.CZhBody + ''','''',1)';
      AQryCmd(qry1, strSQL);
    end;

    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhBack + '''';
    if AQrySel(qry1, strSQL) = 0 then
    begin
      strSQL := 'INSERT Into TPrice(Nam,Unt,Type) VALUES(''' + List.CZhBack + ''','''',1)';
      AQryCmd(qry1, strSQL);
    end;
    {sql := 'SELECT Distinct( ���� ) AS CZName FROM TBod WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    for i := 1 to qry1.RecordCount - 1 do
    begin
      s1 := qry1.FieldValues['CZName'];
      sql := 'SELECT * FROM TPrice WHERE Type=1 AND nam = ''' + s1 + '''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      if qry2.RecordCount = 0 then
      begin
        qry2.Edit;
        qry2.Append;
        qry2.FieldValues['nam'] := s1;
        qry2.FieldValues['unt'] := ' ';
        qry2.FieldValues['Type'] := 1;
        qry2.Post;
      end;
      qry1.Next;
    end;}

    strSQL := 'SELECT Distinct( Nam ) AS HDName FROM THDWare WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    for i := 1 to qry1.RecordCount - 1 do
    begin
      s1 := qry1.FieldValues['HDName'];
      strSQL := 'SELECT * FROM TPrice WHERE Type=2 AND nam = ''' + s1 + '''';
      qry2.SQL.Clear;
      qry2.SQL.Add(strSQL);
      qry2.Open;
      if qry2.RecordCount = 0 then
      begin
        qry2.Edit;
        qry2.Append;
        qry2.FieldValues['nam'] := s1;
        qry2.FieldValues['unt'] := ' ';
        qry2.FieldValues['Type'] := 2;
        qry2.Post;
      end;
      qry1.Next;
    end;
  end;
end;



/// <summary>
/// �Ű壬���壬����塪������
/// </summary>
procedure TF_Prt.SaveCZhToCab();
var
  s_sql : string;
  s_cz_bb, s_cz_mb, s_cz_gtb: string; //�Ű壬���壬����塪������
begin
      //__________________________ͳ�Ʋ���__________________________________
    s_sql := 'SELECT TOP 1 ���� FROM TBod WHERE BodName LIKE ''�Ű�'' AND ListID=''' + strListID + '''';
    AQrySel( qry1 , s_sql);
    try
      s_cz_mb := qry1.FieldValues['����'];
    except
      s_cz_mb := ' ';
    end;


    s_sql := 'SELECT TOP 1 ���� FROM TBod WHERE BodName LIKE ''����'' AND ListID=''' + strListID + '''';
    AQrySel( qry1 , s_sql);
    try
      s_cz_bb := qry1.FieldValues['����'];
    except
      s_cz_bb := ' ';
    end;


    s_sql := 'SELECT TOP 1 ���� FROM TBod WHERE BodName LIKE ''���'' AND ListID=''' + strListID + '''';
    AQrySel( qry1 , s_sql);
    try
      s_cz_gtb := qry1.FieldValues['����'];
    except
      s_cz_gtb := ' ';
    end;


    s_sql := 'SELECT * FROM list WHERE ListID=''' + strListID + '''';
    AQrySel( qry1 , s_sql);
    qry1.Edit;
    qry1.FieldValues['�Ű����']    := s_cz_mb;
    qry1.FieldValues['�������']    := s_cz_bb;
    qry1.FieldValues['��������']  := s_cz_gtb;
    qry1.Post;

end;

/// <summary>
/// �����˿�װ�����Ͻ�����
/// </summary>
procedure TF_Prt.CheckDodAndLS();
var
  i: Integer;
begin
  //�����˿�װ�����Ͻ�����
  with F_Prt do
  begin
    sql := 'SELECT * FROM TBod';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    for i := 1 to qry1.RecordCount do
    begin
      qry1.Edit;
      qry1.FieldValues['nam3'] := ' ';
      qry1.FieldValues['���'] := '0';
      qry1.Post;
      qry1.Next;
    end;

    //�Ƿ�����˿�װ�
    sql := 'SELECT * FROM TOption WHERE ���� LIKE ''��˿�װ�'' AND v3=1';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      sql := 'SELECT * FROM TBod WHERE (��; LIKE ''%sc%'' OR ��; LIKE ''%ˮ��%'')'
        + ' AND BodName LIKE ''�װ�'' ';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      if qry1.RecordCount > 0 then
      begin
        for i := 1 to qry1.RecordCount do
        begin
          qry1.Edit;
          qry1.FieldValues['nam3'] := '��˿�װ�';
          qry1.FieldValues['���'] := '1';
          qry1.Post;
          qry1.Next;
        end;
      end;
    end;

    //�Ƿ������Ͻ�����
    sql := 'SELECT * FROM TBod WHERE (��; LIKE ''%sc%'' OR ��; LIKE ''%ˮ��%'')'
      + ' AND ���� LIKE ''%���Ͻ�%'' AND BodName LIKE ''%����''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      for i := 1 to qry1.RecordCount do
      begin
        qry1.Edit;
        qry1.FieldValues['nam3'] := '���Ͻ�';
        qry1.FieldValues['���'] := '1';
        qry1.Post;
        qry1.Next;
      end;
    end;
  end;
end;

/// <summary>
/// ɾ���۸�ͳ������
/// </summary>
procedure TF_Prt.DeleteHistoryPic();
begin
  with F_Prt do
  begin
    sql := 'DELETE FROM prclist1 WHERE ListID=''' + strListID + '''';
    AQryCmd( qry1, sql);
    sql := 'DELETE FROM prclist2 WHERE ListID=''' + strListID + '''';
    AQryCmd( qry1 , sql);
    sql := 'DELETE FROM prclist3 WHERE ListID=''' + strListID + '''';
    AQryCmd( qry1 , sql);
    sql := 'DELETE FROM HDWareSum WHERE ListID=''' + strListID + '''';
    AQryCmd( qry1 , sql);
  end;
end;

/// <summary>
/// ѹ�����ݿ�
/// </summary>
procedure zip1;
var
  dao: OleVariant;
begin
  dao := CreateOleObject('DAO.DBEngine.35');
  dao.CompactDatabase(AppPath + 'dat2.mdb',
    AppPath + 'tem.mdb');
end;

/// <summary>
/// �ж��ǰ�����ݡ�������ݻ���������
/// </summary>
/// <param name="strXlsFile"></param>
/// <returns></returns>
function TF_Prt.CheckXlsType( strXlsFile : string ) : Integer ;
var
  strTem : string ;
begin
  Result := IS_OTHERFILE ;
  try
    ExcelApp1.Connect;
  except
    MessageDlg('û�а�װExcel', mtError, [mbOk], 0);
    Abort;
    Exit ;
  end;

  ExcelApp1.Caption := 'Excel Application';
  ExcelApp1.Workbooks.Open(strXlsFile, null, null, null, null, null,
    null, null, null, null, null, null, null, null, null, 0);


  strTem := ExcelApp1.Cells.Item[1, 2];
  if ( strTem = '�� ��' ) OR ( strTem = '����' ) then Result := IS_BODFILE
  else if ( strTem = '��������' )                then Result := IS_HDWAREFILE
  else                                                Result := IS_OTHERFILE ;

  ExcelWorkbook1.Disconnect;
  ExcelApp1.Quit;

end;

/// <summary>
/// ��EXCEL�ļ�����������
/// </summary>
/// <param name="strXlsFile"></param>
/// <returns></returns>
function TF_Prt.LoadBodFromExcel( strXlsFile : string ) : Boolean ;
var
  strSQL: string;
  strTem : string ;
  i, j : Integer;
	CabIndex : Integer;
  BodIndex : Integer;
  BodID : Integer;
	strW_H_D , strCabInfo : string;
  strCabTabID : string;
  strOth , strCabType , strCabName , strBodName , strInfo1 : string;
  Date_Input : TDate;
begin

  try
    ExcelApp1.Connect;
  except
    MessageDlg('û�а�װExcel', mtError, [mbOk], 0);
    Abort;
    Result := False ;
    Exit ;
  end;

  //ExcelApp1.Visible[0]:=True;
  ExcelApp1.Caption := 'Excel Application';
  ExcelApp1.Workbooks.Open(strXlsFile, null, null, null, null, null,
    null, null, null, null, null, null, null, null, null, 0);

  {�������:DD20081219-1 ��������:2008-12-19 ��װ��ַ:���ͺ���}
  strTem := ExcelApp1.Cells.Item[2, 2];
  if Pos('��������', strTem) = 0 then
  begin
    ShowMessage('Excel�ļ���ʽ����ȷ��������ѡ��~');
    Result := False ;
    PbHide();
    Exit;
  end
  else
    Result := True ;

  if BoolFName then strListID := CopyStrBetween(UpperCase(ExtractFileName(strXlsFile)), '', '.XLS')
  else strListID := CopyStrBetween(strTem, '�������:', ' ��������:');
  strSDate := CopyStrBetween(strTem, '��������:', ' ��װ��ַ');
  Date_Input := StrToDate(strSDate);
  for i := 0 to IntAddYear - 1 do
    Date_Input := IncYear(Date_Input, 1);
  strSDate := DateToStr(Date_Input);
  strAddress := CopyStrBetween(strTem, '��װ��ַ:', ' ');

  //ɾ����������ͬ�����ж���
  F_List.ListDelete( strListID ) ;

  strSQL := 'SELECT * FROM list WHERE ListID LIKE ''' + strListID + '''';
  AQrySel(qry3, strSQL);
  qry3.Edit;
  qry3.Append;
  qry3.FieldValues['ListID']     := strListID;
  qry3.FieldValues['��������']   := strSDate;
  qry3.FieldValues['��װ��ַ']   := strAddress;
  qry3.FieldValues['����������'] := strTabPrd;
  qry3.FieldValues['���ϼƻ���'] := strTabPro;
  qry3.FieldValues['���۵�']     := strTabPrc;
  qry3.FieldValues['��ĺ��']   := IntToStr( IntBodD ) ;
  qry3.Post;


  CabIndex := 0;
  BodIndex := 0;
  j := 3;
  BodID := 0;
  s0 := ExcelApp1.Cells.Item[j, 1];
  while s0 <> '' do
  begin
    //���col2Ϊ��*��*�ߣ������Ϊ��
    if VarToStr(ExcelApp1.Cells.Item[j, 3]) = '' then
    begin
      {330*650*270
      �Ǳ��:A�����¹�16�и� ����:1}
      strW_H_D := ExcelApp1.Cells.Item[j, 2];
      strCabInfo := ExcelApp1.Cells.Item[j, 4];

      strCabinetID := s0;
      strW := CopyStrBetween(strW_H_D, '', '*');
      strH := CopyStrBetween(strW_H_D, '*', '*');
      strD := CopyStrBetween(strW_H_D, 2, '*', '');
      strStandard := CopyStrBetween(strCabInfo, '', '*');
      strCabinet := CopyStrBetween(strCabInfo, '�Ǳ��:', ' ����');
      strNumber := CopyStrBetween(strCabInfo, '����:', '');
      Inc(CabIndex);

      strSQL := 'INSERT INTO TCab('
      + 'CabID , '
      + '�ߴ� , '
      + 'oth , '
      + 'ListID , '
      + 'Nam , '
      + 'CabIndex , '
      + 'H , '
      + 'W , '
      + 'L , '
      + 'N  '
      + ') VALUES('
      + '''' + strCabinetID + ''' , '
      + '''' + strW_H_D + ''' , '
      + '''' + strCabInfo + ''' , '
      + '''' + strListID + ''' , '
      + '''' + strCabinet + ''' , '
      + IntToStr(CabIndex) + ' , '
      + strH + ' , '  				    //��
      + strW + ' , ' 					    //��
      + strD + ' , ' 					    //��
      + strNumber + ' ) ';   	    //����
      AQryCmd(qry3,strSQL);

      strSQL := 'UPDATE TCab SET C_W = W * N WHERE ListID=''' + strListID + '''' ;
      AQryCmd(qry3,strSQL);


      BodID := 0;
      strSQL := 'SELECT Max(id) AS MaxID FROM TCab ';
      AQrySel(qry3, strSQL );
      strCabTabID := FieldStr( qry3 , 'MaxID' ) ;

    end
    else
    begin
      //____________�����ҵع�.ú��ƿ��.���װ�(��2�߿�)________________
      strOth := VarToStr( ExcelApp1.Cells.Item[j, 7] ) ;
      strCabType  := CopyStrBetween(strOth , '' , '.' );
      strCabName  := CopyStrBetween(strOth , '.' , '.' );
      strBodName  := CopyStrBetween(strOth , 2 , '.' , '(' );
      strInfo1     := CopyStrBetween(strOth , '(' , ')' );

      Inc(BodIndex);
      Inc(BodID);

      strSQL := 'INSERT into TBod ('
      + 'BodIndex , '
      + 'CabIndex , '
      + 'BodID , '
      + 'CabTabID , '
      + 'CabID , '
      + 'BodName , '
      + 'nam2 , '
      + '��; , '
      + '���� , '
      + 'CabWHD , '
      + '��� , '
      + '���� , '
      + '��� , '
      + '���� , '
      + '��ת , '
      + '���� , '
      + '��ע , '
      + 'ͼ�� , '
      + '��� , '
      + 'ListID '
      + ') VALUES( '
      + IntToStr(BodIndex) + ' , '
      + IntToStr(CabIndex) + ' , '
      + IntToStr(BodID) + ' , '
      + strCabTabID + ' , '
      + '''' + strCabinetID  + ''' , '
      + '''' + strBodName    + ''' , '
      + '''' + strCabType    + ''' , '
      + '''' + strCabName    + ''' , '
      + '''' + strInfo1      + ''' , '
      + '''' + strW_H_D      + ''' , '
      +       VarToStr( ExcelApp1.Cells.Item[j, 1] ) + '  , '
      +       VarToStr( ExcelApp1.Cells.Item[j, 2] ) + '  , '
      +       VarToStr( ExcelApp1.Cells.Item[j, 3] ) + '  , '
      +       VarToStr( ExcelApp1.Cells.Item[j, 4] ) + '  , '
      + '''' + VarToStr( ExcelApp1.Cells.Item[j, 5] ) + ''' , '
      + '''' + VarToStr( ExcelApp1.Cells.Item[j, 6] ) + ''' , '
      + '''' + VarToStr( ExcelApp1.Cells.Item[j, 7] ) + ''' , '
      + '''' + VarToStr( ExcelApp1.Cells.Item[j, 8] ) + ''' , '
      + '0 , '
      + '''' + strListID + ''' ) ' ;
      AQryCmd(qry3, strSQL);


    end;
    j := j + 1;
    s0 := ExcelApp1.Cells.Item[j, 1];
  end;

  ExcelWorkbook1.Disconnect;
  ExcelApp1.Quit;



end;

/// <summary>
/// �����������
/// </summary>
/// <param name="strXlsFile"></param>
/// <returns></returns>
function TF_Prt.LoadHDWareFromExcel( strXlsFile : string ) : Boolean ;
var
  strSQL : string ;
  strTem , strCabID , strCabNum : string;
  strCabTabID : string ;
  i , j : Integer ;
  Date_Input : TDate;
begin
  //�����������
  Result := False;
  try
    ExcelApp1.Connect;
  except
    MessageDlg('û�а�װExcel', mtError, [mbOk], 0);
    Abort;
    Result := False ;
    Exit ;
  end;
  try
    ExcelApp1.Caption := 'Excel Application';
    ExcelApp1.Workbooks.Open(strXlsFile, null, null, null, null, null,
      null, null, null, null, null, null, null, null, null, 0);

    strTem := ExcelApp1.Cells.Item[2, 1];
    if Pos('��������', strTem) = 0 then
    begin
      ShowMessage('Excel�ļ���ʽ����ȷ��������ѡ��~');
      Result := False ;
      Exit;
    end
    else
      Result := True;

    {�������:DD20081219-1 ��������:2008-12-19 ��װ��ַ:���ͺ���}

    if BoolFName then strListID := CopyStrBetween(UpperCase(ExtractFileName(strXlsFile)), '', 'WJ.XLS')
    else strListID := CopyStrBetween(strTem, '�������:', ' ��������:');
    strSDate := CopyStrBetween(strTem, '��������:', ' ��װ��ַ');
    Date_Input := StrToDate(strSDate);
    for i := 0 to IntAddYear - 1 do
      Date_Input := IncYear(Date_Input, 1);
    strSDate := DateToStr(Date_Input);
    strAddress := CopyStrBetween(strTem, '��װ��ַ:', ' ');

    strSQL := 'DELETE FROM THDWare WHERE ListID=''' + strListID + '''';
    AQryCmd( qry3 , strSQL ) ;

    strSQL := 'SELECT * FROM List WHERE ListID=''' + strListID + '''';
    AQrySel( qry3 , strSQL ) ;
    if qry3.RecordCount = 0 then
    begin
      ShowMessage('���ȵ��������ݻ�ѡ����ȷ�������ļ�~');
      Exit;
    end;

    i := 0;
    j := 3;
    strCabID := ExcelApp1.Cells.Item[j, 1];
    while strCabID <> '' do
    begin
      strTem := VarToStr( ExcelApp1.Cells.Item[j, 3] ) ;
      if strTem = '' then
      begin
        strSQL := 'SELECT TOP 1 * FROM TCab WHERE CabID = ''' + strCabID + ''' AND ListID=''' + strListID + '''';
        AQrySel( qry3 , strSQL ) ;
        if qry3.RecordCount > 0 then
        begin
          strCabNum := FieldStr( qry3 , 'N' ) ;
          strCabTabID := FieldStr( qry3 , 'ID' ) ;
        end;
        if strCabID = '' then strCabID := '0' ;
      end
      else
      begin
        Inc( i ) ;
        strSQL := 'SELECT TOP 1 * FROM THDWare';
        AQrySel( qry3 , strSQL ) ;
        qry3.Edit;
        qry3.Append;
        qry3.FieldValues['ListID'] := strListID ;
        qry3.FieldValues['HDIndex'] := IntToStr( i ) ;
        qry3.FieldValues['CabTabID'] := strCabTabID;
        qry3.FieldValues['ͼ��'] := ExcelApp1.Cells.Item[j, 1];
        qry3.FieldValues['nam'] := ExcelApp1.Cells.Item[j, 2];
        qry3.FieldValues['����'] := ExcelApp1.Cells.Item[j, 3];
        qry3.FieldValues['oth'] := ExcelApp1.Cells.Item[j, 5];
        qry3.FieldValues['����'] := ExcelApp1.Cells.Item[j, 6];
        qry3.FieldValues['N'] := strCabNum;
        qry3.Post;
      end;
      j := j + 1;
      strCabID := ExcelApp1.Cells.Item[j, 1];
    end;

    ExcelWorkbook1.Disconnect;
    ExcelApp1.Quit;
    CheckNewCZh();
    DeleteHistoryPic();
    Result := True;
  except
    on e: Exception do
    begin
      Result := False;
      ShowMessage(e.Message);
    end;
  end;
end;

/// <summary>
/// ����excel����
/// </summary>
/// <param name="Sender"></param>
procedure TF_Prt.BtnLoadBoardClick(Sender: TObject);
var
  strXlsFile : string ;
begin

  OpenDialog1.InitialDir := Application.ExeName;
  OpenDialog1.Filter := 'Excel�ļ�(*.xls)|*.xls';
  if OpenDialog1.Execute then
    strXlsFile := OpenDialog1.FileName
  else
  begin
    Exit;
  end;

  case CheckXlsType( strXlsFile ) of
    0 :
    begin
      PbShow();
      //______________________����Ĭ�ϱ������______________________________
      F_Prt_Opt.LoadListInfo();

      //____________________��EXCEL�ļ�����������_________________________
      //if not LoadBodFromExcel(strXlsFile) then Exit;
      if not ReadBodDataFromXLS(strXlsFile) then Exit;

      SaveBodDataToDB();
      SaveCZhDataToDB();

      //_________________________ͳ�ư��___________________________________
      ExeBodCount();


      //ͳ������������۸�
      //Stat_BodAreaPrc();

      //CheckNewCZh();


      //_____________________ɾ�����ڼ۸�����_______________________________
      //DeleteHistoryPic();


      //__________________________�������__________________________________
      //SaveCZhToCab();


      PbHide();
      F_List.ListRefreshAll();
    end;
    1 :
    begin
      //____________________��EXCEL�ļ������������________________________
      //if not LoadHDWareFromExcel( strXlsFile ) then Exit;
      if not ReadHDwDataFromXLS( strXlsFile ) then Exit;

      SaveHDwDataToDB();

    end;
    2 :
    begin
      ShowMessage('Excel�ļ���ʽ����ȷ��������ѡ��~');
    end;
  end;

end;

procedure TF_Prt.FormCreate(Sender: TObject);
begin

  //GetStrCon() :='Provider=SQLOLEDB.1;Password=sa;Persist Security Info=True;User ID=sa;Initial Catalog=DB_LAB;Data Source=JACKSPC';
  Panel3.Visible := False;

  qry1.Close;
  qry2.Close;
  qry3.Close;
  qry1.ConnectionString := getConStr();
  qry2.ConnectionString := getConStr();
  qry3.ConnectionString := getConStr();

  ADOQry_List.ConnectionString := getConStr();

  Width := 800 + 140;
  Height := 620;

  Panel1.Align := alClient;

{$IFDEF v1_71}
  btnPrtEdit.Visible := False;
{$ENDIF}

end;

procedure TF_Prt.BtnOptionClick(Sender: TObject);
begin
  F_Prt_Opt.LoadListInfo();
  showForm(F_Prt_Opt);
end;

//�༭����
procedure TF_Prt.btnPrtEditClick(Sender: TObject);
begin
  F_Prt_Edit.ShowModal;
end;

/// <summary>
/// ����txt
/// </summary>
procedure TF_Prt.OutputTXT();
var
  i, i1, i2: Integer;
  s, s1, s2, s3: string;
  sList : TStringList;
begin
  sList := TStringList.Create;
  sql := 'SELECT * FROM TBod WHERE ListID=''' + strListID + '''';
  qry3.SQL.Clear;
  qry3.SQL.Add(sql);
  qry3.Open;
  if qry3.RecordCount = 0 then
  begin
    ShowMessage('û�пɵ���������');
    Exit;
  end;
  i1 := 1;
  i2 := 1;
  s1 := qry3.FieldValues['id'];
  s2 := s1;
  for i := 1 to qry3.RecordCount do
  begin

    s1 := qry3.FieldValues['id'];
    if s1 <> s2 then
    begin
      i1 := i1 + 1;
      i2 := 1;
    end;
    s2 := s1;
    //R:������ת  N:��������ת
    if qry3.FieldValues['��ת'] = '��' then
      s3 := 'R'
    else
      s3 := 'N';
    s := s + FieldStr( qry3 , 'BodName' ) + VarToStr(i1) + '_'
      + VarToStr(i2) + #9;
    s := s + FieldStr( qry3 , '����' ) + #9;
    s := s + FieldStr( qry3 , '����' ) + #9;
    s := s + FieldStr( qry3 , '���' ) + #9 + s3 + #9;
    s := s + FieldStr( qry3 , '����' ) + #9 + 'R' + #9;
    //s := s + qry3.FieldValues['��ע'] + #9;
    sList.Add(s);
    s := '';
    i2 := i2 + 1;
    qry3.Next;
  end;
  dlgSave1.InitialDir := Application.ExeName;
  dlgSave1.DefaultExt := 'txt';
  dlgSave1.Filter := '�ı��ļ�(*.txt)|*.txt';
  dlgSave1.FileName := FormatDateTime('yyyy-mm-dd_hh-mm-ss', Now );
  if dlgSave1.Execute then
  begin
    sList.SaveToFile(dlgSave1.FileName);
  end;

end;

/// <summary>
/// ���ü۸�
/// </summary>
/// <param name="Sender"></param>
procedure TF_Prt.BtnSetPriceClick(Sender: TObject);
begin
  //�����TBod
  CheckNewCZh();
  showForm(F_Price);
end;

/// <summary>
/// ����excel
/// </summary>
procedure TF_Prt.OutputExcel();
var
  f: string;
  i, I_Row, I_Col: Integer;
  ColumnRange, RowRange: Variant;

begin
  //�����������

  try
    ExcelApp1.Connect;
  except
    MessageDlg('û�а�װExcel', mtError, [mbOk], 0);
    Abort;
  end;

  ExcelApp1.Caption := 'Excel Application';
  ExcelApp1.Visible[0] := False;
  ExcelApp1.DisplayAlerts[0] := false;
  ExcelWorkbook1.ConnectTo(ExcelApp1.Workbooks.Add(EmptyParam, 0));
  ExcelApp1.Columns.ColumnWidth := 10;
  ColumnRange := ExcelApp1.Columns;
  ColumnRange.Columns[2].ColumnWidth := 20;

  F_Prt_Opt.LoadListInfo();
  ExcelApp1.Cells.Item[1, 1] := strTabPrd;

  I_Row := 2; I_Col := 2;
  ExcelApp1.Cells.Item[I_Row, I_Col] := '����:';
  Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '''' + FormatDateTime('yy-mm-dd', Date);
  Inc(I_Col, 2);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '����:';
  Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := List.strListID;
  Inc(I_Col, 2);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '��ַ:';
  Inc(I_Row); I_Col := 2;
  ExcelApp1.Cells.Item[I_Row, I_Col] := '�绰:';
  Inc(I_Col, 3);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '����:';

  Inc(I_Row);
  Inc(I_Row); I_Col := 1;

  //_______________��ļ۸�___________________

  ExcelApp1.Cells.Item[I_Row, I_Col] := '���';           Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '����';           Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '���';           Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '����';           Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '���޸���';       Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '��������';     Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '�������';       Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '�Ű����';       Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '������';       Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '�Ű���';

  for i := 0 to Length(List.cab) - 1 do
  begin
    Inc(I_Row); I_Col := 1;

    ExcelApp1.Cells.Item[I_Row, I_Col] := IntToStr(List.cab[i].Index + 1);      Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := List.cab[i].cabName;                  Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := List.cab[i].cabW_H_D;                 Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := IntToStr(List.cab[i].cabNum);         Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := List.cab[i].cabGB;                    Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.cab[i].AreaBody, 3);        Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.cab[i].AreaBack, 3);        Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.cab[i].AreaDoor, 3);        Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.cab[i].PrcBack + List.cab[i].PrcBody, 2); Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.cab[i].PrcDoor, 2);

  end;

  Inc(I_Row);

      //___________________���۸�_______________________

  if Length(List.hdwPrc) > 0 then
  begin
    Inc(I_Row); I_Col := 1;

    ExcelApp1.Cells.Item[I_Row, I_Col] := '���'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := '����'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := '���'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := '����'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := 'Ҫ��'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := 'ͳ��'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := '����'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := '�۸�'; Inc(I_Col);
    ExcelApp1.Cells.Item[I_Row, I_Col] := '��ע';

    for i := 0 to Length(List.hdwPrc) - 1 do
    begin
      Inc(I_Row); I_Col := 1;

      ExcelApp1.Cells.Item[I_Row, I_Col] := IntToStr(List.hdwPrc[i].Index + 1); Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := List.hdwPrc[i].hdName; Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := ''; Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := IntToStr(List.hdwPrc[i].hdNum); Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := ''; Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := IntToStr(List.hdwPrc[i].hdNum); Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.hdwPrc[i].hdPrice, 2); Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.hdwPrc[i].hdSumPrice, 2); Inc(I_Col);
      ExcelApp1.Cells.Item[I_Row, I_Col] := '';

    end;
  end;
  Inc(I_Row);
  Inc(I_Row); I_Col := 1;

  ExcelApp1.Cells.Item[I_Row, I_Col] := '����������'; Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.AreaBody, 3) + 'ƽ��; '; Inc(I_Col); ;
  ExcelApp1.Cells.Item[I_Row, I_Col] := '���������'; Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.AreaBack, 3) + 'ƽ��; '; Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '�Ű������'; Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.AreaDoor, 3) + 'ƽ��; '; Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := '�ϼƽ�'; Inc(I_Col);
  ExcelApp1.Cells.Item[I_Row, I_Col] := StrN(List.SumPrcBod + List.SumPrcHD_ , 2) + 'Ԫ';

  //________________�����ļ�______________
  dlgSave1.InitialDir := Application.ExeName;
  dlgSave1.DefaultExt := 'txt';
  dlgSave1.Filter := 'Excel�ļ�(*.xls)|*.xls';
  dlgSave1.FileName := FormatDateTime('yyyy-mm-dd_hh-mm-ss', Now ) ;
  if dlgSave1.Execute then
  begin
    f := dlgSave1.FileName;
    ExcelWorkbook1.SaveCopyAs(f);
    showmessage('������ɹ���');
  end;
  ExcelWorkbook1.Close(false);
  ExcelWorkbook1.Disconnect;
  ExcelApp1.Quit;
  ExcelApp1.Disconnect;

end;

procedure TF_Prt.OpenFlash();
begin
  TemForm.Hide;
  TemForm := F_Flash;
  TemForm.Show;
end;

procedure TF_Prt.CloseFlash();
begin
  F_Flash.sfFlashPlayer1.StopPlay;
  F_Flash.Hide;
end;

/// <summary>
/// ��ӡ����
/// </summary>
/// <param name="Sender"></param>
procedure TF_Prt.BtnClick(Sender: TObject);
var
  i_btn     :Integer;
begin
  EnterMethod('��ӡ');
  if (Sender is TButton) then i_btn := (Sender as TButton).Tag;
  if (Sender is TRzGroupItem) then i_btn := (Sender as TRzGroupItem).Tag;
  send('tag=' + IntToStr(i_btn));

  if List.strListID <> '' then
  begin
    ADOQry_List.Close;
    ADOQry_List.SQL.Clear;
    ADOQry_List.SQL.Add('SELECT * FROM List WHERE ListID=''' + List.strListID + '''');
    ADOQry_List.Open;
  end;
  
  case i_btn of
    101:
    begin
      TemForm.Hide;
      TemForm := F_List_Import;
      TemForm.Show;
    end;
    203:
    begin
      showForm(F_List_Standard);                                                //��׼������
    end;
    204:
    begin
      showForm(F_Prt_Prd_Opt);                                                  //������������
    end;
    401:
    begin
      F_List.BtnPrintLabel.Click;                                               //��ӡ����
    end;
    402:
    begin
      F_List.btnBox.Click;                                                      //���װ��ǩ
    end;
    403:
    begin
      //F_List.btnMake.Click;                                                     //����������
      f_Prt_PrdIV.show;
    end;
    404:
    begin
      F_List.btnProject.Click;                                                  //���ϼƻ���
    end;
    405:
    begin
      F_List.btnPrice.Click;                                                    //���۵�
    end;
    406:
    begin                                                                       //�༭����
      F_Prt_Edit.ShowModal;
    end;
  end;
  ExitMethod('��ӡ');
end;

procedure TF_Prt.BtnQueryClick(Sender: TObject);
begin
  TemForm.Hide;
  TemForm := F_List;
  TemForm.Show;
  F_List.ListRefreshAll();
end;

procedure TF_Prt.FormShow(Sender: TObject);
var
  IniFile : TIniFile;
  B_Bug : Boolean;
begin
  //D_ADO.AQry1.ConnectionString := getConStr();
  IniFile := TIniFile.Create(AppPath + KEY_FILENAME);
  B_Bug := StrToBool(IniFile.ReadString('Debug','Show','False'));
  if B_Bug then F_Debug.Show;

  SetFormParent(F_Flash,        Panel1);
  SetFormParent(F_Prt_Opt,      Panel1);
  SetFormParent(F_List,         Panel1);
  SetFormParent(F_Price,        Panel1);
  SetFormParent(F_List_Import,  Panel1);
  //��ʾFlash
  TemForm := TForm.Create(nil);
  TemForm := F_Flash;
  TemForm.Show;

end;

procedure TF_Prt.BtnQryDayClick(Sender: TObject);
begin
  TemForm.Hide;
  TemForm := F_List;
  TemForm.Show;
  F_List.MItemQryDay.Click;
end;

procedure TF_Prt.BtnQryMonthClick(Sender: TObject);
begin
  TemForm.Hide;
  TemForm := F_List;
  TemForm.Show;
  F_List.MItemQryMonth.Click;
end;

end.

































