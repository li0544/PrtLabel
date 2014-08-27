object F_List_Import: TF_List_Import
  Left = 0
  Top = 0
  Caption = #23548#20837#35746#21333
  ClientHeight = 355
  ClientWidth = 790
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
  object Splitter1: TSplitter
    Left = 233
    Top = 49
    Width = 5
    Height = 306
  end
  object panel1: TRzPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 49
    Align = alTop
    BorderOuter = fsGroove
    TabOrder = 0
    object Label2: TLabel
      Left = 40
      Top = 16
      Width = 48
      Height = 13
      Caption = #36215#22987#26102#38388
    end
    object Label3: TLabel
      Left = 248
      Top = 16
      Width = 48
      Height = 13
      Caption = #32467#26463#26102#38388
    end
    object datePicStart: TDateTimePicker
      Left = 96
      Top = 12
      Width = 113
      Height = 20
      Date = 40544.923517245370000000
      Format = 'yyyy-MM-dd'
      Time = 40544.923517245370000000
      TabOrder = 0
    end
    object datePicEnd: TDateTimePicker
      Left = 304
      Top = 12
      Width = 113
      Height = 20
      Date = 40647.923517245370000000
      Format = 'yyyy-MM-dd'
      Time = 40647.923517245370000000
      TabOrder = 1
    end
    object btnQuery: TButton
      Left = 448
      Top = 9
      Width = 80
      Height = 30
      Caption = #26597#35810
      TabOrder = 2
      OnClick = btnQueryClick
    end
    object btnImport: TButton
      Left = 544
      Top = 9
      Width = 80
      Height = 30
      Caption = #23548#20837#25968#25454
      TabOrder = 3
      OnClick = btnImportClick
    end
    object btnOpt: TButton
      Left = 640
      Top = 9
      Width = 80
      Height = 30
      Caption = #35774#32622
      TabOrder = 4
      OnClick = btnOptClick
    end
  end
  object chklst1: TCheckListBox
    Left = 0
    Top = 49
    Width = 233
    Height = 306
    Align = alLeft
    ItemHeight = 13
    TabOrder = 1
  end
  object grid1: TDBGridEh
    Left = 352
    Top = 120
    Width = 313
    Height = 153
    DataGrouping.GroupLevels = <>
    DataSource = ds1
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    RowDetailPanel.Color = clBtnFace
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleHeight = 20
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object AQry_List: TADOQuery
    Parameters = <>
    Left = 328
    Top = 64
  end
  object ds1: TDataSource
    DataSet = AQry_List
    Left = 368
    Top = 64
  end
end
