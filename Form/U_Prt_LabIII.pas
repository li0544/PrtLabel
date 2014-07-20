unit U_Prt_LabIII;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frxBarcode, frxClass, UPub, UParam, StrUtils, UDebug;

procedure getDsValue(const VarName: string; var Value: Variant; labs: array of T_BodLab; labCount: Integer);

type
  TF_Prt_LabIII = class(TForm)
    BtnPrintDoor: TButton;
    BtnPrintBody: TButton;
    BtnPrintBack: TButton;
    frxRprt1: TfrxReport;
    frxDs_Lab: TfrxUserDataSet;
    procedure BtnPrintDoorClick(Sender: TObject);
    procedure frxDs_LabFirst(Sender: TObject);
    procedure frxDs_LabNext(Sender: TObject);
    procedure frxDs_LabPrior(Sender: TObject);
    procedure frxDs_LabCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure BtnPrintBodyClick(Sender: TObject);
    procedure BtnPrintBackClick(Sender: TObject);
    procedure frxDs_LabGetValue(const VarName: string; var Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_LabIII: TF_Prt_LabIII;

implementation

{$R *.dfm}
var
  lab_Index: Integer;
  i_Typ: Integer;


procedure TF_Prt_LabIII.BtnPrintBackClick(Sender: TObject);
begin
  i_Typ := 3;
  frxRprt1.LoadFromFile(AppPath + 'rpt/lab.fr3');
  frxRprt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRprt1.ShowReport();
end;

procedure TF_Prt_LabIII.BtnPrintBodyClick(Sender: TObject);
begin
  i_Typ := 2;
  frxRprt1.LoadFromFile(AppPath + 'rpt/lab.fr3');
  frxRprt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRprt1.ShowReport();
end;

procedure TF_Prt_LabIII.BtnPrintDoorClick(Sender: TObject);
begin
  i_Typ := 1;
  frxRprt1.LoadFromFile(AppPath + 'rpt/lab.fr3');
  frxRprt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRprt1.ShowReport();
end;

procedure TF_Prt_LabIII.frxDs_LabCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  if i_Typ = 1 then Eof := lab_Index >= Length(List.bodLabs.DoorLabs)
  else if i_Typ = 2 then Eof := lab_Index >= Length(List.bodLabs.BodyLabs)
  else if i_Typ = 3 then Eof := lab_Index >= Length(List.bodLabs.BackLabs)
end;

procedure TF_Prt_LabIII.frxDs_LabFirst(Sender: TObject);
begin
  lab_Index := 0;
end;

procedure TF_Prt_LabIII.frxDs_LabGetValue(const VarName: string;
  var Value: Variant);
var
  labCount: Integer;
begin
  try
    if i_Typ = 1 then 
    begin
      labCount := Length(List.bodLabs.DoorLabs);
      getDsValue(VarName, Value, List.bodLabs.DoorLabs, labCount);
    end
    else if i_Typ = 2 then 
    begin
      labCount := Length(List.bodLabs.BodyLabs);
      getDsValue(VarName, Value, List.bodLabs.BodyLabs, labCount);
    end
    else if i_Typ = 3 then
    begin
      labCount := Length(List.bodLabs.BackLabs);
      getDsValue(VarName, Value, List.bodLabs.BackLabs, labCount);
    end;
  except
    on ex: Exception do
    begin
      SendError(ex.Message);
    end;
  end;

end;

procedure getDsValue(const VarName: string; var Value: Variant; labs: array of T_BodLab; labCount: Integer);
var
  sOth: string;
begin
  with labs[lab_Index] do
  begin
  
    if ptType = 1 then sOth := CabName
    else sOth := cabTypeID;

    //抽屉，包管，垫条，封板，辅料
    if ( Pos('抽屉', BodName) = 0 ) AND ( Pos('包管', BodName) = 0 ) AND ( Pos('垫条', BodName) = 0 )
    AND ( Pos('封板', BodName) = 0 ) AND ( Pos('辅料', BodName) = 0 ) then
    begin
      ;
    end
    else sOth := '';
  
    if VarName = 'strListID'       then Value :=  List.strListID
    else if VarName = 'strSDate'   then Value :=  List.strSDate
    else if VarName = 'strAddress' then Value :=  List.strAddress //MidStr(List.strAddress,1,4)
    else if VarName = 'bodCZh'     then Value :=  VtoS(bodCZh)
    else if VarName = 'labI_N'     then Value :=  IntToStr(lab_Index + 1) + '/' + IntToStr(labCount)
    else if VarName = 'Index'      then Value :=  VtoS(Index)
    else if VarName = 'labIndex'   then Value :=  VtoS(labIndex)
    else if VarName = 'cabID'      then Value :=  VtoS(cabID)
    else if VarName = 'cabName'    then Value :=  VtoS(cabName)
    else if VarName = 'cabTypeID'  then Value :=  VtoS(cabTypeID)
    else if VarName = 'cabW_H_D'   then Value :=  VtoS(cabW_H_D)
    else if VarName = 'cabOth'     then Value :=  sOth
    else if VarName = 'bodID'      then Value :=  VtoS(bodID)
    else if VarName = 'bodName'    then Value :=  VtoS(bodName)
    else if VarName = 'bodH_W'     then Value :=  VtoS(bodH + fbDoor * 2) + '×' + VtoS(bodW + fbDoor * 2)
    else if VarName = 'bodI_N'     then Value :=  VtoS(labIndex) + '/' + VtoS(bodCount) + '块 '
    else if VarName = 'bodInfo'    then Value :=  VtoS(bodInfo)
    else if VarName = 'bodNum'     then Value :=  VtoS(bodNum)
    else if VarName = 'bodCount'   then Value :=  VtoS(bodCount)
    else if VarName = 'bodW'       then Value :=  VtoS(bodW)
    else if VarName = 'bodH'       then Value :=  VtoS(bodH)
    else if VarName = 'useName'    then Value :=  List.strUseName;
         
  end;   
end;

procedure TF_Prt_LabIII.frxDs_LabNext(Sender: TObject);
begin
  Inc(lab_Index);
end;

procedure TF_Prt_LabIII.frxDs_LabPrior(Sender: TObject);
begin
  Dec(lab_Index);
end;

end.

