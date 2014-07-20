unit U_Prt_Lab2;

interface

{$DEFINE v1_72}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, Menus, StrUtils, UADO,
  CheckLst, 
  RPBase, RPSystem, UPub, UParam, RpDefine;

type
  TF_Prt_Lab = class(TForm)
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
    procedure GetLabOpt();
    procedure BtnDefaultClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure RvSysBodyPrint(Sender: TObject);
    procedure RvSysDoorPrint(Sender: TObject);
    procedure RvSysBackPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_Lab: TF_Prt_Lab;
//  sql: string;
//  sql1: string;
//  sql2: string;
//  sql3: string;
  LabCount: Integer;
//  LabIndex: Integer;
//  BodCount: Integer;
//  BodIndex: Integer;
//  l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10: string;
//  s0, s1, s2, strCaiZhi, s4, s5, s6, strOth, strCabName, strW_H_D, strBodName: string;
//  i: Integer;
//  j: Integer;
//  fSize: Integer;
//  cStr1: string;
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

procedure TF_Prt_Lab.BtnPrintClick(Sender: TObject);
begin
  //读取橱柜标题显示类型：名称，B1/W1
  ReadFZFormIniFile(I_PRD);
  GetLabOpt();
  case (Sender AS TButton).Tag of
    0:
    begin
      //____________________打印门板________________________
      RvSysDoor.Execute;
    end;
    1:
    begin
      //__________________打印柜体板___________________
      RvSysBody.Execute;
    end;
    2:
    begin
      //___________________打印背板_____________________
      RvSysBack.Execute;
    end;
  end;

end;

procedure TF_Prt_Lab.BtnDefaultClick(Sender: TObject);
begin
  EdtCol.Text    := '3';
  EdtRow.Text    := '10';
  EdtW.Text      := '1';
  EdtH.Text      := '2.5';
  EdtLeft.Text   := '0.1';
  EdtTop.Text    := '0.2';
  EdtRight.Text  := '0.1';
  EdtBottom.Text := '0.25';
  Edtfz.Text     := '10';
end;

procedure TF_Prt_Lab.FormActivate(Sender: TObject);
begin
  qry1.SQL.Clear;
  qry1.SQL.Add('SELECT * FROM list WHERE ListID=''' + strListID + '''');
  qry1.Open;

  strSDate := qry1.FieldValues['交货日期'];
  strAddress := qry1.FieldValues['安装地址'];
end;

procedure TF_Prt_Lab.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry1.ConnectionString := getConStr();

  {$IFDEF v1_71}
  BtnPrintBack.Visible := False;
  {$ENDIF}
end;

//打印门板
procedure TF_Prt_Lab.RvSysDoorPrint(Sender: TObject);
var
  i , j , k: Integer;
  x1 , y1 , x2 , y2 , t1:Double;
  l1 , l2 , l3 , l4 : string;
  l , t , rowH: Double;
  labCount : Integer;
begin

  with  Sender AS TBaseReport do
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

      SetFont(ftB, fzBody + fzB);

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

        if ( Pos('包管', BodName) > 0 ) OR ( Pos('垫条', BodName) > 0 )
        OR ( Pos('封板', BodName) > 0 ) OR ( Pos('辅料', BodName) > 0 ) then
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
        if ( Pos('抽屉', BodName) = 0 ) AND ( Pos('包管', BodName) = 0 ) AND ( Pos('垫条', BodName) = 0 )
        AND ( Pos('封板', BodName) = 0 ) AND ( Pos('辅料', BodName) = 0 ) then
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

//打印底顶板
procedure TF_Prt_Lab.RvSysBodyPrint(Sender: TObject);
var
  i , j , k: Integer;
  x1 , y1 , x2 , y2 , t1:Double;
  l1 , l2 , l3 , l4 : string;
  l , t , rowH: Double;
  labCount : Integer;
begin

  with  Sender AS TBaseReport do
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
    {$IFDEF v1_71}
    labCount := GetBoardNum( I_BOD_BODY ) + GetBoardNum( I_BOD_BACK );
    for i := 0 to (Length(List.bodLabs.BodyLabs) + Length(List.bodLabs.BackLabs)) - 1 do
    {$ELSE}
    labCount := GetBoardNum( I_BOD_BODY );
    for i := 0 to Length(List.bodLabs.BodyLabs) - 1 do
    {$ENDIF}
    begin
      if k = labRow then
      begin
        NewPage;
        j := 0;
        k := 0;
        XPos := labLeft;
        YPos := labTop;
      end;
      SetFont(ftB, fzBody + fzB);

      x1 := XPos;
      y1 := YPos;
      x2 := x1 + labW;
      y2 := y1 + labH;
      RoundRect(x1, y1, x2, y2, t1, t1);

      //显示标签内容
      if i < Length(List.bodLabs.BodyLabs) then
      begin
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

          if ( Pos('包管', BodName) > 0 ) OR ( Pos('垫条', BodName) > 0 )
          OR ( Pos('封板', BodName) > 0 ) OR ( Pos('辅料', BodName) > 0 ) then
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
          if ( Pos('抽屉', BodName) = 0 ) AND ( Pos('包管', BodName) = 0 ) AND ( Pos('垫条', BodName) = 0 )
          AND ( Pos('封板', BodName) = 0 ) AND ( Pos('辅料', BodName) = 0 ) then
          begin
            Print(l4);
          end;
        end;
      end
      else
      begin
        with List.bodLabs.BackLabs[i - Length(List.bodLabs.BodyLabs)] do
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

          if ( Pos('包管', BodName) > 0 ) OR ( Pos('垫条', BodName) > 0 )
          OR ( Pos('封板', BodName) > 0 ) OR ( Pos('辅料', BodName) > 0 ) then
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
          if ( Pos('抽屉', BodName) = 0 ) AND ( Pos('包管', BodName) = 0 ) AND ( Pos('垫条', BodName) = 0 )
          AND ( Pos('封板', BodName) = 0 ) AND ( Pos('辅料', BodName) = 0 ) then
          begin
            Print(l4);
          end;
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

//打印背板
procedure TF_Prt_Lab.RvSysBackPrint(Sender: TObject);
var
  i , j , k: Integer;
  x1 , y1 , x2 , y2 , t1:Double;
  l1 , l2 , l3 , l4 : string;
  l , t , rowH: Double;
  labCount : Integer;
begin

  with  Sender AS TBaseReport do
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
      SetFont(ftB, fzBody + fzB);

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

        if ( Pos('包管', BodName) > 0 ) OR ( Pos('垫条', BodName) > 0 )
        OR ( Pos('封板', BodName) > 0 ) OR ( Pos('辅料', BodName) > 0 ) then
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
        if ( Pos('抽屉', BodName) = 0 ) AND ( Pos('包管', BodName) = 0 ) AND ( Pos('垫条', BodName) = 0 )
        AND ( Pos('封板', BodName) = 0 ) AND ( Pos('辅料', BodName) = 0 ) then
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

end.





