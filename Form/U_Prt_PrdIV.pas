unit U_Prt_PrdIV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frxClass, UParam, UList, frxDBSet, DB, ADODB, UDebug,
  UPub, IniFiles, UADO, UFReport;

function  get_PrdIV_Sql(i_typ: Integer): string;
procedure get_PrdIV_Ds(); overload;
procedure get_PrdIV_Ds(i_typ: Integer); overload;

{$REGION '窗口控件与变量'}
type
  TF_Prt_PrdIV = class(TForm)
    btnPrt: TButton;
    frxrpt1: TfrxReport;
    ADOQry1: TADOQuery;
    frxDs1: TfrxDBDataset;
    ADOQry2: TADOQuery;
    frxDs2: TfrxDBDataset;
    ADOQry3: TADOQuery;
    frxDs3: TfrxDBDataset;
    ADOQry4: TADOQuery;
    frxDs4: TfrxDBDataset;
    btnPrtDoor: TButton;
    ADOQry5: TADOQuery;
    frxDs5: TfrxDBDataset;
    ADOQry6: TADOQuery;
    frxDs6: TfrxDBDataset;
    btnPrtDoorAl: TButton;
    ADOQry7: TADOQuery;
    frxDs7: TfrxDBDataset;
    ADOQry8: TADOQuery;
    frxDs8: TfrxDBDataset;
    ADOQry9: TADOQuery;
    frxDs9: TfrxDBDataset;
    ADOQry10: TADOQuery;
    frxDs10: TfrxDBDataset;
    ADOQry11: TADOQuery;
    frxDs11: TfrxDBDataset;
    ADOQry12: TADOQuery;
    frxDs12: TfrxDBDataset;
    ADOQry13: TADOQuery;
    frxDs13: TfrxDBDataset;
    frxUDs1: TfrxUserDataSet;
    frxUDs2: TfrxUserDataSet;
    frxUDs3: TfrxUserDataSet;
    procedure FormCreate(Sender: TObject);
    procedure btnPrtClick(Sender: TObject);
    procedure btnPrtDoorClick(Sender: TObject);
    procedure btnPrtDoorAlClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
{$ENDREGION}
var
  F_Prt_PrdIV: TF_Prt_PrdIV;
  i_index: Integer;

implementation

{$R *.dfm}

/// <summary>
/// 返回生产制作单sql语句
/// </summary>
/// <param name="i_typ">0.全部;1.下柜;2.上柜;3.另加板;4.抽屉;5.门板(All);6.门板(地柜);7.门板(上柜);8.铝框门(All);9.铝框门(下);10.铝框门(上)</param>
/// <returns></returns>
function get_PrdIV_Sql(i_typ: Integer): string;
var
  i,j,k: Integer;
  strSQL: string;
  AQry1: TADOQuery;
  iniFile: TIniFile;
  strName, strCode: TStrings;
  strDrawerName, strDrawerCode: TStrings;
  strType: string;
  strDrawer: string;
  i_Len: Integer;
  s1:string;
begin
  EnterMethod('统计生产制作单');

  try
    AQry1 := TADOQuery.Create(nil);
    AQry1.ConnectionString := getConStr();

    {$REGION '读取配置'}
    iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

    s1 := iniFile.ReadString('PrdOpt', 'Field_Name', '');
    s1 := StringReplace(s1, ' ', '', [rfReplaceAll]);
    strName := TStringList.Create;
    strName.Delimiter := ';';
    strName.DelimitedText := s1;

    s1 := iniFile.ReadString('PrdOpt', 'Field_Code', '');
    s1 := StringReplace(s1, ' ', '', [rfReplaceAll]);
    strCode := TStringList.Create;
    strCode.Delimiter := ';';
    strCode.DelimitedText := s1;

    s1 := iniFile.ReadString('PrdOpt', 'Field_Drawer_Name', '');
    s1 := StringReplace(s1, ' ', '', [rfReplaceAll]);
    strDrawerName := TStringList.Create;
    strDrawerName.Delimiter := ';';
    strDrawerName.DelimitedText := s1;

    s1 := iniFile.ReadString('PrdOpt', 'Field_Drawer_Code', '');
    s1 := StringReplace(s1, ' ', '', [rfReplaceAll]);
    strDrawerCode := TStringList.Create;
    strDrawerCode.Delimiter := ';';
    strDrawerCode.DelimitedText := s1;

    strType   := iniFile.ReadString('PrdOpt', 'Field_Type', '');
    strDrawer := iniFile.ReadString('PrdOpt', 'Field_Drawer', '');

    iniFile.Free;

    {$ENDREGION}

    {$REGION '上柜 下柜 0,1,2'}
    i_Len := strName.Count;
    if (i_typ = 0) or (i_typ = 1) or (i_typ = 2) then
    begin

      strSQL := 'select A.ListID, A.Nam, A.CabIndex, A.H AS 高, A.W AS 宽, A.L AS 深, A.N AS 数量 ';

      for i := 0 to i_Len - 1 do
      begin
        s1 := 'B' + IntToStr(i);
        strSQL := strSQL + ', ' + crlf
          + 'IIF(ISNULL('+s1+'.宽度),'''',CStr('+s1+'.宽度 ) + ''*'' + CStr('+s1+'.长度 )+''*'' + CStr('+s1+'.数量)) AS ' + strName[i] +', '
          + 'IIF(ISNULL('+s1+'.宽度),'''','+s1+'.宽度 * '+s1+'.长度 * '+s1+'.数量) AS ' + strName[i] +'_面积, '
          + 'IIF(ISNULL('+s1+'.宽度),'''','+s1+'.数量) AS ' + strName[i] +'_数量 '
      end;

      strSQL := strSQL + crlf
        + ' FROM ';

      for i := 0 to i_Len - 1 do
        strSQL := strSQL + '(';

      strSQL := strSQL  + 'TCab A ' + crlf;

      for i := 0 to i_Len - 1 do
      begin
        s1 := 'B' + IntToStr(i);
        strCode[i] := StringReplace(strCode[i],',',''' OR BodName=''', [rfReplaceAll]);

        strSQL := strSQL + 'LEFT JOIN (SELECT * FROM TBod WHERE BodName='''+ strCode[i] +''' '
          +'AND ListID=''' + List.strListID + ''') ' + s1 + ' '
          +'ON A.ListID='+s1+'.ListID AND A.CabIndex='+s1+'.CabIndex )' + crlf;
      end;

      strSQL := strSQL + ' where A.ListID='''+ List.strListID +''' ' + crlf
        + 'AND A.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf;

      if i_typ = 1 then         //下柜
      begin
        strType := StringReplace(strType, ';', '%'' AND A.Nam NOT LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND A.Nam NOT LIKE ''%' + strType + '%'' ' + crlf;
      end
      else
      if i_typ =2 then          //上柜
      begin
        strType := StringReplace(strType, ';', '%'' OR A.Nam LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND A.Nam LIKE ''%' + strType + '%'' ' + crlf;
      end;

      strSQL := strSQL + 'order by A.CabIndex ';

    end;
    {$ENDREGION}

    {$REGION '另加板 3'}
    if i_typ = 3 then
    begin
      s1 := strCode.DelimitedText;
      s1 := s1 + ',门板';                                         //门板
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT A.* FROM TBod A '
        + 'LEFT JOIN (SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''') B '
        + 'ON A.CabIndex=B.CabIndex WHERE A.ListID=''' + List.strListID + ''' ' + crlf
        + 'AND A.BodName NOT IN(''' + s1 + ''') '
        + 'AND B.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf;
    end;
    {$ENDREGION}

    {$REGION '抽屉 4'}
    if i_typ = 4 then
    begin
      i_Len := strDrawerName.Count;
      strSQL := 'select A.ListID, A.Nam, A.CabIndex, A.H AS 高, A.W AS 宽, A.L AS 深, A.N AS 数量 ';

      for i := 0 to i_Len - 1 do
      begin
        s1 := 'B' + IntToStr(i);
        strSQL := strSQL + ', ' + crlf
          + 'IIF(ISNULL('+s1+'.宽度),'''',CStr('+s1+'.宽度 ) + ''*'' + CStr('+s1+'.长度 )+''*'' + CStr('+s1+'.数量)) AS ' + strDrawerName[i] +' ' ;
      end;

      strSQL := strSQL + crlf
        + ' FROM ';

      for i := 0 to i_Len - 1 do
        strSQL := strSQL + '(';

      strSQL := strSQL  + 'TCab A ' + crlf;

      for i := 0 to i_Len - 1 do
      begin
        s1 := 'B' + IntToStr(i);
        strDrawerCode[i] := StringReplace(strDrawerCode[i],',',''' OR BodName=''', [rfReplaceAll]);

        strSQL := strSQL + 'LEFT JOIN (SELECT * FROM TBod WHERE BodName='''+ strDrawerCode[i] +''' '
          +'AND ListID=''' + List.strListID + ''') ' + s1 + ' '
          +'ON A.ListID='+s1+'.ListID AND A.CabIndex='+s1+'.CabIndex )' + crlf;
      end;

      strSQL := strSQL + ' where A.ListID='''+ List.strListID +''' ' + crlf
        + 'AND A.Nam LIKE''%' + strDrawer + '%'' ' + crlf;

      strSQL := strSQL + 'order by A.CabIndex ';
    end;
    {$ENDREGION}

    {$REGION '门板 5,6,7'}
    if (i_typ = 5) or (i_typ = 6) or (i_typ = 7) then
    begin
      strSQL := 'SELECT A.*, B.Nam AS 橱柜名称,B.N AS 橱柜数量 FROM TBod A '
        + 'LEFT JOIN (SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''') B '
        + 'ON A.CabIndex=B.CabIndex WHERE A.ListID=''' + List.strListID + ''' ' + crlf
        + 'AND A.BodName = ''门板'' ' + crlf;
      if i_typ = 6 then               //门板 地柜
      begin
        strType := StringReplace(strType, ';', '%'' AND B.Nam NOT LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam NOT LIKE ''%' + strType + '%'' ' + crlf;
      end
      else
      if i_typ = 7 then
      begin                           //门板 上柜
        strType := StringReplace(strType, ';', '%'' OR B.Nam LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam LIKE ''%' + strType + '%'' ' + crlf;
      end;
      //过滤铝框门
      strSQL := strSQL + ' AND B.Nam NOT LIKE ''%铝框门%'' ';
    end;
    {$ENDREGION}

    {$REGION '铝框门门板8,9,10'}
    if (i_typ = 8) or (i_typ = 9) or (i_typ = 10) then
    begin
      strSQL := 'SELECT A.*, B.Nam AS 橱柜名称,B.N AS 橱柜数量 FROM TBod A '
        + 'LEFT JOIN (SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''') B '
        + 'ON A.CabIndex=B.CabIndex WHERE A.ListID=''' + List.strListID + ''' ' + crlf
        + 'AND A.BodName = ''门板'' ' + crlf;
      if i_typ = 9 then               //铝框门 地柜
      begin
        strType := StringReplace(strType, ';', '%'' AND B.Nam NOT LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam NOT LIKE ''%' + strType + '%'' ' + crlf;
      end
      else
      if i_typ = 10 then
      begin                           //铝框门 上柜
        strType := StringReplace(strType, ';', '%'' OR B.Nam LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam LIKE ''%' + strType + '%'' ' + crlf;
      end;
      //过滤铝框门
      strSQL := strSQL + ' AND B.Nam LIKE ''%铝框门%'' ';
    end;
    {$ENDREGION}

    {$REGION '柜体板数量及面积 11,12,13,14,15'}
    if i_typ = 11 then                                            //柜体板
    begin
      s1 := strCode.DelimitedText;
      s1 := s1 + ',门板';
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT SUM(A.数量) AS num,SUM(A.长度*A.宽度*A.数量)/1000000 AS area FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND  A.ListID='''+List.strListID + ''' ' + crlf
        + ' AND A.BodName IN('''+s1+''')' + crlf
        + ' AND B.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf;

    end
    else
    if i_typ = 12 then                                            //抽屉、另加板
    begin
      s1 := strCode.DelimitedText;
      s1 := s1 + ',门板';
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT SUM(A.数量) AS num,SUM(A.长度*A.宽度*A.数量)/1000000 AS area FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + ''' ' + crlf
        + ' AND  A.BodName NOT IN('''+s1+''')' + crlf;
    end
    else
    if i_typ = 13 then                                           //合计
    begin
      strSQL := 'SELECT SUM(A.数量) AS num,SUM(A.长度*A.宽度*A.数量)/1000000 AS area FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + ''' ' + crlf;
    end
    else
    if i_typ = 14 then                                           //背板
    begin
      strSQL := 'SELECT SUM(A.数量) AS num,SUM(A.长度*A.宽度*A.数量)/1000000 AS area FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + '''  ' + crlf
        + ' AND A.BodName=''背板'' ' + crlf;
    end
    else
    if i_typ = 15 then                                          //门板
    begin
      strSQL := 'SELECT SUM(A.数量) AS num,SUM(A.长度*A.宽度*A.数量)/1000000 AS area FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + '''  ' + crlf
        + ' AND A.BodName=''门板'' ' + crlf;
    end;
    {$ENDREGION}


    Send(strSQL);
    {AQry1.SQL.Clear;
    AQry1.SQL.Add(strSQL);
    AQry1.Open;
    Send('返回结果个数：' + IntToStr(AQry1.RecordCount));
    AQry1.Close; }
    AQry1.Free;

    Result := strSQL;
  except
    on ex: Exception do
    begin
      SendError(ex.Message);
      Result := '';
    end;

  end;

  ExitMethod('统计生产制作单');
end;

/// <summary>
/// 给所有的ADOQuery赋值
/// </summary>
procedure get_PrdIV_Ds(); overload;
var
  strSQL: string;
begin
  with F_Prt_PrdIV do
  begin
    //地柜
    AQrySel(ADOQry1, get_PrdIV_Sql(1));
    //上柜
    AQrySel(ADOQry2, get_PrdIV_Sql(2));
    //另加板
    AQrySel(ADOQry3, get_PrdIV_Sql(3));
    //抽屉
    AQrySel(ADOQry4, get_PrdIV_Sql(4));
    //门板 地柜
    AQrySel(ADOQry5, get_PrdIV_Sql(6));
    //门板 上柜
    AQrySel(ADOQry6, get_PrdIV_Sql(7));
    //铝框门门板 地柜
    AQrySel(ADOQry7, get_PrdIV_Sql(9));
    //铝框门门板 上柜
    AQrySel(ADOQry8, get_PrdIV_Sql(10));

    AQrySel(ADOQry9, get_PrdIV_Sql(11));
    AQrySel(ADOQry10, get_PrdIV_Sql(12));
    AQrySel(ADOQry11, get_PrdIV_Sql(13));
    AQrySel(ADOQry12, get_PrdIV_Sql(14));
    AQrySel(ADOQry13, get_PrdIV_Sql(15));
  end;

end;

/// <summary>
/// 根据不同报表给ADOQuery赋值
/// </summary>
/// <param name="i_typ">1.柜体;2.门板;3.铝框门门板</param>
procedure get_PrdIV_Ds(i_typ: Integer); overload;
var
  rpt1,rpt2,rpt3: TRpt;
  inif: TIniFile;
  standard: string;
begin
  //统计标准件
  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  standard := inif.ReadString('PrdOpt','Standard','0');
  inif.Free;

  if standard = '1' then
  begin
    setBodStandard(List.strListID);
  end;

  with F_Prt_PrdIV do
  begin

    if i_typ = 1 then
    begin
      //地柜
      AQrySel(ADOQry1, get_PrdIV_Sql(1));
      //上柜
      AQrySel(ADOQry2, get_PrdIV_Sql(2));
      //另加板
      AQrySel(ADOQry3, get_PrdIV_Sql(3));
      //抽屉
      AQrySel(ADOQry4, get_PrdIV_Sql(4));

      //AQryJoin(ADOQry3, ADOQry4);

      AQrySel(ADOQry9, get_PrdIV_Sql(11));
      AQrySel(ADOQry10, get_PrdIV_Sql(12));
      AQrySel(ADOQry11, get_PrdIV_Sql(13));
      AQrySel(ADOQry12, get_PrdIV_Sql(14));

      rpt1 := TRpt.Create(nil);
      rpt1.AddQry(ADOQry1);
      rpt1.min_count := 12;
      rpt1.initDB(frxUDs1);

      rpt2 := TRpt.Create(nil);
      rpt2.AddQry(ADOQry2);
      rpt2.min_count := 6;
      rpt2.initDB(frxUDs2);

      rpt3 := TRpt.Create(nil);
      rpt3.AddQry(ADOQry3);
      rpt3.AddQry(ADOQry4);
      rpt3.min_count := 3;
      rpt3.initDB(frxUDs3);

    end
    else
    if i_typ = 2 then
    begin
      //门板 地柜
      AQrySel(ADOQry5, get_PrdIV_Sql(6));
      //门板 上柜
      AQrySel(ADOQry6, get_PrdIV_Sql(7));

      AQrySel(ADOQry13, get_PrdIV_Sql(15));
    end
    else
    if i_typ = 3 then
    begin
      //铝框门门板 地柜
      AQrySel(ADOQry7, get_PrdIV_Sql(9));
      //铝框门门板 上柜
      AQrySel(ADOQry8, get_PrdIV_Sql(10));
    end;
  end;
end;


procedure TF_Prt_PrdIV.btnPrtClick(Sender: TObject);
begin
  get_PrdIV_Ds(1);

  frxrpt1.LoadFromFile(AppPath + 'rpt/Prd.fr3');
  frxRpt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRpt1.ShowReport();
end;

procedure TF_Prt_PrdIV.btnPrtDoorAlClick(Sender: TObject);
begin
  get_PrdIV_Ds(3);

  frxrpt1.LoadFromFile(AppPath + 'rpt/PrdDoorAl.fr3');
  frxRpt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRpt1.ShowReport();
end;

procedure TF_Prt_PrdIV.btnPrtDoorClick(Sender: TObject);
begin
  get_PrdIV_Ds(2);

  frxrpt1.LoadFromFile(AppPath + 'rpt/PrdDoor.fr3');
  frxRpt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRpt1.ShowReport();
end;

procedure TF_Prt_PrdIV.FormCreate(Sender: TObject);
begin
  Height := 180;

  ADOQry1.ConnectionString := getConStr;
  ADOQry2.ConnectionString := getConStr;
  ADOQry3.ConnectionString := getConStr;
  ADOQry4.ConnectionString := getConStr;
  ADOQry5.ConnectionString := getConStr;
  ADOQry6.ConnectionString := getConStr;
  ADOQry7.ConnectionString := getConStr;
  ADOQry8.ConnectionString := getConStr;
  ADOQry9.ConnectionString := getConStr;
  ADOQry10.ConnectionString := getConStr;
  ADOQry11.ConnectionString := getConStr;
  ADOQry12.ConnectionString := getConStr;
  ADOQry13.ConnectionString := getConStr;
end;

end.
