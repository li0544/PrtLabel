unit U_List_Opt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, UPub, UParam, U_Prt_Opt, UADO,
  ComCtrls;

type
  TF_List_Opt = class(TForm)
    grp3: TGroupBox;
    lbl13: TLabel;
    lbl14: TLabel;
    lbl16: TLabel;
    lbl17: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    EdtPrd: TEdit;
    EdtPrc: TEdit;
    AQry1: TADOQuery;
    EdtAddress: TEdit;
    EdtPhone: TEdit;
    EdtName: TEdit;
    EdtPro: TEdit;
    DatUpt: TDateTimePicker;
    Label1: TLabel;
    grpMQP: TGroupBox;
    grpQJG: TGroupBox;
    ChkBoxMQP: TCheckBox;
    Lbl3: TLabel;
    EdtMQP_A: TEdit;
    ChkBoxQJG: TCheckBox;
    BtnHD: TButton;
    BtnSave: TButton;
    BtnDefault: TButton;
    Lbl4: TLabel;
    EdtFBGY: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnDefaultClick(Sender: TObject);
    procedure BtnHDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReadListInfo();
    procedure WriteListInfo();
  end;

var
  F_List_Opt: TF_List_Opt;
  STR_COL : array [ 0..7 ] of string = (
  '客户姓名',
  '联系方式',
  '安装地址',
  '生产制作单',
  '开料计划表',
  '报价单',
  '交货日期',
  '封边工艺');

implementation

{$R *.dfm}

procedure TF_List_Opt.FormCreate(Sender: TObject);
begin
  AQry1.Close;
  AQry1.ConnectionString := getConStr();
  Height := 278;
end;

procedure TF_List_Opt.ReadListInfo();
var
  strSQL : string;
begin
  strSQL := 'SELECT * FROM List WHERE ListID=''' + strListID + '''';
  if AQrySel(AQry1 , strSQL ) = 0 then Exit;

  EdtName.Text    := FieldStr(AQry1 , STR_COL[0]);
  EdtPhone.Text   := FieldStr(AQry1 , STR_COL[1]);
  EdtAddress.Text := FieldStr(AQry1 , STR_COL[2]);
  EdtPrd.Text     := FieldStr(AQry1 , STR_COL[3]);
  EdtPro.Text     := FieldStr(AQry1 , STR_COL[4]);
  EdtPrc.Text     := FieldStr(AQry1 , STR_COL[5]);
  DatUpt.DateTime := StrToDate(FieldStr(AQry1 , STR_COL[6]));
  EdtFBGY.Text    := FieldStr(AQry1 , STR_COL[7]);

  ReadIniFile();
  ChkBoxMQP.Checked := ItoB(ptMQP);
  ChkBoxQJG.Checked := ItoB(ptCutSize);
  EdtMQP_A.Text     := ItoS(ptMQP_A);
end;

procedure TF_List_Opt.WriteListInfo();
var
  strSQL : string;
begin
  strSQL := 'UPDATE List SET '
  + STR_COL[0] + '=''' + EdtName.Text                                 + ''', '
  + STR_COL[1] + '=''' + EdtPhone.Text                                + ''', '
  + STR_COL[2] + '=''' + EdtAddress.Text                              + ''', '
  + STR_COL[3] + '=''' + EdtPrd.Text                                  + ''', '
  + STR_COL[4] + '=''' + EdtPro.Text                                  + ''', '
  + STR_COL[5] + '=''' + EdtPrc.Text                                  + ''', '
  + STR_COL[6] + '=''' + FormatDateTime( 'yyyy-MM-dd' , DatUpt.Date ) + ''', '
  + STR_COL[7] + '=''' + EdtFBGY.Text                                 + ''' '
  + 'WHERE ListID=''' + strListID + '''';
  AQryCmd(AQry1 , strSQL ) ;

  ptCutSize := BtoI(ChkBoxQJG.Checked);
  ptMQP     := BtoI(ChkBoxMQP.Checked);
  ptMQP_A   := StoI(EdtMQP_A.Text);
  SaveIniFile();

end;

procedure TF_List_Opt.BtnSaveClick(Sender: TObject);
begin
  WriteListInfo();
  Close;
end;

procedure TF_List_Opt.BtnDefaultClick(Sender: TObject);
begin
  F_Prt_Opt.LoadListInfo();
  EdtPrc.Text := strTabPrc;
  EdtPro.Text := strTabPro;
  EdtPrd.Text := strTabPrd;
end;

procedure TF_List_Opt.BtnHDClick(Sender: TObject);
begin
  F_Prt_Opt.LoadListInfo();
  F_Prt_Opt.Show;
  Close;
end;

end.
