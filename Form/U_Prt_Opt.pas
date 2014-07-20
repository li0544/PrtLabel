unit U_Prt_Opt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, U_Price, U_Debug,
  UPub, UParam, ExtCtrls, Spin, U_Reg, UADO;

type
  TF_Prt_Opt = class(TForm)
    qry1: TADOQuery;
    qry2: TADOQuery;
    ds1: TDataSource;
    Panel1: TPanel;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    LblLineWidth: TLabel;
    lbl17: TLabel;
    lbl15: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdtPrd: TEdit;
    BtnSave1: TButton;
    EdtPrc: TEdit;
    EdtFZBody: TEdit;
    EdtTabW: TEdit;
    EdtPro: TEdit;
    EdtFZTitl: TEdit;
    BtnDefault1: TButton;
    BtnClose1: TButton;
    EdtTabLineH: TEdit;
    EdtfLBottom: TEdit;
    CBoxFName: TCheckBox;
    grp2: TGroupBox;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl12: TLabel;
    chk1: TCheckBox;
    cbb1: TComboBox;
    BtnLaShou: TButton;
    edt5: TEdit;
    btn4: TButton;
    edt6: TEdit;
    btn5: TButton;
    edt7: TEdit;
    btn6: TButton;
    edt8: TEdit;
    btn7: TButton;
    btn10: TButton;
    btn11: TButton;
    chk2: TCheckBox;
    btn13: TButton;
    LblHide: TLabel;
    Label4: TLabel;
    EdtAddYear: TEdit;
    EdtMinTit: TEdit;
    Label5: TLabel;
    EdtfbDoor: TEdit;
    lbl3: TLabel;
    lbl11: TLabel;
    EdtfbBody: TEdit;
    EdtBodD: TEdit;
    tboxBankID1: TEdit;
    tboxBankID2: TEdit;
    tboxBankID3: TEdit;
    lab1: TLabel;
    lab2: TLabel;
    lab3: TLabel;
    procedure chk1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbb1Change(Sender: TObject);
    procedure BtnLaShouClick(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure chk2Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure lbl12Click(Sender: TObject);
    procedure lbl12MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbl12MouseLeave(Sender: TObject);
    procedure BtnSave1Click(Sender: TObject);
    procedure BtnDefault1Click(Sender: TObject);
    procedure BtnClose1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LblHideClick(Sender: TObject);
  private
    { Private declarations }

    procedure SetDefaultVal();
  public
    { Public declarations }
    procedure LoadListInfo();
    procedure SaveListInfo();
    function  LoadVal(strName: string): string;
    procedure SaveVal(strName,strVal: string);
    procedure ref1();
  end;

var
  F_Prt_Opt: TF_Prt_Opt;
  sql: string;

const
  S_TAB_COL : array [ 0..8 ] of string = (
  '����������' , '���ϼƻ���' , '���۵�' ,
  '�����ֺ�' ,   '�����ֺ�' ,   '��ĺ��' ,
  '���߿��' , '����и�' ,   '�����±߾�' );

implementation

uses
  U_Prt, U_Flash;
{$R *.dfm}

procedure TF_Prt_Opt.SaveVal(strName,strVal: string);
var
  strSQL : string;
begin
  strSQL := 'SELECT * FROM TOption WHERE ���� LIKE ''' + strName + '''';
  AQrySel(qry1, strSQL);
  if qry1.RecordCount > 0 then
    strSQL := 'UPDATE TOption SET Val=''' + strVal + ''' WHERE ����=''' + strName + ''''
  else
    strSQL := 'INSERT INTO TOption(����, Val) VALUES(''' + strName + ''', ''' + strVal + ''')';
  AQryCmd(Qry1, strSQL);
end;

function TF_Prt_Opt.LoadVal(strName: string): string;
var
  strSQL : string;
begin
	strSQL := 'SELECT * FROM TOption WHERE ����=''' + strName + '''';
	AQrySel(Qry1 , strSQL);
	Result := FieldStr( Qry1, 'Val' );
end;

procedure TF_Prt_Opt.SetDefaultVal();
begin
  try
    strTabPrc   := EdtPrc.Text;
    strTabPrd   := EdtPrd.Text;
    strTabPro   := EdtPro.Text;
    IntBodD     := StrToInt(EdtBodD.Text);
    fzTitle     := StrToInt(EdtFZTitl.Text);
    fzBody      := StrToInt(EdtFZBody.Text);
    fLBoottom   := StrToFloat(EdtfLBottom.Text);
    TabLineH    := StrToFloat(EdtTabLineH.Text);
    ILineWidth  := 0 - StrToInt(EdtTabW.Text);
    BoolFName   := CBoxFName.Checked;
    IntAddYear  := StrToInt(EdtAddYear.Text);
    fzMinTit    := StrToInt(EdtMinTit.Text);
    fbDoor      := StrToFloat(EdtfbDoor.Text);
    fbBody      := StrToFloat(EdtfbBody.Text);
    fbBack      := 0;
  except
    ShowMessage('����Ĳ�������ȷ����������˶Ժ����ԣ�');
  end;
end;

procedure TF_Prt_Opt.LoadListInfo();
begin
  EdtPrd.Text       := LoadVal('����������');    //����������
  EdtPro.Text       := LoadVal('���ϼƻ���');    //���ϼƻ���
  EdtPrc.Text       := LoadVal('���۵�');        //���۵�
  EdtFZTitl.Text    := LoadVal('�����ֺ�');      //�����ֺ�
  EdtFZBody.Text    := LoadVal('�����ֺ�');      //�����ֺ�
  EdtBodD.Text      := LoadVal('��ĺ��');      //��ĺ��
  EdtTabW.Text      := LoadVal('���߿��');    //���߿��
  EdtTabLineH.Text  := LoadVal('����и�');      //����и�
  EdtfLBottom.Text  := LoadVal('�����±߾�');    //�����±߾�
  CBoxFName.Checked := StoB(LoadVal('FtoID'));   //�ļ�����Ϊ������
  EdtAddYear.Text   := LoadVal('�������+');     //�������+
  EdtMinTit.Text    := LoadVal('С�����ֺ�');    //С�����ֺ�
  EdtfbDoor.Text    := LoadVal('�Ű���');      //�Ű���
  EdtfbBody.Text    := LoadVal('������');      //������
  tboxBankID1.Text  := LoadVal('���п���1');
  tboxBankID2.Text  := LoadVal('���п���2');
  tboxBankID3.Text  := LoadVal('���п���3');

  SetDefaultVal();

end;

procedure TF_Prt_Opt.SaveListInfo();
var
  i : Integer ;
begin

  
  SaveVal('����������',  EdtPrd.Text);            //����������
  SaveVal('���ϼƻ���' , EdtPro.Text);            //���ϼƻ���
  SaveVal('���۵�' ,     EdtPrc.Text);            //���۵�
  SaveVal('��ĺ��' ,   EdtBodD.Text);           //��ĺ��
  SaveVal('�����ֺ�' ,   EdtFZTitl.Text);         //�����ֺ�
  SaveVal('�����ֺ�' ,   EdtFZBody.Text);         //�����ֺ�
  SaveVal('���߿��' , EdtTabW.Text);           //���߿��
  SaveVal('����и�' ,   EdtTabLineH.Text);       //����и�
  SaveVal('�����±߾�' , EdtfLBottom.Text);       //�����±߾�
  SaveVal('FtoID' ,      BtoS(CBoxFName.Checked));//�ļ�����Ϊ������
  SaveVal('�������+' ,  EdtAddYear.Text);        //�������+
  SaveVal('С�����ֺ�' , EdtMinTit.Text);         //С�����ֺ�
  SaveVal('�Ű���',    EdtfbDoor.Text);         //�Ű���
  SaveVal('������',    EdtfbBody.Text);         //������
  SaveVal('���п���1',   tboxBankID1.Text);
  SaveVal('���п���2',   tboxBankID2.Text);
  SaveVal('���п���3',   tboxBankID3.Text);

  SetDefaultVal();
end;


procedure TF_Prt_Opt.chk1Click(Sender: TObject);
begin
  sql := 'SELECT TOP 1 * FROM TOption WHERE ���� LIKE ''��������''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  qry1.Edit;
  if qry1.RecordCount = 0 then
  begin
    qry1.Append;
    qry1.FieldValues['����'] := '��������';
  end;
  qry1.FieldValues['Val'] := chk1.Checked;
  qry1.Post;
end;

procedure TF_Prt_Opt.ref1();
var
  i: Integer;
begin


  sql := 'SELECT TOP 1 * FROM TOption WHERE ���� LIKE ''��������''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
    chk1.Checked := StrToBool( qry1.FieldValues['Val'] );


  sql := 'SELECT TOP 1 * FROM TOption WHERE ���� LIKE ''��˿�װ�''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
    chk2.Checked := StrToBool( qry1.FieldValues['Val'] );

  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=2 AND nam LIKE ''���Ͻ�����''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
    edt6.Text := qry1.FieldValues['prc'];

  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''���͹�''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
    edt5.Text := qry1.FieldValues['prc'];

  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''ˮ�۹�1''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
    edt7.Text := qry1.FieldValues['prc'];

  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''ˮ�۹�2''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
    edt8.Text := qry1.FieldValues['prc'];

  sql := 'SELECT * FROM TPrice WHERE Type=4';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  cbb1.Clear;
  for i := 1 to qry1.RecordCount do
  begin
    cbb1.Items.Add(qry1.FieldValues['nam']);
    qry1.Next;
  end;

  sql := 'SELECT * FROM TPrice WHERE Type=4 AND chk=''True''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
  begin
    cbb1.Text := qry1.FieldValues['nam'];
    lbl10.Caption := qry1.FieldValues['prc'];
  end;
    //cbb1.Style:=csDropDownList;
end;

procedure TF_Prt_Opt.FormCreate(Sender: TObject);
begin
  qry1.Close;
  qry2.Close;
  qry1.ConnectionString := getConStr();
  qry2.ConnectionString := getConStr();
  ref1;
  btn13.Hide;
end;

procedure TF_Prt_Opt.cbb1Change(Sender: TObject);
var
  i: Integer;
begin
  Sql := 'SELECT * FROM TPrice WHERE Type=4';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
  begin
    for i := 1 to qry1.RecordCount do
    begin
      qry1.Edit;
      qry1.FieldValues['chk'] := '0';
      qry1.Post;
      qry1.Next;
    end;
  end;
  sql := 'SELECT * FROM TPrice WHERE Type=4 AND nam LIKE ''' + cbb1.Text + '''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  if qry1.RecordCount > 0 then
  begin
    lbl10.Caption := qry1.FieldValues['prc'];
    qry1.Edit;
    qry1.FieldValues['chk'] := '1';
    qry1.Post;
  end
  else
    Exit;

  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=2 AND nam LIKE ''����''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  qry1.Edit;
  if qry1.RecordCount = 0 then
  begin
    qry1.Append;
    qry1.FieldValues['nam'] := '����';
  end;
  qry1.FieldValues['prc'] := StrToFloat(lbl10.Caption);
  qry1.Post;
end;

procedure TF_Prt_Opt.BtnLaShouClick(Sender: TObject);
begin
  F_Price.Show;
end;

procedure TF_Prt_Opt.btn10Click(Sender: TObject);
begin
  ref1;
end;

procedure TF_Prt_Opt.btn5Click(Sender: TObject);
begin
  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=2 AND nam LIKE ''���Ͻ�����''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  qry1.Edit;
  if qry1.RecordCount = 0 then
  begin
    qry1.Append;
    qry1.FieldValues['nam'] := '���Ͻ�����';
  end;
  qry1.FieldValues['prc'] := edt6.Text;
  qry1.Post;

end;

procedure TF_Prt_Opt.btn4Click(Sender: TObject);
begin
  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''���͹�''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  qry1.Edit;
  if qry1.RecordCount > 0 then
    qry1.FieldValues['prc'] := edt5.Text;
  qry1.Post;
end;

procedure TF_Prt_Opt.btn6Click(Sender: TObject);
begin
  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''ˮ�۹�1''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  qry1.Edit;
  if qry1.RecordCount > 0 then
    qry1.FieldValues['prc'] := edt7.Text;
  qry1.Post;
end;

procedure TF_Prt_Opt.btn7Click(Sender: TObject);
begin
  sql := 'SELECT TOP 1 * FROM TPrice WHERE Type=3 AND nam LIKE ''ˮ�۹�2''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  qry1.Edit;
  if qry1.RecordCount > 0 then
    qry1.FieldValues['prc'] := edt8.Text;
  qry1.Post;
end;

procedure TF_Prt_Opt.chk2Click(Sender: TObject);
begin
  sql := 'SELECT TOP 1 * FROM TOption WHERE ���� LIKE ''��˿�װ�''';
  qry1.SQL.Clear;
  qry1.SQL.Add(sql);
  qry1.Open;
  qry1.Edit;
  if qry1.RecordCount = 0 then
  begin
    qry1.Append;
    qry1.FieldValues['����'] := '��˿�װ�';
  end;
  qry1.FieldValues['Val'] := chk2.Checked;
  qry1.Post;
end;

procedure TF_Prt_Opt.btn13Click(Sender: TObject);
begin
  with F_Prt do
  begin
    F_Debug.Show;
  end;
  Close;
end;

procedure TF_Prt_Opt.lbl12Click(Sender: TObject);
begin
  if MessageDlg('ȷ��Ҫ���ע����Ϣ�����ע����Ϣ���´�������Ҫ��������ע����~',
    mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin
    with F_Prt do
    begin
      DeleteKeyFile();
      ShowMessage('ע����Ϣ�����������Ҫ����������������ע����~');
      Close;
    end;
  end;
end;

procedure TF_Prt_Opt.lbl12MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lbl12.Font.Color := clRed;
end;

procedure TF_Prt_Opt.lbl12MouseLeave(Sender: TObject);
begin
  lbl12.Font.Color := clBlack;
end;

procedure TF_Prt_Opt.BtnSave1Click(Sender: TObject);
begin
  SaveListInfo();
end;

procedure TF_Prt_Opt.BtnDefault1Click(Sender: TObject);
begin
  
  EdtPrd.Text       := '***����˾ ����';     //����������
  EdtPrc.Text       := '***����ר����';        //���۵�
  EdtPro.Text       := 'U''Green �˸�Ҿ�';    //���ϼƻ���
  EdtFZBody.Text    := '12';                   //�����ֺ�
  EdtFZTitl.Text    := '26';                   //�����ֺ�
  EdtTabW.Text      := '1';                    //���߿��
  EdtBodD.Text      := '15';                   //��ĺ��
  EdtTabLineH.Text  := '1.5' ;                 //����и�
  EdtfLBottom.Text  := '0.05';                 //�����±߾�
  CBoxFName.Checked := False ;                 //�ļ�����Ϊ������
  EdtMinTit.Text    := '14';                   //С�����ֺ�
  EdtAddYear.Text   := '2';                    //�������+
  EdtfbDoor.Text    := '2';                    //�Ű���
  EdtfbBody.Text    := '2';                    //������
  tboxBankID1.Text  := '';
  tboxBankID2.Text  := '';
  tboxBankID3.Text  := '';
end;

procedure TF_Prt_Opt.BtnClose1Click(Sender: TObject);
begin
  F_Flash.Show;
  Hide;
end;

procedure TF_Prt_Opt.FormResize(Sender: TObject);
begin
  Panel1.TOP := (F_Prt_Opt.Height - Panel1.Height) div 2;
  Panel1.Left := (F_Prt_Opt.Width - Panel1.Width) div 2;
end;

procedure TF_Prt_Opt.LblHideClick(Sender: TObject);
begin
  if LblHide.Caption = '<<' then
  begin
    LblHide.Caption := '>>';
    F_Prt.Panel2.Hide;
  end
  else
  begin
    LblHide.Caption := '<<';
    F_Prt.Panel2.Show;
  end;
end;

end.








