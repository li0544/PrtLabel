unit UList;

interface

uses
  //System
  UPub, UParam, Controls, Dialogs, SysUtils, Variants, DateUtils,
  DB, ADODB, UDebug, ExcelXP, UADO;

procedure Stat_BodAreaPrc();                                    //统计板材面积和价格
procedure Stat_BodLab();                                        //统计标签数据
procedure Stat_BodPrd();                                        //统计生产制作单数据
procedure Stat_hdwPrc();                                        //统计报价单数据
procedure ReadBodDataFromDB();                                  //FROM Access DB
procedure ReadhdwDataFromDB();                                  //
procedure SaveBodDataToDB();                                    //Save Board Data To Access DB
procedure SaveHDwDataToDB();                                    //Save HardWare Data to Access DB
procedure SaveCZhDataToDB();                                    //Save CaiZhi Data to Access DB
procedure ReadCZhPrc();                                         //读取板材金额
procedure ReadhdwPrc();                                         //读取五金金额
procedure ReadTsPrc();                                          //读取特殊加价公式及金额
function  ReadBodDataFromXLS( strXlsFile : string ): Boolean;   //FROM Excel
function  ReadHDwDataFromXLS( strXlsFile : string ): Boolean;   //FROM Excel
procedure setBodStandard(listID: string);                       //过滤标准件 板材


implementation

uses
  U_List;

/// <summary>
/// 从excel读取板材数据
/// </summary>
/// <param name="strXlsFile"></param>
/// <returns></returns>
function ReadBodDataFromXLS( strXlsFile : string ): Boolean;
var
  strTem : string ;
  i, j : Integer;
	C_Index : Integer;
  B_Index : Integer;
  Date_Input : TDate;
  ExlApp1: TExcelApplication;
  ExlWork1: TExcelWorkbook;
  ExlSheet1: TExcelWorksheet;
begin
//  with D_ADO do
//  begin
    ExlApp1 := TExcelApplication.Create(nil);
    ExlWork1 := TExcelWorkbook.Create(nil);
    ExlSheet1 := TExcelWorksheet.Create(nil);

    try
      ExlApp1.Connect;
    except
      MessageDlg('没有安装Excel', mtError, [mbOk], 0);
      Abort;
      Result := False ;
      Exit ;
    end;

    try
      //ExlApp1.Visible[0]:=True;
      ExlApp1.Caption := 'Excel Application';
      ExlApp1.Workbooks.Open(strXlsFile, null, null, null, null, null,
        null, null, null, null, null, null, null, null, null, 0);

      {订单编号:DD20081219-1 交货日期:2008-12-19 安装地址:呼和浩特}
      strTem := ExlApp1.Cells.Item[2, 2];
      if Pos('交货日期', strTem) = 0 then
      begin
        ShowMessage('Excel文件格式不正确，请重新选择~');
        Result := False ;
        PbHide();
        Exit;
      end
      else
        Result := True ;
    
      if BoolFName then
        List.strListID := CopyStrBetween(UpperCase(ExtractFileName(strXlsFile)), '', '.XLS')
      else
        List.strListID := CopyStrBetween(strTem, '订单编号:', ' 交货日期:');

      List.strSDate := CopyStrBetween(strTem, '交货日期:', ' 安装地址');
      Date_Input := StrToDate(List.strSDate);
      for i := 0 to IntAddYear - 1 do Date_Input := IncYear(Date_Input, 1);
      List.strSDate := DateToStr(Date_Input);

      List.strAddress := CopyStrBetween(strTem, '安装地址:', ' ');

      //删除订单号相同的已有订单
      //F_List.ListDelete( List.strListID ) ;

      C_Index := -1;
      B_Index := -1;
      j := 3;
      SetLength(List.cab, 0);
      strTem := ExlApp1.Cells.Item[j, 1];
      while strTem <> '' do
      begin
        //如果col2为长*宽*高，则此列为空
        if VarToStr(ExlApp1.Cells.Item[j, 3]) = '' then
        begin
          {FAWCBDG-SMXG | 330*650*270 | 非标柜:双门下柜 数量:1}

          {FADG-SZZYXG | 非标柜(700*600*560):水槽下柜sc 数量:1}
          Inc(C_Index);
          SetLength(List.cab,C_Index + 1);
          with List.cab[C_Index] do
          begin
            List.cab[C_Index].CabID := strTem;
            List.cab[C_Index].cabW_H_D := ExlApp1.Cells.Item[j, 2];
            List.cab[C_Index].cabOth   := ExlApp1.Cells.Item[j, 4];
            List.cab[C_Index].Index    := C_Index;
            List.cab[C_Index].cabW     := StrToFloat(CopyStrBetween(cabW_H_D, '', '*'));
            List.cab[C_Index].cabH     := StrToFloat(CopyStrBetween(cabW_H_D, '*', '*'));
            List.cab[C_Index].cabD     := StrToFloat(CopyStrBetween(cabW_H_D, 2, '*', ''));
            List.cab[C_Index].cabType  := CopyStrBetween(cabOth, '', '*');
            List.cab[C_Index].cabName  := CopyStrBetween(cabOth, '非标柜:', ' 数量');
            List.cab[C_Index].cabNum   := StrToInt(CopyStrBetween(cabOth, '数量:', ''));
            List.cab[C_Index].cabC_W   := cabW * cabNum;
          end;

        end
        else
        begin
          //____________雅丽家地柜.煤气瓶柜.顶底板(封2边开)________________
          SetLength(List.cab[C_Index].bod, Length(List.cab[C_Index].bod) + 1);
          B_Index := Length(List.cab[C_Index].bod) - 1;
          List.cab[C_Index].cabBodNum := Length(List.cab[C_Index].bod);
          with List.cab[C_Index].bod[B_Index] do
          begin
            {6 | 593 | 343 | 2 | 是 | 10美杜沙金属烤漆 | 雅丽家地柜.双门下柜.门板(对开门) | 1-FAWCBDG-SMXG-MB1 | *1-FAWCBDG-SMXG-MB1*}
            List.cab[C_Index].bod[B_Index].bodOth   := VarToStr( ExlApp1.Cells.Item[j, 7] ); //备注
            List.cab[C_Index].bod[B_Index].bodType  := CopyStrBetween(bodOth , '' , '.' );
            List.cab[C_Index].bod[B_Index].cabNam   := CopyStrBetween(bodOth , '.' , '.' );
            List.cab[C_Index].bod[B_Index].bodName  := CopyStrBetween(bodOth , 2 , '.' , '(' );
            List.cab[C_Index].bod[B_Index].bodInfo  := CopyStrBetween(bodOth , '(' , ')' );
            List.cab[C_Index].bod[B_Index].Index    := StrToInt( ExlApp1.Cells.Item[j, 1] );			//标号
            List.cab[C_Index].bod[B_Index].bodH     := StrToFloat( ExlApp1.Cells.Item[j, 2] );			//长度
            List.cab[C_Index].bod[B_Index].bodW     := StrToFloat( ExlApp1.Cells.Item[j, 3] );			//宽度
            List.cab[C_Index].bod[B_Index].bodNum   := StrToInt( ExlApp1.Cells.Item[j, 4] );			//数量
            List.cab[C_Index].bod[B_Index].bodXZh   := VarToStr( ExlApp1.Cells.Item[j, 5] );			//旋转
            List.cab[C_Index].bod[B_Index].bodCZh   := VarToStr( ExlApp1.Cells.Item[j, 6] );			//材质
            List.cab[C_Index].bod[B_Index].bodFlag  := VarToStr( ExlApp1.Cells.Item[j, 8] );			//图号
            List.cab[C_Index].bod[B_Index].cabIndex := List.cab[C_Index].Index;
            List.cab[C_Index].bod[B_Index].bodID    := B_Index;
            if bodName = '门板' then List.CZhDoor := bodCZh;
            if bodName = '背板' then List.CZhBack := bodCZh;
            if (bodName = '侧板') OR (bodName = '底顶板')
              OR (bodName = '顶底板') OR (bodName = '隔板')
            then List.CZhBody := bodCZh;
          end;

        end;
        j := j + 1;
        strTem := ExlApp1.Cells.Item[j, 1];
      end;

      ExlApp1.Quit;
    except
      on e: Exception do
      begin
        ShowMessage('Excel文件格式不正确，请重新选择~' + #10#13 + e.Message);
        Result := False ;
        PbHide();
        ExlApp1.Quit;
      end;
    end;
    ExlApp1.Free;
    ExlWork1.Free;
    ExlSheet1.Free;
//  end;
end;

/// <summary>
/// 从excel读取五金信息
/// </summary>
/// <param name="strXlsFile"></param>
/// <returns></returns>
function  ReadHDwDataFromXLS( strXlsFile : string ): Boolean;   
var
  strSQL : string ;
  C_Index : Integer;
  H_Index : Integer;
  strTem : string;
  i , j , k : Integer ;
  Date_Input : TDate;
  ExlApp1: TExcelApplication;
  ExlWork1: TExcelWorkbook;
  ExlSheet1: TExcelWorksheet;
  AQry1: TADOQuery;
begin
  //导入五金数据
//  with D_ADO do
//  begin
    ExlApp1 := TExcelApplication.Create(nil);
    ExlWork1 := TExcelWorkbook.Create(nil);
    ExlSheet1 := TExcelWorksheet.Create(nil);
    AQry1 := TADOQuery.Create(nil);
    AQry1.ConnectionString := getConStr();

    try
      ExlApp1.Connect;
    except
      MessageDlg('没有安装Excel', mtError, [mbOk], 0);
      Abort;
      Result := False ;
      Exit ;
    end;
    try


      ExlApp1.Caption := 'Excel Application';
      ExlApp1.Workbooks.Open(strXlsFile, null, null, null, null, null,
        null, null, null, null, null, null, null, null, null, 0);

      strTem := ExlApp1.Cells.Item[2, 1];
      if Pos('交货日期', strTem) = 0 then
      begin
        ShowMessage('Excel文件格式不正确，请重新选择~');
        Result := False ;
        Exit;
      end
      else
        Result := True;

      {订单编号:DD20081219-1 交货日期:2008-12-19 安装地址:呼和浩特}
      if BoolFName then
        List.strListID := CopyStrBetween(UpperCase(ExtractFileName(strXlsFile)), '', 'WJ.XLS')
      else
        List.strListID := CopyStrBetween(strTem, '订单编号:', ' 交货日期:');

      strSDate := CopyStrBetween(strTem, '交货日期:', ' 安装地址');
      Date_Input := StrToDate(strSDate);
      for i := 0 to IntAddYear - 1 do Date_Input := IncYear(Date_Input, 1);
      List.strSDate := DateToStr(Date_Input);
      List.strAddress := CopyStrBetween(strTem, '安装地址:', ' ');

      strSQL := 'SELECT * FROM List WHERE ListID=''' + List.strListID + '''';
      if AQrySel( AQry1 , strSQL ) = 0 then
      begin
        ShowMessage('请先导入板材数据或选择正确的数据文件~');
        Exit;
      end;

      C_Index := -1;
      H_Index := -1;

      i := 0;
      j := 3;
			k := -1;     //hdID
      SetLength(List.cab, 0);
      strTem := ExlApp1.Cells.Item[j, 1];
      while strTem <> '' do
      begin

        if VarToStr(ExlApp1.Cells.Item[j, 3]) = '' then
        begin
          {FADG-SZZYXG | 非标柜(700*600*560):水槽下柜sc 数量:1}
          Inc(C_Index);
          SetLength(List.cab, C_Index + 1);

          with List.cab[C_Index] do
          begin
            List.cab[C_Index].CabID    := strTem;
            List.cab[C_Index].cabOth   := ExlApp1.Cells.Item[j, 2];
            List.cab[C_Index].cabW_H_D := (CopyStrBetween(cabOth, '(', ')'));
            List.cab[C_Index].Index    := C_Index;
            List.cab[C_Index].cabW     := StrToFloat(CopyStrBetween(cabW_H_D, '', '*'));
            List.cab[C_Index].cabH     := StrToFloat(CopyStrBetween(cabW_H_D, '*', '*'));
            List.cab[C_Index].cabD     := StrToFloat(CopyStrBetween(cabW_H_D, 2, '*', ''));
            List.cab[C_Index].cabType  := CopyStrBetween(cabOth, '', '(');
            List.cab[C_Index].cabName  := CopyStrBetween(cabOth, '):', ' 数量');
            List.cab[C_Index].cabNum   := StrToInt(CopyStrBetween(cabOth, '数量:', ''));
            List.cab[C_Index].cabC_W   := cabW * cabNum;
          end;

        end
        else
        begin
					Inc(k);
          SetLength(List.cab[C_Index].hdw, Length(List.cab[C_Index].hdw) + 1);
          H_Index := Length(List.cab[C_Index].hdw) - 1;
          List.cab[C_Index].cabhdwNum := Length(List.cab[C_Index].hdw);
          with List.cab[C_Index].hdw[H_Index] do
          begin
            {1-FASG-MYM-4*16LS | 4*16螺丝 | 8 | 五金 | 雅丽家上柜.百页门.4*16螺丝 | *1-FASG-MYM-4/16LS*}
            List.cab[C_Index].hdw[H_Index].hdOth    := VarToStr( ExlApp1.Cells.Item[j, 5] ); //备注
            List.cab[C_Index].hdw[H_Index].cabType  := CopyStrBetween(hdOth , '' , '.' );
            List.cab[C_Index].hdw[H_Index].cabNam   := CopyStrBetween(hdOth , '.' , '.' );
            List.cab[C_Index].hdw[H_Index].hdInfo   := CopyStrBetween(hdOth , '(' , ')' );
            List.cab[C_Index].hdw[H_Index].hdFlag   := VarToStr( ExlApp1.Cells.Item[j, 1] );			//图号
            List.cab[C_Index].hdw[H_Index].hdName   := VarToStr( ExlApp1.Cells.Item[j, 2] );			//名称
            List.cab[C_Index].hdw[H_Index].hdNum    := StrToInt( ExlApp1.Cells.Item[j, 3] );			//数量
            List.cab[C_Index].hdw[H_Index].strType  := VarToStr( ExlApp1.Cells.Item[j, 4] );			//类型
            List.cab[C_Index].hdw[H_Index].hdOth    := VarToStr( ExlApp1.Cells.Item[j, 5] );			//备注
            List.cab[C_Index].hdw[H_Index].cabIndex := List.cab[C_Index].Index;
            List.cab[C_Index].hdw[H_Index].hdID     := H_Index;
            List.cab[C_Index].hdw[H_Index].Index    := k;
          end;
        end;
        
        j := j + 1;
        strTem := VarToStr( ExlApp1.Cells.Item[j, 1] ) ;
      end;
      ExlApp1.Quit;
      
    except
      on e: Exception do
      begin
        ShowMessage('Excel文件格式不正确，请重新选择~' + #10#13 + e.Message);
        Result := False ;
        PbHide();
        ExlApp1.Quit;
      end;
    end;
    ExlApp1.Free;
    ExlWork1.Free;
    ExlSheet1.Free;
    AQry1.Free;
//  end;
end;

procedure ReadBodDataFromDB();
var
  strSQL : string;
  i : Integer;
  iLength : Integer;
	C_Index : Integer;
  B_Index : Integer;
  AQry1: TADOQuery;
begin
//  with D_ADO do
//  begin
    try
      AQry1 := TADOQuery.Create(nil);
      AQry1.ConnectionString := getConStr();
      strSQL := 'SELECT * FROM List WHERE ListID=''' + strListID + '''';
      AQrySel(AQry1, strSQL);
      List.Index := 0;
      List.strListID  := strListID ;
      List.strSDate   := FieldStr(AQry1, '交货日期');
      List.strAddress := FieldStr(AQry1, '安装地址');
      List.strUseName := FieldStr(AQry1, '客户姓名');
      List.strUsePho  := FieldStr(AQry1, '联系方式');
      List.CZhDoor    := FieldStr(AQry1, '门板材质');
      List.CZhBack    := FieldStr(AQry1, '背板材质');
      List.CZhBody    := FieldStr(AQry1, '柜体板材质');
      List.strFBGY    := FieldStr(AQry1, '封边工艺');
      strSQL := 'SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''' Order By CabIndex';
      iLength := AQrySel(AQry1, strSQL);
      if iLength = 0 then Exit;
      SetLength(List.cab, iLength );
      for i := 0 to AQry1.RecordCount - 1 do
      begin
        C_Index := i;
        List.cab[C_Index].Index 	 := AQry1.FieldValues['CabIndex'];
        List.cab[C_Index].CabID    := AQry1.FieldValues['CabID'];
        List.cab[C_Index].cabW_H_D := AQry1.FieldValues['尺寸'];
        List.cab[C_Index].cabOth   := AQry1.FieldValues['Oth'];
        List.cab[C_Index].cabW     := AQry1.FieldValues['W'];
        List.cab[C_Index].cabH     := AQry1.FieldValues['H'];
        List.cab[C_Index].cabD     := AQry1.FieldValues['L'];
        List.cab[C_Index].cabName  := AQry1.FieldValues['Nam'];
        List.cab[C_Index].cabNum   := AQry1.FieldValues['N'];
        iLength := FieldInt(AQry1, 'BodNum');
        SetLength(List.cab[i].bod, iLength);
        AQry1.Next;
      end;
    
      strSQL := 'SELECT * FROM TBod WHERE ListID=''' + List.strListID + ''' Order By BodIndex';
      AQrySel(AQry1, strSQL);
      for i := 0 to AQry1.RecordCount - 1 do
      begin

        C_Index := FieldInt(AQry1, 'CabIndex');
        B_Index := FieldInt(AQry1, 'BodID');
       
        List.cab[C_Index].bod[B_Index].Index 			:= FieldInt(AQry1, 'BodIndex'	);
        List.cab[C_Index].bod[B_Index].bodType 		:= FieldStr(AQry1, 'CabType'  	);
        List.cab[C_Index].bod[B_Index].cabNam  		:= FieldStr(AQry1, '用途'     );
        List.cab[C_Index].bod[B_Index].bodName 		:= FieldStr(AQry1, 'BodName'     );
        List.cab[C_Index].bod[B_Index].bodInfo 		:= FieldStr(AQry1, '括号'     );
        List.cab[C_Index].bod[B_Index].bodH    		:= FieldDob(AQry1, '长度'     );
        List.cab[C_Index].bod[B_Index].bodW    		:= FieldDob(AQry1, '宽度'     );
        List.cab[C_Index].bod[B_Index].bodNum     := FieldInt(AQry1, '数量'     );
        List.cab[C_Index].bod[B_Index].bodXZh     := FieldStr(AQry1, '旋转'     );
        List.cab[C_Index].bod[B_Index].bodCZh     := FieldStr(AQry1, '材质'     );
        List.cab[C_Index].bod[B_Index].bodOth  		:= FieldStr(AQry1, '备注'     );
        List.cab[C_Index].bod[B_Index].bodFlag    := FieldStr(AQry1, '图号'     );

        AQry1.Next;
      end;
    except
      on e: Exception do
      begin
        Send(e.Message);
      end;
    end;
    AQry1.Free;
//  end;
end;

procedure ReadhdwDataFromDB();
var
  strSQL : string;
  i : Integer;
  iLength : Integer;
	C_Index : Integer;
  H_Index : Integer;
  AQry1: TADOQuery;
begin
//  with D_ADO do
//  begin
    try
      AQry1 := TADOQuery.Create(nil);
      AQry1.ConnectionString := getConStr();
      strSQL := 'SELECT * FROM List WHERE ListID=''' + strListID + '''';
      AQrySel(AQry1, strSQL);
      List.Index := 0;
      List.strListID  := strListID ;
      List.strSDate   := FieldStr(AQry1, '交货日期');
      List.strAddress := FieldStr(AQry1, '安装地址');
      List.CZhDoor := FieldStr(AQry1, '门板材质');
      List.CZhBack := FieldStr(AQry1, '背板材质');
      List.CZhBody := FieldStr(AQry1, '柜体板材质');
      strSQL := 'SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''' Order By CabIndex';
      iLength := AQrySel(AQry1, strSQL);
      if iLength = 0 then Exit;
      SetLength(List.cab, iLength );
      for i := 0 to AQry1.RecordCount - 1 do
      begin
        C_Index := i;
        List.cab[C_Index].Index 	 := AQry1.FieldValues['CabIndex'];
        List.cab[C_Index].CabID    := AQry1.FieldValues['CabID'];
        List.cab[C_Index].cabW_H_D := AQry1.FieldValues['尺寸'];
        List.cab[C_Index].cabOth   := AQry1.FieldValues['Oth'];
        List.cab[C_Index].cabW     := AQry1.FieldValues['W'];
        List.cab[C_Index].cabH     := AQry1.FieldValues['H'];
        List.cab[C_Index].cabD     := AQry1.FieldValues['L'];
        List.cab[C_Index].cabName  := AQry1.FieldValues['Nam'];
        List.cab[C_Index].cabNum   := AQry1.FieldValues['N'];
        SetLength(List.cab[i].hdw, 0);
        AQry1.Next;
      end;
    
      strSQL := 'SELECT * FROM THDWare WHERE ListID=''' + List.strListID + ''' Order By HDIndex';
      AQrySel(AQry1, strSQL);
      for i := 0 to AQry1.RecordCount - 1 do
      begin
        C_Index := FieldInt(AQry1, 'CabIndex');
        H_Index := FieldInt(AQry1, 'hdID');
        if C_Index > Length(List.cab) - 1 then Exit;
        SetLength(List.cab[C_Index].hdw, Length(List.cab[C_Index].hdw) + 1);

        List.cab[C_Index].hdw[H_Index].Index 			:= FieldInt(AQry1, 'hdIndex'	);
        List.cab[C_Index].hdw[H_Index].hdName 		:= FieldStr(AQry1, 'Nam'     );
        List.cab[C_Index].hdw[H_Index].hdInfo 		:= FieldStr(AQry1, '工艺'     );
        List.cab[C_Index].hdw[H_Index].hdNum      := FieldInt(AQry1, '数量'     );
        List.cab[C_Index].hdw[H_Index].hdOth  		:= FieldStr(AQry1, 'Oth'     );
        List.cab[C_Index].hdw[H_Index].hdFlag     := FieldStr(AQry1, '图号'     );

        AQry1.Next;
      end;
    except
      on e: Exception do
      begin
        Send(e.Message);
      end;
    end;
    AQry1.Free;
//  end;
end;

/// <summary>
/// Save Board Data To Access DB
/// </summary>
procedure SaveBodDataToDB();
var
  strSQL : string;
  i , j : Integer;
  AQry1: TADOQuery;
begin
//  with D_ADO do
//  begin
    AQry1 := TADOQuery.Create(nil);
    AQry1.ConnectionString := getConStr();
    if List.strListID = '' then Exit;
    strListID := List.strListID;
    F_List.ListDelete(List.strListID);

    strSQL := 'INSERT INTO list('
    + 'ListID'    		+', '
    + '交货日期'			+', '
    + '安装地址'			+', '
    + '生产制作单'	 	+', '
    + '开料计划表'		+', '
    + '报价单'			  +', '
    + '门板材质'			+', '
    + '背板材质'			+', '
    + '柜体板材质'		+', '
    + '板材厚度'			+', '
    + '导入时间'			+'  '    
    + ') VALUES('
    + '''' + List.strListID 	+ ''' , '
    + '''' + List.strSDate		+ ''' , '
    + '''' + List.strAddress	+ ''' , '
    + '''' + strTabPrd			  + ''' , '
    + '''' + strTabPro			  + ''' , '
    + '''' + strTabPrc 		    + ''' , '
    + '''' + List.CZhDoor 	  + ''' , '
    + '''' + List.CZhBack 	  + ''' , '
    + '''' + List.CZhBody 	  + ''' , '
    +       ItoS(IntBodD)     + '   , '
    + '''' + sNow             + ''' ) ' ;

    AQryCmd(AQry1,strSQL);

    for i := 0 to Length(List.cab) - 1 do
    begin
      strSQL := 'INSERT INTO TCab('
      + 'ListID' 		+ ', '
      + 'CabIndex' 	+ ', '
      + 'CabID' 		+ ', '
      + '尺寸' 			+ ', '
      + 'oth' 			+ ', '
      + 'Nam' 			+ ', '
      + 'BodNum' 		+ ', '
      + 'H' 				+ ', '
      + 'W' 				+ ', '
      + 'L' 				+ ', '
      + 'C_W' 			+ ', '
      + 'N' 				+ '  '
      + ') VALUES('
      + '''' + List.strListID 									+ ''' , '
      + 			ItoS(List.cab[i].Index) 		+ '  , '
      + '''' + List.cab[i].cabID 					+ ''' , '
      + '''' + List.cab[i].cabW_H_D 				+ ''' , '
      + '''' + List.cab[i].cabOth 					+ ''' , '
      + '''' + List.cab[i].cabName 				+ ''' , '
      + 			ItoS(List.cab[i].cabBodNum) + '  , '
      + 			Dtos(List.cab[i].cabH) 			+ '  , '  				    //高
      + 			Dtos(List.cab[i].cabW) 			+ '  , ' 					    //宽
      + 			Dtos(List.cab[i].cabD) 			+ '  , ' 					    //深
      + 			Dtos(List.cab[i].cabC_W) 		+ '  , '
      + 			ItoS(List.cab[i].cabNum) 		+ '  ) ';   	    //数量
      AQryCmd(AQry1,strSQL);

      for j := 0 to Length(List.cab[i].bod) - 1 do
      begin
        strSQL := 'INSERT into TBod ('
        + 'BodIndex , '
        + 'CabIndex , '
        + 'BodID , '
        + 'CabTabID , '
        + 'CabID , '
        + 'BodName , '
        + 'CabType , '
        + '用途 , '
        + '括号 , '
        + 'CabWHD , '
        + '标号 , '
        + '长度 , '
        + '宽度 , '
        + '数量 , '
        + '旋转 , '
        + '材质 , '
        + '备注 , '
        + '图号 , '
        + '五金 , '
        + 'ListID '
        + ') VALUES( '
        + ' ' + IntToStr(List.cab[i].bod[j].Index) 			+ '  , '
        + ' ' + IntToStr(List.cab[i].Index) 						+ '  , '
        + ' ' + IntToStr(List.cab[i].bod[j].bodID) 			+ '  , '
        + ' ' + '90000'  																+ '  , '
        + '''' +	List.cab[i].cabID 										  + ''' , '
        + '''' + List.cab[i].bod[j].bodName   						+ ''' , '
        + '''' + List.cab[i].bod[j].bodType    					+ ''' , '
        + '''' + List.cab[i].bod[j].cabNam    						+ ''' , '
        + '''' + List.cab[i].bod[j].bodInfo      				+ ''' , '
        + '''' + List.cab[i].cabW_H_D      							+ ''' , '
        + ' ' + VarToStr( List.cab[i].bod[j].Index   ) 	+ '  , '
        + ' ' + VarToStr( List.cab[i].bod[j].bodH    ) 	+ '  , '
        + ' ' + VarToStr( List.cab[i].bod[j].bodW    ) 	+ '  , '
        + ' ' + VarToStr( List.cab[i].bod[j].bodNum  ) 	+ '  , '
        + '''' + VarToStr( List.cab[i].bod[j].bodXZh  ) 	+ ''' , '
        + '''' + VarToStr( List.cab[i].bod[j].bodCZh  ) 	+ ''' , '
        + '''' + VarToStr( List.cab[i].bod[j].bodOth  ) 	+ ''' , '
        + '''' + VarToStr( List.cab[i].bod[j].bodFlag ) 	+ ''' , '
        + '0 , '                        
        + '''' + List.strListID + ''' ) ' ;
        AQryCmd(AQry1, strSQL);

      end;

    end;
    AQry1.Free;
//  end;
end;

/// <summary>
/// Save HardWare Data to Access DB
/// </summary>
procedure SaveHDwDataToDB();
var
  strSQL : string ;
  i , j : Integer ;
  AQry1: TADOQuery;
begin
  //导入五金数据
//  with D_ADO do
//  begin
    AQry1 := TADOQuery.Create(nil);
    AQry1.ConnectionString := getConStr();
    strSQL := 'DELETE * FROM THDWare WHERE ListID=''' + List.strListID + '''';
    AQryCmd(AQry1, strSQL);
    
    for i := 0 to Length(List.cab) - 1 do
    begin
      for j := 0 to Length(List.cab[i].hdw) - 1 do
      begin
        with List.cab[i].hdw[j] do
        begin
          strSQL := 'INSERT Into THDWare('
          + 'ListID' 	 + ' , '
          + 'hdIndex'	 + ' , '
          + 'hdID'	 + ' , '
          + 'CabIndex' + ' , '	
          + '图号'		 + ' , '	
          + 'nam' 		 + ' , '	
          + '数量'		 + ' , '
          + '工艺'		 + ' , '	
          + 'oth' 		 + '   '
          +') VALUES('
          + '''' + List.strListID     + ''' , '
          + ''   + VarToStr(Index)    + '   , '
          + ''   + VarToStr(hdID)     + '   , '
          + ''   + VarToStr(cabIndex) + '   , '
          + '''' + hdFlag             + ''' , '
          + '''' + hdName             + ''' , '
          + ''   + IntToStr(hdNum)    + '   , '
          + '''' + hdInfo             + ''' , '
          + '''' + hdOth              + '''   '
          +')';

          AQryCmd(AQry1, strSQL);
          
        end;
      end;
    end;
    AQry1.Free;
//  end;
end;

/// <summary>
/// Save CaiZhi Data to Access DB
/// </summary>
procedure SaveCZhDataToDB();
var
  strSQL : string;
  AQry1: TADOQuery;
begin
  //保存新材质
//  with D_ADO do
//  begin
    AQry1 := TADOQuery.Create(nil);
    AQry1.ConnectionString := getConStr();
    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhDoor + '''';
    if AQrySel(AQry1, strSQL) = 0 then
    begin
      strSQL := 'INSERT Into TPrice(Nam,Unt,Type) VALUES(''' + List.CZhDoor + ''','''',1)';
      AQryCmd(AQry1, strSQL);
    end;

    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhBody + '''';
    if AQrySel(AQry1, strSQL) = 0 then
    begin
      strSQL := 'INSERT Into TPrice(Nam,Unt,Type) VALUES(''' + List.CZhBody + ''','''',1)';
      AQryCmd(AQry1, strSQL);
    end;

    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhBack + '''';
    if AQrySel(AQry1, strSQL) = 0 then
    begin
      strSQL := 'INSERT Into TPrice(Nam,Unt,Type) VALUES(''' + List.CZhBack + ''','''',1)';
      AQryCmd(AQry1, strSQL);
    end;
    AQry1.Free;
//  end;

end;

/// <summary>
/// 读取板材金额
/// </summary>
procedure ReadCZhPrc();
var
  strSQL : string;
  AQry1: TADOQuery;
begin
  //读取板材价格
//  with D_ADO do
//  begin
    AQry1 := TADOQuery.Create(nil);
    AQry1.ConnectionString := getConStr();
    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhDoor + '''';
    if AQrySel(AQry1, strSQL) > 0 then List.PrcDoor := FieldDob(AQry1, 'Prc')
    else List.PrcDoor := 0;

    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhBody + '''';
    if AQrySel(AQry1, strSQL) > 0 then List.PrcBody := FieldDob(AQry1, 'Prc')
    else List.PrcBody := 0;

    strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.CZhBack + '''';
    if AQrySel(AQry1, strSQL) > 0 then List.PrcBack := FieldDob(AQry1, 'Prc')
    else List.PrcBack := 0;
    AQry1.Free;
//  end;
end;

/// <summary>
/// 读取五金金额
/// </summary>
procedure ReadhdwPrc();
begin

end;

/// <summary>
/// 读取特殊加价公式及金额
/// </summary>
procedure ReadTsPrc();
var
  i : Integer;
  ado1: TADO;
begin
  ado1 := TADO.Create(nil);
  SetLength(List.tsPrc, 0);
  ado1.Sel('SELECT * FROM TPrice WHERE Type=3 AND chk=''True''');
  if ado1.RecordCount = 0 then Exit;
  SetLength(List.tsPrc, ado1.RecordCount);
  for i := 0 to ado1.RecordCount - 1 do
  begin
    List.tsPrc[i].Name := ado1.Fs('Nam');
    List.tsPrc[i].Prc  := ado1.Fd('Prc');
    List.tsPrc[i].GS   := ado1.Fs('Unt');
    ado1.Next;
  end;
  ado1.Free;
end;

/// <summary>
/// 统计板材面积和价格
/// </summary>
procedure Stat_BodAreaPrc();
var
  i, j: Integer;
  cab_B, cab_W : Integer;
begin
  cab_B := 0;
  cab_W := 0;
  List.NumDoor    := 0;
  List.NumBack    := 0;
  List.NumBody    := 0;
  List.NumCB      := 0;
  List.NumDDB     := 0;
  List.NumGB      := 0;
  List.NumQLT     := 0;
  List.NumHLT     := 0;
  List.NumFJB     := 0;
  List.AreaDoor   := 0;
  List.AreaBack   := 0;
  List.AreaBody   := 0;
  List.SumPrcDoor := 0;
  List.SumPrcBody := 0;
  List.SumPrcBack := 0;
  List.SumPrcBod  := 0;
  List.SumPrcHD_  := 0;
  SetLength(List.cabPrd , 0);
  SetLength(List.hdwPrc , 0);

  for i := 0 to Length(List.cab) - 1 do
  begin
    List.cab[i].cabNDoor := 0 ;
    List.cab[i].cabNBack := 0 ;
    List.cab[i].cabNBody := 0 ;
    List.cab[i].AreaDoor := 0 ;
    List.cab[i].AreaBack := 0 ;
    List.cab[i].AreaBody := 0 ;

    for j := 0 to Length(List.cab[i].bod) - 1 do
    begin
      with List.cab[i].bod[j] do
      begin
        if bodName = '门板' then
        begin
          Inc(List.cab[i].cabNDoor, bodNum);
          List.cab[i].AreaDoor := List.cab[i].AreaDoor + ( (bodH + (2 * fbDoor)) * (bodW + (2 * fbDoor)) * bodNum / 1000000 ) ;
        end
        else if bodName = '背板' then
        begin
          Inc(List.cab[i].cabNBack, bodNum);
          List.cab[i].AreaBack := List.cab[i].AreaBack + (bodH + 2 * fbBack) * (bodW + 2 * fbBack) * bodNum / 1000000;

        end
        else
        begin
          Inc(List.cab[i].cabNBody, bodNum);
          List.cab[i].AreaBody := List.cab[i].AreaBody + (bodH + 2 * fbBody) * (bodW + 2 * fbBody) * bodNum / 1000000;

          if bodName = '侧板' then
          begin
            Inc(List.cab[i].cabNCB, bodNum);
            Inc(List.NumCB, bodNum);
          end
          else if (bodName = '底顶板') OR (bodName = '顶底板') OR (bodName = '底板') OR (bodName = '顶板') then
          begin
            Inc(List.cab[i].cabNDDB, bodNum);
            Inc(List.NumDDB, bodNum);

            if (bodName = '底顶板') OR (bodName = '顶底板') OR (bodName = '底板') then
            begin
              Inc(List.cab[i].cabNBUp, bodNum);
              Inc(List.NumBUp, bodNum);
            end
            else if (bodName = '顶板') then
            begin
              Inc(List.cab[i].cabNBDown, bodNum);
              Inc(List.NumBDown, bodNum);
            end
          end
          else if (bodName = '拉条') OR (bodName = '前拉条') OR (bodName = '后拉条') then
          begin
            Inc(List.cab[i].cabNLT, bodNum);
            Inc(List.NumLT, bodNum);

            if (bodName = '拉条') OR (bodName = '前拉条') then
            begin
              Inc(List.cab[i].cabNFLT, bodNum);
              Inc(List.NumQLT, bodNum);
            end
            else if bodName = '后拉条' then
            begin
              Inc(List.cab[i].cabNBLT, bodNum);
              Inc(List.NumHLT, bodNum);
            end;
          end
          else if (bodName = '隔板') OR (bodName = '搁板') OR (bodName = '活隔') then
          begin
            Inc(List.cab[i].cabNGB, bodNum);
            Inc(List.NumGB, bodNum);
            List.cab[i].cabGB :='有隔';
          end
          else if (bodName = '固隔') then
          begin
            Inc(List.cab[i].cabNGB_G, bodNum);
            Inc(List.NumGB_G, bodNum);
            List.cab[i].cabGB :='有隔';
          end
          else
          begin
            Inc(List.cab[i].cabNFJB, bodNum);
            Inc(List.NumFJB, bodNum);
          end;
        end;
        
        if Pos('上柜', bodOth) > 0 then
        begin
          List.cab[i].cabTypeID := 'W';
        end
        else
        begin
          List.cab[i].cabTypeID := 'B';
        end;

      end;
    end;

    if List.cab[i].cabTypeID = 'W' then
    begin
      Inc(cab_B);
      List.cab[i].cabTypeID := 'W' + IntToStr(cab_B);
    end
    else
    begin
      Inc(cab_W);
      List.cab[i].cabTypeID := 'B' + IntToStr(cab_W);
    end;

    if List.cab[i].cabGB = '' then List.cab[i].cabGB := '无隔';

    Inc(List.NumDoor, List.cab[i].cabNDoor);
    Inc(List.NumBody, List.cab[i].cabNBody);
    Inc(List.NumBack, List.cab[i].cabNBack);

    List.cab[i].PrcDoor := List.cab[i].AreaDoor * List.PrcDoor;
    List.cab[i].PrcBack := List.cab[i].AreaBack * List.PrcBack;
    List.cab[i].PrcBody := List.cab[i].AreaBody * List.PrcBody;

    List.AreaDoor := List.AreaDoor + List.cab[i].AreaDoor;
    List.AreaBack := List.AreaBack + List.cab[i].AreaBack;
    List.AreaBody := List.AreaBody + List.cab[i].AreaBody;
  end;

  List.SumPrcDoor := List.AreaDoor * List.PrcDoor;
  List.SumPrcBack := List.AreaBack * List.PrcBack;
  List.SumPrcBody := List.AreaBody * List.PrcBody;
  List.SumPrcBod := List.SumPrcDoor + List.SumPrcBack + List.SumPrcBody;

end;

/// <summary>
/// 统计标签数据
/// </summary>
procedure Stat_BodLab();
var
  i , j , k: Integer;
  n : Integer;
  temBodLab : T_BodLab;
  temBodLabs : array of T_BodLab;
begin
  k := 0;
  //赋值
  SetLength(List.bodLab, 0);
  for i := 0 to Length(List.cab) - 1 do
  begin
    for j := 0 to Length(List.cab[i].bod) - 1 do
    begin
      with List.cab[i], bod[j] do
      begin
        n := Length(List.bodLab);
        SetLength(List.bodLab, n + 1);
        List.bodLab[n].Index     := k;
        List.bodLab[n].cabID     := cabID;
        List.bodLab[n].cabName   := cabNam;
        List.bodLab[n].cabTypeID := cabTypeID;
        List.bodLab[n].cabW_H_D  := cabW_H_D;
        List.bodLab[n].bodID     := bodID;
        List.bodLab[n].bodName   := bodName;
        List.bodLab[n].bodCZh    := bodCZh;
        List.bodLab[n].bodInfo   := bodInfo;
        List.bodLab[n].bodNum    := bodNum;
        List.bodLab[n].bodH      := bodH;
        List.bodLab[n].bodW      := bodW;
        Inc(k);
      end;
    end;
  end;
  //排序
  for i := 0 to Length(List.bodLab) - 2 do
  begin
    for j := 0 to Length(List.bodLab) - 2 do
    begin
      // if 'W' > 'H'
      if (List.bodLab[j].bodH > List.bodLab[j + 1].bodH)
        OR ((List.bodLab[j].bodH = List.bodLab[j + 1].bodH)
        AND (List.bodLab[j].bodW > List.bodLab[j + 1].bodW)) then
      begin
        temBodLab := List.bodLab[j];
        List.bodLab[j] := List.bodLab[j + 1];
        List.bodLab[j + 1] := temBodLab;
      end;
    end;
  end;

  {for i := 0 to Length(List.bodLab) - 1 do
  begin
    with List.bodLab[i] do
    begin
      Send(DtoS(bodH) + ' , ' + Dtos(bodW) + ' , ' + bodName);
    end;
  end; }

  //统计
  for i := 0 to Length(List.bodLab) - 1 do
  begin
    for j := 0 to Length(List.bodLab) - 1 do
    begin
      if (List.bodLab[i].bodCZh = List.bodLab[j].bodCZh)
      AND (List.bodLab[i].bodH = List.bodLab[j].bodH)
      AND (List.bodLab[i].bodW = List.bodLab[j].bodW) then
      begin
        List.bodLab[i].bodCount := List.bodLab[i].bodCount + List.bodLab[j].bodNum;
      end;
    end;
  end;

  //分组
  SetLength(List.bodLabs.DoorLabs, 0);
  SetLength(List.bodLabs.BodyLabs, 0);
  SetLength(List.bodLabs.BackLabs, 0);
  for i := 0 to Length(List.bodLab) - 1 do
  begin
    if Pos('门板', List.bodLab[i].bodName) > 0 then
    begin
      for j := 0 to List.bodLab[i].bodNum - 1 do
      begin
        n := Length(List.bodLabs.DoorLabs);
        SetLength(List.bodLabs.DoorLabs, n + 1);
        if (n > 0)
        AND (List.bodLabs.DoorLabs[n - 1].bodH = List.bodLab[i].bodH)
        AND (List.bodLabs.DoorLabs[n - 1].bodW = List.bodLab[i].bodW)
        then k := List.bodLabs.DoorLabs[n - 1].labIndex + 1
        else k := 1;

        with List.bodLabs.DoorLabs[n] do
        begin
          labIndex  := k;
          cabID     := List.bodLab[i].cabID;
          cabName   := List.bodLab[i].cabName;
          cabTypeID := List.bodLab[i].cabTypeID;
          cabW_H_D  := List.bodLab[i].cabW_H_D;
          bodID     := List.bodLab[i].bodID;
          bodName   := List.bodLab[i].bodName;
          bodCZh    := List.bodLab[i].bodCZh;
          bodInfo   := List.bodLab[i].bodInfo;
          bodNum    := List.bodLab[i].bodNum;
          bodH      := List.bodLab[i].bodH;
          bodW      := List.bodLab[i].bodW;
          bodCount  := List.bodLab[i].bodCount;
        end;
      end;
    end
    else if Pos('背板', List.bodLab[i].bodName) > 0 then
    begin
      for j := 0 to List.bodLab[i].bodNum - 1 do
      begin
        n := Length(List.bodLabs.BackLabs);
        SetLength(List.bodLabs.BackLabs, n + 1);
        if (n > 0)
        AND (List.bodLabs.BackLabs[n - 1].bodH = List.bodLab[i].bodH)
        AND (List.bodLabs.BackLabs[n - 1].bodW = List.bodLab[i].bodW)
        then k := List.bodLabs.BackLabs[n - 1].labIndex + 1
        else k := 1;
        
        with List.bodLabs.BackLabs[n] do
        begin
          labIndex  := k;
          cabID     := List.bodLab[i].cabID;
          cabName   := List.bodLab[i].cabName;
          cabTypeID := List.bodLab[i].cabTypeID;
          cabW_H_D  := List.bodLab[i].cabW_H_D;
          bodID     := List.bodLab[i].bodID;
          bodName   := List.bodLab[i].bodName;
          bodCZh    := List.bodLab[i].bodCZh;
          bodInfo   := List.bodLab[i].bodInfo;
          bodNum    := List.bodLab[i].bodNum;
          bodH      := List.bodLab[i].bodH;
          bodW      := List.bodLab[i].bodW;
          bodCount  := List.bodLab[i].bodCount;
        end;
      end;
    end
    else
    begin
      for j := 0 to List.bodLab[i].bodNum - 1 do
      begin
        n := Length(List.bodLabs.BodyLabs);
        SetLength(List.bodLabs.BodyLabs, n + 1);
        if (n > 0)
        AND (List.bodLabs.BodyLabs[n - 1].bodH = List.bodLab[i].bodH)
        AND (List.bodLabs.BodyLabs[n - 1].bodW = List.bodLab[i].bodW)
        then k := List.bodLabs.BodyLabs[n - 1].labIndex + 1
        else k := 1;
        
        with List.bodLabs.BodyLabs[n] do
        begin
          labIndex  := k;
          cabID     := List.bodLab[i].cabID;
          cabName   := List.bodLab[i].cabName;
          cabTypeID := List.bodLab[i].cabTypeID;
          cabW_H_D  := List.bodLab[i].cabW_H_D;
          bodID     := List.bodLab[i].bodID;
          bodName   := List.bodLab[i].bodName;
          bodCZh    := List.bodLab[i].bodCZh;
          bodInfo   := List.bodLab[i].bodInfo;
          bodNum    := List.bodLab[i].bodNum;
          bodH      := List.bodLab[i].bodH;
          bodW      := List.bodLab[i].bodW;
          bodCount  := List.bodLab[i].bodCount;
        end;
      end;
    end;

  end;
end;

/// <summary>
/// 统计生产制作单
/// </summary>
procedure Stat_BodPrd();
var
  i, j, k, l: Integer;
  tem_cabPrd : T_CabPrd;
  cutBod : Double;
begin
  BoolMQPG := False;
  BoolQJG  := False;
  SetLength(List.cabPrd, 0);
  SetLength(List.cabDrawer, 0);                                                 //设置抽屉数量为0
  SetLength(List.cabPrd, Length(List.cab));
  SetLength(List.cabPrdOth.NameBG, 0);
  SetLength(List.cabPrdOth.NameDT, 0);
  SetLength(List.cabPrdOth.NameFB, 0);
  SetLength(List.cabPrdOth.NameFL, 0);
  SetLength(List.cabPrdOth.NumBG, 0);
  SetLength(List.cabPrdOth.NumDT, 0);
  SetLength(List.cabPrdOth.NumFB, 0);
  SetLength(List.cabPrdOth.NumFL, 0);
  SetLength(List.cabPrdOth.sizeDT, 0);
  SetLength(List.cabPrdOth.sizeBG, 0);
  SetLength(List.cabPrdOth.sizeFB, 0);
  SetLength(List.cabPrdOth.sizeFL, 0);
  List.cabPrdOth.showPrdOth := False;

  for i := 0 to Length(List.cab) - 1 do
  begin
    List.cabPrd[i].cabIndex  := List.cab[i].Index;
    List.cabPrd[i].cabName   := List.cab[i].cabName;
    List.cabPrd[i].cabW_H_D  := List.cab[i].cabW_H_D;
    List.cabPrd[i].cabD      := List.cab[i].cabD;
    List.cabPrd[i].cabTypeID := List.cab[i].cabTypeID;
    List.cabPrd[i].TabH      := 2;
    List.cabPrd[i].cabNum    := List.cab[i].cabNum;
    List.cabPrd[i].cutType   := CUT_NIL;
    List.cabPrd[i].showCab   := True;
    List.cabPrd[i].cut_GB    := False;
    if Pos('煤气瓶' ,List.cabprd[i].cabName) > 0 then
    begin
      BoolMQPG := True;
      List.cabPrd[i].cutType := CUT_MQP;
    end;
    if Pos('包管' ,List.cab[i].cabName) > 0 then
    begin
      for k := 0 to Length(List.cab[i].bod) - 1 do
      begin
        j := Length(List.cabPrdOth.NumBG);
        SetLength(List.cabPrdOth.NameBG, j + 1);
        SetLength(List.cabPrdOth.NumBG,  j + 1);
        SetLength(List.cabPrdOth.sizeBG, j + 1);
        List.cabPrdOth.NameBG[j] := List.cab[i].cabName;
        List.cabPrdOth.NumBG[j]  := List.cab[i].bod[k].bodNum;
        List.cabPrdOth.sizeBG[j] := Dtos(List.cab[i].bod[k].bodH) + '*' + Dtos(List.cab[i].bod[k].bodW);
        List.cabPrd[i].showCab := False;
        List.cabPrdOth.showPrdOth := True;
        if j + 1 > List.cabPrdOth.rowCount then List.cabPrdOth.rowCount := j + 1;
      end;
    end;
    if Pos('垫条' ,List.cab[i].cabName) > 0 then
    begin
      for k := 0 to Length(List.cab[i].bod) - 1 do
      begin
        j := Length(List.cabPrdOth.NumDT);
        SetLength(List.cabPrdOth.NameDT, j + 1);
        SetLength(List.cabPrdOth.NumDT,  j + 1);
        SetLength(List.cabPrdOth.sizeDT, j + 1);
        List.cabPrdOth.NameDT[j] := List.cab[i].cabName;
        List.cabPrdOth.NumDT[j]  := List.cab[i].bod[k].bodNum;
        List.cabPrdOth.sizeDT[j] := Dtos(List.cab[i].bod[k].bodH) + '*' + Dtos(List.cab[i].bod[k].bodW);
        List.cabPrd[i].showCab := False;
        List.cabPrdOth.showPrdOth := True;
        if j + 1 > List.cabPrdOth.rowCount then List.cabPrdOth.rowCount := j + 1;
      end;
    end;
    if Pos('封板' ,List.cab[i].cabName) > 0 then
    begin
      for k := 0 to Length(List.cab[i].bod) - 1 do
      begin
        j := Length(List.cabPrdOth.NumFB);
        SetLength(List.cabPrdOth.NameFB, j + 1);
        SetLength(List.cabPrdOth.NumFB,  j + 1);
        SetLength(List.cabPrdOth.sizeFB, j + 1);
        List.cabPrdOth.NameFB[j] := List.cab[i].cabName;
        List.cabPrdOth.NumFB[j]  := List.cab[i].bod[k].bodNum;
        List.cabPrdOth.sizeFB[j] := Dtos(List.cab[i].bod[k].bodH) + '*' + Dtos(List.cab[i].bod[k].bodW);
        List.cabPrd[i].showCab := False;
        List.cabPrdOth.showPrdOth := True;
        if j + 1 > List.cabPrdOth.rowCount then List.cabPrdOth.rowCount := j + 1;
      end;
    end;
    if Pos('辅料' ,List.cab[i].cabName) > 0 then
    begin
      for k := 0 to Length(List.cab[i].bod) - 1 do
      begin
        j := Length(List.cabPrdOth.NumFL);
        SetLength(List.cabPrdOth.NameFB, j + 1);
        SetLength(List.cabPrdOth.NumFL,  j + 1);
        SetLength(List.cabPrdOth.sizeFL, j + 1);
        List.cabPrdOth.NameFB[j] := List.cab[i].cabName;
        List.cabPrdOth.NumFL[j]  := List.cab[i].bod[k].bodNum;
        List.cabPrdOth.sizeFL[j] := Dtos(List.cab[i].bod[k].bodH) + '*' + Dtos(List.cab[i].bod[k].bodW);
        List.cabPrd[i].showCab := False;
        List.cabPrdOth.showPrdOth := True;
        if j + 1 > List.cabPrdOth.rowCount then List.cabPrdOth.rowCount := j + 1;
      end;
    end;

    if Pos('抽屉', List.cab[i].cabName) > 0 then
    begin
      EnterMethod(List.cab[i].cabName);
      j := Length(List.cabDrawer);
      SetLength(List.cabDrawer, j+1);
      List.cabDrawer[j].Name := List.cab[i].cabName;
      for k := 0 to Length(List.cab[i].bod) - 1 do
      begin
        with List.cab[i].bod[k] do
        begin
          if Pos('抽邦', bodName) > 0 then
          begin
            List.cabDrawer[j].ChBang := List.cabDrawer[j].ChBang
              + FloatToStr(bodH) + '*' + FloatToStr(bodW) + '*' + FloatToStr(bodNum);
          end
          else
          if Pos('抽尾', bodName) > 0 then
          begin
            List.cabDrawer[j].ChWei := List.cabDrawer[j].ChWei
              + FloatToStr(bodH) + '*' + FloatToStr(bodW) + '*' + FloatToStr(bodNum);
          end
          else
          if Pos('抽底', bodName) > 0 then
          begin
            List.cabDrawer[j].ChDi := List.cabDrawer[j].ChDi
              + FloatToStr(bodH) + '*' + FloatToStr(bodW) + '*' + FloatToStr(bodNum);
          end;
        end;


      end;
      ExitMethod(List.cab[i].cabName);
    end;

    for j := 0 to Length(List.cab[i].bod) - 1 do
    begin
      with List.cab[i].bod[j] do
      begin
        if bodName = '门板' then
        begin
          k := Length(List.cabPrd[i].bodDoor);
          SetLength(List.cabPrd[i].bodDoor, k + 1);
          List.cabPrd[i].bodDoor[k] := VarToStr(bodW + fbDoor * 2) + '×' + VarToStr(bodH + fbDoor * 2) + '=' + VarToStr(bodNum);
          if bodInfo <> '' then
          begin
            k := Length(List.cabPrd[i].bodDoor);
            SetLength(List.cabPrd[i].bodDoor, k + 1);
            List.cabPrd[i].bodDoor[k] := bodInfo ;
          end;
          if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
        end
        else if bodName = '背板' then
        begin
          k := Length(List.cabPrd[i].bodBack);
          SetLength(List.cabPrd[i].bodBack, k + 1);
          List.cabPrd[i].bodBack[k] := VarToStr(bodW) + '×' + VarToStr(bodH) + '=' + VarToStr(bodNum);
          if bodInfo <> '' then
          begin
            k := Length(List.cabPrd[i].bodBack);
            SetLength(List.cabPrd[i].bodBack, k + 1);
            List.cabPrd[i].bodBack[k] := bodInfo ;
          end;
          if Pos('起始宽度', bodInfo) > 0 then
          begin
            List.cabPrd[i].cutC := bodW;
          end;
          if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
        end
        else
        begin
          if bodName = '侧板' then
          begin
            k := Length(List.cabPrd[i].bodCB);
            SetLength(List.cabPrd[i].bodCB, k + 1);
            List.cabPrd[i].bodCB[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
            if bodInfo <> '' then
            begin
              k := Length(List.cabPrd[i].bodCB);
              SetLength(List.cabPrd[i].bodCB, k + 1);
              List.cabPrd[i].bodCB[k] := bodInfo ;
            end;
            if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
          end
          else if (bodName = '底顶板') OR (bodName = '顶底板') OR (bodName = '底板') OR (bodName = '顶板') then
          begin
            k := Length(List.cabPrd[i].bodDDB);
            SetLength(List.cabPrd[i].bodDDB, k + 1);
            List.cabPrd[i].bodDDB[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
            if bodInfo <> '' then
            begin
              k := Length(List.cabPrd[i].bodDDB);
              SetLength(List.cabPrd[i].bodDDB, k + 1);
              List.cabPrd[i].bodDDB[k] := bodInfo ;
            end;
            //if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;

            if (bodName = '底顶板') OR (bodName = '顶底板') OR (bodName = '底板') then
            begin
              k := Length(List.cabPrd[i].bodBUp);
              SetLength(List.cabPrd[i].bodBUp, k + 1);
              List.cabPrd[i].bodBUp[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
              if bodInfo <> '' then
              begin
                k := Length(List.cabPrd[i].bodBUp);
                SetLength(List.cabPrd[i].bodBUp, k + 1);
                List.cabPrd[i].bodBUp[k] := bodInfo ;
              end;
              if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
            end
            else if (bodName = '顶板') then
            begin
              k := Length(List.cabPrd[i].bodBDown);
              SetLength(List.cabPrd[i].bodBDown, k + 1);
              List.cabPrd[i].bodBDown[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
              if bodInfo <> '' then
              begin
                k := Length(List.cabPrd[i].bodBDown);
                SetLength(List.cabPrd[i].bodBDown, k + 1);
                List.cabPrd[i].bodBDown[k] := bodInfo ;
              end;
              if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
            end
          end
          else if (bodName = '拉条') OR (bodName = '前拉条') OR (bodName = '后拉条') then
          begin
            k := Length(List.cabPrd[i].bodLT);
            SetLength(List.cabPrd[i].bodLT, k + 1);
            List.cabPrd[i].bodLT[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
            if bodInfo <> '' then
            begin
              k := Length(List.cabPrd[i].bodLT);
              SetLength(List.cabPrd[i].bodLT, k + 1);
              List.cabPrd[i].bodLT[k] := bodInfo ;
            end;
            if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;

            if (bodName = '拉条') OR (bodName = '前拉条') then
            begin
              k := Length(List.cabPrd[i].bodQLT);
              SetLength(List.cabPrd[i].bodQLT, k + 1);
              List.cabPrd[i].bodQLT[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
              if bodInfo <> '' then
              begin
                k := Length(List.cabPrd[i].bodQLT);
                SetLength(List.cabPrd[i].bodQLT, k + 1);
                List.cabPrd[i].bodQLT[k] := bodInfo ;
              end;
              if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
            end;
            if bodName = '后拉条' then
            begin
              k := Length(List.cabPrd[i].bodHLT);
              SetLength(List.cabPrd[i].bodHLT, k + 1);
              List.cabPrd[i].bodHLT[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
              if bodInfo <> '' then
              begin
                k := Length(List.cabPrd[i].bodHLT);
                SetLength(List.cabPrd[i].bodHLT, k + 1);
                List.cabPrd[i].bodHLT[k] := bodInfo ;
              end;
              if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
            end;
          end
          else if (bodName = '隔板') OR (bodName = '搁板') OR (bodName = '活隔') then
          begin
            k := Length(List.cabPrd[i].bodGB);
            SetLength(List.cabPrd[i].bodGB, k + 1);
            List.cabPrd[i].bodGB[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
            if bodInfo <> '' then
            begin
              k := Length(List.cabPrd[i].bodGB);
              SetLength(List.cabPrd[i].bodGB, k + 1);
              List.cabPrd[i].bodGB[k] := bodInfo ;
            end;
            if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
            //有隔板
            List.cabPrd[i].cut_GB := True;
          end
          else if (bodName = '固隔') then
          begin
            k := Length(List.cabPrd[i].bodGB_G);
            SetLength(List.cabPrd[i].bodGB_G, k + 1);
            List.cabPrd[i].bodGB_G[k] := VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
            if bodInfo <> '' then
            begin
              k := Length(List.cabPrd[i].bodGB_G);
              SetLength(List.cabPrd[i].bodGB_G, k + 1);
              List.cabPrd[i].bodGB_G[k] := bodInfo ;
            end;
            if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
            //有隔板
            List.cabPrd[i].cut_GB := True;
          end
          else
          begin
            //附加板
            k := Length(List.cabPrd[i].bodFJB);
            SetLength(List.cabPrd[i].bodFJB, k + 1);
            List.cabPrd[i].bodFJB[k] := bodName + ':' + VarToStr(bodW + fbBody * 2) + '×' + VarToStr(bodH + fbBody * 2) + '=' + VarToStr(bodNum);
            if bodInfo <> '' then
            begin
              k := Length(List.cabPrd[i].bodFJB);
              SetLength(List.cabPrd[i].bodFJB, k + 1);
              List.cabPrd[i].bodFJB[k] := bodInfo ;
            end;

            if bodName = '切角板' then
            begin
              if Pos('中切角', bodType) > 0 then
                List.cabPrd[i].cutType := CUT_ZQJ
              else
                List.cabPrd[i].cutType := CUT_QJ;

              if bodW > bodH then cutBod := bodH
              else cutBod := bodW;

              if (Pos('开', bodInfo) > 0) AND (List.cabPrd[i].cutA = 0) then
              begin
                List.cabPrd[i].cutA    := cutBod;
                List.cabPrd[i].cutGB_A := cutBod;
              end
              else if List.cabPrd[i].cutB = 0 then
              begin
                List.cabPrd[i].cutB    := cutBod;
                List.cabPrd[i].cutGB_B := cutBod;
              end
              else
              begin
                List.cabPrd[i].cutA    := cutBod;
                List.cabPrd[i].cutGB_A := cutBod;
              end;

              BoolQJG := True;

            end
            else if bodName = '挖角板' then
            begin
              //区分上柜，下柜
              if Pos('上', bodType) > 0 then
                List.cabPrd[i].cutType := CUT_SWJ
              else
                List.cabPrd[i].cutType := CUT_XWJ;

              if (Pos('开', bodInfo) > 0) AND (List.cabPrd[i].cutB = 0) then
                List.cabPrd[i].cutB := cutBod
              else if List.cabPrd[i].cutA = 0 then
                List.cabPrd[i].cutA := cutBod
              else
                List.cabPrd[i].cutB := cutBod;

              BoolQJG := True;

            end;

            if List.cabPrd[i].TabH - 1 < k then List.cabPrd[i].TabH := k + 1;
          end;
        end;


      end;
    end;


  end;

  //对橱柜进行排序
  //按上下柜尺寸排序
  if ptType = 1 then
  for i := 0 to Length(List.cabPrd) - 2 do
  begin
    for j := 0 to Length(List.cabPrd) - 2 do
    begin
      if List.cabPrd[j].cabD < List.cabPrd[j + 1].cabD then
      begin
        tem_cabPrd := List.cabPrd[j];
        List.cabPrd[j] := List.cabprd[j + 1];
        List.cabPrd[j + 1] := tem_cabPrd;
      end;
    end;
  end
  //按上下柜名称排序
  else if ptType = 2 then
  for i := 0 to Length(List.cabPrd) - 2 do
  begin
    for j := 0 to Length(List.cabPrd) - 2 do
    begin
      // if 'W' > 'B'
      if Copy(List.cabPrd[j].cabTypeID, 0, 1) > Copy(List.cabPrd[j + 1].cabTypeID, 0, 1) then
      begin
        tem_cabPrd := List.cabPrd[j];
        List.cabPrd[j] := List.cabprd[j + 1];
        List.cabPrd[j + 1] := tem_cabPrd;
      end;
    end;
  end;

end;

/// <summary>
/// 统计报价单数据
/// </summary>
procedure Stat_hdwPrc();
var
  i, j, k: Integer;
  Bchk_hdw: Boolean;
  strSQL : string;
  AQry1: TADOQuery;
begin
  AQry1 := TADOQuery.Create(nil);
  AQry1.ConnectionString := getConStr();
  for i := 0 to Length(List.cab) - 1 do
  begin
    for j := 0 to Length(List.cab[i].hdw) - 1 do
    begin
      Bchk_hdw := False;
      for k := 0 to Length(List.hdwPrc) - 1 do
      begin
        if List.hdwPrc[k].hdName = List.cab[i].hdw[j].hdName then
        begin
          Bchk_hdw := True;
          Break;
        end;
      end;

      if Bchk_hdw = True then
      begin
        List.hdwPrc[k].hdNum := List.hdwPrc[k].hdNum + List.cab[i].hdw[j].hdNum;
      end
      else
      begin
        k := Length(List.hdwPrc);
        SetLength(List.hdwPrc, k + 1);
        List.hdwPrc[k].Index := k;
        List.hdwPrc[k].hdName := List.cab[i].hdw[j].hdName;
        List.hdwPrc[k].hdNum := List.cab[i].hdw[j].hdNum;
      end;

    end;
  end;

  List.SumPrcHD_ := 0;
  for i := 0 to Length(List.hdwPrc) - 1 do
  begin
    with List.hdwPrc[i] do
    begin
      strSQL := 'SELECT * FROM TPrice WHERE Nam=''' + List.hdwPrc[i].hdName + ''' AND chk=''True'' ;';
      if AQrySel(AQry1, strSQL) > 0 then
        List.hdwPrc[i].hdPrice := StrToFloat(AQry1.FieldValues['prc'])
      else
        List.hdwPrc[i].hdPrice := 0;

      List.hdwPrc[i].hdSumPrice := hdPrice * hdNum;
      List.SumPrcHD_ := List.SumPrcHD_ + List.hdwPrc[i].hdSumPrice;
    end;
  end;

  AQry1.Free;
end;

/// <summary>
/// 过滤标准件
/// </summary>
procedure setBodStandard(listID: string);
var
  ado1: TADO;
  strSQL : string;
  i: Integer;
begin
  EnterMethod('统计标准件');
  ado1 := TADO.Create(nil);

  strSQL := 'UPDATE TBod SET 标准件='''' WHERE ListID=''' + listID + '''';
  ado1.Cmd(strSQL);

  strSQL := 'UPDATE TBod SET 标准件=''是'' WHERE ListID=''' + listID + ''' AND ID IN (' + crlf
    + 'SELECT A.ID FROM TBod A,TBod_Standard B WHERE A.ListID=''' + ListID + ''' '
    + 'AND A.BodName=B.[Name] AND A.长度=B.H '
    + 'AND A.宽度=B.W AND A.材质=B.CZh AND A.括号=B.GYi ) ';
  Send(strSQL);
  i := ado1.Cmd(strSQL);
  Send('更新记录数量：' + IntToStr(i));

  ado1.Free;
  ExitMethod('统计标准件');
end;

end.










