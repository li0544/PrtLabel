unit U_Prt_Prd_DoorOth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UPub, UParam, UADO, IniFiles, UDebug;

type
  TF_Prt_Prd_DoorOth = class(TForm)
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_Prd_DoorOth: TF_Prt_Prd_DoorOth;
  lab: array of TLabel;
  edt: array of TEdit;

implementation

{$R *.dfm}

procedure TF_Prt_Prd_DoorOth.btnOKClick(Sender: TObject);
var
  i: Integer;
  ado1: TADO;
  strSQL: string;
  s1: string;
begin
  if List.doorOth_val.Count = 0 then
    List.doorOth_val.Add('');

  List.doorOth_val[0] := '';
  for i := 0 to List.doorOth_col.Count - 1 do
    List.doorOth_val[0] := List.doorOth_val[0] + edt[i].Text + ';';

  ado1 := TADO.Create(nil);
  strSQL := 'DELETE FROM DoorOth WHERE ListID=''' + List.strListID + '''';
  ado1.Cmd(strSQL);

  strSQL := 'INSERT INTO DoorOth (ListID';
  s1 := '''' + List.strListID + '''';
  for i := 0 to List.doorOth_col.Count - 1 do
  begin
    strSQL := strSQL + ',' + List.doorOth_col[i];
    s1 := s1 + ',''' + edt[i].Text + '''';
  end;

  strSQL := strSQL + ') VALUES (' + s1 + ')';
  ado1.Cmd(strSQL);
  ado1.Free;

  Close;
end;

procedure TF_Prt_Prd_DoorOth.FormCreate(Sender: TObject);
var
  inif: TIniFile;
  i, j: Integer;
begin
  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  List.doorOth_col := TStringList.Create;
  List.doorOth_col.Delimiter := ';';
  List.doorOth_col.DelimitedText := inif.ReadString('PrdOpt','Field_Door_Oth','');
  inif.Free;

  List.doorOth_val := TStringList.Create;

  SetLength(lab, List.doorOth_col.Count);
  SetLength(edt, List.doorOth_col.Count);
  for i := 0 to List.doorOth_col.Count - 1 do
  begin
    lab[i] := TLabel.Create(Self);
    lab[i].Parent := Self;
    lab[i].Top := i * 30 + 20;
    lab[i].Left := 20;
    lab[i].Width := 80;
    lab[i].Caption := List.doorOth_col[i];
    lab[i].Show;

    edt[i] := TEdit.Create(Self);
    edt[i].Parent := Self;
    edt[i].Top := i * 30 + 20;
    edt[i].Left := 100;
    edt[i].Width := 300;
    edt[i].Show;
  end;


end;

procedure TF_Prt_Prd_DoorOth.FormShow(Sender: TObject);
var
  i, j: Integer;
  ado1: TADO;
  strSQL: string;
  MyClass: TComponent;
begin

  ado1 := TADO.Create(nil);
  MyClass := TComponent.Create(Self);

  try
    strSQL := 'SELECT * FROM DoorOth WHERE ListID=''' + List.strListID + '''';
    ado1.Sel(strSQL);

    for i := 0 to List.doorOth_col.Count - 1 do
      edt[i].Text := VarToStr( ado1.Fields[i + 1].Value );
  except
    on ex: Exception do
    begin
      SendError(ex.Message);

      strSQL := 'create table DoorOth ( '
        + 'ListID   varchar(20)';

      for i := 0 to List.doorOth_col.Count - 1 do
        strSQL := strSQL + ',' + List.doorOth_col[i] + ' varchar(100)';

      strSQL := strSQL + ')';

      ado1.Cmd(strSQL);
    end;
  end;

  ado1.Free;

end;

end.
