unit U_PBRun;

interface

uses
  Classes, U_Pb, SysUtils;

type
  TPBRun = class(TThread)
  BoolRun: Boolean;
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods AND properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  AND UpdateCaption could look LIKE,

    procedure PBRun.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ PBRun }

procedure TPBRun.Execute;
var
  i : Integer;
begin
  with F_PB do
  begin
    while BoolRun do
    begin
      if pb1.Position < pb1.Max then pb1.Position := pb1.Position + 5
      else pb1.Position := 1;
      Sleep(10);
    end;
  end;
end;

end.
