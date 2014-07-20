object F_Prt_PrdIV: TF_Prt_PrdIV
  Left = 0
  Top = 0
  Caption = #29983#20135#21046#20316#21333
  ClientHeight = 456
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnPrt: TButton
    Left = 48
    Top = 56
    Width = 97
    Height = 33
    Caption = #26588#20307
    TabOrder = 0
    OnClick = btnPrtClick
  end
  object btnPrtDoor: TButton
    Left = 168
    Top = 56
    Width = 97
    Height = 33
    Caption = #38376#26495
    TabOrder = 1
    OnClick = btnPrtDoorClick
  end
  object btnPrtDoorAl: TButton
    Left = 288
    Top = 56
    Width = 97
    Height = 33
    Caption = #38109#26694#38376#38376#26495
    TabOrder = 2
    OnClick = btnPrtDoorAlClick
  end
  object frxrpt1: TfrxReport
    Version = '4.15'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41824.667495023160000000
    ReportOptions.LastChange = 41826.703164143520000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 16
    Top = 128
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 1046.929810000000000000
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 275.905690000000000000
        Width = 1046.929810000000000000
      end
      object MasterData1: TfrxMasterData
        Height = 22.677180000000000000
        Top = 147.401670000000000000
        Width = 1046.929810000000000000
        DataSetName = 'ds_prd'
        RowCount = 0
      end
      object ColumnHeader1: TfrxColumnHeader
        Height = 22.677180000000000000
        Top = 64.252010000000000000
        Width = 1046.929810000000000000
      end
      object ColumnFooter1: TfrxColumnFooter
        Height = 22.677180000000000000
        Top = 230.551330000000000000
        Width = 1046.929810000000000000
      end
    end
  end
  object ADOQry1: TADOQuery
    Parameters = <>
    Left = 96
    Top = 128
  end
  object frxDs1: TfrxDBDataset
    UserName = 'ds_prdIV'
    CloseDataSource = False
    DataSet = ADOQry1
    BCDToCurrency = False
    Left = 72
    Top = 128
  end
  object ADOQry2: TADOQuery
    Parameters = <>
    Left = 160
    Top = 128
  end
  object frxDs2: TfrxDBDataset
    UserName = 'ds_prdIV_Top'
    CloseDataSource = False
    DataSet = ADOQry2
    BCDToCurrency = False
    Left = 136
    Top = 128
  end
  object ADOQry3: TADOQuery
    Parameters = <>
    Left = 248
    Top = 128
  end
  object frxDs3: TfrxDBDataset
    UserName = 'ds_prdIV_Other'
    CloseDataSource = False
    DataSet = ADOQry3
    BCDToCurrency = False
    Left = 224
    Top = 128
  end
  object ADOQry4: TADOQuery
    Parameters = <>
    Left = 328
    Top = 128
  end
  object frxDs4: TfrxDBDataset
    UserName = 'ds_prdIV_Drawer'
    CloseDataSource = False
    DataSet = ADOQry4
    BCDToCurrency = False
    Left = 304
    Top = 128
  end
  object ADOQry5: TADOQuery
    Parameters = <>
    Left = 40
    Top = 184
  end
  object frxDs5: TfrxDBDataset
    UserName = 'ds_prdIV_Door'
    CloseDataSource = False
    DataSet = ADOQry5
    BCDToCurrency = False
    Left = 16
    Top = 184
  end
  object ADOQry6: TADOQuery
    Parameters = <>
    Left = 120
    Top = 184
  end
  object frxDs6: TfrxDBDataset
    UserName = 'ds_prdIV_Door_Top'
    CloseDataSource = False
    DataSet = ADOQry6
    BCDToCurrency = False
    Left = 96
    Top = 184
  end
  object ADOQry7: TADOQuery
    Parameters = <>
    Left = 248
    Top = 192
  end
  object frxDs7: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl'
    CloseDataSource = False
    DataSet = ADOQry7
    BCDToCurrency = False
    Left = 224
    Top = 192
  end
  object ADOQry8: TADOQuery
    Parameters = <>
    Left = 328
    Top = 192
  end
  object frxDs8: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl_Top'
    CloseDataSource = False
    DataSet = ADOQry8
    BCDToCurrency = False
    Left = 304
    Top = 192
  end
  object ADOQry9: TADOQuery
    Parameters = <>
    Left = 40
    Top = 240
  end
  object frxDs9: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl_sum1'
    CloseDataSource = False
    DataSet = ADOQry9
    BCDToCurrency = False
    Left = 16
    Top = 240
  end
  object ADOQry10: TADOQuery
    Parameters = <>
    Left = 104
    Top = 240
  end
  object frxDs10: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl_sum2'
    CloseDataSource = False
    DataSet = ADOQry10
    BCDToCurrency = False
    Left = 80
    Top = 240
  end
  object ADOQry11: TADOQuery
    Parameters = <>
    Left = 168
    Top = 240
  end
  object frxDs11: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl_sum3'
    CloseDataSource = False
    DataSet = ADOQry11
    BCDToCurrency = False
    Left = 144
    Top = 240
  end
  object ADOQry12: TADOQuery
    Parameters = <>
    Left = 232
    Top = 240
  end
  object frxDs12: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl_sum4'
    CloseDataSource = False
    DataSet = ADOQry12
    BCDToCurrency = False
    Left = 208
    Top = 240
  end
  object ADOQry13: TADOQuery
    Parameters = <>
    Left = 304
    Top = 240
  end
  object frxDs13: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl_sum5'
    CloseDataSource = False
    DataSet = ADOQry13
    BCDToCurrency = False
    Left = 280
    Top = 240
  end
  object frxUDs1: TfrxUserDataSet
    UserName = #26588#20307'_'#19978#26588
    Left = 16
    Top = 304
  end
  object frxUDs2: TfrxUserDataSet
    UserName = #26588#20307'_'#19979#26588
    Left = 48
    Top = 304
  end
  object frxUDs3: TfrxUserDataSet
    UserName = #38468#21152#26495'_'#25277#23625
    Left = 80
    Top = 304
  end
end
