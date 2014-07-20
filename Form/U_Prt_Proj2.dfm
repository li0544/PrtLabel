object F_Prt_Proj2: TF_Prt_Proj2
  Left = 261
  Top = 313
  Caption = #24320#26009#35745#21010#34920
  ClientHeight = 133
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object btn1: TButton
    Left = 86
    Top = 58
    Width = 106
    Height = 24
    Caption = #25171#21360#24320#26009#35745#21010#34920
    TabOrder = 0
    OnClick = btn1Click
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
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 40
    Top = 8
  end
  object qry2: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 72
    Top = 8
  end
  object qry3: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 104
    Top = 8
  end
  object qry4: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 136
    Top = 8
  end
  object qry5: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 168
    Top = 8
  end
  object qry6: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 200
    Top = 8
  end
  object qry7: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 232
    Top = 8
  end
  object qry8: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 264
    Top = 8
  end
end
