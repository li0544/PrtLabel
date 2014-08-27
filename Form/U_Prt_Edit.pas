unit U_Prt_Edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, UPub, UParam, UDebug, frxClass, frxDesgn, U_Prt_PrdIV,
  frxOLE, frxGradient, frxCross, StdCtrls, RzLabel, jpeg, ExtCtrls, RzPanel,
  IniFiles;

procedure editRpt(rpt: string);

type
  TF_Prt_Edit = class(TForm)
    btnLab: TRzBitBtn;
    btnOutPacking: TRzBitBtn;
    frxDesg1: TfrxDesigner;
    frxRprt1: TfrxReport;
    btnDrawer: TRzBitBtn;
    btnPrd: TRzBitBtn;
    btnDoorAl: TRzBitBtn;
    panel1: TRzPanel;
    img1: TImage;
    label1: TRzLabel;
    procedure btnLabClick(Sender: TObject);
    procedure btnOutPackingClick(Sender: TObject);
    procedure btnDrawerClick(Sender: TObject);
    procedure btnPrdClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDoorAlClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    btn1: array of TButton;
  end;

var
  F_Prt_Edit: TF_Prt_Edit;

implementation

{$R *.dfm}

procedure editRpt(rpt: string);
begin
  F_Prt_Edit.frxRprt1.LoadFromFile(AppPath + 'rpt/' + rpt);
  F_Prt_Edit.frxRprt1.Script.AddVariable('WPath', 'String', AppPath);
  F_Prt_Edit.frxRprt1.DesignReport;
end;

procedure TF_Prt_Edit.FormCreate(Sender: TObject);
begin
  Height := 230;
  Width := 550;
end;

procedure TF_Prt_Edit.FormShow(Sender: TObject);
var
  i,i_top, i_left: Integer;
  s1,s2: TStrings;
  inif: TIniFile;
begin

  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

  s1 := TStringList.Create();
  s1.Delimiter := ';';
  s1.DelimitedText := inif.ReadString('Report', 'RptFile','');

  SetLength(btn1, s1.Count);
  i_top := 80;
  i_left := 60;
  for i := 0 to s1.Count - 1 do
  begin

    i_top := (i div 4) * 40 + 80;
    i_left := i mod 4 * 110 + 60;


    s2 := TStringList.Create();
    s2.Delimiter := ':';
    s2.DelimitedText := s1[i];
    btn1[i] := TButton.Create(Self);
    btn1[i].Parent := Self;
    btn1[i].Caption := s2[0];
    btn1[i].Width := 100;
    btn1[i].Height := 30;
    btn1[i].Top := i_top;
    btn1[i].Left := i_left;
    btn1[i].Show;
    btn1[i].OnClick := btnClick;

    s2.Free;
  end;

  s1.Free;
end;

procedure TF_Prt_Edit.btnDoorAlClick(Sender: TObject);
begin
  get_PrdIV_Ds(3);

  editRpt('prdDoorAl.fr3');
end;

procedure TF_Prt_Edit.btnDrawerClick(Sender: TObject);
begin
  get_PrdIV_Ds(2);

  editRpt('prdDoor.fr3');
end;

procedure TF_Prt_Edit.btnLabClick(Sender: TObject);
begin
  editRpt('lab.fr3');
end;

procedure TF_Prt_Edit.btnOutPackingClick(Sender: TObject);
begin
  editRpt('outPacking.fr3');
end;

procedure TF_Prt_Edit.btnPrdClick(Sender: TObject);
begin
  get_PrdIV_Ds(1);

  editRpt('prd.fr3');
end;

procedure TF_Prt_Edit.btnClick(Sender: TObject);
var
  i,i_top, i_left: Integer;
  s1,s2: TStrings;
  inif: TIniFile;
begin

  get_PrdIV_Ds(1);
  get_PrdIV_Ds(2);
  get_PrdIV_Ds(3);
  get_PrdIV_Ds(4);

  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

  s1 := TStringList.Create();
  s1.Delimiter := ';';
  s1.DelimitedText := inif.ReadString('Report', 'RptFile','');

  for i := 0 to s1.Count - 1 do
  begin

    s2 := TStringList.Create();
    s2.Delimiter := ':';
    s2.DelimitedText := s1[i];

    if s2[0] = TButton(Sender).Caption then
    begin
      editRpt(s2[1] + '.fr3');
      s2.Free;

      Break;
    end;
    s2.Free;
  end;

  s1.Free;


end;

end.
