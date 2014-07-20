unit UDebug;

interface

{$DEFINE Show_Log}
{$DEFINE cd}     //cndebug
{$DEFINE cs_1}       //codesite

uses
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebug,
{$ENDIF}
{$IFDEF cs}
  CodeSiteLogging,
{$ENDIF}
{$ENDIF}
  SysUtils;

procedure Send(s1: string); overload;
procedure send(strMsg: string; e: TObject); overload;
procedure SendException(E: Exception); overload;
procedure SendException(strMsg: string; E: Exception); overload;
procedure SendError(s1: string);
procedure EnterDebug(s1: string);
procedure ExitDebug(s1: string);
procedure EnterMethod(strMsg: string);
procedure ExitMethod(strMsg: string);

implementation

procedure Send(s1: string); overload;
begin
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogMsg(s1);
{$ENDIF}
{$IFDEF cs}
  CodeSite.Send(s1);
{$ENDIF}
{$ENDIF}
end;

procedure send(strMsg: string; e: TObject); overload;
begin
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogMsg(e.ToString);
{$ENDIF}
{$IFDEF cs}
  CodeSite.Send(strMsg, e);
{$ENDIF}
{$ENDIF}
end;

procedure SendException(E: Exception); overload;
begin
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogMsg(E.Message);
{$ENDIF}
{$IFDEF cs}
  CodeSite.Send(E.Message);
{$ENDIF}
{$ENDIF}
end;

procedure SendException(strMsg: string; E: Exception); overload;
begin
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogMsg(strMsg + #10#13 + E.Message);
{$ENDIF}
{$IFDEF cs}
  CodeSite.SendException(strMsg, E);
{$ENDIF}
{$ENDIF}
end;

procedure SendError(s1: string);
begin
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogMsgError(s1);
{$ENDIF}
{$IFDEF cs}
  CodeSite.SendError(s1);
{$ENDIF}
{$ENDIF}
end;

procedure EnterDebug(s1: string);
begin
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogEnter(s1);
{$ENDIF}
{$IFDEF cs}
  CodeSite.EnterMethod(s1);
{$ENDIF}
{$ENDIF}
end;

procedure ExitDebug(s1: string);
begin
{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogLeave(s1);
{$ENDIF}
{$IFDEF cs}
  CodeSite.ExitMethod(s1);
{$ENDIF}
{$ENDIF}
end;

procedure EnterMethod(strMsg: string);
begin

{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogEnter(strMsg);
{$ENDIF}
{$IFDEF cs}
  EnterMethod(strMsg);
{$ENDIF}
{$ENDIF}
end;

procedure ExitMethod(strMsg: string);
begin

{$IFDEF Show_Log}
{$IFDEF cd}
  CnDebugger.LogLeave(strMsg);
{$ENDIF}
{$IFDEF cs}
  ExitDebug(strMsg);
{$ENDIF}
{$ENDIF}
end;

end.

