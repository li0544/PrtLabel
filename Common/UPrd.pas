unit UPrd;

interface

procedure savePrd_BodyToDB();

implementation

uses
  UParam, UPub;

procedure savePrd_BodyToDB();
var
  i, j: Integer;
  strSQL: string;
  CabTabID : string ;
  rowH, rowW, rowTop : Double;
  ID : string;
begin
   {
    //���߿���
    SetPen(clBlack, psSolid, ILineWidth, pmCopy);

    InitData();

    PrintAllColumns(Sender);


    //_____________________��ӡ�������______________________

    rowH := LineHeight * TabLineH ;

    //���ͳ��
    YPos := YPos + rowH ;
    YPos := YPos - fLBoottom;
    Bold := True;
    PrintXY( c3  + l,  YPos ,   IntToStr( List.NumCB   ) );  //���
    PrintXY( c4  + l,  YPos ,   IntToStr( List.NumDDB  ) );  //�׶���
    PrintXY( c5  + l,  YPos ,   IntToStr( List.NumGB   ) );  //����
    PrintXY( c6  + l,  YPos ,   IntToStr( List.NumQLT  ) );  //����
    PrintXY( c7  + l,  YPos ,   '<--'                    );
    PrintXY( c8  + l,  YPos ,   IntToStr( List.NumFJB  ) );  //���Ӱ�
    PrintXY( c9  + l,  YPos ,   IntToStr( List.NumBack ) );  //����
    PrintXY( c10 + l,  YPos ,   IntToStr( List.NumDoor ) );  //�Ű�
    Bold := False;

    YPos := YPos + fLBoottom;
    MoveTo(c1, YPos); LineTo(c0, YPos);
    }
    //_____________________��ӡ�������______________________

    //SetFont(ftB, fzBody + fzB);

    //for i := 1 to qry1.RecordCount do
    for i := 0 to Length(List.cabPrd) - 1 do
    begin
      ID := getNewID('Prd_Body', 'ID');
      strSQL := 'Insert into Prd_Body('
        + 'ID    ,'
        + 'NO    ,'
        + 'Nam   ,'
        + 'W_H_D ,'
        + 'C_B   ,'
        + 'D_B   ,'
        + 'G_B   ,'
        + 'Q_D   ,'
        + 'H_D   ,'
        + 'Oth_B ,'
        + 'B_B   ,'
        + 'Oth   ,'
        + 'Pic    '
        + ') Values('
        + ''   + ID                      + '  ,'
        + '''' + ItoS(i + 1)             + ''','
        + '''' + List.cabPrd[i].cabName  + ''','
        + '''' + List.cabPrd[i].cabW_H_D + ''','
        + '''' + List.cabPrd[i].bodCB[1] + ''','
        + 'D_B   ,'
        + 'G_B   ,'
        + 'Q_D   ,'
        + 'H_D   ,'
        + 'Oth_B ,'
        + 'B_B   ,'
        + 'Oth   ,'
        + 'Pic   )';        

      rowTop := YPos;
      l := 0.10;
      PrintXY(c1 + l, YPos + rowH, IntToStr(i + 1));  //���

      YPos := rowTop;
      l := 0.08;
      YPos := YPos + rowH;
      PrintXY(c2 + l, YPos, List.cabPrd[i].cabName);  //��������
      YPos := YPos + rowH;
      PrintXY(c2 + l, YPos, List.cabPrd[i].cabW_H_D);

      b1 := False;
      b2 := False;
      b3 := False;
      b4 := False;

      YPos := rowTop;
      with List.cabPrd[i] do
      begin
        for j := 0 to List.cabPrd[i].TabH - 1 do
        begin

          YPos := YPos + rowH;
          //���
          if j + 1 <= Length(bodCB) then
          begin
            if bodCB[j] = '��4�߿�' then
            begin
              PrintXY(c3 + l, YPos, '(��4��');
              Bold := True;
              Print('��');
              Bold := False;
              Print(')');
            end
            else
            begin
              PrintXY(c3 + l, YPos, bodCB[j]);
            end;
          end;

          //�׶���
          if j + 1 <= Length(bodDDB) then
          begin
            if bodDDB[j] = '��2�߿�' then
            begin
              PrintXY(c4 + l, YPos, '(��2��');
              Bold := True;
              Print('��');
              Bold := False;
              Print(')')
            end
            else
            begin
              PrintXY(c4 + l, YPos, bodDDB[j]);
            end;
          end;

          //����
          if j + 1 <= Length(bodGB) then
          begin
            PrintXY(c5 + l, YPos, bodGB[j]);
          end;

          //ǰ����
          if j + 1 <= Length(bodQLT) then
          begin
            PrintXY(c6 + l, YPos, bodQLT[j]);
          end;

          //���
          if j + 1 <= Length(bodHLT) then
          begin
            PrintXY(c7 + l, YPos, bodHLT[j]);
          end;

          //���Ӱ�
          if j + 1 <= Length(bodFJB) then
          begin
            PrintXY(c8 + l, YPos, bodFJB[j]);
          end;

          //����
          if j + 1 <= Length(bodBack) then
          begin
            PrintXY(c9 + l, YPos, bodBack[j]);
          end;

          //�Ű�
          if j + 1 <= Length(bodDoor) then
          begin
            PrintXY(c10 + l, YPos, bodDoor[j]);
          end;

        end;


        //d0 := 0.20;
        d0 := rowH;
        y1 := rowTop;
        if List.cabPrd[i].cutType = CUT_QJ then
        begin
          //______________________�нǰ�______________________
          if List.cab[i].cabW < 400 then
          begin
            cutA := cutA + IThick_Board;
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
          PrintXY(x3 + l, y3 + d0 * 3 , 'A=' + VarToStr(cutA));

          x3 := x3 + d0 * 2 + 0.03;
          MoveTo(x3, y3); LineTo(x3 + d0, y3);
          MoveTo(x3 + d0, y3 + d0); LineTo(x3 + d0 * 2, y3 + d0);
          MoveTo(x3, y3 + (d0 * 2)); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          MoveTo(x3, y3); LineTo(x3, y3 + (d0 * 2));
          MoveTo(x3 + d0, y3); LineTo(x3 + d0, y3 + d0);
          MoveTo(x3 + (d0 * 2), y3 + d0); LineTo(x3 + (d0 * 2), y3 + (d0 * 2));
          PrintXY(x3 + d0 + l, y3 + (d0 * 2) - l, 'B');
          PrintXY(x3 + d0 + l, y3 + d0 - l, 'A');
          PrintXY(x3 + l, y3 + d0 * 3 , 'B=' + VarToStr(cutB));
          PrintXY(x3 - d0 * 2 - 0.03, y3 + d0 * 4 - l / 2, '�װ忪��ʾ��ͼ');
        end;

        if List.cabPrd[i].cutType = CUT_ZQJ then
        begin
          //____________________���н�_______________________
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
//          try
//            cutC := cutC + 25;
//          except
//            cutC := 0;
//          end;
          PrintXY(x3 + d0 * 3 + l / 2, y3, 'a=' + VarToStr(cutC));
          PrintXY(x3 + d0 * 3 + l / 2, y3 + d0, 'b=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 3 + l / 2, y3 + d0 * 2, 'c=' + VarToStr(cutB));
          PrintXY(x3 + l, y3 + d0 * 3 - l / 2, '�װ忪��ʾ��ͼ');
        end;

        if List.cabPrd[i].cutType = CUT_SWJ then
        begin
          //______________________���ڽǰ�______________________
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
          PrintXY(x3 + l, y3 + d0 * 3, 'A=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + VarToStr(cutB));
          PrintXY(x3, y3 + d0 * 4 - l / 2, '��忪��ʾ��ͼ');

        end;

        if List.cabPrd[i].cutType = CUT_XWJ then
        begin
          //______________________���ڽǰ�______________________
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
          PrintXY(x3 + l, y3 + d0 * 3, 'A=' + VarToStr(cutA));
          PrintXY(x3 + d0 * 2 + l, y3 + d0 * 3, 'B=' + VarToStr(cutB));
          PrintXY(x3, y3 + d0 * 4 - l / 2, '��忪��ʾ��ͼ');
        end;
      end;
      {
      for j := 1 to 10 do
      begin
        if h[j] > y2 then
          y2 := h[j];
      end; }

      //y2 := y2 + TabH * List.cabPrd[i].TabH;

      YPos := rowTop + List.cabPrd[i].TabH * rowH + fLBoottom ;
      MoveTo(c1, YPos); LineTo(c11, YPos);
        //________________________��ҳ___________________________
      YPos := YPos;
      if YPos > 7.0 then
      begin
        l0 := YPos;
        tabBottom := YPos;
        MoveTo(c11, YPos); LineTo(c0, YPos);

        //________________________����___________________________

        MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
        MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
        MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
        MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);
        MoveTo(c5,  tabTop);  LineTo(c5,  tabBottom);
        MoveTo(c6,  tabTop);  LineTo(c6,  tabBottom);
        MoveTo(c7,  tabTop);  LineTo(c7,  tabBottom);
        MoveTo(c8,  tabTop);  LineTo(c8,  tabBottom);
        MoveTo(c9,  tabTop);  LineTo(c9,  tabBottom);
        MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
        MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
        MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

        NewPage;

        PrintAllColumns(Sender);
      end;

      qry1.Next;
    end; { for }
    MoveTo(c11, YPos); LineTo(c0, YPos);

    l0 := YPos;
		tabBottom := YPos;
    //________________________����___________________________
		MoveTo(c1,  tabTop);  LineTo(c1,  tabBottom);
		MoveTo(c2,  tabTop);  LineTo(c2,  tabBottom);
		MoveTo(c3,  tabTop);  LineTo(c3,  tabBottom);
		MoveTo(c4,  tabTop);  LineTo(c4,  tabBottom);
		MoveTo(c5,  tabTop);  LineTo(c5,  tabBottom);
		MoveTo(c6,  tabTop);  LineTo(c6,  tabBottom);
		MoveTo(c7,  tabTop);  LineTo(c7,  tabBottom);
		MoveTo(c8,  tabTop);  LineTo(c8,  tabBottom);
		MoveTo(c9,  tabTop);  LineTo(c9,  tabBottom);
		MoveTo(c10, tabTop);  LineTo(c10, tabBottom);
		MoveTo(c11, tabTop);  LineTo(c11, tabBottom);
		MoveTo(c12, tabTop);  LineTo(c12, tabBottom);

    //_______________________�������_________________________
    NewLine;

    YPos := YPos + fLBoottom * 2;
    Print('������ܣ�');
    rowW := 2.5;
    XPos := SectionLeft + 1 + rowW * 0 ;    Print('������ܹ�' + VarToStr(List.NumBody) + '�飬' + VarToStr(List.AreaBody) + 'ƽ�ף�');
    XPos := SectionLeft + 1 + rowW * 1 ;    Print('�����ܹ�'   + VarToStr(List.NumBack) + '�飬' + VarToStr(List.AreaBack) + 'ƽ�ף�');
    XPos := SectionLeft + 1 + rowW * 2 ;    Print('�Ű��ܹ�'   + VarToStr(List.NumDoor) + '�飬' + VarToStr(List.AreaDoor) + 'ƽ�ף�');

    NewLine;
    YPos := YPos + fLBoottom;
		rowW := 2;
    XPos := SectionLeft + rowW * 0 ;   	Print('����(��)��');
    XPos := SectionLeft + rowW * 1 ;  	Print('��ߣ�');
    XPos := SectionLeft + rowW * 2 ;   	Print('���(������)��');
    XPos := SectionLeft + rowW * 3 ;   	Print('��װ��');
    XPos := SectionLeft + rowW * 4 ;    Print('�ʼ죺');



end;


end.
