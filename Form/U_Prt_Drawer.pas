unit U_Prt_Drawer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, StdCtrls, UParam, UDebug, UPub;

type
  TF_Prt_Drawer = class(TForm)
    frxrpt1: TfrxReport;
    frxUDs_Drawer: TfrxUserDataSet;
    btnRptDrawer: TButton;
    procedure frxUDs_DrawerCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frxUDs_DrawerFirst(Sender: TObject);
    procedure frxUDs_DrawerNext(Sender: TObject);
    procedure frxUDs_DrawerPrior(Sender: TObject);
    procedure frxUDs_DrawerGetValue(const VarName: string; var Value: Variant);
    procedure btnRptDrawerClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_Drawer: TF_Prt_Drawer;
  rpt_index: Integer;

implementation

{$R *.dfm}

procedure TF_Prt_Drawer.btnRptDrawerClick(Sender: TObject);
begin

  frxrpt1.LoadFromFile(AppPath + 'rpt/Drawer.fr3');
  frxRpt1.Script.AddVariable('WPath', 'String', AppPath);
  frxRpt1.ShowReport();
end;

procedure TF_Prt_Drawer.frxUDs_DrawerCheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  Eof := rpt_index >= Length(List.cabDrawer);
end;

procedure TF_Prt_Drawer.frxUDs_DrawerFirst(Sender: TObject);
begin
  rpt_index := 0;
end;

procedure TF_Prt_Drawer.frxUDs_DrawerGetValue(const VarName: string;
  var Value: Variant);
begin
  with List.cabDrawer[rpt_index] do
  begin
    if VarName = 'Name'   then Value := Name;
    if VarName = 'ChBang' then Value := ChBang;
    if VarName = 'ChWei'  then Value := ChWei;
    if VarName = 'ChDi'   then Value := ChDi;

  end;
end;

procedure TF_Prt_Drawer.frxUDs_DrawerNext(Sender: TObject);
begin
  Inc(rpt_index);
end;

procedure TF_Prt_Drawer.frxUDs_DrawerPrior(Sender: TObject);
begin
  Dec(rpt_index);
end;

end.
