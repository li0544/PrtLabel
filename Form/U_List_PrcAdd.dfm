object F_List_PrcAdd: TF_List_PrcAdd
  Left = 0
  Top = 0
  Caption = #38468#21152#37329#39069
  ClientHeight = 402
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object panel1: TRzPanel
    Left = 8
    Top = 54
    Width = 694
    Height = 313
    BorderOuter = fsGroove
    TabOrder = 0
    DesignSize = (
      694
      313)
    object grp2: TGroupBox
      Left = 16
      Top = 8
      Width = 662
      Height = 233
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = #20854#20182#36153#29992
      TabOrder = 0
      DesignSize = (
        662
        233)
      object dbGrid1: TDBGridEh
        Left = 16
        Top = 16
        Width = 630
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
        ImeMode = imDisable
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
        Columns = <
          item
            EditButtons = <>
            FieldName = #35746#21333#32534#21495
            Footers = <>
            Visible = False
            Width = 200
          end
          item
            EditButtons = <>
            FieldName = #25910#36153#39033#30446
            Footers = <>
            Width = 200
          end
          item
            EditButtons = <>
            FieldName = #37329#39069
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object panel2: TRzPanel
    Left = 0
    Top = 0
    Width = 710
    Height = 48
    Align = alTop
    BorderOuter = fsBump
    TabOrder = 1
    object btnAdd: TButton
      Tag = 10
      Left = 76
      Top = 8
      Width = 90
      Height = 30
      Caption = #28155#21152
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnRef: TButton
      Tag = 11
      Left = 180
      Top = 8
      Width = 90
      Height = 30
      Caption = #21047#26032
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDel: TButton
      Tag = 12
      Left = 284
      Top = 8
      Width = 90
      Height = 30
      Caption = #21024#38500
      TabOrder = 2
      OnClick = btnAddClick
    end
    object btnSave: TButton
      Tag = 13
      Left = 388
      Top = 8
      Width = 90
      Height = 30
      Caption = #20445#23384
      TabOrder = 3
      OnClick = btnAddClick
    end
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
    AfterInsert = AQry1AfterInsert
    Parameters = <>
    SQL.Strings = (
      'select * from TPrcAdd')
    Left = 192
    Top = 328
  end
  object pm1: TPopupMenu
    Left = 260
    Top = 327
    object MItemAdd: TMenuItem
      Tag = 10
      Caption = #28155#21152
    end
    object MItemRefresh: TMenuItem
      Tag = 20
      Caption = #21047#26032
    end
    object MItemDelete: TMenuItem
      Tag = 30
      Caption = #21024#38500
    end
  end
end
