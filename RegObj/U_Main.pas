unit U_Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, U_RegObj, StdCtrls, ExtCtrls, U_Reg, Clipbrd,
    CnWaterImage, jpeg, WinSkinData;

type
    TF_Main = class(TForm)
        grp1: TGroupBox;
        lbl6: TLabel;
        lbl7: TLabel;
        edt1: TEdit;
        edt2: TEdit;
        btn1: TButton;
        btn2: TButton;
        btn3: TButton;
        btn4: TButton;
        dlgSave1: TSaveDialog;
        mmo1: TMemo;
    tmr1: TTimer;
    wi1: TCnWaterImage;
    SkinData1: TSkinData;
        procedure FormCreate(Sender: TObject);
        procedure edt1Change(Sender: TObject);
        procedure btn4Click(Sender: TObject);
        procedure btn1Click(Sender: TObject);
        procedure btn2Click(Sender: TObject);
        procedure btn3Click(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
    end;

var
    F_Main: TF_Main;
    AObj: TRegObj;

implementation

{$R *.dfm}

procedure TF_Main.FormCreate(Sender: TObject);
begin
    edt1.Clear;
    edt2.Clear;
    mmo1.Clear;
    mmo1.Hide;
end;

procedure TF_Main.edt1Change(Sender: TObject);
begin
    if edt1.Text <> '' then
    begin
        if Length(Trim(edt1.Text)) = 19 then
            edt2.Text := GetKey(edt1.Text)
        else
            edt2.Text := '注册码不正确~';
    end;
end;

procedure TF_Main.btn4Click(Sender: TObject);
begin
    Close;
end;

procedure TF_Main.btn1Click(Sender: TObject);
begin
    edt1.Text := Clipboard.AsText;
end;

procedure TF_Main.btn2Click(Sender: TObject);
begin
    Clipboard.AsText := edt2.Text;
end;

procedure TF_Main.btn3Click(Sender: TObject);
begin
    mmo1.Lines.Append('注册码：' + edt1.Text);
    mmo1.Lines.Append('序列号：' + edt2.Text);
    mmo1.Lines.Append('');
    mmo1.Lines.Append(DateTimeToStr(Now));
    dlgSave1.InitialDir := Application.ExeName;
    dlgSave1.DefaultExt := 'txt';
    dlgSave1.Filter := '文本文件(*.txt)|*.txt';
    dlgSave1.FileName := 'PrtLab序列号_' + VarToStr(Date);
    if dlgSave1.Execute then
        mmo1.Lines.SaveToFile(dlgSave1.FileName);
end;

end.

