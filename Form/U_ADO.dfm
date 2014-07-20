object D_ADO: TD_ADO
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 383
  Width = 774
  object AQry1: TADOQuery
    Parameters = <>
    Left = 24
    Top = 16
  end
  object AQry2: TADOQuery
    Parameters = <>
    Left = 72
    Top = 16
  end
  object AQry3: TADOQuery
    Parameters = <>
    Left = 120
    Top = 16
  end
  object ExlApp1: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 24
    Top = 72
  end
  object ExlWork1: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 72
    Top = 72
  end
  object ExlSheet1: TExcelWorksheet
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 120
    Top = 72
  end
end
