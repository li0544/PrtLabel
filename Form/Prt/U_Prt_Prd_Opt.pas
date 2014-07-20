unit U_Prt_Prd_Opt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzButton, RzLabel, jpeg, ExtCtrls, RzPanel,
  IniFiles, U_List;

type
  TF_Prt_Prd_Opt = class(TForm)
    panel2: TRzPanel;
    img1: TImage;
    label1: TRzLabel;
    group1: TGroupBox;
    listBox1: TListBox;
    group2: TGroupBox;
    btnAdd: TRzBitBtn;
    btnDel: TRzBitBtn;
    btnCancel: TRzBitBtn;
    btnSave: TRzBitBtn;
    Label2: TLabel;
    tboxName: TEdit;
    Label3: TLabel;
    tboxCode: TMemo;
    btnBack: TRzBitBtn;
    procedure btn_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure listBox1Click(Sender: TObject);
    procedure tboxNameChange(Sender: TObject);
    procedure tboxCodeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Prt_Prd_Opt: TF_Prt_Prd_Opt;
  sName : TStringList;
  sCode : TStringList;

implementation

uses
  U_Prt;

{$R *.dfm}

procedure TF_Prt_Prd_Opt.btn_Click(Sender: TObject);
var
  i : Integer;
  i_btn : Integer;
  sl : TStringList;
  s1 : string;
  inif : TIniFile;
begin


  i_btn := 0;
  if Sender is TRzButton then
    i_btn := (Sender as TRzButton).Tag;

  sl := TStringList.Create;

  case i_btn of
    //add
    1:
    begin
      if tboxName.Text <> '' then
      begin
        for i := 0 to sName.Count - 1 do
        begin
          if tboxName.Text = sName[i] then
          begin
            ShowMessage('改名称已存在');
            Exit;
          end;
        end;

        sName.Add(tboxName.Text);
        listBox1.Items.Add(tboxName.Text);

        tboxCode.Text := Trim(tboxCode.Text);
        s1 := '';
        for i := 0 to tboxCode.Lines.Count - 1 do
        begin
          if (i <> 0) and (Trim(tboxCode.Lines[i]) <> '') then
          begin
            s1 := s1 + ',' + tboxCode.Lines[i];
          end;

          if i = 0 then
            s1 := tboxCode.Lines[i];
        end;
        sCode.Add(s1);
      end;

    end;
    //del
    2:
    begin
      if Application.MessageBox('确定要删除吗？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = IDCANCEL then
      begin
        Exit;
      end;

      i := listBox1.ItemIndex;

      if i < sName.Count then
      begin
        sName.Delete(i);
        sCode.Delete(i);
        listBox1.Items.Delete(i);
      end;

    end ;
    //save
    3:
    begin
      inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

      s1 := '';
      for i := 0 to sName.Count - 1 do
      begin
        if i <> 0 then s1 := s1 + ';';
        s1 := s1 + sName[i];
      end;
      inif.WriteString('PrdOpt', 'Field_Name', s1);

      s1 := '';
      for i := 0 to sCode.Count - 1 do
      begin
        if i <> 0 then s1 := s1 + ';';
        s1 := s1 + sCode[i];
      end;
      inif.WriteString('PrdOpt', 'Field_Code', s1);

      inif.Free;
    end;
    4:
    begin
      inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

      sName.Delimiter := ';';
      sCode.Delimiter := ';';
      sName.DelimitedText := inif.ReadString('PrdOpt', 'Field_Name', '');
      sCode.DelimitedText := inif.ReadString('PrdOpt', 'Field_Code', '');

      inif.Free;

      listBox1.Items := sName;
    end;
    9:
    begin

      showForm(F_List);
    end;


  end;

  sl.Free;

end;


procedure TF_Prt_Prd_Opt.FormCreate(Sender: TObject);
var
  inif : TIniFile;
begin
  sName := TStringList.Create;
  sCode := TStringList.Create;
  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

  sName.Delimiter := ';';
  sCode.Delimiter := ';';
  sName.DelimitedText := inif.ReadString('PrdOpt', 'Field_Name', '');
  sCode.DelimitedText := inif.ReadString('PrdOpt', 'Field_Code', '');

  inif.Free;

  listBox1.Items := sName;
end;

procedure TF_Prt_Prd_Opt.listBox1Click(Sender: TObject);
var
  i: Integer;
  sl : TStringList;
begin
  i := listBox1.ItemIndex;
  tboxName.Text := sName[i];

  sl := TStringList.Create;
  sl.Delimiter := ',';
  sl.DelimitedText := sCode[i];
  tboxCode.Lines := sl;

  sl.Free;
end;

procedure TF_Prt_Prd_Opt.tboxCodeChange(Sender: TObject);
var
  i : Integer;
  s1 : string;
begin
  tboxCode.Text := Trim(tboxCode.Text);
  s1 := '';
  for i := 0 to tboxCode.Lines.Count - 1 do
  begin
    if (i <> 0) and (Trim(tboxCode.Lines[i]) <> '') then
    begin
      s1 := s1 + ',' + tboxCode.Lines[i];
    end;

    if i = 0 then
      s1 := tboxCode.Lines[i];
  end;

  i := listBox1.ItemIndex;
  sCode[i] := s1;
end;

procedure TF_Prt_Prd_Opt.tboxNameChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to sName.Count - 1 do
  begin
    if tboxName.Text = sName[i] then
    begin
      Exit;
    end;
  end;

  i := listBox1.ItemIndex;
  if i < sName.Count then
  begin
    sName[i] := tboxName.Text;
    listBox1.Items[i] := tboxName.Text;
  end;
end;

end.
