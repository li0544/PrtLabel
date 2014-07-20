object F_Prt_Drawer: TF_Prt_Drawer
  Left = 0
  Top = 0
  Caption = #25277#23625#25253#34920
  ClientHeight = 132
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnRptDrawer: TButton
    Left = 104
    Top = 48
    Width = 105
    Height = 33
    Caption = 'btnPrtDrawer'
    TabOrder = 0
    OnClick = btnRptDrawerClick
  end
  object frxrpt1: TfrxReport
    Version = '4.9.32'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41820.943308750000000000
    ReportOptions.LastChange = 41821.632718275460000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 24
    Top = 8
    Datasets = <
      item
        DataSet = frxUDs_Drawer
        DataSetName = 'ds_drawer'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 275.905690000000000000
        Width = 718.110700000000000000
      end
      object ColumnHeader1: TfrxColumnHeader
        Height = 22.677180000000000000
        Top = 64.252010000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            #21517#31216)
        end
      end
      object ColumnFooter1: TfrxColumnFooter
        Height = 22.677180000000000000
        Top = 230.551330000000000000
        Width = 718.110700000000000000
      end
      object MasterData1: TfrxMasterData
        Height = 22.677180000000000000
        Top = 147.401670000000000000
        Width = 718.110700000000000000
        DataSet = frxUDs_Drawer
        DataSetName = 'ds_drawer'
        RowCount = 0
        object ds_drawerName: TfrxMemoView
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'Name'
          DataSet = frxUDs_Drawer
          DataSetName = 'ds_drawer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[ds_drawer."Name"]')
          ParentFont = False
        end
        object ds_drawerChBang: TfrxMemoView
          Left = 113.385900000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'ChBang'
          DataSet = frxUDs_Drawer
          DataSetName = 'ds_drawer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[ds_drawer."ChBang"]')
          ParentFont = False
        end
        object ds_drawerChWei: TfrxMemoView
          Left = 226.771800000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'ChWei'
          DataSet = frxUDs_Drawer
          DataSetName = 'ds_drawer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[ds_drawer."ChWei"]')
          ParentFont = False
        end
        object ds_drawerChDi: TfrxMemoView
          Left = 377.953000000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'ChDi'
          DataSet = frxUDs_Drawer
          DataSetName = 'ds_drawer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[ds_drawer."ChDi"]')
          ParentFont = False
        end
      end
    end
  end
  object frxUDs_Drawer: TfrxUserDataSet
    UserName = 'ds_drawer'
    OnCheckEOF = frxUDs_DrawerCheckEOF
    OnFirst = frxUDs_DrawerFirst
    OnNext = frxUDs_DrawerNext
    OnPrior = frxUDs_DrawerPrior
    Fields.Strings = (
      'Name'
      'ChBang'
      'ChWei'
      'ChDi')
    OnGetValue = frxUDs_DrawerGetValue
    Left = 88
    Top = 8
  end
end
