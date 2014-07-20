program PrtLab;

uses
  Forms,
  IniFiles,
  SysUtils,
  U_Prt_Lab2 in '..\Form\U_Prt_Lab2.PAS' {F_Prt_Lab},
  U_Prt in '..\Form\U_Prt.pas' {F_Prt},
  U_Price in '..\Form\U_Price.pas' {F_Price},
  U_Prt_Prc2 in '..\Form\U_Prt_Prc2.pas' {F_Prt_Prc2},
  U_Prt_Opt in '..\Form\U_Prt_Opt.pas' {F_Prt_Opt},
  U_Debug in '..\Form\U_Debug.pas' {F_Debug},
  U_Pb in '..\Form\U_Pb.pas' {F_PB},
  U_Price_Add in '..\Form\U_Price_Add.pas' {F_Price_Add},
  U_RegI in '..\Form\U_RegI.pas' {F_RegI},
  U_Prt_Proj2 in '..\Form\U_Prt_Proj2.pas' {F_Prt_Proj2},
  U_List in '..\Form\U_List.pas' {F_List},
  U_Flash in '..\Form\U_Flash.pas' {F_Flash},
  U_List_Opt in '..\Form\U_List_Opt.pas' {F_List_Opt},
  U_Prt_Prd3 in '..\Form\U_Prt_Prd3.pas' {F_Prt_Prd2},
  CondExpression in '..\Common\CondExpression.pas',
  U_ExeCabPrice in '..\Common\U_ExeCabPrice.pas',
  U_HWInf in '..\Common\U_HWInf.pas',
  U_MD5 in '..\Common\U_MD5.pas',
  U_PBRun in '..\Common\U_PBRun.pas',
  U_Reg in '..\Common\U_Reg.pas',
  UList in '..\Common\UList.pas',
  UParam in '..\Common\UParam.pas',
  UPub in '..\Common\UPub.pas',
  U_Prt_LabIII in '..\Form\U_Prt_LabIII.pas' {F_Prt_LabIII},
  U_Prt_OutPacking in '..\Form\U_Prt_OutPacking.pas' {F_Prt_OutPacking},
  UIni in '..\Common\UIni.pas',
  U_Prt_Edit in '..\Form\U_Prt_Edit.pas' {F_Prt_Edit},
  U_List_PrcAdd in '..\Form\U_List_PrcAdd.pas' {F_List_PrcAdd},
  U_Prt_Drawer in '..\Form\U_Prt_Drawer.pas' {F_Prt_Drawer},
  U_Prt_PrdIV in '..\Form\U_Prt_PrdIV.pas' {F_Prt_PrdIV},
  U_List_Import in '..\Form\U_List_Import.pas' {F_List_Import},
  U_List_Import_Opt in '..\Form\U_List_Import_Opt.pas' {F_List_Import_Opt},
  UADO in '..\..\..\..\第三方控件\wpvcl\Pub\UADO.pas',
  UFReport in '..\..\..\..\第三方控件\wpvcl\Pub\UFReport.pas',
  U_List_Standard in '..\Form\Standard\U_List_Standard.pas' {F_List_Standard},
  U_List_Bod in '..\Form\List\U_List_Bod.pas' {F_List_Bod},
  U_Prt_Prd_Opt in '..\Form\Prt\U_Prt_Prd_Opt.pas' {F_Prt_Prd_Opt};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '橱柜计算器';

  if ChkKey() then
  begin
    Application.CreateForm(TF_Prt, F_Prt);
  Application.CreateForm(TF_PB, F_PB);
  Application.CreateForm(TF_Debug, F_Debug);
  Application.CreateForm(TF_Prt_Opt, F_Prt_Opt);
  Application.CreateForm(TF_Prt_Prc2, F_Prt_Prc2);
  Application.CreateForm(TF_Price, F_Price);
  Application.CreateForm(TF_Prt_Lab, F_Prt_Lab);
  Application.CreateForm(TF_Prt_Proj2, F_Prt_Proj2);
  Application.CreateForm(TF_List, F_List);
  Application.CreateForm(TF_Flash, F_Flash);
  Application.CreateForm(TF_List_Opt, F_List_Opt);
  Application.CreateForm(TF_Prt_Prd2, F_Prt_Prd2);
  Application.CreateForm(TF_Prt_LabIII, F_Prt_LabIII);
  Application.CreateForm(TF_Prt_OutPacking, F_Prt_OutPacking);
  Application.CreateForm(TF_Prt_Edit, F_Prt_Edit);
  Application.CreateForm(TF_List_PrcAdd, F_List_PrcAdd);
  Application.CreateForm(TF_Prt_Drawer, F_Prt_Drawer);
  Application.CreateForm(TF_Prt_PrdIV, F_Prt_PrdIV);
  Application.CreateForm(TF_List_Import, F_List_Import);
  Application.CreateForm(TF_List_Import_Opt, F_List_Import_Opt);
  Application.CreateForm(TF_List_Standard, F_List_Standard);
  Application.CreateForm(TF_List_Bod, F_List_Bod);
  Application.CreateForm(TF_Prt_Prd_Opt, F_Prt_Prd_Opt);
  end
  else
  begin

    Application.CreateForm(TF_RegI, F_RegI);

  end;

  Application.Run;
end.

