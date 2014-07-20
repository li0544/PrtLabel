program RegObj;

uses
  Forms,
  U_Main in 'U_Main.pas' {F_Main},
  U_HWInf in 'U_HWInf.pas',
  U_MD5 in 'U_MD5.pas',
  U_Reg in 'U_Reg.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF_Main, F_Main);
  Application.Run;
end.
