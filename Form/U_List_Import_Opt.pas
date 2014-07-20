unit U_List_Import_Opt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, DB, ADODB, UParam;

type
  TF_List_Import_Opt = class(TForm)
    tboxPass: TEdit;
    btnPath1: TButton;
    Label1: TLabel;
    tboxFile1: TEdit;
    Label2: TLabel;
    tboxFile2: TEdit;
    Label3: TLabel;
    btnPath2: TButton;
    btnTest: TButton;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnPath1Click(Sender: TObject);
    procedure btnPath2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_List_Import_Opt: TF_List_Import_Opt;

implementation

{$R *.dfm}

procedure TF_List_Import_Opt.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TF_List_Import_Opt.btnPath1Click(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(Self);
  dlg.Filter := 'dat文件|anaor.dat|所有文件|*.*';
  if dlg.Execute() then
  begin
    tboxFile1.Text := dlg.FileName;
  end;
end;

procedure TF_List_Import_Opt.btnPath2Click(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(Self);
  dlg.Filter := 'dat文件|Material.dat|所有文件|*.*';
  if dlg.Execute() then
  begin
    tboxFile2.Text := dlg.FileName;
  end;
end;

procedure TF_List_Import_Opt.btnSaveClick(Sender: TObject);
var
  iniFile : TIniFile;
  path, file1, file2, pass: string;
begin
  path    := ExtractFilePath(tboxFile1.Text);
  file1   := ExtractFileName(tboxFile1.Text);
  file2   := ExtractFileName(tboxFile2.Text);
  pass    := tboxPass.Text;

  iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  iniFile.WriteString('dbDat', 'dat1', file1);
  iniFile.WriteString('dbDat', 'dat2', file2);
  iniFile.WriteString('dbDat', 'datPath', path);
  iniFile.WriteString('dbDat', 'datPswd', pass);
  iniFile.Free;

  ShowMessage('保存成功');
end;

procedure TF_List_Import_Opt.btnTestClick(Sender: TObject);
var
  ADOQry1: TADOQuery;
begin

  decDatFile(tboxFile1.Text);
  decDatFile(tboxFile2.Text);

  try
    ADOQry1 := TADOQuery.Create(nil);
    ADOQry1.ConnectionString := getConStr_Import(1);
    ADOQry1.SQL.Clear;
    ADOQry1.SQL.Add('select * from Config');
    ADOQry1.Open;
    ADOQry1.Close;
    ADOQry1.Free;
    ShowMessage('测试成功');
  except
    ShowMessage('测试失败');
  end;

end;

procedure TF_List_Import_Opt.FormCreate(Sender: TObject);
var
  inifile: TIniFile;
  path, file1, file2, pass: string;
begin
  inifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  file1 	:= IniFile.ReadString('dbDat', 'dat1', 'anaor.dat')	;
  file2   := IniFile.ReadString('dbDat', 'dat2', 'Material.dat');
  path    := IniFile.ReadString('dbDat', 'datPath',  ' ')	;
  pass  	:= IniFile.ReadString('dbDat', 'datPswd',  'jeff&&)@@%'  )	;
  inifile.Free;
  tboxFile1.Text := path + file1;
  tboxFile2.Text := path + file2;
  tboxPass.Text  := pass;
end;

end.
