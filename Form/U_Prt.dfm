object F_Prt: TF_Prt
  Left = 0
  Top = 89
  Caption = #25171#21360#26631#31614
  ClientHeight = 507
  ClientWidth = 712
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 326
    Top = 0
    Width = 5
    Height = 507
  end
  object Panel1: TPanel
    Left = 352
    Top = 292
    Width = 233
    Height = 89
    TabOrder = 0
  end
  object Panel3: TRzSizePanel
    Left = 0
    Top = 0
    Width = 163
    Height = 507
    BorderOuter = fsGroove
    HotSpotVisible = True
    SizeBarWidth = 7
    TabOrder = 1
    object BtnLoadBoard: TButton
      Left = 16
      Top = 112
      Width = 120
      Height = 30
      Caption = #23548#20837'Excel'#25991#20214
      TabOrder = 0
      OnClick = BtnLoadBoardClick
    end
    object BtnOption: TButton
      Left = 16
      Top = 152
      Width = 120
      Height = 30
      Caption = #25253#34920#31995#32479#21442#25968
      TabOrder = 1
      OnClick = BtnOptionClick
    end
    object BtnSetPrice: TButton
      Left = 16
      Top = 192
      Width = 120
      Height = 30
      Caption = #35774#32622#20215#26684
      TabOrder = 2
      OnClick = BtnSetPriceClick
    end
    object BtnQuery: TButton
      Left = 16
      Top = 232
      Width = 120
      Height = 30
      Caption = #26597#35810
      TabOrder = 3
      OnClick = BtnQueryClick
    end
    object BtnQryDay: TButton
      Left = 16
      Top = 272
      Width = 120
      Height = 30
      Caption = #26174#31034#24403#22825#35746#21333
      TabOrder = 4
      OnClick = BtnQryDayClick
    end
    object BtnQryMonth: TButton
      Left = 16
      Top = 312
      Width = 120
      Height = 30
      Caption = #26174#31034#24403#26376#35746#21333
      TabOrder = 5
      OnClick = BtnQryMonthClick
    end
    object btnPrtEdit: TButton
      Left = 16
      Top = 351
      Width = 120
      Height = 30
      Caption = #32534#36753#25253#34920
      TabOrder = 6
      OnClick = btnPrtEditClick
    end
  end
  object Panel2: TRzGroupBar
    Left = 163
    Top = 0
    Width = 163
    Height = 507
    GradientColorStart = clBtnFace
    GradientColorStop = clBtnShadow
    GroupBorderSize = 8
    Color = clBtnShadow
    ParentColor = False
    TabOrder = 2
    object RzGroup1: TRzGroup
      Items = <
        item
          Caption = #23548#20837'Excel'#25991#20214
          OnClick = BtnLoadBoardClick
        end
        item
          Caption = #23548#20837#25968#25454
          Tag = 101
          OnClick = BtnClick
        end>
      Opened = True
      OpenedHeight = 68
      DividerVisible = False
      Caption = #23548#20837#25968#25454
      ParentColor = False
    end
    object RzGroup2: TRzGroup
      Items = <
        item
          Caption = #25253#34920#21450#31995#32479#21442#25968
          OnClick = BtnOptionClick
        end
        item
          Caption = #20215#26684#35774#32622
          OnClick = BtnSetPriceClick
        end
        item
          Caption = #26631#20934#20214#35774#32622
          Tag = 203
          OnClick = BtnClick
        end
        item
          Caption = #29983#20135#25253#34920#35774#32622
          Tag = 204
          OnClick = BtnClick
        end>
      Opened = True
      OpenedHeight = 108
      DividerVisible = False
      Caption = #31995#32479#35774#32622
      ParentColor = False
    end
    object RzGroup3: TRzGroup
      Items = <
        item
          Caption = #26597#35810
          OnClick = BtnQueryClick
        end
        item
          Caption = #26174#31034#24403#22825#35746#21333
          OnClick = BtnQryDayClick
        end
        item
          Caption = #26174#31034#24403#26376#35746#21333
          OnClick = BtnQryMonthClick
        end>
      Opened = True
      OpenedHeight = 88
      DividerVisible = False
      Caption = #35746#21333
      ParentColor = False
    end
    object RzGroup4: TRzGroup
      Items = <
        item
          Caption = #25171#21360#26631#31614
          Tag = 401
          OnClick = BtnClick
        end
        item
          Caption = #22806#21253#35013#26631#31614
          Tag = 402
          OnClick = BtnClick
        end
        item
          Caption = #29983#20135#21046#20316#21333
          Tag = 403
          OnClick = BtnClick
        end
        item
          Caption = #24320#26009#35745#21010#34920
          Tag = 404
          OnClick = BtnClick
        end
        item
          Caption = #25253#20215#21333
          Tag = 405
          OnClick = BtnClick
        end
        item
          Caption = #32534#36753#25253#34920
          Tag = 406
          OnClick = BtnClick
        end>
      Opened = True
      OpenedHeight = 148
      DividerVisible = False
      Caption = #25253#34920
      ParentColor = False
    end
  end
  object ExcelApp1: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = True
    Left = 646
    Top = 16
  end
  object ExcelWorkbook1: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 502
    Top = 64
  end
  object OpenDialog1: TOpenDialog
    Left = 598
    Top = 64
  end
  object dlgSave1: TSaveDialog
    Left = 646
    Top = 64
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
    Left = 598
    Top = 16
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
    Left = 550
    Top = 16
  end
  object qry3: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=sa;Persist Security Info=True;User ' +
      'ID=sa;Initial Catalog=DB_LAB;Data Source=JACKSPC'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#26448#26009)
    Left = 502
    Top = 16
  end
  object ADOQry_List: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select top 1 * from list')
    Left = 344
    Top = 72
    object ADOQry_ListListID: TWideStringField
      FieldName = 'ListID'
    end
    object ADOQry_List交货日期: TWideStringField
      FieldName = #20132#36135#26085#26399
      Size = 50
    end
    object ADOQry_List安装地址: TWideStringField
      FieldName = #23433#35013#22320#22336
      Size = 50
    end
    object ADOQry_List门板材质: TWideStringField
      FieldName = #38376#26495#26448#36136
      Size = 50
    end
    object ADOQry_List背板材质: TWideStringField
      FieldName = #32972#26495#26448#36136
      Size = 50
    end
    object ADOQry_List柜体板材质: TWideStringField
      FieldName = #26588#20307#26495#26448#36136
      Size = 50
    end
    object ADOQry_List客户姓名: TWideStringField
      FieldName = #23458#25143#22995#21517
      Size = 50
    end
    object ADOQry_List联系方式: TWideStringField
      FieldName = #32852#31995#26041#24335
      Size = 50
    end
    object ADOQry_List字体大小: TSmallintField
      FieldName = #23383#20307#22823#23567
    end
    object ADOQry_List生产制作单: TWideStringField
      FieldName = #29983#20135#21046#20316#21333
      Size = 50
    end
    object ADOQry_List开料计划表: TWideStringField
      FieldName = #24320#26009#35745#21010#34920
      Size = 50
    end
    object ADOQry_List报价单: TWideStringField
      FieldName = #25253#20215#21333
      Size = 50
    end
    object ADOQry_List板材厚度: TFloatField
      FieldName = #26495#26448#21402#24230
    end
    object ADOQry_List封边工艺: TWideStringField
      FieldName = #23553#36793#24037#33402
      Size = 50
    end
    object ADOQry_List隔板: TWideStringField
      FieldName = #38548#26495
      Size = 50
    end
    object ADOQry_List柜体板单价: TWideStringField
      FieldName = #26588#20307#26495#21333#20215
      Size = 50
    end
    object ADOQry_List门板单价: TWideStringField
      FieldName = #38376#26495#21333#20215
      Size = 50
    end
    object ADOQry_List背板单价: TWideStringField
      FieldName = #32972#26495#21333#20215
      Size = 50
    end
    object ADOQry_List柜体板面积: TFloatField
      FieldName = #26588#20307#26495#38754#31215
    end
    object ADOQry_List门板面积: TFloatField
      FieldName = #38376#26495#38754#31215
    end
    object ADOQry_List背板面积: TFloatField
      FieldName = #32972#26495#38754#31215
    end
    object ADOQry_List柜体板价格: TFloatField
      FieldName = #26588#20307#26495#20215#26684
    end
    object ADOQry_List门板价格: TFloatField
      FieldName = #38376#26495#20215#26684
    end
    object ADOQry_List背板价格: TFloatField
      FieldName = #32972#26495#20215#26684
    end
    object ADOQry_List柜体价格: TFloatField
      FieldName = #26588#20307#20215#26684
    end
    object ADOQry_List柜体合计金额: TWideStringField
      FieldName = #26588#20307#21512#35745#37329#39069
      Size = 50
    end
    object ADOQry_List五金价格: TFloatField
      FieldName = #20116#37329#20215#26684
    end
    object ADOQry_List特殊加价: TFloatField
      FieldName = #29305#27530#21152#20215
    end
    object ADOQry_List合计金额: TFloatField
      FieldName = #21512#35745#37329#39069
    end
    object ADOQry_List导入时间: TDateTimeField
      FieldName = #23548#20837#26102#38388
    end
  end
  object frxDs_List: TfrxDBDataset
    UserName = 'List'
    CloseDataSource = False
    DataSet = ADOQry_List
    BCDToCurrency = False
    Left = 344
    Top = 120
  end
end
