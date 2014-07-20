unit U_Debug;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ComCtrls, Menus, ToolWin, ImgList, ExtCtrls, DB,
    ADODB, Grids, DBGrids, UParam, UPub, UADO,
    U_Prt_Prc2;

type
    TF_Debug = class(TForm)
        pgc1: TPageControl;
        ts1: TTabSheet;
    ts2: TTabSheet;
        ts3: TTabSheet;
        mmo1: TMemo;
        tlb1: TToolBar;
        btn1: TToolButton;
        il1: TImageList;
    AQry1: TADOQuery;
        pnl1: TPanel;
        mmo3: TMemo;
        mmo2: TMemo;
        cmd1: TADOCommand;
        ds1: TADODataSet;
        ds2: TDataSource;
    spl1: TSplitter;
    spl2: TSplitter;
    DBGrid1: TDBGrid;
    Edt1: TEdit;
    Edt2: TEdit;
    Edt3: TEdit;
    Edt4: TEdit;
    Btn2: TButton;
    BtnPrtPrc: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure mmo3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn2Click(Sender: TObject);
    procedure BtnPrtPrcClick(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
    end;

var
    F_Debug: TF_Debug;

implementation


{$R *.dfm}

procedure TF_Debug.FormCreate(Sender: TObject);
begin
    pgc1.ActivePageIndex:=0;
    pgc1.Align := alClient;
    mmo1.Align := alClient;
    mmo2.Align := alClient;
    pnl1.Align := alBottom;

    Self.TOP := 10;
    Self.Left := 10;
    mmo1.Clear;
    mmo2.Clear;
    mmo3.Clear;

    AQry1.Close;
    AQry1.ConnectionString := getConStr();
end;

procedure TF_Debug.btn1Click(Sender: TObject);
begin
    mmo1.Clear;
end;

procedure TF_Debug.mmo3KeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
var
    i: Integer;
begin
    if Key = 116 then
    begin
        mmo2.Lines.Append(mmo3.Text);
        try
            AQry1.SQL.Clear;
            AQry1.SQL.Add(mmo3.Text);
            AQry1.Open;
            for i := 1 to DBGrid1.Columns.Count do
                DBGrid1.Columns[i].Width := 100;
        except
            on E: Exception do
            begin
                mmo2.Lines.Append(E.Message);
            end;

        end;
        mmo3.Clear;
    end;
end;

procedure TF_Debug.Btn2Click(Sender: TObject);
var
  d1 : Double;
  i1 , i2 : Integer;
  s1 : string;
begin
  d1 := StrToFloat(Edt1.Text);
  i1 := StrToInt(Edt2.Text);
  i2 := StrToInt(Edt3.Text);
  Str( d1: i1: i2, s1);
  Edt4.Text := s1;
end;

procedure TF_Debug.BtnPrtPrcClick(Sender: TObject);
begin

  F_Prt_Prc2.RvSystem1.Execute;
end;

end.

