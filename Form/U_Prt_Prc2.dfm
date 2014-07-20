object F_Prt_Prc2: TF_Prt_Prc2
  Left = 388
  Top = 241
  Caption = #25171#21360#25253#20215#21333
  ClientHeight = 123
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btn5: TButton
    Left = 110
    Top = 50
    Width = 106
    Height = 24
    Caption = #25171#21360#25253#20215#21333
    TabOrder = 0
    OnClick = btn5Click
  end
  object RvSystem1: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.Orientation = poLandScape
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'Rave Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    OnPrint = RvSystem1Print
    Left = 16
    Top = 8
  end
  object qry1: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#20215#26684)
    Left = 64
    Top = 8
  end
end
