object F_Prt_PrdIV: TF_Prt_PrdIV
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #29983#20135#21046#20316#21333
  ClientHeight = 466
  ClientWidth = 505
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
  object label2: TLabel
    Left = 16
    Top = 240
    Width = 108
    Height = 13
    Caption = #25968#37327#38754#31215#32479#35745#38750#26631#20214
  end
  object label3: TLabel
    Left = 16
    Top = 288
    Width = 108
    Height = 13
    Caption = #25968#37327#38754#31215#32479#35745#26631#20934#20214
  end
  object label4: TLabel
    Left = 16
    Top = 192
    Width = 93
    Height = 13
    Caption = #38376#26495' '#38750#38109#26694'_'#38109#26694
  end
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
    Left = 151
    Top = 56
    Width = 97
    Height = 33
    Caption = #38376#26495
    TabOrder = 1
    OnClick = btnPrtDoorClick
  end
  object btnPrtDoorAl: TButton
    Left = 254
    Top = 56
    Width = 97
    Height = 33
    Caption = #38109#26694#38376#38376#26495
    TabOrder = 2
    OnClick = btnPrtDoorAlClick
  end
  object btnHDW: TButton
    Left = 357
    Top = 56
    Width = 97
    Height = 33
    Caption = #20116#37329
    TabOrder = 3
    OnClick = btnHDWClick
  end
  object frxrpt1: TfrxReport
    Version = '4.9.32'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41824.667495023200000000
    ReportOptions.LastChange = 41846.475343587960000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 16
    Top = 128
    Datasets = <
      item
        DataSet = frxDs13
        DataSetName = #38376#26495#25968#37327
      end
      item
        DataSet = F_Prt.frxDs_List
        DataSetName = 'List'
      end>
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
        Height = 26.456692913385800000
        Top = 18.897650000000000000
        Width = 1046.929810000000000000
        object Memo32: TfrxMemoView
          Align = baClient
          Width = 1046.929810000000000000
          Height = 26.456692913385800000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          HAlign = haCenter
          Memo.UTF8W = (
            #38376#26495#36710#38388#29983#20135#21333)
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 589.606680000000000000
        Width = 1046.929810000000000000
      end
      object MasterData1: TfrxMasterData
        Height = 18.897650000000000000
        Top = 245.669450000000000000
        Width = 1046.929810000000000000
        DataSetName = 'ds_prdIV_Door'
        RowCount = 0
        object Memo1: TfrxMemoView
          Left = 37.795300000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #27249#26588#21517#31216
          DataSetName = 'ds_prdIV_Door'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            '[ds_prdIV_Door."'#27249#26588#21517#31216'"]')
          ParentFont = False
        end
        object ds_prdIV_Door: TfrxMemoView
          Left = 151.181200000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #38271#24230
          DataSetName = 'ds_prdIV_Door'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door."'#38271#24230'"]')
          ParentFont = False
        end
        object ds_prdIV_Door1: TfrxMemoView
          Left = 226.771800000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #23485#24230
          DataSetName = 'ds_prdIV_Door'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door."'#23485#24230'"]')
          ParentFont = False
        end
        object ds_prdIV_Door2: TfrxMemoView
          Left = 302.362400000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #25968#37327
          DataSetName = 'ds_prdIV_Door'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door."'#25968#37327'"]')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Width = 37.795300000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[LINE]')
          ParentFont = False
        end
        object ds_prdIV_Door3: TfrxMemoView
          Left = 377.953000000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #25324#21495
          DataSetName = 'ds_prdIV_Door'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door."'#25324#21495'"]')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 453.543600000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
        end
        object Memo15: TfrxMemoView
          Left = 529.134200000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
        end
        object ds_prdIV_DoorCabWHD: TfrxMemoView
          Left = 642.520100000000000000
          Width = 113.385851180000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'CabWHD'
          DataSetName = 'ds_prdIV_Door'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door."CabWHD"]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 774.803650000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          ParentFont = False
        end
      end
      object ColumnHeader1: TfrxColumnHeader
        Height = 52.913420000000000000
        Top = 68.031540000000000000
        Width = 1046.929810000000000000
        object Memo31: TfrxMemoView
          Top = 3.779529999999990000
          Width = 34.015770000000000000
          Height = 30.236240000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            #35746#21333#32534#21495)
          ParentFont = False
        end
        object ListListID: TfrxMemoView
          Left = 37.795300000000000000
          Top = 7.559060000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'ListID'
          DataSet = F_Prt.frxDs_List
          DataSetName = 'List'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            '[List."ListID"]')
          ParentFont = False
        end
        object Memo33: TfrxMemoView
          Left = 188.976500000000000000
          Top = 3.779529999999990000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #23458#25143#22995#21517)
          ParentFont = False
        end
        object Memo34: TfrxMemoView
          Left = 188.976500000000000000
          Top = 26.456710000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #23433#35013#22320#22336)
          ParentFont = False
        end
        object Memo35: TfrxMemoView
          Left = 487.559370000000000000
          Top = 3.779529999999990000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #32852#31995#26041#24335)
          ParentFont = False
        end
        object Memo36: TfrxMemoView
          Left = 487.559370000000000000
          Top = 26.456710000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #23433#35013#26085#26399)
          ParentFont = False
        end
        object Memo37: TfrxMemoView
          Left = 264.567100000000000000
          Top = 3.779529999999990000
          Width = 188.976426770000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #23458#25143#22995#21517
          DataSet = F_Prt.frxDs_List
          DataSetName = 'List'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[List."'#23458#25143#22995#21517'"]')
          ParentFont = False
        end
        object Memo38: TfrxMemoView
          Left = 264.567100000000000000
          Top = 26.456710000000000000
          Width = 188.976377952756000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #23433#35013#22320#22336
          DataSet = F_Prt.frxDs_List
          DataSetName = 'List'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[List."'#23433#35013#22320#22336'"]')
          ParentFont = False
        end
        object Memo39: TfrxMemoView
          Left = 566.929500000000000000
          Top = 3.779529999999990000
          Width = 151.181102362205000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #32852#31995#26041#24335
          DataSet = F_Prt.frxDs_List
          DataSetName = 'List'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[List."'#32852#31995#26041#24335'"]')
          ParentFont = False
        end
        object Memo40: TfrxMemoView
          Left = 566.929500000000000000
          Top = 26.456710000000000000
          Width = 151.181102362205000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #20132#36135#26085#26399
          DataSet = F_Prt.frxDs_List
          DataSetName = 'List'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '[List."'#20132#36135#26085#26399'"]')
          ParentFont = False
        end
      end
      object ColumnFooter1: TfrxColumnFooter
        Height = 75.590600000000000000
        Top = 491.338900000000000000
        Width = 1046.929810000000000000
        object Memo41: TfrxMemoView
          Top = 11.338590000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #32479#35745)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo42: TfrxMemoView
          Top = 30.236240000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #24179#26041)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo43: TfrxMemoView
          Top = 49.133890000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #22359#25968)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo44: TfrxMemoView
          Left = 75.590600000000000000
          Top = 11.338590000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #38376#26495)
          ParentFont = False
          VAlign = vaCenter
        end
        object ds_prdIV_DoorAl_sum5num: TfrxMemoView
          Left = 75.590600000000000000
          Top = 49.133890000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'num'
          DataSet = frxDs13
          DataSetName = #38376#26495#25968#37327
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_DoorAl_sum5."num"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object ds_prdIV_DoorAl_sum5area: TfrxMemoView
          Left = 75.590600000000000000
          Top = 30.236240000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'area'
          DataSet = frxDs13
          DataSetName = #38376#26495#25968#37327
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_DoorAl_sum5."area"]')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object Header1: TfrxHeader
        Height = 41.574830000000000000
        Top = 181.417440000000000000
        Width = 1046.929810000000000000
        object Memo3: TfrxMemoView
          Left = 151.181200000000000000
          Top = 3.779529999999990000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #39640)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo4: TfrxMemoView
          Left = 226.771800000000000000
          Top = 3.779529999999990000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #23485)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo5: TfrxMemoView
          Left = 302.362400000000000000
          Top = 3.779529999999990000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #22359)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo6: TfrxMemoView
          Left = 37.795300000000000000
          Top = 3.779529999999990000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #27249#26588#21517#31216)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo8: TfrxMemoView
          Top = 3.779529999999990000
          Width = 37.795300000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #24207#21495)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo10: TfrxMemoView
          Left = 377.953000000000000000
          Top = 3.779529999999990000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #29305#27530#35828#26126)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo11: TfrxMemoView
          Left = 453.543600000000000000
          Top = 3.779529999999990000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #25289#25163#35828#26126)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo12: TfrxMemoView
          Left = 529.134200000000000000
          Top = 3.779529999999990000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #22791#27880)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo13: TfrxMemoView
          Left = 642.520100000000000000
          Top = 3.779529999999990000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #21253#35013#22797#26680#23610#23544)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo2: TfrxMemoView
          Left = 774.803650000000000000
          Top = 3.779529999999990000
          Width = 272.126160000000000000
          Height = 37.795300000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop]
          Memo.UTF8W = (
            #38468#22270#21450#29305#27530#35828#26126#65306)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo17: TfrxMemoView
          Top = 22.677180000000000000
          Width = 755.906000000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #20197#19979#20026#22320#26588#38376#26495)
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object Footer1: TfrxFooter
        Height = 18.897650000000000000
        Top = 287.244280000000000000
        Width = 1046.929810000000000000
        object Memo16: TfrxMemoView
          Left = 774.803650000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          ParentFont = False
        end
      end
      object MasterData2: TfrxMasterData
        Height = 18.897650000000000000
        Top = 370.393940000000000000
        Width = 1046.929810000000000000
        DataSetName = 'ds_prdIV_Door_Top'
        RowCount = 0
        object Memo21: TfrxMemoView
          Left = 37.795300000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #27249#26588#21517#31216
          DataSetName = 'ds_prdIV_Door_Top'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            '[ds_prdIV_Door_Top."'#27249#26588#21517#31216'"]')
          ParentFont = False
        end
        object Memo22: TfrxMemoView
          Left = 151.181200000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #38271#24230
          DataSetName = 'ds_prdIV_Door_Top'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door_Top."'#38271#24230'"]')
          ParentFont = False
        end
        object Memo23: TfrxMemoView
          Left = 226.771800000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #23485#24230
          DataSetName = 'ds_prdIV_Door_Top'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door_Top."'#23485#24230'"]')
          ParentFont = False
        end
        object Memo24: TfrxMemoView
          Left = 302.362400000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #25968#37327
          DataSetName = 'ds_prdIV_Door_Top'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door_Top."'#25968#37327'"]')
          ParentFont = False
        end
        object Memo25: TfrxMemoView
          Width = 37.795300000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[LINE]')
          ParentFont = False
        end
        object Memo26: TfrxMemoView
          Left = 377.953000000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = #25324#21495
          DataSetName = 'ds_prdIV_Door_Top'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door_Top."'#25324#21495'"]')
          ParentFont = False
        end
        object Memo27: TfrxMemoView
          Left = 453.543600000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
        end
        object Memo28: TfrxMemoView
          Left = 529.134200000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
        end
        object Memo29: TfrxMemoView
          Left = 642.520100000000000000
          Width = 113.385851180000000000
          Height = 18.897650000000000000
          ShowHint = False
          DataField = 'CabWHD'
          DataSetName = 'ds_prdIV_Door_Top'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[ds_prdIV_Door_Top."CabWHD"]')
          ParentFont = False
        end
        object Memo30: TfrxMemoView
          Left = 774.803650000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          ParentFont = False
        end
      end
      object Header2: TfrxHeader
        Height = 18.897650000000000000
        Top = 328.819110000000000000
        Width = 1046.929810000000000000
        object Memo18: TfrxMemoView
          Width = 755.906000000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #20197#19979#20026#21514#26588#38376#26495)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo19: TfrxMemoView
          Left = 774.803650000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop]
          ParentFont = False
        end
      end
      object Footer2: TfrxFooter
        Height = 18.897650000000000000
        Top = 411.968770000000000000
        Width = 1046.929810000000000000
        object Memo20: TfrxMemoView
          Left = 774.803650000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          ParentFont = False
        end
      end
    end
  end
  object ADOQry1: TADOQuery
    Parameters = <>
    Left = 152
    Top = 136
  end
  object frxDs1: TfrxDBDataset
    UserName = 'ds_prdIV'
    CloseDataSource = False
    DataSet = ADOQry1
    BCDToCurrency = False
    Left = 128
    Top = 136
  end
  object ADOQry2: TADOQuery
    Parameters = <>
    Left = 224
    Top = 136
  end
  object frxDs2: TfrxDBDataset
    UserName = 'ds_prdIV_Top'
    CloseDataSource = False
    DataSet = ADOQry2
    BCDToCurrency = False
    Left = 200
    Top = 136
  end
  object ADOQry3: TADOQuery
    Parameters = <>
    Left = 304
    Top = 136
  end
  object frxDs3: TfrxDBDataset
    UserName = 'ds_prdIV_Other'
    CloseDataSource = False
    DataSet = ADOQry3
    BCDToCurrency = False
    Left = 280
    Top = 136
  end
  object ADOQry4: TADOQuery
    Parameters = <>
    Left = 384
    Top = 136
  end
  object frxDs4: TfrxDBDataset
    UserName = 'ds_prdIV_Drawer'
    CloseDataSource = False
    DataSet = ADOQry4
    BCDToCurrency = False
    Left = 360
    Top = 136
  end
  object ADOQry5: TADOQuery
    Parameters = <>
    Left = 128
    Top = 184
  end
  object ADOQry6: TADOQuery
    Parameters = <>
    Left = 152
    Top = 184
  end
  object ADOQry7: TADOQuery
    Parameters = <>
    Left = 360
    Top = 184
  end
  object frxDs7: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl'
    CloseDataSource = False
    DataSet = ADOQry7
    BCDToCurrency = False
    Left = 336
    Top = 184
  end
  object ADOQry8: TADOQuery
    Parameters = <>
    Left = 440
    Top = 184
  end
  object frxDs8: TfrxDBDataset
    UserName = 'ds_prdIV_DoorAl_Top'
    CloseDataSource = False
    DataSet = ADOQry8
    BCDToCurrency = False
    Left = 416
    Top = 184
  end
  object ADOQry9: TADOQuery
    Parameters = <>
    Left = 152
    Top = 232
  end
  object frxDs9: TfrxDBDataset
    UserName = #26588#20307#25968#37327
    CloseDataSource = False
    DataSet = ADOQry9
    BCDToCurrency = False
    Left = 128
    Top = 232
  end
  object ADOQry10: TADOQuery
    Parameters = <>
    Left = 216
    Top = 232
  end
  object frxDs10: TfrxDBDataset
    UserName = #21478#21152#26495#25277#23625#25968#37327
    CloseDataSource = False
    DataSet = ADOQry10
    BCDToCurrency = False
    Left = 192
    Top = 232
  end
  object ADOQry11: TADOQuery
    Parameters = <>
    Left = 280
    Top = 232
  end
  object frxDs11: TfrxDBDataset
    UserName = #26588#20307#21512#35745#25968#37327
    CloseDataSource = False
    DataSet = ADOQry11
    BCDToCurrency = False
    Left = 256
    Top = 232
  end
  object ADOQry12: TADOQuery
    Parameters = <>
    Left = 344
    Top = 232
  end
  object frxDs12: TfrxDBDataset
    UserName = #32972#26495#25968#37327
    CloseDataSource = False
    DataSet = ADOQry12
    BCDToCurrency = False
    Left = 320
    Top = 232
  end
  object ADOQry13: TADOQuery
    Parameters = <>
    Left = 416
    Top = 232
  end
  object frxDs13: TfrxDBDataset
    UserName = #38376#26495#25968#37327
    CloseDataSource = False
    DataSet = ADOQry13
    BCDToCurrency = False
    Left = 392
    Top = 232
  end
  object frxUDs1: TfrxUserDataSet
    UserName = #26588#20307'_'#19978#26588
    Left = 128
    Top = 376
  end
  object frxUDs2: TfrxUserDataSet
    UserName = #26588#20307'_'#19979#26588
    Left = 160
    Top = 376
  end
  object frxUDs3: TfrxUserDataSet
    UserName = #38468#21152#26495'_'#25277#23625
    Left = 192
    Top = 376
  end
  object frxUDs4: TfrxUserDataSet
    UserName = #26631#20934#20214
    Left = 224
    Top = 376
  end
  object ADOQry14: TADOQuery
    Parameters = <>
    Left = 128
    Top = 328
  end
  object ADOQry15: TADOQuery
    Parameters = <>
    Left = 224
    Top = 328
  end
  object frxDs14: TfrxDBDataset
    UserName = #20116#37329
    CloseDataSource = False
    DataSet = ADOQry15
    BCDToCurrency = False
    Left = 200
    Top = 328
  end
  object ADOQry16: TADOQuery
    Parameters = <>
    Left = 152
    Top = 280
  end
  object frxDs15: TfrxDBDataset
    UserName = #26631#20934#26588#20307#25968#37327
    CloseDataSource = False
    DataSet = ADOQry16
    BCDToCurrency = False
    Left = 128
    Top = 280
  end
  object ADOQry17: TADOQuery
    Parameters = <>
    Left = 224
    Top = 280
  end
  object frxDs16: TfrxDBDataset
    UserName = #26631#20934#32972#26495#25968#37327
    CloseDataSource = False
    DataSet = ADOQry17
    BCDToCurrency = False
    Left = 200
    Top = 280
  end
  object frxUDs5: TfrxUserDataSet
    UserName = #38376#26495'_'#19979#26588
    Left = 224
    Top = 184
  end
  object frxUDs6: TfrxUserDataSet
    UserName = #38376#26495'_'#19978#26588
    Left = 248
    Top = 184
  end
  object ADOQry18: TADOQuery
    Parameters = <>
    Left = 176
    Top = 184
  end
  object frxUDs7: TfrxUserDataSet
    UserName = #36741#26495
    Left = 272
    Top = 184
  end
  object frxUDs8: TfrxUserDataSet
    UserName = ' '#38376#26495#38468#21152
    Left = 296
    Top = 184
  end
end
