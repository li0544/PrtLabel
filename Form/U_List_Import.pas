unit U_List_Import;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls, ExtCtrls, RzPanel, DB, ADODB,
  UParam, UDebug, DBGridEhGrouping, GridsEh, DBGridEh, UADO, UAppTools;

type
  T_Variant = record                            //变量
    v_ID    : Integer;                          //变量名称id
    i_v2    : Integer;                          // ?
    d_val   : Real;                             //变量值
  end;

  T_Part = record
    board_ID  : Integer;                        //板材名称id
    exp_ID    : Integer;                        //表达式id
    i_v3      : Integer;                        //?
    b1        : Byte;                           //?
    b2        : Byte;                           //?
    b3        : Byte;                           //?
    b4        : Byte;                           //?
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
/// 导入数据
/// </summary>
/// <param name="Sender"></param>
procedure TF_List_Import.btnImportClick(Sender: TObject);
var
  i,j,k: Integer;
  strSQL: string;
  ado1, ado2, ado3: TADO;
  var1: array of T_Variant;
  part1: array of T_Part;
  stream: TMemoryStream;
  b1: array of Byte;
  b4 : TArr_Byte4;
  b8 : TArr_Byte8;
begin
  EnterMethod('导入数据');
  ado1 := TADO.Create(nil);
  ado2 := TADO.Create(nil);
  ado3 := TADO.Create(nil);
  ado1.ConnectionString := getConStr_Import(1);
  ado2.ConnectionString := getConStr_Import(1);
  ado3.ConnectionString := getConStr_Import(2);
  for i := 0 to chklst1.Items.Count - 1 do
  begin
    if chklst1.Checked[i] then
    begin
      EnterMethod('读取数据');
      Send('订单编号：' + chklst1.Items[i]);
      List.strListID := chklst1.Items[i];                //订单号

      ado1.Sel('select * from OrderForm WHERE Number=''' + List.strListID + '''');

      if ado1.RecordCount = 1 then
      begin
        List.strSDate   := ado1.Fs('OutDate');            //安装日期
        List.strUseName := ado1.Fs('ClientName');         //客户名称
        List.strAddress := ado1.Fs('ClientAddr');         //客户地址
        List.strUsePho  := ado1.Fs('ClientContact');      //客户电话
        List.CreateDate := ado1.Fs('CreateDate');         //创建日期
        List.State      := ado1.Fs('Status');             //状态
        List.Prc_Pay    := ado1.Fd('Pay');                //金额
        List.Prc_Income := ado1.Fd('income');             //已付
        List.Index      := ado1.Fi('index');              //id

        //只有一条记录
        ado2.Sel('SELECT * FROM Break WHERE OrderIndex=' + IntToStr(List.Index));
        List.CZhDoor    := ado2.Fs('doormartial');        //门板材质
        List.CZhBody    := ado2.Fs('bodymartial');        //柜体材质
        List.CZhBack    := ado2.Fs('backmartial');        //背板材质

        SetLength(List.cab, ado2.RecordCount);

        //variant
        stream := TMemoryStream.Create();
        TBlobField(ado2.FieldByName('variant')).SaveToStream(stream);
        SetLength(var1, stream.Size div sizeof(var1[0]));
        SetLength(b1, stream.Size);
        stream.Position := 0;
        stream.ReadBuffer(b1[0], stream.Size);
        stream.Free;
        //Send(ByteToStr(TArr_Byte(b1)));
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
          ado3.Sel('select variant from variant where index=' + IntToStr(var1[j].v_ID));
          Send(ado3.Fs('variant'));

        end;

        //part
        stream := TMemoryStream.Create();
        TBlobField(ado2.FieldByName('part')).SaveToStream(stream);
        SetLength(part1, stream.Size div sizeof(part1[0]));
        SetLength(b1, stream.Size);
        stream.Position := 0;
        stream.ReadBuffer(b1[0], stream.Size);
        stream.Free;
        //Send(ByteToStr(TArr_Byte(b1)));
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
          ado3.Sel('select [name] from part where index=' + IntToStr(part1[j].board_ID));
          Send(ado3.Fs('name'));

          ado3.Sel('select index,expressions_width,expressions_length,cabinetsub,partname,counts,material_name,craftwork from expressions where index=' + IntToStr(part1[j].exp_ID));
          Send(TADOQuery(ado3));
        end;
        ExitMethod('读取数据');
      end
      else
      begin
        Send('找不到订单：' + List.strListID);
      end;

    end;

  end;
  ado1.Free;
  ado2.Free;
  ExitMethod('导入数据');
end;

/// <summary>
/// 导入数据设置
/// </summary>
/// <param name="Sender"></param>
procedure TF_List_Import.btnOptClick(Sender: TObject);
begin
  F_List_Import_Opt.ShowModal;
end;

/// <summary>
/// 查询订单
/// </summary>
/// <param name="Sender"></param>
procedure TF_List_Import.btnQueryClick(Sender: TObject);
var
  strSQL: string;
  i: Integer;
begin
  EnterMethod('查询订单号');
  AQry1.Close;
  AQry2.Close;

  AQry1.ConnectionString := getConStr_Import(1);
  AQry2.ConnectionString := getConStr_Import(2);

  decDatFile();      //转存最新数据文件

  strSQL := 'SELECT * FROM orderform WHERE createdate >=''' + FormatDateTime('yyyy-mm-dd',datePicStart.Date)
    + ''' AND createdate <=''' + FormatDateTime('yyyy-mm-dd',datePicEnd.Date) + '''';

  AQry1.SQL.Clear;
  AQry1.SQL.Add(strSQL);
  AQry1.Open;
  Send(strSQL + #13#10 + '返回结果个数：' + IntToStr(AQry1.RecordCount));

  chklst1.Items.Clear;
  for i := 0 to AQry1.RecordCount - 1 do
  begin
    chklst1.Items.Add(AQry1.FieldValues['number']);
    AQry1.Next;
  end;
  AQry1.Close;

  ExitMethod('查询订单号');
end;

procedure TF_List_Import.FormCreate(Sender: TObject);
begin
  AQry1 := TADOQuery.Create(nil);
  AQry2 := TADOQuery.Create(nil);

  datePicStart.Date := Now;
  datePicEnd.Date := Now;

  grid1.Align := alClient;
end;

end.
