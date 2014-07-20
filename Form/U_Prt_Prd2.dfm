object F_Prt_Prd2: TF_Prt_Prd2
  Left = 268
  Top = 270
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #25171#21360#29983#20135#21046#20316#21333
  ClientHeight = 110
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object BtnPrintProduce: TButton
    Left = 44
    Top = 43
    Width = 104
    Height = 27
    Caption = #25171#21360#26588#20307#26495
    TabOrder = 0
    OnClick = BtnPrintProduceClick
  end
  object Button1: TButton
    Tag = 1
    Left = 156
    Top = 43
    Width = 104
    Height = 27
    Caption = #25171#21360#38376#26495
    TabOrder = 1
    OnClick = BtnPrintProduceClick
  end
  object Button2: TButton
    Tag = 2
    Left = 268
    Top = 43
    Width = 104
    Height = 27
    Caption = #25171#21360#20116#37329
    TabOrder = 2
    OnClick = BtnPrintProduceClick
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
    Left = 8
    Top = 8
  end
  object qry1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from prt_proj')
    Left = 184
    Top = 8
  end
  object qry2: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 216
    Top = 8
  end
  object qry3: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 248
    Top = 8
  end
  object ds1: TDataSource
    DataSet = qry1
    Left = 280
    Top = 8
  end
  object RvSysBody: TRvSystem
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
    OnPrint = RvSysBodyPrint
    Left = 40
    Top = 8
  end
  object RvSysDoor: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'Rave Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    OnPrint = RvSysDoorPrint
    Left = 72
    Top = 8
  end
  object RvSysHDW: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'Rave Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    OnPrint = RvSysHDWPrint
    Left = 104
    Top = 8
  end
  object RvSysHDW2: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'Rave Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    OnPrint = RvSysHDW2Print
    Left = 136
    Top = 8
  end
end
