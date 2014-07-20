object F_PB: TF_PB
  Left = 329
  Top = 435
  BorderStyle = bsDialog
  Caption = #36827#24230
  ClientHeight = 62
  ClientWidth = 287
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object pb1: TProgressBar
    Left = 7
    Top = 18
    Width = 273
    Height = 25
    Position = 15
    Smooth = True
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 104
  end
end
