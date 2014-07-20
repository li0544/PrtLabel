unit U_Prt_Lab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, Menus, StrUtils,
  CheckLst, RPShell, RPLabel,
  RPDefine, RPBase, RPSystem, UPub, UMain;

type
  TF_Prt_Lab = class(TForm)
    ReportSystem1: TRvSystem;
    LabelShell1: TLabelShell;
    BtnPrintDoor: TButton;
    BtnPrintBack: TButton;
    Label1: TLabel;
    EdtCol: TEdit;
    Label2: TLabel;
    EdtRow: TEdit;
    Label3: TLabel;
    EdtH: TEdit;
    Label4: TLabel;
    EdtW: TEdit;
    Label5: TLabel;
    EdtLeft: TEdit;
    Label6: TLabel;
    EdtTop: TEdit;
    Label7: TLabel;
    EdtBottom: TEdit;
    Label8: TLabel;
    EdtRight: TEdit;
    Label9: TLabel;
    Edtfz: TEdit;
    BtnDefault: TButton;
    qry1: TADOQuery;
    qry2: TADOQuery;
    qry3: TADOQuery;
    RvSysBody: TRvSystem;
    RvSysDoor: TRvSystem;
    RvSysBack: TRvSystem;
    procedure LabelShell1LabelAfter(ReportPrinter: TBaseReport; LabelShell: TLabelShell; var Valid: Boolean);
    procedure LabelShell1LabelPrint(ReportPrinter: TBaseReport; LabelShell: TLabelShell; var Valid: Boolean);
    procedure LabelShell1ReportBefore(ReportPrinter: TBaseReport; LabelShell: TLabelShell);
    procedure GetLabOpt();
    procedure ReportSystem1Print(Sender: TObject);
    procedure BtnDefaultClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure RvSysBodyPrint(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure RvSysDoorPrint(Sender: TObject);
    procedure RvSysBackPrint(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_Lab: TF_Prt_Lab;
  sql: string;
  sql1: string;
  sql2: string;
  sql3: string;
  LabCount: Integer;
  LabIndex: Integer;
  BodCount: Integer;
  BodIndex: Integer;
  l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10: string;
  s0, s1, s2, strCaiZhi, s4, s5, s6, strOth, strCabName, strW_H_D, strBodName: string;
  i: Integer;
  j: Integer;
  fSize: Integer;
  cStr1: string;
  fb: Double;
  labRow    : Integer;   //每页标签行数
  labCol    : Integer;   //每页标签列数
  labH      : Double;    //标签高度
  labW      : Double;    //标签宽度
  labLeft   : Double;
  labTop    : Double;
  labRight  : Double;
  labBottom : Double;

implementation



{$R *.DFM}

procedure TF_Prt_Lab.LabelShell1ReportBefore(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell);
begin
  qry2.First;
  ReportPrinter.SetFont('宋体', fSize);
end;

procedure TF_Prt_Lab.GetLabOpt();
begin
  labCol    := StoI(EdtCol.Text);
  labRow    := StoI(EdtRow.Text);
  labH      := StoD(EdtH.Text);
  labW      := StoD(EdtW.Text);
  labTop    := StoD(EdtTop.Text);
  labRight  := StoD(EdtRight.Text);
  labLeft   := StoD(EdtLeft.Text);
  labBottom := StoD(EdtBottom.Text);
end;

procedure TF_Prt_Lab.LabelShell1LabelPrint(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell; var Valid: Boolean);
var
  cab_id: string;
  i : Integer;
  strCabType : string;
begin
  with ReportPrinter do
  begin
//    try
//      cab_id := FieldStr(qry2, 'CabID');
//    except
//      cab_id := '000000';
//    end;
//    sql7 := 'SELECT * From TCab WHERE CabID =''' + cab_id + ''' AND ListID=''' + strListID + '''';
//    AQrySel(qry3,sql7);
//    if qry3.RecordCount = 0 then Exit;
    strW_H_D := qry2.FieldValues['CabWHD'];
//    begin
      strCaiZhi := FieldStr( qry2, '材质' ) + ' ' + IntToStr( LabIndex ) + '/' + IntToStr( LabCount ) + '块';
      strW      := VarToStr( FieldDob( qry2, '长度') + fb );
      strH      := VarToStr( FieldDob( qry2, '宽度') + fb );
      BodCount  := FieldInt(qry2, 'BodCount');
      strOth    := FieldStr(qry2, '括号');
      strCabName:= FieldStr(qry2, '用途');

      strBodName := FieldStr(qry2, 'BodName');
      l1 := strListID + ' ' + '交货日期:' + strSDate;
      l2 := '地址:' + MidStr(strAddress, 1, 4) + ' ' + strCaiZhi;

      Println(l1);
      Println(l2);

      if ( Pos('包管', strBodName) > 0 ) or ( Pos('垫条', strBodName) > 0 )
      or ( Pos('封板', strBodName) > 0 ) or ( Pos('辅料', strBodName) > 0 ) then
      begin
        Bold := True;
        Print(strBodName);
        Bold := False;
        l3 := ' ' + strW + '×' + strH + ' ' + IntToStr( BodIndex ) + '/' + IntToStr( BodCount ) + '块 ' + strOth;
        Println(l3);
      end
      else
      begin
        l3 := strBodName + ' ' + strW + '×' + strH + ' ' + IntToStr( BodIndex ) + '/' + IntToStr( BodCount ) + '块 ' + strOth;
        Println(l3);
      end;

      if ptType = 1 then
      begin
        l4 := strCabName + ' ' + strW_H_D;
      end
      else
      begin
        strCabType := '---';
        for i := 0 to Length(List.cab) - 1 do
        begin
          if (List.cab[i].cabName = strCabName) and (List.cab[i].cabW_H_D = strW_H_D) then
          begin
            strCabType := List.cab[i].cabTypeID;
            Break;
          end;
        end;

        l4 := strCabType + ' ' + strW_H_D;
      end;
      //抽屉，包管，垫条，封板，辅料
      if ( Pos('抽屉', strBodName) = 0 ) and ( Pos('包管', strBodName) = 0 ) and ( Pos('垫条', strBodName) = 0 )
      and ( Pos('封板', strBodName) = 0 ) and ( Pos('辅料', strBodName) = 0 ) then
      begin
        Println(l4);
      end;

      LabIndex := LabIndex + 1;


      if BodIndex = BodCount then
        BodIndex := 1
      else
        BodIndex := BodIndex + 1;

//    end;


  end;
end;


procedure TF_Prt_Lab.LabelShell1LabelAfter(ReportPrinter: TBaseReport;
  LabelShell: TLabelShell; var Valid: Boolean);
var
  n: Integer;
begin
  try
    n := StrToInt(qry2.FieldValues['数量']);
  except
    n := 0;
  end;
  
  if i >= n then
  begin
    qry2.Next;
    i := 1;
  end
  else
    i := i + 1;

  Valid := not qry2.EOF;
end;

procedure TF_Prt_Lab.ReportSystem1Print(Sender: TObject);
begin
  LabelShell1.Execute(Sender as TBaseReport);
end;

procedure TF_Prt_Lab.BtnPrintClick(Sender: TObject);
begin
  //读取橱柜标题显示类型：名称，B1/W1
  ReadFZFormIniFile(I_PRD);

  case (Sender as TButton).Tag of
    0:
    begin
      //____________________打印门板________________________
      sql1 := 'select * From TBod where ListID=''' + strListID + ''' AND BodName like ''门板'' order by 长度,宽度,BodName,材质';
      LabCount := GetBoardNum( I_BOD_DOOR );
      LabIndex := 1;
      BodIndex := 1;
      i := 1;
      sql := 'select * from TOption where 名称 like ''门板封边''';
      AQrySel( qry1 , sql );
      fb := qry1.FieldValues['Val'];
      fb := fb * 2;
    end;
    1:
    begin
      //__________________打印柜体板___________________
      sql1 := 'select * From TBod where ListID=''' + strListID + ''' AND (BodName not like ''门板'' and BodName not like ''背板'') order by 长度,宽度,BodName,材质';
      LabCount := GetBoardNum( I_BOD_BODY );
      LabIndex := 1;
      BodIndex := 1;
      i := 1;
      sql := 'select * from TOption where 名称 like ''柜体封边''';
      AQrySel( qry1 , sql );
      fb := qry1.FieldValues['Val'];
      fb := fb * 2;
    end;
    2:
    begin
      //___________________打印背板_____________________
      sql1 := 'select * From TBod where ListID=''' + strListID + ''' AND BodName like ''背板'' order by 长度,宽度,BodName,材质';
      LabCount := GetBoardNum( I_BOD_BACK );
      LabIndex := 1;
      BodIndex := 1;
      i := 1;
      fb := 0;
    end;
  end;
  
  if AQrySel( qry2 , sql1 ) = 0 then
  begin
    ShowMessage('该板材不存在！');
    Exit;
  end;
  ReportSystem1.Execute;

end;

procedure TF_Prt_Lab.EditChange(Sender: TObject);
begin
  LabelShell1.NumAcross     := StrToInt(EdtCol.Text);
  LabelShell1.NumDown       := StrToInt(EdtRow.Text);
  LabelShell1.LabelHeight   :=  StrToFloat(EdtH.Text);                               
  LabelShell1.SpacingHeight :=  StrToFloat(EdtH.Text) + StrToFloat(EdtBottom.Text);  
  LabelShell1.LabelWidth    :=    StrToFloat(EdtW.Text);
  LabelShell1.SpacingWidth  :=    StrToFloat(EdtW.Text) + StrToFloat(EdtRight.Text);
  LabelShell1.SpacingLeft   := StrToFloat(EdtLeft.Text);
  LabelShell1.SpacingTop    := StrToFloat(EdtTop.Text);
  LabelShell1.SpacingHeight := StrToFloat(EdtH.Text) + StrToFloat(EdtRight.Text);
  LabelShell1.SpacingWidth  := StrToFloat(EdtW.Text) + StrToFloat(EdtBottom.Text);
  fSize                     := StrToInt(Edtfz.Text);
end;

procedure TF_Prt_Lab.BtnDefaultClick(Sender: TObject);
begin
  EdtCol.Text    := '3';
  EdtRow.Text    := '10';
  EdtW.Text      := '1';
  EdtH.Text      := '2.5';
  EdtLeft.Text   := '0.1';
  EdtTop.Text    := '0.5';
  EdtRight.Text  := '0.1';
  EdtBottom.Text := '0.25';
  Edtfz.Text     := '10';
end;

procedure TF_Prt_Lab.FormActivate(Sender: TObject);
begin
  fSize := 10;
  qry3.SQL.Clear;
  qry3.SQL.Add('select * from list WHERE ListID=''' + strListID + '''');
  qry3.Open;

  strSDate := qry3.FieldValues['交货日期'];
  strAddress := qry3.FieldValues['安装地址'];
end;

procedure TF_Prt_Lab.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry2.Close;
  qry3.Close;
  qry1.ConnectionString := strCon;
  qry2.ConnectionString := strCon;
  qry3.ConnectionString := strCon;
end;

procedure TF_Prt_Lab.RvSysDoorPrint(Sender: TObject);
var
  i , j , k: Integer;
  x1 , y1 , x2 , y2 , t1:Double;
  l1 , l2 , l3 , l4 : string;
  l , t , rowH: Double;
  labCount : Integer;
begin
  //读取参数
  GetLabOpt();

  with  Sender as TBaseReport do
  begin

    SetPen(clGreen,psSolid,-1,pmCopy);
    l := 0.1;    t := 0.1;    rowH := LineHeight;    j := 0;
    k := 0;
    t1 := 0.25;
    XPos := labLeft;
    YPos := labTop;

//    labH := (PageHeight - labBottom - 0.2) / labRow - labTop;
//    labW := (PageWidth - labRight) / labCol - labLeft;
    labCount := GetBoardNum( I_BOD_DOOR );
    for i := 0 to Length(List.bodLabs.DoorLabs) - 1 do
    begin
      if k = labRow then
      begin
        NewPage;
        j := 0;
        k := 0;
        XPos := labLeft;
        YPos := labTop;
      end;

      x1 := XPos;
      y1 := YPos;
      x2 := x1 + labW;
      y2 := y1 + labH;
      RoundRect(x1, y1, x2, y2, t1, t1);

      //显示标签内容
      with List.bodLabs.DoorLabs[i] do
      begin
        l1 := strListID + ' ' + '交货日期:' + strSDate;
        l2 := '地址:' + MidStr(strAddress, 1, 4) + ' ' + bodCZh + ' ' + VarToStr(i + 1) + '/' + VarToStr(labCount);

        XPos := x1 + l;
        YPos := YPos + rowH + t;
        Print(l1);
        XPos := x1 + l;
        YPos := YPos + rowH;
        Print(l2);
        XPos := x1 + l;
        YPos := YPos + rowH;

        if ( Pos('包管', BodName) > 0 ) or ( Pos('垫条', BodName) > 0 )
        or ( Pos('封板', BodName) > 0 ) or ( Pos('辅料', BodName) > 0 ) then
        begin
          Bold := True;
          Print(BodName);
          Bold := False;
          l3 := ' ' + VtoS(bodH + fbDoor * 2) + '×' + VtoS(bodW + fbDoor * 2) + ' ' + IntToStr( labIndex ) + '/' + IntToStr( BodCount ) + '块 ' + bodInfo;
          Print(l3);
        end
        else
        begin
          l3 := BodName + ' ' + VtoS(bodH + fbDoor * 2) + '×' + VtoS(bodW + fbDoor * 2) + ' ' + IntToStr( labIndex ) + '/' + IntToStr( BodCount ) + '块 ' + bodInfo;
          Print(l3);
        end;
        XPos := x1 + l;
        YPos := YPos + rowH;

        if ptType = 1 then
        begin
          l4 := CabName + ' ' + cabW_H_D;
        end
        else
        begin
          l4 := cabTypeID + ' ' + cabW_H_D;
        end;

        //抽屉，包管，垫条，封板，辅料
        if ( Pos('抽屉', BodName) = 0 ) and ( Pos('包管', BodName) = 0 ) and ( Pos('垫条', BodName) = 0 )
        and ( Pos('封板', BodName) = 0 ) and ( Pos('辅料', BodName) = 0 ) then
        begin
          Print(l4);
        end;
      end;

      //控制坐标
      if j < labCol - 1 then
      begin
        XPos := x2 + labRight;
        YPos := y1;
        Inc(j);
      end
      else if j = labCol - 1 then
      begin
        XPos := labLeft;
        j := 0;
        YPos := y2 + labBottom;
        Inc(k);
      end;

    end;
  end;
end;

procedure TF_Prt_Lab.RvSysBodyPrint(Sender: TObject);
var
  i , j , k: Integer;
  x1 , y1 , x2 , y2 , t1:Double;
  l1 , l2 , l3 , l4 : string;
  l , t , rowH: Double;
  labCount : Integer;
begin
  //读取参数
  GetLabOpt();

  with  Sender as TBaseReport do
  begin

    //SetBrush(clGreen,bsClear, nil);
    SetPen(clGreen,psSolid,-1,pmCopy);
    l := 0.1;    t := 0.1;    rowH := LineHeight;    j := 0;
    k := 0;
    t1 := 0.25;
    XPos := labLeft;
    YPos := labTop;

//    labH := (PageHeight - labBottom - 0.2) / labRow - labTop;
//    labW := (PageWidth - labRight) / labCol - labLeft;
    labCount := GetBoardNum( I_BOD_BODY );
    for i := 0 to Length(List.bodLabs.BodyLabs) - 1 do
    begin
      if k = labRow then
      begin
        NewPage;
        j := 0;
        k := 0;
        XPos := labLeft;
        YPos := labTop;
      end;

      x1 := XPos;
      y1 := YPos;
      x2 := x1 + labW;
      y2 := y1 + labH;
      RoundRect(x1, y1, x2, y2, t1, t1);

      //显示标签内容
      with List.bodLabs.BodyLabs[i] do
      begin
        l1 := strListID + ' ' + '交货日期:' + strSDate;
        l2 := '地址:' + MidStr(strAddress, 1, 4) + ' ' + bodCZh + ' ' + VarToStr(i + 1) + '/' + VarToStr(labCount);

        XPos := x1 + l;
        YPos := YPos + rowH + t;
        Print(l1);
        XPos := x1 + l;
        YPos := YPos + rowH;
        Print(l2);
        XPos := x1 + l;
        YPos := YPos + rowH;

        if ( Pos('包管', BodName) > 0 ) or ( Pos('垫条', BodName) > 0 )
        or ( Pos('封板', BodName) > 0 ) or ( Pos('辅料', BodName) > 0 ) then
        begin
          Bold := True;
          Print(BodName);
          Bold := False;
          l3 := ' ' + VtoS(bodH + fbBody * 2) + '×' + VtoS(bodW + fbBody * 2) + ' ' + IntToStr( labIndex ) + '/' + IntToStr( BodCount ) + '块 ' + bodInfo;
          Print(l3);
        end
        else
        begin
          l3 := BodName + ' ' + VtoS(bodH + fbBody * 2) + '×' + VtoS(bodW + fbBody * 2) + ' ' + IntToStr( labIndex ) + '/' + IntToStr( BodCount ) + '块 ' + bodInfo;
          Print(l3);
        end;
        XPos := x1 + l;
        YPos := YPos + rowH;

        if ptType = 1 then
        begin
          l4 := CabName + ' ' + cabW_H_D;
        end
        else
        begin
          l4 := cabTypeID + ' ' + cabW_H_D;
        end;

        //抽屉，包管，垫条，封板，辅料
        if ( Pos('抽屉', BodName) = 0 ) and ( Pos('包管', BodName) = 0 ) and ( Pos('垫条', BodName) = 0 )
        and ( Pos('封板', BodName) = 0 ) and ( Pos('辅料', BodName) = 0 ) then
        begin
          Print(l4);
        end;
      end;

      //控制坐标
      if j < labCol - 1 then
      begin
        XPos := x2 + labRight;
        YPos := y1;
        Inc(j);
      end
      else if j = labCol - 1 then
      begin
        XPos := labLeft;
        j := 0;
        YPos := y2 + labBottom;
        Inc(k);
      end;

    end;
  end;
end;

procedure TF_Prt_Lab.RvSysBackPrint(Sender: TObject);
var
  i , j , k: Integer;
  x1 , y1 , x2 , y2 , t1:Double;
  l1 , l2 , l3 , l4 : string;
  l , t , rowH: Double;
  labCount : Integer;
begin
  //读取参数
  GetLabOpt();

  with  Sender as TBaseReport do
  begin

    //SetBrush(clGreen,bsClear, nil);
    SetPen(clGreen,psSolid,-1,pmCopy);
    l := 0.1;    t := 0.1;    rowH := LineHeight;    j := 0;
    k := 0;
    t1 := 0.25;
    XPos := labLeft;
    YPos := labTop;

//    labH := (PageHeight - labBottom - 0.2) / labRow - labTop;
//    labW := (PageWidth - labRight) / labCol - labLeft;
    labCount := GetBoardNum( I_BOD_BACK );
    for i := 0 to Length(List.bodLabs.BackLabs) - 1 do
    begin
      if k = labRow then
      begin
        NewPage;
        j := 0;
        k := 0;
        XPos := labLeft;
        YPos := labTop;
      end;

      x1 := XPos;
      y1 := YPos;
      x2 := x1 + labW;
      y2 := y1 + labH;
      RoundRect(x1, y1, x2, y2, t1, t1);

      //显示标签内容
      with List.bodLabs.BackLabs[i] do
      begin
        l1 := strListID + ' ' + '交货日期:' + strSDate;
        l2 := '地址:' + MidStr(strAddress, 1, 4) + ' ' + bodCZh + ' ' + VarToStr(i + 1) + '/' + VarToStr(labCount);

        XPos := x1 + l;
        YPos := YPos + rowH + t;
        Print(l1);
        XPos := x1 + l;
        YPos := YPos + rowH;
        Print(l2);
        XPos := x1 + l;
        YPos := YPos + rowH;

        if ( Pos('包管', BodName) > 0 ) or ( Pos('垫条', BodName) > 0 )
        or ( Pos('封板', BodName) > 0 ) or ( Pos('辅料', BodName) > 0 ) then
        begin
          Bold := True;
          Print(BodName);
          Bold := False;
          l3 := ' ' + VtoS(bodH + fbBack * 2) + '×' + VtoS(bodW + fbBack * 2) + ' ' + IntToStr( labIndex ) + '/' + IntToStr( BodCount ) + '块 ' + bodInfo;
          Print(l3);
        end
        else
        begin
          l3 := BodName + ' ' + VtoS(bodH + fbBack * 2) + '×' + VtoS(bodW + fbBack * 2) + ' ' + IntToStr( labIndex ) + '/' + IntToStr( BodCount ) + '块 ' + bodInfo;
          Print(l3);
        end;
        XPos := x1 + l;
        YPos := YPos + rowH;

        if ptType = 1 then
        begin
          l4 := CabName + ' ' + cabW_H_D;
        end
        else
        begin
          l4 := cabTypeID + ' ' + cabW_H_D;
        end;

        //抽屉，包管，垫条，封板，辅料
        if ( Pos('抽屉', BodName) = 0 ) and ( Pos('包管', BodName) = 0 ) and ( Pos('垫条', BodName) = 0 )
        and ( Pos('封板', BodName) = 0 ) and ( Pos('辅料', BodName) = 0 ) then
        begin
          Print(l4);
        end;
      end;

      //控制坐标
      if j < labCol - 1 then
      begin
        XPos := x2 + labRight;
        YPos := y1;
        Inc(j);
      end
      else if j = labCol - 1 then
      begin
        XPos := labLeft;
        j := 0;
        YPos := y2 + labBottom;
        Inc(k);
      end;

    end;
  end;
end;

procedure TF_Prt_Lab.Label1Click(Sender: TObject);
begin
  RvSysBody.Execute;
end;


procedure TF_Prt_Lab.Label5Click(Sender: TObject);
begin
  RvSysBack.Execute;
end;

procedure TF_Prt_Lab.Label2Click(Sender: TObject);
begin
  RvSysDoor.Execute;
end;

end.





