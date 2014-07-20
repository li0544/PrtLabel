unit UIni;

interface

uses
  IniFiles, Windows, SysUtils, CodeSiteLogging, Dialogs, ADODB, Variants,
  DBGridEh, RzCmboBx, RzDBCmbo, Messages, RzListVw, Classes, TypInfo,
  Math, RzPanel, CondExpression, DB,
  ComCtrls, Forms, Controls, ExtCtrls, ShellAPI, RzTreeVw, DateUtils,
  ComObj, UDebug;

function IniReadStr(strNode: string; strKey: string; strVal: string): string;
procedure IniWriteStr(strNode: string; strKey: string; strVal: string);

implementation

var
  AppPath     : string;        //Èí¼þÄ¿Â¼
  IniFile     : TIniFile;

const
  KEY_FILENAME : string = 'Config.ini';

function IniReadStr(strNode: string; strKey: string; strVal: string): string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  IniFile := TIniFile.Create(AppPath + KEY_FILENAME);
  Result := IniFile.ReadString(strNode, strKey, strVal);
  IniFile.Free;
end;

procedure IniWriteStr(strNode: string; strKey: string; strVal: string);
begin
  AppPath := ExtractFilePath(Application.ExeName);
  IniFile   := TIniFile.Create(AppPath + KEY_FILENAME);
  IniFile.WriteString(strNode, strKey, strVal);
  IniFile.Free;
end;

end.



