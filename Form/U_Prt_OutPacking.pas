unit U_Prt_OutPacking;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ExtCtrls, RzPanel, RzButton,
  UPub, UParam, UDebug, frxClass, UIni;

procedure f_Prt_OutPacking_showModal();
procedure f_prt_OutPacking_getDsValue(const VarName: string; var Value: Variant);

type
  TF_Prt_OutPacking = class(TForm)
    grpbox1: TRzGroupBox;
    lab10: TLabel;
    lab11: TLabel;
    lab12: TLabel;
    lab13: TLabel;
    tboxUnit: TRzEdit;
    tboxPrefixU: TRzEdit;
    tboxPrefixD: TRzEdit;
    tboxPhone: TRzEdit;
    grpbox2: TRzGroupBox;
    lab1: TLabel;
    lab2: TLabel;
    lab3: TLabel;
    lab4: TLabel;
    lab5: TLabel;
    lab6: TLabel;
    lab7: TLabel;
    lab8: TLabel;
    tboxNBack: TRzEdit;
    tboxNTop: TRzEdit;
    tboxNDown: TRzEdit;
    tboxNHardW: TRzEdit;
    tboxlistID: TRzEdit;
    tboxNCount: TRzEdit;
    tboxUserNam: TRzEdit;
    tboxAddress: TRzEdit;
    btnOptSave: TRzBitBtn;
    btnPrtView: TRzBitBtn;
    btnCancel: TRzBitBtn;
    frxDs_OutPacking: TfrxUserDataSet;
    frxRprt1: TfrxReport;
    procedure btnCancelClick(Sender: TObject);
    procedure btnPrtViewClick(Sender: TObject);
    procedure frxDs_OutPackingFirst(Sender: TObject);
    procedure frxDs_OutPackingNext(Sender: TObject);
    procedure frxDs_OutPackingPrior(Sender: TObject);
    procedure frxDs_OutPackingCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frxDs_OutPackingGetValue(const VarName: string; var Value: Variant);
    procedure btnOptSaveClick(Sender: TObject);
    procedure tboxNTopChange(Sender: TObject);
    procedure tboxNCountChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_OutPacking: TF_Prt_OutPacking;

implementation

{$R *.dfm}
var
  lab_Index: Integer;
  labCount: Integer;
  i_cab_U: Integer;
  i_cab_D: Integer;
  i_cab_B: Integer;
  i_cab_W: Integer;
  cabUp: array of T_Cabinet;
  cabDown: array of T_Cabinet;

procedure TF_Prt_OutPacking.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//保存设置
procedure TF_Prt_OutPacking.btnOptSaveClick(Sender: TObject);
begin
  IniWriteStr('Factory', 'Phone', tboxPhone.Text);
  IniWriteStr('Factory', 'Unit', tboxUnit.Text);
  IniWriteStr('Factory', 'PrefixU', tboxPrefixU.Text);
  IniWriteStr('Factory', 'PrefixD', tboxPrefixD.Text);
end;

procedure TF_Prt_OutPacking.btnPrtViewClick(Sender: TObject);
begin
  try
    labCount := StrToInt(tboxNCount.Text);
    i_cab_U := StrToInt(tboxNTop.Text);
    i_cab_D := StrToInt(tboxNDown.Text);
    i_cab_B := StrToInt(tboxNBack.Text);
    i_cab_W := StrToInt(tboxNHardW.Text);

    frxRprt1.LoadFromFile(AppPath + 'rpt/outPacking.fr3');
    frxRprt1.Script.AddVariable('WPath', 'String', AppPath);
    frxRprt1.ShowReport();
  except
    on ex: Exception do
    begin
      Send(ex.Message);
      ShowMessage('输入不正确，请检查后重试！');
    end;
  end;

end;

procedure TF_Prt_OutPacking.frxDs_OutPackingCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := lab_Index >= labCount;
end;

procedure TF_Prt_OutPacking.frxDs_OutPackingFirst(Sender: TObject);
begin
  lab_Index := 0;
end;

procedure TF_Prt_OutPacking.frxDs_OutPackingGetValue(const VarName: string; var Value: Variant);
begin
  f_prt_OutPacking_getDsValue(VarName, Value);
end;

procedure f_prt_OutPacking_getDsValue(const VarName: string; var Value: Variant);
var
  strCabName: string;
  strCabH_W_D: string;
  strCabI_N: string;
  strCabNo: string;
  i: Integer;
begin
  with F_Prt_OutPacking do
  begin
    if lab_Index < i_cab_U then
    begin
      i := lab_Index;
      strCabName := cabUp[i].cabName;
      strCabH_W_D := cabUp[i].cabW_H_D;
      strCabI_N := ItoS(lab_Index + 1) + '/' + ItoS(labCount);
      strCabNo := tboxPrefixU.Text + ItoS(i + 1);
    end
    else if (lab_Index >= i_cab_U) and (lab_Index < i_cab_U + i_cab_D) then
    begin
      i := lab_Index - i_cab_U;
      strCabName := cabDown[i].cabName;
      strCabH_W_D := cabDown[i].cabW_H_D;
      strCabI_N := ItoS(lab_Index + 1) + '/' + ItoS(labCount);
      strCabNo := tboxPrefixD.Text + ItoS(i + 1);
    end
    else if (lab_Index >= i_cab_U + i_cab_D) and (lab_Index < i_cab_U + i_cab_D + i_cab_B) then
    begin
      i := lab_Index - i_cab_U - i_cab_D;
      strCabName := '背板';
      strCabH_W_D := '';
      strCabI_N := ItoS(lab_Index + 1) + '/' + ItoS(labCount);
      strCabNo := '' + ItoS(i + 1);
    end
    else
    begin
      i := lab_Index - i_cab_U - i_cab_D - i_cab_B;
      strCabName := '五金';
      strCabH_W_D := '';
      strCabI_N := ItoS(lab_Index + 1) + '/' + ItoS(labCount);
      strCabNo := '' + ItoS(i + 1);
    end;

    if VarName = 'strListID'       then Value :=  tboxlistID.Text
    else if VarName = 'useName'    then Value :=  tboxUserNam.Text
    else if VarName = 'address'    then Value :=  tboxAddress.Text
    else if VarName = 'cabName'    then Value :=  strCabName
    else if VarName = 'cabH_H_D'   then Value :=  strCabH_W_D
    else if VarName = 'cabCount'   then Value :=  tboxNCount.Text
    else if VarName = 'cabI_N'     then Value :=  strCabI_N
    else if VarName = 'cabNo'      then Value :=  strCabNo
    else if VarName = 'coName'     then Value :=  tboxUnit.Text
    else if VarName = 'coPhon'     then Value :=  tboxPhone.Text;
  end;
end;

procedure TF_Prt_OutPacking.frxDs_OutPackingNext(Sender: TObject);
begin
  Inc(lab_Index);
end;

procedure TF_Prt_OutPacking.frxDs_OutPackingPrior(Sender: TObject);
begin
  Dec(lab_Index);
end;

procedure TF_Prt_OutPacking.tboxNCountChange(Sender: TObject);
var
  i, j: Integer;
begin
  try
    labCount := StrToInt(tboxNCount.Text);
    i_cab_U := StrToInt(tboxNTop.Text);
    i_cab_D := StrToInt(tboxNDown.Text);
    i_cab_B := StrToInt(tboxNBack.Text);
    i_cab_W := StrToInt(tboxNHardW.Text);
    if labCount > i_cab_U + i_cab_D + i_cab_B + i_cab_W then
      Msg('总数不能大于上下柜及背板五金之和！');
  except
    Msg('输入不正确！');
  end;
end;

procedure TF_Prt_OutPacking.tboxNTopChange(Sender: TObject);
begin
  try
    labCount := StrToInt(tboxNCount.Text);
    i_cab_U := StrToInt(tboxNTop.Text);
    i_cab_D := StrToInt(tboxNDown.Text);
    i_cab_B := StrToInt(tboxNBack.Text);
    i_cab_W := StrToInt(tboxNHardW.Text);
    if i_cab_U > Length(cabUp) then Msg('上柜分包数量不能大于上柜总数！')
    else if i_cab_D > Length(cabDown) then Msg('下柜分包数量不能大于下柜总数！')
    else tboxNCount.Text := ItoS(i_cab_U + i_cab_D + i_cab_B + i_cab_W);

  except
    Msg('输入不正确！');
  end;
end;

procedure f_Prt_OutPacking_showModal();
var
  i, j: Integer;
begin
  with F_Prt_OutPacking do
  begin
    try
      tboxlistID.Text := List.strListID;
      tboxUserNam.Text := List.strUseName;
      tboxAddress.Text := List.strAddress;
      tboxNBack.Text := '1';
      tboxNHardW.Text := '1';

      tboxPhone.Text := IniReadStr('Factory', 'Phone', '');
      tboxUnit.Text := IniReadStr('Factory', 'Unit', '');
      tboxPrefixU.Text := IniReadStr('Factory', 'PrefixU', 'B');
      tboxPrefixD.Text := IniReadStr('Factory', 'PrefixD', 'A');

      SetLength(cabUp, 0);
      SetLength(cabDown, 0);

      for i := 0 to Length(List.cab) - 1 do
      begin
        with List.cab[i] do
        begin
          if Pos('板', cabName) = 0 then
          begin
            if Pos('上柜', cabName) > 0 then
            begin
              j := Length(cabUp);
              SetLength(cabUp, j + 1);
              cabUp[j].cabName := cabName;
              cabUp[j].cabW_H_D := cabW_H_D;
              cabUp[j].cabID := ItoS(j + 1);
            end
            else
            begin
              j := Length(cabDown);
              SetLength(cabDown, j + 1);
              cabDown[j].cabName := cabName;
              cabDown[j].cabW_H_D := cabW_H_D;
              cabDown[j].cabID := ItoS(j + 1);
            end;
          end;
        end;
      end;

      tboxNTop.Text := ItoS(Length(cabUp));
      tboxNDown.Text := ItoS(Length(cabDown));
      tboxNCount.Text := ItoS(Length(cabUp) + Length(cabDown) + 2);
    except
      on ex: Exception do
      begin
        SendError(ex.Message);
      end;
    end;


    ShowModal;
  end;
end;

end.
