unit UPub;

interface
uses
  Windows, SysUtils, Dialogs, ADODB, Variants,
  DBGridEh, Messages,
  Math, Forms, StdCtrls,
  ComCtrls, Controls, ExtCtrls, ShellAPI, UADO ;

type
  TByteDynArray = array of Byte;

procedure Msg(strMsg: string);
procedure FillListView(LV1:TListView; AQry:TADOQuery);
procedure SetFormParent(Form1 : TForm; Parent1 : TPanel);
procedure OpenLocalFile ( FileURL : AnsiString ) ;                      //打开文件或网址
function  openAQry(AQry1: TADOQuery; strSQL: string): Boolean;          //设置ADOQuery控件连接字符串

procedure CBoxAddObj(CBox: TComboBox; sTxt, sVal: string);
procedure LBoxAddObj(LBox: TListBox; sTxt, sVal: string);

function  sNow() : string;
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

function  AddZero(s:String;HopeLength:Integer): String;        //字符串前补0
function  CopyStrBetween( strOld: string; strA: string; strB: string): string; overload;
function  CopyStrBetween(strOld: string; n: Integer; strA: string; strB: string): string; overload;
function  AnsiContainsStr(const AText, ASubText: string): Boolean;
function  GetItemIndex(CBox: TComboBox; v: Variant ): Integer;
function  GetItemValue(CBox: TComboBox ): string;
function  GetLstIndex(LBox: TListBox; v: Variant ): Integer;
function  GetLstValue(LBox: TListBox ): string;

procedure ByteArrayToFile(const ByteArray : TByteDynArray; const FileName : string );   //byte[] to file
function  FiIeToByteArray(const FileName:string ):TByteDynArray;                        //file to byte[]

type
  TCboxItem = class(TObject)
    strName: string;
    public
      strValue: string;
  end;

type
  TLstItem = class(TObject)
    strName: string;
    public
      strValue: string;
  end;

var
  AppPath       : string;        //软件目录


const
  KEY_FILENAME  : string = 'Config.ini';
  crlf          : string = #13#10;

implementation



procedure Msg(strMsg: string);
begin
  ShowMessage(strMsg);
end;

procedure FillListView(LV1:TListView; AQry:TADOQuery);
var
  col: TListColumn;
  item: TListItem;
  i, j: Integer;
begin
  LV1.Visible := False;
  LV1.Items.Clear;
  LV1.Columns.Clear;
  LV1.Font.CharSet:=GB2312_CHARSET;
  LV1.Font.Name:='宋体';

  for i :=0 to AQry.FieldCount - 1 do
  begin
    col := LV1.Columns.Add;
    col.Caption := VarToStr(AQry.Fields[i].FieldName);
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
  LV1.Visible := True;
end;

procedure CBoxAddObj(CBox: TComboBox; sTxt, sVal: string);
var
  obj1 : TCboxItem;
begin
  obj1 := TCboxItem.Create;
  obj1.strName := sTxt;
  obj1.strValue := sVal;
  CBox.Items.AddObject(sTxt, obj1);
end;

procedure LBoxAddObj(LBox: TListBox; sTxt, sVal: string);
var
  obj1 : TLstItem;
begin
  obj1 := TLstItem.Create;
  obj1.strName := sTxt;
  obj1.strValue := sVal;
  LBox.Items.AddObject(sTxt, obj1);
end;

procedure SetFormParent(Form1 : TForm; Parent1 : TPanel);
begin
  Form1.Parent := Parent1;
  Form1.BorderStyle := bsNone;
  Form1.Align := alClient;
  Form1.Show;
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

function openAQry(AQry1: TADOQuery; strSQL: string): Boolean;
begin
  try
    Result := True;
    AQry1.Close;
    AQry1.ConnectionString := getConStr;
    //AQry1.Connection := DatMod.ADB1;
    AQry1.SQL.Clear;
    AQry1.SQL.Add(strSQL);
    AQry1.Open;
  except
    ShowMessage('数据库连接失败，请检查和修改配置后重试');
    Result := False;
  end;
end;


function  sNow() : string;
begin
  Result := FormatDateTime('yyyy-MM-dd HH:mm:ss', Now);
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

function CopyStrBetween(strOld: string; strA: string; strB: string): string; overload;
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
    DELETE(strOld, 1, i + Length(strA) - 1);
  end;

  i := Pos(strB, strOld);
  if i = 0 then
  begin
    Result := strOld;
    Exit;
  end;
  Result := Copy(strOld, 1, i - 1);
end;

function CopyStrBetween(strOld: string; n: Integer; strA: string; strB: string): string; overload;
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
      DELETE(strOld, 1, i + Length(strA) - 1);
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

function AnsiContainsStr(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(ASubText, AText) > 0;
end;

function  GetItemIndex(CBox: TComboBox; v: Variant ): Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to CBox.Items.Count - 1 do
  begin
    if VarToStr(v) = (CBox.Items.Objects[i] AS TCboxItem).strValue then Result := i;
  end;

end;

function  GetItemValue(CBox: TComboBox ): string;
var
  i : Integer;
begin
  i := CBox.ItemIndex;
  Result := (CBox.Items.Objects[i] AS TCboxItem).strValue;
  {Result := '';
  for i := 0 to CBox.Items.Count - 1 do
  begin
    if CBox.Text = (CBox.Items.Objects[i] AS TCboxItem).strName then
      Result := (CBox.Items.Objects[i] AS TCboxItem).strValue;
  end;}
end;

function  GetLstIndex(LBox: TListBox; v: Variant ): Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to LBox.Items.Count - 1 do
  begin
    if VarToStr(v) = (LBox.Items.Objects[i] AS TLstItem).strValue then Result := i;
  end;

end;

function  GetLstValue(LBox: TListBox ): string;
var
  i : Integer;
begin
  Result := (LBox.Items.Objects[LBox.ItemIndex] AS TLstItem).strValue;
  {Result := '';
  for i := 0 to LBox.Items.Count - 1 do
  begin
    send(LBox.Items.Strings[LBox.ItemIndex]);
    send((LBox.Items.Objects[i] AS TLstItem).strName);
    if LBox.Items.Strings[LBox.ItemIndex] = (LBox.Items.Objects[i] AS TLstItem).strName then
      Result := (LBox.Items.Objects[i] AS TLstItem).strValue;
  end;}
end;

procedure ByteArrayToFile(const ByteArray : TByteDynArray; const FileName : string );
var
 Count: integer;
 F: FIle of Byte;
 pTemp: Pointer;
begin
 AssignFile( F, FileName );
 Rewrite(F);
 try
    Count := Length( ByteArray );
    pTemp := @ByteArray[0];
    BlockWrite(F, pTemp^, Count );
 finally
    CloseFile( F );
 end;
end;

function FiIeToByteArray(const FileName:string ):TByteDynArray;
const
  BLOCK_SIZE=1024;
var
  BytesRead,BytesToWrite,Count:integer;
  F:File of Byte;
  pTemp:Pointer;
begin
  AssignFile( F, FileName );
  Reset(F);
  try
    Count := FileSize( F );
    SetLength(Result, Count );
    pTemp := @Result[0];
    BytesRead := BLOCK_SIZE;
    while (BytesRead = BLOCK_SIZE ) do
    begin
       BytesToWrite := Min(Count, BLOCK_SIZE);
       BlockRead(F, pTemp^, BytesToWrite , BytesRead );
       pTemp := Pointer(LongInt(pTemp) + BLOCK_SIZE);
       Count := Count-BytesRead;
    end;
  finally
     CloseFile( F );
  end;
end;


//______________________________________________________________________________

initialization
begin
  AppPath := ExtractFilePath(Application.ExeName);
  //getConStr();
  //init();
end;

finalization
begin



end;

end.









