unit U_List_Import;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls, ExtCtrls, RzPanel, DB, ADODB,
  UParam, UDebug, DBGridEhGrouping, GridsEh, DBGridEh, UADO, UAppTools,
  UPub, IniFiles;

type
  T_Variant = record                                                            //����
    v_ID    : Integer;                                                          //��������id
    i_v2    : Integer;                                                          // ?
    d_val   : Real;                                                             //����ֵ

    name    : string;                                                           //��������
  end;

  T_Part = record
    board_ID  : Integer;                                                        //�������id
    exp_ID    : Integer;                                                        //���ʽid
    i_v3      : Integer;                                                        //?
    b1        : Byte;                                                           //?
    b2        : Byte;                                                           //?
    b3        : Byte;                                                           //?
    b4        : Byte;                                                           //?

    name      : string;                                                         //�������
    exp_l     : string;                                                         //���ʽ  ��
    exp_w     : string;                                                         //��
  end;
type
  TF_List_Import = class(TForm)
    panel1: TRzPanel;
    Label2: TLabel;
    Label3: TLabel;
    datePicStart: TDateTimePicker;
    datePicEnd: TDateTimePicker;
    btnQuery: TButton;
    chklst1: TCheckListBox;
    btnImport: TButton;
    btnOpt: TButton;
    grid1: TDBGridEh;
    Splitter1: TSplitter;
    AQry_List: TADOQuery;
    ds1: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnOptClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_List_Import: TF_List_Import;
  AQry1: TADOQuery;
  AQry2: TADOQuery;

implementation

uses U_List_Import_Opt;

{$R *.dfm}

/// <summary>
/// ��������
/// </summary>
/// <param name="Sender"></param>
procedure TF_List_Import.btnImportClick(Sender: TObject);
var
  i,j,k,n: Integer;
  strSQL: string;
  ado1, ado2, ado3: TADO;
  ado4: TADO;
  var1: array of T_Variant;
  part1: array of T_Part;
  stream: TMemoryStream;
  b1: array of Byte;
  b4 : TArr_Byte4;
  b8 : TArr_Byte8;
  s1: string;
  inif: TIniFile;
  strDoor: string;
  s_H, s_W, s_D: string;
begin
  EnterMethod('��������');

  inif := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  strDoor   := inif.ReadString('PrdOpt', 'Field_Door', '');
  s_H       := inif.ReadString('SysOpt', 'H', '����߶�');
  s_W       := inif.ReadString('SysOpt', 'W', '������');
  s_D       := inif.ReadString('SysOpt', 'D', '�������');
  inif.Free;

  ado1 := TADO.Create(nil);
  ado2 := TADO.Create(nil);
  ado3 := TADO.Create(nil);
  ado4 := TADO.Create(nil);
  ado1.ConnectionString := getConStr_Import(1);
  ado2.ConnectionString := getConStr_Import(1);
  ado3.ConnectionString := getConStr_Import(2);
  for i := 0 to chklst1.Items.Count - 1 do                                      //�����б�
  begin
    if chklst1.Checked[i] then
    begin
      EnterMethod('��ȡ����');
      Send('������ţ�' + chklst1.Items[i]);
      List.strListID := chklst1.Items[i];                                       //������

      ado1.Sel('select * from OrderForm WHERE Number=''' + List.strListID + '''');

      if ado1.RecordCount = 1 then
      begin
        List.strSDate   := ado1.Fs('OutDate');                                  //��װ����
        List.strUseName := ado1.Fs('ClientName');                               //�ͻ�����
        List.strAddress := ado1.Fs('ClientAddr');                               //�ͻ���ַ
        List.strUsePho  := ado1.Fs('ClientContact');                            //�ͻ��绰
        List.CreateDate := ado1.Fs('CreateDate');                               //��������
        List.State      := ado1.Fs('Status');                                   //״̬
        List.Prc_Pay    := ado1.Fd('Pay');                                      //���
        List.Prc_Income := ado1.Fd('income');                                   //�Ѹ�
        List.Index      := ado1.Fi('index');                                    //id

        //������¼
        ado2.Sel('SELECT * FROM Break WHERE OrderIndex=' + IntToStr(List.Index));
        List.CZhDoor    := ado2.Fs('doormartial');                              //�Ű����
        List.CZhBody    := ado2.Fs('bodymartial');                              //�������
        List.CZhBack    := ado2.Fs('backmartial');                              //�������

        strSQL := 'DELETE FROM List WHERE ListID=''' + List.strListID + '''';
        ado4.Cmd(strSQL);

        strSQL := 'DELETE FROM TCab WHERE ListID=''' + List.strListID + '''';
        ado4.Cmd(strSQL);

        strSQL := 'DELETE FROM TBod WHERE ListID=''' + List.strListID + '''';
        ado4.Cmd(strSQL);

        strSQL := 'DELETE FROM THDWare WHERE ListID=''' + List.strListID + '''';
        ado4.Cmd(strSQL);

        strSQL := 'INSERT INTO [List](' + crlf
          + '[ListID],[��������],[��װ��ַ],'
          + '[�Ű����],[�������],[��������],[�ͻ�����],[��ϵ��ʽ],'
          + '[�ϼƽ��],[�Ѹ����],[����ʱ��]' + crlf
          + ') VALUES (' + crlf
          + '''' + List.strListID + ''',''' + List.strSDate + ''','''
          + List.strAddress + ''','
          + '''' + List.CZhDoor + ''',''' + List.CZhBack + ''','''
          + List.CZhBody + ''',''' + List.strUseName + ''','''
          + list.strUsePho + ''','
          + '' + FloatToStr(List.Prc_Pay) + ','
          + FloatToStr(List.Prc_Income) + ',''' + List.CreateDate + ''')';
        Send(strSQL);
        ado4.Cmd(strSQL);

        SetLength(List.cab, ado2.RecordCount);

        for n := 0 to ado2.RecordCount - 1 do
        begin
          EnterMethod('���� ' + IntToStr(n) );
          ado3.Sel('SELECT a.*,b.name as name2,b.index as index2 ' + crlf
            + ' FROM cabinetsub a,cabinet b ' + crlf
            + ' WHERE a.cabinet=b.index AND a.index=' + ado2.Fs('subcabinet'));
          List.cab[n].cabName   := ado3.Fs('name');
          List.cab[n].cabID     := ado3.Fs('mark');
          List.cab[n].cabType   := ado3.Fs('name2');
          List.cab[n].cabNum    := ado2.Fi('conuts');
          List.cab[n].doorCZ    := ado2.Fs('doormartial');                      //�Ű����
          List.cab[n].bodyCZ    := ado2.Fs('bodymartial');                      //�������
          List.cab[n].backCZ    := ado2.Fs('backmartial');                      //�������


          {$REGION 'variant'}
          //variant
          stream := TMemoryStream.Create();
          TBlobField(ado2.FieldByName('variant')).SaveToStream(stream);
          SetLength(var1, stream.Size div 16);
          SetLength(b1, stream.Size);
          stream.Position := 0;
          stream.ReadBuffer(b1[0], stream.Size);
          stream.Free;
          //Send(ByteToStr(TArr_Byte(b1)));
          s1 := '��������=' + IntToStr(Length(var1));
          for j := 0 to Length(var1) - 1 do
          begin
            b4[0] := b1[j*16+0];
            b4[1] := b1[j*16+1];
            b4[2] := b1[j*16+2];
            b4[3] := b1[j*16+3];
            CopyMemory(@var1[j].v_ID, @b4, 4);

            b4[0] := b1[j*16+4];
            b4[1] := b1[j*16+5];
            b4[2] := b1[j*16+6];
            b4[3] := b1[j*16+7];
            CopyMemory(@var1[j].i_v2, @b4, 4);

            b8[0] := b1[j*16+8 ];
            b8[1] := b1[j*16+9 ];
            b8[2] := b1[j*16+10];
            b8[3] := b1[j*16+11];
            b8[4] := b1[j*16+12];
            b8[5] := b1[j*16+13];
            b8[6] := b1[j*16+14];
            b8[7] := b1[j*16+15];
            CopyMemory(@var1[j].d_val, @b8, 8);

            //Send(IntToStr(var1[j].v_ID) + ',' + IntToStr(var1[j].i_v2) + ',' + FloatToStr(var1[j].d_val));
            ado3.Sel('select variant from variant where index='
              + IntToStr(var1[j].v_ID));
            var1[j].name := ado3.Fs('variant');                                 //variant name
            //Send(var1[j].name + '=' + FloatToStr(var1[j].d_val));
            s1 := s1 + crlf + var1[j].name + '=' + FloatToStr(var1[j].d_val);

            if Pos(var1[j].name, s_H) > 0 then List.cab[n].cabH := var1[j].d_val;
            if Pos(var1[j].name, s_D) > 0 then List.cab[n].cabD := var1[j].d_val;
            if Pos(var1[j].name, s_W) > 0 then List.cab[n].cabW := var1[j].d_val;
          end;
          Send(s1);

          //strSQL := 'SELECT * FROM TCab WHERE ListID=''' + List.strListID + ''' AND CabIndex=' + IntToStr(n);
          //ado4.Sel(strSQL);

          strSQL := 'INSERT INTO [TCab]('
            + '[ListID],[CabIndex],[CabID],[CabType],'
            + ' [�ߴ�],'
            + ' [Nam],[H],[W],[L],[N],bodyCZ,doorCZ,backCZ'
            + ') VALUES ('
            + '''' + List.strListID + ''',' + IntToStr(n) + ','''
            + List.cab[n].cabID + ''',''' + List.cab[n].cabType + ''','
            + '''' + FloatToStr(List.cab[n].cabH) + '*'
            + FloatToStr(List.cab[n].cabW) + '*'
            + FloatToStr(List.cab[n].cabD) + ''','
            + '''' + List.cab[n].cabName + ''','
            + FloatToStr(List.cab[n].cabH) + ','
            + FloatToStr(List.cab[n].cabW) + ','
            + '' + FloatToStr(List.cab[n].cabD) + ','
            + IntToStr(List.cab[n].cabNum) + ','
            + '''' + List.cab[n].bodyCZ + ''','''
            + List.cab[n].doorCZ + ''',''' + List.cab[n].backCZ + ''')';
          Send(strSQL);
          ado4.Cmd(strSQL);
          {$ENDREGION}


          //part
          stream := TMemoryStream.Create();
          TBlobField(ado2.FieldByName('part')).SaveToStream(stream);
          SetLength(part1, stream.Size div 16);
          SetLength(b1, stream.Size);
          stream.Position := 0;
          stream.ReadBuffer(b1[0], stream.Size);
          stream.Free;
          //Send(ByteToStr(TArr_Byte(b1)));

          SetLength(List.cab[n].bod, Length(part1));
          s1 := '';
          for j := 0 to Length(part1) - 1 do
          begin
            b4[0] := b1[j*16+0];
            b4[1] := b1[j*16+1];
            b4[2] := b1[j*16+2];
            b4[3] := b1[j*16+3];
            CopyMemory(@part1[j].board_ID, @b4, 4);

            b4[0] := b1[j*16+4];
            b4[1] := b1[j*16+5];
            b4[2] := b1[j*16+6];
            b4[3] := b1[j*16+7];
            CopyMemory(@part1[j].exp_ID, @b4, 4);

            b4[0] := b1[j*16+8 ];
            b4[1] := b1[j*16+9 ];
            b4[2] := b1[j*16+10];
            b4[3] := b1[j*16+11];
            CopyMemory(@part1[j].i_v3, @b4, 4);

            part1[j].b1 := b1[j*16+12];
            part1[j].b2 := b1[j*16+13];
            part1[j].b3 := b1[j*16+14];
            part1[j].b4 := b1[j*16+15];

            //Send(IntToStr(part1[j].board_ID) + ',' + IntToStr(part1[j].exp_ID) + ',' + IntToStr(part1[j].i_v3));
            ado3.Sel('select [name] from part where index='
              + IntToStr(part1[j].board_ID));
            part1[j].name := ado3.Fs('name');                                   //part name
            //Send(part1[j].name);

            List.cab[n].bod[j].bodName := part1[j].name;

            if Pos(List.cab[n].bod[j].bodName, strDoor) > 0 then
            begin
              List.cab[n].bod[j].bodCZh := List.cab[n].doorCZ
            end
            else
            if List.cab[n].bod[j].bodName = '����' then
            begin
              List.cab[n].bod[j].bodCZh := List.cab[n].backCZ
            end
            else
              List.cab[n].bod[j].bodCZh := List.cab[n].bodyCZ;

            ado3.Sel('select index,expressions_width,expressions_length,'
              + 'cabinetsub,partname,counts,material_name,craftwork '
              + ' from expressions where index=' + IntToStr(part1[j].exp_ID));
            part1[j].exp_l := ado3.Fs('expressions_length');
            part1[j].exp_w := ado3.Fs('expressions_width');
            //Send(TADOQuery(ado3));
            List.cab[n].bod[j].bodNum   := ado3.Fi('counts');
            List.cab[n].bod[j].bodInfo  := ado3.Fs('material_name');            //����

            try
              for k := 0 to Length(var1) - 1 do
              begin
                part1[j].exp_l := StringReplace(part1[j].exp_l, var1[k].name, FloatToStr(var1[k].d_val), [rfReplaceAll]);
                part1[j].exp_w := StringReplace(part1[j].exp_w, var1[k].name, FloatToStr(var1[k].d_val), [rfReplaceAll]);
              end;

              ado3.Sel('Select variant, default from [variant]');
              for k := 0 to ado3.RecordCount - 1 do
              begin
                part1[j].exp_l := StringReplace(part1[j].exp_l, ado3.Fs('variant'), ado3.Fs('default'), [rfReplaceAll]);
                part1[j].exp_w := StringReplace(part1[j].exp_w, ado3.Fs('variant'), ado3.Fs('default'), [rfReplaceAll]);
                ado3.Next;
              end;

              //ɾ������ո�
              part1[j].exp_l := StringReplace(part1[j].exp_l, ' ', '', [rfReplaceAll]);
              part1[j].exp_w := StringReplace(part1[j].exp_w, ' ', '', [rfReplaceAll]);

              //Math.sqrt()
              part1[j].exp_l := StringReplace(part1[j].exp_l, 'SQRT', 'Math.sqrt', [rfReplaceAll]);
              part1[j].exp_w := StringReplace(part1[j].exp_w, 'SQRT', 'Math.sqrt', [rfReplaceAll]);

              //Send(part1[j].name);
              //Send('exp_l=' + part1[j].exp_l);
              //Send('exp_w=' + part1[j].exp_w);
              if part1[j].exp_l <>'' then part1[j].exp_l := RunJs('s1=' + part1[j].exp_l, 's1');       //length
              if part1[j].exp_w <>'' then part1[j].exp_w := RunJs('s1=' + part1[j].exp_w, 's1');       //width
              //Send('value_l=' + part1[j].exp_l);
              //Send('value_w=' + part1[j].exp_w);

              if part1[j].exp_l <>'' then List.cab[n].bod[j].bodH := StrToFloat(part1[j].exp_l);
              if part1[j].exp_w <>'' then List.cab[n].bod[j].bodW := StrToFloat(part1[j].exp_w);
            except
              on ex: Exception do
              begin
                SendError(ex.Message);
              end;
            end;

            //board
            if (part1[j].exp_l <> '') and (part1[j].exp_w <> '') then
            begin
              strSQL := 'INSERT INTO [TBod]('
                + '[CabTabID],[ListID],[BodIndex],[CabIndex],[BodID],[CabID],'
                + '[���],[����],[���],[����],[��ת],[����],[��ע],[ͼ��],'
                + '[BodName],[CabType],[��;],[����],'
                + '[CabWHD],[BodCount],[��׼��]'
                + ') VALUES ('
                + '0,''' + List.strListID + ''',' + IntToStr(j) + ',' + IntToStr(n) + ','
                + IntToStr(j) + ',''' + List.cab[n].cabID + ''','
                + '' + IntToStr(j) + ',' + part1[j].exp_l + ',' + part1[j].exp_w + ','
                + IntToStr(List.cab[n].bod[j].bodNum) + ',''��'','
                + '''' + List.cab[n].bod[j].bodCZh + ''','''',''' + List.cab[n].cabID + ''','
                +'''' + List.cab[n].bod[j].bodName + ''',''' + List.cab[n].cabType + ''','
                +'''' + List.cab[n].cabName + ''','
                +'''' + List.cab[n].bod[j].bodInfo + ''','''',0,'''')';
              //Send(strSQL);
              ado4.Cmd(strSQL);
            end
            //HDWare
            else
            begin
              strSQL := 'INSERT INTO [THDWare]('
                + '[ListID],[CabIndex],[hdID],[hdIndex],[ͼ��],[nam],'
                + '[���],[����],[����],[ͳ��],[oth]'
                + ') VALUES ('
                + '''' + List.strListID + ''',' + IntToStr(n) + ','
                + IntToStr(j) + ',' + IntToStr(j) + ','''
                + List.cab[n].cabID + ''','''
                + List.cab[n].bod[j].bodName + ''','''','''','
                + IntToStr(List.cab[n].bod[j].bodNum) + ',0,'
                + '''' + List.cab[n].bod[j].bodInfo + ''')';
              //Send(strSQL);
              ado4.Cmd(strSQL);
            end;
            s1 := s1 + strSQL + crlf;
          end;
          Send(s1);

          ado2.Next;
          ExitMethod('���� ' + IntToStr(n) );
        end;
        ExitMethod('��ȡ����');
      end
      else
      begin
        Send('�Ҳ���������' + List.strListID);
      end;

    end;

  end;
  ado1.Free;
  ado2.Free;

  ExitMethod('��������');

  ShowMessage('�����������');
end;

/// <summary>
/// ������������
/// </summary>
/// <param name="Sender"></param>
procedure TF_List_Import.btnOptClick(Sender: TObject);
begin
  F_List_Import_Opt.ShowModal;
end;

/// <summary>
/// ��ѯ����
/// </summary>
/// <param name="Sender"></param>
procedure TF_List_Import.btnQueryClick(Sender: TObject);
var
  strSQL: string;
  i: Integer;
begin
  EnterMethod('��ѯ������');
  AQry1.Close;
  AQry2.Close;

  Send(getConStr_Import(1));
  Send(getConStr_Import(2));
  AQry1.ConnectionString := getConStr_Import(1);
  AQry2.ConnectionString := getConStr_Import(2);

  decDatFile();      //ת�����������ļ�

  strSQL := 'SELECT * FROM orderform WHERE createdate >=''' + FormatDateTime('yyyy-mm-dd',datePicStart.Date)
    + ''' AND createdate <=''' + FormatDateTime('yyyy-mm-dd',datePicEnd.Date) + '''';

  AQry1.SQL.Clear;
  AQry1.SQL.Add(strSQL);
  AQry1.Open;
  Send(strSQL + #13#10 + '���ؽ��������' + IntToStr(AQry1.RecordCount));

  chklst1.Items.Clear;
  for i := 0 to AQry1.RecordCount - 1 do
  begin
    chklst1.Items.Add(AQry1.FieldValues['number']);
    AQry1.Next;
  end;
  AQry1.Close;

  strSQL := 'SELECT * FROM List WHERE ����ʱ�� >=#'
    + FormatDateTime('yyyy-mm-dd',datePicStart.Date) + '# AND ����ʱ�� <=#'
    + FormatDateTime('yyyy-mm-dd',datePicEnd.Date) + '#';
  AQrySel(AQry_List, strSQL);

  ExitMethod('��ѯ������');
end;

procedure TF_List_Import.FormCreate(Sender: TObject);
begin
  AQry1 := TADOQuery.Create(nil);
  AQry2 := TADOQuery.Create(nil);
  AQry_List.ConnectionString := getConStr();

  datePicStart.Date := Now;
  datePicEnd.Date := Now;

  grid1.Align := alClient;
end;

end.
