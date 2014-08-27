unit U_Prt_PrdIV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frxClass, UParam, UList, frxDBSet, DB, ADODB, UDebug,
  UPub, IniFiles, UADO, UFReport, Math;

function  get_PrdIV_Sql(i_typ: Integer): string;
procedure get_PrdIV_Ds(); overload;
procedure get_PrdIV_Ds(i_typ: Integer); overload;
function  get_PrdIV_Ls(i_typ: Integer): TStringList;
function  get_PrdIV_Ls_Col(i_typ: Integer): TStringList;

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
    ADOQry6: TADOQuery;
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
    frxUDs4: TfrxUserDataSet;
    ADOQry14: TADOQuery;
    btnHDW: TButton;
    ADOQry15: TADOQuery;
    frxDs14: TfrxDBDataset;
    ADOQry16: TADOQuery;
    frxDs15: TfrxDBDataset;
    ADOQry17: TADOQuery;
    frxDs16: TfrxDBDataset;
    label2: TLabel;
    label3: TLabel;
    label4: TLabel;
    frxUDs5: TfrxUserDataSet;
    frxUDs6: TfrxUserDataSet;
    ADOQry18: TADOQuery;
    frxUDs7: TfrxUserDataSet;
    frxUDs8: TfrxUserDataSet;
    procedure FormCreate(Sender: TObject);
    procedure btnPrtClick(Sender: TObject);
    procedure btnPrtDoorClick(Sender: TObject);
    procedure btnPrtDoorAlClick(Sender: TObject);
    procedure btnHDWClick(Sender: TObject);
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
  strSQL, s_Q: string;
  AQry1: TADOQuery;
  iniFile: TIniFile;
  strName, strCode: TStrings;
  strDrawerName, strDrawerCode: TStrings;
  strDoor: string;
  strType: string;
  strDoorAl: string;
  strDrawer: string;
  standard: string;
  strOut: string;
  i_Len: Integer;
  s1,s2,s3: string;
begin
  EnterMethod('统计生产制作单');

  try
    //AQry1 := TADOQuery.Create(nil);
    //AQry1.ConnectionString := getConStr();

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
    strDoor   := iniFile.ReadString('PrdOpt', 'Field_Door', '');
    strDoorAl := iniFile.ReadString('PrdOpt', 'Field_DoorAl', '');
    standard  := iniFile.ReadString('PrdOpt', 'Standard', '1');
    strOut    := iniFile.ReadString('PrdOpt', 'Field_Door_Out', '外漏板');

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
          + 'IIF(ISNULL('+s1+'.长度),'''',CStr('+s1+'.长度 ) + ''*'' + CStr('+s1+'.宽度 )+''*'' + CStr('+s1+'.数量)) AS ' + strName[i] +', '
          + 'IIF(ISNULL('+s1+'.长度),'''','+s1+'.长度 * '+s1+'.宽度 * '+s1+'.数量) AS ' + strName[i] +'_面积, '
          + 'IIF(ISNULL('+s1+'.长度),'''','+s1+'.数量) AS ' + strName[i] +'_数量 ';
      end;

      strSQL := strSQL + crlf
        + ' FROM ';

      for i := 0 to i_Len - 1 do
        strSQL := strSQL + '(';

      strSQL := strSQL  + 'TCab A ' + crlf;

      for i := 0 to i_Len - 1 do
      begin
        s1 := 'B' + IntToStr(i);
        s2 := StringReplace(strCode[i],',',''' OR BodName=''', [rfReplaceAll]);

        strSQL := strSQL + 'LEFT JOIN (SELECT * FROM TBod WHERE BodName='''+ s2 +''' '
          +'AND ListID=''' + List.strListID + ''' ';

        if standard = '1' then strSQL := strSQL + 'AND 标准件='''' ';           //统计标准件

        strSQL := strSQL + ') ' + s1 + ' '
          +'ON A.ListID='+s1+'.ListID AND A.CabIndex='+s1+'.CabIndex )' + crlf;
      end;

      strSQL := strSQL + ' where A.ListID='''+ List.strListID +''' ' + crlf
        + 'AND A.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf;

      if i_typ = 1 then         //下柜
      begin
        s2 := StringReplace(strType, ';', '%'' AND A.Nam NOT LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND A.Nam NOT LIKE ''%' + s2 + '%'' ' + crlf;
      end
      else
      if i_typ = 2 then          //上柜
      begin
        s2 := StringReplace(strType, ';', '%'' OR A.Nam LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND A.Nam LIKE ''%' + s2 + '%'' ' + crlf;
      end;

      strSQL := strSQL + 'order by A.CabIndex ';

    end;
    {$ENDREGION}

    {$REGION '另加板 3'}
    if i_typ = 3 then
    begin
      s1 := strCode.DelimitedText;
      s1 := s1 + ',' + strDoor + ',' + strDoorAl + ','
        + strDrawerCode.DelimitedText;                                                 //门板
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT BodName,长度,宽度,括号,SUM(数量 * N) AS 数量 FROM TBod A '
        + 'LEFT JOIN (SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''') B '
        + 'ON A.CabIndex=B.CabIndex WHERE A.ListID=''' + List.strListID + ''' ' + crlf;

      if standard = '1' then strSQL := strSQL + ' AND 标准件='''' ';            //统计标准件

      strSQL := strSQL + ' AND A.BodName NOT IN(''' + s1 + ''') '
        //+ ' AND B.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf
        + ' GROUP BY BodName,长度,宽度,括号';
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
        s2 := StringReplace(strDrawerCode[i],',',''' OR BodName=''', [rfReplaceAll]);

        strSQL := strSQL + 'LEFT JOIN (SELECT * FROM TBod WHERE BodName='''+ s2 +''' '
          +'AND ListID=''' + List.strListID + ''') ' + s1 + ' '
          +'ON A.ListID=' + s1 + '.ListID AND A.CabIndex=' + s1 + '.CabIndex )' + crlf;
      end;

      strSQL := strSQL + ' where A.ListID='''+ List.strListID +''' ' + crlf
        + 'AND A.Nam LIKE''%' + strDrawer + '%'' ' + crlf;

      strSQL := strSQL + 'order by A.CabIndex ';
    end;
    {$ENDREGION}

    {$REGION '门板 5,6,7,54'}
    if (i_typ = 5) or (i_typ = 6) or (i_typ = 7) or (i_typ = 54) then
    begin
      s1 := StringReplace(strDoor,',',''',''',[rfReplaceAll]);
      strSQL := 'SELECT A.宽度 - (B.c_w * 2) AS 宽度2,A.长度 - (B.c_w * 2) - B.BodNum AS 长度2,'
        + 'A.*, A.数量 * B.N AS 数量2, B.Nam AS 橱柜名称,B.N AS 橱柜数量,B.尺寸 FROM TBod A '
        + 'LEFT JOIN (SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''') B '
        + 'ON A.CabIndex=B.CabIndex WHERE A.ListID=''' + List.strListID + ''' ' + crlf
        + 'AND A.BodName IN (''' + s1 + ''') ' + crlf;

      s_Q := 'SELECT A.宽度 - (B.c_w * 2) AS 宽度2,A.长度 - (B.c_w * 2) AS 长度2,'
        + 'A.*, A.数量 * B.N AS 数量2, B.Nam AS 橱柜名称,B.N AS 橱柜数量,B.尺寸 FROM TBod A '
        + 'LEFT JOIN (SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''') B '
        + 'ON A.CabIndex=B.CabIndex WHERE A.ListID=''' + List.strListID + ''' ' + crlf
        + 'AND A.BodName IN (''' + s1 + ''') ' + crlf;

      s3 := StringReplace(strOut, ',', ''',''', [rfReplaceAll]);

      if i_typ = 6 then               //门板 (地柜)
      begin
        s2 := StringReplace(strType, ';', '%'' AND B.Nam NOT LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam NOT LIKE ''%' + s2 + '%'' ' + crlf;
        strSQL := strSQL + ' AND A.BodName LIKE ''门板'' ';
        strSQL := strSQL + ' AND A.括号 NOT IN (''' + s3 + ''') ';


        s_Q := s_Q + ' AND B.Nam NOT LIKE ''%' + s2 + '%'' ' + crlf;
        s_Q := s_Q + ' AND A.BodName LIKE ''门板'' ';
        s_Q := s_Q + ' AND A.括号 IN (''' + s3 + ''') ';

        strSQL := strSQL + ' UNION ' + crlf + s_Q;
      end
      else
      if i_typ = 7 then
      begin                           //门板 (上柜) 辅料

        s2 := StringReplace(strType, ';', '%'' OR B.Nam LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam LIKE ''%' + s2 + '%'' ' + crlf;
        strSQL := strSQL + ' AND A.BodName LIKE ''门板'' ';
        strSQL := strSQL + ' AND A.括号 NOT IN (''' + s3 + ''') ';

        s2 := StringReplace(strOut, ',', ''',''', [rfReplaceAll]);
        s_Q := s_Q + ' AND B.Nam LIKE ''%' + s2 + '%'' ' + crlf;
        s_Q := s_Q + ' AND A.BodName LIKE ''门板'' ';
        s_Q := s_Q + ' AND A.括号 IN (''' + s3 + ''') ';

        strSQL := strSQL + ' UNION ' + crlf + s_Q;
      end
      else
      if i_typ = 54 then
      begin                           //门板 (上柜) 辅料

        //s2 := StringReplace(strType, ';', '%'' OR B.Nam LIKE ''%', [rfReplaceAll]);
        //strSQL := strSQL + ' AND B.Nam LIKE ''%' + s2 + '%'' ' + crlf;
        strSQL := s_Q + ' AND A.BodName NOT LIKE ''门板'' ';
      end;
      //过滤铝框门
      //strSQL := strSQL + ' AND B.Nam NOT LIKE ''%铝框门%'' ';
    end;
    {$ENDREGION}

    {$REGION '铝框门门板8,9,10'}
    if (i_typ = 8) or (i_typ = 9) or (i_typ = 10) then
    begin
      s1 := StringReplace(strDoorAl,',',''',''',[rfReplaceAll]);
      strSQL := 'SELECT A.*, A.数量 * B.N AS 数量2, B.Nam AS 橱柜名称,B.N AS 橱柜数量 FROM TBod A '
        + 'LEFT JOIN (SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''') B '
        + 'ON A.CabIndex=B.CabIndex WHERE A.ListID=''' + List.strListID + ''' ' + crlf
        + 'AND A.BodName IN (''' + s1 + ''') ' + crlf;
      if i_typ = 9 then               //铝框门 地柜
      begin
        s2 := StringReplace(strType, ';', '%'' AND B.Nam NOT LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam NOT LIKE ''%' + s2 + '%'' ' + crlf;
      end
      else
      if i_typ = 10 then
      begin                           //铝框门 上柜
        s2 := StringReplace(strType, ';', '%'' OR B.Nam LIKE ''%', [rfReplaceAll]);
        strSQL := strSQL + ' AND B.Nam LIKE ''%' + s2 + '%'' ' + crlf;
      end;
    end;
    {$ENDREGION}

    {$REGION '标准件 16'}
    if i_typ = 16 then
    begin
      s1 := strDoor + ',' + strDoorAl + ',' + strDrawerCode.DelimitedText;
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT A.BodName,A.长度,A.宽度,A.材质,A.括号,Sum(A.数量 * B.N) AS 数量 '
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID=''' + List.strListID + ''' AND A.标准件=''是'' '
        + ' AND A.BodName NOT IN('''+s1+''')' + crlf
        //+ ' AND B.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf
        + ' GROUP BY A.BodName,A.长度,A.宽度,A.材质,A.括号';
    end;

    {$ENDREGION}

    {$REGION '五金 17'}
    if i_typ = 17 then
    begin
      strSQL := 'SELECT A.nam AS 名称, SUM(A.数量 * B.N) AS 数量, A.oth AS 备注 '
        + ' FROM [THDWare] A,TCab B '
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID=''' + List.strListID + ''' '
        + ' AND A.nam <>'''' '
        + ' GROUP BY A.nam, A.oth';
    end;
    {$ENDREGION}


    {$REGION '柜体板数量及面积 非标准件:柜体101,抽屉|附加102,合计103,背板104,门板105 标准件:柜体106,背板107'}
    if i_typ = 101 then                                            //柜体板
    begin
      s1 := strCode.DelimitedText;
      //s1 := s1 + ',' + strDoor;
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT SUM(A.数量 * B.N) AS num, ROUND(SUM(A.长度 *  A.宽度 * A.数量 * B.N)/1000000,2) AS area '
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND  A.ListID='''+List.strListID + ''' ' + crlf
        + ' AND A.BodName IN('''+s1+''')' + crlf
        + ' AND A.BodName <>''背板''';

        if standard = '1' then strSQL := strSQL + ' AND A.标准件='''' ';           //统计标准件
        //+ ' AND B.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf;

    end
    else
    if i_typ = 102 then                                            //抽屉、另加板
    begin
      s1 := strCode.DelimitedText;
      s1 := s1 + ',' + strDoor + ',' + strDoorAl;
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT SUM(A.数量 * B.N) AS num, ROUND(SUM(A.长度 *  A.宽度 * A.数量 * B.N)/1000000,2) AS area '
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + ''' ' + crlf
        + ' AND  A.BodName NOT IN('''+s1+''')' + crlf;

        if standard = '1' then strSQL := strSQL + ' AND A.标准件='''' ';           //统计标准件
    end
    else
    if i_typ = 103 then                                           //合计
    begin
      s1 := strDoor + ',' + strDoorAl;
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT SUM(A.数量 * B.N) AS num, ROUND(SUM(A.长度 * A.宽度 * A.数量 * B.N)/1000000,2) AS area '
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + ''' ' + crlf
        + ' AND A.BodName NOT IN('''+s1+''')' + crlf;

        if standard = '1' then strSQL := strSQL + ' AND A.标准件='''' ';           //统计标准件
        //+ ' AND B.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf;
    end
    else
    if i_typ = 104 then                                           //背板
    begin
      strSQL := 'SELECT SUM(A.数量 * B.N) AS num, ROUND(SUM(A.长度 * A.宽度 * A.数量 * B.N)/1000000,2) AS area '
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + '''  ' + crlf
        + ' AND A.BodName=''背板'' ' + crlf;

        if standard = '1' then strSQL := strSQL + ' AND A.标准件='''' ';           //统计标准件
    end
    else
    if i_typ = 105 then                                          //门板
    begin
      s1 := StringReplace(strDoor,',',''',''',[rfReplaceAll]);
      strSQL := 'SELECT SUM(A.数量 * B.N) AS num, ROUND(SUM(A.长度 * A.宽度 * A.数量 * B.N)/1000000,2) AS area,'
        + ' ROUND(SUM(A.宽度 * A.数量 * B.N)/1000,2) AS 拉手长度'
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + '''  ' + crlf
        + ' AND A.BodName IN (''' + s1 + ''') ' + crlf;
    end
    else
    if i_typ = 106 then                                           //标准件 柜体
    begin
      s1 := strDoor + ',' + strDoorAl + ',背板';
      s1 := StringReplace(s1, ';', ',', [rfReplaceAll]);
      s1 := StringReplace(s1, ',', ''',''', [rfReplaceAll]);
      strSQL := 'SELECT SUM(A.数量 * B.N) AS num, ROUND(SUM(A.长度 *  A.宽度 * A.数量 * B.N)/1000000,2) AS area '
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND  A.ListID='''+List.strListID + ''' ' + crlf
        + ' AND A.BodName NOT IN (''' + s1 + ''') ' + crlf;

        if standard = '1' then strSQL := strSQL + ' AND A.标准件=''是'' ';           //统计标准件
        //+ ' AND B.Nam NOT LIKE''%' + strDrawer + '%'' ' + crlf;
    end
    else
    if i_typ = 107 then                                           //标准件 背板
    begin
      strSQL := 'SELECT SUM(A.数量 * B.N) AS num, ROUND(SUM(A.长度 * A.宽度 * A.数量 * B.N)/1000000,2) AS area '
        + ' FROM TBod A,TCab B' + crlf
        + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex AND A.ListID='''+List.strListID + '''  ' + crlf
        + ' AND A.BodName=''背板'' ' + crlf;

        if standard = '1' then strSQL := strSQL + ' AND A.标准件=''是'' ';           //统计标准件
    end;
    {$ENDREGION}


    Send(strSQL);

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
begin
  get_PrdIV_Ds(1);
  get_PrdIV_Ds(2);
  get_PrdIV_Ds(3);
  get_PrdIV_Ds(4);

end;

/// <summary>
/// 根据不同报表给ADOQuery赋值
/// </summary>
/// <param name="i_typ">1.柜体;2.门板;3.铝框门门板</param>
procedure get_PrdIV_Ds(i_typ: Integer); overload;
var
  rpt1,rpt2,rpt3,rpt4: TRpt;
  rpt5,rpt6,rpt7,rpt8: TRpt;
  inif: TIniFile;
  standard: string;
  s_line: TStrings;
  ado1: TADO;
begin
  //统计标准件
  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  standard := inif.ReadString('PrdOpt','Standard','0');

  s_line := TStringList.Create;
  s_line.Delimiter := ';';
  s_line.DelimitedText := inif.ReadString('PrdOpt', 'min_line','12;6;3;3');

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
      //AQrySel(ADOQry1, get_PrdIV_Sql(1));
      //上柜
      //AQrySel(ADOQry2, get_PrdIV_Sql(2));
      //另加板
      AQrySel(ADOQry3, get_PrdIV_Sql(3));
      //抽屉
      AQrySel(ADOQry4, get_PrdIV_Sql(4));

      //AQryJoin(ADOQry3, ADOQry4);

      AQrySel(ADOQry9,  get_PrdIV_Sql(101));                                    //body
      AQrySel(ADOQry10, get_PrdIV_Sql(102));
      AQrySel(ADOQry11, get_PrdIV_Sql(103));
      AQrySel(ADOQry12, get_PrdIV_Sql(104));                                    //back
      AQrySel(ADOQry16, get_PrdIV_Sql(106));
      AQrySel(ADOQry17, get_PrdIV_Sql(107));

      AQrySel(ADOQry14, get_PrdIV_Sql(16));

      //柜体部件 上柜
      rpt1 := TRpt.Create(nil);
      //rpt1.AddQry(ADOQry1);
      rpt1.AddList(get_PrdIV_Ls(1), get_PrdIV_Ls_col(1));
      rpt1.min_count := StrToInt(s_line[0]);
      rpt1.initDB(frxUDs1);

      //柜体部件 下柜
      rpt2 := TRpt.Create(nil);
      //rpt2.AddQry(ADOQry2);
      rpt2.AddList(get_PrdIV_Ls(2), get_PrdIV_Ls_col(2));
      rpt2.min_count := StrToInt(s_line[1]);
      rpt2.initDB(frxUDs2);

      //另加板 抽屉
      rpt3 := TRpt.Create(nil);
      rpt3.AddQry(ADOQry3);
      //rpt3.AddQry(ADOQry4);
      rpt3.AddList(get_PrdIV_Ls(3), get_PrdIV_Ls_col(3));
      rpt3.min_count := StrToInt(s_line[2]);
      rpt3.initDB(frxUDs3);

      //标准件
      rpt4 := TRpt.Create(nil);
      rpt4.AddQry(ADOQry14);
      rpt4.min_count := StrToInt(s_line[3]);
      rpt4.initDB(frxUDs4);

      ado1 := TADO.Create(nil);
      ado1.Cmd('UPDATE List SET 背板面积=' + VarToStr(ADOQry12.FieldValues['area'])
        + ',柜体板面积=' + VarToStr(ADOQry9.FieldValues['area'])
        + ' WHERE ListID=''' + list.strListID + '''');
      ado1.Free;

    end
    else
    if i_typ = 2 then
    begin
      //门板 地柜
      AQrySel(ADOQry5, get_PrdIV_Sql(6));
      rpt5 := TRpt.Create(nil);
      rpt5.AddQry(ADOQry5);
      //rpt5.AddList(get_PrdIV_Ls(1), get_PrdIV_Ls_col(1));
      rpt5.min_count := StrToInt(s_line[0]);
      rpt5.initDB(frxUDs5);

      //门板 上柜
      AQrySel(ADOQry6, get_PrdIV_Sql(7));
      rpt6 := TRpt.Create(nil);
      rpt6.AddQry(ADOQry6);
      //rpt6.AddList(get_PrdIV_Ls(1), get_PrdIV_Ls_col(1));
      rpt6.min_count := StrToInt(s_line[0]);
      rpt6.initDB(frxUDs6);

      //辅板
      AQrySel(ADOQry18, get_PrdIV_Sql(54));
      rpt7 := TRpt.Create(nil);
      rpt7.AddQry(ADOQry18);
      //rpt6.AddList(get_PrdIV_Ls(1), get_PrdIV_Ls_col(1));
      rpt7.min_count := StrToInt(s_line[0]);
      rpt7.initDB(frxUDs7);

      //门板附加信息
      rpt8 := TRpt.Create(nil);
      rpt8.AddList(List.doorOth_val, List.doorOth_col);
      rpt8.min_count := 1;
      rpt8.initDB(frxUDs8);

      AQrySel(ADOQry13, get_PrdIV_Sql(105));                                    //door

      ado1 := TADO.Create(nil);
      ado1.Cmd('UPDATE List SET 门板面积=' + VarToStr(ADOQry13.FieldValues['area'])
        + ' WHERE ListID=''' + list.strListID + '''');
      ado1.Free;
    end
    else
    if i_typ = 3 then
    begin
      //铝框门门板 地柜
      AQrySel(ADOQry7, get_PrdIV_Sql(9));
      //铝框门门板 上柜
      AQrySel(ADOQry8, get_PrdIV_Sql(10));
    end;
    if i_typ = 4 then
    begin
      //五金
      AQrySel(ADOQry15, get_PrdIV_Sql(17));
    end;
  end;

  s_line.Free;
end;

/// <summary>
/// 用户自定义数据 柜体部件
/// </summary>
/// <param name="i_typ"></param>
/// <returns></returns>
function get_PrdIV_Ls(i_typ: Integer): TStringList;
var
  ado1: TADO;
  ados: array of TADO;
  standard : string;
  i,j,k,l: Integer;
  i_row_count: Integer;                                                         //行计数
  i_ds_count: Integer;                                                          //结果集计数
  i_col_index: Integer;                                                         //当前列标记
  strSQL: string;
  AQry1: TADOQuery;
  iniFile: TIniFile;
  strName, strCode: TStrings;
  strDrawerName, strDrawerCode: TStrings;
  strType: string;
  strDrawer: string;
  i_Len: Integer;
  s1: string;
  s2: array of array of string;
  s3: string;
  sJ1, sJ2, sJ3: string;
  s_code: string;
  s_exp: string;
begin
  EnterMethod('生成柜体板数据');
  //统计标准件
  {$REGION '读取参数'}
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

  standard := iniFile.ReadString('PrdOpt','Standard','0');

  iniFile.Free;
  {$ENDREGION}

  Result := TStringList.Create;
  ado1 := TADO.Create(nil);

  {$REGION '上柜|下柜 1 2'}
  if (i_typ = 1) or (i_typ = 2) then
  begin
    EnterMethod('上柜|下柜');
    SetLength(ados, strName.Count);
    for i := 0 to strName.Count - 1 do
    begin
      ados[i] := TADO.Create(nil);
    end;

    strSQL := 'SELECT ListID, Nam, CabIndex, H AS 高, W AS 宽, L AS 深, N AS 数量,Oth AS 备注 '
      + ' FROM TCab WHERE H > 0 AND ListID=''' + List.strListID + '''';

    if i_typ = 1 then         //下柜
    begin
      strType := StringReplace(strType, ';', '%'' AND Nam NOT LIKE ''%', [rfReplaceAll]);
      strSQL := strSQL + ' AND Nam NOT LIKE ''%' + strType + '%'' ' + crlf;
    end
    else
    if i_typ = 2 then          //上柜
    begin
      strType := StringReplace(strType, ';', '%'' OR Nam LIKE ''%', [rfReplaceAll]);
      strSQL := strSQL + ' AND Nam LIKE ''%' + strType + '%'' ' + crlf;
    end;

    strSQL := strSQL + 'order by CabIndex ';
    Send(strSQL);
    ado1.Sel(strSQL);

    s_code := ReadFile(ExtractFilePath(Application.ExeName) + 'code\PrtPrd.ds');

    i_row_count := 0;
    for i := 0 to ado1.RecordCount - 1 do                                         //外层循环 个体
    begin

      EnterMethod('CabIndex=' + ado1.Fs('CabIndex'));

      sJ1 := ado1.RowToJson();
                                                                                //一次统计出所有需要的数据
      s3 := '';
      i_ds_count := 0;
      for j := 0 to  strName.Count - 1 do                                       //列循环 部件名
      begin
        s1 := strCode[j];
        s1 := StringReplace(s1,',',''' OR BodName=''', [rfReplaceAll]);

        strSQL := 'SELECT '
          + ' CStr(A.长度 ) + ''*'' + CStr(A.宽度 )+''*'' + CStr(SUM(A.数量 * B.N)) AS V1,'
          + ' 括号 AS V2 '
          + ' FROM TBod A, TCab B' + crlf
          + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex '
          + ' AND A.ListID=''' + List.strListID + ''' ' + crlf
          + ' AND A.CabIndex=' + ado1.Fs('CabIndex') + ' ' + crlf
          + ' AND (A.BodName=''' + s1 + ''') ' + crlf;
        if standard = '1' then strSQL := strSQL + ' AND A.标准件='''' ';        //过滤标准件

        strSQL := strSQL + ' GROUP BY A.长度, A.宽度, A.括号';

        //Send(strSQL);
        s3 := s3 + strSQL + crlf;
        ados[j].Sel(strSQL);
        //ados[j].First;

        //Send('结果集个数：' + IntToStr(ados[j].RecordCount) );
        s3 := s3 + '结果集个数：' + IntToStr(ados[j].RecordCount) + crlf;

        i_ds_count := Max(i_ds_count, ados[j].RecordCount);                     //最大行数

      end;

      Send(s3);
      Send('最大行数=' + IntToStr(i_ds_count));
      s3 := '';

      if i_ds_count = 0 then i_ds_count := 1;
      

      i_row_count := i_row_count + i_ds_count;
      SetLength(s2, i_row_count);                                                 //添加新行
      for l := i_row_count - i_ds_count to i_row_count - 1 do
      begin

        SetLength(s2[l],ado1.FieldCount + strName.Count);

        if l = i_row_count - i_ds_count then
        begin

          for k := 0 to ado1.Fields.Count - 1 do                                  //添加柜体信息
          begin
            s2[l][k] := VarToStr(ado1.Fields[k].Value);
          end;
        end;

        for j := 0 to strName.Count - 1 do
        begin
          if not ados[j].Eof then
          begin
            s2[l][ado1.FieldCount + j] := ados[j].Fs('V1');
            //Send(ados[j].Fs('V1'));
            //s3 := s3 + ados[j].Fs('V1') + crlf;                                 //debug info

            try
              sJ2 := ados[j].RowToJson();
              sJ3 := '{"c":"'+ strCode[j] +'","s":"' + strName[j] + '"}';
              s_exp := s_code;
              s_exp := StringReplace(s_exp, '{v1}', sJ1, [rfReplaceAll]);
              s_exp := StringReplace(s_exp, '{v2}', sJ2, [rfReplaceAll]);
              s_exp := StringReplace(s_exp, '{v3}', sJ3, [rfReplaceAll]);
              //Send(s_exp);

              s2[l][ado1.FieldCount + j] := RunJs(s_exp, 's0');
            except
              on ex: Exception do
              begin
                SendError(ex.Message);
              end;

            end;

            ados[j].Next;
          end;

        end;

      end;
      //Send(s3);

      ado1.Next;

      ExitMethod('柜体统计结束');
    end;

    for i := 0 to strName.Count - 1 do
    begin
      ados[i].free;
    end;
    ExitMethod('上柜|下柜');
  end;
  {$ENDREGION}

  {$REGION '抽屉 3'}
  if i_typ = 3 then
  begin
    EnterMethod('抽屉');
    SetLength(ados, strDrawerName.Count);
    for i := 0 to strDrawerName.Count - 1 do
    begin
      ados[i] := TADO.Create(nil);
    end;

    strSQL := 'SELECT ListID, Nam AS 抽屉名称, CabIndex, H AS 高, W AS 宽, L AS 深, N AS 数量 '
      + ' FROM TCab '
      + ' WHERE Nam Like ''%' + strDrawer + '%'' AND ListID=''' + List.strListID + '''';


    strSQL := strSQL + 'order by CabIndex ';
    Send(strSQL);
    ado1.Sel(strSQL);

    i_row_count := 0;
    for i := 0 to ado1.RecordCount - 1 do                                         //外层循环 个体
    begin

      EnterMethod('CabIndex=' + ado1.Fs('CabIndex') + ', name=' + ado1.Fs('抽屉名称'));

      i_ds_count := 0;
      for j := 0 to  strDrawerName.Count - 1 do                                         //列循环
      begin
        s1 := strDrawerCode[j];
        s1 := StringReplace(s1,',',''' OR BodName=''', [rfReplaceAll]);

        strSQL := 'SELECT '
          + ' CStr(A.长度 ) + ''*'' + CStr(A.宽度 )+''*'' + CStr(SUM(A.数量 * B.N)) AS V1 '
          + ' FROM TBod A, TCab B' + crlf
          + ' WHERE A.ListID=B.ListID AND A.CabIndex=B.CabIndex '
          + ' AND A.ListID=''' + List.strListID + ''' ' + crlf
          + ' AND A.CabIndex=' + ado1.Fs('CabIndex') + ' ' + crlf
          + ' AND (A.BodName=''' + s1 + ''') ' + crlf;
        if standard = '1' then strSQL := strSQL + ' AND A.标准件='''' ';        //过滤标准件

        strSQL := strSQL + ' GROUP BY A.长度,A.宽度';

        //Send(strSQL);
        s3 := s3 + strSQL + crlf;
        ados[j].Sel(strSQL);
        ados[j].First;

        //Send('结果集个数：' + IntToStr(ados[j].RecordCount) );
        s3 := s3 + '结果集个数：' + IntToStr(ados[j].RecordCount) + crlf;

        i_ds_count := Max(i_ds_count, ados[j].RecordCount);

      end;

      Send(s3);
      Send('最大行数=' + IntToStr(i_ds_count));
      s3 := '';

      i_row_count := i_row_count + i_ds_count;
      SetLength(s2, i_row_count);                                               //添加新行
      for l := i_row_count - i_ds_count to i_row_count - 1 do
      begin

        SetLength(s2[l],ado1.FieldCount + strDrawerName.Count);                 //设置数组第2维下标

        if l = i_row_count - i_ds_count then
        begin

          for k := 0 to ado1.Fields.Count - 1 do                                //添加柜体信息
          begin
            s2[l][k] := VarToStr(ado1.Fields[k].Value);
          end;
        end;

        for j := 0 to strDrawerName.Count - 1 do
        begin
          if not ados[j].Eof then
          begin
            s2[l][ado1.FieldCount + j] := ados[j].Fs('V1');
            //Send(ados[j].Fs('V1'));
            s3 := s3 + ados[j].Fs('V1') + crlf;

            ados[j].Next;
          end;

        end;

      end;
      Send(s3);

      ado1.Next;

      ExitMethod('柜体统计结束');
    end;

    for i := 0 to strDrawerName.Count - 1 do
    begin
      ados[i].free;
    end;
    ExitMethod('抽屉');
  end;
  {$ENDREGION}
  Result := TStringList.Create;
  for i := 0 to i_row_count - 1 do
  begin
    Result.Add('');
    for j := 0 to Length(s2[i]) - 1 do
    begin
      if j <> 0 then Result[i] := Result[i] + ';';

      Result[i] := Result[i] + s2[i][j];
    end;
  end;

  Send(Result);

  ExitMethod('生成柜体板数据');
end;

/// <summary>
/// 设置列头  用户自定义数据
/// </summary>
/// <returns>TStringList</returns>
function  get_PrdIV_Ls_Col(i_typ: Integer): TStringList;
var
  inif : TIniFile;
  s1,s2: TStrings;
  ado1 : TADO;
  i: Integer;
begin
  EnterMethod('获取列名');

  s1 := TStringList.Create;
  ado1 := TADO.Create(nil);

  if (i_typ = 1) or (i_typ = 2) then
    ado1.Sel('SELECT top 1 ListID, Nam, CabIndex, H AS 高, W AS 宽, L AS 深, N AS 数量,Oth AS 备注 FROM TCab');

  if i_typ = 3 then
    ado1.Sel('SELECT top 1 ListID, Nam AS 抽屉名称, CabIndex, H AS 高, W AS 宽, L AS 深, N AS 数量 FROM TCab');                                        //查询柜体中的列

  for i := 0 to ado1.Fields.Count - 1 do s1.Add(ado1.Fields[i].FieldName);
  ado1.Free;

  s2 := TStringList.Create;
  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  s2.Delimiter := ';';

  if (i_typ = 1) or (i_typ = 2) then
    s2.DelimitedText := inif.ReadString('PrdOpt', 'Field_Name', '');              //用户自定义的列

  if i_typ = 3 then
    s2.DelimitedText := inif.ReadString('PrdOpt', 'Field_Drawer_Name', '');

  inif.Free;

  Result := TStringList.Create;
  for i := 0 to s1.Count - 1 do Result.Add(s1[i]);                              //柜体中的列
  for i := 0 to s2.Count - 1 do Result.Add(s2[i]);                              //用户自定义的列

  ExitMethod('获取列名');
end;

/// <summary>
/// print hdware
/// </summary>
/// <param name="Sender"></param>
procedure TF_Prt_PrdIV.btnHDWClick(Sender: TObject);
begin
  get_PrdIV_Ds(4);

  frxrpt1.LoadFromFile(AppPath + 'rpt/hdw.fr3');
  frxRpt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRpt1.ShowReport();
end;

/// <summary>
/// print body board
/// </summary>
/// <param name="Sender"></param>
procedure TF_Prt_PrdIV.btnPrtClick(Sender: TObject);
begin
  get_PrdIV_Ds(1);

  frxrpt1.LoadFromFile(AppPath + 'rpt/Prd.fr3');
  frxRpt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRpt1.ShowReport();
end;

/// <summary>
/// print door Al board
/// </summary>
/// <param name="Sender"></param>
procedure TF_Prt_PrdIV.btnPrtDoorAlClick(Sender: TObject);
begin
  get_PrdIV_Ds(3);

  frxrpt1.LoadFromFile(AppPath + 'rpt/PrdDoorAl.fr3');
  frxRpt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRpt1.ShowReport();
end;

/// <summary>
/// print door board
/// </summary>
/// <param name="Sender"></param>
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
  ADOQry14.ConnectionString := getConStr;
  ADOQry15.ConnectionString := getConStr;
  ADOQry16.ConnectionString := getConStr;
  ADOQry17.ConnectionString := getConStr;
  ADOQry18.ConnectionString := getConStr;
end;

end.
