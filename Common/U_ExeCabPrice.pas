unit U_ExeCabPrice;



interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms, Dialogs,
  DB, ADODB, Math, UParam, UPub, UADO;

procedure ExeCabPrice();
procedure ExeBoardPrice();
procedure ExeHDWarePrice();
procedure GroupAreaAndTotal();

implementation

uses U_Prt;

procedure ExeBoardPrice();
var
  strSQL : string;
  strFBDoor , strFBBody : string ;
  strBodCZ : string ;
  strBodName : string ;
  strBodNum : string;
  strPic : string ;
  strCabTabID , strCabArea , strCabPic : string ;
  i , j : Integer ;
  
const
  S_TAB_COL : array [ 0..5 , 0..2 ] of string = (
  ( '���' , 'BodName Not IN ( ''�Ű�'' , ''����'' )', '��������' ) ,
  ( '���' , 'BodName=''�Ű�''',                     '�Ű����'   ) ,
  ( '���' , 'BodName=''����''',                     '�������'   ) ,
  ( '�۸�' , 'BodName Not IN ( ''�Ű�'' , ''����'' )', '�����۸�' ) ,
  ( '�۸�' , 'BodName=''�Ű�''',                     '�Ű�۸�'   ) ,
  ( '�۸�' , 'BodName=''����''',                     '����۸�'   ) ) ;

begin
  with F_Prt do
  begin
    //__________________���ò�ͬ��ķ�ߣ�����Ϊ0 ______________________
    strSQL := 'SELECT TOP 1 * FROM TOption WHERE ���� LIKE ''�Ű���''';
    AQrySel( qry1 , strSQL ) ;
    strFBDoor := FieldStr(qry1 , 'Val' );

    strSQL := 'Update TBod SET ���=' + strFBDoor + ' WHERE BodName=''�Ű�'' AND ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'SELECT TOP 1 * FROM TOption WHERE ���� LIKE ''������''';
    AQrySel( qry1 , strSQL ) ;
    strFBBody := FieldStr(qry1 , 'Val' );

    strSQL := 'Update TBod SET ���=' + strFBBody + ' WHERE BodName Not IN ( ''�Ű�'' , ''����'' ) AND ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //_______________________���㵥��������___________________________
    strSQL := 'Update TBod SET ��� = (��� * 2 + ����) * (��� * 2 + ���) * ���� / 1000000 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //_______________________��ѯ��ͬ���ʼ۸�____________________________
    strSQL := 'SELECT Distinct ���� AS BodCZ , BodName AS BodName FROM TBod WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    for i := 0 to qry1.RecordCount - 1 do
    begin
      strBodCZ := FieldStr( qry1 , 'BodCZ' );

      strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + strBodCZ + ''' AND chk=''True'' AND Type=1';
      AQrySel( qry2 , strSQL ) ;
      if qry2.RecordCount = 0 then strPic := '0'
      else strPic := FieldStr( qry2 , 'Prc' ) ;

      strSQL := 'Update TBod SET ����=' + strPic + ' WHERE ����=''' + strBodCZ + ''' AND ListID=''' + strListID + ''''  ;
      AQryCmd( qry2 , strSQL ) ;

      strBodName := FieldStr( qry1 , 'BodName' ) ;
      if ( strBodName <> '�Ű�' ) AND ( strBodName <> '����' ) then strBodName := '�����' ;
      strSQL := 'Update List SET ' + strBodName + '����=' + strPic + ' WHERE ListID='''+ strListID +'''' ;
      AQryCmd( qry2 , strSQL ) ;

      qry1.Next;
    end;

    //________________________���㵥����ļ۸�_________________________
    strSQL := 'Update TBod SET �۸� = ��� * ���� WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //_______________________������ͳ�Ƽ۸�����______________________
    strSQL := 'SELECT * FROM TCab WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    for i :=0 to qry1.RecordCount - 1 do
    begin
      strCabTabID := FieldStr( qry1 , 'ID' ) ;
      for j := 0 to 5 do
      begin
        strSQL := 'SELECT Sum(' + S_TAB_COL[ j , 0 ] + ') AS Area FROM TBod WHERE ' + S_TAB_COL[ j , 1 ] + ' AND CabTabID =' + strCabTabID ;
        AQrySel( qry2 , strSQL ) ;
        strCabArea := FieldStr( qry2 , 'Area' ) ;

        if strCabArea = '' then strCabArea := '0' ;
        strSQL := 'Update TCab SET ' + S_TAB_COL[ j , 2 ] + '=' + strCabArea + ' WHERE ID=' + strCabTabID ;
        AQryCmd( qry2 , strSQL ) ;
      end;
      strSQL := 'SELECT Sum(����) AS BodNum FROM TBod WHERE CabTabID =' + strCabTabID ;
      AQrySel(qry2, strSQL);
      strBodNum := FieldStr(qry2, 'BodNum');

      strSQL := 'Update TCab SET BodNum=' + strBodNum + ' WHERE ID=' + strCabTabID ;
      AQryCmd(qry2, strSQL);
      qry1.Next;
    end;

    //_______________________��������ͳ�Ƽ۸�����______________________
    for i :=0 to 5 do
    begin
        strSQL := 'SELECT Sum(' + S_TAB_COL[ i , 0 ] + ') AS Area FROM TBod WHERE ' + S_TAB_COL[ i , 1 ] + ' AND ListID=''' + strListID + '''';
        AQrySel( qry1 , strSQL ) ;
        strCabArea := FieldStr( qry1 , 'Area' ) ;

        if strCabArea = '' then strCabArea := '0' ;
        strSQL := 'Update List SET ' + S_TAB_COL[ i , 2 ] + '=' + strCabArea + ' WHERE ListID=''' + strListID + '''';
        AQryCmd( qry1 , strSQL ) ;
    end;

    //_____________________________�������۸�____________________________
    strSQL := 'Update TCab SET ����۸� = �����۸� + ����۸� WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update List SET ����۸� = �����۸� + ����۸� , ����ϼƽ�� = �����۸� + ����۸� + �Ű�۸� WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update List SET �ϼƽ�� = ����ϼƽ�� + ���۸� + ����Ӽ� WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //________________________________������______________________________
    strSQL := 'SELECT * FROM TCab WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    for i :=0 to qry1.RecordCount - 1 do
    begin
      strCabTabID := FieldStr( qry1 , 'ID' ) ;

        strSQL := 'SELECT * FROM TBod WHERE BodName In ( ''����'' , ''���'' ) AND CabTabID =' + strCabTabID ;
        if AQrySel( qry2 , strSQL ) > 0 then
          strSQL := 'Update TCab SET ����=''�и�'' WHERE ID=' + strCabTabID
        else
          strSQL := 'Update TCab SET ����=''�޸�'' WHERE ID=' + strCabTabID ;
        AQryCmd( qry2 , strSQL ) ;

      qry1.Next;
    end;

  end;
end;  

procedure ExeHDWarePrice();
var
  strSQL : string ;
  strHDName , strNum , strPrc , strSumPrc : string ;
  i : Integer ;
begin
  with F_Prt do
  begin

    strSQL := 'SELECT TOP 1 ID FROM THDWare WHERE ListID=''' + strListID + '''' ;
    if AQrySel( qry1 , strSQL ) = 0 then Exit ;

    //_______________________________������𵥼�_______________________________
    strSQL := 'SELECT Distinct( Nam ) AS HDName FROM THDWare WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    for i := 0 to qry1.RecordCount - 1 do
    begin
      strHDName := FieldStr( qry1 , 'HDName' ) ;
      strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + strHDName + ''' AND chk=''True'' AND Type=2' ;
      AQrySel( qry2 , strSQL ) ;
      if qry2.RecordCount = 0 then strPrc := '0'
      else strPrc := FieldStr( qry2 , 'Prc' ) ;

      strSQL := 'Update THDWare SET ����=' + strPrc + ' WHERE Nam=''' + strHDName + ''' AND ListID=''' + strListID + '''' ;
      AQryCmd( qry2 , strSQL ) ;
      
      qry1.Next;
    end;

    //_______________________________�������۸�_______________________________
    strSQL := 'Update THDWare SET ͳ�� = ���� WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update THDWare SET �۸� = ���� * ͳ�� WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //____________________________������ͳ�����۸�____________________________
    strSQL := 'DELETE FROM HDWareSum WHERE ListID=''' + strListID + '''';
    AQryCmd( qry1 , strSQL );

    strSQL := 'SELECT DISTINCTROW nam , ListID , Sum(����) AS Num1, First(����) AS Prc1, Sum(�۸�) AS SumPrc '
    + 'FROM THDWare WHERE ListID=''' + strListID + ''' GROUP BY nam, ListID;' ;
    AQrySel( qry1 , strSQL ) ;
    for i := 0 to qry1.RecordCount - 1 do
    begin
      strName := FieldStr( qry1 , 'nam' ) ;
      strNum := FieldStr( qry1 , 'Num1' ) ;
      strPrc := FieldStr( qry1 , 'Prc1' ) ;
      strSumPrc := FieldStr( qry1 , 'SumPrc' ) ;
      strSQL := 'INSERT Into HDWareSum (���, ����, ����, ͳ��, ����, �۸�, ListID) VALUES('
      + IntToStr( i + 1 ) + ', ''' + strName + ''', ' + strNum + ', ' + strNum + ', ' + strPrc + ', '
      + strSumPrc + ' , ''' + strListID + ''' ) ' ;
      AQryCmd( qry2 , strSQL ) ;

      qry1.Next ;
    end;

    //_______________________________���¶����۸�_______________________________
    strSQL := 'SELECT  Sum(�۸�) AS SumPrc FROM THDWare WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    strSumPrc := FieldStr( qry1 , 'SumPrc' ) ;

    strSQL := 'Update List SET ���۸�=' + strSumPrc + ' WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update List SET �ϼƽ�� = �����۸� + ����۸� + �Ű�۸� + ���۸� + ����Ӽ� WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;
  end;
end;

procedure GroupAreaAndTotal();
begin
  with F_Prt do
  begin
  
  end;
end;

procedure ExeCabPrice();
var
  sql: string;
  s1, s2, s3, strCabID, s5, s6, s7, s8, s9: string;
  BodWidth, BodHeight, BodNum, i4, i5, i6, i7, i8, i9, fb1, fb2: Double;
  v1, v2, v3, v4, v5, v6, v7, v8, v9,
    v10, v11: string;
  c1, c2, c3, c4, c5, c6, c7, c8, c9,
    c10, c11: string;
  strVal: array of string;
  strCol: array of string;
  i, j, k, n: Integer;
  b1: Boolean;

begin
  //ͳ�Ƽ۸�
  SetLength(strCol,20);
  SetLength(strVal,20);

  with F_Prt do
  begin

    {
    //_______________ͳ�ư�ļ۸�___________________
    sql := 'SELECT * FROM TBod WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    if qry1.RecordCount = 0 then
    begin
      ShowMessage('���ȵ����ļ��������');
      Exit;
    end;
    n := 1;
    for i := 1 to qry1.RecordCount do
    begin
      s1 := FieldStr( qry1 , '����' ) ;
      s2 := FieldStr( qry1 , '����' ) ;
      s3 := FieldStr( qry1 , 'BodName' ) ; //�������
      strCabID := FieldStr( qry1 , 'ID' ) ;   //������
      s5 := FieldStr( qry1 , '��;' ) ; //��������
      b1 := FieldBoo( qry1 , '���' ) ;
      BodWidth := FieldDob( qry1 , '����' ) ;
      BodHeight := FieldDob( qry1 , '���' ) ;
      BodNum := FieldDob( qry1 , '����' ) ;
      //�Ű���
      sql := 'SELECT TOP 1 * FROM TOption WHERE ���� LIKE ''�Ű���''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      fb1 := FieldDob( qry2 , 'Val' ) ;
      fb1 := fb1 * 2;
      //������
      sql := 'SELECT * FROM TOption WHERE ���� LIKE ''������''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      fb2 := FieldDob( qry2 , 'Val' ) ;
      fb2 := fb2 * 2;

      if s2 = '' then s2 := ' ';
      sql := 'SELECT * FROM TPrice WHERE Type=1 AND nam LIKE ''' + s1 + ''''; //��ļ۸��
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      if qry2.RecordCount = 0 then
      begin
        ShowMessage('���������ļ۸�~');
        PbHide();
        Exit;
      end
      else
      begin
        if StrToBool(FieldStr( qry2 , 'chk' ) ) then
          i4 := FieldDob( qry2 , 'prc' )
        else
          i4 := 0; //���������㣬����Ϊ0
      end;

      if s3 = '�Ű�' then
      begin

        i6 := (BodWidth + fb1) * (BodHeight + fb1) * BodNum / 1000000; //���
      end
      else if s3 = '����' then
      begin
        i6 := BodWidth * BodHeight * BodNum / 1000000; //���
      end
      else if ((s3 = '�װ�') AND b1) OR (((s3 = '����') OR (s3 = 'ǰ����')) AND b1) then
      begin
        i6 := (BodWidth + fb2) * (BodHeight + fb2) * BodNum / 1000000;
        i4 := 0;
      end
      else
      begin

        i6 := (BodWidth + fb2) * (BodHeight + fb2) * BodNum / 1000000;
      end;

      i5 := i6 * i4; //�۸�
      s6 := VarToStr(BodWidth) + '*' + VarToStr(BodHeight);


      
      strCol[1] := '���';
      strCol[2] := '�������'; 
      strCol[3] := '����';     
      strCol[4] := '���';     
      strCol[5] := '����';     
      strCol[6] := '����';     
      strCol[7] := 'ͳ��';     
      strCol[8] := '����';     
      strCol[9] := '�۸�';     
      strCol[10] := 'c_id';    
      strCol[11] := '��ע';
      strCol[12] := 'ListID';

      strVal[1] := VarToStr(n);
      strVal[2] := '''' + s3 + '''';
      strVal[3] := '''' + s5 + '''';
      strVal[4] := '''' + s6 + '''';
      strVal[5] := VarToStr(BodNum);
      strVal[6] := '''' + s2 + '''';
      strVal[7] := VarToStr(i6);
      strVal[8] := VarToStr(i4);
      strVal[9] := VarToStr(i5);
      strVal[10] := '''' + strCabID + '''';
      strVal[11] := '''' + s1 + '''';
      strVal[12] := '''' + strListID + '''' ;

      sql := 'INSERT into prclist1(' + strCol[1];
      for k := 2 to 12 do
      begin
        sql := sql + ',' + strCol[k];
      end;
      sql := sql + ') VALUES(' + strVal[1];
      for k := 2 to 12 do
      begin
        sql := sql + ',' + strVal[k];
      end;

      sql := sql + ')';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.ExecSQL;

      qry1.Next;
      n := n + 1;
      
    end;

    //_______________ͳ�ƹ��Ӽ۸�___________________
    n := 1;
    sql := 'SELECT * FROM TCab WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    if qry1.RecordCount = 0 then
    begin
      ShowMessage('�뵼��������');
      PbHide();
      Exit;
    end;
    

    for j := 1 to qry1.RecordCount do
    begin
      s1 := FieldStr( qry1 , 'CabID' ) ;
      sql := 'SELECT * FROM prclist1 WHERE C_ID LIKE ''' + s1 + ''' AND ListID=''' + strListID + '''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      //s3 := VarToStr(FieldStr( qry2 , '����' ) );
      s3 := VarToStr(FieldStr( qry1 , 'Nam' ) );
      BodWidth := 0; BodHeight := 0; BodNum := 0; i4 := 0;
      i5 := 0; i6 := 0; i7 := 0; i8 := 0;
      for i := 1 to qry2.RecordCount do
      begin
        s2 := FieldStr( qry2 , '�������' ) ;
        strCabID := FieldStr( qry2 , '��ע' ) ;
                //ͳ�ư�ļ۸�����ϼ�
        if s2 = '�Ű�' then
        begin
          BodWidth := BodWidth + FieldDob( qry2 , 'ͳ��' ) ;
          i4 := i4 + FieldDob( qry2 , '�۸�' ) ;
        end
        else if s2 = '����' then
        begin
          BodHeight := BodHeight + FieldDob( qry2 , 'ͳ��' ) ;
          i5 := i5 + FieldDob( qry2 , '�۸�' ) ;
        end
        else if (Pos('���', s2) > 0) OR (Pos('����', s2) > 0) then
        begin
          BodNum := BodNum + FieldDob( qry2 , 'ͳ��' ) ;
          i6 := i6 + FieldDob( qry2 , '�۸�' ) ;
          i8 := i8 + 1;
        end
        else
        begin
          BodNum := BodNum + FieldDob( qry2 , 'ͳ��' ) ;
          i6 := i6 + FieldDob( qry2 , '�۸�' ) ;
        end;
        qry2.Next;

        
      end;
      if i8 > 0 then
        s6 := '�и�'
      else
        s6 := '�޸�';
      s5 := FieldStr( qry1 , '�ߴ�' ) ;
      i7 := FieldDob( qry1 , 'n' ) ; //����


      strCol[1] := '���';
      strCol[2] := '����';      
      strCol[3] := '���';      
      strCol[4] := '����';      
      strCol[5] := '����';      
      strCol[6] := '����';      
      strCol[7] := '�������';  
      strCol[8] := '�������';  
      strCol[9] := '�Ű����';  
      strCol[10] := '����1';    
      strCol[11] := '����1';    
      strCol[12] := '�Ű�1';    
      strCol[13] := '�۸�';     
      strCol[14] := '�Ű�۸�'; 
      strCol[15] := '�ϼ�';
      strCol[16] := 'ListID';

      strVal[1] := VarToStr(n);
      strVal[2] := '''' + s3 + '''';
      strVal[3] := '''' + s5 + '''';
      strVal[4] := VarToStr(i7);
      strVal[5] := ''' ''';
      strVal[6] := '''' + s6 + '''';
      strVal[7] := VarToStr(RoundTo(BodNum, -3));
      strVal[8] := VarToStr(RoundTo(BodHeight, -3));
      strVal[9] := VarToStr(RoundTo(BodWidth, -3));
      strVal[10] := VarToStr(BodNum);
      strVal[11] := VarToStr(BodHeight);
      strVal[12] := VarToStr(BodWidth);
      strVal[13] := VarToStr(RoundTo((i5 + i6), -2));
      strVal[14] := VarToStr(RoundTo(i4, -2));
      strVal[15] := VarToStr(RoundTo((i4 + i5 + i6), -2));
      strVal[16] := '''' + strListID + '''' ;
             
      sql := 'INSERT into prclist2(' + strCol[1];
      for k := 2 to 16 do
      begin
        sql := sql + ',' + strCol[k];
      end;
      sql := sql + ') VALUES(' + strVal[1];
      for k := 2 to 16 do
      begin
        sql := sql + ',' + strVal[k];
      end;
      sql := sql + ')';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.ExecSQL;

      qry1.Next;
      n := n + 1;

      
    end;

    //_______________ͳ�ư�����___________________
    sql := 'SELECT sum(����1) AS ����,sum(����1) AS ����,'
      + 'sum(�Ű�1) AS �Ű� FROM prclist2 WHERE ListID=''' + strListID + '''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    
    BodWidth := FieldDob( qry2 , '����' ) ;
    BodHeight := FieldDob( qry2 , '����' ) ;
    BodNum := FieldDob( qry2 , '�Ű�' ) ;
    sql1 := 'DELETE FROM ���ͳ�� WHERE ListID=''' + strListID + '''' ; 
    qry2.SQL.Clear;
    qry2.SQL.Add(sql1);
    qry2.ExecSQL;
    
    strCol[1] := '�������'; 
    strCol[2] := '�������'; 
    strCol[3] := '�Ű����';
    strCol[4] := 'ListID';

    strVal[1] := VarToStr(BodWidth);
    strVal[2] := VarToStr(BodHeight);
    strVal[3] := VarToStr(BodNum);
    strVal[4] := strListID ;

    sql := 'INSERT into ���ͳ��('
    + strCol[1] + ','
    + strCol[2] + ','
    + strCol[3] + ','
    + strCol[4]
    + ') VALUES('
    + strVal[1] + ','
    + strVal[2] + ','
    + strVal[3] + ','''
    + strVal[4] + ''')';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.ExecSQL;

    
    }
    //_______________�������۸�___________________
    sql := 'SELECT * FROM THDWare WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    for i := 1 to qry1.RecordCount do
    begin
      s1 := FieldStr( qry1 , 'nam' ) ;
      BodWidth := FieldDob( qry1 , '����' ) ;
      BodNum := FieldDob( qry1 , 'n' ) ;
      sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''' + s1 + ''''; //���۸�
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;

      if qry2.RecordCount = 0 then
      begin
        ShowMessage('�����������TBod�ļ۸�');
        Exit;
      end
      else
      begin
        if StrToBool(FieldStr( qry2 , 'chk' ) ) then
          i4 := FieldDob( qry2 , 'prc' )
        else
          i4 := 0; //����������
      end;
      i6 := BodWidth * BodNum; //����
      i5 := i6 * i4; //�۸�

      strCol[1] := '���';
      strCol[2] := '����'; 
      strCol[3] := '���'; 
      strCol[4] := '����'; 
      strCol[5] := '����'; 
      strCol[6] := 'ͳ��'; 
      strCol[7] := '����'; 
      strCol[8] := '�۸�'; 
      strCol[9] := '��ע';
      strCol[10] := 'ListID';

      strVal[1] := VarToStr(n);
      strVal[2] := '''' + s1 + '''';
      strVal[3] := VarToStr(BodWidth);
      strVal[4] := VarToStr(BodNum);
      strVal[5] := ''' ''';
      strVal[6] := VarToStr(i6);
      strVal[7] := VarToStr(i4);
      strVal[8] := VarToStr(i5);
      strVal[9] := ''' ''';
      strVal[10] := '''' + strListID + '''' ;

      sql := 'INSERT into prclist3(' + strCol[1];
      for k := 2 to 10 do
      begin
        sql := sql + ',' + strCol[k];
      end;
      sql := sql + ') VALUES(' + strVal[1];
      for k := 2 to 10 do
      begin
        sql := sql + ',' + strVal[k];
      end;
      sql := sql + ')';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.ExecSQL;

      qry1.Next;

      
    end;

    //_______________ͳ�����۸�___________________
    sql := 'SELECT distinct(����),sum(���) AS ���1,sum(����) AS ����1,'
      + 'sum(ͳ��) AS ͳ��1,max(����) AS ����1,sum(�۸�) AS �۸�1 '
      + 'FROM prclist3 WHERE ���� <> 0 AND ListID='''+ strListID +''' group by ���� ';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    //dbgMsg('HDWareSum');
    for i := 1 to qry2.RecordCount do
    begin
      s1 := FieldStr( qry2 , '����' ) ;
      BodWidth := FieldDob( qry2 , '���1' ) ;
      BodNum := FieldDob( qry2 , '����1' ) ;
      i4 := FieldDob( qry2 , '����1' ) ;
      i6 := FieldDob( qry2 , 'ͳ��1' ) ; //����
      i5 := FieldDob( qry2 , '�۸�1' ) ; //�۸�

      if i4 <> 0 then
      begin
        strCol[1] := '���'; 
        strCol[2] := '����'; 
        strCol[3] := '���'; 
        strCol[4] := '����'; 
        strCol[5] := '����'; 
        strCol[6] := 'ͳ��'; 
        strCol[7] := '����'; 
        strCol[8] := '�۸�'; 
        strCol[9] := '��ע';
        strCol[10] := 'ListID' ;

        strVal[1] := VarToStr(n);
        strVal[2] := '''' + s1 + '''';
        strVal[3] := ''' ''';
        strVal[4] := VarToStr(i6);
        strVal[5] := ''' ''';
        strVal[6] := VarToStr(i6);
        strVal[7] := VarToStr(i4);
        strVal[8] := VarToStr(i5);
        strVal[9] := ''' ''';
        strVal[10] := '''' + strListID + '''' ;

        sql := 'INSERT into HDWareSum(' + strCol[1];
        for k := 2 to 10 do
        begin
          sql := sql + ',' + strCol[k];
        end;
        sql := sql + ') VALUES(' + strVal[1];
        for k := 2 to 10 do
        begin
          sql := sql + ',' + strVal[k];
        end;
        sql := sql + ')';
        qry3.SQL.Clear;
        qry3.SQL.Add(sql);
        qry3.ExecSQL;
        //dbgMsg(VarToStr(n));
        n := n + 1;

      end;
      qry2.Next;

      
    end;

    

    //_______________�������ּ۸�___________________
    sql := 'SELECT * FROM TOption WHERE ���� LIKE ''��������'' AND v3=1 ';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    BodWidth := qry2.RecordCount;
    
    //dbgMsg('la shou 1');
    sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''����'' AND chk=''True''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    BodHeight := qry2.RecordCount;
    
    //dbgMsg('la shou 2');
    sql := 'SELECT * FROM HDWareSum WHERE ���� LIKE ''����'' AND ListID=''' + strListID + '''';
    qry3.SQL.Clear;
    qry3.SQL.Add(sql);
    qry3.Open;
    BodNum := qry3.RecordCount;
    
    //dbgMsg('la shou 3');

    if (BodWidth > 0) AND (BodHeight > 0) AND (BodNum > 0) then
    begin
      sql := 'SELECT * FROM TOption WHERE ���� LIKE ''�Ű���''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      i4 := FieldDob( qry1 , 'Val' ) ;
      
      //dbgMsg('ls4');

      sql := 'SELECT sum(��� * ����) AS �ܿ�,sum(����) AS ����1 FROM TBod '
        + 'WHERE BodName LIKE ''�Ű�'' AND ListID=''' + strListID + '''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      BodWidth := FieldDob( qry1 , '�ܿ�' ) ;
      BodHeight := FieldDob( qry1 , '����1' ) ;
      

      sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''����''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      BodNum := FieldDob( qry2 , 'prc' ) ;
      

      strVal[1] := VarToStr(BodNum);
      strVal[2] := VarToStr((BodWidth + 2 * BodHeight * i4) / 1000);
      strVal[3] := VarToStr((BodWidth + 2 * BodHeight * i4) * BodNum / 1000);
      sql := 'update HDWareSum SET ����=' + strVal[1] + ',ͳ��=' + strVal[2]
        + ',�۸�=' + strVal[3] + ' WHERE ���� LIKE ''����'' AND ListID=''' + strListID + '''';
      qry3.SQL.Clear;
      qry3.SQL.Add(sql);
      qry3.ExecSQL;
    end;

    

    //_______________���͹�Ӽ�___________________
    sql := 'SELECT * FROM TCab WHERE oth LIKE ''%����%'' OR oth LIKE ''%yx%'' '
    +'AND ListID='''+ strListID +'''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    if qry1.RecordCount > 0 then
    begin
      sql := 'SELECT sum(n) AS ���� FROM TCab WHERE oth LIKE ''%����%'' OR oth LIKE ''%yx%''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      BodWidth := FieldDob( qry1 , '����' ) ;
    end
    else
      BodWidth := 0;

    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''���͹�''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    BodHeight := FieldDob( qry1 , 'prc' ) ;
    

    sql := 'SELECT TOP 1 * FROM prclist5 WHERE ���� LIKE ''���͹�'' AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    qry1.Edit;
    qry1.FieldValues[ '����' ]  := BodWidth;
    qry1.FieldValues[ '����' ]  := BodHeight;
    qry1.FieldValues[ '�۸�' ]  := BodWidth * BodHeight;
    qry1.Post;

    

    //_______________ˮ�۹�1�Ӽ�___________________
    sql := 'SELECT * FROM TCab WHERE '
      + '(oth LIKE ''%ˮ��%'' OR oth LIKE ''%sc%'') AND w<=900 '
      + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    if qry1.RecordCount > 0 then
    begin
      sql := 'SELECT sum(n) AS ���� FROM TCab WHERE '
        + '(oth LIKE ''%ˮ��%'' OR oth LIKE ''%sc%'') AND w<=900 '
        + 'AND ListID=''' + strListID + '''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      
      BodWidth := FieldDob( qry1 , '����' ) ;
    end
    else
      BodWidth := 0;

    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''ˮ�۹�1''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    BodHeight := FieldDob( qry1 , 'prc' ) ;

    sql := 'SELECT TOP 1 * FROM prclist5 WHERE ���� LIKE ''ˮ�۹�1'' '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    qry1.Edit;
    qry1.FieldValues[ '����' ]  := BodWidth;
    qry1.FieldValues[ '����' ]  := BodHeight;
    qry1.FieldValues[ '�۸�' ]  := BodWidth * BodHeight;
    qry1.FieldValues[ 'ListID' ] := strListID;
    qry1.Post;
    

    //_______________ˮ�۹�2�Ӽ�___________________

    sql := 'SELECT * FROM TCab WHERE '
      + '(oth LIKE ''%ˮ��%'' OR oth LIKE ''%sc%'') AND w>900 '
      + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    if qry1.RecordCount > 0 then
    begin
      sql := 'SELECT sum(n) AS ���� FROM TCab WHERE '
        + '(oth LIKE ''%ˮ��%'' OR oth LIKE ''%sc%'') AND w>900 '
        + 'AND ListID=''' + strListID + '''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      BodWidth := FieldDob( qry1 , '����' ) ;
    end
    else
      BodWidth := 0;

    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''ˮ�۹�2''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    BodHeight := FieldDob( qry1 , 'prc' ) ;
    

    sql := 'SELECT TOP 1 * FROM prclist5 WHERE ���� LIKE ''ˮ�۹�2'' '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    qry1.Edit;
    qry1.FieldValues[ '����' ]  := BodWidth;
    qry1.FieldValues[ '����' ]  := BodHeight;
    qry1.FieldValues[ '�۸�' ]  := BodWidth * BodHeight;
    qry1.Post;
    

    //_______________���Ͻ�����___________________
    sql := 'SELECT * FROM TBod WHERE nam3 LIKE ''���Ͻ�'' '
    + 'AND ListID='''+ strListID +'''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''���Ͻ�����'''
      + ' AND chk=''True''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    if (qry1.RecordCount > 0) AND (qry2.RecordCount > 0) then
    begin
      BodWidth := FieldDob( qry1 , '����' ) ;
      BodHeight := FieldDob( qry2 , 'prc' ) ;
      BodNum := 0;
      for i := 1 to qry1.RecordCount do
      begin

        BodNum := BodNum + BodWidth;
        qry1.Next;
      end;
      i4 := qry1.RecordCount;
      sql := 'SELECT TOP 1 * FROM HDWareSum WHERE ListID=''' + strListID + '''';
      qry3.SQL.Clear;
      qry3.SQL.Add(sql);
      qry3.Open;
      qry3.Edit;
      qry3.Append;
      qry3.FieldValues[ '���' ]  := n;
      qry3.FieldValues[ '����' ]  := '���Ͻ�����';
      qry3.FieldValues[ '����' ]  := i4;
      qry3.FieldValues[ 'ͳ��' ]  := BodNum / 1000;
      qry3.FieldValues[ '����' ]  := BodHeight;
      qry3.FieldValues[ '�۸�' ]  := BodNum * BodHeight / 1000;
      qry3.FieldValues[ '���' ]  := ' ';
      qry3.FieldValues[ '����' ]  := ' ';
      qry3.FieldValues[ '��ע' ]  := ' ';
      qry3.FieldValues[ 'ListID' ] := strListID;
      qry3.Post;
      
      n := n + 1
    end;

    

    //_______________��˿�װ����___________________
    sql := 'SELECT * FROM TBod WHERE nam3 LIKE ''��˿�װ�'' '
    + 'AND ListID='''+ strListID +'''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=2 AND nam LIKE ''������˿�װ�'''
      + ' AND chk=''True''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    
    if (qry1.RecordCount > 0) AND (qry2.RecordCount > 0) then
    begin
      BodWidth := FieldDob( qry1 , '����' ) ;
      BodHeight := FieldDob( qry1 , '���' ) ;
      i5 := FieldDob( qry2 , 'prc' ) ;
      BodNum := 0;
      for i := 1 to qry1.RecordCount do
      begin

        BodNum := BodNum + BodWidth * BodHeight;
        qry1.Next;
      end;
      i4 := qry1.RecordCount;
      sql := 'SELECT TOP 1 * FROM HDWareSum WHERE ListID=''' + strListID + '''';
      qry3.SQL.Clear;
      qry3.SQL.Add(sql);
      qry3.Open;
      qry3.Edit;
      qry3.Append;
      qry3.FieldValues[ '���' ]  := n;
      qry3.FieldValues[ '����' ]  := '������˿�װ�';
      qry3.FieldValues[ '����' ]  := i4;
      qry3.FieldValues[ 'ͳ��' ]  := RoundTo(BodNum / 1000000, -3);
      qry3.FieldValues[ '����' ]  := i5;
      qry3.FieldValues[ '�۸�' ]  := RoundTo(BodNum * i5 / 1000000, -2);
      qry3.FieldValues[ '���' ]  := ' ';
      qry3.FieldValues[ '����' ]  := ' ';
      qry3.FieldValues[ '��ע' ]  := ' ';
      qry3.FieldValues[ 'ListID' ] := strListID;
      qry3.Post;
      
    end;

    
    PbHide();
  end;

end;


end.




