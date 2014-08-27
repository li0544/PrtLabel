object F_List_FB: TF_List_FB
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35774#32622#23553#36793#21450#25289#25163
  ClientHeight = 274
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 32
    Top = 24
    Width = 193
    Height = 161
    Caption = #23553#36793#26448#36136
    TabOrder = 0
    object label2: TLabel
      Left = 88
      Top = 24
      Width = 24
      Height = 13
      Caption = #21402#24230
    end
    object radio1: TRadioButton
      Left = 24
      Top = 56
      Width = 57
      Height = 17
      Caption = 'PVC'
      TabOrder = 0
    end
    object tbox1: TEdit
      Left = 104
      Top = 54
      Width = 64
      Height = 21
      TabOrder = 1
      Text = '2'
    end
    object tbox2: TEdit
      Left = 104
      Top = 81
      Width = 64
      Height = 21
      TabOrder = 2
      Text = '1.5'
    end
    object radio2: TRadioButton
      Left = 24
      Top = 83
      Width = 57
      Height = 17
      Caption = #38109#21512#37329
      TabOrder = 3
    end
    object tbox3: TEdit
      Left = 104
      Top = 110
      Width = 64
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object radio3: TRadioButton
      Left = 24
      Top = 112
      Width = 57
      Height = 17
      Caption = #26080
      Checked = True
      TabOrder = 5
      TabStop = True
    end
  end
  object btnSave: TButton
    Left = 232
    Top = 216
    Width = 89
    Height = 33
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 344
    Top = 216
    Width = 89
    Height = 33
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 256
    Top = 24
    Width = 193
    Height = 161
    Caption = #26465#24418#25289#25163
    TabOrder = 3
    object label3: TLabel
      Left = 88
      Top = 24
      Width = 48
      Height = 13
      Caption = #25187#38500#23610#23544
    end
    object radio4: TRadioButton
      Left = 16
      Top = 56
      Width = 82
      Height = 17
      Caption = #26465#24418#25289#25163'A'
      TabOrder = 0
    end
    object tbox4: TEdit
      Left = 104
      Top = 56
      Width = 64
      Height = 21
      TabOrder = 1
      Text = '35'
    end
    object tbox5: TEdit
      Left = 104
      Top = 83
      Width = 64
      Height = 21
      TabOrder = 2
      Text = '30'
    end
    object radio5: TRadioButton
      Left = 16
      Top = 83
      Width = 82
      Height = 17
      Caption = #26465#24418#25289#25163'B'
      TabOrder = 3
    end
    object tbox6: TEdit
      Left = 104
      Top = 110
      Width = 64
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object radio6: TRadioButton
      Left = 16
      Top = 110
      Width = 82
      Height = 17
      Caption = #26222#36890#25289#25163
      Checked = True
      TabOrder = 5
      TabStop = True
    end
  end
end
