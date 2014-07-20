object F_Price: TF_Price
  Left = 159
  Top = 127
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #35774#32622#26448#26009#20215#26684
  ClientHeight = 490
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object RzPanel1: TRzPanel
    Left = 8
    Top = 120
    Width = 657
    Height = 313
    BorderOuter = fsGroove
    TabOrder = 1
    DesignSize = (
      657
      313)
    object grp2: TGroupBox
      Left = 16
      Top = 8
      Width = 625
      Height = 233
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = #26495#26448#20215#26684
      TabOrder = 0
      DesignSize = (
        625
        233)
      object DBGridEh1: TDBGridEh
        Left = 16
        Top = 16
        Width = 593
        Height = 177
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataGrouping.GroupLevels = <>
        DataSource = ds1
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -12
        FooterFont.Name = #23435#20307
        FooterFont.Style = []
        ParentFont = False
        PopupMenu = pm1
        RowDetailPanel.Color = clBtnFace
        RowHeight = 22
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #23435#20307
        TitleFont.Style = []
        TitleHeight = 20
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 689
    Height = 57
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 697
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
    object BtnBodPrice: TButton
      Tag = 1
      Left = 72
      Top = 13
      Width = 90
      Height = 30
      Caption = #26495#26448#20215#26684
      TabOrder = 0
      OnClick = BtnPriceClick
    end
    object BtnHDPrice: TButton
      Tag = 2
      Left = 176
      Top = 13
      Width = 90
      Height = 30
      Caption = #20116#37329#20215#26684
      TabOrder = 1
      OnClick = BtnPriceClick
    end
    object BtnLSPrice: TButton
      Tag = 4
      Left = 384
      Top = 13
      Width = 90
      Height = 30
      Caption = #25289#25163
      TabOrder = 2
      OnClick = BtnPriceClick
    end
    object RzButton1: TRzButton
      Tag = 9
      Left = 560
      Top = 14
      Width = 90
      Height = 30
      FrameColor = 7617536
      ModalResult = 1
      Caption = #36820#22238
      TabOrder = 3
      OnClick = BtnPriceClick
    end
    object Button1: TButton
      Tag = 3
      Left = 280
      Top = 13
      Width = 90
      Height = 30
      Caption = #29305#27530#21152#20215
      TabOrder = 4
      OnClick = BtnPriceClick
    end
  end
  object RzPanel2: TRzPanel
    Left = 0
    Top = 57
    Width = 689
    Height = 48
    Align = alTop
    BorderOuter = fsBump
    TabOrder = 2
    ExplicitWidth = 697
    object btnAdd: TButton
      Tag = 10
      Left = 76
      Top = 8
      Width = 90
      Height = 30
      Caption = #28155#21152
      TabOrder = 0
      OnClick = BtnPriceClick
    end
    object btnRef: TButton
      Tag = 11
      Left = 180
      Top = 8
      Width = 90
      Height = 30
      Caption = #21047#26032
      TabOrder = 1
      OnClick = BtnPriceClick
    end
    object btnDel: TButton
      Tag = 12
      Left = 284
      Top = 8
      Width = 90
      Height = 30
      Caption = #21024#38500
      TabOrder = 2
      OnClick = BtnPriceClick
    end
    object btnSave: TButton
      Tag = 13
      Left = 388
      Top = 8
      Width = 90
      Height = 30
      Caption = #20445#23384
      TabOrder = 3
      OnClick = BtnPriceClick
    end
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 468
    Width = 689
    Height = 22
    AutoStyle = False
    BorderInner = fsFlat
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 3
    ExplicitTop = 479
    ExplicitWidth = 697
  end
  object ds1: TDataSource
    DataSet = AQry1
    Left = 224
    Top = 328
  end
  object AQry1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tprice')
    Left = 192
    Top = 328
  end
  object pm1: TPopupMenu
    Left = 260
    Top = 327
    object MItemAdd: TMenuItem
      Tag = 10
      Caption = #28155#21152
      OnClick = BtnPriceClick
    end
    object MItemRefresh: TMenuItem
      Tag = 20
      Caption = #21047#26032
      OnClick = BtnPriceClick
    end
    object MItemDelete: TMenuItem
      Tag = 30
      Caption = #21024#38500
      OnClick = BtnPriceClick
    end
  end
end
