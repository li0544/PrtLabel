unit U_Prt_Prc2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpDefine, RpBase, RpSystem, DB, ADODB, StdCtrls, UParam, UADO,
  UPub, CondExpression;

type
  TF_Prt_Prc2 = class(TForm)
    RvSystem1: TRvSystem;
    qry1: TADOQuery;
    btn5: TButton;
    procedure RvSystem1Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn5Click(Sender: TObject);

  private
    procedure PrintBoardColumns(var Sender: TObject);
    procedure PrintHardwareColumns(var Sender: TObject);
    procedure PrintColumns(var Sender: TObject);
  public
    { Public declarations }
    function ChkVal(sVal : string) : Boolean;
  end;

var
  F_Prt_Prc2: TF_Prt_Prc2;

implementation

uses U_List_PrcAdd, U_Prt_Opt;

{$R *.dfm}
var
  cStr: string;

  //RvSystem1Print
  l0, l1: Double;
  c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10: Double;
  i1, i2, i3: Double;

procedure TF_Prt_Prc2.RvSystem1Print(Sender: TObject);
var
  i, j: Integer;
  strSQL: string;
  TabH : Double ;
  tem_cab : T_Cabinet;
  sExp : string;
  i_index : Integer;
begin
  with Sender AS TBaseReport do
  begin
    //__________________________��ȡ���������Ϣ________________________________
    ReadFZFormIniFile(I_PRC);

    //���߿���
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    SectionTop := 0.75; //����
    SectionLeft := 0.5;
    SetFont(ftT, fzTitle ); //��������

    PrintCenter( strTabPrc , PageWidth / 2); //����
    NewLine;
    SetFont(ftB, fzBody + fzB );

    PrintLeft('����:' + FormatDateTime('yy-mm-dd', Date), 0.5);
    PrintLeft('����:' + strListID , 2.5);
    PrintLeft('��ַ:'  , 5);
    PrintLeft('�绰:'  , 7.5);
    PrintLeft('����:'  , 9);
    YPos := YPos + 0.05 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    YPos := YPos + 0.03 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    NewLine ;
    if ptDoorPrc = 0 then
    begin
      PrintLeft('�Ű����:' + List.CZhDoor , 0.7);
      PrintLeft('����:' + StrN(List.PrcDoor , PrcRound) , 4 );
      PrintLeft('���:' + StrN(List.AreaDoor , AreaRound) , 6 );
      PrintLeft('���:' + StrN(List.SumPrcDoor , PrcRound) , 8 );
      NewLine;
    end;
    PrintLeft('�������:' + List.CZhBody , 0.7 );
    PrintLeft('����:' + StrN(List.PrcBody , PrcRound) , 4 );
    PrintLeft('���:' + StrN(List.AreaBody , AreaRound) , 6 );
    PrintLeft('���:' + StrN(List.SumPrcBody , PrcRound) , 8 );
    NewLine;
    PrintLeft('�������:' + List.CZhBack , 0.7);
    PrintLeft('����:' + StrN(List.PrcBack , PrcRound) , 4 );
    PrintLeft('���:' + StrN(List.AreaBack , AreaRound) , 6 );
    PrintLeft('���:' + StrN(List.SumPrcBack , PrcRound) , 8 );

    NewLine;
    YPos := YPos - 0.1 ;
    
    //_______________��ļ۸�___________________
    i1 := 1.2;
    l0 := YPos;
    c0 := XPos;
    c1 := c0 + 0.5; //���         1.0
    c2 := c1 + 1.8; //����         2.8
    c3 := c2 + 1.2; //���         4.0
    c4 := c3 + 0.6; //����         4.6
    c5 := c4 + 1.0; //���޸���     5.6
    c6 := c5 + 1.0; //�������     6.6
    c7 := c6 + 1.0; //�������     7.6
    c8 := c7 + 1.0; //�Ű����     8.6
    c9 := c8 + 1.0; //�۸�         9.6
    c10 := c9 + 1.0; //�Ű�۸�     10.6

    //�и�
    TabOldLineH := LineHeight ;
    TabH := LineHeight * TabLineH ;
    LineHeight := TabH ;

    i1 := 0.1  ;
    i2 := fLBoottom ;
    i3 := 0    ;

    SetFont(ftB, fzBody + fzB );

    l1 := YPos;
    MoveTo(c0, l0); LineTo(c10, l0);
    NewLine;
    l1 := l1 + TabH ;
    MoveTo(c0, l1); LineTo(c10, l1);
    PrintXY(c0 + i1, l1 - i2, '���');
    PrintXY(c1 + i1, l1 - i2, '����');
    PrintXY(c2 + i1, l1 - i2, '���');
    PrintXY(c3 + i1, l1 - i2, '����');
    PrintXY(c4 + i1, l1 - i2, '���޸���');
    PrintXY(c5 + i1, l1 - i2, '�������');
    PrintXY(c6 + i1, l1 - i2, '�������');
    PrintXY(c7 + i1, l1 - i2, '�Ű����');
    PrintXY(c8 + i1, l1 - i2, '������');
    if ptDoorPrc = 0 then PrintXY(c9 + i1, l1 - i2, '�Ű���');

    //�Գ����������
    for i := 0 to Length(List.cab) - 2 do
    begin
      for j := 0 to Length(List.cab) - 2 do
      begin
        // if 'W' > 'B'
        if Copy(List.cab[j].cabTypeID, 0, 1) > Copy(List.cab[j + 1].cabTypeID, 0, 1) then
        begin
          tem_cab := List.cab[j];
          List.cab[j] := List.cab[j + 1];
          List.cab[j + 1] := tem_cab;
        end;
      end;
    end;

    for i := 0 to Length(List.cab) - 1 do
    begin
      //________________________���ƺ��߼�����__________________________
      NewLine;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c10, l1);

      PrintXY(c0 + i1, l1 - i2, IntToStr(List.cab[i].Index + 1 ) );
      if ptType = 1 then
        PrintXY(c1 + i1, l1 - i2, List.cab[i].cabName  )
      else
        PrintXY(c1 + i1, l1 - i2, List.cab[i].cabTypeID  );
      PrintXY(c2 + i1, l1 - i2, VarToStr(List.cab[i].cabW_H_D ) );
      PrintXY(c3 + i1, l1 - i2, IntToStr(List.cab[i].cabNum ) );
      PrintXY(c4 + i1, l1 - i2, List.cab[i].cabGB  );
      PrintXY(c5 + i1, l1 - i2, StrN(List.cab[i].AreaBody , AreaRound) );
      PrintXY(c6 + i1, l1 - i2, StrN(List.cab[i].AreaBack , AreaRound) );
      PrintXY(c7 + i1, l1 - i2, StrN(List.cab[i].AreaDoor , AreaRound) );
      PrintXY(c8 + i1, l1 - i2, StrN(List.cab[i].PrcBody + List.cab[i].PrcBack , PrcRound ) );
      if ptDoorPrc = 0 then PrintXY(c9 + i1, l1 - i2, StrN(List.cab[i].PrcDoor , PrcRound ) );

      if YPos > 7 then
      begin
        //__________________________��������__________________________
        MoveTo(c0, l0); LineTo(c0, l1);
        MoveTo(c1, l0); LineTo(c1, l1);
        MoveTo(c2, l0); LineTo(c2, l1);
        MoveTo(c3, l0); LineTo(c3, l1);
        MoveTo(c4, l0); LineTo(c4, l1);
        MoveTo(c5, l0); LineTo(c5, l1);
        MoveTo(c6, l0); LineTo(c6, l1);
        MoveTo(c7, l0); LineTo(c7, l1);
        MoveTo(c8, l0); LineTo(c8, l1);
        if ptDoorPrc = 0 then MoveTo(c9, l0); LineTo(c9, l1);
        MoveTo(c10, l0); LineTo(c10, l1);

        NewPage; //��ҳ���½�ҳ

        YPos := 0.75;
        l0 := YPos;
        MoveTo(c0, l0); LineTo(c10, l0);
        NewLine;
        l1 := YPos;
        MoveTo(c0, l1); LineTo(c10, l1);
        PrintXY(c0 + i1, l1 - i2, '���');
        PrintXY(c1 + i1, l1 - i2, '����');
        PrintXY(c2 + i1, l1 - i2, '���');
        PrintXY(c3 + i1, l1 - i2, '����');
        PrintXY(c4 + i1, l1 - i2, '���޸���');
        PrintXY(c5 + i1, l1 - i2, '�������');
        PrintXY(c6 + i1, l1 - i2, '�������');
        PrintXY(c7 + i1, l1 - i2, '�Ű����');
        PrintXY(c8 + i1, l1 - i2, '������');
        if ptDoorPrc = 0 then PrintXY(c9 + i1, l1 - i2, '�Ű���');

        //PrintColumns(Sender);
      end;
    end;
    //__________________________��������__________________________
    MoveTo(c0, l0); LineTo(c0, l1);
    MoveTo(c1, l0); LineTo(c1, l1);
    MoveTo(c2, l0); LineTo(c2, l1);
    MoveTo(c3, l0); LineTo(c3, l1);
    MoveTo(c4, l0); LineTo(c4, l1);
    MoveTo(c5, l0); LineTo(c5, l1);
    MoveTo(c6, l0); LineTo(c6, l1);
    MoveTo(c7, l0); LineTo(c7, l1);
    MoveTo(c8, l0); LineTo(c8, l1);
    if ptDoorPrc = 0 then MoveTo(c9, l0); LineTo(c9, l1);
    MoveTo(c10, l0); LineTo(c10, l1);

    //����ϼƽ��
    NewLine;
    YPos := YPos + TabH / 4 ;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;
    if ptDoorPrc = 0 then
      Print('���岿�� �ϼƽ� ' + StrN(List.SumPrcBod , PrcRound) + ' Ԫ')
    else
      Print('���岿�� �ϼƽ� ' + StrN(List.SumPrcBod - List.SumPrcDoor , PrcRound) + ' Ԫ');
    SetFont(ftB, fzBody + fzB );
    Bold := False;


    //______________________________���۸�____________________________________
    
    if Length(List.hdwPrc) > 0 then
    begin
      //NewLine;
      YPos := YPos + 0.1 ;
      i1 := 1.2;
      l0 := YPos;
            //c0 := XPos;
      c1 := c0 + 0.5; //���
      c2 := c1 + 1.8; //����
      c3 := c2 + 1.2; //���
      c4 := c3 + 0.6; //����
      c5 := c4 + 1.0; //Ҫ��
      c6 := c5 + 1.0; //ͳ��
      c7 := c6 + 1.0; //����
      c8 := c7 + 1.0; //�۸�
      c9 := c8 + 2.0; //��ע

      i1 := 0.1;
      i2 := fLBoottom ;

      l1 := YPos;
      MoveTo(c0, l0); LineTo(c9, l0);
      NewLine;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c9, l1);
      PrintXY(c0 + i1, l1 - i2, '���');
      PrintXY(c1 + i1, l1 - i2, '����');
      PrintXY(c2 + i1, l1 - i2, '���');
      PrintXY(c3 + i1, l1 - i2, '����');
      PrintXY(c4 + i1, l1 - i2, 'Ҫ��');
      PrintXY(c5 + i1, l1 - i2, 'ͳ��');
      PrintXY(c6 + i1, l1 - i2, '����');
      PrintXY(c7 + i1, l1 - i2, '�۸�');
      PrintXY(c8 + i1, l1 - i2, '��ע');


      for i := 0 to Length(List.hdwPrc) - 1 do
      begin
        NewLine;
        l1 := l1 + TabH ;
        MoveTo(c0, l1); LineTo(c9, l1); //������
        PrintXY(c0 + i1, l1 - i2, IntToStr(List.hdwPrc[i].Index + 1) );
        PrintXY(c1 + i1, l1 - i2, List.hdwPrc[i].hdName );
        PrintXY(c2 + i1, l1 - i2, '' );
        PrintXY(c3 + i1, l1 - i2, IntToStr(List.hdwPrc[i].hdNum) );
        PrintXY(c4 + i1, l1 - i2, '' );
        PrintXY(c5 + i1, l1 - i2, IntToStr(List.hdwPrc[i].hdNum) );
        PrintXY(c6 + i1, l1 - i2, StrN(List.hdwPrc[i].hdPrice , PrcRound) );
        PrintXY(c7 + i1, l1 - i2, StrN(List.hdwPrc[i].hdSumPrice , PrcRound) );
        PrintXY(c8 + i1, l1 - i2, '' );
        
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
          MoveTo(c8, l0); LineTo(c8, l1);
          MoveTo(c9, l0); LineTo(c9, l1);

          NewPage; //��ҳ���½�ҳ

          YPos := 0.75;
          l0 := YPos;
          MoveTo(c0, l0); LineTo(c9, l0);
          NewLine;
          l1 := YPos;
          MoveTo(c0, l1); LineTo(c9, l1);
          PrintXY(c0 + i1, l1 - i2, '���');
          PrintXY(c1 + i1, l1 - i2, '����');
          PrintXY(c2 + i1, l1 - i2, '���');
          PrintXY(c3 + i1, l1 - i2, '����');
          PrintXY(c4 + i1, l1 - i2, 'Ҫ��');
          PrintXY(c5 + i1, l1 - i2, 'ͳ��');
          PrintXY(c6 + i1, l1 - i2, '����');
          PrintXY(c7 + i1, l1 - i2, '�۸�');
          PrintXY(c8 + i1, l1 - i2, '��ע');
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
      MoveTo(c8, l0); LineTo(c8, l1);
      MoveTo(c9, l0); LineTo(c9, l1);

      //���ϼƽ��
      NewLine;
      YPos := YPos + TabH / 4 ;
      SetFont('����', fzMinTit);
      Bold := True;
      PrintXY(c0, YPos, '��𲿷� �ϼƽ� ' + StrN(List.SumPrcHD_ , PrcRound) + ' Ԫ');
      SetFont(ftB, fzBody + fzB );
      Bold := False;

    end;


    //______________________________�����Ӽ���Ŀ________________________________

    if Length(List.cab) > 0 then
    begin
      //NewLine;
      YPos := YPos + 0.1 ;
      i1 := 1.2;
      l0 := YPos;
            //c0 := XPos;
      c1 := c0 + 0.5; //���
      c2 := c1 + 1.8; //����
      c3 := c2 + 1.2; //���
      c4 := c3 + 0.6; //����
      c5 := c4 + 1.0; //�Ӽ۽��
      c6 := c5 + 1.0; //�ϼƽ��
      c7 := c6 + 4.0; //��ע

      i1 := 0.1;
      i2 := fLBoottom ;
      i_index := 0;
      List.SumPrcTS_ := 0;

      l1 := YPos;
      MoveTo(c0, l0); LineTo(c7, l0);
      NewLine;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c7, l1);
      PrintXY(c0 + i1, l1 - i2, '���');
      PrintXY(c1 + i1, l1 - i2, '����');
      PrintXY(c2 + i1, l1 - i2, '���');
      PrintXY(c3 + i1, l1 - i2, '����');
      PrintXY(c4 + i1, l1 - i2, '�Ӽ۽��');
      PrintXY(c5 + i1, l1 - i2, '�ϼƽ��');
      PrintXY(c6 + i1, l1 - i2, '��ע');


      for i := 0 to Length(List.cab) - 1 do
      begin

        for j :=0 to Length(List.tsPrc) - 1 do
        begin
          if Pos(List.tsPrc[j].Name, List.cab[i].cabName) = 0 then Continue;
          sExp := List.tsPrc[j].GS;
          sExp := StringReplace(sExp, '���', Dtos(List.cab[i].cabW), [rfReplaceAll]);
          sExp := StringReplace(sExp, '�߶�', Dtos(List.cab[i].cabH), [rfReplaceAll]);
          if not ChkVal(sExp) then Continue;

          NewLine;
          l1 := l1 + TabH ;
          MoveTo(c0, l1); LineTo(c7, l1); //������
          Inc(i_index);
          PrintXY(c0 + i1, l1 - i2, ItoS(i_index) );
          PrintXY(c1 + i1, l1 - i2, List.cab[i].cabName );
          PrintXY(c2 + i1, l1 - i2, List.cab[i].cabW_H_D );
          PrintXY(c3 + i1, l1 - i2, ItoS(List.cab[i].cabNum) );
          PrintXY(c4 + i1, l1 - i2, Dtos(List.tsPrc[j].Prc) );
          PrintXY(c5 + i1, l1 - i2, Dtos(List.tsPrc[j].Prc * List.cab[i].cabNum) );
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
            PrintXY(c4 + i1, l1 - i2, '�Ӽ۽��');
            PrintXY(c5 + i1, l1 - i2, '�ϼƽ��');
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
      SetFont('����', fzMinTit);
      Bold := True;
      PrintXY(c0, YPos, '����Ӽ� �ϼƽ� ' + StrN(List.SumPrcTS_ , PrcRound) + ' Ԫ');
      SetFont(ftB, fzBody + fzB );
      Bold := False;

    end;
    {
    //Ĭ���и�
    LineHeight := TabOldLineH ;

    NewLine;
    XPos := 0.5;

    strSQL := 'SELECT * FROM prclist5 WHERE ���� LIKE ''���͹�'' AND ���� > 0 '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      Print('���͹�������');
      Print(VarToStr(FieldStr( qry1 , '����' ) ) + ',');
      Print('�Ӽۣ�');
      Print(VarToStr(FieldStr( qry1 , '�۸�' ) ) + 'Ԫ; ');
      i3 := i3 + FieldDob( qry1 , '�۸�' ) ;
    end;

    strSQL := 'SELECT * FROM prclist5 WHERE ���� LIKE ''ˮ�۹�1'' AND ���� > 0 '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      Print('<=900ˮ�۹�������');
      Print(VarToStr(FieldStr( qry1 , '����' ) ) + ',');
      Print('�Ӽۣ�');
      Print(VarToStr(FieldStr( qry1 , '�۸�' ) ) + 'Ԫ; ');
      i3 := i3 + FieldDob( qry1 , '�۸�' ) ;
    end;

    strSQL := 'SELECT * FROM prclist5 WHERE ���� LIKE ''ˮ�۹�2'' AND ���� > 0 '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      Print('����900ˮ�۹�������');
      Print(VarToStr(FieldStr( qry1 , '����' ) ) + ',');
      Print('�Ӽۣ�');
      Print(VarToStr(FieldStrN( qry1 , '�۸�', PrcRound ) ) + 'Ԫ; ');
      i3 := i3 + FieldDob( qry1 , '�۸�' ) ;
    end;
    }
    //_______________________________�ϼƽ��___________________________________
    NewLine;
    XPos := 0.5;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;    PrintXY(c0, YPos, '������' );
    NewLine;
    F_List_PrcAdd.btnRef.Click;
    PrintXY(c0, YPos, List.strPrcOth);
    NewLine;

    if ptDoorPrc = 0 then
      PrintXY(c0, YPos, '�ۼƽ�' +  StrN(List.SumPrcBod + List.SumPrcHD_ + List.SumPrcTS_  + List.NumPrcOth, PrcRound) + 'Ԫ')
    else
      PrintXY(c0, YPos, '�ۼƽ�' +  StrN(List.SumPrcBod + List.SumPrcHD_ + List.SumPrcTS_ - List.SumPrcDoor + List.NumPrcOth, PrcRound) + 'Ԫ');
    PrintXY(6, YPos, '��ˣ�');
    PrintXY(8, YPos, '����ȷ�ϣ�');
    SetFont(ftB, fzBody + fzB );
    Bold := False;

    NewLine;
    PrintXY(c0, YPos, '���п���1: ' + F_Prt_Opt.tboxBankID1.Text + '    '
      + '���п���2: ' + F_Prt_Opt.tboxBankID2.Text + '    '
      + '���п���3: ' + F_Prt_Opt.tboxBankID3.Text);
  end;

end;

function TF_Prt_Prc2.ChkVal(sVal : string) : Boolean;
var
  ce : TCondExpression;
begin
  ce :=  TCondExpression.Create();

  ce.Compile( sVal );

    if ce.GetResult() then
      Result := True
    else
      Result := False;

  ce.Free;

end;

procedure TF_Prt_Prc2.PrintColumns(var Sender: TObject);
begin
//  with Sender AS TBaseReport do
//  begin
//    YPos := 0.75;
//    l0 := YPos;
//    MoveTo(c0, l0); LineTo(c10, l0);
//    NewLine;
//    l1 := YPos;
//    MoveTo(c0, l1); LineTo(c10, l1);
//    PrintXY(c0 + i1, l1 - i2, '���');
//    PrintXY(c1 + i1, l1 - i2, '����');
//    PrintXY(c2 + i1, l1 - i2, '���');
//    PrintXY(c3 + i1, l1 - i2, '����');
//    PrintXY(c4 + i1, l1 - i2, '���޸���');
//    PrintXY(c5 + i1, l1 - i2, '�������');
//    PrintXY(c6 + i1, l1 - i2, '�������');
//    PrintXY(c7 + i1, l1 - i2, '�Ű����');
//    PrintXY(c8 + i1, l1 - i2, '������');
//    PrintXY(c9 + i1, l1 - i2, '�Ű���');
//  end;
end;

procedure TF_Prt_Prc2.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry1.ConnectionString := getConStr();

end;

procedure TF_Prt_Prc2.btn5Click(Sender: TObject);
begin
  RvSystem1.Execute;
end;

procedure TF_Prt_Prc2.PrintBoardColumns(var Sender: TObject);
begin
//  with Sender AS TBaseReport do
//  begin
//    YPos := 0.75;
//    l0 := YPos;
//    MoveTo(c0, l0); LineTo(c10, l0);
//    NewLine;
//    l1 := YPos;
//    MoveTo(c0, l1); LineTo(c10, l1);
//    PrintXY(c0 + i1, l1 - i2, '���');
//    PrintXY(c1 + i1, l1 - i2, '����');
//    PrintXY(c2 + i1, l1 - i2, '���');
//    PrintXY(c3 + i1, l1 - i2, '����');
//    PrintXY(c4 + i1, l1 - i2, '���޸���');
//    PrintXY(c5 + i1, l1 - i2, '�������');
//    PrintXY(c6 + i1, l1 - i2, '�������');
//    PrintXY(c7 + i1, l1 - i2, '�Ű����');
//    PrintXY(c8 + i1, l1 - i2, '������');
//    PrintXY(c9 + i1, l1 - i2, '�Ű���');
//  end;
end;

procedure TF_Prt_Prc2.PrintHardwareColumns(var Sender: TObject);
begin
//  with Sender AS TBaseReport do
//  begin
//    YPos := 0.75;
//    l0 := YPos;
//    MoveTo(c0, l0); LineTo(c10, l0);
//    NewLine;
//    l1 := YPos;
//    MoveTo(c0, l1); LineTo(c10, l1);
//    PrintXY(c0 + i1, l1 - i2, '���');
//    PrintXY(c1 + i1, l1 - i2, '����');
//    PrintXY(c2 + i1, l1 - i2, '���');
//    PrintXY(c3 + i1, l1 - i2, '����');
//    PrintXY(c4 + i1, l1 - i2, '���޸���');
//    PrintXY(c5 + i1, l1 - i2, '�������');
//    PrintXY(c6 + i1, l1 - i2, '�������');
//    PrintXY(c7 + i1, l1 - i2, '�Ű����');
//    PrintXY(c8 + i1, l1 - i2, '������');
//    PrintXY(c9 + i1, l1 - i2, '�Ű���');
//  end;
end;

end.


