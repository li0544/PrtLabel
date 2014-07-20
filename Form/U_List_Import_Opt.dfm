object F_List_Import_Opt: TF_List_Import_Opt
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #25968#25454#23548#20837#35774#32622
  ClientHeight = 203
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #26032#23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 27
    Top = 92
    Width = 24
    Height = 12
    Caption = #23494#30721
  end
  object Label2: TLabel
    Left = 27
    Top = 28
    Width = 54
    Height = 12
    Caption = 'anaor.dat'
  end
  object Label3: TLabel
    Left = 27
    Top = 60
    Width = 72
    Height = 12
    Caption = 'Material.dat'
  end
  object tboxPass: TEdit
    Left = 104
    Top = 89
    Width = 394
    Height = 20
    TabOrder = 0
  end
  object btnPath1: TButton
    Left = 512
    Top = 24
    Width = 57
    Height = 23
    Caption = #27983#35272
    TabOrder = 1
    OnClick = btnPath1Click
  end
  object tboxFile1: TEdit
    Left = 104
    Top = 25
    Width = 394
    Height = 20
    TabOrder = 2
  end
  object tboxFile2: TEdit
    Left = 105
    Top = 57
    Width = 393
    Height = 20
    TabOrder = 3
  end
  object btnPath2: TButton
    Left = 512
    Top = 53
    Width = 57
    Height = 23
    Caption = #27983#35272
    TabOrder = 4
    OnClick = btnPath2Click
  end
  object btnTest: TButton
    Left = 105
    Top = 136
    Width = 80
    Height = 30
    Caption = #27979#35797
    TabOrder = 5
    OnClick = btnTestClick
  end
  object btnSave: TButton
    Left = 315
    Top = 136
    Width = 80
    Height = 30
    Caption = #20445#23384
    TabOrder = 6
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 418
    Top = 136
    Width = 80
    Height = 30
    Caption = #20851#38381
    TabOrder = 7
    OnClick = btnCancelClick
  end
end
