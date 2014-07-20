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

    PrintLeft('日期:' + FormatDateTime('yy-mm-dd', Date), 0.5);
    PrintLeft('单号:' + strListID , 2.5);
    PrintLeft('地址:'  , 5);
    PrintLeft('电话:'  , 7.5);
    PrintLeft('传真:'  , 9);
    YPos := YPos + 0.05 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    YPos := YPos + 0.03 ;    MoveTo(0.5, YPos ); LineTo(10.6, YPos );
    NewLine ;
    if ptDoorPrc = 0 then
    begin
      PrintLeft('门板材质:' + List.CZhDoor , 0.7);
      PrintLeft('单价:' + StrN(List.PrcDoor , PrcRound) , 4 );
      PrintLeft('面积:' + StrN(List.AreaDoor , AreaRound) , 6 );
      PrintLeft('金额:' + StrN(List.SumPrcDoor , PrcRound) , 8 );
      NewLine;
    end;
    PrintLeft('柜体材质:' + List.CZhBody , 0.7 );
    PrintLeft('单价:' + StrN(List.PrcBody , PrcRound) , 4 );
    PrintLeft('面积:' + StrN(List.AreaBody , AreaRound) , 6 );
    PrintLeft('金额:' + StrN(List.SumPrcBody , PrcRound) , 8 );
    NewLine;
    PrintLeft('背板材质:' + List.CZhBack , 0.7);
    PrintLeft('单价:' + StrN(List.PrcBack , PrcRound) , 4 );
    PrintLeft('面积:' + StrN(List.AreaBack , AreaRound) , 6 );
    PrintLeft('金额:' + StrN(List.SumPrcBack , PrcRound) , 8 );

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
    if ptDoorPrc = 0 then PrintXY(c9 + i1, l1 - i2, '门板金额');

    //对橱柜进行排序
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
      //________________________绘制横线及数据__________________________
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
        if ptDoorPrc = 0 then MoveTo(c9, l0); LineTo(c9, l1);
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
        if ptDoorPrc = 0 then PrintXY(c9 + i1, l1 - i2, '门板金额');

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
    if ptDoorPrc = 0 then MoveTo(c9, l0); LineTo(c9, l1);
    MoveTo(c10, l0); LineTo(c10, l1);

    //柜体合计金额
    NewLine;
    YPos := YPos + TabH / 4 ;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;
    if ptDoorPrc = 0 then
      Print('柜体部分 合计金额： ' + StrN(List.SumPrcBod , PrcRound) + ' 元')
    else
      Print('柜体部分 合计金额： ' + StrN(List.SumPrcBod - List.SumPrcDoor , PrcRound) + ' 元');
    SetFont(ftB, fzBody + fzB );
    Bold := False;


    //______________________________五金价格____________________________________
    
    if Length(List.hdwPrc) > 0 then
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


      for i := 0 to Length(List.hdwPrc) - 1 do
      begin
        NewLine;
        l1 := l1 + TabH ;
        MoveTo(c0, l1); LineTo(c9, l1); //划横线
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
      PrintXY(c0, YPos, '五金部分 合计金额： ' + StrN(List.SumPrcHD_ , PrcRound) + ' 元');
      SetFont(ftB, fzBody + fzB );
      Bold := False;

    end;


    //______________________________其他加价项目________________________________

    if Length(List.cab) > 0 then
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
      c5 := c4 + 1.0; //加价金额
      c6 := c5 + 1.0; //合计金额
      c7 := c6 + 4.0; //备注

      i1 := 0.1;
      i2 := fLBoottom ;
      i_index := 0;
      List.SumPrcTS_ := 0;

      l1 := YPos;
      MoveTo(c0, l0); LineTo(c7, l0);
      NewLine;
      l1 := l1 + TabH ;
      MoveTo(c0, l1); LineTo(c7, l1);
      PrintXY(c0 + i1, l1 - i2, '序号');
      PrintXY(c1 + i1, l1 - i2, '名称');
      PrintXY(c2 + i1, l1 - i2, '规格');
      PrintXY(c3 + i1, l1 - i2, '数量');
      PrintXY(c4 + i1, l1 - i2, '加价金额');
      PrintXY(c5 + i1, l1 - i2, '合计金额');
      PrintXY(c6 + i1, l1 - i2, '备注');


      for i := 0 to Length(List.cab) - 1 do
      begin

        for j :=0 to Length(List.tsPrc) - 1 do
        begin
          if Pos(List.tsPrc[j].Name, List.cab[i].cabName) = 0 then Continue;
          sExp := List.tsPrc[j].GS;
          sExp := StringReplace(sExp, '宽度', Dtos(List.cab[i].cabW), [rfReplaceAll]);
          sExp := StringReplace(sExp, '高度', Dtos(List.cab[i].cabH), [rfReplaceAll]);
          if not ChkVal(sExp) then Continue;

          NewLine;
          l1 := l1 + TabH ;
          MoveTo(c0, l1); LineTo(c7, l1); //划横线
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

            NewPage; //分页，新建页

            YPos := 0.75;
            l0 := YPos;
            MoveTo(c0, l0); LineTo(c7, l0);
            NewLine;
            l1 := YPos;
            MoveTo(c0, l1); LineTo(c7, l1);
            PrintXY(c0 + i1, l1 - i2, '序号');
            PrintXY(c1 + i1, l1 - i2, '名称');
            PrintXY(c2 + i1, l1 - i2, '规格');
            PrintXY(c3 + i1, l1 - i2, '数量');
            PrintXY(c4 + i1, l1 - i2, '加价金额');
            PrintXY(c5 + i1, l1 - i2, '合计金额');
            PrintXY(c6 + i1, l1 - i2, '备注');
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

      //特殊加价合计金额
      NewLine;
      YPos := YPos + TabH / 4 ;
      SetFont('黑体', fzMinTit);
      Bold := True;
      PrintXY(c0, YPos, '特殊加价 合计金额： ' + StrN(List.SumPrcTS_ , PrcRound) + ' 元');
      SetFont(ftB, fzBody + fzB );
      Bold := False;

    end;
    {
    //默认行高
    LineHeight := TabOldLineH ;

    NewLine;
    XPos := 0.5;

    strSQL := 'SELECT * FROM prclist5 WHERE 名称 LIKE ''异型柜'' AND 数量 > 0 '
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

    strSQL := 'SELECT * FROM prclist5 WHERE 名称 LIKE ''水槽柜1'' AND 数量 > 0 '
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

    strSQL := 'SELECT * FROM prclist5 WHERE 名称 LIKE ''水槽柜2'' AND 数量 > 0 '
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
    }
    //_______________________________合计金额___________________________________
    NewLine;
    XPos := 0.5;
    SetFont(ftM, fzMinTit + fzM);
    Bold := True;    PrintXY(c0, YPos, '其他：' );
    NewLine;
    F_List_PrcAdd.btnRef.Click;
    PrintXY(c0, YPos, List.strPrcOth);
    NewLine;

    if ptDoorPrc = 0 then
      PrintXY(c0, YPos, '累计金额：' +  StrN(List.SumPrcBod + List.SumPrcHD_ + List.SumPrcTS_  + List.NumPrcOth, PrcRound) + '元')
    else
      PrintXY(c0, YPos, '累计金额：' +  StrN(List.SumPrcBod + List.SumPrcHD_ + List.SumPrcTS_ - List.SumPrcDoor + List.NumPrcOth, PrcRound) + '元');
    PrintXY(6, YPos, '审核：');
    PrintXY(8, YPos, '财务确认：');
    SetFont(ftB, fzBody + fzB );
    Bold := False;

    NewLine;
    PrintXY(c0, YPos, '银行卡号1: ' + F_Prt_Opt.tboxBankID1.Text + '    '
      + '银行卡号2: ' + F_Prt_Opt.tboxBankID2.Text + '    '
      + '银行卡号3: ' + F_Prt_Opt.tboxBankID3.Text);
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


