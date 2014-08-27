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
  //���
  P_PBoard = ^T_Board;
  T_Board = record
    Index      : Integer;                                                       //���
    cabIndex   : Integer;                                                       //�������
    bodID      : Integer;                                                       //������
    bodH       : Double;                                                        //��
    bodW       : Double;                                                        //��
    bodNum     : Integer;                                                       //����
    bodXZh     : string; 			                                                  //��ת �޸�ԭ����������
    bodCZh     : string; 			                                                  //����
    bodOth     : string;                                                        //��ע
    bodFlag    : string;                                                        //ͼ��
    bodName    : string;                                                        //����
    bodType    : string;                                                        //���� �Ϲ��¹�
    bodEdge    : Double;                                                        //���
    bodArea    : Double;                                                        //���
    bodPrice   : Double;                                                        //�۶�
    cabNam     : string;     			                                              //�������ƣ�����
    bodInfo    : string;    			                                              //���գ���������
  end;

  //���
  P_PhdWare = ^T_hdWare;
  T_hdWare = record
    Index      : Integer;                                                       //���
    cabIndex   : Integer;                                                       //���
    cabFlag    : string;                                                        //����ͼ��
    hdID       : Integer;                                                       //������
    hdNum      : Integer;                                                       //����
    hdCZh      : string; 			                                                  //����
    hdOth      : string;                                                        //��ע
    hdFlag     : string;                                                        //ͼ��
    hdName     : string;                                                        //����
    cabType    : string;                                                        //���� �Ϲ��¹�
    strType    : string;                                                        //��𡢷����
    hdArea     : Double;                                                        //���
    hdPrice    : Double;                                                        //����
    hdSumPrice : Double;                                                        //���
    cabNam     : string;     		                                             	  //�������ƣ�����
    hdInfo     : string;    		                                                //���գ���������
  end;

  //����
  P_PCabinet = ^T_Cabinet;
  T_Cabinet = record
    Index     : Integer;                                                        //���
    cabID     : string;                                                         //���
    cabW      : Double;                                                         //��
    cabH      : Double;                                                         //��
    cabD      : Double;                                                         //��
    cabC_W    : Double;                                                         //�ϼƿ��
    cabW_H_D  : string;                                                         //�ߴ�
    cabTypeID : string;                                                         //�Ϲ�W���¹�B
    cabName   : string;                                                         //����
    cabOth    : string;                                                         //��ע
    cabType   : string;                                                         //�Ϲ��¹�
    cabGB     : string;                                                         //���޸���
    bodyCZ    : string;                                                         //�������
    doorCZ    : string;                                                         //�Ű����
    backCZ    : string;                                                         //�������

    cabNum    : Integer;                                                        //����
    cabNDoor  : Integer;                                                        //�Ű�����
    cabNBack  : Integer;                                                        //���������
    cabNBody  : Integer;                                                        //��������
    cabNCB    : Integer;                                                        //�������
    cabNLT    : Integer;                                                        //��������
    cabNFLT   : Integer;                                                        //ǰ��������
    cabNBLT   : Integer;                                                        //����������
    cabNGB_G  : Integer;                                                        //�������� ���
    cabNGB    : Integer;                                                        //�������� �̸�
    cabNDDB   : Integer;                                                        //�׶�������
    cabNBUp   : Integer;                                                        //��������
    cabNBDown : Integer;                                                        //�װ�����
    cabNFJB   : Integer;                                                        //���Ӱ�����
    cabBodNum : Integer;                                                        //�������
    cabhdwNum : Integer;                                                        //�������
    AreaDoor  : Double;                                                         //�Ű����
    AreaBack  : Double;                                                         //�������
    AreaBody  : Double;                                                         //��������
    PrcDoor   : Double;                                                         //�Ű�۸�
    PrcBack   : Double;                                                         //����۸�
    PrcBody   : Double;                                                         //�����۸�
    PrcAll    : Double;                                                         //����۸�
    bod       : array of T_Board;                                               //�������
    hdw       : array of T_hdWare;                                              //�������
  end;

  //��ӡ��ǩ������ϸ
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
    bodInfo   : string;           //��;
    bodNum    : Integer;          //
    bodCount  : Integer;          //
    bodW      : Double;           //
    bodH      : Double;           //
  end;

  //��ӡ��ǩҳ�����ݷ��ദ��
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

  //����������
  P_PCabPrd = ^T_CabPrd;
  T_CabPrd = record
    cabIndex  : Integer;          //���
    cabName   : string;           //��������
    cabTypeID : string;           //�¹�B �Ϲ�W
    cabW_H_D  : string;           //�ߴ�
    cabD      : Double;           //��
    bodCB     : array of string;  //���
    bodDDB    : array of string;  //�׶���
    bodBUp    : array of string;  //���塢
    bodBDown  : array of string;  //�װ�
    bodGB_G   : array of string;  //���� �̸�
    bodGB     : array of string;  //���� ���
    bodLT     : array of string;  //����
    bodQLT    : array of string;  //ǰ����
    bodHLT    : array of string;  //������
    bodFJB    : array of string;  //���Ӱ�
    bodBack   : array of string;  //����
    bodDoor   : array of string;  //�Ű�
    cabNum    : Integer;          //����
    cutType   : Integer;          //�н����ͣ��нǣ��ڽǣ����нǣ�
    cutA      : Double;           //�нǳߴ�A
    cutB      : Double;           //�нǳߴ�B
    cutC      : Double;           //�нǳߴ�C
    cutGB_A   : Double;           //����A
    cutGB_B   : Double;           //����B
    TabH      : Integer;          //����������
    cut_GB    : Boolean;          //�Ƿ��и���
    showCab   : Boolean;          //�Ƿ���ʾ��ģ��
  end;

  //���ܣ���������壬����(������������β)
  P_PCabPrdOth = ^T_CabPrdOth;
  T_CabPrdOth = record
    Index      : Integer;            //���
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
    showPrdOth : Boolean;            //�Ƿ���ʾ����ģ��
  end;

  //����Ӽ۹�ʽ�����
  P_TCabTsPrc = ^TCabTsPrc;
  TCabTsPrc = record
    Name       : string;            //����
    GS         : string;            //��ʽ
    Prc        : Double;            //�۸�
  end;


  TCabDrawer = record
    Name      :string;
    ChBang    :string;              //���
    ChWei     :string;              //��β
    ChDi      :string;              //���
  end;
  //����
  P_PList = ^T_List;
  T_List = record
    Index      : Integer;            //���
    strListID  : string;             //�������
    strSDate   : string;             //��������
    strAddress : string;             //��װ��ַ
    strUseName : string;             //�ͻ�����
    strUsePho  : string;             //�ͻ���ϵ��ʽ
    CreateDate : string;              //��������
    State      : string;              //״̬
    strFBGY    : string;             //��߹���
    CZhDoor    : string;             //�Ű����
    CZhBack    : string;             //�������
    CZhBody    : string;             //��������
    strPrcOth  : string;             //��������
    NumDoor    : Integer;            //�Ű�����
    NumBack    : Integer;            //��������
    NumBody    : Integer;            //�����
    NumGB_G    : Integer;            //���� �̸�
    NumGB      : Integer;            //���� ���
    NumLT      : Integer;            //����
    NumQLT     : Integer;            //ǰ����
    NumHLT     : Integer;            //������
    NumCB      : Integer;            //�������
    NumDDB     : Integer;            //�׶���
    NumBUp     : Integer;            //����
    NumBDown   : Integer;            //�װ�
    NumFJB     : Integer;            //���Ӱ�����
    NumCabUp   : Integer;            //�Ϲ�����
    NumCabDown : Integer;            //�¹�����
    NumPrcOth  : Integer;            //��������
    PrcDoor    : Double;             //�Ű���ʵ���
    PrcBody    : Double;             //�������ʵ���
    PrcBack    : Double;             //������ʵ���
    SumPrcDoor : Double;             //�Ű�ϼƼ۸�
    SumPrcBody : Double;             //�����ϼƼ۸�
    SumPrcBack : Double;             //����ϼƼ۸�
    SumPrcBod  : Double;             //��ļ۸�
    SumPrcHD_  : Double;             //���۸�
    SumPrcTS_  : Double;             //����Ӽ�
    Prc_Pay    : Double;              //���
    Prc_Income : Double;              //�Ѹ�
    AreaDoor   : Double;             //�Ű����
    AreaBack   : Double;             //�������
    AreaBody   : Double;             //��������
    AreaGB     : Double;             //����
    AreaDDB    : Double;             //�׶���
    AreaQLT    : Double;             //ǰ����
    AreaHLT    : Double;             //������
    AreaCB     : Double;             //���
    AreaFJB    : Double;             //���Ӱ�
    cabPrdOth  : T_CabPrdOth;         //����ģ��
    bodLabs    : T_BodLabs;           //ͳ�ƺ��ǩ
    bodLab     : array of T_BodLab;   //δͳ�Ʊ�ǩ
    cab        : array of T_Cabinet;  //�����б�
    cabPrd     : array of T_CabPrd;   //����������
    hdwPrc     : array of T_hdWare;   //���ͳ��
    tsPrc      : array of TCabTsPrc;  //����Ӽ۹�ʽ�����
    cabDrawer  : array of TCabDrawer; //���뱨������

    doorOth_col: TStrings;
    doorOth_val: TStringList;
  end;

{$REGION '����������'}
var
  ILineWidth   : Integer;       //���߿���
  fzTitle      : Integer;       //���������С
  fzMinTit     : Integer;       //С�����ֺ�
  fzBody       : Integer;       //���������С
  fzT,fzM,fzB  : Integer;       //���⡢С���⣬������������ֵ
  ftT,ftM,ftB  : string;        //���⣬С���⣬������������
  ptType       : Integer;       //������ʾ��ʽ��1����ʾ�������� 2���¹�B���Ϲ�W
  ptCutSize    : Integer;       //�нǹ񿪿ڳߴ� 0.���Ӱ�ĺ�� 1.�Ӱ�ĺ��
  ptMQP        : Integer;       //ú��ƿ�� 0.���ж� 1.�жϲ���ͼ
  ptMQP_A      : Integer;       //����A��ֵ
  ptDoorPrc    : Integer;       //�Ű��� 0.ͳ�� 1.��ͳ��
  ptDifMod     : Integer;       //������ʾ���ܣ���������壬���ϣ�0.���ж� 1.�ж�
  TabOldLineH  : Double;        //���ԭʼ�и�
  TabLineH     : Double;        //����и�
  fLBoottom    : Double;        //�����±߾�
  fbBody       : Double;        //������
  fbDoor       : Double;        //�Ű���
  fbBack       : Double;        //������
  IntBodD      : Integer;       //��ĺ��
  IntAddYear   : Integer;       //�������+
  PrcRound     : Integer;       //����С��
  AreaRound    : Integer;       //�������С��λ��
  strTabPrc    : string;        //���۵�
  strTabPrd    : string;        //����������
  strTabPro    : string;        //���ϼƻ���
  BoolFName    : Boolean;       //xls�ļ��Ƿ���ȷ
  strListID    : string;        //�������
  strName      : string;        //�ͻ�����
  strPhone     : string;        //��ϵ��ʽ
  strSDate     : string;        //��������
  strAddress   : string;        //��װ��ַ
  strBod_Door  : string;        //�Ű����
  strBod_Body  : string;        //�������
  strBod_Back  : string;        //�������
  strFBGY      : string;        //��߹���
  strW         : string;        //��
  strH         : string;        //��
  strD         : string;        //��
  strNumber    : string;        //����
  strCabinet   : string;        //��������
  strStandard  : string;        //��׼�񣬷Ǳ�׼��
  strCabinetID : string;        //������
  BoolMQPG     : Boolean;       //�Ƿ���ú��ƿ��
  BoolQJG      : Boolean;       //�Ƿ����нǹ�
  List         : T_List;         //�����б�
  T_S          : TDateTime;     //ģ������Ч�ʼ��㡪����ʼʱ��
  pb2          : TPBRun;        //���߳���ʾ������

const

  CAB_UP   : Integer = 0;
  CAB_DOWN : Integer = 1;

  I_LAB_DOOR : Integer = 0;    //��ӡ�Ű��ǩ
  I_LAB_BODY : Integer = 1;
  I_LAB_BACK : Integer = 2;

  I_PRD : Integer = 0;           //����������
  I_PRO : Integer = 1;           //���ϼƻ���
  I_PRC : Integer = 2;           //���۵�

  CUT_NIL: Integer = -1;          //����������壬����ͼ
  CUT_QJ : Integer =  0;          //�нǰ�
  CUT_ZQJ: Integer =  1;          //���н�
  CUT_SWJ: Integer =  2;          //���ڽǰ�
  CUT_XWJ: Integer =  3;          //���ڽǰ�
  CUT_MQP: Integer =  4;          //ú��ƿ����

  I_BOD_DOOR :  Integer = 0  ;    //�Ű�
  I_BOD_BACK :  Integer = 1  ;    //����
  I_BOD_C_B_ :  Integer = 2  ;    //���
  I_BOD_DDB_ :  Integer = 3  ;    //�׶���
  I_BOD_G_B_ :  Integer = 4  ;    //����
  I_BOD_QLT_ :  Integer = 5  ;    //ǰ����
  I_BOD_HLT_ :  Integer = 6  ;    //������
  I_BOD_L_T_ :  Integer = 7  ;    //����
  I_BOD_FJB_ :  Integer = 8  ;    //���Ӱ�
  I_BOD_BODY :  Integer = 9  ;    //�����
  I_BOD_MAX_ :  Integer = 10 ;    //�������

  S_BOD_NAME :  array [ 0..10 ] of string = (
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''�Ű�''',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''����''',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''���'' ',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''�׶���'',''���װ�'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''����'',''���'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''ǰ����'',''����'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name=''������''',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name IN(''ǰ����'',''����'',''������'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name NOT IN(''���'',''�׶���'',''���װ�'',''����'',''���'',''ǰ����'',''����'',''������'',''����'',''�Ű�'')',
  'SELECT SUM(Num) AS Num1 FROM BoardSum WHERE Name NOT IN(''����'',''�Ű�'')',
  'SELECT Max(Num) AS Num1 FROM BoardSum WHERE 1=1 ');

  S_TAB_NAME : array [ 0..10 ] of string = (
  'List',     'TCab',      'TBod',     'THDWare',
  '���ͳ��', 'BoardSum',  'PrcList1', 'PrcList2',
  'PrcList3', 'HDWareSum', 'PrcList5');

  IS_BODFILE    : Integer = 0 ;
  IS_HDWAREFILE : Integer = 1 ;
  IS_OTHERFILE  : Integer = 2 ;

{$ENDREGION}
implementation

/// <summary>
/// ��ʾ������
/// </summary>
procedure PbShow();
begin
  F_PB.pb1.Max      := 100;
  F_PB.pb1.Position := 0;
  F_PB.Caption      := '��ȴ���';
  F_PB.Show;
  pb2 := TPBRun.Create(True);
  pb2.BoolRun := True;
  pb2.Resume;
end;

/// <summary>
/// ���ع�����
/// </summary>
procedure PbHide();
begin

  pb2.BoolRun := False;
  pb2.Terminate;
  F_PB.Hide;
end;

/// <summary>
/// ��ʼʱ��
/// </summary>
procedure Timing_Begin();
begin
  T_S := Now;
end;

/// <summary>
/// ������ʱ
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
/// ��ȡ��������
/// </summary>
/// <param name="iType">���������� ���ϼƻ��� ���쵥</param>
procedure ReadFZFormIniFile(iType : Integer);
var
  IniFile : TIniFile;
  strTyp : string;
begin
  IniFile := TIniFile.Create(AppPath + KEY_FILENAME);
  if iType = I_PRD then strTyp := 'PrdOpt';
  if iType = I_PRO then strTyp := 'ProOpt';
  if iType = I_PRC then strTyp := 'PrcOpt';

  ftT := IniFile.ReadString(strTyp, 'TitleFont',  '����');
  ftM := IniFile.ReadString(strTyp, 'MinTitFont', '����');
  ftB := IniFile.ReadString(strTyp, 'BodyFont',   '����');
  fzT := StrToInt(IniFile.ReadString(strTyp, 'TitleFontSize',  '0'));
  fzM := StrToInt(IniFile.ReadString(strTyp, 'MinTitFontSize', '0'));
  fzB := StrToInt(IniFile.ReadString(strTyp, 'BodyFontSize',   '0'));

  IniFile.Free;
end;

/// <summary>
/// ��ȡ����
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
/// ��������
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

  //�������ʱ���ݿ��ʽ�᲻ͬ������ʱbyte[0]=00,�رպ�byte[0]=15
  if b1[0] <> 00 then
  begin
    //��ʼת��
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
























