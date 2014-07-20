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
        ShowMessage('���������кţ������û�����кţ�����ϵ����ṩ��~');
        Exit;
    end;

    WriteKey(edt2.Text);
    ShowMessage('�����Ҫ�������������ע����Ϣ��ȷ���´ν��������ʹ�ý���~');
    btnCancel.Click;
end;

end.

