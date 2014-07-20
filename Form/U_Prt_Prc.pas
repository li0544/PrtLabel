unit U_Prt_Prc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpDefine, RpBase, RpSystem, DB, ADODB, Math, StdCtrls, UMain,
  UPub;

type
  TF_Prt_Prc = class(TForm)
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
  end;

var
  F_Prt_Prc: TF_Prt_Prc;

implementation

{$R *.dfm}
var
  cStr: string;

  //RvSystem1Print
  l0, l1: Double;
  c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10: Double;
  i1, i2, i3: Double;

procedure TF_Prt_Prc.RvSystem1Print(Sender: TObject);
var
  i: Integer;
  strSQL: string;
  TabH : Double ;
begin
  with Sender as TBaseReport do
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

    strSQL := 'select * from list WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;

    PrintLeft('����:' + FormatDateTime('yy-mm-dd', Date), 0.5);
    PrintLeft('����:' + strListID , 2.5);
    PrintLeft('��ַ:'  , 5);
    PrintLeft('�绰:'  , 7.5);
    PrintLeft('����:'  , 9);
    YPos := YPos + 0.05 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    YPos := YPos + 0.03 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    NewLine ;
    //YPos := YPos - fLBoottom ;
    PrintLeft('�Ű����:' + strBod_Door , 0.7);
    PrintLeft('����:' + FieldStrN( qry1 , '�Ű嵥��', PrcRound ) , 4 );
    PrintLeft('���:' + FieldStrN( qry1 , '�Ű����', AreaRound ) , 6 );
    PrintLeft('���:' + FieldStrN( qry1 , '�Ű�۸�', PrcRound ) , 8 );
    NewLine;
    PrintLeft('�������:' + strBod_Body , 0.7 );
    PrintLeft('����:' + FieldStrN( qry1 , '����嵥��', PrcRound ) , 4 );
    PrintLeft('���:' + FieldStrN( qry1 , '��������', AreaRound ) , 6 );
    PrintLeft('���:' + FieldStrN( qry1 , '�����۸�', PrcRound ) , 8 );
    NewLine;
    PrintLeft('�������:' + strBod_Back , 0.7);
    PrintLeft('����:' + FieldStrN( qry1 , '���嵥��', PrcRound ) , 4 );
    PrintLeft('���:' + FieldStrN( qry1 , '�������', AreaRound ) , 6 );
    PrintLeft('���:' + FieldStrN( qry1 , '����۸�', PrcRound ) , 8 );
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
    PrintXY(c9 + i1, l1 - i2, '�Ű���');

    strSQL := 'select * From TCab WHERE ListID=''' + strListID + ''' Order By CabIndex';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    for i := 1 to qry1.RecordCount do
    begin
      //________________________���ƺ��߼�����__________________________
      NewLine;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c10, l1);
      PrintXY(c0 + i1, l1 - i2, FieldStr( qry1 , 'CabIndex' ) );
      PrintXY(c1 + i1, l1 - i2, FieldStr( qry1 , 'Nam' ) );
      PrintXY(c2 + i1, l1 - i2, FieldStr( qry1 , '�ߴ�' ) );
      PrintXY(c3 + i1, l1 - i2, FieldStr( qry1 , 'N' ) );
      PrintXY(c4 + i1, l1 - i2, FieldStr( qry1 , '����' ) );
      PrintXY(c5 + i1, l1 - i2, FieldStr( qry1 , '��������' ) );
      PrintXY(c6 + i1, l1 - i2, FieldStr( qry1 , '�������' ) );
      PrintXY(c7 + i1, l1 - i2, FieldStr( qry1 , '�Ű����' ) );
      PrintXY(c8 + i1, l1 - i2, FieldStr( qry1 , '����۸�' ) );
      PrintXY(c9 + i1, l1 - i2, FieldStr( qry1 , '�Ű�۸�' ) );
      qry1.Next;
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
        MoveTo(c9, l0); LineTo(c9, l1);
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
        PrintXY(c9 + i1, l1 - i2, '�Ű���');

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
    MoveTo(c9, l0); LineTo(c9, l1);
    MoveTo(c10, l0); LineTo(c10, l1);

    //����ϼƽ��
    NewLine;
    YPos := YPos + TabH / 4 ;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;
    strSQL := 'select * from List WHERE ListID=''' + strListID + '''';
    AQrySel(qry1, strSQL);
    Print('���岿�� �ϼƽ� ' + FieldStrN( qry1 , '����ϼƽ��', PrcRound ) + ' Ԫ');
    SetFont(ftB, fzBody + fzB );
    Bold := False;


    //______________________________���۸�____________________________________
    strSQL := 'select * from HDWareSum WHERE ListID='''+ strListID +'''';
    AQrySel( qry1 , strSQL ) ;
    if qry1.RecordCount > 0 then
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

//      strSQL := 'select * from HDWareSum WHERE ListID=''' + strListID + '''';
//      qry1.SQL.Clear;
//      qry1.SQL.Add(strSQL);
//      qry1.Open;
      for i := 1 to qry1.RecordCount do
      begin
        NewLine;
        l1 := l1 + TabH ;
        MoveTo(c0, l1); LineTo(c9, l1); //������
        PrintXY(c0 + i1, l1 - i2, FieldStr( qry1 , '���' ) );
        PrintXY(c1 + i1, l1 - i2, FieldStr( qry1 , '����' ) );
        PrintXY(c2 + i1, l1 - i2, FieldStr( qry1 , '���' ) );
        PrintXY(c3 + i1, l1 - i2, FieldStr( qry1 , '����' ) );
        PrintXY(c4 + i1, l1 - i2, FieldStr( qry1 , '����' ) );
        PrintXY(c5 + i1, l1 - i2, FieldStr( qry1 , 'ͳ��' ) );
        PrintXY(c6 + i1, l1 - i2, FieldStr( qry1 , '����' ) );
        PrintXY(c7 + i1, l1 - i2, FieldStr( qry1 , '�۸�' ) );
        PrintXY(c8 + i1, l1 - i2, FieldStr( qry1 , '��ע' ) );
        i3 := i3 + FieldDob( qry1 , '�۸�' ) ;
        qry1.Next;
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
      strSQL := 'select * from List WHERE ListID=''' + strListID + '''';
      AQrySel(qry1, strSQL);
      PrintXY(c0, YPos, '��𲿷� �ϼƽ� ' + FieldStrN( qry1 , '���۸�', PrcRound) + ' Ԫ');
      SetFont(ftB, fzBody + fzB );
      Bold := False;

    end;

    //______________________________�����Ӽ���Ŀ________________________________
    //Ĭ���и�
    LineHeight := TabOldLineH ;

    NewLine;
    XPos := 0.5;

    strSQL := 'select * from prclist5 where ���� like ''���͹�'' and ���� > 0 '
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

    strSQL := 'select * from prclist5 where ���� like ''ˮ�۹�1'' and ���� > 0 '
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

    strSQL := 'select * from prclist5 where ���� like ''ˮ�۹�2'' and ���� > 0 '
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

    //_______________________________�ϼƽ��___________________________________
    NewLine;
    XPos := 0.5;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;
    
    strSQL := 'select * from List WHERE ListID=''' + strListID + '''';
    AQrySel(qry1, strSQL);
    //PrintXY(c0, YPos, '������' + FieldStr( qry1 , '����Ӽ�' ) + 'Ԫ');
    PrintXY(c0, YPos, '������' );
    NewLine;
    PrintXY(c0, YPos, '�ۼƽ�' + FieldStrN(qry1 , '�ϼƽ��', PrcRound ) + 'Ԫ');
    PrintXY(6, YPos, '��ˣ�');
    PrintXY(8, YPos, '����ȷ�ϣ�');
    SetFont(ftB, fzBody + fzB );
    Bold := False;  
  end;

end;

procedure TF_Prt_Prc.PrintColumns(var Sender: TObject);
begin
//  with Sender as TBaseReport do
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

procedure TF_Prt_Prc.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry1.ConnectionString := strCon;

end;

procedure TF_Prt_Prc.btn5Click(Sender: TObject);
begin
  RvSystem1.Execute;
end;

procedure TF_Prt_Prc.PrintBoardColumns(var Sender: TObject);
begin
//  with Sender as TBaseReport do
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

procedure TF_Prt_Prc.PrintHardwareColumns(var Sender: TObject);
begin
//  with Sender as TBaseReport do
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

