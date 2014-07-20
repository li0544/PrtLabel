object F_Prt_OutPacking: TF_Prt_OutPacking
  Left = 0
  Top = 0
  Caption = #25171#21360#22806#21253#35013
  ClientHeight = 305
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grpbox1: TRzGroupBox
    Left = 22
    Top = 135
    Width = 434
    Height = 99
    Caption = #35774#32622
    TabOrder = 0
    object lab10: TLabel
      Left = 17
      Top = 24
      Width = 48
      Height = 13
      Caption = #29983#20135#21333#20301
    end
    object lab11: TLabel
      Left = 169
      Top = 24
      Width = 24
      Height = 13
      Caption = #30005#35805
    end
    object lab12: TLabel
      Left = 17
      Top = 59
      Width = 48
      Height = 13
      Caption = #19978#26588#21069#32512
    end
    object lab13: TLabel
      Left = 169
      Top = 59
      Width = 48
      Height = 13
      Caption = #19979#26588#21069#32512
    end
    object tboxUnit: TRzEdit
      Left = 71
      Top = 20
      Width = 80
      Height = 21
      TabOrder = 0
    end
    object tboxPrefixU: TRzEdit
      Left = 71
      Top = 55
      Width = 80
      Height = 21
      TabOrder = 1
    end
    object tboxPrefixD: TRzEdit
      Left = 223
      Top = 55
      Width = 80
      Height = 21
      TabOrder = 2
    end
    object tboxPhone: TRzEdit
      Left = 223
      Top = 20
      Width = 80
      Height = 21
      TabOrder = 3
    end
    object btnOptSave: TRzBitBtn
      Left = 329
      Top = 52
      Width = 81
      Caption = #20445#23384#35774#32622
      TabOrder = 4
      OnClick = btnOptSaveClick
    end
  end
  object grpbox2: TRzGroupBox
    Left = 23
    Top = 8
    Width = 433
    Height = 121
    TabOrder = 1
    object lab1: TLabel
      Left = 16
      Top = 18
      Width = 48
      Height = 13
      Caption = #35746#21333#32534#21495
    end
    object lab2: TLabel
      Left = 172
      Top = 18
      Width = 24
      Height = 13
      Caption = #19978#26588
    end
    object lab3: TLabel
      Left = 298
      Top = 18
      Width = 24
      Height = 13
      Caption = #32972#26495
    end
    object lab4: TLabel
      Left = 16
      Top = 53
      Width = 48
      Height = 13
      Caption = #26631#31614#24635#25968
    end
    object lab5: TLabel
      Left = 172
      Top = 53
      Width = 24
      Height = 13
      Caption = #19979#26588
    end
    object lab6: TLabel
      Left = 298
      Top = 53
      Width = 24
      Height = 13
      Caption = #20116#37329
    end
    object lab7: TLabel
      Left = 16
      Top = 88
      Width = 48
      Height = 13
      Caption = #23458#25143#22995#21517
    end
    object lab8: TLabel
      Left = 160
      Top = 88
      Width = 48
      Height = 13
      Caption = #23458#25143#22320#22336
    end
    object tboxNBack: TRzEdit
      Left = 328
      Top = 15
      Width = 80
      Height = 21
      Text = '0'
      TabOrder = 0
      OnChange = tboxNTopChange
    end
    object tboxNTop: TRzEdit
      Left = 202
      Top = 15
      Width = 80
      Height = 21
      Text = '0'
      TabOrder = 1
      OnChange = tboxNTopChange
    end
    object tboxNDown: TRzEdit
      Left = 202
      Top = 50
      Width = 80
      Height = 21
      Text = '0'
      TabOrder = 2
      OnChange = tboxNTopChange
    end
    object tboxNHardW: TRzEdit
      Left = 328
      Top = 50
      Width = 80
      Height = 21
      Text = '0'
      TabOrder = 3
      OnChange = tboxNTopChange
    end
    object tboxlistID: TRzEdit
      Left = 70
      Top = 15
      Width = 80
      Height = 21
      TabOrder = 4
    end
    object tboxNCount: TRzEdit
      Left = 70
      Top = 50
      Width = 80
      Height = 21
      Text = '0'
      TabOrder = 5
      OnChange = tboxNCountChange
    end
    object tboxUserNam: TRzEdit
      Left = 70
      Top = 85
      Width = 80
      Height = 21
      TabOrder = 6
    end
    object tboxAddress: TRzEdit
      Left = 214
      Top = 85
      Width = 194
      Height = 21
      TabOrder = 7
    end
  end
  object btnPrtView: TRzBitBtn
    Left = 245
    Top = 256
    Width = 81
    Caption = #25171#21360#39044#35272
    TabOrder = 2
    OnClick = btnPrtViewClick
  end
  object btnCancel: TRzBitBtn
    Left = 351
    Top = 256
    Width = 81
    Caption = #21462#28040
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object frxDs_OutPacking: TfrxUserDataSet
    UserName = 'frxDs_OutPacking'
    OnCheckEOF = frxDs_OutPackingCheckEOF
    OnFirst = frxDs_OutPackingFirst
    OnNext = frxDs_OutPackingNext
    OnPrior = frxDs_OutPackingPrior
    Fields.Strings = (
      'strListID'
      'useName'
      'address'
      'cabName'
      'cabH_H_D'
      'cabCount'
      'cabI_N'
      'cabNo'
      'coName'
      'coPhon')
    OnGetValue = frxDs_OutPackingGetValue
    Left = 88
    Top = 248
  end
  object frxRprt1: TfrxReport
    Version = '4.9.32'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41366.592077048600000000
    ReportOptions.LastChange = 41367.384971331020000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 40
    Top = 248
    Datasets = <
      item
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 100.000000000000000000
      PaperHeight = 50.000000000000000000
      PaperSize = 256
      LeftMargin = 1.000000000000000000
      RightMargin = 1.000000000000000000
      TopMargin = 1.000000000000000000
      BottomMargin = 1.000000000000000000
      DataSet = frxDs_OutPacking
      DataSetName = 'frxDs_OutPacking'
      object Memo1: TfrxMemoView
        Left = 113.385900000000000000
        Width = 45.354360000000000000
        Height = 18.897650000000000000
        ShowHint = False
        Memo.UTF8W = (
          #23458#25143#21517)
      end
      object Memo2: TfrxMemoView
        Width = 45.354360000000000000
        Height = 18.897650000000000000
        ShowHint = False
        Memo.UTF8W = (
          #35746#21333#21495)
      end
      object frxDs1strListID: TfrxMemoView
        Left = 45.354360000000000000
        Width = 68.031540000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'strListID'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."strListID"]')
      end
      object frxDs1useName: TfrxMemoView
        Left = 158.740260000000000000
        Width = 56.692950000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'useName'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."useName"]')
      end
      object Memo3: TfrxMemoView
        Top = 18.897650000000000000
        Width = 34.015770000000000000
        Height = 18.897650000000000000
        ShowHint = False
        Memo.UTF8W = (
          #24635#25968)
      end
      object frxDs1cabCount: TfrxMemoView
        Left = 34.015770000000000000
        Top = 18.897650000000000000
        Width = 79.370130000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'cabCount'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."cabCount"]')
      end
      object frxDs1cabI_N: TfrxMemoView
        Left = 113.385900000000000000
        Top = 18.897650000000000000
        Width = 102.047310000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'cabI_N'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."cabI_N"]')
      end
      object frxDs1cabName: TfrxMemoView
        Top = 37.795300000000000000
        Width = 75.590600000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'cabName'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."cabName"]')
      end
      object frxDs1cabH_H_D: TfrxMemoView
        Left = 120.944960000000000000
        Top = 37.795300000000000000
        Width = 94.488250000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'cabH_H_D'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."cabH_H_D"]')
      end
      object frxDs1address: TfrxMemoView
        Top = 56.692950000000000000
        Width = 215.433210000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'address'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."address"]')
      end
      object frxDs1coName: TfrxMemoView
        Top = 75.590600000000000000
        Width = 113.385900000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'coName'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."coName"]')
      end
      object frxDs1coPhon: TfrxMemoView
        Left = 113.385900000000000000
        Top = 75.590600000000000000
        Width = 102.047310000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'coPhon'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."coPhon"]')
      end
      object frxDs1cabNo: TfrxMemoView
        Left = 75.590600000000000000
        Top = 37.795300000000000000
        Width = 45.354360000000000000
        Height = 18.897650000000000000
        ShowHint = False
        DataField = 'cabNo'
        DataSet = frxDs_OutPacking
        DataSetName = 'frxDs_OutPacking'
        Memo.UTF8W = (
          '[frxDs_OutPacking."cabNo"]')
      end
    end
  end
end
