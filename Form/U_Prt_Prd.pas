unit U_Prt_Prd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RpDefine, RpBase, RpSystem, DB, ADODB, RpCon, UMain,
  RpConDS, RpRave, Math, GridsEh, DBGridEh, StrUtils, CodeSiteLogging,
  DBGridEhGrouping, UPub;

type
  TF_Prt_Prd = class(TForm)
    RvSystem1: TRvSystem;
    BtnPrintProduce: TButton;
    qry1: TADOQuery;
    qry2: TADOQuery;
    qry3: TADOQuery;
    ds1: TDataSource;
    procedure BtnPrintProduceClick(Sender: TObject);
    procedure RvSystem1Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure PrintColumns(var Sender: TObject);
    procedure InitData();
  public
    { Public declarations }
  end;

var
  F_Prt_Prd: TF_Prt_Prd;


  l1, l2, l3, l4, l5, l6, l7, l8, l9, l0: Double;
  c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c0: Double;
  l, x1, x2, x3, y1, y2, y3: Double;
  h: array[1..13] of Double;
  sTit: string;

  IThick_Board: Integer; //板材厚度
  IAdge_Door, IAdge_Body: Double;
  s_sql: string;
  cab_nam, cab_w: string;
  s0, s1, s2, s3, s4, s5, s6, s7, s8, s9: string;
  d0, d1, d2, d3, d4, d5, d6: Double;
  i1, i2, i3: Integer;
  b1, b2, b3, b4: Boolean;


implementation

uses U_Prt;
{$R *.dfm}

procedure TF_Prt_Prd.BtnPrintProduceClick(Sender: TObject);
begin
  try
    RvSystem1.Execute; //执行报表！
  except
    on e: Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;

procedure TF_Prt_Prd.RvSystem1Print(Sender: TObject);
var
  i, j: Integer;
  strSQL: string;
  CabTabID : string ;
  TabH : Double;
begin

  with Sender as TBaseReport do
  begin

    //表格边框宽度
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    InitData();

    PrintColumns(Sender);

    //_____________________打印表格内容______________________

    TabH := LineHeight * TabLineH ;

    //板材统计
    l2 := l2 + TabH ;
    Bold := True;
    PrintXY(c3 + l,   l2 - fLBoottom ,   IntToStr( GetBoardNum(I_BOD_C_B_) ) );  //侧板
    PrintXY(c4 + l,   l2 - fLBoottom ,   IntToStr( GetBoardNum(I_BOD_DDB_) ) );  //底顶板
    PrintXY(c5 + l,   l2 - fLBoottom ,   IntToStr( GetBoardNum(I_BOD_G_B_) ) );  //隔板
    PrintXY(c6 + l,   l2 - fLBoottom ,   IntToStr( GetBoardNum(I_BOD_L_T_) ) );  //拉条
    PrintXY(c7 + l,   l2 - fLBoottom ,   '<--');
    PrintXY(c8 + l,   l2 - fLBoottom ,   IntToStr( GetBoardNum(I_BOD_FJB_) ) );  //附加板
    PrintXY(c9 + l,   l2 - fLBoottom ,   IntToStr( GetBoardNum(I_BOD_BACK) ) );  //背板
    PrintXY(c10 + l,  l2 - fLBoottom ,   IntToStr( GetBoardNum(I_BOD_DOOR) ) );  //门板
    Bold := False;

    //MoveTo(c1, l1); LineTo(c0, l1);
    MoveTo(c1, l2); LineTo(c0, l2);

    //_____________________打印板材数据______________________
    qry1.SQL.Clear;
    qry1.SQL.Add('SELECT * From TCab WHERE ListID='''+ strListID +''' order by H');
    qry1.Open;

    y2 := l2;
    SetFont(ftB, fzBody + fzB);

    for i := 1 to qry1.RecordCount do
    begin

      s0 := qry1.FieldValues['id'];
      s5 := qry1.FieldValues['尺寸']; //橱柜尺寸
      cab_w := s5;
      cab_w := MidStr(cab_w, Pos('*', cab_w) + 1, Length(cab_w) - Pos('*', cab_w));
      cab_w := MidStr(cab_w, Pos('*', cab_w) + 1, Length(cab_w) - Pos('*', cab_w));
      //ShowMessage(cab_w);
      for j := 1 to 10 do
      begin
        h[j] := y2;
      end;
      y1 := y2;
      l := 0.10;
      PrintXY(c1 + l, y2 + TabH, IntToStr(i));

      CabTabID := VarToStr(qry1.FieldValues['ID']);
      strSQL := 'select * From TBod where CabTabID = ' + CabTabID + ' AND ListID='''+ strListID +'''';
      //CodeSite.Send(strSQL);
      qry2.SQL.Clear;
      qry2.SQL.Add(strSQL);
      qry2.Open;
      l := 0.08;
      h[10] := h[10] + TabH;

      //橱柜名称
      //cab_nam := VarToStr(qry2.FieldValues['用途']);
      cab_nam := VarToStr(qry1.FieldValues['Nam']);
      PrintXY(c2 + l, h[10], cab_nam);

      h[10] := h[10] + TabH;
      PrintXY(c2 + l, h[10], s5);

      b1 := False;
      b2 := False;
      b3 := False;
      b4 := False;
      for j := 1 to qry2.RecordCount do
      begin

        s1 := FieldStr( qry2, 'BodName');
        s2 := FieldStr( qry2, '长度');
        s3 := FieldStr( qry2, '宽度');
        s4 := FieldStr( qry2, '数量');
        s5 := FieldStr( qry2, '括号');
        s6 := FieldStr( qry2, 'CabType');

        if s1 = '门板' then
        begin
          h[1] := h[1] + TabH;
          s2 := VarToStr(StrToFloat(s2) + IAdge_Door);
          s3 := VarToStr(StrToFloat(s3) + IAdge_Door);
          PrintXY(c10 + l, h[1], s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[1] := h[1] + TabH;
            PrintXY(c10 + l, h[1], '(' + s5 + ')');
          end;
        end
        else if s1 = '侧板' then
        begin
          h[2] := h[2] + TabH;
          s2 := VarToStr(StrToFloat(s2) + IAdge_Body);
          s3 := VarToStr(StrToFloat(s3) + IAdge_Body);
          PrintXY(c3 + l, h[2], s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[2] := h[2] + TabH;
            if s5 = '封4边开' then
            begin
              PrintXY(c3 + l, h[2], '(封4边');
              Bold := True;
              Print('开');
              Bold := False;
              Print(')')
            end
            else
            begin
              PrintXY(c3 + l, h[2], s5);
            end;
          end;
        end
        else if s1 = '背板' then
        begin
          h[3] := h[3] + TabH;
          PrintXY(c9 + l, h[3], s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[3] := h[3] + TabH;
            PrintXY(c9 + l, h[3], '(' + s5 + ')');
          end;
          if Pos('起始宽度', s5) > 0 then
          begin
            s9 := s3;
          end;
        end
        else if (s1 = '底顶板') or (s1 = '顶底板') or (s1 = '底板') then
        begin
          h[4] := h[4] + TabH;
          s2 := VarToStr(StrToFloat(s2) + IAdge_Body);
          s3 := VarToStr(StrToFloat(s3) + IAdge_Body);
          PrintXY(c4 + l, h[4], s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[4] := h[4] + TabH;
            if s5 = '封2边开' then
            begin
              PrintXY(c4 + l, h[4], '(封2边');
              Bold := True;
              Print('开');
              Bold := False;
              Print(')')
            end
            else
            begin
              PrintXY(c4 + l, h[4], '(' + s5 + ')');
            end;

          end;
        end
        else if (s1 = '隔板') or (s1 = '搁板') then
        begin
          h[5] := h[5] + TabH;
          s2 := VarToStr(StrToFloat(s2) + IAdge_Body);
          s3 := VarToStr(StrToFloat(s3) + IAdge_Body);
          PrintXY(c5 + l, h[5], s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[5] := h[5] + TabH;
            PrintXY(c5 + l, h[5], '(' + s5 + ')');
          end;
        end
        else if (s1 = '前拉条') or (s1 = '拉条') then
        begin
          h[6] := h[6] + TabH;
          s2 := VarToStr(StrToFloat(s2) + IAdge_Body);
          s3 := VarToStr(StrToFloat(s3) + IAdge_Body);
          PrintXY(c6 + l, h[6], s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[6] := h[6] + TabH;
            PrintXY(c6 + l, h[6], '(' + s5 + ')');
          end;
        end
        else if s1 = '后拉条' then
        begin
          h[7] := h[7] + TabH;
          s2 := VarToStr(StrToFloat(s2) + IAdge_Body);
          s3 := VarToStr(StrToFloat(s3) + IAdge_Body);
          PrintXY(c7 + l, h[7], s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[7] := h[7] + TabH;
            PrintXY(c7 + l, h[7], '(' + s5 + ')');
          end;
        end
        else if s1 = '后挡' then
        begin
          //h[8] := h[8] + t;
          //PrintXY(c7 + l, h[8], s2 + '×' + s3 + '=' + s4);

        end
        else
        begin
          h[9] := h[9] + TabH;
          s2 := VarToStr(StrToFloat(s2) + IAdge_Body);
          s3 := VarToStr(StrToFloat(s3) + IAdge_Body);
          PrintXY(c8 + l, h[9], s1 + ':' + s2 + '×' + s3 + '=' + s4);
          if s5 <> '' then
          begin
            h[9] := h[9] + TabH;
            PrintXY(c8 + l, h[9], '(' + s5 + ')');
            if s1 = '切角板' then
            begin
              if Pos('中切角', s6) > 0 then
                b4 := True
              else
                b1 := True;

              if Pos('开', s5) > 0 then
                s7 := s3
              else
                s8 := s3;
            end;
            if s1 = '挖角板' then
            begin
              if Pos('上', s6) > 0 then
                b2 := True
              else
                b3 := True;

              if Pos('开', s5) > 0 then
                s8 := s3
              else
                s7 := s3;
            end;

          end;
        end;
        qry2.Next;
      end;

      //d0 := 0.20;
      d0 := TabH;

      if b1 then
      begin
        //______________________切角板______________________
        if StrToInt(cab_w) < 400 then
        begin
          s7 := VarToStr(StrToInt(s7) + IThick_Board);
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
        PrintXY(x3 + l, y3 + d0 * 3 , 'A=' + s7);

        x3 := x3 + d0 * 2 + 0.03;
        MoveTo(x3, y3); LineTo(x3 + d0, y3);
        MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
        MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
        MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
        MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
        MoveTo(x3 + (d0 * 2), y3 + d0); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
        PrintXY(x3 + d0 + l, y3 + (d0 * 2) - l, 'B');
        PrintXY(x3 + d0 + l, y3 + d0 - l, 'A');
        PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + s8);
        PrintXY(x3 - d0 * 2 - 0.03, y3 + d0 * 4 - l / 2, '底板开口示意图');
      end;

      if b4 then
      begin
        //____________________中切角_______________________
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
        try
          s9 := VarToStr(StrToInt64(s9) + 25);
        except
          s9 := '0';
        end;
        PrintXY(x3 + d0 * 3 + l / 2, y3, 'a=' + s9);
        PrintXY(x3 + d0 * 3 + l / 2, y3 + d0, 'b=' + s7);
        PrintXY(x3 + d0 * 3 + l / 2, y3 + d0 * 2, 'c=' + s8);
        PrintXY(x3 + l, y3 + d0 * 3 - l / 2, '底板开口示意图');
      end;

      if b2 then
      begin
        //______________________挖角板______________________
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
        PrintXY(x3 + l, y3 + d0 * 3, 'A=' + s7);
        PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + s8);
        PrintXY(x3, y3 + d0 * 4 - l / 2, '侧板开口示意图');

      end;

      if b3 then
      begin

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
        PrintXY(x3 + l, y3 + d0 * 3, 'A=' + s7);
        PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + s8);
        PrintXY(x3, y3 + d0 * 4 - l / 2, '侧板开口示意图');
      end;

      for j := 1 to 10 do
      begin
        if h[j] > y2 then
          y2 := h[j];
      end;
      y2 := y2 + fLBoottom ;
      MoveTo(c1, y2); LineTo(c11, y2);
        //________________________分页___________________________
      if y2 > 7.0 then
      begin
        l0 := y2;
        MoveTo(c11, y2); LineTo(c0, y2);

        //________________________竖线___________________________

        MoveTo(c1, l1); LineTo(c1, l0);
        MoveTo(c2, l1); LineTo(c2, l0);
        MoveTo(c3, l1); LineTo(c3, l0);
        MoveTo(c4, l1); LineTo(c4, l0);
        MoveTo(c5, l1); LineTo(c5, l0);
        MoveTo(c6, l1); LineTo(c6, l0);
        MoveTo(c7, l1); LineTo(c7, l0);
        MoveTo(c8, l1); LineTo(c8, l0);
        MoveTo(c9, l1); LineTo(c9, l0);
        MoveTo(c10, l1); LineTo(c10, l0);
        MoveTo(c11, l1); LineTo(c11, l0);
        MoveTo(c12, l1); LineTo(c12, l0);

        NewPage;

        PrintColumns(Sender);
      end;

      qry1.Next;
    end; { for }
    MoveTo(c11, y2); LineTo(c0, y2);

    l0 := y2;
    //________________________竖线___________________________
    MoveTo(c1, l1); LineTo(c1, l0);
    MoveTo(c2, l1); LineTo(c2, l0);
    MoveTo(c3, l1); LineTo(c3, l0);
    MoveTo(c4, l1); LineTo(c4, l0);
    MoveTo(c5, l1); LineTo(c5, l0);
    MoveTo(c6, l1); LineTo(c6, l0);
    MoveTo(c7, l1); LineTo(c7, l0);
    MoveTo(c8, l1); LineTo(c8, l0);
    MoveTo(c9, l1); LineTo(c9, l0);
    MoveTo(c10, l1); LineTo(c10, l0);
    MoveTo(c11, l1); LineTo(c11, l0);
    MoveTo(c12, l1); LineTo(c12, l0);

    //_______________________配件汇总_________________________
    NewLine;

    YPos := y2 + 0.15 + TabH;
    XPos := 0.6;
    Print('面积汇总：');
    strSQL := 'Select * From List Where ListID=''' + strListID + '''';
    AQrySel(qry1, strSQL);

    Print('柜体总共' + VarToStr(GetBoardNum(I_BOD_BODY)) + '块，' + FieldStrN(qry1,'柜体板面积',AreaRound) + '平米；');

    Print('背板总共' + VarToStr(GetBoardNum(I_BOD_BACK)) + '块，' + FieldStrN(qry1,'背板面积',AreaRound) + '平米；');

    Print('门板总共' + VarToStr(GetBoardNum(I_BOD_DOOR)) + '块，' + FieldStrN(qry1,'门板面积',AreaRound) + '平米；');

    strSQL := 'SELECT TCab.H, Sum(TCab.C_W) AS s1 From TCab WHERE ListID=''' + strListID + ''' GROUP BY H order by h ';
    qry1.SQL.Clear;
    qry1.SQL.Add(strSQL);
    qry1.Open;
    s1 := VarToStr(qry1.FieldValues['s1'] / 1000);
    Print('下柜总长度' + s1 + '米；');

    if qry1.RecordCount > 1 then
    begin
      qry1.Next;
      s1 := VarToStr(qry1.FieldValues['s1'] / 1000);
    end
    else
      s1 := '0';

    Print('上柜总长度' + s1 + '米');

    NewLine;
    YPos := YPos + TabH;
    XPos := 1.0;
    Print('开料(槽)：');

    XPos := XPos + 1.3;
    Print('封边：');

    XPos := XPos + 1.2;
    Print('打孔(铰链孔)：');

    XPos := XPos + 1.8;
    Print('组装：');

    XPos := XPos + 1.2;
    Print('质检：');


  end;

end;

procedure TF_Prt_Prd.InitData();
var
  strSQL : string;
begin
 //_____________________________初始化数据___________________________________

  if strTabPrd <> '' then
    sTit := strTabPrd
  else
    sTit := '***橱柜公司 工厂';

  strSQL := 'select * from 参数1 where 名称 like ''门板封边''';
  AQrySel(qry1, strSQL);
  IAdge_Door := qry1.FieldValues['Val'];
  IAdge_Door := IAdge_Door * 2;

  strSQL := 'select * from 参数1 where 名称 like ''柜体封边''';
  AQrySel(qry1, strSQL);
  IAdge_Body := qry1.FieldValues['Val'];
  IAdge_Body := IAdge_Body * 2;

end;

procedure TF_Prt_Prd.PrintColumns(var Sender: TObject);
var
  temLineH : Double ;
begin
  with Sender as TBaseReport do
  begin
    //__________________________读取相对字体信息________________________________
    ReadFZFormIniFile(I_PRD);
    //___________________________打印表头和表尾_________________________________
    SectionTop := 0.75; //顶端
    SectionLeft := 1.0;
    //_____________________________打印表头_____________________________________
    Home;
    SetFont(ftT, fzTitle + fzT); //设置字体


    PrintCenter(strTabPrd , PageWidth / 2);
    //___________________________打印页码、日期_________________________________
    SetFont(ftB, fzBody + fzB);
    SectionBottom := 8;
    PrintFooter('　第' + IntToStr(CurrentPage) + '页', pjLeft); //页码
    PrintFooter('日期: ' + FormatDateTime('mm-dd', Date) + ' ', pjRight); //日期
    SectionBottom := 7.5;
    SetTopOfPage;

    Home;
    y1 := 1.2;
    YPos := y1; //y=1.2  订单编号
    SetFont(ftB, fzBody + fzB);
    //SetTopOfPage;
    //Home;
    //PrintXY( 1.0, 2.0, 'Text above (1.0, 2.0)');


    Print('订单编号：');     Print(strListID);
    XPos := XPos + 0.2;
    Print('下单日期：');
    XPos := XPos + 1.0;
    Print('交货日期：');     Print(strSDate);
    XPos := XPos + 0.2;
    Print('拆单：');
    XPos := XPos + 1.0;
    Print('审核：');
    XPos := XPos + 1.0;
    Print('出货状态：');
    NewLine;
    //_____________________打印双横线_______________________
    x1 := 0.5;
    x2 := 11.0;
    y1 := y1 + 0.05; //y=1.2+0.05=1.25
    MoveTo(x1, y1); //两条横线
    LineTo(x2, y1);
    y1 := y1 + 0.02; //y=1.25+0.02=1.27
    MoveTo(x1, y1);
    LineTo(x2, y1);
    temLineH := 0.18;
    y1 := y1 + temLineH; //y=1.27+0.15=1.42  客户姓名
    YPos := y1;
    Print('客户姓名：');    Print(strName);
    XPos := 4.0;
    Print('电话：');        Print(strPhone);
    XPos := 7.0;
    Print('送货地址：');    Print(strAddress);
    NewLine;

    y1 := y1 + temLineH; //y=1.42+0.15=1.57			柜体
    YPos := y1;
    Print('柜体：');        Print(strBod_Body);
    XPos := 4.0;
    Print('门板：');        Print(strBod_Door);
    NewLine;


    //_____________________打印列标题_______________________
    x1 := 1.28; //名称
    x2 := 0.95;
    x3 := 10.5 - 0.3 - x1 - 8 * x2; //附加板
    c1 := 0.50;
    c2 := c1 + 0.30; //NO
    c3 := c2 + x1; //名称
    c4 := c3 + x2; //侧板
    c5 := c4 + x2; //底顶板
    c6 := c5 + x2; //层、隔板
    c7 := c6 + x2; //挡板
    c8 := c7 + x2; //拉条
    c9 := c8 + x3; //附加板
    c10 := c9 + x2; //背板
    c11 := c10 + x2; //门板
    c12 := c11 + x2 + 0.15; //备注
    c0 := c12; //11.0 +0.15

    l1 := y1 + 0.05; //表格上边框

    l0 := 6.00;
    temLineH := 0.16;
    l := 0.10;
    l2 := l1 + temLineH + fLBoottom ;

    PrintXY(c1 + l, l1 + temLineH, 'NO');
    PrintXY(c2 + l, l1 + temLineH, '名称');
    PrintXY(c3 + l, l1 + temLineH, '侧板');
    PrintXY(c4 + l, l1 + temLineH, '底顶板');
    PrintXY(c5 + l, l1 + temLineH, '隔板');
    PrintXY(c6 + l, l1 + temLineH, '前拉条');
    PrintXY(c7 + l, l1 + temLineH, '后拉条');
    PrintXY(c8 + l, l1 + temLineH, '附加板');
    PrintXY(c9 + l, l1 + temLineH, '背板');
    PrintXY(c10 + l, l1 + temLineH, '门板');
    PrintXY(c11 + l, l1 + temLineH, '备注');
    //y2 := y2 + 0.21;
    y2 := l2;
    //________________________横线___________________________
    MoveTo(c1, l1); LineTo(c0, l1);
    MoveTo(c1, l2); LineTo(c0, l2);
  end;
end;

procedure TF_Prt_Prd.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry2.Close;
  qry3.Close;
  qry1.ConnectionString := strCon;
  qry2.ConnectionString := strCon;
  qry3.ConnectionString := strCon;

end;

end.


