object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 328
  Width = 354
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\Coders\CursoMoney2\Fontes\DB\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 56
    Top = 32
  end
end
