unit U_Price_Add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB , UPub, UParam, UADO;

type
  TF_Price_Add = class(TForm)
    lbl1: TLabel;
    edt1: TEdit;
    lbl2: TLabel;
    edt2: TEdit;
    lbl3: TLabel;
    cbb1: TComboBox;
    chk1: TCheckBox;
    BtnSave: TButton;
    BtnCancel: TButton;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure edt2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Add(t: Integer);
    procedure Edit(t: Integer; s1: string; i1: Double; s2: string; b1: Boolean);
  end;

var
  F_Price_Add: TF_Price_Add;
  v1: string;
  v2: Double;
  v3: string;
  v4: Boolean;
  tab: Integer;
  typ: Integer;
  sql: string;
  
implementation

{$R *.dfm}
uses
  U_Price, U_Prt;

procedure TF_Price_Add.Add(t: Integer);
begin
  tab := t;
  typ := 1;
  edt1.Clear;
  edt2.Text := '0';
  cbb1.Clear;
end;

procedure TF_Price_Add.Edit(t: Integer; s1: string; i1: Double; s2: string; b1: Boolean);
begin
  v1 := s1;
  v2 := i1;
  v3 := s2;
  v4 := b1;
  tab := t;
  typ := 2;
  edt1.Text := v1;
  edt2.Text := VarToStr(v2);
  cbb1.Text := v3;
  chk1.Checked := v4;
end;

procedure TF_Price_Add.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TF_Price_Add.BtnSaveClick(Sender: TObject);
var
  tabnam: string;
begin
  with F_Prt do
  begin
    if (edt1.Text = '') OR (edt2.Text = '') then
    begin
      ShowMessage('名称和价格不能为空');
      Exit;
    end;
    if cbb1.Text = '' then
      cbb1.Text := ' ';

    case tab of
      1: tabnam := 'Type=1';
      2: tabnam := 'Type=2';
      4: tabnam := 'Type=4';
      0: F_Price_Add.Close;
    end;

    if typ = 2 then
    begin
      sql := 'SELECT * FROM TPrice WHERE ' + tabnam + ' AND nam LIKE ''' + v1 + '''';
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      if qry1.RecordCount > 0 then
      begin
        qry1.Edit;
        qry1.FieldValues['nam'] := edt1.Text;
        qry1.FieldValues['prc'] := edt2.Text;
        qry1.FieldValues['unt'] := cbb1.Text;
        qry1.FieldValues['chk'] := chk1.Checked;
        qry1.FieldValues['Type'] := tab;
        qry1.Post;
      end;
    end
    else
    if typ = 1 then
    begin
      sql := 'SELECT TOP 1 * FROM TPrice WHERE ' + tabnam;
      qry1.SQL.Clear;
      qry1.SQL.Add(sql);
      qry1.Open;
      qry1.Edit;
      qry1.Append;
      qry1.FieldValues['nam'] := edt1.Text;
      qry1.FieldValues['prc'] := edt2.Text;
      qry1.FieldValues['unt'] := cbb1.Text;
      qry1.FieldValues['chk'] := chk1.Checked;
      qry1.FieldValues['Type'] := tab;
      qry1.Post;

    end;

  end;
  Close;
end;

procedure TF_Price_Add.edt2Change(Sender: TObject);
begin
  try
    StrToFloat(edt2.Text);
  except
    edt2.Clear;
  end;
end;

procedure TF_Price_Add.FormCreate(Sender: TObject);
var
  AQry1: TADOQuery;
begin
  AQry1 := TADOQuery.Create(nil);
  AQry1.ConnectionString := getConStr();
//  with D_ADO do
//  begin
    AQry1.SQL.Clear;
    AQry1.SQL.Add('SELECT distinct(unt) AS unt1 FROM TPrice');
    AQry1.Open;
    while not AQry1.Eof do
    begin
      cbb1.Items.Add(VarToStr(AQry1.FieldValues['unt1']));
      AQry1.Next;
    end;
//  end;
  AQry1.Close;
  AQry1.Free;
end;

end.

