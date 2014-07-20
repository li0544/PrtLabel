unit U_Reg;

interface
uses
    SysUtils, U_HWInf, CnMD5;

function GetID: string;
function ChkKey(sKey: string): Boolean;
function GetKey(sID: string): string;
function MD5(str1: string): string;

implementation

function GetID: string;
var
    HDID: string;
    md1, sID: string;
    s: array[1..16] of string;
    k: array[1..16] of string;
    i, j: Integer;
begin
    HDID := Trim(GetIdeSerialNumber);
    md1 := MD5(HDID);
    sID := '';
    for i := 1 to 16 do
    begin
        s[i] := Copy(md1, i * 2, 1);
        sID := sID + s[i];
        if (i mod 4 = 0) AND (i <> 16) then
            sID := sID + '-';
    end;
    Result := sID;
end;

function GetKey(sID: string): string;
var
    md1, sKey: string;
    s: array[1..16] of string;
    i, j: Integer;
begin
    for j := 1 to 3 do
    begin
        md1 := MD5(sid);
        sKey := '';
        for i := 1 to 16 do
        begin
            s[i] := Copy(md1, i * 2, 1);
            sKey := sKey + s[i];
            if (i mod 4 = 0) AND (i <> 16) then
                sKey := sKey + '-';
        end;
        sID := sKey;
    end;
    Result := sKey;
end;

function ChkKey(sKey: string): Boolean;
var
    HDID: string;
    md1, sTem, sID: string;
    s: array[1..16] of string;
    k: array[1..16] of string;
    i, j: Integer;
begin

    sKey := UpperCase(sKey);
    if sKey <> GetKey(GetID) then
        Result := False
    else
        result := True;
end;

function MD5(str1: string): string;
var
  aDig: TMD5Digest;
begin
{$IFDEF UNICODE}
  Result := MD5Print(MD5StringA(AnsiString(str1)));
{$ELSE}
  Result := MD5Print(MD5String(str1));
{$ENDIF}
end;

end.

