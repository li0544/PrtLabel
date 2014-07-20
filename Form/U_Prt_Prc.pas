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
    //__________________________读取相对字体信息________________________________
    ReadFZFormIniFile(I_PRC);

    //表格边框宽度
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    SectionTop := 0.75; //顶端
    SectionLeft := 0.5;
    SetFont(ftT, fzTitle ); //设置字体

    PrintCenter( strTabPrc , PageWidth / 2); //标题
    NewLine;
    SetFont(ftB, fzBody + fzB );

    strSQL := 'select * from list WHERE ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;

    PrintLeft('日期:' + FormatDateTime('yy-mm-dd', Date), 0.5);
    PrintLeft('单号:' + strListID , 2.5);
    PrintLeft('地址:'  , 5);
    PrintLeft('电话:'  , 7.5);
    PrintLeft('传真:'  , 9);
    YPos := YPos + 0.05 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    YPos := YPos + 0.03 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    NewLine ;
    //YPos := YPos - fLBoottom ;
    PrintLeft('门板材质:' + strBod_Door , 0.7);
    PrintLeft('单价:' + FieldStrN( qry1 , '门板单价', PrcRound ) , 4 );
    PrintLeft('面积:' + FieldStrN( qry1 , '门板面积', AreaRound ) , 6 );
    PrintLeft('金额:' + FieldStrN( qry1 , '门板价格', PrcRound ) , 8 );
    NewLine;
    PrintLeft('柜体材质:' + strBod_Body , 0.7 );
    PrintLeft('单价:' + FieldStrN( qry1 , '柜体板单价', PrcRound ) , 4 );
    PrintLeft('面积:' + FieldStrN( qry1 , '柜体板面积', AreaRound ) , 6 );
    PrintLeft('金额:' + FieldStrN( qry1 , '柜体板价格', PrcRound ) , 8 );
    NewLine;
    PrintLeft('背板材质:' + strBod_Back , 0.7);
    PrintLeft('单价:' + FieldStrN( qry1 , '背板单价', PrcRound ) , 4 );
    PrintLeft('面积:' + FieldStrN( qry1 , '背板面积', AreaRound ) , 6 );
    PrintLeft('金额:' + FieldStrN( qry1 , '背板价格', PrcRound ) , 8 );
    NewLine;
    YPos := YPos - 0.1 ;
    
    //_______________板材价格___________________
    i1 := 1.2;
    l0 := YPos;
    c0 := XPos;
    c1 := c0 + 0.5; //编号         1.0
    c2 := c1 + 1.8; //名称         2.8
    c3 := c2 + 1.2; //规格         4.0
    c4 := c3 + 0.6; //数量         4.6
    c5 := c4 + 1.0; //有无隔板     5.6
    c6 := c5 + 1.0; //柜体面积     6.6
    c7 := c6 + 1.0; //背板面积     7.6
    c8 := c7 + 1.0; //门板面积     8.6
    c9 := c8 + 1.0; //价格         9.6
    c10 := c9 + 1.0; //门板价格     10.6

    //行高
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
    PrintXY(c0 + i1, l1 - i2, '序号');
    PrintXY(c1 + i1, l1 - i2, '名称');
    PrintXY(c2 + i1, l1 - i2, '规格');
    PrintXY(c3 + i1, l1 - i2, '数量');
    PrintXY(c4 + i1, l1 - i2, '有无隔板');
    PrintXY(c5 + i1, l1 - i2, '柜体面积');
    PrintXY(c6 + i1, l1 - i2, '背板面积');
    PrintXY(c7 + i1, l1 - i2, '门板面积');
    PrintXY(c8 + i1, l1 - i2, '柜体金额');
    PrintXY(c9 + i1, l1 - i2, '门板金额');

    strSQL := 'select * From TCab WHERE ListID=''' + strListID + ''' Order By CabIndex';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    for i := 1 to qry1.RecordCount do
    begin
      //________________________绘制横线及数据__________________________
      NewLine;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c10, l1);
      PrintXY(c0 + i1, l1 - i2, FieldStr( qry1 , 'CabIndex' ) );
      PrintXY(c1 + i1, l1 - i2, FieldStr( qry1 , 'Nam' ) );
      PrintXY(c2 + i1, l1 - i2, FieldStr( qry1 , '尺寸' ) );
      PrintXY(c3 + i1, l1 - i2, FieldStr( qry1 , 'N' ) );
      PrintXY(c4 + i1, l1 - i2, FieldStr( qry1 , '隔板' ) );
      PrintXY(c5 + i1, l1 - i2, FieldStr( qry1 , '柜体板面积' ) );
      PrintXY(c6 + i1, l1 - i2, FieldStr( qry1 , '背板面积' ) );
      PrintXY(c7 + i1, l1 - i2, FieldStr( qry1 , '门板面积' ) );
      PrintXY(c8 + i1, l1 - i2, FieldStr( qry1 , '柜体价格' ) );
      PrintXY(c9 + i1, l1 - i2, FieldStr( qry1 , '门板价格' ) );
      qry1.Next;
      if YPos > 7 then
      begin
        //__________________________绘制竖线__________________________
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

        NewPage; //分页，新建页

        YPos := 0.75;
        l0 := YPos;
        MoveTo(c0, l0); LineTo(c10, l0);
        NewLine;
        l1 := YPos;
        MoveTo(c0, l1); LineTo(c10, l1);
        PrintXY(c0 + i1, l1 - i2, '序号');
        PrintXY(c1 + i1, l1 - i2, '名称');
        PrintXY(c2 + i1, l1 - i2, '规格');
        PrintXY(c3 + i1, l1 - i2, '数量');
        PrintXY(c4 + i1, l1 - i2, '有无隔板');
        PrintXY(c5 + i1, l1 - i2, '柜体面积');
        PrintXY(c6 + i1, l1 - i2, '背板面积');
        PrintXY(c7 + i1, l1 - i2, '门板面积');
        PrintXY(c8 + i1, l1 - i2, '柜体金额');
        PrintXY(c9 + i1, l1 - i2, '门板金额');

        //PrintColumns(Sender);
      end;
    end;
    //__________________________绘制竖线__________________________
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

    //柜体合计金额
    NewLine;
    YPos := YPos + TabH / 4 ;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;
    strSQL := 'select * from List WHERE ListID=''' + strListID + '''';
    AQrySel(qry1, strSQL);
    Print('柜体部分 合计金额： ' + FieldStrN( qry1 , '柜体合计金额', PrcRound ) + ' 元');
    SetFont(ftB, fzBody + fzB );
    Bold := False;


    //______________________________五金价格____________________________________
    strSQL := 'select * from HDWareSum WHERE ListID='''+ strListID +'''';
    AQrySel( qry1 , strSQL ) ;
    if qry1.RecordCount > 0 then
    begin
      //NewLine;
      YPos := YPos + 0.1 ;
      i1 := 1.2;
      l0 := YPos;
            //c0 := XPos;
      c1 := c0 + 0.5; //编号
      c2 := c1 + 1.8; //名称
      c3 := c2 + 1.2; //规格
      c4 := c3 + 0.6; //数量
      c5 := c4 + 1.0; //要求
      c6 := c5 + 1.0; //统计
      c7 := c6 + 1.0; //单价
      c8 := c7 + 1.0; //价格
      c9 := c8 + 2.0; //备注

      i1 := 0.1;
      i2 := fLBoottom ;

      l1 := YPos;
      MoveTo(c0, l0); LineTo(c9, l0);
      NewLine;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c9, l1);
      PrintXY(c0 + i1, l1 - i2, '序号');
      PrintXY(c1 + i1, l1 - i2, '名称');
      PrintXY(c2 + i1, l1 - i2, '规格');
      PrintXY(c3 + i1, l1 - i2, '数量');
      PrintXY(c4 + i1, l1 - i2, '要求');
      PrintXY(c5 + i1, l1 - i2, '统计');
      PrintXY(c6 + i1, l1 - i2, '单价');
      PrintXY(c7 + i1, l1 - i2, '价格');
      PrintXY(c8 + i1, l1 - i2, '备注');

//      strSQL := 'select * from HDWareSum WHERE ListID=''' + strListID + '''';
//      qry1.SQL.Clear;
//      qry1.SQL.Add(strSQL);
//      qry1.Open;
      for i := 1 to qry1.RecordCount do
      begin
        NewLine;
        l1 := l1 + TabH ;
        MoveTo(c0, l1); LineTo(c9, l1); //划横线
        PrintXY(c0 + i1, l1 - i2, FieldStr( qry1 , '序号' ) );
        PrintXY(c1 + i1, l1 - i2, FieldStr( qry1 , '名称' ) );
        PrintXY(c2 + i1, l1 - i2, FieldStr( qry1 , '规格' ) );
        PrintXY(c3 + i1, l1 - i2, FieldStr( qry1 , '数量' ) );
        PrintXY(c4 + i1, l1 - i2, FieldStr( qry1 , '工艺' ) );
        PrintXY(c5 + i1, l1 - i2, FieldStr( qry1 , '统计' ) );
        PrintXY(c6 + i1, l1 - i2, FieldStr( qry1 , '单价' ) );
        PrintXY(c7 + i1, l1 - i2, FieldStr( qry1 , '价格' ) );
        PrintXY(c8 + i1, l1 - i2, FieldStr( qry1 , '备注' ) );
        i3 := i3 + FieldDob( qry1 , '价格' ) ;
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

          NewPage; //分页，新建页

          YPos := 0.75;
          l0 := YPos;
          MoveTo(c0, l0); LineTo(c9, l0);
          NewLine;
          l1 := YPos;
          MoveTo(c0, l1); LineTo(c9, l1);
          PrintXY(c0 + i1, l1 - i2, '序号');
          PrintXY(c1 + i1, l1 - i2, '名称');
          PrintXY(c2 + i1, l1 - i2, '规格');
          PrintXY(c3 + i1, l1 - i2, '数量');
          PrintXY(c4 + i1, l1 - i2, '要求');
          PrintXY(c5 + i1, l1 - i2, '统计');
          PrintXY(c6 + i1, l1 - i2, '单价');
          PrintXY(c7 + i1, l1 - i2, '价格');
          PrintXY(c8 + i1, l1 - i2, '备注');
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

      //五金合计金额
      NewLine;
      YPos := YPos + TabH / 4 ;
      SetFont('黑体', fzMinTit);
      Bold := True;
      strSQL := 'select * from List WHERE ListID=''' + strListID + '''';
      AQrySel(qry1, strSQL);
      PrintXY(c0, YPos, '五金部分 合计金额： ' + FieldStrN( qry1 , '五金价格', PrcRound) + ' 元');
      SetFont(ftB, fzBody + fzB );
      Bold := False;

    end;

    //______________________________其他加价项目________________________________
    //默认行高
    LineHeight := TabOldLineH ;

    NewLine;
    XPos := 0.5;

    strSQL := 'select * from prclist5 where 名称 like ''异型柜'' and 数量 > 0 '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      Print('异型柜数量：');
      Print(VarToStr(FieldStr( qry1 , '数量' ) ) + ',');
      Print('加价：');
      Print(VarToStr(FieldStr( qry1 , '价格' ) ) + '元; ');
      i3 := i3 + FieldDob( qry1 , '价格' ) ;
    end;

    strSQL := 'select * from prclist5 where 名称 like ''水槽柜1'' and 数量 > 0 '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      Print('<=900水槽柜数量：');
      Print(VarToStr(FieldStr( qry1 , '数量' ) ) + ',');
      Print('加价：');
      Print(VarToStr(FieldStr( qry1 , '价格' ) ) + '元; ');
      i3 := i3 + FieldDob( qry1 , '价格' ) ;
    end;

    strSQL := 'select * from prclist5 where 名称 like ''水槽柜2'' and 数量 > 0 '
    + 'AND ListID=''' + strListID + '''';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    if qry1.RecordCount > 0 then
    begin
      Print('大于900水槽柜数量：');
      Print(VarToStr(FieldStr( qry1 , '数量' ) ) + ',');
      Print('加价：');
      Print(VarToStr(FieldStrN( qry1 , '价格', PrcRound ) ) + '元; ');
      i3 := i3 + FieldDob( qry1 , '价格' ) ;
    end;

    //_______________________________合计金额___________________________________
    NewLine;
    XPos := 0.5;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;
    
    strSQL := 'select * from List WHERE ListID=''' + strListID + '''';
    AQrySel(qry1, strSQL);
    //PrintXY(c0, YPos, '其他：' + FieldStr( qry1 , '特殊加价' ) + '元');
    PrintXY(c0, YPos, '其他：' );
    NewLine;
    PrintXY(c0, YPos, '累计金额：' + FieldStrN(qry1 , '合计金额', PrcRound ) + '元');
    PrintXY(6, YPos, '审核：');
    PrintXY(8, YPos, '财务确认：');
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
//    PrintXY(c0 + i1, l1 - i2, '序号');
//    PrintXY(c1 + i1, l1 - i2, '名称');
//    PrintXY(c2 + i1, l1 - i2, '规格');
//    PrintXY(c3 + i1, l1 - i2, '数量');
//    PrintXY(c4 + i1, l1 - i2, '有无隔板');
//    PrintXY(c5 + i1, l1 - i2, '柜体面积');
//    PrintXY(c6 + i1, l1 - i2, '背板面积');
//    PrintXY(c7 + i1, l1 - i2, '门板面积');
//    PrintXY(c8 + i1, l1 - i2, '柜体金额');
//    PrintXY(c9 + i1, l1 - i2, '门板金额');
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
//    PrintXY(c0 + i1, l1 - i2, '序号');
//    PrintXY(c1 + i1, l1 - i2, '名称');
//    PrintXY(c2 + i1, l1 - i2, '规格');
//    PrintXY(c3 + i1, l1 - i2, '数量');
//    PrintXY(c4 + i1, l1 - i2, '有无隔板');
//    PrintXY(c5 + i1, l1 - i2, '柜体面积');
//    PrintXY(c6 + i1, l1 - i2, '背板面积');
//    PrintXY(c7 + i1, l1 - i2, '门板面积');
//    PrintXY(c8 + i1, l1 - i2, '柜体金额');
//    PrintXY(c9 + i1, l1 - i2, '门板金额');
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
//    PrintXY(c0 + i1, l1 - i2, '序号');
//    PrintXY(c1 + i1, l1 - i2, '名称');
//    PrintXY(c2 + i1, l1 - i2, '规格');
//    PrintXY(c3 + i1, l1 - i2, '数量');
//    PrintXY(c4 + i1, l1 - i2, '有无隔板');
//    PrintXY(c5 + i1, l1 - i2, '柜体面积');
//    PrintXY(c6 + i1, l1 - i2, '背板面积');
//    PrintXY(c7 + i1, l1 - i2, '门板面积');
//    PrintXY(c8 + i1, l1 - i2, '柜体金额');
//    PrintXY(c9 + i1, l1 - i2, '门板金额');
//  end;
end;

end.

