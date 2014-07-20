unit U_Pb;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, ExtCtrls;

type
    TF_PB = class(TForm)
        pb1: TProgressBar;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    private
    { Private declarations }                                                       
    public
    { Public declarations }
    end;

var
    F_PB: TF_PB;

implementation

{$R *.dfm}

procedure TF_PB.FormActivate(Sender: TObject);
begin
//  pb1.Position := 1;
//  Timer1.Enabled := True;
end;

procedure TF_PB.FormHide(Sender: TObject);
begin
//  Timer1.Enabled := False;
end;

procedure TF_PB.Timer1Timer(Sender: TObject);
begin
  if pb1.Position < pb1.Max then pb1.Position := pb1.Position + 1
  else pb1.Position := 5;
  Refresh;
end;

end.

