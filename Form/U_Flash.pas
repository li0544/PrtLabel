unit U_Flash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sf_flash, StdCtrls;

type
  TF_Flash = class(TForm)
    sfFlashPlayer1: TsfFlashPlayer;
    sfFlashList1: TsfFlashList;
    LblHide: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure LblHideClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Flash: TF_Flash;

implementation

uses U_Prt;

{$R *.dfm}

procedure TF_Flash.FormCreate(Sender: TObject);
begin
  sfFlashPlayer1.Align := alClient;
  sfFlashPlayer1.FlashIndex := 0;
end;

procedure TF_Flash.FormActivate(Sender: TObject);
begin
  sfFlashPlayer1.Play;
end;

procedure TF_Flash.FormHide(Sender: TObject);
begin
  sfFlashPlayer1.Stop;
end;

procedure TF_Flash.LblHideClick(Sender: TObject);
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
