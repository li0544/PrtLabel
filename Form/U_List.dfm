object F_List: TF_List
  Left = 161
  Top = 166
  Caption = #35746#21333
  ClientHeight = 487
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object RzPanel2: TRzPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 49
    Align = alTop
    BorderOuter = fsGroove
    TabOrder = 2
    object LblHide: TLabel
      Left = 8
      Top = 8
      Width = 18
      Height = 16
      Caption = '<<'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = LblHideClick
    end
    object Label1: TLabel
      Left = 48
      Top = 16
      Width = 48
      Height = 12
      Caption = #35746#21333#32534#21495
    end
    object Label2: TLabel
      Left = 232
      Top = 16
      Width = 48
      Height = 12
      Caption = #36215#22987#26102#38388
    end
    object Label3: TLabel
      Left = 440
      Top = 16
      Width = 48
      Height = 12
      Caption = #32467#26463#26102#38388
    end
    object EdtListID: TEdit
      Left = 104
      Top = 12
      Width = 89
      Height = 20
      TabOrder = 0
    end
    object DateTimePickerStart: TDateTimePicker
      Left = 288
      Top = 12
      Width = 113
      Height = 20
      Date = 40544.923517245370000000
      Format = 'yyyy-MM-dd'
      Time = 40544.923517245370000000
      TabOrder = 1
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 496
      Top = 12
      Width = 113
      Height = 20
      Date = 40647.923517245370000000
      Format = 'yyyy-MM-dd'
      Time = 40647.923517245370000000
      TabOrder = 2
    end
    object BtnQuery: TButton
      Left = 656
      Top = 9
      Width = 80
      Height = 30
      Caption = #26597#35810
      TabOrder = 3
      OnClick = ToolBtnClick
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 467
    Width = 864
    Height = 20
    Panels = <>
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 49
    Width = 864
    Height = 48
    Align = alTop
    BorderOuter = fsGroove
    TabOrder = 0
    object BtnPrintLabel: TButton
      Tag = 101
      Left = 18
      Top = 6
      Width = 80
      Height = 30
      Caption = #25171#21360#26631#31614
      TabOrder = 0
      Visible = False
      OnClick = ToolBtnClick
    end
    object btnMake: TButton
      Tag = 102
      Left = 160
      Top = 6
      Width = 80
      Height = 30
      Caption = #29983#20135#21046#20316#21333
      TabOrder = 1
      Visible = False
      OnClick = ToolBtnClick
    end
    object btnProject: TButton
      Tag = 103
      Left = 222
      Top = 6
      Width = 80
      Height = 30
      Caption = #24320#26009#35745#21010#34920
      TabOrder = 2
      Visible = False
      OnClick = ToolBtnClick
    end
    object btnPrice: TButton
      Tag = 104
      Left = 288
      Top = 6
      Width = 80
      Height = 30
      Caption = #25253#20215#21333
      TabOrder = 3
      Visible = False
      OnClick = ToolBtnClick
    end
    object Button5: TButton
      Tag = 105
      Left = 460
      Top = 6
      Width = 80
      Height = 30
      Caption = #23548#20986'EXCEL'
      TabOrder = 4
      OnClick = ToolBtnClick
    end
    object Button1: TButton
      Tag = 106
      Left = 546
      Top = 6
      Width = 80
      Height = 30
      Caption = #23548#20986'TXT'
      TabOrder = 5
      OnClick = ToolBtnClick
    end
    object Button6: TButton
      Tag = 7
      Left = 656
      Top = 6
      Width = 80
      Height = 30
      Caption = #36820#22238
      TabOrder = 6
      OnClick = ToolBtnClick
    end
    object btnBox: TButton
      Tag = 107
      Left = 86
      Top = 6
      Width = 80
      Height = 30
      Caption = #22806#21253#35013#26631#31614
      TabOrder = 7
      Visible = False
      OnClick = ToolBtnClick
    end
    object btnBod: TButton
      Tag = 108
      Left = 374
      Top = 6
      Width = 80
      Height = 30
      Caption = #25286#20998#35746#21333
      TabOrder = 8
      OnClick = ToolBtnClick
    end
  end
  object DBGridEh1: TDBGridEh
    Left = 211
    Top = 128
    Width = 473
    Height = 257
    DataGrouping.GroupLevels = <>
    DataSource = ds2
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = ANSI_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -12
    FooterFont.Name = #23435#20307
    FooterFont.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
    ParentFont = False
    PopupMenu = PopupMenu1
    RowDetailPanel.Color = clBtnFace
    RowHeight = 20
    TabOrder = 3
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    TitleHeight = 20
    OnDblClick = DBGridEh1DblClick
    Columns = <
      item
        EditButtons = <>
        FieldName = #35746#21333#32534#21495
        Footers = <>
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = #22788#29702#26102#38388
        Footers = <>
        Title.TitleButton = True
        Width = 152
      end
      item
        EditButtons = <>
        FieldName = #23548#20837#26102#38388
        Footers = <>
        Title.TitleButton = True
        Width = 164
      end
      item
        EditButtons = <>
        FieldName = #23433#35013#22320#22336
        Footers = <>
        Title.TitleButton = True
        Width = 188
      end
      item
        EditButtons = <>
        FieldName = #38376#26495#26448#36136
        Footers = <>
        Title.TitleButton = True
        Width = 159
      end
      item
        EditButtons = <>
        FieldName = #32972#26495#26448#36136
        Footers = <>
        Title.TitleButton = True
        Width = 164
      end
      item
        EditButtons = <>
        FieldName = #26588#20307#26495#26448#36136
        Footers = <>
        Title.TitleButton = True
        Width = 147
      end
      item
        EditButtons = <>
        FieldName = #23458#25143#22995#21517
        Footers = <>
        Title.TitleButton = True
        Width = 98
      end
      item
        EditButtons = <>
        FieldName = #32852#31995#26041#24335
        Footers = <>
        Title.TitleButton = True
        Width = 99
      end
      item
        EditButtons = <>
        FieldName = #38376#26495#38754#31215
        Footers = <>
        Title.TitleButton = True
        Width = 87
      end
      item
        EditButtons = <>
        FieldName = #32972#26495#38754#31215
        Footers = <>
        Title.TitleButton = True
        Width = 93
      end
      item
        EditButtons = <>
        FieldName = #26588#20307#26495#38754#31215
        Footers = <>
        Title.TitleButton = True
        Width = 104
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object AQry1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT ListID AS '#35746#21333#32534#21495', '#20132#36135#26085#26399' AS '#22788#29702#26102#38388','#23548#20837#26102#38388', '#23433#35013#22320#22336', '#38376#26495#26448#36136', '
      '    '#32972#26495#26448#36136', '#26588#20307#26495#26448#36136', '#23458#25143#22995#21517', '#32852#31995#26041#24335', '#29983#20135#21046#20316#21333' AS '#29983#20135#21046#20316#21333#26631#39064', '
      '    '#24320#26009#35745#21010#34920' AS '#24320#26009#35745#21010#34920#26631#39064', '#25253#20215#21333' AS '#25253#20215#21333#26631#39064' '
      '    FROM List')
    Left = 16
    Top = 112
  end
  object Ds1: TDataSource
    DataSet = AQry1
    Left = 16
    Top = 144
  end
  object tbl1: TADOTable
    Left = 16
    Top = 184
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 216
    object MItemLoadXls: TMenuItem
      Tag = 10
      Caption = #23548#20837'Excel'#25991#20214
      OnClick = MItemClick
    end
    object MItemOpt: TMenuItem
      Tag = 11
      Caption = #35774#32622#25253#34920#21442#25968
      OnClick = MItemClick
    end
    object MItemPric: TMenuItem
      Tag = 12
      Caption = #35774#32622#20215#26684
      OnClick = MItemClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object MItemRefresh: TMenuItem
      Tag = 998
      Caption = #21047#26032
      OnClick = MItemClick
    end
    object MItemQryDay: TMenuItem
      Tag = 996
      Caption = #26174#31034#24403#22825#35746#21333
      OnClick = MItemClick
    end
    object MItemQryMonth: TMenuItem
      Tag = 997
      Caption = #26174#31034#24403#26376#35746#21333
      OnClick = MItemClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object MItemUpdate: TMenuItem
      Tag = 100
      Caption = #20462#25913#35746#21333#21495
      OnClick = MItemClick
    end
    object MItemListOpt: TMenuItem
      Tag = 101
      Caption = #35746#21333#35774#32622
      OnClick = MItemClick
    end
    object MItemDelete: TMenuItem
      Tag = 102
      Caption = #21024#38500
      OnClick = MItemClick
    end
    object N1: TMenuItem
      Tag = 110
      Caption = #38468#20214#36153#29992
      OnClick = MItemClick
    end
  end
  object AQry2: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    AfterOpen = AQry2AfterOpen
    AfterScroll = AQry2AfterScroll
    Parameters = <>
    SQL.Strings = (
      'SELECT ListID AS '#35746#21333#32534#21495', '#20132#36135#26085#26399' AS '#22788#29702#26102#38388','#23548#20837#26102#38388', '#23433#35013#22320#22336', '#38376#26495#26448#36136', '
      '    '#32972#26495#26448#36136', '#26588#20307#26495#26448#36136', '#23458#25143#22995#21517', '#32852#31995#26041#24335', '#29983#20135#21046#20316#21333' AS '#29983#20135#21046#20316#21333#26631#39064', '
      '    '#24320#26009#35745#21010#34920' AS '#24320#26009#35745#21010#34920#26631#39064', '#25253#20215#21333' AS '#25253#20215#21333#26631#39064' ,'#38376#26495#38754#31215','#32972#26495#38754#31215','#26588#20307#26495#38754#31215
      '    FROM List')
    Left = 168
    Top = 104
  end
  object ds2: TDataSource
    DataSet = AQry2
    Left = 168
    Top = 136
  end
  object ATab2: TADOTable
    Left = 56
    Top = 184
  end
end
