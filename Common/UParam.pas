unit UParam;

interface
uses
  SysUtils, Dialogs, Variants, DB, ADODB, UPub, U_Pb ,IniFiles, U_PBRun,
  DateUtils, Controls, Forms, Classes, Math, UDebug, UADO;


procedure PbShow();
procedure PbHide();
procedure Timing_Begin();
procedure Timing_End();
procedure ReadIniFile();
procedure SaveIniFile();
procedure ReadFZFormIniFile(iType : Integer);
function  GetBoardNum(IBoardNam : Integer): Integer;

function  getConStr_Import(i_typ: Integer): string;
procedure decDatFile(); overload;
procedure decDatFile(fileName: string); overload;

//function  ADOCMD(strSQL : string): Integer;

type
  //板材
  P_PBoard = ^T_Board;
  T_Board = record
    Index      : Integer;                                                       //序号
    cabIndex   : Integer;                                                       //橱柜序号
    bodID      : Integer;                                                       //板材序号
    bodH       : Double;                                                        //长
    bodW       : Double;                                                        //宽
    bodNum     : Integer;                                                       //数量
    bodXZh     : string; 			                                                  //旋转 修改原来长变量名
    bodCZh     : string; 			                                                  //材质
    bodOth     : string;                                                        //备注
    bodFlag    : string;                                                        //图号
    bodName    : string;                                                        //名称
    bodType    : string;                                                        //类型 上柜、下柜
    bodEdge    : Double;                                                        //封边
    bodArea    : Double;                                                        //面积
    bodPrice   : Double;                                                        //价额
    cabNam     : string;     			                                              //橱柜名称，无用
    bodInfo    : string;    			                                              //工艺，括号内容
  end;

  //五金
  P_PhdWare = ^T_hdWare;
  T_hdWare = record
    Index      : Integer;                                                       //序号
    cabIndex   : Integer;                                                       //序号
    cabFlag    : string;                                                        //橱柜图号
    hdID       : Integer;                                                       //板材序号
    hdNum      : Integer;                                                       //数量
    hdCZh      : string; 			                                                  //材质
    hdOth      : string;                                                        //备注
    hdFlag     : string;                                                        //图号
    hdName     : string;                                                        //名称
    cabType    : string;                                                        //类型 上柜、下柜
    strType    : string;                                                        //五金、非五金
    hdArea     : Double;                                                        //面积
    hdPrice    : Double;                                                        //单价
    hdSumPrice : Double;                                                        //金额
    cabNam     : string;     		                                             	  //橱柜名称，无用
    hdInfo     : string;    		                                                //工艺，括号内容
  end;

  //橱柜
  P_PCabinet = ^T_Cabinet;
  T_Cabinet = record
    Index     : Integer;                                                        //序号
    cabID     : string;                                                         //编号
    cabW      : Double;                                                         //宽
    cabH      : Double;                                                         //高
    cabD      : Double;                                                         //深
    cabC_W    : Double;                                                         //合计宽度
    cabW_H_D  : string;                                                         //尺寸
    cabTypeID : string;                                                         //上柜W，下柜B
    cabName   : string;                                                         //名称
    cabOth    : string;                                                         //备注
    cabType   : string;                                                         //上柜、下柜
    cabGB     : string;                                                         //有无隔板
    bodyCZ    : string;                                                         //柜体材质
    doorCZ    : string;                                                         //门板材质
    backCZ    : string;                                                         //背板材质

    cabNum    : Integer;                                                        //数量
    cabNDoor  : Integer;                                                        //门板数量
    cabNBack  : Integer;                                                        //柜体板数量
    cabNBody  : Integer;                                                        //背板数量
    cabNCB    : Integer;                                                        //侧板数量
    cabNLT    : Integer;                                                        //拉条数量
    cabNFLT   : Integer;                                                        //前拉条数量
    cabNBLT   : Integer;                                                        //后拉条数量
    cabNGB_G  : Integer;                                                        //隔板数量 活隔
    cabNGB    : Integer;                                                        //隔板数量 固隔
    cabNDDB   : Integer;                                                        //底顶板数量
    cabNBUp   : Integer;                                                        //顶板数量
    cabNBDown : Integer;                                                        //底板数量
    cabNFJB   : Integer;                                                        //附加板数量
    cabBodNum : Integer;                                                        //板材数量
    cabhdwNum : Integer;                                                        //五金数量
    AreaDoor  : Double;                                                         //门板面积
    AreaBack  : Double;                                                         //背板面积
    AreaBody  : Double;                                                         //柜体板面积
    PrcDoor   : Double;                                                         //门板价格
    PrcBack   : Double;                                                         //背板价格
    PrcBody   : Double;                                                         //柜体板价格
    PrcAll    : Double;                                                         //柜体价格
    bod       : array of T_Board;                                               //板材数据
    hdw       : array of T_hdWare;                                              //五金数据
  end;

  //打印标签数据明细
  P_PBodLab = ^T_BodLab;
  T_BodLab = record
    Index     : Integer;          //
    labIndex  : Integer;          //
    cabID     : string;           //
    cabName   : string;           //
    cabTypeID : string;           //
    cabW_H_D  : string;           //
    bodID     : Integer;          //
    bodName   : string;           //
    bodCZh    : string;           //
    bodInfo   : string;           //用途
    bodNum    : Integer;          //
    bodCount  : Integer;          //
    bodW      : Double;           //
    bodH      : Double;           //
  end;

  //打印标签页面数据分类处理
  P_PBodLabs = ^T_BodLabs;
  T_BodLabs = record
    Index     : Integer;
    DoorCount : Integer;
    BodyCount : Integer;
    BackCount : Integer;
    bodTyps   : array [0..2] of array of T_BodLab;
    DoorLabs  : array of T_BodLab;
    BodyLabs  : array of T_BodLab;
    BackLabs  : array of T_BodLab;
  end;

  //生产制作单
  P_PCabPrd = ^T_CabPrd;
  T_CabPrd = record
    cabIndex  : Integer;          //序号
    cabName   : string;           //橱柜名称
    cabTypeID : string;           //下柜B 上柜W
    cabW_H_D  : string;           //尺寸
    cabD      : Double;           //深
    bodCB     : array of string;  //侧板
    bodDDB    : array of string;  //底顶板
    bodBUp    : array of string;  //顶板、
    bodBDown  : array of string;  //底板
    bodGB_G   : array of string;  //隔板 固隔
    bodGB     : array of string;  //隔板 活隔
    bodLT     : array of string;  //拉条
    bodQLT    : array of string;  //前拉条
    bodHLT    : array of string;  //后拉条
    bodFJB    : array of string;  //附加板
    bodBack   : array of string;  //背板
    bodDoor   : array of string;  //门板
    cabNum    : Integer;          //数量
    cutType   : Integer;          //切角类型（切角，挖角，中切角）
    cutA      : Double;           //切角尺寸A
    cutB      : Double;           //切角尺寸B
    cutC      : Double;           //切角尺寸C
    cutGB_A   : Double;           //隔板A
    cutGB_B   : Double;           //隔板B
    TabH      : Integer;          //表格最大行数
    cut_GB    : Boolean;          //是否有隔板
    showCab   : Boolean;          //是否显示该模型
  end;

  //包管，垫条，封板，辅料(生产制作单表尾)
  P_PCabPrdOth = ^T_CabPrdOth;
  T_CabPrdOth = record
    Index      : Integer;            //序号
    NameBG     : array of  string;   //
    NameDT     : array of  string;   //
    NameFB     : array of  string;   //
    NameFL     : array of  string;   //
    sizeBG     : array of  string;   //
    sizeDT     : array of  string;   //
    sizeFB     : array of  string;   //
    sizeFL     : array of  string;   //
    NumBG      : array of  Integer;  //
    NumDT      : array of  Integer;  //
    NumFB      : array of  Integer;  //
    NumFL      : array of  Integer;  //
    rowCount   : Integer;            //
    showPrdOth : Boolean;            //是否显示特殊模型
  end;

  //特殊加价公式及金额
  P_TCabTsPrc = ^TCabTsPrc;
  TCabTsPrc = record
    Name       : string;            //名称
    GS         : string;            //公式
    Prc        : Double;            //价格
  end;


  TCabDrawer = record
    Name      :string;
    ChBang    :string;              //抽邦
    ChWei     :string;              //抽尾
    ChDi      :string;              //抽底
  end;
  //订单
  P_PList = ^T_List;
  T_List = record
    Index      : Integer;            //序号
    strListID  : string;             //订单编号
    strSDate   : string;             //交货日期
    strAddress : string;             //安装地址
    strUseName : string;             //客户姓名
    strUsePho  : string;             //客户联系方式
    CreateDate : string;              //创建日期
    State      : string;              //状态
    strFBGY    : string;             //封边工艺
    CZhDoor    : string;             //门板材质
    CZhBack    : string;             //背板材质
    CZhBody    : string;             //柜体板材质
    strPrcOth  : string;             //其他费用
    NumDoor    : Integer;            //门板数量
    NumBack    : Integer;            //背板数量
    NumBody    : Integer;            //柜体板
    NumGB_G    : Integer;            //隔板 固隔
    NumGB      : Integer;            //隔板 活隔
    NumLT      : Integer;            //拉条
    NumQLT     : Integer;            //前拉条
    NumHLT     : Integer;            //后拉条
    NumCB      : Integer;            //侧板数量
    NumDDB     : Integer;            //底顶板
    NumBUp     : Integer;            //顶板
    NumBDown   : Integer;            //底板
    NumFJB     : Integer;            //附加板数量
    NumCabUp   : Integer;            //上柜数量
    NumCabDown : Integer;            //下柜数量
    NumPrcOth  : Integer;            //其他费用
    PrcDoor    : Double;             //门板材质单价
    PrcBody    : Double;             //柜体板材质单价
    PrcBack    : Double;             //背板材质单价
    SumPrcDoor : Double;             //门板合计价格
    SumPrcBody : Double;             //柜体板合计价格
    SumPrcBack : Double;             //背板合计价格
    SumPrcBod  : Double;             //板材价格
    SumPrcHD_  : Double;             //五金价格
    SumPrcTS_  : Double;             //特殊加价
    Prc_Pay    : Double;              //金额
    Prc_Income : Double;              //已付
    AreaDoor   : Double;             //门板面积
    AreaBack   : Double;             //背板面积
    AreaBody   : Double;             //柜体板面积
    AreaGB     : Double;             //隔板
    AreaDDB    : Double;             //底顶板
    AreaQLT    : Double;             //前拉条
    AreaHLT    : Double;             //后拉条
    AreaCB     : Double;             //侧板
    AreaFJB    : Double;             //附加板
    cabPrdOth  : T_CabPrdOth;         //特殊模型
    bodLabs    : T_BodLabs;           //统计后标签
    bodLab     : array of T_BodLab;   //未统计标签
    cab        : array of T_Cabinet;  //橱柜列表
    cabPrd     : array of T_CabPrd;   //生产制作单
    hdwPrc     : array of T_hdWare;   //五金统计
    tsPrc      : array of TCabTsPrc;  //特殊加价公式及金额
    cabDrawer  : array of TCabDrawer; //抽屉报表数据

    doorOth_col: TStrings;
    doorOth_val: TStringList;
  end;

{$REGION '变量及常量'}
var
  ILineWidth   : Integer;       //表格边框宽度
  fzTitle      : Integer;       //标题字体大小
  fzMinTit     : Integer;       //小标题字号
  fzBody       : Integer;       //内容字体大小
  fzT,fzM,fzB  : Integer;       //标题、小标题，正文相对字体差值
  ftT,ftM,ftB  : string;        //标题，小标题，正文字体名称
  ptType       : Integer;       //报表显示样式，1：显示橱柜名称 2：下柜B，上柜W
  ptCutSize    : Integer;       //切角柜开口尺寸 0.不加板材厚度 1.加板材厚度
  ptMQP        : Integer;       //煤气瓶柜 0.不判断 1.判断并绘图
  ptMQP_A      : Integer;       //参数A的值
  ptDoorPrc    : Integer;       //门板金额 0.统计 1.不统计
  ptDifMod     : Integer;       //独立显示包管，垫条，封板，辅料：0.不判断 1.判断
  TabOldLineH  : Double;        //表格原始行高
  TabLineH     : Double;        //表格行高
  fLBoottom    : Double;        //文字下边距
  fbBody       : Double;        //柜体封边
  fbDoor       : Double;        //门板封边
  fbBack       : Double;        //背板封边
  IntBodD      : Integer;       //板材厚度
  IntAddYear   : Integer;       //订单年份+
  PrcRound     : Integer;       //金额保留小数
  AreaRound    : Integer;       //面积保留小数位数
  strTabPrc    : string;        //报价单
  strTabPrd    : string;        //生产制作单
  strTabPro    : string;        //开料计划表
  BoolFName    : Boolean;       //xls文件是否正确
  strListID    : string;        //订单编号
  strName      : string;        //客户姓名
  strPhone     : string;        //联系方式
  strSDate     : string;        //交货日期
  strAddress   : string;        //安装地址
  strBod_Door  : string;        //门板材质
  strBod_Body  : string;        //柜体材质
  strBod_Back  : string;        //背板材质
  strFBGY      : string;        //封边工艺
  strW         : string;        //宽
  strH         : string;        //高
  strD         : string;        //深
  strNumber    : string;        //数量
  strCabinet   : string;        //橱柜名称
  strStandard  : string;        //标准柜，非标准柜
  strCabinetID : string;        //橱柜编号
  BoolMQPG     : Boolean;       //是否有煤气瓶柜
  BoolQJG      : Boolean;       //是否有切角柜
  List         : T_List;         //订单列表
  T_S          : TDateTime;     //模块运行效率计算——起始时间
  pb2          : TPBRun;        //多线程显示进度条

const

  CAB_UP   : Integer = 0;
  CAB_DOWN : Integer = 1;

  I_LAB_DOOR : Integer = 0;    //打印门板标签
  I_LAB_BODY : Integer = 1;
  I_LAB_BACK : Integer = 2;

  I_PRD : Integer = 0;           //生产制作单
  I_PRO : Integer = 1;           //开料计划表
  I_PRC : Integer = 2;           //报价单

  CUT_NIL: Integer = -1;          //不是特殊柜体，不绘图
  CUT_QJ : Integer =  0;          //切角板
  CUT_ZQJ: Integer =  1;          //中切角
  CUT_SWJ: Integer =  2;          //上挖角板
  CUT_XWJ: Integer =  3;          //下挖角板
  CUT_MQP: Integer =  4;          //煤气瓶柜体

  I_BOD_DOOR :  Integer = 0  ;    //门板
  I_BOD_BACK :  Integer = 1  ;    //背板
  I_BOD_C_B_ :  Integer = 2  ;    //侧板
  I_BOD_DDB_ :  Integer = 3  ;    //底顶板
  I_BOD_G_B_ :  Integer = 4  ;    //隔板
  I_BOD_QLT_ :  Integer = 5  ;    //前拉条
  I_BOD_HLT_ :  Integer = 6  ;    //后拉条
  I_BOD_L_T_ :  Integer = 7  ;    //拉条
  I_BOD_FJB_ :  Integer = 8  ;    //附加板
  I_BOD_BODY :  Integer = 9  ;    //柜体板
  I_BOD_MAX_ :  Integer = 10 ;    //最大板材数

  S_BOD_NAME :  array [ 0..10 ] of string = (
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''门板''',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''背板''',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''侧板'' ',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''底顶板'',''顶底板'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''隔板'',''搁板'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''前拉条'',''拉条'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''后拉条''',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''前拉条'',''拉条'',''后拉条'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name NOT IN(''侧板'',''底顶板'',''顶底板'',''隔板'',''搁板'',''前拉条'',''拉条'',''后拉条'',''背板'',''门板'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name NOT IN(''背板'',''门板'')',
  'SELECT Max(Num) AS Num1 FROM BoardSum WHERE 1=1 ');

  S_TAB_NAME : array [ 0..10 ] of string = (
  'List',     'TCab',      'TBod',     'THDWare',
  '面积统计', 'BoardSum',  'PrcList1', 'PrcList2',
  'PrcList3', 'HDWareSum', 'PrcList5');

  IS_BODFILE    : Integer = 0 ;
  IS_HDWAREFILE : Integer = 1 ;
  IS_OTHERFILE  : Integer = 2 ;

{$ENDREGION}
implementation

/// <summary>
/// 显示滚动条
/// </summary>
procedure PbShow();
begin
  F_PB.pb1.Max      := 100;
  F_PB.pb1.Position := 0;
  F_PB.Caption      := '请等待…';
  F_PB.Show;
  pb2 := TPBRun.Create(True);
  pb2.BoolRun := True;
  pb2.Resume;
end;

/// <summary>
/// 隐藏滚动条
/// </summary>
procedure PbHide();
begin

  pb2.BoolRun := False;
  pb2.Terminate;
  F_PB.Hide;
end;

/// <summary>
/// 开始时间
/// </summary>
procedure Timing_Begin();
begin
  T_S := Now;
end;

/// <summary>
/// 代码用时
/// </summary>
procedure Timing_End();
begin
  Send('Used : ' + VarToStr(MilliSecondsBetween(Now, T_S) / 1000));
end;

function GetBoardNum(IBoardNam : Integer): Integer;
var
  strSQL : string;
  AQry1 : TADOQuery;
begin

  strSQL := S_BOD_NAME[ IBoardNam ] + ' AND ListID=''' + strListID + '''';

  AQry1 := TADOQuery.Create(nil);
  AQry1.ConnectionString := getConStr();
  AQry1.Close;
  AQry1.SQL.Clear;
  AQry1.SQL.Add(strSQL);
  AQry1.Open;
  Result := FieldInt( AQry1, 'Num1') ;
  AQry1.Close;
  AQry1.Free;

end;
{
function ADOCMD(strSQL : string): Integer;
var
  AQryTem: TADOQuery;
begin
  AQryTem := TADOQuery.Create(nil);
  AQryTem.ConnectionString := GetStrCon();
  AQryTem.Close;
  AQryTem.SQL.Clear;
  AQryTem.SQL.Add(strSQL);
  Result := AQryTem.ExecSQL;
  AQryTem.Close;
  AQryTem.Free;
end;}

/// <summary>
/// 读取报表配置
/// </summary>
/// <param name="iType">生产制作单 开料计划表 报检单</param>
procedure ReadFZFormIniFile(iType : Integer);
var
  IniFile : TIniFile;
  strTyp : string;
begin
  IniFile := TIniFile.Create(AppPath + KEY_FILENAME);
  if iType = I_PRD then strTyp := 'PrdOpt';
  if iType = I_PRO then strTyp := 'ProOpt';
  if iType = I_PRC then strTyp := 'PrcOpt';

  ftT := IniFile.ReadString(strTyp, 'TitleFont',  '黑体');
  ftM := IniFile.ReadString(strTyp, 'MinTitFont', '黑体');
  ftB := IniFile.ReadString(strTyp, 'BodyFont',   '宋体');
  fzT := StrToInt(IniFile.ReadString(strTyp, 'TitleFontSize',  '0'));
  fzM := StrToInt(IniFile.ReadString(strTyp, 'MinTitFontSize', '0'));
  fzB := StrToInt(IniFile.ReadString(strTyp, 'BodyFontSize',   '0'));

  IniFile.Free;
end;

/// <summary>
/// 读取配置
/// </summary>
procedure ReadIniFile();
var
  IniFile : TIniFile;
begin
  IniFile   := TIniFile.Create(AppPath + KEY_FILENAME);
  ptType    := StrToInt(IniFile.ReadString('SysOpt', 'ptType',    '1'));
  ptCutSize := StrToInt(IniFile.ReadString('SysOpt', 'ptCutSize', '0'));
  ptMQP     := StrToInt(IniFile.ReadString('SysOpt', 'ptMQP',     '0'));
  ptMQP_A   := StrToInt(IniFile.ReadString('SysOpt', 'ptMQP_A',   '250'));
  ptDoorPrc := StrToInt(IniFile.ReadString('SysOpt', 'ptDoorPrc', '0'));
  ptDifMod  := StrToInt(IniFile.ReadString('SysOpt', 'ptDifMod',  '0'));
  IniFile.Free;
end;

/// <summary>
/// 保存配置
/// </summary>
procedure SaveIniFile();
var
  IniFile : TIniFile;
begin
  IniFile   := TIniFile.Create(AppPath + KEY_FILENAME);
  IniFile.WriteString('SysOpt', 'ptType',    ItoS(ptType)   );
  IniFile.WriteString('SysOpt', 'ptCutSize', ItoS(ptCutSize));
  IniFile.WriteString('SysOpt', 'ptMQP',     ItoS(ptMQP)    );
  IniFile.WriteString('SysOpt', 'ptMQP_A',   ItoS(ptMQP_A)  );
  IniFile.WriteString('SysOpt', 'ptDoorPrc', ItoS(ptDoorPrc));
  IniFile.WriteString('SysOpt', 'ptDifMod',  ItoS(ptDifMod) );
  IniFile.Free;
end;


/// <summary>
/// get ConnectionString for dat
/// </summary>
/// <param name="i_typ">1:dat1; 2:dat2</param>
/// <returns></returns>
function  getConStr_Import(i_typ: Integer): string;
var
  file1, file2, path, pass: string;
  IniFile: TIniFile;
begin
  IniFile   := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  file1 	  := IniFile.ReadString('dbDat', 'dat1', 'anaor.dat')	;
  file2     := IniFile.ReadString('dbDat', 'dat2', 'Material.dat');
  path      := IniFile.ReadString('dbDat', 'datPath',  ' ')	;
  pass  	  := IniFile.ReadString('dbDat', 'datPswd',  ' '  )	;

  IniFile.Free;

  if i_typ = 1 then
  begin
    Result := 'Provider=Microsoft.Jet.OLEDB.4.0;'
      + 'Data Source=' + path + file1 + '.mdb;'
      + 'Jet OLEDB:Database Password=' + pass + ';'
      + 'Persist Security Info=False';
  end
  else
  begin
    Result := 'Provider=Microsoft.Jet.OLEDB.4.0;'
      + 'Data Source=' + path + file2 + '.mdb;'
      + 'Jet OLEDB:Database Password=' + pass + ';'
      + 'Persist Security Info=False';
  end;
end;

procedure decDatFile();
var
  iniFile: TIniFile;
  path, file1, file2: string;
begin
  iniFile   := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  file1 	  := IniFile.ReadString('dbDat', 'dat1', 'anaor.dat')	;
  file2     := IniFile.ReadString('dbDat', 'dat2', 'Material.dat');
  path      := IniFile.ReadString('dbDat', 'datPath',  ' ')	;

  decDatFile(path + file1);
  decDatFile(path + file2);
end;

procedure decDatFile(fileName: string);
var
  strm1: TFileStream;
  strm2: TFileStream;
  i_len: Int64;
  b1: TByteDynArray; //array of Byte;
  i, i1, i2: Integer;
  b2: Byte;
const
  i_h: array[0..15] of Integer = (1, 0, 3, 2, 5, 4, 7, 6, 9, 8, $b, $a, $d, $c, $f, $e);
  i_l: array[0..15] of Integer = (5, 4, 7, 6, 1, 0, 3, 2, $d, $c, $f, $e, 9, 8, $b, $a);
begin
  {strm1 := TFileStream.Create(fileName, fmOpenRead);
  i_len := strm1.Size;
  SetLength(b1, i_len);
  strm1.Position := 0;
  strm1.Read(b1, i_len);
  strm1.Free; }
  b1 := FiIeToByteArray(fileName);

  //软件运行时数据库格式会不同，运行时byte[0]=00,关闭后byte[0]=15
  if b1[0] <> 00 then
  begin
    //开始转换
    for i := 0 to $3FF do
    begin
      b2 := b1[i];
      i1 := b2 div $10;
      i2 := b2 mod $10;
      b1[i] := i_h[i1] * $10 + i_l[i2];
    end;
  end;

  {strm2 := TFileStream.Create(fileName + '.mdb', fmCreate);
  strm2.Position := 0;
  strm2.Write(b1, i_len);
  strm2.Free;}

  ByteArrayToFile(b1, fileName + '.mdb');
end;


end.
























