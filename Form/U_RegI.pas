unit U_RegI;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls, U_Reg, Clipbrd, jpeg;

type
    TF_RegI = class(TForm)
    grp1: TGroupBox;
    lbl6: TLabel;
    lbl7: TLabel;
    edt1: TEdit;
    edt2: TEdit;
    BtnCopy: TButton;
    BtnPaset: TButton;
    BtnOK: TButton;
    BtnCancel: TButton;
    img1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnPasetClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
    end;

var
    F_RegI: TF_RegI;

implementation



{$R *.dfm}

procedure TF_RegI.FormCreate(Sender: TObject);
begin
    edt1.Text := GetID;
    edt2.Clear;

end;

procedure TF_RegI.BtnCopyClick(Sender: TObject);
begin
    Clipboard.AsText := edt1.Text;
end;

procedure TF_RegI.BtnPasetClick(Sender: TObject);
begin
    edt2.Text := Clipboard.AsText;
end;

procedure TF_RegI.BtnCancelClick(Sender: TObject);
begin
    Close;
end;

procedure TF_RegI.BtnOKClick(Sender: TObject);
begin
    if edt2.Text = '' then
    begin
        ShowMessage('请输入序列号，如果您没有序列号，请联系软件提供商~');
        Exit;
    end;

    WriteKey(edt2.Text);
    ShowMessage('软件需要重新启动，如果注册信息正确，下次将进入软件使用界面~');
    btnCancel.Click;
end;

end.

