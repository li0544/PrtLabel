object F_Prt_Opt: TF_Prt_Opt
  Left = 136
  Top = 110
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21442#25968#35774#32622
  ClientHeight = 577
  ClientWidth = 816
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 12
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
  object Panel1: TPanel
    Left = 48
    Top = 16
    Width = 713
    Height = 521
    BevelInner = bvLowered
    TabOrder = 0
    object grp1: TGroupBox
      Left = 32
      Top = 17
      Width = 649
      Height = 257
      Caption = #25171#21360#35774#32622
      TabOrder = 0
      object lbl1: TLabel
        Left = 32
        Top = 28
        Width = 60
        Height = 12
        Caption = #29983#20135#21333#26631#39064
      end
      object lbl2: TLabel
        Left = 32
        Top = 92
        Width = 60
        Height = 12
        Caption = #25253#20215#21333#26631#39064
      end
      object lbl4: TLabel
        Left = 280
        Top = 60
        Width = 48
        Height = 12
        Caption = #27491#25991#23383#21495
      end
      object LblLineWidth: TLabel
        Left = 456
        Top = 28
        Width = 60
        Height = 12
        Caption = #34920#26684#36793#26694#23485
      end
      object lbl17: TLabel
        Left = 32
        Top = 60
        Width = 60
        Height = 12
        Caption = #24320#26009#34920#26631#39064
      end
      object lbl15: TLabel
        Left = 280
        Top = 28
        Width = 48
        Height = 12
        Caption = #26631#39064#23383#21495
      end
      object Label1: TLabel
        Left = 280
        Top = 92
        Width = 48
        Height = 12
        Caption = #26495#26448#21402#24230
      end
      object Label2: TLabel
        Left = 456
        Top = 60
        Width = 48
        Height = 12
        Caption = #34920#26684#34892#39640
      end
      object Label3: TLabel
        Left = 456
        Top = 92
        Width = 60
        Height = 12
        Caption = #25991#23383#19979#36793#36317
      end
      object Label4: TLabel
        Left = 280
        Top = 124
        Width = 60
        Height = 12
        Caption = #35746#21333#24180#20221#21152
      end
      object Label5: TLabel
        Left = 456
        Top = 124
        Width = 60
        Height = 12
        Caption = #23567#26631#39064#23383#21495
      end
      object lbl3: TLabel
        Left = 280
        Top = 156
        Width = 60
        Height = 12
        Caption = #38376#26495#23553#36793#21402
      end
      object lbl11: TLabel
        Left = 456
        Top = 156
        Width = 60
        Height = 12
        Caption = #26588#20307#23553#36793#21402
      end
      object lab1: TLabel
        Left = 32
        Top = 124
        Width = 54
        Height = 12
        Caption = #38134#34892#21345#21495'1'
      end
      object lab2: TLabel
        Left = 32
        Top = 156
        Width = 54
        Height = 12
        Caption = #38134#34892#21345#21495'2'
      end
      object lab3: TLabel
        Left = 32
        Top = 188
        Width = 54
        Height = 12
        Caption = #38134#34892#21345#21495'3'
      end
      object EdtPrd: TEdit
        Left = 104
        Top = 24
        Width = 153
        Height = 20
        TabOrder = 0
      end
      object BtnSave1: TButton
        Left = 456
        Top = 216
        Width = 70
        Height = 22
        Caption = #20445#23384
        TabOrder = 1
        OnClick = BtnSave1Click
      end
      object EdtPrc: TEdit
        Tag = 2
        Left = 104
        Top = 88
        Width = 153
        Height = 20
        TabOrder = 2
      end
      object EdtFZBody: TEdit
        Tag = 4
        Left = 344
        Top = 56
        Width = 81
        Height = 20
        TabOrder = 3
      end
      object EdtTabW: TEdit
        Tag = 6
        Left = 528
        Top = 24
        Width = 81
        Height = 20
        TabOrder = 4
      end
      object EdtPro: TEdit
        Tag = 1
        Left = 104
        Top = 56
        Width = 153
        Height = 20
        TabOrder = 5
      end
      object EdtFZTitl: TEdit
        Tag = 3
        Left = 344
        Top = 24
        Width = 81
        Height = 20
        TabOrder = 6
      end
      object EdtBodD: TEdit
        Tag = 5
        Left = 344
        Top = 88
        Width = 81
        Height = 20
        TabOrder = 7
      end
      object BtnDefault1: TButton
        Left = 376
        Top = 216
        Width = 70
        Height = 22
        Caption = #24674#22797#40664#35748
        TabOrder = 8
        OnClick = BtnDefault1Click
      end
      object BtnClose1: TButton
        Left = 536
        Top = 216
        Width = 70
        Height = 22
        Caption = #36820#22238
        TabOrder = 9
        OnClick = BtnClose1Click
      end
      object EdtTabLineH: TEdit
        Tag = 7
        Left = 528
        Top = 56
        Width = 81
        Height = 20
        TabOrder = 10
      end
      object EdtfLBottom: TEdit
        Tag = 8
        Left = 528
        Top = 88
        Width = 81
        Height = 20
        TabOrder = 11
      end
      object CBoxFName: TCheckBox
        Left = 280
        Top = 186
        Width = 145
        Height = 16
        Caption = #25991#20214#21517#20316#20026#35746#21333#21495
        TabOrder = 12
      end
      object EdtAddYear: TEdit
        Tag = 5
        Left = 344
        Top = 120
        Width = 81
        Height = 20
        TabOrder = 13
      end
      object EdtMinTit: TEdit
        Tag = 4
        Left = 528
        Top = 120
        Width = 81
        Height = 20
        TabOrder = 14
      end
      object EdtfbDoor: TEdit
        Left = 344
        Top = 152
        Width = 81
        Height = 20
        Hint = #21333#20301'('#27627#31859')'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
      end
      object EdtfbBody: TEdit
        Left = 528
        Top = 152
        Width = 81
        Height = 20
        Hint = #21333#20301'('#27627#31859')'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
      end
      object tboxBankID1: TEdit
        Left = 104
        Top = 120
        Width = 153
        Height = 20
        TabOrder = 17
      end
      object tboxBankID2: TEdit
        Tag = 1
        Left = 104
        Top = 152
        Width = 153
        Height = 20
        TabOrder = 18
      end
      object tboxBankID3: TEdit
        Tag = 2
        Left = 104
        Top = 184
        Width = 153
        Height = 20
        TabOrder = 19
      end
    end
    object grp2: TGroupBox
      Left = 32
      Top = 280
      Width = 649
      Height = 217
      Caption = #20215#26684#35745#31639
      TabOrder = 1
      object lbl5: TLabel
        Left = 32
        Top = 36
        Width = 60
        Height = 12
        Caption = #24322#22411#26588#21152#20215
        Enabled = False
      end
      object lbl6: TLabel
        Left = 32
        Top = 68
        Width = 60
        Height = 12
        Caption = #38109#21512#37329#25289#26465
        Enabled = False
      end
      object lbl7: TLabel
        Left = 416
        Top = 36
        Width = 90
        Height = 12
        Caption = '<=900'#27700#27133#26588#21152#20215
        Enabled = False
      end
      object lbl8: TLabel
        Left = 416
        Top = 68
        Width = 90
        Height = 12
        Caption = '> 900'#27700#27133#26588#21152#20215
        Enabled = False
      end
      object lbl9: TLabel
        Left = 32
        Top = 100
        Width = 48
        Height = 12
        Caption = #25289#25163#31181#31867
      end
      object lbl10: TLabel
        Left = 176
        Top = 100
        Width = 18
        Height = 12
        Hint = #21333#20301'('#20803')'
        Caption = '---'
        ParentShowHint = False
        ShowHint = True
      end
      object lbl12: TLabel
        Left = 32
        Top = 192
        Width = 84
        Height = 12
        Caption = '['#28165#38500#27880#20876#20449#24687']'
        OnClick = lbl12Click
        OnMouseMove = lbl12MouseMove
        OnMouseLeave = lbl12MouseLeave
      end
      object chk1: TCheckBox
        Left = 296
        Top = 98
        Width = 65
        Height = 17
        Caption = #26465#24418#25289#25163
        TabOrder = 0
        OnClick = chk1Click
      end
      object cbb1: TComboBox
        Left = 96
        Top = 96
        Width = 73
        Height = 20
        TabOrder = 1
        OnChange = cbb1Change
      end
      object BtnLaShou: TButton
        Left = 312
        Top = 144
        Width = 152
        Height = 22
        Caption = #25289#25163#31181#31867#21450#20215#26684#35774#32622
        TabOrder = 2
        OnClick = BtnLaShouClick
      end
      object edt5: TEdit
        Left = 96
        Top = 32
        Width = 57
        Height = 20
        Hint = #21333#20301'('#20803')'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object btn4: TButton
        Left = 160
        Top = 31
        Width = 49
        Height = 22
        Caption = #20445#23384
        Enabled = False
        TabOrder = 4
        OnClick = btn4Click
      end
      object edt6: TEdit
        Left = 96
        Top = 64
        Width = 57
        Height = 20
        Hint = #21333#20301'('#20803'/'#31859')'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object btn5: TButton
        Left = 161
        Top = 63
        Width = 49
        Height = 22
        Caption = #20445#23384
        Enabled = False
        TabOrder = 6
        OnClick = btn5Click
      end
      object edt7: TEdit
        Left = 512
        Top = 32
        Width = 57
        Height = 20
        Hint = #21333#20301'('#20803')'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
      object btn6: TButton
        Left = 576
        Top = 31
        Width = 49
        Height = 22
        Caption = #20445#23384
        Enabled = False
        TabOrder = 8
        OnClick = btn6Click
      end
      object edt8: TEdit
        Left = 512
        Top = 64
        Width = 57
        Height = 20
        Hint = #21333#20301'('#20803')'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object btn7: TButton
        Left = 576
        Top = 63
        Width = 49
        Height = 22
        Caption = #20445#23384
        Enabled = False
        TabOrder = 10
        OnClick = btn7Click
      end
      object btn10: TButton
        Left = 472
        Top = 144
        Width = 70
        Height = 22
        Caption = #21047#26032
        TabOrder = 11
        OnClick = btn10Click
      end
      object btn11: TButton
        Left = 552
        Top = 144
        Width = 70
        Height = 22
        Caption = #36820#22238
        TabOrder = 12
        OnClick = BtnClose1Click
      end
      object chk2: TCheckBox
        Left = 416
        Top = 98
        Width = 97
        Height = 17
        Caption = #37329#23646#25289#19997#24213#26495
        TabOrder = 13
        OnClick = chk2Click
      end
      object btn13: TButton
        Left = 40
        Top = 144
        Width = 48
        Height = 22
        Caption = 'Debug'
        TabOrder = 14
        OnClick = btn13Click
      end
    end
  end
  object qry1: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    Parameters = <>
    Top = 64
  end
  object qry2: TADOQuery
    CacheSize = 100
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dat2.mdb;Persist Se' +
      'curity Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select top 1 * from prt_proj')
    Left = 3
    Top = 161
  end
  object ds1: TDataSource
    DataSet = qry2
    Left = 1
    Top = 139
  end
end
