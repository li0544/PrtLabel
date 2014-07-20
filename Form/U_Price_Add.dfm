object F_Price_Add: TF_Price_Add
  Left = 488
  Top = 370
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #35774#32622#20215#26684
  ClientHeight = 190
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object lbl1: TLabel
    Left = 48
    Top = 23
    Width = 24
    Height = 12
    Caption = #26448#26009
  end
  object lbl2: TLabel
    Left = 48
    Top = 55
    Width = 24
    Height = 12
    Caption = #20215#26684
  end
  object lbl3: TLabel
    Left = 48
    Top = 87
    Width = 24
    Height = 12
    Caption = #21333#20301
  end
  object edt1: TEdit
    Left = 80
    Top = 19
    Width = 145
    Height = 20
    TabOrder = 0
    Text = 'edt1'
  end
  object edt2: TEdit
    Left = 80
    Top = 51
    Width = 145
    Height = 20
    TabOrder = 1
    Text = 'edt2'
    OnChange = edt2Change
  end
  object cbb1: TComboBox
    Left = 80
    Top = 83
    Width = 145
    Height = 20
    TabOrder = 2
    Text = 'cbb1'
  end
  object chk1: TCheckBox
    Left = 80
    Top = 115
    Width = 97
    Height = 17
    Caption = #21442#19982#35745#31639
    TabOrder = 3
  end
  object BtnSave: TButton
    Left = 64
    Top = 145
    Width = 65
    Height = 25
    Caption = #30830#23450
    TabOrder = 4
    OnClick = BtnSaveClick
  end
  object BtnCancel: TButton
    Left = 144
    Top = 145
    Width = 65
    Height = 25
    Caption = #21462#28040
    TabOrder = 5
    OnClick = BtnCancelClick
  end
end
