object F_Prt_LabIII: TF_Prt_LabIII
  Left = 480
  Top = 359
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #25171#21360#26631#31614
  ClientHeight = 129
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object BtnPrintDoor: TButton
    Left = 45
    Top = 43
    Width = 76
    Height = 25
    Caption = #25171#21360#38376#26495
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = BtnPrintDoorClick
  end
  object BtnPrintBody: TButton
    Tag = 1
    Left = 133
    Top = 43
    Width = 76
    Height = 25
    Caption = #25171#21360#26588#20307#26495
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BtnPrintBodyClick
  end
  object BtnPrintBack: TButton
    Tag = 2
    Left = 221
    Top = 43
    Width = 76
    Height = 25
    Caption = #25171#21360#32972#26495
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = BtnPrintBackClick
  end
  object frxRprt1: TfrxReport
    Version = '4.9.32'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41365.815400347200000000
    ReportOptions.LastChange = 41366.480711076390000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    Left = 40
    Top = 80
    Datasets = <
      item
        DataSet = frxDs_Lab
        DataSetName = 'frxDs_Lab'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 60.000000000000000000
      PaperHeight = 30.000000000000000000
      PaperSize = 256
      LeftMargin = 1.000000000000000000
      RightMargin = 1.000000000000000000
      TopMargin = 1.000000000000000000
      BottomMargin = 1.000000000000000000
      object MasterData1: TfrxMasterData
        Height = 76.692950000000000000
        Top = 18.897650000000000000
        Width = 219.212740000000000000
        DataSet = frxDs_Lab
        DataSetName = 'frxDs_Lab'
        RowCount = 0
        object frxDs1strListID: TfrxMemoView
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'strListID'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."strListID"]')
        end
        object frxDs1strSDate: TfrxMemoView
          Left = 143.622140000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'strSDate'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."strSDate"]')
        end
        object Memo2: TfrxMemoView
          Left = 79.370130000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            #20132#36135#26085#26399#65306)
        end
        object Memo3: TfrxMemoView
          Top = 18.897650000000000000
          Width = 45.354360000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            #22320#22336#65306)
        end
        object frxDs1strAddress: TfrxMemoView
          Left = 45.354360000000000000
          Top = 18.897650000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'strAddress'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."strAddress"]')
        end
        object frxDs1cabW_H_D: TfrxMemoView
          Left = 117.165430000000000000
          Top = 56.692950000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'cabW_H_D'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."cabW_H_D"]')
        end
        object frxDs1bodName: TfrxMemoView
          Top = 37.795300000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'bodName'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."bodName"]')
        end
        object frxDs1bodCZh: TfrxMemoView
          Left = 113.385900000000000000
          Top = 18.897650000000000000
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'bodCZh'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."bodCZh"]')
        end
        object frxDs1bodH_W: TfrxMemoView
          Left = 94.488250000000000000
          Top = 37.795300000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'bodH_W'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."bodH_W"]')
        end
        object frxDs1bodI_N: TfrxMemoView
          Left = 170.078850000000000000
          Top = 37.795300000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'bodI_N'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."bodI_N"]')
        end
        object frxDs1labI_N: TfrxMemoView
          Left = 170.078850000000000000
          Top = 18.897650000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'labI_N'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."labI_N"]')
        end
        object frxDs1cabOth: TfrxMemoView
          Top = 56.692950000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'cabOth'
          DataSet = frxDs_Lab
          DataSetName = 'frxDs_Lab'
          Memo.UTF8W = (
            '[frxDs1."cabOth"]')
        end
      end
    end
  end
  object frxDs_Lab: TfrxUserDataSet
    UserName = 'frxDs_Lab'
    OnCheckEOF = frxDs_LabCheckEOF
    OnFirst = frxDs_LabFirst
    OnNext = frxDs_LabNext
    OnPrior = frxDs_LabPrior
    Fields.Strings = (
      'strListID'
      'strSDate'
      'strAddress'
      'bodCZh'
      'Index'
      'labIndex'
      'labI_N'
      'cabID'
      'cabName'
      'cabTypeID'
      'cabOth'
      'cabW_H_D'
      'bodID'
      'bodName'
      'bodH_W'
      'bodI_N'
      'bodInfo'
      'bodNum'
      'bodCount'
      'bodW'
      'bodH'
      'useName')
    OnGetValue = frxDs_LabGetValue
    Left = 96
    Top = 80
  end
end
