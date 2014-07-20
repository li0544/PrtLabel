unit U_Prt_Prd3;

interface

{$DEFINE PRC_HIDE}  //���ؼ۸�
{$DEFINE v1_74c}    //v1_74c �нǲ������¹񣬸���ߴ���нǴ�1

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RpDefine, RpBase, RpSystem, DB, ADODB, UParam,
  U_Prt_Drawer, UDebug, UADO,
  UPub;

type
  TF_Prt_Prd2 = class(TForm)
    RvSystem1: TRvSystem;
    BtnPrintProduce: TButton;
    qry1: TADOQuery;
    qry2: TADOQuery;
    qry3: TADOQuery;
    ds1: TDataSource;
    Button1: TButton;
    Button2: TButton;
    RvSysBody: TRvSystem;
    RvSysDoor: TRvSystem;
    RvSysHDW: TRvSystem;
    RvSysHDW2: TRvSystem;
    btnDrawer: TButton;
    procedure BtnPrintProduceClick(Sender: TObject);
    procedure RvSystem1Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RvSysBodyPrint(Sender: TObject);
    procedure RvSysDoorPrint(Sender: TObject);
    procedure RvSysHDWPrint(Sender: TObject);
    procedure RvSysHDW2Print(Sender: TObject);
    procedure btnDrawerClick(Sender: TObject);
  private
    { Private declarations }
    procedure PrintAllColumns(var Sender: TObject);
    procedure PrintBodyColumns(var Sender: TObject);
    procedure PrintDoorColumns(var Sender: TObject);
    procedure PrintHdwColumns(var Sender: TObject);
    procedure PrintHdw2Columns(var Sender: TObject);
    procedure InitData();
  public
    { Public declarations }
  end;

var
  F_Prt_Prd2: TF_Prt_Prd2;


  l1, l2, l3, l4, l5, l6, l7, l8, l9, l0: Double;
  c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c0: Double;
  l, x1, x2, x3, y1, y2, y3: Double;
  sTit: string;

  IThick_Board: Integer; //��ĺ��
  IAdge_Door, IAdge_Body: Double;
  s_sql: string;
  cab_nam, cab_w: string;
  s0, s1, s2, s3, s4, s5, s6, s7, s8, s9: string;
  d0, d1, d2, d3, d4, d5, d6: Double;
  i1, i2, i3: Integer;
  b1, b2, b3, b4: Boolean;
  tabTop, tabBottom, tabLeft, tabRight: Double;


implementation

uses U_Prt_Prc2;


{$R *.dfm}


procedure TF_Prt_Prd2.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry2.Close;
  qry3.Close;
  qry1.ConnectionString := getConStr();
  qry2.ConnectionString := getConStr();
  qry3.ConnectionString := getConStr();

end;

procedure TF_Prt_Prd2.InitData();
var
  strSQL : string;
begin
 //_____________________________��ʼ������___________________________________

  if strTabPrd <> '' then
    sTit := strTabPrd
  else
    sTit := '***����˾ ����';

  strSQL := 'SELECT * FROM TOption WHERE ���� LIKE ''�Ű���''';
  AQrySel(qry1, strSQL);
  IAdge_Door := qry1.FieldValues['Val'];
  IAdge_Door := IAdge_Door * 2;

  strSQL := 'SELECT * FROM TOption WHERE ���� LIKE ''������''';
  AQrySel(qry1, strSQL);
  IAdge_Body := qry1.FieldValues['Val'];
  IAdge_Body := IAdge_Body * 2;

end;

procedure TF_Prt_Prd2.PrintAllColumns(var Sender: TObject);
var
  rowH , rowW : Double ;
begin
  with Sender AS TBaseReport do
  begin
    //__________________________��ȡ���������Ϣ________________________________
    ReadFZFormIniFile(I_PRD);
    rowH := LineHeight * TabLineH;
    
    //___________________________��ӡ��ͷ�ͱ�β_________________________________
    SectionTop    := 0.75;              //���˱߾�
    SectionLeft   := 0.5 ;
    SectionBottom := PageHeight - 0.3 ;
    SectionRight  := PageWidth  - 0.5 ;

    //___________________________��ӡҳ�롢����_________________________________
    PrintFooter('����' + IntToStr(CurrentPage) + 'ҳ', pjLeft); //ҳ��
    PrintFooter('����: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //����
    SetTopOfPage;

    YPos := 0.8;
    //_____________________________��ӡ��ͷ_____________________________________
    SetFont(ftT, fzTitle + fzT); //��������
    PrintCenter(strTabPrd , PageWidth / 2);
    NewLine;

    SetFont(ftB, fzBody + fzB);
    rowW := 1.8;
    XPos := SectionLeft + rowW * 0 ; 		 Print('������ţ�');     Print(strListID);
    XPos := SectionLeft + rowW * 1 ;     Print('�µ����ڣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('�������ڣ�');     Print(strSDate);
    XPos := SectionLeft + rowW * 3 ;     Print('�𵥣�');
    XPos := SectionLeft + rowW * 4 ;     Print('��ˣ�');
    XPos := SectionLeft + rowW * 5 ;     Print('����״̬��');
    //_____________________��ӡ˫����_______________________
		YPos := YPos + 0.05;
    x1 := SectionLeft;			x2 := SectionRight;
    MoveTo(x1, YPos);       LineTo(x2, YPos);
    YPos := YPos + 0.02;
    MoveTo(x1, YPos);			  LineTo(x2, YPos);
    NewLine;

		YPos := YPos + fLBoottom;
		rowW := 2.5;
    XPos := SectionLeft + rowW * 0 ;  Print('�ͻ�������');    Print(strName);
    XPos := SectionLeft + rowW * 1 ;	Print('�绰��');        Print(strPhone);
    XPos := SectionLeft + rowW * 2 ;	Print('�ͻ���ַ��');    Print(strAddress);
    NewLine;
    YPos := YPos + fLBoottom;
    XPos := SectionLeft + rowW * 0 ;  Print('����壺');      Print(strBod_Body);
    XPos := SectionLeft + rowW * 1 ;  Print('�Ű壺');        Print(strBod_Door);
		XPos := SectionLeft + rowW * 2 ;  Print('���壺');        Print(strBod_Back);
    
    //_____________________��ӡ�б���_______________________
    x1  := 1.28; 		                  //�����п�
    x2  := 0.95;			                //����п�
    x3  := PageWidth - 2 * x1 - 8 * x2; //���Ӱ��п�
    c1  := 0.50;
    c2  := c1  + 0.30;                //NO
    c3  := c2  + x1;                  //����
    c4  := c3  + x2;                  //���
    c5  := c4  + x2;                  //�׶���
    c6  := c5  + x2;                  //�㡢����
    c7  := c6  + x2;                  //����
    c8  := c7  + x2;                  //����
    c9  := c8  + x3;                  //���Ӱ�
    c10 := c9  + x2;                  //����
    c11 := c10 + x2;                  //�Ű�
    c12 := c11 + x2 + 0.15;           //��ע
    c0  := c12;                       //11.0 +0.15

    YPos := YPos + fLBoottom; //����ϱ߿�
    MoveTo(c1, YPos);     LineTo(c0, YPos);
    tabTop := YPos;
    tabLeft := c1;        tabRight := c0;

    l := 0.10;
    YPos := YPos + rowH;
    PrintXY( c1  + l,  YPos , 'NO');
    PrintXY( c2  + l,  YPos , '����');
    PrintXY( c3  + l,  YPos , '���');
    PrintXY( c4  + l,  YPos , '�׶���');
    PrintXY( c5  + l,  YPos , '����');
    PrintXY( c6  + l,  YPos , 'ǰ����');
    PrintXY( c7  + l,  YPos , '������');
    PrintXY( c8  + l,  YPos , '���Ӱ�');
    PrintXY( c9  + l,  YPos , '����');
    PrintXY( c10 + l,  YPos , '�Ű�');
    PrintXY( c11 + l,  YPos , '��ע');

    //________________________����___________________________

    YPos := YPos + fLBoottom ;
    MoveTo(c1, YPos);     LineTo(c0, YPos);
  end;
end;

procedure TF_Prt_Prd2.PrintBodyColumns(var Sender: TObject);
var
  rowH , rowW : Double ;
begin
  with Sender AS TBaseReport do
  begin
    //__________________________��ȡ���������Ϣ________________________________
    ReadFZFormIniFile(I_PRD);
    rowH := LineHeight * TabLineH;
    
    //___________________________��ӡ��ͷ�ͱ�β_________________________________
    SectionTop    := 0.75;              //���˱߾�
    SectionLeft   := 0.5 ;
    SectionBottom := PageHeight - 0.3 ;
    SectionRight  := PageWidth  - 0.5 ;

    //___________________________��ӡҳ�롢����_________________________________
    PrintFooter('����' + IntToStr(CurrentPage) + 'ҳ', pjLeft); //ҳ��
    PrintFooter('����: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //����
    SetTopOfPage;

    YPos := 0.8;
    //_____________________________��ӡ��ͷ_____________________________________
    SetFont(ftT, fzTitle + fzT); //��������
    PrintCenter(strTabPrd , PageWidth / 2);
    NewLine;

    SetFont(ftB, fzBody + fzB);
    rowW := 1.8;
    XPos := SectionLeft + rowW * 0 ; 		 Print('������ţ�');     Print(strListID);
    XPos := SectionLeft + rowW * 1 ;     Print('�µ����ڣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('�������ڣ�');     Print(strSDate);
    XPos := SectionLeft + rowW * 3 ;     Print('�𵥣�');
    XPos := SectionLeft + rowW * 4 ;     Print('��ˣ�');
    XPos := SectionLeft + rowW * 5 ;     Print('����״̬��');
    //_____________________��ӡ˫����_______________________
		YPos := YPos + 0.05;
    x1 := SectionLeft;			x2 := SectionRight;
    MoveTo(x1, YPos);       LineTo(x2, YPos);
    YPos := YPos + 0.02;
    MoveTo(x1, YPos);			  LineTo(x2, YPos);
    NewLine;

		YPos := YPos + fLBoottom;
		rowW := 2.5;
    XPos := SectionLeft + rowW * 0 ;  Print('�ͻ�������');    Print(strName);
    XPos := SectionLeft + rowW * 1 ;	Print('�绰��');        Print(strPhone);
    XPos := SectionLeft + rowW * 2 ;	Print('�ͻ���ַ��');    Print(strAddress);
    NewLine;
    YPos := YPos + fLBoottom;
    XPos := SectionLeft + rowW * 0 ;  Print('����壺');      Print(strBod_Body);
    XPos := SectionLeft + rowW * 1 ;  Print('��߹��գ�');    Print(strFBGY);
		XPos := SectionLeft + rowW * 2 ;  Print('���壺');        Print(strBod_Back);
    
    //_____________________��ӡ�б���_______________________
    x1  := 1.28; 		                  //�����п�
    x2  := 1.10;			                //����п�
    x3  := PageWidth - 2 * x1 - 7 * x2; //���Ӱ��п�
    c1  := 0.50;
    c2  := c1  + 0.30;                //NO
    c3  := c2  + x1;                  //����
    c4  := c3  + x2;                  //���
    c5  := c4  + x2;                  //�׶���
    c6  := c5  + x2;                  //�㡢����
    c7  := c6  + x2;                  //����
    c8  := c7  + x2;                  //����
    c9  := c8  + x3;                  //���Ӱ�
    c10 := c9  + x2;                  //����
//    c11 := c10 + x2;                  //�Ű�
    c12 := c10 + 1 + 0.15;           //��ע
    c0  := c12;                       //11.0 +0.15

    YPos := YPos + fLBoottom; //����ϱ߿�
    MoveTo(c1, YPos);     LineTo(c0, YPos);
    tabTop := YPos;
    tabLeft := c1;        tabRight := c0;

    l := 0.10;
    YPos := YPos + rowH;
    PrintXY( c1  + l,  YPos , 'NO');
    PrintXY( c2  + l,  YPos , '����');
    PrintXY( c3  + l,  YPos , '���');
    //PrintXY( c4  + l,  YPos , '�װ�');
    //PrintXY( c5  + l,  YPos , '����');
    //PrintXY( c6  + l,  YPos , '����');
    PrintXY( c4  + l,  YPos , '�׶���');
    PrintXY( c5  + l,  YPos , '�̸�');
    PrintXY( c6  + l,  YPos , '���');
    PrintXY( c7  + l,  YPos , '����');
    PrintXY( c8  + l,  YPos , '���Ӱ�');
    PrintXY( c9  + l,  YPos , '����');
//    PrintXY( c10 + l,  YPos , '�Ű�');
    PrintXY( c10 + l,  YPos , '��ע');

    //________________________����___________________________

    YPos := YPos + fLBoottom ;
    MoveTo(c1, YPos);     LineTo(c0, YPos);
  end;
end;

procedure TF_Prt_Prd2.PrintDoorColumns(var Sender: TObject);
var
  rowH , rowW : Double ;
begin
  with Sender AS TBaseReport do
  begin
    //__________________________��ȡ���������Ϣ________________________________
    ReadFZFormIniFile(I_PRD);
    rowH := LineHeight * TabLineH;
    
    //___________________________��ӡ��ͷ�ͱ�β_________________________________
    SectionTop    := 0.75;              //���˱߾�
    SectionLeft   := 0.5 ;
    SectionBottom := PageHeight - 0.3 ;
    SectionRight  := PageWidth  - 0.5 ;

    //___________________________��ӡҳ�롢����_________________________________
    PrintFooter('����' + IntToStr(CurrentPage) + 'ҳ', pjLeft); //ҳ��
    PrintFooter('����: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //����
    SetTopOfPage;

    YPos := 0.8;
    //_____________________________��ӡ��ͷ_____________________________________
    SetFont(ftT, fzTitle + fzT); //��������
    PrintCenter(strTabPrd , PageWidth / 2);
    NewLine;

    SetFont(ftB, fzBody + fzB);
    rowW := 1.8;
    XPos := SectionLeft + rowW * 0 ; 		 Print('������ţ�');     Print(strListID);
    XPos := SectionLeft + rowW * 1 ;     Print('�µ����ڣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('�������ڣ�');     Print(strSDate);
    NewLine;
    YPos := YPos - fLBoottom;
    XPos := SectionLeft + rowW * 0 ;     Print('�𵥣�');
    XPos := SectionLeft + rowW * 1 ;     Print('��ˣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('����״̬��');
    //_____________________��ӡ˫����_______________________
		YPos := YPos + 0.05;
    x1 := SectionLeft;			x2 := SectionRight;
    MoveTo(x1, YPos);       LineTo(x2, YPos);
    YPos := YPos + 0.02;
    MoveTo(x1, YPos);			  LineTo(x2, YPos);
    NewLine;

		YPos := YPos + fLBoottom;
		rowW := 2.5;
    XPos := SectionLeft + rowW * 0 ;  Print('�ͻ�������');    Print(strName);
    XPos := SectionLeft + rowW * 1 ;	Print('�绰��');        Print(strPhone);
    XPos := SectionLeft + rowW * 2 ;	Print('�ͻ���ַ��');    Print(strAddress);
    NewLine;
    YPos := YPos + fLBoottom;
    XPos := SectionLeft + rowW * 0 ;  Print('��߹��գ�');    Print(strFBGY);
    //XPos := SectionLeft + rowW * 0 ;  Print('����壺');      Print(strBod_Body);
    XPos := SectionLeft + rowW * 1 ;  Print('�Ű壺');        Print(strBod_Door);
		XPos := SectionLeft + rowW * 2 ;  Print('���壺');        Print(strBod_Back);
    
    //_____________________��ӡ�б���_______________________
    x1  := 3; 		                  //�����п�
    x2  := 1.5;			                //����п�
    x3  := PageWidth - 2 * x1 - 8 * x2; //���Ӱ��п�
    c1  := 0.50;
    c2  := c1  + 0.30;                //NO
    c3  := c2  + x1;                  //����

//    c10 := c2  + x2;                  //����
    c11 := c3 + x2;                  //�Ű���
    c12 := c11 + x2 + 0.15;           //��ע
    c12 := SectionRight;
    c0  := SectionRight;                       //11.0 +0.15

    YPos := YPos + fLBoottom;         //����ϱ߿�
    MoveTo(c1, YPos);     LineTo(c0, YPos);
    tabTop := YPos;
    tabLeft := c1;        tabRight := c0;

    l := 0.10;
    YPos := YPos + rowH;
    PrintXY( c1  + l,  YPos , 'NO');
    PrintXY( c2  + l,  YPos , '��������');

    PrintXY( c3 + l,  YPos , '�Ű���');
    PrintXY( c11 + l,  YPos , '��ע');

    //________________________����___________________________

    YPos := YPos + fLBoottom ;
    MoveTo(c1, YPos);     LineTo(c0, YPos);
  end;
end;

procedure TF_Prt_Prd2.PrintHdwColumns(var Sender: TObject);
var
  rowH , rowW : Double ;
begin
  with Sender AS TBaseReport do
  begin
    //__________________________��ȡ���������Ϣ________________________________
    ReadFZFormIniFile(I_PRD);
    rowH := LineHeight * TabLineH;
    
    //___________________________��ӡ��ͷ�ͱ�β_________________________________
    SectionTop    := 0.75;              //���˱߾�
    SectionLeft   := 0.5 ;
    SectionBottom := PageHeight - 0.3 ;
    SectionRight  := PageWidth  - 0.5 ;

    //___________________________��ӡҳ�롢����_________________________________
    PrintFooter('����' + IntToStr(CurrentPage) + 'ҳ', pjLeft); //ҳ��
    PrintFooter('����: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //����
    SetTopOfPage;

    YPos := 0.8;
    //_____________________________��ӡ��ͷ_____________________________________
    SetFont(ftT, fzTitle + fzT); //��������
    PrintCenter(strTabPrd , PageWidth / 2);
    NewLine;

    SetFont(ftB, fzBody + fzB);
    rowW := 2.5;
    XPos := SectionLeft + rowW * 0 ; 		 Print('������ţ�');     Print(strListID);
    XPos := SectionLeft + rowW * 1 ;     Print('�µ����ڣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('�������ڣ�');     Print(strSDate);
    NewLine;
    YPos := YPos + fLBoottom;
    XPos := SectionLeft + rowW * 0 ;     Print('�𵥣�');
    XPos := SectionLeft + rowW * 1 ;     Print('��ˣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('����״̬��');
    //_____________________��ӡ˫����_______________________
		YPos := YPos + 0.05;
    x1 := SectionLeft;			x2 := SectionRight;
    MoveTo(x1, YPos);       LineTo(x2, YPos);
    YPos := YPos + 0.02;
    MoveTo(x1, YPos);			  LineTo(x2, YPos);
    NewLine;

		YPos := YPos + fLBoottom;
		rowW := 2.5;
    XPos := SectionLeft + rowW * 0 ;  Print('�ͻ�������');    Print(strName);
    XPos := SectionLeft + rowW * 1 ;	Print('�绰��');        Print(strPhone);
    XPos := SectionLeft + rowW * 2 ;	Print('�ͻ���ַ��');    Print(strAddress);
    NewLine;
    YPos := YPos + fLBoottom;
    XPos := SectionLeft + rowW * 0 ;  Print('����壺');      Print(strBod_Body);
    XPos := SectionLeft + rowW * 1 ;  Print('�Ű壺');        Print(strBod_Door);
		XPos := SectionLeft + rowW * 2 ;  Print('���壺');        Print(strBod_Back);
    
    //_____________________��ӡ�б���_______________________
    x1  := 1.8; 		                  //�����п�
    x2  := 1.8;			                //����п�
    x3  := PageWidth - 2 * x1 - 2 * x2; //���Ӱ��п�
    c1  := 0.50;
    c2  := c1  + 0.30;                //NO
    c3  := c2  + x1;                  //��������
    c4  := c3  + 0.50;                //���
    c10 := c4  + x2;                  //�������
    c11 := c10 + 0.50;                  //�������
    c12 := c11 + x2 + 0.15;           //��ע
    c12 := SectionRight;
    c0  := SectionRight;                       //11.0 +0.15

    YPos := YPos + fLBoottom;         //����ϱ߿�
    MoveTo(c1, YPos);     LineTo(c0, YPos);
    tabTop := YPos;
    tabLeft := c1;        tabRight := c0;

    l := 0.10;
    YPos := YPos + rowH;
    PrintXY( c1  + l,  YPos , 'NO');
    PrintXY( c2  + l,  YPos , '��������');
    PrintXY( c3  + l,  YPos , '���');
    PrintXY( c4  + l,  YPos , '���');
    PrintXY( c10 + l,  YPos , '����');
    PrintXY( c11 + l,  YPos , '��ע');

    //________________________����___________________________

    YPos := YPos + fLBoottom ;
    MoveTo(c1, YPos);     LineTo(c0, YPos);
  end;
end;

procedure TF_Prt_Prd2.PrintHdw2Columns(var Sender: TObject);
var
  rowH , rowW : Double ;
begin
  with Sender AS TBaseReport do
  begin
    //__________________________��ȡ���������Ϣ________________________________
    ReadFZFormIniFile(I_PRD);
    rowH := LineHeight * TabLineH;
    
    //___________________________��ӡ��ͷ�ͱ�β_________________________________
    SectionTop    := 0.75;              //���˱߾�
    SectionLeft   := 0.5 ;
    SectionBottom := PageHeight - 0.3 ;
    SectionRight  := PageWidth  - 0.5 ;

    //___________________________��ӡҳ�롢����_________________________________
    PrintFooter('����' + IntToStr(CurrentPage) + 'ҳ', pjLeft); //ҳ��
    PrintFooter('����: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //����
    SetTopOfPage;

    YPos := 0.8;
    //_____________________________��ӡ��ͷ_____________________________________
    SetFont(ftT, fzTitle + fzT); //��������
    PrintCenter(strTabPrd , PageWidth / 2);
    NewLine;

    SetFont(ftB, fzBody + fzB);
    rowW := 2.5;
    XPos := SectionLeft + rowW * 0 ; 		 Print('������ţ�');     Print(strListID);
    XPos := SectionLeft + rowW * 1 ;     Print('�µ����ڣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('�������ڣ�');     Print(strSDate);
    NewLine;
    YPos := YPos + fLBoottom;
    XPos := SectionLeft + rowW * 0 ;     Print('�𵥣�');
    XPos := SectionLeft + rowW * 1 ;     Print('��ˣ�');
    XPos := SectionLeft + rowW * 2 ;     Print('����״̬��');
    //_____________________��ӡ˫����_______________________
		YPos := YPos + 0.05;
    x1 := SectionLeft;			x2 := SectionRight;
    MoveTo(x1, YPos);       LineTo(x2, YPos);
    YPos := YPos + 0.02;
    MoveTo(x1, YPos);			  LineTo(x2, YPos);
    NewLine;

		YPos := YPos + fLBoottom;
		rowW := 2.5;
    XPos := SectionLeft + rowW * 0 ;  Print('�ͻ�������');    Print(strName);
    XPos := SectionLeft + rowW * 1 ;	Print('�绰��');        Print(strPhone);
    XPos := SectionLeft + rowW * 2 ;	Print('�ͻ���ַ��');    Print(strAddress);
    NewLine;
    YPos := YPos + fLBoottom;
    XPos := SectionLeft + rowW * 0 ;  Print('����壺');      Print(strBod_Body);
    XPos := SectionLeft + rowW * 1 ;  Print('�Ű壺');        Print(strBod_Door);
		XPos := SectionLeft + rowW * 2 ;  Print('���壺');        Print(strBod_Back);
    
    //_____________________��ӡ�б���_______________________
    x1  := 1.8; 		                  //�����п�
    x2  := 1.8;			                //����п�
    x3  := PageWidth - 2 * x1 - 2 * x2; //���Ӱ��п�
    c1  := 0.50;
    c2  := c1  + 0.30;                //NO
    c10 := c2  + x2;                  //�������
    c11 := c10 + 0.50;                //�������
    c12 := c11 + x2 + 0.15;           //��ע
    c12 := SectionRight;
    c0  := SectionRight;                       //11.0 +0.15

    YPos := YPos + fLBoottom;         //����ϱ߿�
    MoveTo(c1, YPos);     LineTo(c0, YPos);
    tabTop := YPos;
    tabLeft := c1;        tabRight := c0;

    l := 0.10;
    YPos := YPos + rowH;
    PrintXY( c1  + l,  YPos , 'NO');
    PrintXY( c2  + l,  YPos , '���');
    PrintXY( c10 + l,  YPos , '����');
    PrintXY( c11 + l,  YPos , '��ע');

    //________________________����___________________________

    YPos := YPos + fLBoottom ;
    MoveTo(c1, YPos);     LineTo(c0, YPos);
  end;
end;

procedure TF_Prt_Prd2.btnDrawerClick(Sender: TObject);
begin
  F_Prt_Drawer.btnRptDrawer.Click;
end;

procedure TF_Prt_Prd2.BtnPrintProduceClick(Sender: TObject);
begin
  try

    case (Sender AS TButton).Tag of
      0:
        RvSysBody.Execute; //��ӡ�����
      1:
        RvSysDoor.Execute; //��ӡ�Ű�
      2:
        RvSyshdw2.Execute; //��ӡ���
    end;
  except
    on e: Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;

procedure TF_Prt_Prd2.RvSystem1Print(Sender: TObject);
var
  i, j: Integer;
  strSQL: string;
  CabTabID : string ;
  rowH, rowW, rowTop : Double;
begin

  with Sender AS TBaseReport do
  begin

    //���߿���
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    InitData();

    PrintAllColumns(Sender);


    //_____________________��ӡ�������______________________

    rowH := LineHeight * TabLineH ;

    //���ͳ��
    YPos := YPos + rowH ;
    YPos := YPos - fLBoottom;
    Bold := True;
    PrintXY( c3  + l,  YPos ,   IntToStr( List.NumCB   ) );  //���
    PrintXY( c4  + l,  YPos ,   IntToStr( List.NumDDB  ) );  //�׶���
    PrintXY( c5  + l,  YPos ,   IntToStr( List.NumGB   ) );  //����
    PrintXY( c6  + l,  YPos ,   IntToStr( List.NumQLT  ) );  //����
    PrintXY( c7  + l,  YPos ,   '<--'                    );
    PrintXY( c8  + l,  YPos ,   IntToStr( List.NumFJB  ) );  //���Ӱ�
    PrintXY( c9  + l,  YPos ,   IntToStr( List.NumBack ) );  //����
    PrintXY( c10 + l,  YPos ,   IntToStr( List.NumDoor ) );  //�Ű�
    Bold := False;

    YPos := YPos + fLBoottom;
    MoveTo(c1, YPos); LineTo(c0, YPos);

    //_____________________��ӡ�������______________________

    SetFont(ftB, fzBody + fzB);

    //for i := 1 to qry1.RecordCount do
    for i := 0 to Length(List.cabPrd) - 1 do
    begin

      rowTop := YPos;
      l := 0.10;
      PrintXY(c1 + l, YPos + rowH, IntToStr(i + 1));  //���

      YPos := rowTop;
      l := 0.08;
      YPos := YPos + rowH;
      PrintXY(c2 + l, YPos, List.cabPrd[i].cabName);  //��������
      YPos := YPos + rowH;
      PrintXY(c2 + l, YPos, List.cabPrd[i].cabW_H_D);

      b1 := False;
      b2 := False;
      b3 := False;
      b4 := False;

      YPos := rowTop;
      with List.cabPrd[i] do
      begin
        for j := 0 to List.cabPrd[i].TabH - 1 do
        begin

          YPos := YPos + rowH;
          //���
          if j + 1 <= Length(bodCB) then
          begin
            if bodCB[j] = '��4�߿�' then
            begin
              PrintXY(c3 + l, YPos, '(��4��');
              Bold := True;
              Print('��');
              Bold := False;
              Print(')');
            end
            else
            begin
              PrintXY(c3 + l, YPos, bodCB[j]);
            end;
          end;

          //�׶���
          if j + 1 <= Length(bodDDB) then
          begin
            if bodDDB[j] = '��2�߿�' then
            begin
              PrintXY(c4 + l, YPos, '(��2��');
              Bold := True;
              Print('��');
              Bold := False;
              Print(')')
            end
            else
            begin
              PrintXY(c4 + l, YPos, bodDDB[j]);
            end;
          end;

          //����
          if j + 1 <= Length(bodGB) then
          begin
            PrintXY(c5 + l, YPos, bodGB[j]);
          end;

          //ǰ����
          if j + 1 <= Length(bodQLT) then
          begin
            PrintXY(c6 + l, YPos, bodQLT[j]);
          end;

          //���
          if j + 1 <= Length(bodHLT) then
          begin
            PrintXY(c7 + l, YPos, bodHLT[j]);
          end;

          //���Ӱ�
          if j + 1 <= Length(bodFJB) then
          begin
            PrintXY(c8 + l, YPos, bodFJB[j]);
          end;

          //����
          if j + 1 <= Length(bodBack) then
          begin
            PrintXY(c9 + l, YPos, bodBack[j]);
          end;

          //�Ű�
          if j + 1 <= Length(bodDoor) then
          begin
            PrintXY(c10 + l, YPos, bodDoor[j]);
          end;

        end;


        //d0 := 0.20;
        d0 := rowH;
        y1 := rowTop;
        if List.cabPrd[i].cutType = CUT_QJ then
        begin
          //______________________�нǰ�______________________
          if List.cab[i].cabW < 400 then
          begin
            cutA := cutA + IThick_Board;
          end;
          x3 := c11 + 0.03;
          y3 := y1 + 0.03;
          MoveTo(x3 + d0, y3); LineTo(x3 + (d0 * 2), y3);
          MoveTo(x3, y3 + d0); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          MoveTo(x3, y3 + d0); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + (d0 * 2), y3); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          PrintXY(x3 + l, y3 + (d0 * 2) - l, 'B');
          PrintXY(x3 + l, y3 + d0 - l, 'A');
          PrintXY(x3 + l, y3 + d0 * 3 , 'A=' + VarToStr(cutA));

          x3 := x3 + d0 * 2 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + d0, y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + (d0 * 2), y3 + d0); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          PrintXY(x3 + d0 + l, y3 + (d0 * 2) - l, 'B');
          PrintXY(x3 + d0 + l, y3 + d0 - l, 'A');
          PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + VarToStr(cutB));
          PrintXY(x3 - d0 * 2 - 0.03, y3 + d0 * 4 - l / 2, '�װ忪��ʾ��ͼ');
        end;

        if List.cabPrd[i].cutType = CUT_ZQJ then
        begin
          //____________________���н�_______________________
          x3 := c11 + 0.03;
          y3 := y1 + d0 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + d0, y3);
          MoveTo(x3 + d0 * 2, y3); LineTo(x3 + d0 * 3, y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3, y3 + d0 * 2); LineTo(x3 + d0 * 3, y3 + d0 * 2);
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + d0 * 2, y3); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3 + (d0 * 3), y3); LineTo(x3 + (d0 * 3), y3 + (d0 * 2));
          PrintXY(x3 + l, y3 - l / 2, 'A');
          PrintXY(x3 + l, y3 + d0 - l / 2, 'B');
          PrintXY(x3 + d0 + l, y3 + d0 * 2 - l, 'C');
//          try
//            cutC := cutC + 25;
//          except
//            cutC := 0;
//          end;
          PrintXY(x3 + d0 * 3 + l / 2, y3, 'a=' + VarToStr(cutC));
          PrintXY(x3 + d0 * 3 + l / 2, y3 + d0, 'b=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 3 + l / 2, y3 + d0 * 2, 'c=' + VarToStr(cutB));
          PrintXY(x3 + l, y3 + d0 * 3 - l / 2, '�װ忪��ʾ��ͼ');
        end;

        if List.cabPrd[i].cutType = CUT_SWJ then
        begin
          //______________________���ڽǰ�______________________
          x3 := c11 + 0.03;
          y3 := y1 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + d0, y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + (d0 * 2), y3 + d0); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          PrintXY(x3 + d0 + l, y3 + (d0 * 2) - l, 'B');
          PrintXY(x3 + l, y3 + d0 - l, 'A');
          PrintXY(x3 + l, y3 + d0 * 3, 'A=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + VarToStr(cutB));
          PrintXY(x3, y3 + d0 * 4 - l / 2, '��忪��ʾ��ͼ');

        end;

        if List.cabPrd[i].cutType = CUT_XWJ then
        begin
          //______________________���ڽǰ�______________________
          //x3 := x3 + d0 * 2 + 0.03;
          x3 := c11 + 0.03;
          y3 := y1 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + (d0 * 2), y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + (d0 * 2), y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + d0, y3 + (d0 * 2));
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0, y3 + d0 * 2);
          MoveTo(x3 + (d0 * 2), y3); LineTo(x3 + (d0 * 2), y3 + d0);
          PrintXY(x3 + l, y3 + (d0 * 2) - l, 'A');
          PrintXY(x3 + d0 + l, y3 + d0 - l, 'B');
          PrintXY(x3 + l, y3 + d0 * 3, 'A=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + VarToStr(cutB));
          PrintXY(x3, y3 + d0 * 4 - l / 2, '��忪��ʾ��ͼ');
        end;
      end;
      {
      for j := 1 to 10 do
      begin
        if h[j] > y2 then
          y2 := h[j];
      end; }

      //y2 := y2 + TabH * List.cabPrd[i].TabH;

      YPos := rowTop + List.cabPrd[i].TabH * rowH + fLBoottom ;
      MoveTo(c1, YPos); LineTo(c11, YPos);
        //________________________��ҳ___________________________
      YPos := YPos;
      if YPos > 7.0 then
      begin
        l0 := YPos;
        tabBottom := YPos;
        MoveTo(c11, YPos); LineTo(c0, YPos);

        //________________________����___________________________

        MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
        MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
        MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
        MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);
        MoveTo(c5,  tabTop);  LineTo(c5,  tabBottom);
        MoveTo(c6,  tabTop);  LineTo(c6,  tabBottom);
        MoveTo(c7,  tabTop);  LineTo(c7,  tabBottom);
        MoveTo(c8,  tabTop);  LineTo(c8,  tabBottom);
        MoveTo(c9,  tabTop);  LineTo(c9,  tabBottom);
        MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
        MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
        MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

        NewPage;

        PrintAllColumns(Sender);
      end;

      qry1.Next;
    end; { for }
    MoveTo(c11, YPos); LineTo(c0, YPos);

    l0 := YPos;
		tabBottom := YPos;
    //________________________����___________________________
		MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
		MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
		MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
		MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);
		MoveTo(c5,  tabTop);  LineTo(c5,  tabBottom);
		MoveTo(c6,  tabTop);  LineTo(c6,  tabBottom);
		MoveTo(c7,  tabTop);  LineTo(c7,  tabBottom);
		MoveTo(c8,  tabTop);  LineTo(c8,  tabBottom);
		MoveTo(c9,  tabTop);  LineTo(c9,  tabBottom);
		MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
		MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
		MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

    //_______________________�������_________________________
    NewLine;

    YPos := YPos + fLBoottom * 2;
    Print('������ܣ�');
    rowW := 2.5;
    XPos := SectionLeft + 1 + rowW * 0 ;    Print('������ܹ�' + VarToStr(List.NumBody) + '�飬' + VarToStr(List.AreaBody) + 'ƽ�ף�');
    XPos := SectionLeft + 1 + rowW * 1 ;    Print('�����ܹ�'   + VarToStr(List.NumBack) + '�飬' + VarToStr(List.AreaBack) + 'ƽ�ף�');
    XPos := SectionLeft + 1 + rowW * 2 ;    Print('�Ű��ܹ�'   + VarToStr(List.NumDoor) + '�飬' + VarToStr(List.AreaDoor) + 'ƽ�ף�');

    NewLine;
    YPos := YPos + fLBoottom;
		rowW := 2;
    XPos := SectionLeft + rowW * 0 ;   	Print('����(��)��');
    XPos := SectionLeft + rowW * 1 ;  	Print('��ߣ�');
    XPos := SectionLeft + rowW * 2 ;   	Print('���(������)��');
    XPos := SectionLeft + rowW * 3 ;   	Print('��װ��');
    XPos := SectionLeft + rowW * 4 ;    Print('�ʼ죺');


  end;

end;


procedure TF_Prt_Prd2.RvSysBodyPrint(Sender: TObject);
var
  i, j, k: Integer;
  strSQL: string;
  CabTabID : string ;
  rowH, rowW, rowTop : Double;
  MQP_A : string;
  QJG_BC : string;
  QJG_FB : string;
  DrawMQP : Boolean;
  DrawQJG : Boolean;
  i1, i2 : Double;
  i_index : Integer;
  TabH : Double;
  sExp : string;
begin
  with Sender AS TBaseReport do
  begin

    DrawMQP := False;
    if BoolMQPG AND (ptMQP = 1) then
    begin
      if Application.MessageBox('����ú��ƿ���Ƿ����ʾ��ͼ��', '��ʾ', MB_YESNO + MB_ICONQUESTION) = IDYES then
      begin
        MQP_A := InputBox('ú��ƿ�����', 'A=', VarToStr(ptMQP_A));
        DrawMQP := True;
      end;
    end;

    DrawQJG := False;
    if BoolQJG AND (ptCutSize = 1) then
    begin
      QJG_BC := InputBox('�нǹ����', '��ĺ��=', VarToStr(IThick_Board));
      QJG_FB := InputBox('�нǹ����', '��ߺ��=', VarToStr(fbBody));
    end;

    //���߿���
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    InitData();

    //���Ʊ�ͷ
    PrintBodyColumns(Sender);

    //_____________________��ӡ�������______________________

    rowH := LineHeight * TabLineH ;

    //���ͳ��
    YPos := YPos + rowH ;
    YPos := YPos - fLBoottom;
    Bold := True;
    PrintXY( c3  + l,  YPos ,   IntToStr( List.NumCB   ) );  //���
    PrintXY( c4  + l,  YPos ,   IntToStr( List.NumBUp  ) );  //�װ�
    PrintXY( c5  + l,  YPos ,   IntToStr( List.NumGB_G ) );  //����
    PrintXY( c6  + l,  YPos ,   IntToStr( List.NumGB   ) );  //����
    PrintXY( c7  + l,  YPos ,   IntToStr( List.NumLT   ) );  //����
    PrintXY( c8  + l,  YPos ,   IntToStr( List.NumFJB  ) );  //���Ӱ�
    PrintXY( c9  + l,  YPos ,   IntToStr( List.NumBack ) );  //����
//    PrintXY( c10 + l,  YPos ,   IntToStr( List.NumDoor ) );  //�Ű�
    Bold := False;

    YPos := YPos + fLBoottom;
    MoveTo(c1, YPos); LineTo(c0, YPos);

    //_____________________��ӡ�������______________________

    SetFont(ftB, fzBody + fzB);

    for i := 0 to Length(List.cabPrd) - 1 do
    begin
      if (ptDifMod = 1) AND (List.cabPrd[i].showCab = False) then Continue;
      
      rowTop := YPos;
      l := 0.10;
      Inc(k);
      PrintXY(c1 + l, YPos + rowH, IntToStr(k));  //���

      YPos := rowTop;
      l := 0.08;
      YPos := YPos + rowH;
      if ptType = 1 then
        PrintXY(c2 + l, YPos, List.cabPrd[i].cabName)   //��������
      else if ptType = 2 then
        PrintXY(c2 + l, YPos, List.cabPrd[i].cabTypeID);  //Bx,Wx
      YPos := YPos + rowH;
      PrintXY(c2 + l, YPos, List.cabPrd[i].cabW_H_D + '=' + IntToStr(List.cabPrd[i].cabNum));

      b1 := False;
      b2 := False;
      b3 := False;
      b4 := False;

      YPos := rowTop;
      with List.cabPrd[i] do
      begin
        for j := 0 to List.cabPrd[i].TabH - 1 do
        begin

          YPos := YPos + rowH;
          //���
          if j + 1 <= Length(bodCB) then
          begin
            if bodCB[j] = '��4�߿�' then
            begin
              PrintXY(c3 + l, YPos, '(��4��');
              Bold := True;
              Print('��');
              Bold := False;
              Print(')');
            end
            else
            begin
              PrintXY(c3 + l, YPos, bodCB[j]);
            end;
          end;

          //�װ�
          if j + 1 <= Length(bodBUp) then
          begin
            if bodBUp[j] = '��2�߿�' then
            begin
              PrintXY(c4 + l, YPos, '(��2��');
              Bold := True;
              Print('��');
              Bold := False;
              Print(')')
            end
            else
            begin
              PrintXY(c4 + l, YPos, bodBUp[j]);
            end;
          end;

          //����
//          if j + 1 <= Length(bodBDown) then
//          begin
//            if bodBDown[j] = '��2�߿�' then
//            begin
//              PrintXY(c5 + l, YPos, '(��2��');
//              Bold := True;
//              Print('��');
//              Bold := False;
//              Print(')')
//            end
//            else
//            begin
//              PrintXY(c5 + l, YPos, bodBDown[j]);
//            end;
//          end;

          //�̸�
          if j + 1 <= Length(bodGB_G) then
          begin
            if bodGB_G[j] = '��2�߿�' then
            begin
              PrintXY(c5 + l, YPos, '(��2��');
              Bold := True;
              Print('��');
              Bold := False;
              Print(')')
            end
            else
            begin
              PrintXY(c5 + l, YPos, bodGB_G[j]);
            end;
          end;

          //����
          if j + 1 <= Length(bodGB) then
          begin
            PrintXY(c6 + l, YPos, bodGB[j]);
          end;

          //����
          if j + 1 <= Length(bodLT) then
          begin
            PrintXY(c7 + l, YPos, bodLT[j]);
          end;

          //���Ӱ�
          if j + 1 <= Length(bodFJB) then
          begin
            PrintXY(c8 + l, YPos, bodFJB[j]);
          end;

          //����
          if j + 1 <= Length(bodBack) then
          begin
            PrintXY(c9 + l, YPos, bodBack[j]);
          end;

        end;

        //d0 := 0.20;
        d0 := rowH;
        y1 := rowTop;
        if List.cabPrd[i].cutType = CUT_QJ then
        begin
        //______________________�нǰ�______________________
//          if List.cab[i].cabW < 400 then
//          begin
//            cutA := cutA + IThick_Board;
//          end;
          x3 := c10 + 0.03;
          y3 := y1 + 0.03;
          MoveTo(x3 + d0, y3); LineTo(x3 + (d0 * 2), y3);
          MoveTo(x3, y3 + d0); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          MoveTo(x3, y3 + d0); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + (d0 * 2), y3); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          PrintXY(x3 + l, y3 + (d0 * 2) - l, 'B');
          PrintXY(x3 + l, y3 + d0 - l, 'A');
          {$IFNDEF v1_74c}
          PrintXY(x3 + l, y3 + d0 * 3 , 'A=' + VarToStr(cutA));
          {$ELSE}
          PrintXY(x3 + l, y3 + d0 * 3 , 'A=' + VarToStr(cutA + fbBody * 2 + 2));
          {$ENDIF}
          send('cutA:' + VarToStr(cutA) + ', cutB:' + VarToStr(cutB));

          x3 := x3 + d0 * 2 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + d0, y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + (d0 * 2), y3 + d0); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          PrintXY(x3 + d0 + l, y3 + (d0 * 2) - l, 'B');
          PrintXY(x3 + d0 + l, y3 + d0 - l, 'A');
          //�Ϲ� �нǰ�
          if ( ptCutSize = 1 )
            {$IFNDEF v1_74c}
            AND (Pos( '��' , cabName ) > 0)
            {$ENDIF}
          then
          begin
            {$IFNDEF v1_74c}
            PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + VarToStr(cutB - StoD(QJG_BC) - 2 * StoD(QJG_FB)));
            {$ELSE}
            PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + VarToStr(cutB - StoD(QJG_BC) + fbBody * 2 + 2));
            {$ENDIF}
          end
          else
          begin
            PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + VarToStr(cutB)) ;
          end;
          PrintXY(x3 - d0 * 2 - 0.03, y3 + d0 * 4 - l / 2, '�װ忪��ʾ��ͼ');

          //�Ϲ� �нǰ� ����ʾ��ͼ
          if ( ptCutSize = 1 )
            {$IFNDEF v1_74c}
            AND (Pos( '�Ϲ�' , cabName ) > 0)
            {$ENDIF}
            AND ( cut_GB )
          then
          begin
            x3 := c10 + 0.03;
            y3 := y1 + rowH * 4 + 0.03;
            MoveTo(x3 + d0, y3); LineTo(x3 + (d0 * 2), y3);
            MoveTo(x3, y3 + d0); LineTo(x3 + d0, y3 + d0);
            MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
            MoveTo(x3, y3 + d0); LineTo(x3, y3 + (d0 * 2));
            MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
            MoveTo(x3 + (d0 * 2), y3); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
            PrintXY(x3 + l, y3 + (d0 * 2) - l, 'B');
            PrintXY(x3 + l, y3 + d0 - l, 'A');
            {$IFNDEF v1_74c}
            PrintXY(x3 + l, y3 + d0 * 3 , 'A=' + VarToStr(cutGB_A));
            {$ELSE}
            PrintXY(x3 + l, y3 + d0 * 3 , 'A=' + VarToStr(cutA + fbBody * 2 - 4));
            {$ENDIF}

            x3 := x3 + d0 * 2 + 0.03;
            MoveTo(x3, y3); LineTo(x3 + d0, y3);
            MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
            MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
            MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
            MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
            MoveTo(x3 + (d0 * 2), y3 + d0); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
            PrintXY(x3 + d0 + l, y3 + (d0 * 2) - l, 'B');
            PrintXY(x3 + d0 + l, y3 + d0 - l, 'A');
            {$IFNDEF v1_74c}
            PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + VarToStr(cutGB_B)) ;
            {$ELSE}
            PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + VarToStr(cutB + fbBody * 2 + 2));
            {$ENDIF}
            PrintXY(x3 - d0 * 2 - 0.03, y3 + d0 * 4 - l / 2, '���忪��ʾ��ͼ');
          end
        end;

        if List.cabPrd[i].cutType = CUT_ZQJ then
        begin
          //____________________���н�_______________________
          x3 := c10 + 0.03;
          y3 := y1 + d0 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + d0, y3);
          MoveTo(x3 + d0 * 2, y3); LineTo(x3 + d0 * 3, y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3, y3 + d0 * 2); LineTo(x3 + d0 * 3, y3 + d0 * 2);
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + d0 * 2, y3); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3 + (d0 * 3), y3); LineTo(x3 + (d0 * 3), y3 + (d0 * 2));
          PrintXY(x3 + l, y3 - l / 2, 'A');
          PrintXY(x3 + l, y3 + d0 - l / 2, 'B');
          PrintXY(x3 + d0 + l, y3 + d0 * 2 - l, 'C');

          PrintXY(x3 + d0 * 3 + l / 2, y3, 'a=' + VarToStr(cutC));
          PrintXY(x3 + d0 * 3 + l / 2, y3 + d0, 'b=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 3 + l / 2, y3 + d0 * 2, 'c=' + VarToStr(cutB));
          PrintXY(x3 + l, y3 + d0 * 3 - l / 2, '�װ忪��ʾ��ͼ');
        end;

        if List.cabPrd[i].cutType = CUT_SWJ then
        begin
          //______________________���ڽǰ�______________________
          x3 := c10 + 0.03;
          y3 := y1 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + d0, y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + (d0 * 2), y3 + d0); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          PrintXY(x3 + d0 + l, y3 + (d0 * 2) - l, 'B');
          PrintXY(x3 + l, y3 + d0 - l, 'A');
          PrintXY(x3 + l, y3 + d0 * 3, 'A=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + VarToStr(cutB));
          PrintXY(x3, y3 + d0 * 4 - l / 2, '��忪��ʾ��ͼ');

        end;

        if List.cabPrd[i].cutType = CUT_XWJ then
        begin
          //______________________���ڽǰ�______________________
          //x3 := x3 + d0 * 2 + 0.03;
          x3 := c10 + 0.03;
          y3 := y1 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + (d0 * 2), y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + (d0 * 2), y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + d0, y3 + (d0 * 2));
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0, y3 + d0 * 2);
          MoveTo(x3 + (d0 * 2), y3); LineTo(x3 + (d0 * 2), y3 + d0);
          PrintXY(x3 + l, y3 + (d0 * 2) - l, 'A');
          PrintXY(x3 + d0 + l, y3 + d0 - l, 'B');
          PrintXY(x3 + l, y3 + d0 * 3, 'A=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + VarToStr(cutB));
          PrintXY(x3, y3 + d0 * 4 - l / 2, '��忪��ʾ��ͼ');
        end;

        if (List.cabPrd[i].cutType = CUT_MQP) AND DrawMQP then
        begin
          //______________________ú��ƿ��______________________
          //x3 := x3 + d0 * 2 + 0.03;
          if ptMQP = 1 then
          begin
            x3 := c10 + 0.03;
            y3 := y1 + 0.03;
//            SetPen(clBlack,psSolid,-2,pmCopy);
//            SetBrush(clBlack,bsClear,nil);
            Rectangle(x3, y3, x3 + d0 * 2, y3 + d0 * 2);
            Ellipse(x3 + 0.1, y3 + 0.1, x3 + d0 * 2 - 0.1, y3 + d0 * 2 - 0.1);
            MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 3 - l, y3 + d0 - l / 2);
            PrintXY(x3 + d0 * 3 , y3 + d0, 'A=' + MQP_A);
            PrintXY(x3 + d0 * 2 + l / 2, y3 + d0 * 2 - l / 2, '�װ�ʾ��ͼ');
          end;
        end;
      end;

      //y2 := y2 + TabH * List.cabPrd[i].TabH;
      //���н�ʾ��ͼ����������4�У���4�м��㣬�ӻ�����ʾ��ͼʱ��������8����
      if (List.cabPrd[i].cutType <> CUT_NIL)
        AND (List.cabPrd[i].cutType <> CUT_MQP)
        AND (List.cabPrd[i].TabH < 4)
      then
          List.cabPrd[i].TabH := 4;

      if ( List.cabPrd[i].cutType = CUT_QJ )
        AND ( ptCutSize = 1 )
        AND (Pos( '�Ϲ�' , List.cabPrd[i].cabName ) > 0)
        AND ( List.cabPrd[i].cut_GB )
        AND (List.cabPrd[i].TabH < 8)
      then
        List.cabPrd[i].TabH := 8;

      YPos := rowTop + List.cabPrd[i].TabH * rowH + fLBoottom ;
      MoveTo(c1, YPos); LineTo(c10, YPos);
        //________________________��ҳ___________________________
      if i + 1 < Length(List.cabPrd) then
      if YPos + rowH * List.cabPrd[i + 1].TabH + 1 > SectionBottom then
      begin
        l0 := YPos;
        tabBottom := YPos;
        MoveTo(c10, YPos); LineTo(c0, YPos);

        //________________________����___________________________

        MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
        MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
        MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
        MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);
        MoveTo(c5,  tabTop);  LineTo(c5,  tabBottom);
        MoveTo(c6,  tabTop);  LineTo(c6,  tabBottom);
        MoveTo(c7,  tabTop);  LineTo(c7,  tabBottom);
        MoveTo(c8,  tabTop);  LineTo(c8,  tabBottom);
        MoveTo(c9,  tabTop);  LineTo(c9,  tabBottom);
        MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
//        MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
        MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

        NewPage;

        PrintBodyColumns(Sender);
      end;

      qry1.Next;
    end; { for }
    MoveTo(c10, YPos); LineTo(c0, YPos);

    l0 := YPos;
		tabBottom := YPos;
    //________________________����___________________________
		MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
		MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
		MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
		MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);
		MoveTo(c5,  tabTop);  LineTo(c5,  tabBottom);
		MoveTo(c6,  tabTop);  LineTo(c6,  tabBottom);
		MoveTo(c7,  tabTop);  LineTo(c7,  tabBottom);
		MoveTo(c8,  tabTop);  LineTo(c8,  tabBottom);
		MoveTo(c9,  tabTop);  LineTo(c9,  tabBottom);
		MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
//		MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
		MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

    //_______________________����ģ��_________________________
    with List.cabPrdOth do
    if (ptDifMod = 1) AND showPrdOth then
    begin
      YPos := YPos + fLBoottom;
      tabTop := YPos ; tabBottom := YPos + rowH * rowCount + fLBoottom;
      Rectangle(tabLeft, tabTop, tabRight, tabBottom);
      NewLine;
      rowW := 2.5;
      tabTop := YPos;
      i := 0;
      Bold := True;
      if Length(NumBG) > 0 then
      begin
        tabLeft := SectionLeft + rowW * i + l ; Inc(i);  YPos := tabTop;
        for j :=0 to Length(NumBG) - 1 do
        begin
          YPos := YPos + j * rowH;
          PrintXY(tabLeft, YPos, NameBG[j] + '��' + sizeBG[j] + '=' + IntToStr(NumBG[j]));
        end;
      end;
      if Length(NumDT) > 0 then
      begin
        tabLeft := SectionLeft + rowW * i + l ; Inc(i);  YPos := tabTop;
        for j :=0 to Length(NumDT) - 1 do
        begin
          YPos := YPos + j * rowH;
          PrintXY(tabLeft, YPos, NameDT[j] + '��' + sizeDT[j] + '=' + IntToStr(NumDT[j]));
        end;
      end;
      if Length(NumFB) > 0 then
      begin
        tabLeft := SectionLeft + rowW * i + l ; Inc(i);  YPos := tabTop;
        for j :=0 to Length(NumFB) - 1 do
        begin
          YPos := YPos + j * rowH;
          PrintXY(tabLeft, YPos, NameFB[j] + '��' + sizeFB[j] + '=' + IntToStr(NumFB[j]));
        end;
      end;
      if Length(NumFL) > 0 then
      begin
        tabLeft := SectionLeft + rowW * i + l ; Inc(i);  YPos := tabTop;
        for j :=0 to Length(NumFL) - 1 do
        begin
          YPos := YPos + j * rowH;
          PrintXY(tabLeft, YPos, NameFL[j] + '��' + sizeFL[j] + '=' + IntToStr(NumFL[j]));
        end;
      end;
      Bold := False;
      YPos := tabTop + rowCount * rowH;
    end;

    //______________________________�����Ӽ���Ŀ________________________________

    if Length(List.cab) > 0 then
    begin
      //NewLine;
      YPos := YPos + 0.1 ;
      l0 := YPos;
      c0 := 0.5;
      c1 := c0 + 0.5; //���
      c2 := c1 + 1.8; //����
      c3 := c2 + 1.2; //���
      c4 := c3 + 0.6; //����
      c5 := c4 + 1.0; //�Ӽ۽��
      c6 := c5 + 1.0; //�ϼƽ��
      //c7 := c6 + 4.0; //��ע
      c7 := tabRight;

      i1 := 0.1;
      i2 := fLBoottom ;
      i_index := 0;
      List.SumPrcTS_ := 0;

      l1 := YPos;
      MoveTo(c0, l0); LineTo(c7, l0);
      NewLine;
      TabH := LineHeight * TabLineH ;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c7, l1);
      PrintXY(c0 + i1, l1 - i2, '���');
      PrintXY(c1 + i1, l1 - i2, '����');
      PrintXY(c2 + i1, l1 - i2, '���');
      PrintXY(c3 + i1, l1 - i2, '����');
      {$IFNDEF PRC_HIDE}
      PrintXY(c4 + i1, l1 - i2, '�Ӽ۽��');
      PrintXY(c5 + i1, l1 - i2, '�ϼƽ��');
      {$ENDIF}
      PrintXY(c6 + i1, l1 - i2, '��ע');


      for i := 0 to Length(List.cab) - 1 do
      begin

        for j :=0 to Length(List.tsPrc) - 1 do
        begin
          if Pos(List.tsPrc[j].Name, List.cab[i].cabName) = 0 then Continue;
          sExp := List.tsPrc[j].GS;
          sExp := StringReplace(sExp, '���', Dtos(List.cab[i].cabW), [rfReplaceAll]);
          sExp := StringReplace(sExp, '�߶�', Dtos(List.cab[i].cabH), [rfReplaceAll]);
          if not F_Prt_Prc2.ChkVal(sExp) then Continue;

          NewLine;
          l1 := l1 + TabH ;
          MoveTo(c0, l1); LineTo(c7, l1); //������
          Inc(i_index);
          PrintXY(c0 + i1, l1 - i2, ItoS(i_index) );
          PrintXY(c1 + i1, l1 - i2, List.cab[i].cabName );
          PrintXY(c2 + i1, l1 - i2, List.cab[i].cabW_H_D );
          PrintXY(c3 + i1, l1 - i2, ItoS(List.cab[i].cabNum) );
          {$IFNDEF PRC_HIDE}
          PrintXY(c4 + i1, l1 - i2, Dtos(List.tsPrc[j].Prc) );
          PrintXY(c5 + i1, l1 - i2, Dtos(List.tsPrc[j].Prc * List.cab[i].cabNum) );
          {$ENDIF}
          PrintXY(c6 + i1, l1 - i2, '' );
          List.SumPrcTS_ := List.SumPrcTS_ + (List.tsPrc[j].Prc * List.cab[i].cabNum);

          if YPos > 7.5 then
          begin
            MoveTo(c0, l0); LineTo(c0, l1);
            MoveTo(c1, l0); LineTo(c1, l1);
            MoveTo(c2, l0); LineTo(c2, l1);
            MoveTo(c3, l0); LineTo(c3, l1);
            MoveTo(c4, l0); LineTo(c4, l1);
            MoveTo(c5, l0); LineTo(c5, l1);
            MoveTo(c6, l0); LineTo(c6, l1);
            MoveTo(c7, l0); LineTo(c7, l1);

            NewPage; //��ҳ���½�ҳ

            YPos := 0.75;
            l0 := YPos;
            MoveTo(c0, l0); LineTo(c7, l0);
            NewLine;
            l1 := YPos;
            MoveTo(c0, l1); LineTo(c7, l1);
            PrintXY(c0 + i1, l1 - i2, '���');
            PrintXY(c1 + i1, l1 - i2, '����');
            PrintXY(c2 + i1, l1 - i2, '���');
            PrintXY(c3 + i1, l1 - i2, '����');
            {$IFNDEF PRC_HIDE}
            PrintXY(c4 + i1, l1 - i2, '�Ӽ۽��');
            PrintXY(c5 + i1, l1 - i2, '�ϼƽ��');
            {$ENDIF}
            PrintXY(c6 + i1, l1 - i2, '��ע');
          end;
        end;

      end;
      MoveTo(c0, l0); LineTo(c0, l1);
      MoveTo(c1, l0); LineTo(c1, l1);
      MoveTo(c2, l0); LineTo(c2, l1);
      MoveTo(c3, l0); LineTo(c3, l1);
      MoveTo(c4, l0); LineTo(c4, l1);
      MoveTo(c5, l0); LineTo(c5, l1);
      MoveTo(c6, l0); LineTo(c6, l1);
      MoveTo(c7, l0); LineTo(c7, l1);

      //����Ӽۺϼƽ��
      NewLine;
      YPos := YPos + TabH / 4 ;
      //SetFont('����', fzMinTit);
      //Bold := True;
      {$IFNDEF PRC_HIDE}
      PrintXY(c0 + i1, YPos, '����Ӽ� �� ' + StrN(List.SumPrcTS_ , PrcRound) + ' Ԫ');
      {$ENDIF}
      //SetFont(ftB, fzBody + fzB );
      //Bold := False;

      l0 := YPos + 0.05;
      MoveTo(c0, l0); LineTo(c7, l0);

    end;

    //_______________________�������_________________________
    NewLine;

    YPos := YPos + fLBoottom * 2;
    PrintXY(c0 + i1, YPos, '������ܣ�');
    rowW := 2.5;
    XPos := SectionLeft + 1 + rowW * 0 + i1 ;    Print('������ܹ�' + VarToStr(List.NumBody) + '�飬' + VarToStr(List.AreaBody) + 'ƽ�ף�');
    XPos := SectionLeft + 1 + rowW * 1 + i1 ;    Print('�����ܹ�'   + VarToStr(List.NumBack) + '�飬' + VarToStr(List.AreaBack) + 'ƽ�ף�');
    XPos := SectionLeft + 1 + rowW * 2 + i1 ;    Print('�Ű��ܹ�'   + VarToStr(List.NumDoor) + '�飬' + VarToStr(List.AreaDoor) + 'ƽ�ף�');

    NewLine;
    YPos := YPos + fLBoottom;
		rowW := 2;
    XPos := SectionLeft + rowW * 0 + i1 ;   	Print('����(��)��');
    XPos := SectionLeft + rowW * 1 + i1 ;  	  Print('��ߣ�');
    XPos := SectionLeft + rowW * 2 + i1 ;   	Print('���(������)��');
    XPos := SectionLeft + rowW * 3 + i1 ;   	Print('��װ��');
    XPos := SectionLeft + rowW * 4 + i1 ;     Print('�ʼ죺');

    //_______________________�۸����_________________________

    NewLine ;
    if ptDoorPrc = 0 then
    begin
      PrintLeft('�Ű����:' + List.CZhDoor , 0.7);
      {$IFNDEF PRC_HIDE}
      PrintLeft('����:' + StrN(List.PrcDoor , PrcRound) , 4 );
      //PrintLeft('���:' + StrN(List.AreaDoor , AreaRound) , 6 );
      PrintLeft('���:' + StrN(List.SumPrcDoor , PrcRound) , 8 );
      {$ENDIF}
      NewLine;
    end;
    PrintLeft('�������:' + List.CZhBody , 0.7 );
    {$IFNDEF PRC_HIDE}
    PrintLeft('����:' + StrN(List.PrcBody , PrcRound) , 4 );
    //PrintLeft('���:' + StrN(List.AreaBody , AreaRound) , 6 );
    PrintLeft('���:' + StrN(List.SumPrcBody , PrcRound) , 8 );
    {$ENDIF}
    NewLine;
    PrintLeft('�������:' + List.CZhBack , 0.7);
    {$IFNDEF PRC_HIDE}
    PrintLeft('����:' + StrN(List.PrcBack , PrcRound) , 4 );
    //PrintLeft('���:' + StrN(List.AreaBack , AreaRound) , 6 );
    PrintLeft('���:' + StrN(List.SumPrcBack , PrcRound) , 8 );
    {$ENDIF}

    l0 := YPos + 0.05;
    MoveTo(c0, l0); LineTo(c7, l0);
    MoveTo(c0, l0); LineTo(c0, l1);
    MoveTo(c7, l0); LineTo(c7, l1);

    NewLine;
    SetFont('����', fzMinTit);
    Bold := True;
    YPos := YPos + 0.1;
    {$IFNDEF PRC_HIDE}
    if ptDoorPrc = 0 then
      PrintXY(c0 + i1, YPos, '�ϼƽ�' +  StrN(List.SumPrcBod + List.SumPrcHD_ + List.SumPrcTS_ , PrcRound) + 'Ԫ')
    else
      PrintXY(c0 + i1, YPos, '�ϼƽ�' +  StrN(List.SumPrcBod + List.SumPrcHD_ + List.SumPrcTS_ - List.SumPrcDoor , PrcRound) + 'Ԫ');
    {$ENDIF}
    //SetFont(ftB, fzBody + fzB );
    Bold := False;

    NewLine;
    PrintXY(c0 + i1, YPos, '����ʱ�䣺' + sNow +'       �ѱ��۵�ȷ��          �Ѹ���');
  end;

end;

procedure TF_Prt_Prd2.RvSysDoorPrint(Sender: TObject);
var
  i, j ,k: Integer;
  strSQL: string;
  CabTabID : string ;
  rowH, rowW, rowTop : Double;
begin

  with Sender AS TBaseReport do
  begin

    //���߿���
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    InitData();

    PrintDoorColumns(Sender);


    //_____________________��ӡ�������______________________

    rowH := LineHeight * TabLineH ;

    //���ͳ��
    YPos := YPos + rowH ;
    YPos := YPos - fLBoottom;
    Bold := True;
    PrintXY( c3 + l,  YPos ,   IntToStr( List.NumDoor ) );  //�Ű�
    Bold := False;

    YPos := YPos + fLBoottom;
    MoveTo(c1, YPos); LineTo(c0, YPos);

    //_____________________��ӡ�������______________________

    SetFont(ftB, fzBody + fzB);

    k := 0;
    for i := 0 to Length(List.cabPrd) - 1 do
    begin
      if (ptDifMod = 1) AND (List.cabPrd[i].showCab = False) then Continue;

      rowTop := YPos;
      l := 0.10;
      YPos := YPos + rowH;
      YPos := YPos - fLBoottom;
      Inc(k);
      PrintXY(c1 + l, YPos, IntToStr(k));  //���

      YPos := rowTop;
      l := 0.08;
      YPos := YPos + rowH;
      YPos := YPos - fLBoottom;
      if ptType = 1 then
        PrintXY(c2 + l, YPos, List.cabPrd[i].cabName)   //��������
      else
        PrintXY(c2 + l, YPos, List.cabPrd[i].cabTypeID);  //Bx,Wx
      //YPos := YPos + rowH;
      PrintXY(c2 + 1.8 + l, YPos, List.cabPrd[i].cabW_H_D + '=' + IntToStr(List.cabPrd[i].cabNum));

      YPos := rowTop;
      with List.cabPrd[i] do
      begin
        for j := 0 to List.cabPrd[i].TabH - 1 do
        begin

          YPos := YPos - fLBoottom;
          //�Ű�
          if j + 1 <= Length(bodDoor) then
          begin
            
            if j mod 2 = 1 then
            begin
              PrintXY(c11 + l, YPos, bodDoor[j]);
              //Print( bodDoor[j] );
            end
            else
            begin
              YPos := YPos + rowH;
              PrintXY(c3 + l, YPos, bodDoor[j]);
            end;
          end;

          YPos := YPos + fLBoottom;
          MoveTo(c3, YPos); LineTo(c12, YPos);

        end;


        //d0 := 0.20;
        d0 := rowH;

        if Length(bodDoor) > 2 then
          YPos := rowTop + rowH * ((Length(List.cabPrd[i].bodDoor) + 1) div 2)
        else
          YPos := rowTop + rowH ;
          
        MoveTo(c1, YPos); LineTo(c12, YPos);

      end;

      //________________________��ҳ___________________________
      if YPos + 1 > SectionBottom then
      begin
        l0 := YPos;
        tabBottom := YPos;
        MoveTo(c11, YPos); LineTo(c0, YPos);

        //________________________����___________________________

        MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
        MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);

        MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
        MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
        MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

        NewPage;

        PrintDoorColumns(Sender);
      end;

      qry1.Next;
    end; { for }
//    MoveTo(c11, YPos); LineTo(c0, YPos);

    l0 := YPos;
		tabBottom := YPos;
    //________________________����___________________________
		MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
		MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);

		MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
		MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
		MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

    //_______________________�������_________________________
    NewLine;

    YPos := YPos + fLBoottom * 2;
    Print('������ܣ�');
    rowW := 2.5;
    XPos := SectionLeft + 1 ;    Print('������ܹ�' + VarToStr(List.NumBody) + '�飬' + VarToStr(List.AreaBody) + 'ƽ�ף�');
    NewLine;
    XPos := SectionLeft + 1 ;    Print('�����ܹ�'   + VarToStr(List.NumBack) + '�飬' + VarToStr(List.AreaBack) + 'ƽ�ף�');
    NewLine;
    XPos := SectionLeft + 1 ;    Print('�Ű��ܹ�'   + VarToStr(List.NumDoor) + '�飬' + VarToStr(List.AreaDoor) + 'ƽ�ף�');

    NewLine;
    YPos := YPos + fLBoottom;
		rowW := 1.5;
    XPos := SectionLeft + rowW * 0 ;   	Print('����(��)��');
    XPos := SectionLeft + rowW * 1 ;  	Print('��ߣ�');
    XPos := SectionLeft + rowW * 2 ;   	Print('���(������)��');
    XPos := SectionLeft + rowW * 3 ;   	Print('��װ��');
    XPos := SectionLeft + rowW * 4 ;    Print('�ʼ죺');


  end;

end;

procedure TF_Prt_Prd2.RvSysHDWPrint(Sender: TObject);
var
  i, j: Integer;
  strSQL: string;
  CabTabID : string ;
  rowH, rowW, rowTop : Double;
begin

  with Sender AS TBaseReport do
  begin

    //���߿���
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    InitData();

    PrinthdwColumns(Sender);


    //_____________________��ӡ�������______________________

    rowH := LineHeight * TabLineH ;


    //_____________________��ӡ�������______________________

    SetFont(ftB, fzBody + fzB);

    for i := 0 to Length(List.cabPrd) - 1 do
    begin

      rowTop := YPos;
      l := 0.10;
      PrintXY(c1 + l, YPos + rowH , IntToStr(i + 1));  //���

      YPos := rowTop;
      l := 0.08;
      YPos := YPos + rowH;
      PrintXY(c2 + l, YPos , List.cabPrd[i].cabName);  //��������
      YPos := YPos + rowH - fLBoottom;
      PrintXY(c2 + l, YPos, List.cabPrd[i].cabW_H_D);

      b1 := False;
      b2 := False;
      b3 := False;
      b4 := False;

      YPos := rowTop;
      with List.cab[i] do
      begin
        for j := 0 to Length(hdw) - 1 do
        begin

          YPos := YPos + rowH - fLBoottom;

          PrintXY(c3  + l, YPos, IntToStr(j + 1));
          PrintXY(c4  + l, YPos, hdw[j].hdName);
          PrintXY(c10 + l, YPos, IntToStr(hdw[j].hdNum));

          YPos := YPos + fLBoottom;
          MoveTo(c3, YPos); LineTo(c12, YPos);

        end;

        if Length(hdw) > 2 then
          YPos := rowTop + rowH * Length(List.cab[i].hdw)  
        else
          YPos := rowTop + rowH * 2 ;

        MoveTo(c1, YPos); LineTo(c12, YPos);

      end;


        //________________________��ҳ___________________________
      if i + 1 < Length(List.cabPrd) then
      if YPos + rowH * Length(List.cab[i + 1].hdw ) > SectionBottom then
      begin
        l0 := YPos;
        tabBottom := YPos;
        MoveTo(c12, YPos); LineTo(c0, YPos);

        //________________________����___________________________

        MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
        MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
        MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
        MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);

        MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
        MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
        MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

        NewPage;

        PrinthdwColumns(Sender);
      end;

    end; { for }
//    MoveTo(c12, YPos); LineTo(c0, YPos);

    l0 := YPos;
		tabBottom := YPos;
    //________________________����___________________________
		MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
		MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
    MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
		MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);

		MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
		MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
		MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

    //_______________________�������_________________________
    NewLine;

    YPos := YPos + fLBoottom * 2;
    Print('������ܣ�');
    rowW := 2.5;
    XPos := SectionLeft + 1  ;    Print('������ܹ�' + VarToStr(List.NumBody) + '�飬' + VarToStr(List.AreaBody) + 'ƽ�ף�');
    NewLine;
    XPos := SectionLeft + 1  ;    Print('�����ܹ�'   + VarToStr(List.NumBack) + '�飬' + VarToStr(List.AreaBack) + 'ƽ�ף�');
    NewLine;
    XPos := SectionLeft + 1  ;    Print('�Ű��ܹ�'   + VarToStr(List.NumDoor) + '�飬' + VarToStr(List.AreaDoor) + 'ƽ�ף�');

    NewLine;
    YPos := YPos + fLBoottom;
		rowW := 2;
    XPos := SectionLeft + rowW * 0 ;   	Print('����(��)��');
    XPos := SectionLeft + rowW * 1 ;  	Print('��ߣ�');
    XPos := SectionLeft + rowW * 2 ;   	Print('���(������)��');
    XPos := SectionLeft + rowW * 3 ;   	Print('��װ��');
    XPos := SectionLeft + rowW * 4 ;    Print('�ʼ죺');


  end;

end;

procedure TF_Prt_Prd2.RvSysHDW2Print(Sender: TObject);
var
  i, j: Integer;
  strSQL: string;
  CabTabID : string ;
  rowH, rowW, rowTop : Double;
begin

  with Sender AS TBaseReport do
  begin

    //���߿���
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    InitData();

    PrintHdw2Columns(Sender);


    //_____________________��ӡ�������______________________

    rowH := LineHeight * TabLineH ;


    //_____________________��ӡ�������______________________

    SetFont(ftB, fzBody + fzB);

    for i := 0 to Length(List.hdwPrc) - 1 do
    begin

      rowTop := YPos;
      //YPos := rowTop;
      with List.hdwPrc[i] do
      begin

        YPos := YPos + rowH - fLBoottom;

        PrintXY(c1  + l, YPos, IntToStr(i + 1));
        PrintXY(c2  + l, YPos, hdName);
        PrintXY(c10 + l, YPos, IntToStr(hdNum));

        YPos := YPos + fLBoottom;
        //MoveTo(c3, YPos); LineTo(c12, YPos);

        MoveTo(c1, YPos); LineTo(c12, YPos);

      end;


        //________________________��ҳ___________________________
      if i + 1 < Length(List.cabPrd) then
      if YPos + rowH * Length(List.cab[i + 1].hdw ) > SectionBottom then
      begin
        l0 := YPos;
        tabBottom := YPos;
        MoveTo(c12, YPos); LineTo(c0, YPos);

        //________________________����___________________________

        MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
        MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
//        MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
//        MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);

        MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
        MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
        MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

        NewPage;

        PrinthdwColumns(Sender);
      end;

    end; { for }
//    MoveTo(c12, YPos); LineTo(c0, YPos);

    l0 := YPos;
		tabBottom := YPos;
    //________________________����___________________________
		MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
		MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
//    MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
//		MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);

		MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
		MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
		MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

    //_______________________�������_________________________
    NewLine;

    YPos := YPos + fLBoottom * 2;
    Print('������ܣ�');
    rowW := 2.5;
    XPos := SectionLeft + 1  ;    Print('������ܹ�' + VarToStr(List.NumBody) + '�飬' + VarToStr(List.AreaBody) + 'ƽ�ף�');
    NewLine;
    XPos := SectionLeft + 1  ;    Print('�����ܹ�'   + VarToStr(List.NumBack) + '�飬' + VarToStr(List.AreaBack) + 'ƽ�ף�');
    NewLine;
    XPos := SectionLeft + 1  ;    Print('�Ű��ܹ�'   + VarToStr(List.NumDoor) + '�飬' + VarToStr(List.AreaDoor) + 'ƽ�ף�');

    NewLine;
    YPos := YPos + fLBoottom;
		rowW := 2;
    XPos := SectionLeft + rowW * 0 ;   	Print('����(��)��');
    XPos := SectionLeft + rowW * 1 ;  	Print('��ߣ�');
    XPos := SectionLeft + rowW * 2 ;   	Print('���(������)��');
    XPos := SectionLeft + rowW * 3 ;   	Print('��װ��');
    XPos := SectionLeft + rowW * 4 ;    Print('�ʼ죺');
    

  end;

end;

end.




