unit U_Prt_Proj2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, RpDefine, RpBase, RpSystem, StdCtrls, StrUtils, UParam,
  UPub, UADO;

type
  TF_Prt_Proj2 = class(TForm)
    btn1: TButton;
    RvSystem1: TRvSystem;
    qry1: TADOQuery;
    qry2: TADOQuery;
    qry3: TADOQuery;
    qry4: TADOQuery;
    qry5: TADOQuery;
    qry6: TADOQuery;
    qry7: TADOQuery;
    qry8: TADOQuery;
    procedure btn1Click(Sender: TObject);
    procedure RvSystem1Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_Proj2: TF_Prt_Proj2;

implementation

{$R *.dfm}

procedure sel1(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry1.SQL.Clear;
    qry1.SQL.Add(s_sql);
    qry1.Open;
  end;
end;

procedure sel2(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry2.SQL.Clear;
    qry2.SQL.Add(s_sql);
    qry2.Open;
  end;
end;

procedure sel3(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry3.SQL.Clear;
    qry3.SQL.Add(s_sql);
    qry3.Open;
  end;
end;

procedure sel4(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry4.SQL.Clear;
    qry4.SQL.Add(s_sql);
    qry4.Open;
  end;
end;

procedure sel5(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry5.SQL.Clear;
    qry5.SQL.Add(s_sql);
    qry5.Open;
  end;
end;

procedure sel6(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry6.SQL.Clear;
    qry6.SQL.Add(s_sql);
    qry6.Open;
  end;
end;

procedure sel7(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry7.SQL.Clear;
    qry7.SQL.Add(s_sql);
    qry7.Open;
  end;
end;

procedure sel8(s_sql: string);
begin
  with F_Prt_Proj2 do
  begin
    qry8.SQL.Clear;
    qry8.SQL.Add(s_sql);
    qry8.Open;
  end;
end;

procedure TF_Prt_Proj2.btn1Click(Sender: TObject);
begin
  RvSystem1.Execute;
end;

procedure TF_Prt_Proj2.RvSystem1Print(Sender: TObject);
var
  s_sql: string;
  n_mb, n_bb, n_gtb: string;
  i_max: Integer;
  i, j, k: Integer;
  s0, s1, s2, s3, s4, s5, s6, s7, s8, s9: string;
  d0, d1, d2, d3, d4, d5, d6: Double;
  i1, i2, i3: Integer;
  fb1, fb2: Double;
  l1, l2, l3, l4, l5, l6, l7, l8, l9, l0: Double;
  c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c0: Double;
  t ,l, x1, x2, x3, x4, y1, y2, y3, y4, d_t1, d_t2: Double;
  c: array[1..13] of Double;
begin

  with Sender AS TBaseReport do
  begin
    //__________________________读取相对字体信息________________________________
    ReadFZFormIniFile(I_PRO);

    //表格边框宽度
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

      { 打印表头和表尾 }

    SectionTop := 0.5; //顶端
    SectionLeft := 0.5;
    SectionRight := 11;
    SectionBottom := 8;

    //__________________打印页码、日期____________________
    SetFont(ftB, fzBody + fzB );
    PrintFooter('　第' + IntToStr(CurrentPage) + '页', pjLeft); //页码
    PrintFooter('日期: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //日期
    Home;
    
    n_mb  := IntToStr( GetBoardNum(I_BOD_DOOR) ); //门板
    n_bb  := IntToStr( GetBoardNum(I_BOD_BACK) ); //背板
    n_gtb := IntToStr( GetBoardNum(I_BOD_BODY) ); //柜体板

    SetFont(ftT, fzTitle + fzT);                  //标题字体
    PrintCenter( strTabPro , PageWidth / 2 ) ;    //标题
    SetFont(ftB, fzBody + fzB );
    Bold := True;
    NewLine;
    YPos := YPos + 0.1;
    d_t1 := 1.2;
    Print('订单编号: ');    Print(strListID);
    XPos := XPos + d_t1;
    Print('安装地址: ');    Print(strAddress);
    XPos := XPos + d_t1;
    Print('客户姓名: ');    Print(strName);
    XPos := XPos + d_t1;
    Print('联系方式: ');    Print(strPhone);
    YPos := YPos + 0.03;
    MoveTo(0.4, YPos); LineTo(11.2, YPos);
    NewLine;
    d_t1 := 0.3;
    d_t2 := 0.6;
    Print('背板材质: ');    Print(strBod_Back);   XPos := XPos + d_t1;
    Print('数量: ');        Print(n_bb);          XPos := XPos + d_t2;
    Print('柜体板材质: ');  Print(strBod_Body);   XPos := XPos + d_t1;
    Print('数量: ');        Print(n_gtb);         XPos := XPos + d_t2;
    Print('封边工艺: ');    Print(strFBGY);       XPos := XPos + d_t2;
    Print('开料员: ');
    //NewLine;

    y1 := YPos + 0.1; //y=1.2+0.05=1.25

    //_____________________打印列标题_______________________
    x1 := 1.28; //名称
    x4 := 2.2; //列距
    c1 := 0.2; //表格左边距
    c2 := c1 + 0.30; //NO
    c3 := c2 + x4; //侧板
    c4 := c3 + x4; //底顶板
    c5 := c4 + x4; //隔板
    c6 := c5 + x4; //拉条
    c7 := c6 + x4; //附加板
    c[1] := c1;
    c[2] := c[1] + 0.3; //NO
    c[3] := c[2] + x4 - 0.2; //侧板
    c[4] := c[3] + x4; //底顶板
    c[5] := c[4] + x4 - 0.4; //隔板
    c[6] := c[5] + x4 - 0.5; //拉条
    c[7] := c[6] + x4; //附加板
    c[8] := c[7] + x4 - 1.1; //背板
    c0 := c[8]; //11.0 +0.15

    l1 := y1 + fLBoottom ; //表格上边框

    t := LineHeight * TabLineH ;
    l0 := 6.00;
    l := 0.10;
    l2 := l1 + t + fLBoottom ;

    d_t1 := 0.5;
    PrintXY(c[1] + l, l1 + t, 'NO');
    PrintXY(c[2] + d_t1, l1 + t, '侧板');
    PrintXY(c[3] + d_t1, l1 + t, '底顶板');
    PrintXY(c[4] + d_t1, l1 + t, '隔板');
    PrintXY(c[5] + d_t1, l1 + t, '拉条');
    PrintXY(c[6] + d_t1, l1 + t, '附加板');
    PrintXY(c[7] + d_t1, l1 + t, '背板');
    //PrintXY(c8 + l, l1 + t, '门板');


    //________________________横线___________________________
    MoveTo(c1, l1); LineTo(c0, l1);
    MoveTo(c1, l2); LineTo(c0, l2);
    y4 := l2;

    qry1.SQL.Clear;
    qry1.SQL.Add('SELECT * FROM TCab WHERE ListID='''+ strListID +''' order by H');
    qry1.Open;

    y2 := l2;
    //t := 0.20;

    s_sql := 'SELECT 材质, 长度,宽度,括号 AS 工艺说明,sum(数量) AS 数量1 '
      + 'FROM TBod WHERE BodName LIKE ''侧板'' '
      + 'AND ListID='''+ strListID + ''' '
      +'group by 长度,宽度,括号,材质';
    s_sql := s_sql + ' order by 长度 desc,宽度 desc';
    sel1(s_sql);

    s_sql := 'SELECT 材质, 长度,宽度,括号 AS 工艺说明,sum(数量) AS 数量1 '
      + 'FROM TBod WHERE (BodName LIKE ''底顶板'' OR BodName LIKE ''顶底板'' OR BodName LIKE ''底板'' OR '
      + 'BodName LIKE ''顶板'') '
      + 'AND ListID='''+ strListID + ''' '
      + 'group by 长度,宽度,括号,材质';
    s_sql := s_sql + ' order by 长度 desc,宽度 desc';
    sel2(s_sql);

    s_sql := 'SELECT 材质, 长度,宽度,括号 AS 工艺说明,sum(数量) AS 数量1 '
      + 'FROM TBod WHERE (BodName LIKE ''隔板'' OR BodName LIKE ''搁板'') '
      + 'AND ListID='''+ strListID + ''' '
      + 'group by 长度,宽度,括号,材质';
    s_sql := s_sql + ' order by 长度 desc,宽度 desc';
    sel3(s_sql);

    s_sql := 'SELECT 材质,长度,宽度,括号 AS 工艺说明,sum(数量) AS 数量1 '
      + 'FROM TBod WHERE (BodName LIKE ''前拉条'' OR BodName LIKE ''后拉条'' OR BodName LIKE ''拉条'') '
      + 'AND ListID='''+ strListID + ''' '
      + 'group by 长度,宽度,括号,材质';
    s_sql := s_sql + ' order by 长度 desc,宽度 desc';
    sel4(s_sql);

    s_sql := 'SELECT 材质, 长度,宽度,括号 AS 工艺说明,sum(数量) AS 数量1 '
      + 'FROM TBod WHERE (BodName not LIKE ''门板'' AND BodName not LIKE ''背板'' AND BodName not LIKE ''侧板'' '
      + 'AND BodName not LIKE ''顶底板'' AND BodName not LIKE ''底顶板'' AND BodName not LIKE ''底板'' AND '
      + 'BodName not LIKE ''顶板'' AND BodName not LIKE ''隔板'' AND '
      + 'BodName not LIKE ''搁板'' AND BodName not LIKE ''拉条'' AND BodName not LIKE ''后拉条'' AND BodName '
      + 'not LIKE ''前拉条'') '
      + 'AND ListID='''+ strListID + ''' '
      + 'group by 长度,宽度,括号,材质';
    s_sql := s_sql + ' order by 长度 desc,宽度 desc';
    sel5(s_sql);

    s_sql := 'SELECT 材质, 长度,宽度,括号 AS 工艺说明,sum(数量) AS 数量1 '
      + 'FROM TBod WHERE BodName LIKE ''背板'' '
      + 'AND ListID='''+ strListID + ''' '
      + 'group by 长度,宽度,括号,材质';
    s_sql := s_sql + ' order by 长度 desc,宽度 desc';
    sel6(s_sql);

    s_sql := 'SELECT 材质, 长度,宽度,括号 AS 工艺说明,sum(数量) AS 数量1 '
      + 'FROM TBod WHERE BodName LIKE ''门板'' '
      + 'AND ListID='''+ strListID + ''' '
      + 'group by 长度,宽度,括号,材质';
    s_sql := s_sql + ' order by 长度 desc,宽度 desc';
    sel7(s_sql);

    i := 1;
    while ((not qry1.Eof) OR (not qry2.Eof) OR (not qry3.Eof) OR (not qry4.Eof)
      OR (not qry5.Eof) OR (not qry6.Eof)) do
    begin

      y1 := y2;
      l := 0.10;
      y2 := y2 + t;
      PrintXY(c1 + l, y2, IntToStr(i));

      l := 0.03;
      x1 := l + 0.4; // 长度——列宽
      x2 := x1 * 2; // 宽度
      x3 := x2 + l + 0.22; //数量——列宽

      //s6 := FieldStr( qry2, 'CabType' );

      //__________________________侧板_____________________________
      if not qry1.Eof then
      begin
        s2 := FieldStr( qry1, '长度');
        s3 := FieldStr( qry1, '宽度');
        s4 := FieldStr( qry1, '数量1');
        s5 := FieldStr( qry1, '工艺说明');
        s5 := MidStr(s5, 1, 5);
        s2 := VarToStr(StrToFloat(s2) + fb2);
        s3 := VarToStr(StrToFloat(s3) + fb2);
        PrintXY(c[2] + l, y2, s2);
        PrintXY(c[2] + x1 + l, y2, s3);
        PrintXY(c[2] + x2 + l, y2, s4);
        PrintXY(c[2] + x3 + l, y2, s5);
        qry1.Next;
      end;
      //__________________________底顶板________________________________
      if not qry2.Eof then
      begin
        s2 := FieldStr( qry2, '长度' );
        s3 := FieldStr( qry2, '宽度' );
        s4 := FieldStr( qry2, '数量1' );
        s5 := FieldStr( qry2, '工艺说明' );
        s5 := MidStr(s5, 1, 6);
        s2 := VarToStr(StrToFloat(s2) + fb2);
        s3 := VarToStr(StrToFloat(s3) + fb2);
        PrintXY(c[3] + l, y2, s2);
        PrintXY(c[3] + x1 + l, y2, s3);
        PrintXY(c[3] + x2 + l, y2, s4);
        PrintXY(c[3] + x3 + l, y2, s5);
        qry2.Next;
      end;
      //__________________________隔板_______________________________
      if not qry3.Eof then
      begin
        s2 := FieldStr( qry3 , '长度' );
        s3 := FieldStr( qry3 , '宽度' );
        s4 := FieldStr( qry3 , '数量1' );
        s5 := FieldStr( qry3 , '工艺说明' );
        s5 := MidStr(s5, 1, 4);
        s2 := VarToStr(StrToFloat(s2) + fb2);
        s3 := VarToStr(StrToFloat(s3) + fb2);
        PrintXY(c[4] + l, y2, s2);
        PrintXY(c[4] + x1 + l, y2, s3);
        PrintXY(c[4] + x2 + l, y2, s4);
        PrintXY(c[4] + x3 + l, y2, s5);
        qry3.Next;
      end;
      //__________________________拉条_______________________________
      if not qry4.Eof then
      begin
        s2 := FieldStr( qry4 , '长度' );
        s3 := FieldStr( qry4 , '宽度' );
        s4 := FieldStr( qry4 , '数量1' );
        s5 := FieldStr( qry4 , '工艺说明' );
        s5 := MidStr(s5, 1, 3);
        s2 := VarToStr(StrToFloat(s2) + fb2);
        s3 := VarToStr(StrToFloat(s3) + fb2);
        PrintXY(c[5] + l, y2, s2);
        PrintXY(c[5] + x1 + l, y2, s3);
        PrintXY(c[5] + x2 + l, y2, s4);
        PrintXY(c[5] + x3 + l, y2, s5);
        qry4.Next;
      end;
      //__________________________附加板_____________________________
      if not qry5.Eof then
      begin
        s2 := FieldStr( qry5 , '长度' );
        s3 := FieldStr( qry5 , '宽度' );
        s4 := FieldStr( qry5 , '数量1' );
        s5 := FieldStr( qry5 , '工艺说明' );
        s5 := MidStr(s5, 1, 6);
        s2 := VarToStr(StrToFloat(s2) + fb2);
        s3 := VarToStr(StrToFloat(s3) + fb2);
        PrintXY(c[6] + l, y2, s2);
        PrintXY(c[6] + x1 + l, y2, s3);
        PrintXY(c[6] + x2 + l, y2, s4);
        PrintXY(c[6] + x3 + l, y2, s5);
        qry5.Next;
      end;
      //__________________________背板_____________________________
      if not qry6.Eof then
      begin
        s2 := FieldStr( qry6 , '长度' );
        s3 := FieldStr( qry6 , '宽度' );
        s4 := FieldStr( qry6 , '数量1' );
        s5 := FieldStr( qry6 , '工艺说明' );
        s2 := VarToStr(StrToFloat(s2) + fb2);
        s3 := VarToStr(StrToFloat(s3) + fb2);
        PrintXY(c[7] + l, y2, s2);
        PrintXY(c[7] + x1 + l, y2, s3);
        PrintXY(c[7] + x2 + l, y2, s4);
        PrintXY(c[7] + x3 + l, y2, s5);
        qry6.Next;
      end;

      d0 := 0.20;
      y2 := y2 + fLBoottom ;
      MoveTo(c1, y2); LineTo(c0, y2); //换行——打印横线
      //________________________分页___________________________
      if y2 > 7.0 then
      begin
        l0 := y2;
        //MoveTo(c0, y2); LineTo(c0, y2);

        //________________________竖线___________________________

        MoveTo(c1, l1); LineTo(c1, l0);
        for i := 1 to 6 do
        begin
          MoveTo(c[i + 1], l1); LineTo(c[i + 1], l0);
          MoveTo(x1 + c[i + 1], y4); LineTo(x1 + c[i + 1], l0);
          MoveTo(x2 + c[i + 1], y4); LineTo(x2 + c[i + 1], l0);
          if i <> 6 then
            MoveTo(x3 + c[i + 1], y4); LineTo(x3 + c[i + 1], l0);
        end;
        MoveTo(c0, l1); LineTo(c0, l0);

        NewPage;
        SectionTop := 0.5; //顶端
        SectionLeft := 0.5;
        SectionRight := 11;
        SectionBottom := 8;

        //__________________打印页码、日期____________________
        SetFont(ftB, fzBody + fzB );
        PrintFooter('　第' + IntToStr(CurrentPage) + '页', pjLeft); //页码
        PrintFooter('日期: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //日期
        Home;

        SetFont(ftT, fzTitle + fzT);              //设置标题字体
        PrintCenter( strTabPro , PageWidth / 2);  //标题
        SetFont(ftB, fzBody + fzB );
        Bold := True;
        NewLine;
        YPos := YPos + 0.1;
        d_t1 := 1.2;
        Print('订单编号: ');    Print(strListID);
        XPos := XPos + d_t1;
        Print('安装地址: ');    Print(strAddress);
        XPos := XPos + d_t1;
        Print('客户姓名: ');    Print(strName);
        XPos := XPos + d_t1;
        Print('联系方式: ');    Print(strPhone);
        YPos := YPos + 0.03;
        MoveTo(0.4, YPos); LineTo(11.2, YPos);
        NewLine;
        d_t1 := 0.3;
        d_t2 := 0.6;
        Print('背板材质: ');    Print(strBod_Back);
        XPos := XPos + d_t1;
        Print('数量: ');        Print(n_bb);
        XPos := XPos + d_t2;
        Print('柜体板材质: ');  Print(strBod_Body);
        XPos := XPos + d_t1;
        Print('数量: ');        Print(n_gtb);
        XPos := XPos + d_t2;
        Print('开料员: ');
        //NewLine;

        y1 := YPos + 0.1; //y=1.2+0.05=1.25
        //t := 0.18;

        //_____________________打印列标题_______________________
        d_t1 := 0.5;
        PrintXY(c1 + l, l1 + t, 'NO');
        PrintXY(c[1] + l, l1 + t, 'NO');
        PrintXY(c[2] + d_t1, l1 + t, '侧板');
        PrintXY(c[3] + d_t1, l1 + t, '底顶板');
        PrintXY(c[4] + d_t1, l1 + t, '隔板');
        PrintXY(c[5] + d_t1, l1 + t, '拉条');
        PrintXY(c[6] + d_t1, l1 + t, '附加板');
        PrintXY(c[7] + d_t1, l1 + t, '背板');
        //PrintXY(c8 + l, l1 + t, '门板');


        //________________________横线___________________________
        MoveTo(c1, l1); LineTo(c0, l1);
        MoveTo(c1, l2); LineTo(c0, l2);
        y4 := l2;
        y2 := l2;
        //MoveTo(c1, l1); LineTo(c0, l1);
        //MoveTo(c1, l2); LineTo(c0, l2);

      end;
      i := i + 1;
    end; { for }

    //MoveTo(c11, y2); LineTo(c0, y2);

    l0 := y2;
    //________________________竖线___________________________
    MoveTo(c1, l1); LineTo(c1, l0);
    for i := 1 to 6 do
    begin
      MoveTo(c[i + 1], l1); LineTo(c[i + 1], l0);
      MoveTo(x1 + c[i + 1], y4); LineTo(x1 + c[i + 1], l0);
      MoveTo(x2 + c[i + 1], y4); LineTo(x2 + c[i + 1], l0);
      if i <> 6 then
        MoveTo(x3 + c[i + 1], y4); LineTo(x3 + c[i + 1], l0);
    end;
    MoveTo(c0, l1); LineTo(c0, l0);




  end;
end;

procedure TF_Prt_Proj2.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry2.Close;
  qry3.Close;
  qry4.Close;
  qry5.Close;
  qry6.Close;
  qry7.Close;
  qry8.Close;
  qry1.ConnectionString := getConStr();
  qry2.ConnectionString := getConStr();
  qry3.ConnectionString := getConStr();
  qry4.ConnectionString := getConStr();
  qry5.ConnectionString := getConStr();
  qry6.ConnectionString := getConStr();
  qry7.ConnectionString := getConStr();
  qry8.ConnectionString := getConStr();
end;

end.

