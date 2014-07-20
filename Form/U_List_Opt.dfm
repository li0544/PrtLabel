object F_List_Opt: TF_List_Opt
  Left = 238
  Top = 236
  BorderStyle = bsDialog
  Caption = #35746#21333#35774#32622
  ClientHeight = 398
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object grp3: TGroupBox
    Left = 15
    Top = 8
    Width = 489
    Height = 177
    Caption = #35746#21333#21442#25968
    TabOrder = 0
    object lbl13: TLabel
      Left = 32
      Top = 40
      Width = 48
      Height = 12
      Caption = #23433#35013#22320#22336
    end
    object lbl14: TLabel
      Left = 32
      Top = 104
      Width = 48
      Height = 12
      Caption = #23458#25143#22995#21517
    end
    object lbl16: TLabel
      Left = 32
      Top = 72
      Width = 48
      Height = 12
      Caption = #32852#31995#26041#24335
    end
    object lbl17: TLabel
      Left = 264
      Top = 72
      Width = 60
      Height = 12
      Caption = #24320#26009#34920#26631#39064
    end
    object lbl1: TLabel
      Left = 264
      Top = 40
      Width = 60
      Height = 12
      Caption = #29983#20135#21333#26631#39064
    end
    object lbl2: TLabel
      Left = 264
      Top = 104
      Width = 60
      Height = 12
      Caption = #25253#20215#21333#26631#39064
    end
    object Label1: TLabel
      Left = 32
      Top = 136
      Width = 48
      Height = 12
      Caption = #20132#36135#26085#26399
    end
    object Lbl4: TLabel
      Left = 264
      Top = 136
      Width = 48
      Height = 12
      Caption = #23553#36793#24037#33402
    end
    object EdtPrd: TEdit
      Left = 328
      Top = 32
      Width = 137
      Height = 20
      TabOrder = 0
    end
    object EdtPrc: TEdit
      Left = 328
      Top = 96
      Width = 137
      Height = 20
      TabOrder = 1
    end
    object EdtAddress: TEdit
      Left = 96
      Top = 32
      Width = 137
      Height = 20
      TabOrder = 2
    end
    object EdtPhone: TEdit
      Left = 96
      Top = 64
      Width = 137
      Height = 20
      TabOrder = 3
    end
    object EdtName: TEdit
      Left = 96
      Top = 96
      Width = 137
      Height = 20
      TabOrder = 4
    end
    object EdtPro: TEdit
      Left = 328
      Top = 64
      Width = 137
      Height = 20
      TabOrder = 5
    end
    object DatUpt: TDateTimePicker
      Left = 96
      Top = 128
      Width = 137
      Height = 20
      Date = 40650.011232638890000000
      Time = 40650.011232638890000000
      TabOrder = 6
    end
    object EdtFBGY: TEdit
      Left = 328
      Top = 128
      Width = 137
      Height = 20
      TabOrder = 7
    end
  end
  object grpMQP: TGroupBox
    Left = 16
    Top = 272
    Width = 241
    Height = 57
    Caption = #29028#27668#29942#26588
    TabOrder = 1
    object Lbl3: TLabel
      Left = 128
      Top = 26
      Width = 12
      Height = 12
      Caption = 'A='
    end
    object ChkBoxMQP: TCheckBox
      Left = 24
      Top = 24
      Width = 89
      Height = 17
      Caption = #21028#26029#29028#27668#29942#26588
      TabOrder = 0
    end
    object EdtMQP_A: TEdit
      Left = 152
      Top = 22
      Width = 73
      Height = 20
      TabOrder = 1
    end
  end
  object grpQJG: TGroupBox
    Left = 264
    Top = 272
    Width = 241
    Height = 57
    Caption = #20999#35282#26588
    TabOrder = 2
    object ChkBoxQJG: TCheckBox
      Left = 24
      Top = 24
      Width = 89
      Height = 17
      Caption = 'A+'#26495#26448#21402#24230
      TabOrder = 0
    end
    object BtnHD: TButton
      Left = 136
      Top = 21
      Width = 80
      Height = 23
      Caption = #26495#26448#21402#24230
      TabOrder = 1
      OnClick = BtnHDClick
    end
  end
  object BtnSave: TButton
    Left = 424
    Top = 203
    Width = 80
    Height = 23
    Caption = #20445#23384
    TabOrder = 3
    OnClick = BtnSaveClick
  end
  object BtnDefault: TButton
    Left = 336
    Top = 203
    Width = 80
    Height = 23
    Caption = #24674#22797#40664#35748
    TabOrder = 4
    OnClick = BtnDefaultClick
  end
  object AQry1: TADOQuery
    Parameters = <>
    Left = 31
    Top = 8
  end
end
