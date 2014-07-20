unit UPub;

interface
uses
  IniFiles, Windows, SysUtils, CodeSiteLogging, Dialogs, ADODB, Variants,
  ComCtrls, Forms, Controls, ExtCtrls, ShellAPI ;

procedure DebugMsg(strMsg: string);
procedure FillListView(LV1:TListView; AQry:TADOQuery);
procedure SetFormParent(Form1 : TForm; Parent1 : TPanel);
procedure OpenLocalFile ( FileURL : AnsiString ) ;        //打开文件或网址

function  VtoS(v: Variant): string;
function  BtoS(b: Boolean): string;
function  ItoS(i: Integer): string;
function  Dtos(d: Double ): string;
function  StoI(s: string ): Integer;
function  StoB(s: string ): Boolean;
function  ItoB(i: Integer ): Boolean;
function  BtoI(b: Boolean ): Integer;
function  StoD(s: string ): Double;
function  StrN(d: Double; n: Integer): string;
function  AQrySel(AQry1: TADOQuery; strSQL: string) : Integer;
function  AQryCmd(AQry1: TADOQuery; strSQL: string) : Integer;
function  GetConStr(strPath: string): string;
function  FieldStr(AQry1: TADOQuery; strField: string): string;
function  FieldStrN(AQry1: TADOQuery; strField: string; i:Integer): string;
function  FieldInt(AQry1: TADOQuery; strField: string): Integer;
function  FieldDob(AQry1: TADOQuery; strField: string): Double;
function  FieldBoo(AQry1: TADOQuery; strField: string): Boolean;
function  AddZero(s:String;HopeLength:Integer): String;        //字符串前补0
function  CopyStrBetween( strOld: string; strA: string; strB: string): string;
function  CopyStrBetweenN(strOld: string; n: Integer; strA: string; strB: string): string;
function  AnsiContainsStr(const AText, ASubText: string): Boolean;

implementation

function GetConStr(strPath: string): string;
var
  s_Host, s_D_B_, s_User, s_Pass, s_Con: string;
  MailIni: TIniFile;
begin
  MailIni := TIniFile.Create(strPath + 'config.ini');
  with MailIni do
  begin
    s_Host := ReadString('SQLDB', 'Server', '127.0.0.1');
    s_D_B_ := ReadString('SQLDB', 'DBName', 'Master');
    s_User := ReadString('SQLDB', 'User', 'sa');
    s_Pass := ReadString('SQLDB', 'Password', '');
  end;

  s_Con := 'Provider=SQLOLEDB.1;'
    + 'Persist Security Info=True;'
    + 'Data Source=' + s_Host + ';'
    + 'Initial Catalog=' + s_D_B_ + ';'
    + 'User ID=' + s_User + ';'
    + 'Password=' + s_Pass + ';';
  Result := s_Con
end;
  
function AQrySel(AQry1: TADOQuery; strSQL: string): Integer;
begin
  try
    Result := 0;
    AQry1.Close;
    AQry1.SQL.Clear;
    AQry1.SQL.Add(strSQL);
    AQry1.Open;
    Result := AQry1.RecordCount;
  except
    on ex: Exception do
    begin
      DebugMsg(ex.Message);
      DebugMsg(strSQL);
    end;
  end;
end;

function AQryCmd(AQry1: TADOQuery; strSQL: string) : Integer;
begin

  try
    Result := 0;
    AQry1.Close;
    AQry1.SQL.Clear;
    AQry1.SQL.Add(strSQL);
    Result := AQry1.ExecSQL;
  except
    on ex: Exception do
    begin
      DebugMsg(ex.Message);
      DebugMsg(strSQL);
    end;
  end;

end;

function FieldStr(AQry1: TADOQuery; strField: string): string;
begin
  if AQry1.RecordCount = 0 then Result := ''
  else Result := VarToStr(AQry1.FieldValues[strField]);
end;

function FieldStrN(AQry1: TADOQuery; strField: string; i:Integer): string;
var
  d_tem : Double;
begin
  if AQry1.RecordCount = 0 then d_tem := 0
  else
  begin
    if VarToStr(AQry1.FieldValues[strField]) = '' then d_tem := 0
    else
    try
      d_tem := StrToFloat(AQry1.FieldValues[strField]);
    except
      d_tem := 0
    end;
    Str(d_tem: 3: i, Result);
  end;
end;

function FieldInt(AQry1: TADOQuery; strField: string): Integer;
begin
  if AQry1.RecordCount = 0 then Result := 0
  else
  begin
    if VarToStr(AQry1.FieldValues[strField]) = '' then Result := 0
    else
    try
      Result := StrToInt(AQry1.FieldValues[strField]);
    except
      Result := 0
    end;
  end;

end;

function FieldDob(AQry1: TADOQuery; strField: string): Double;
begin
  if AQry1.RecordCount = 0 then Result := 0
  else
  begin
    if VarToStr(AQry1.FieldValues[strField]) = '' then Result := 0
    else
    try
      Result := StrToFloat(AQry1.FieldValues[strField]);
    except
      Result := 0
    end;
  end;

end;

function FieldBoo(AQry1: TADOQuery; strField: string): Boolean;
begin
  if AQry1.RecordCount = 0 then Result := False
  else
  begin
    if VarToStr(AQry1.FieldValues[strField]) = '' then Result := False
    else
    try
      Result := StrToBool(AQry1.FieldValues[strField]);
    except
      Result := False;
    end;
  end;

end;

function  VtoS(v: Variant): string;
begin
  Result := VarToStr(v);
end;

function  BtoS(b: Boolean): string;
begin
  Result := BoolToStr(b);
end;

function  ItoS(i: Integer): string;
begin
  Result := IntToStr(i);
end;

function  Dtos(d: Double ): string;
begin
  Result := FloatToStr(d);
end;  

function  StoI(s: string ): Integer;
begin
  Result := StrToInt(s);
end;

function  StoB(s: string ): Boolean;
begin
  Result := StrToBool(s);
end;

function  ItoB(i: Integer ): Boolean;
begin
  Result := StoB(ItoS(i));
end;

function  BtoI(b: Boolean ): Integer;
begin
  if b then Result := 1
  else Result := 0;
end;

function  StoD(s: string ): Double;
begin
  Result := StrToFloat(s);
end;

function  StrN(d: Double; n: Integer): string;
begin
  Str(d: 3: n, Result);
end;

function AddZero(s:String;HopeLength:Integer):String;
begin
  Result:=StringReplace(Format('%'+IntToStr(HopeLength)+'s',[s]),' ','0',[rfIgnoreCase,rfReplaceAll]);
end;

function CopyStrBetween(strOld: string; strA: string; strB: string): string;
var
  i: Integer;
begin
  if strA <> '' then
  begin
    i := Pos(strA, strOld);
    if i = 0 then
    begin
      Result := '';
      Exit;
    end;
    Delete(strOld, 1, i + Length(strA) - 1);
  end;

  i := Pos(strB, strOld);
  if i = 0 then
  begin
    Result := strOld;
    Exit;
  end;
  Result := Copy(strOld, 1, i - 1);
end;

function CopyStrBetweenN(strOld: string; n: Integer; strA: string; strB: string): string;
var
  i, j: Integer;
begin
  if strA <> '' then
  begin
    for j := 0 to (n - 1) do
    begin
      i := Pos(strA, strOld);
      if i = 0 then
      begin
        Result := '';
        Exit;
      end;
      Delete(strOld, 1, i + Length(strA) - 1);
    end;
  end;

  i := Pos(strB, strOld);
  if i = 0 then
  begin
    Result := strOld;
    Exit;
  end;
  Result := Copy(strOld, 1, i - 1);
end;

procedure DebugMsg(strMsg: string);
begin
  CodeSite.Send(FormatDateTime('hh:nn:ss:zzz',Now) + '  ' + strMsg);
end;

procedure FillListView(LV1:TListView; AQry:TADOQuery);
var
  col: TListColumn;
  item: TListItem;
  i, j: Integer;
begin
  LV1.Items.Clear;
  LV1.Columns.Clear;

  for i :=0 to AQry.FieldCount - 1 do
  begin
    col := LV1.Columns.Add;
    col.Caption := AQry.Fields[i].FieldName;
    col.Width := 110;
  end;

  AQry.First;
  for i := 0 to AQry.RecordCount - 1 do
  begin
    item := LV1.Items.Add;
    item.Caption := VarToStr(AQry.Fields[0].Value);
    for j :=1 to AQry.FieldCount - 1 do
    begin
      item.SubItems.Add(VarToStr(AQry.Fields[j].Value));
    end;
    AQry.Next;
  end;

end;

procedure SetFormParent(Form1 : TForm; Parent1 : TPanel);
begin
  Form1.Parent := Parent1;
  Form1.BorderStyle := bsNone;
  Form1.Align := alClient;
end;

procedure OpenLocalFile ( FileURL : AnsiString ) ;
begin
    if AnsiContainsStr ( lowercase ( FileURL ) , 'http://' ) then
				ShellExecute(0, 'open', Pchar(FileURL), '', '', SW_SHOWNORMAL)
            //运行外部Web程序
    else
    begin
        if FileExists ( FileURL ) then
            ShellExecute(0, 'open', PChar(FileURL), '', '', SW_SHOWNORMAL)
                //启动外部其他程序
        else
            Application.MessageBox ( PChar ( '无法启动外部程序【' + FileURL + '】' ) ,
                '错误信息' , MB_OK + MB_ICONERROR ) ;
    end ;
end ;

function AnsiContainsStr(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(ASubText, AText) > 0;
end;

end.

