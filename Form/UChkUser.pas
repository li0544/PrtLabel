unit UChkUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, jpeg, CnWaterImage, ExtCtrls, RzPanel, RzButton, StdCtrls,
  Mask, RzEdit, RzLabel, UPub, UParam, IniFiles, CnMD5, UAppTools;

type
  TFChkUser = class(TForm)
    RzLabel2: TRzLabel;
    tboxPass: TRzEdit;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    RzPanel1: TRzPanel;
    CnWaterImage1: TCnWaterImage;
    il1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    i_SH: Integer;
  end;

var
  FChkUser: TFChkUser;

implementation

{$R *.dfm}

procedure TFChkUser.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TFChkUser.btnOKClick(Sender: TObject);
var
  inif: TIniFile;
  b_md5: TMD5Digest;
  b1: TArr_Byte;
  s_md5: string;
  s1: string;
  i: Integer;
begin
  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\Config.ini');
  s1 := inif.ReadString('SysOpt', 'pass', 'admin');
  s1 := StringReplace(s1,' ', '', [rfReplaceAll]);
  if Length(s1) <> 32 then
  begin
    b_md5 := MD5String(s1);
    SetLength(b1, 16);
    for i := 0 to 15 do b1[i] := b_md5[i];
    s1 := ByteToStr(b1);
    s1 := StringReplace(s1,' ', '', [rfReplaceAll]);
    inif.WriteString('SysOpt', 'pass', s1);
  end;
  inif.Free;

  b_md5 := MD5String(tboxPass.Text);
  SetLength(b1, 16);
  for i := 0 to 15 do b1[i] := b_md5[i];
  s_md5 := ByteToStr(b1);
  s_md5 := StringReplace(s_md5,' ', '', [rfReplaceAll]);
  if s1 = s_md5 then
  begin
    ModalResult := mrOk;
    tboxPass.Text := '';
  end
  else
  begin
    ShowMessage('ÃÜÂë²»ÕýÈ·');
  end;
end;

procedure TFChkUser.FormCreate(Sender: TObject);
begin
  CnWaterImage1.Align := alClient;
end;

end.
