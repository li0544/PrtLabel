unit U_List_FB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UADO, UParam, UPub, UDebug, IniFiles;

type
  TF_List_FB = class(TForm)
    grp1: TGroupBox;
    btnSave: TButton;
    btnCancel: TButton;
    radio1: TRadioButton;
    tbox1: TEdit;
    tbox2: TEdit;
    radio2: TRadioButton;
    tbox3: TEdit;
    radio3: TRadioButton;
    GroupBox1: TGroupBox;
    radio4: TRadioButton;
    tbox4: TEdit;
    tbox5: TEdit;
    radio5: TRadioButton;
    tbox6: TEdit;
    radio6: TRadioButton;
    label2: TLabel;
    label3: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_List_FB: TF_List_FB;

implementation

{$R *.dfm}

procedure TF_List_FB.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TF_List_FB.btnSaveClick(Sender: TObject);
var
  ado1: TADO;
  s1: string;
  inif: TIniFile;
begin

  ado1 := TADO.Create(nil);
  ado1.Cmd('UPDATE TCab SET C_W=0,BodNum=0 WHERE ListID=''' + List.strListID + '''');

  if radio1.Checked then s1 := tbox1.Text;
  if radio2.Checked then s1 := tbox2.Text;
  if radio3.Checked then s1 := tbox3.Text;

  ado1.Cmd('UPDATE TCab SET C_W=' + s1 + ' WHERE ListID=''' + List.strListID + '''');

  if radio4.Checked then s1 := tbox4.Text;
  if radio5.Checked then s1 := tbox5.Text;
  if radio6.Checked then s1 := tbox6.Text;

  ado1.Cmd('UPDATE TCab SET BodNum=' + s1 + ' WHERE ListID=''' + List.strListID + '''');

  Close;
end;

end.
