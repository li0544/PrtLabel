unit U_Prt_Edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, UPub, UParam, UDebug, frxClass, frxDesgn, U_Prt_PrdIV,
  frxOLE, frxGradient, frxCross, StdCtrls, RzLabel, jpeg, ExtCtrls, RzPanel;

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
  private
    { Private declarations }
  public
    { Public declarations }

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

end.
