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
  ( '面积' , 'BodName Not IN ( ''门板'' , ''背板'' )', '柜体板面积' ) ,
  ( '面积' , 'BodName=''门板''',                     '门板面积'   ) ,
  ( '面积' , 'BodName=''背板''',                     '背板面积'   ) ,
  ( '价格' , 'BodName Not IN ( ''门板'' , ''背板'' )', '柜体板价格' ) ,
  ( '价格' , 'BodName=''门板''',                     '门板价格'   ) ,
  ( '价格' , 'BodName=''背板''',                     '背板价格'   ) ) ;

begin
  with F_Prt do
  begin
    //__________________设置不同板材封边，背板为0 ______________________
    strSQL := 'SELECT TOP 1 * FROM TOption WHERE 名称 LIKE ''门板封边''';
    AQrySel( qry1 , strSQL ) ;
    strFBDoor := FieldStr(qry1 , 'Val' );

    strSQL := 'Update TBod SET 封边=' + strFBDoor + ' WHERE BodName=''门板'' AND ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'SELECT TOP 1 * FROM TOption WHERE 名称 LIKE ''柜体封边''';
    AQrySel( qry1 , strSQL ) ;
    strFBBody := FieldStr(qry1 , 'Val' );

    strSQL := 'Update TBod SET 封边=' + strFBBody + ' WHERE BodName Not IN ( ''门板'' , ''背板'' ) AND ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //_______________________计算单个板材面积___________________________
    strSQL := 'Update TBod SET 面积 = (封边 * 2 + 长度) * (封边 * 2 + 宽度) * 数量 / 1000000 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //_______________________查询不同材质价格____________________________
    strSQL := 'SELECT Distinct 材质 AS BodCZ , BodName AS BodName FROM TBod WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    for i := 0 to qry1.RecordCount - 1 do
    begin
      strBodCZ := FieldStr( qry1 , 'BodCZ' );

      strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + strBodCZ + ''' AND chk=''True'' AND Type=1';
      AQrySel( qry2 , strSQL ) ;
      if qry2.RecordCount = 0 then strPic := '0'
      else strPic := FieldStr( qry2 , 'Prc' ) ;

      strSQL := 'Update TBod SET 单价=' + strPic + ' WHERE 材质=''' + strBodCZ + ''' AND ListID=''' + strListID + ''''  ;
      AQryCmd( qry2 , strSQL ) ;

      strBodName := FieldStr( qry1 , 'BodName' ) ;
      if ( strBodName <> '门板' ) AND ( strBodName <> '背板' ) then strBodName := '柜体板' ;
      strSQL := 'Update List SET ' + strBodName + '单价=' + strPic + ' WHERE ListID='''+ strListID +'''' ;
      AQryCmd( qry2 , strSQL ) ;

      qry1.Next;
    end;

    //________________________计算单个板材价格_________________________
    strSQL := 'Update TBod SET 价格 = 面积 * 单价 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //_______________________按橱柜统计价格和面积______________________
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
      strSQL := 'SELECT Sum(数量) AS BodNum FROM TBod WHERE CabTabID =' + strCabTabID ;
      AQrySel(qry2, strSQL);
      strBodNum := FieldStr(qry2, 'BodNum');

      strSQL := 'Update TCab SET BodNum=' + strBodNum + ' WHERE ID=' + strCabTabID ;
      AQryCmd(qry2, strSQL);
      qry1.Next;
    end;

    //_______________________按订单号统计价格和面积______________________
    for i :=0 to 5 do
    begin
        strSQL := 'SELECT Sum(' + S_TAB_COL[ i , 0 ] + ') AS Area FROM TBod WHERE ' + S_TAB_COL[ i , 1 ] + ' AND ListID=''' + strListID + '''';
        AQrySel( qry1 , strSQL ) ;
        strCabArea := FieldStr( qry1 , 'Area' ) ;

        if strCabArea = '' then strCabArea := '0' ;
        strSQL := 'Update List SET ' + S_TAB_COL[ i , 2 ] + '=' + strCabArea + ' WHERE ListID=''' + strListID + '''';
        AQryCmd( qry1 , strSQL ) ;
    end;

    //_____________________________计算柜体价格____________________________
    strSQL := 'Update TCab SET 柜体价格 = 柜体板价格 + 背板价格 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update List SET 柜体价格 = 柜体板价格 + 背板价格 , 柜体合计金额 = 柜体板价格 + 背板价格 + 门板价格 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update List SET 合计金额 = 柜体合计金额 + 五金价格 + 特殊加价 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //________________________________检查隔板______________________________
    strSQL := 'SELECT * FROM TCab WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    for i :=0 to qry1.RecordCount - 1 do
    begin
      strCabTabID := FieldStr( qry1 , 'ID' ) ;

        strSQL := 'SELECT * FROM TBod WHERE BodName In ( ''隔板'' , ''搁板'' ) AND CabTabID =' + strCabTabID ;
        if AQrySel( qry2 , strSQL ) > 0 then
          strSQL := 'Update TCab SET 隔板=''有隔'' WHERE ID=' + strCabTabID
        else
          strSQL := 'Update TCab SET 隔板=''无隔'' WHERE ID=' + strCabTabID ;
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

    //_______________________________设置五金单价_______________________________
    strSQL := 'SELECT Distinct( Nam ) AS HDName FROM THDWare WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    for i := 0 to qry1.RecordCount - 1 do
    begin
      strHDName := FieldStr( qry1 , 'HDName' ) ;
      strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + strHDName + ''' AND chk=''True'' AND Type=2' ;
      AQrySel( qry2 , strSQL ) ;
      if qry2.RecordCount = 0 then strPrc := '0'
      else strPrc := FieldStr( qry2 , 'Prc' ) ;

      strSQL := 'Update THDWare SET 单价=' + strPrc + ' WHERE Nam=''' + strHDName + ''' AND ListID=''' + strListID + '''' ;
      AQryCmd( qry2 , strSQL ) ;
      
      qry1.Next;
    end;

    //_______________________________计算五金价格_______________________________
    strSQL := 'Update THDWare SET 统计 = 数量 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update THDWare SET 价格 = 单价 * 统计 WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    //____________________________按名称统计五金价格____________________________
    strSQL := 'DELETE FROM HDWareSum WHERE ListID=''' + strListID + '''';
    AQryCmd( qry1 , strSQL );

    strSQL := 'SELECT DISTINCTROW nam , ListID , Sum(数量) AS Num1, First(单价) AS Prc1, Sum(价格) AS SumPrc '
    + 'FROM THDWare WHERE ListID=''' + strListID + ''' GROUP BY nam, ListID;' ;
    AQrySel( qry1 , strSQL ) ;
    for i := 0 to qry1.RecordCount - 1 do
    begin
      strName := FieldStr( qry1 , 'nam' ) ;
      strNum := FieldStr( qry1 , 'Num1' ) ;
      strPrc := FieldStr( qry1 , 'Prc1' ) ;
      strSumPrc := FieldStr( qry1 , 'SumPrc' ) ;
      strSQL := 'INSERT Into HDWareSum (序号, 名称, 数量, 统计, 单价, 价格, ListID) VALUES('
      + IntToStr( i + 1 ) + ', ''' + strName + ''', ' + strNum + ', ' + strNum + ', ' + strPrc + ', '
      + strSumPrc + ' , ''' + strListID + ''' ) ' ;
      AQryCmd( qry2 , strSQL ) ;

      qry1.Next ;
    end;

    //_______________________________更新订单价格_______________________________
    strSQL := 'SELECT  Sum(价格) AS SumPrc FROM THDWare WHERE ListID=''' + strListID + '''' ;
    AQrySel( qry1 , strSQL ) ;
    strSumPrc := FieldStr( qry1 , 'SumPrc' ) ;

    strSQL := 'Update List SET 五金价格=' + strSumPrc + ' WHERE ListID=''' + strListID + '''' ;
    AQryCmd( qry1 , strSQL ) ;

    strSQL := 'Update List SET 合计金额 = 柜体板价格 + 背板价格 + 门板价格 + 五金价格 + 特殊加价 WHERE ListID=''' + strListID + '''' ;
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
  //统计价格
  SetLength(strCol,20);
  SetLength(strVal,20);

  with F_Prt do
  begin

    {
    //_______________统计板材价格___________________
    sql := 'SELECT * FROM TBod WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    if qry1.RecordCount = 0 then
    begin
      ShowMessage('请先导入板材及五金数据');
      Exit;
    end;
    n := 1;
    for i := 1 to qry1.RecordCount do
    begin
      s1 := FieldStr( qry1 , '材质' ) ;
      s2 := FieldStr( qry1 , '括号' ) ;
      s3 := FieldStr( qry1 , 'BodName' ) ; //板材名称
      strCabID := FieldStr( qry1 , 'ID' ) ;   //柜体编号
      s5 := FieldStr( qry1 , '用途' ) ; //柜体名称
      b1 := FieldBoo( qry1 , '五金' ) ;
      BodWidth := FieldDob( qry1 , '长度' ) ;
      BodHeight := FieldDob( qry1 , '宽度' ) ;
      BodNum := FieldDob( qry1 , '数量' ) ;
      //门板封边
      sql := 'SELECT TOP 1 * FROM TOption WHERE 名称 LIKE ''门板封边''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      fb1 := FieldDob( qry2 , 'Val' ) ;
      fb1 := fb1 * 2;
      //柜体封边
      sql := 'SELECT * FROM TOption WHERE 名称 LIKE ''柜体封边''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      fb2 := FieldDob( qry2 , 'Val' ) ;
      fb2 := fb2 * 2;

      if s2 = '' then s2 := ' ';
      sql := 'SELECT * FROM TPrice WHERE Type=1 AND nam LIKE ''' + s1 + ''''; //板材价格库
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      if qry2.RecordCount = 0 then
      begin
        ShowMessage('请先输入板材价格~');
        PbHide();
        Exit;
      end
      else
      begin
        if StrToBool(FieldStr( qry2 , 'chk' ) ) then
          i4 := FieldDob( qry2 , 'prc' )
        else
          i4 := 0; //不参与运算，单价为0
      end;

      if s3 = '门板' then
      begin

        i6 := (BodWidth + fb1) * (BodHeight + fb1) * BodNum / 1000000; //面积
      end
      else if s3 = '背板' then
      begin
        i6 := BodWidth * BodHeight * BodNum / 1000000; //面积
      end
      else if ((s3 = '底板') AND b1) OR (((s3 = '拉条') OR (s3 = '前拉条')) AND b1) then
      begin
        i6 := (BodWidth + fb2) * (BodHeight + fb2) * BodNum / 1000000;
        i4 := 0;
      end
      else
      begin

        i6 := (BodWidth + fb2) * (BodHeight + fb2) * BodNum / 1000000;
      end;

      i5 := i6 * i4; //价格
      s6 := VarToStr(BodWidth) + '*' + VarToStr(BodHeight);


      
      strCol[1] := '序号';
      strCol[2] := '板材名称'; 
      strCol[3] := '名称';     
      strCol[4] := '规格';     
      strCol[5] := '数量';     
      strCol[6] := '工艺';     
      strCol[7] := '统计';     
      strCol[8] := '单价';     
      strCol[9] := '价格';     
      strCol[10] := 'c_id';    
      strCol[11] := '备注';
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

    //_______________统计柜子价格___________________
    n := 1;
    sql := 'SELECT * FROM TCab WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    if qry1.RecordCount = 0 then
    begin
      ShowMessage('请导入板材数据');
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
      //s3 := VarToStr(FieldStr( qry2 , '名称' ) );
      s3 := VarToStr(FieldStr( qry1 , 'Nam' ) );
      BodWidth := 0; BodHeight := 0; BodNum := 0; i4 := 0;
      i5 := 0; i6 := 0; i7 := 0; i8 := 0;
      for i := 1 to qry2.RecordCount do
      begin
        s2 := FieldStr( qry2 , '板材名称' ) ;
        strCabID := FieldStr( qry2 , '备注' ) ;
                //统计板材价格及面积合计
        if s2 = '门板' then
        begin
          BodWidth := BodWidth + FieldDob( qry2 , '统计' ) ;
          i4 := i4 + FieldDob( qry2 , '价格' ) ;
        end
        else if s2 = '背板' then
        begin
          BodHeight := BodHeight + FieldDob( qry2 , '统计' ) ;
          i5 := i5 + FieldDob( qry2 , '价格' ) ;
        end
        else if (Pos('搁板', s2) > 0) OR (Pos('隔板', s2) > 0) then
        begin
          BodNum := BodNum + FieldDob( qry2 , '统计' ) ;
          i6 := i6 + FieldDob( qry2 , '价格' ) ;
          i8 := i8 + 1;
        end
        else
        begin
          BodNum := BodNum + FieldDob( qry2 , '统计' ) ;
          i6 := i6 + FieldDob( qry2 , '价格' ) ;
        end;
        qry2.Next;

        
      end;
      if i8 > 0 then
        s6 := '有隔'
      else
        s6 := '无隔';
      s5 := FieldStr( qry1 , '尺寸' ) ;
      i7 := FieldDob( qry1 , 'n' ) ; //数量


      strCol[1] := '序号';
      strCol[2] := '名称';      
      strCol[3] := '规格';      
      strCol[4] := '数量';      
      strCol[5] := '工艺';      
      strCol[6] := '隔板';      
      strCol[7] := '柜体面积';  
      strCol[8] := '背板面积';  
      strCol[9] := '门板面积';  
      strCol[10] := '柜体1';    
      strCol[11] := '背板1';    
      strCol[12] := '门板1';    
      strCol[13] := '价格';     
      strCol[14] := '门板价格'; 
      strCol[15] := '合计';
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

    //_______________统计板材面积___________________
    sql := 'SELECT sum(柜体1) AS 柜体,sum(背板1) AS 背板,'
      + 'sum(门板1) AS 门板 FROM prclist2 WHERE ListID=''' + strListID + '''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    
    BodWidth := FieldDob( qry2 , '柜体' ) ;
    BodHeight := FieldDob( qry2 , '背板' ) ;
    BodNum := FieldDob( qry2 , '门板' ) ;
    sql1 := 'DELETE FROM 面积统计 WHERE ListID=''' + strListID + '''' ; 
    qry2.SQL.Clear;
    qry2.SQL.Add(sql1);
    qry2.ExecSQL;
    
    strCol[1] := '柜体面积'; 
    strCol[2] := '背板面积'; 
    strCol[3] := '门板面积';
    strCol[4] := 'ListID';

    strVal[1] := VarToStr(BodWidth);
    strVal[2] := VarToStr(BodHeight);
    strVal[3] := VarToStr(BodNum);
    strVal[4] := strListID ;

    sql := 'INSERT into 面积统计('
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
    //_______________计算五金价格___________________
    sql := 'SELECT * FROM THDWare WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    for i := 1 to qry1.RecordCount do
    begin
      s1 := FieldStr( qry1 , 'nam' ) ;
      BodWidth := FieldDob( qry1 , '数量' ) ;
      BodNum := FieldDob( qry1 , 'n' ) ;
      sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''' + s1 + ''''; //五金价格
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;

      if qry2.RecordCount = 0 then
      begin
        ShowMessage('请先输入五金TBod的价格');
        Exit;
      end
      else
      begin
        if StrToBool(FieldStr( qry2 , 'chk' ) ) then
          i4 := FieldDob( qry2 , 'prc' )
        else
          i4 := 0; //不参与运算
      end;
      i6 := BodWidth * BodNum; //数量
      i5 := i6 * i4; //价格

      strCol[1] := '序号';
      strCol[2] := '名称'; 
      strCol[3] := '规格'; 
      strCol[4] := '数量'; 
      strCol[5] := '工艺'; 
      strCol[6] := '统计'; 
      strCol[7] := '单价'; 
      strCol[8] := '价格'; 
      strCol[9] := '备注';
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

    //_______________统计五金价格___________________
    sql := 'SELECT distinct(名称),sum(规格) AS 规格1,sum(数量) AS 数量1,'
      + 'sum(统计) AS 统计1,max(单价) AS 单价1,sum(价格) AS 价格1 '
      + 'FROM prclist3 WHERE 单价 <> 0 AND ListID='''+ strListID +''' group by 名称 ';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    //dbgMsg('HDWareSum');
    for i := 1 to qry2.RecordCount do
    begin
      s1 := FieldStr( qry2 , '名称' ) ;
      BodWidth := FieldDob( qry2 , '规格1' ) ;
      BodNum := FieldDob( qry2 , '数量1' ) ;
      i4 := FieldDob( qry2 , '单价1' ) ;
      i6 := FieldDob( qry2 , '统计1' ) ; //数量
      i5 := FieldDob( qry2 , '价格1' ) ; //价格

      if i4 <> 0 then
      begin
        strCol[1] := '序号'; 
        strCol[2] := '名称'; 
        strCol[3] := '规格'; 
        strCol[4] := '数量'; 
        strCol[5] := '工艺'; 
        strCol[6] := '统计'; 
        strCol[7] := '单价'; 
        strCol[8] := '价格'; 
        strCol[9] := '备注';
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

    

    //_______________条形拉手价格___________________
    sql := 'SELECT * FROM TOption WHERE 名称 LIKE ''条形拉手'' AND v3=1 ';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    BodWidth := qry2.RecordCount;
    
    //dbgMsg('la shou 1');
    sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''拉手'' AND chk=''True''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    BodHeight := qry2.RecordCount;
    
    //dbgMsg('la shou 2');
    sql := 'SELECT * FROM HDWareSum WHERE 名称 LIKE ''拉手'' AND ListID=''' + strListID + '''';
    qry3.SQL.Clear;
    qry3.SQL.Add(sql);
    qry3.Open;
    BodNum := qry3.RecordCount;
    
    //dbgMsg('la shou 3');

    if (BodWidth > 0) AND (BodHeight > 0) AND (BodNum > 0) then
    begin
      sql := 'SELECT * FROM TOption WHERE 名称 LIKE ''门板封边''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      i4 := FieldDob( qry1 , 'Val' ) ;
      
      //dbgMsg('ls4');

      sql := 'SELECT sum(宽度 * 数量) AS 总宽,sum(数量) AS 数量1 FROM TBod '
        + 'WHERE BodName LIKE ''门板'' AND ListID=''' + strListID + '''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      BodWidth := FieldDob( qry1 , '总宽' ) ;
      BodHeight := FieldDob( qry1 , '数量1' ) ;
      

      sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''拉手''';
      qry2.SQL.Clear;
      qry2.SQL.Add(sql);
      qry2.Open;
      BodNum := FieldDob( qry2 , 'prc' ) ;
      

      strVal[1] := VarToStr(BodNum);
      strVal[2] := VarToStr((BodWidth + 2 * BodHeight * i4) / 1000);
      strVal[3] := VarToStr((BodWidth + 2 * BodHeight * i4) * BodNum / 1000);
      sql := 'update HDWareSum SET 单价=' + strVal[1] + ',统计=' + strVal[2]
        + ',价格=' + strVal[3] + ' WHERE 名称 LIKE ''拉手'' AND ListID=''' + strListID + '''';
      qry3.SQL.Clear;
      qry3.SQL.Add(sql);
      qry3.ExecSQL;
    end;

    

    //_______________异型柜加价___________________
    sql := 'SELECT * FROM TCab WHERE oth LIKE ''%异型%'' OR oth LIKE ''%yx%'' '
    +'AND ListID='''+ strListID +'''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    if qry1.RecordCount > 0 then
    begin
      sql := 'SELECT sum(n) AS 数量 FROM TCab WHERE oth LIKE ''%异型%'' OR oth LIKE ''%yx%''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      BodWidth := FieldDob( qry1 , '数量' ) ;
    end
    else
      BodWidth := 0;

    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''异型柜''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    BodHeight := FieldDob( qry1 , 'prc' ) ;
    

    sql := 'SELECT TOP 1 * FROM prclist5 WHERE 名称 LIKE ''异型柜'' AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    qry1.Edit;
    qry1.FieldValues[ '数量' ]  := BodWidth;
    qry1.FieldValues[ '单价' ]  := BodHeight;
    qry1.FieldValues[ '价格' ]  := BodWidth * BodHeight;
    qry1.Post;

    

    //_______________水槽柜1加价___________________
    sql := 'SELECT * FROM TCab WHERE '
      + '(oth LIKE ''%水槽%'' OR oth LIKE ''%sc%'') AND w<=900 '
      + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    if qry1.RecordCount > 0 then
    begin
      sql := 'SELECT sum(n) AS 数量 FROM TCab WHERE '
        + '(oth LIKE ''%水槽%'' OR oth LIKE ''%sc%'') AND w<=900 '
        + 'AND ListID=''' + strListID + '''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      
      BodWidth := FieldDob( qry1 , '数量' ) ;
    end
    else
      BodWidth := 0;

    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''水槽柜1''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    BodHeight := FieldDob( qry1 , 'prc' ) ;

    sql := 'SELECT TOP 1 * FROM prclist5 WHERE 名称 LIKE ''水槽柜1'' '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    qry1.Edit;
    qry1.FieldValues[ '数量' ]  := BodWidth;
    qry1.FieldValues[ '单价' ]  := BodHeight;
    qry1.FieldValues[ '价格' ]  := BodWidth * BodHeight;
    qry1.FieldValues[ 'ListID' ] := strListID;
    qry1.Post;
    

    //_______________水槽柜2加价___________________

    sql := 'SELECT * FROM TCab WHERE '
      + '(oth LIKE ''%水槽%'' OR oth LIKE ''%sc%'') AND w>900 '
      + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    if qry1.RecordCount > 0 then
    begin
      sql := 'SELECT sum(n) AS 数量 FROM TCab WHERE '
        + '(oth LIKE ''%水槽%'' OR oth LIKE ''%sc%'') AND w>900 '
        + 'AND ListID=''' + strListID + '''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      BodWidth := FieldDob( qry1 , '数量' ) ;
    end
    else
      BodWidth := 0;

    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''水槽柜2''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    BodHeight := FieldDob( qry1 , 'prc' ) ;
    

    sql := 'SELECT TOP 1 * FROM prclist5 WHERE 名称 LIKE ''水槽柜2'' '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    qry1.Edit;
    qry1.FieldValues[ '数量' ]  := BodWidth;
    qry1.FieldValues[ '单价' ]  := BodHeight;
    qry1.FieldValues[ '价格' ]  := BodWidth * BodHeight;
    qry1.Post;
    

    //_______________铝合金拉条___________________
    sql := 'SELECT * FROM TBod WHERE nam3 LIKE ''铝合金'' '
    + 'AND ListID='''+ strListID +'''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    sql := 'SELECT * FROM TPrice WHERE Type=2 AND nam LIKE ''铝合金拉条'''
      + ' AND chk=''True''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    if (qry1.RecordCount > 0) AND (qry2.RecordCount > 0) then
    begin
      BodWidth := FieldDob( qry1 , '长度' ) ;
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
      qry3.FieldValues[ '序号' ]  := n;
      qry3.FieldValues[ '名称' ]  := '铝合金拉条';
      qry3.FieldValues[ '数量' ]  := i4;
      qry3.FieldValues[ '统计' ]  := BodNum / 1000;
      qry3.FieldValues[ '单价' ]  := BodHeight;
      qry3.FieldValues[ '价格' ]  := BodNum * BodHeight / 1000;
      qry3.FieldValues[ '规格' ]  := ' ';
      qry3.FieldValues[ '工艺' ]  := ' ';
      qry3.FieldValues[ '备注' ]  := ' ';
      qry3.FieldValues[ 'ListID' ] := strListID;
      qry3.Post;
      
      n := n + 1
    end;

    

    //_______________拉丝底板序号___________________
    sql := 'SELECT * FROM TBod WHERE nam3 LIKE ''拉丝底板'' '
    + 'AND ListID='''+ strListID +'''';
    qry1.SQL.Clear;
    qry1.SQL.Add(sql);
    qry1.Open;
    
    sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=2 AND nam LIKE ''金属拉丝底板'''
      + ' AND chk=''True''';
    qry2.SQL.Clear;
    qry2.SQL.Add(sql);
    qry2.Open;
    
    if (qry1.RecordCount > 0) AND (qry2.RecordCount > 0) then
    begin
      BodWidth := FieldDob( qry1 , '长度' ) ;
      BodHeight := FieldDob( qry1 , '宽度' ) ;
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
      qry3.FieldValues[ '序号' ]  := n;
      qry3.FieldValues[ '名称' ]  := '金属拉丝底板';
      qry3.FieldValues[ '数量' ]  := i4;
      qry3.FieldValues[ '统计' ]  := RoundTo(BodNum / 1000000, -3);
      qry3.FieldValues[ '单价' ]  := i5;
      qry3.FieldValues[ '价格' ]  := RoundTo(BodNum * i5 / 1000000, -2);
      qry3.FieldValues[ '规格' ]  := ' ';
      qry3.FieldValues[ '工艺' ]  := ' ';
      qry3.FieldValues[ '备注' ]  := ' ';
      qry3.FieldValues[ 'ListID' ] := strListID;
      qry3.Post;
      
    end;

    
    PbHide();
  end;

end;


end.




