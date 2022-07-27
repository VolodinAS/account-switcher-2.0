unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Registry, Vcl.StdCtrls, ShellApi, Vcl.ExtCtrls, FileCtrl, IniFiles,
  Vcl.ComCtrls;

type
  Tfrm = class(TForm)
    btn_addAccount: TButton;
    btn_update: TButton;
    btn_launch: TButton;
    listbox_accountList: TListBox;
    btn_removeAccount: TButton;
    tmr_focusListChecker: TTimer;
    btn_settings: TButton;
    btn_quit: TButton;
    stbar_main: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure btn_addAccountClick(Sender: TObject);
    procedure btn_updateClick(Sender: TObject);
    procedure tmr_focusListCheckerTimer(Sender: TObject);
    procedure btn_removeAccountClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure btn_settingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_launchClick(Sender: TObject);
    procedure listbox_accountListDblClick(Sender: TObject);
    procedure stbar_mainClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateList;
    procedure SettingsClientPath;
    procedure LaunchGame;
  end;

var
  frm: Tfrm;
  GLOBAL_APPLICATIION_PATH: string; // папка приложения
  GLOBAL_DIRECTORIES_REGISTRIES: string; // папка с реестрами
  GLOBAL_DIRECTORIES_CONFIG: string; // папка с конфигом
  GLOBAL_FILES_CONFIG: string; // файл с конфигом
  GLOBAL_FILES_CLIENT_NAME: string;
  GLOBAL_REGISTRY_PATH_MINES: string; // путь реестра
  GLOBAL_FILES_MINES_CLIENT: string; // путь до клиента игры

  GLOBAL_INI_CLIENT_SECTION: string;
  GLOBAL_INI_CLIENT_PARAMETER: string;

  IniFile: TIniFile;

implementation

{$R *.dfm}

procedure Tfrm.btn_addAccountClick(Sender: TObject);
var
  Reg: TRegistry;
  RegistryItems: TStringList;
  accountData: string;
  FileName, Key: string;
begin
  Reg := TRegistry.Create;
  RegistryItems := TStringList.Create;

  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey(GLOBAL_REGISTRY_PATH_MINES, false);
  Reg.GetValueNames(RegistryItems);

  if RegistryItems.Count > 0 then
  begin
    accountData := Vcl.Dialogs.InputBox
      ('Найден аккаунт (оставьте пустое имя для отмены)',
      'Введите данные аккаунта (ник, ид, что угодно):', '');
    if accountData.Length > 0 then
    begin
      FileName := GLOBAL_DIRECTORIES_REGISTRIES + '\' + accountData + '.reg';
      Key := 'HKEY_CURRENT_USER' + GLOBAL_REGISTRY_PATH_MINES;
      if ShellExecute(Handle, 'open', 'regedit.exe',
        PChar(Format('/e "%s" "%s"', [FileName, Key])), '', SW_SHOWDEFAULT) <= 32
      then // если ошибка, то возвращаемый код <=32
      begin
        RaiseLastWin32Error();
      end
      else
      begin
        ShowMessage('Аккаунт успешно сохранен');
        UpdateList;
      end;
    end
    else
    begin
      ShowMessage('Имя не может быть пустым. Отмена...');
    end;

  end
  else
  begin
    ShowMessage('Вы еще не авторизовались. Сначала авторизуйтесь хотя бы раз!');
  end;
end;

procedure Tfrm.btn_launchClick(Sender: TObject);
begin
  LaunchGame;
end;

procedure Tfrm.btn_quitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrm.btn_removeAccountClick(Sender: TObject);
var
  isRemove, currentAccount: Integer;
  RemovePath, accountName: string;
begin
  currentAccount := listbox_accountList.ItemIndex;
  accountName := listbox_accountList.Items[currentAccount];
  if currentAccount > 0 then
  begin

    isRemove := MessageDlg('Вы действительно хотите удалить аккаунт "' +
      accountName + '"?', TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo);
    if isRemove = mrYes then
    begin
      RemovePath := GLOBAL_DIRECTORIES_REGISTRIES + '\' + accountName + '.reg';
      if FileExists(RemovePath) then
      begin
        if DeleteFile(RemovePath) then
        begin
          ShowMessage('Аккаунт "' + accountName + '" успешно удален!');
          UpdateList;
        end;
      end;

    end
    else
    begin
      listbox_accountList.ItemIndex := -1;
    end;

  end
  else
  begin
    ShowMessage('Не выбран аккаунт для удаления');
  end;
end;

procedure Tfrm.btn_settingsClick(Sender: TObject);
begin
  SettingsClientPath;
end;

procedure Tfrm.btn_updateClick(Sender: TObject);
begin
  UpdateList;
end;

procedure Tfrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IniFile.Free;
end;

procedure Tfrm.FormCreate(Sender: TObject);
begin

  GLOBAL_APPLICATIION_PATH := ExtractFilePath(ParamStr(0));
  GLOBAL_DIRECTORIES_REGISTRIES := GLOBAL_APPLICATIION_PATH + 'registry';
  GLOBAL_DIRECTORIES_CONFIG := GLOBAL_APPLICATIION_PATH + 'config';
  GLOBAL_FILES_CONFIG := GLOBAL_DIRECTORIES_CONFIG + '\settings.ini';
  GLOBAL_REGISTRY_PATH_MINES := '\Software\MyachinInc\Mines3';
  GLOBAL_FILES_MINES_CLIENT := '';
  GLOBAL_INI_CLIENT_SECTION := 'MinesClient';
  GLOBAL_INI_CLIENT_PARAMETER := 'Path';
  GLOBAL_FILES_CLIENT_NAME := 'Mines3.exe';

  if not DirectoryExists(GLOBAL_DIRECTORIES_REGISTRIES) then
  begin
    if CreateDir(GLOBAL_DIRECTORIES_REGISTRIES) then
    begin

    end;
  end;

  if not DirectoryExists(GLOBAL_DIRECTORIES_CONFIG) then
  begin
    if CreateDir(GLOBAL_DIRECTORIES_CONFIG) then
    begin

    end;
  end;

  IniFile := TIniFile.Create(GLOBAL_FILES_CONFIG);

  GLOBAL_FILES_MINES_CLIENT := IniFile.ReadString(GLOBAL_INI_CLIENT_SECTION,
    GLOBAL_INI_CLIENT_PARAMETER, '');

  if GLOBAL_FILES_MINES_CLIENT = '' then
  begin
    SettingsClientPath;
  end;

  UpdateList;

end;

procedure Tfrm.listbox_accountListDblClick(Sender: TObject);
begin
  LaunchGame;
end;

procedure Tfrm.tmr_focusListCheckerTimer(Sender: TObject);
begin
  if listbox_accountList.ItemIndex >= 0 then
  begin
    btn_removeAccount.Enabled := true;
    btn_launch.Enabled := true;
  end
  else
  begin
    btn_removeAccount.Enabled := false;
    btn_launch.Enabled := false;
  end;

end;

procedure Tfrm.UpdateList;
var
  sr: TSearchRec;
  Path: string;
  buttonSelected: Integer;
  Attr: Integer;
begin
  listbox_accountList.Items.Clear;
  listbox_accountList.Enabled := false;
  Path := GLOBAL_DIRECTORIES_REGISTRIES;
  Path := IncludeTrailingPathDelimiter(Path);
  Attr := faAnyFile - faVolumeID - faDirectory;
  try
    if FindFirst(Path + '*', Attr, sr) = 0 then
      repeat
        sr.Name := StringReplace(sr.Name, '.reg', '',
          [rfReplaceAll, rfIgnoreCase]);
        listbox_accountList.Items.Add(sr.Name);
      until FindNext(sr) <> 0;
  finally
    FindClose(sr);
  end;

  if listbox_accountList.Items.Count = 0 then
  begin
    listbox_accountList.Items.Add('У Вас нет сохранённых аккаунтов');
  end
  else
  begin
    listbox_accountList.Enabled := true;
  end;

end;

procedure Tfrm.SettingsClientPath;
begin
  if not SelectDirectory('ВЫБЕРИТЕ ПАПКУ С MINES.EXE', '',
    GLOBAL_FILES_MINES_CLIENT) then
    Exit;
  if GLOBAL_FILES_MINES_CLIENT <> '' then
  begin
    GLOBAL_FILES_MINES_CLIENT := GLOBAL_FILES_MINES_CLIENT + '\' +
      GLOBAL_FILES_CLIENT_NAME;
    if FileExists(GLOBAL_FILES_MINES_CLIENT) then
    begin
      ShowMessage('Найден клиент игры. Сохранено!');
      IniFile.WriteString(GLOBAL_INI_CLIENT_SECTION,
        GLOBAL_INI_CLIENT_PARAMETER, GLOBAL_FILES_MINES_CLIENT);
    end
    else
    begin
      ShowMessage('По такому пути файла не существует!')
    end;
  end;
end;

procedure Tfrm.stbar_mainClick(Sender: TObject);
var
  foo: TPoint;
begin
  GetCursorPos(foo);
  foo := stbar_main.ScreenToClient(foo);
  // ShowMessage( IntToStr(foo.X) + ' : ' + IntToStr( foo.Y ) );
  if foo.X <= 200 then
  begin
    // link developer
    ShellExecute(Handle, 'open', 'https://vk.com/oncologist63', nil,
      nil, SW_SHOW);
  end
  else
  begin
    // link github
    ShellExecute(Handle, 'open',
      'https://github.com/VolodinAS/account-switcher-2.0', nil, nil, SW_SHOW);
  end;
end;

procedure Tfrm.LaunchGame;
var
  FileName, accountData: string;
begin
  if listbox_accountList.ItemIndex >= 0 then
  begin
    accountData := listbox_accountList.Items[listbox_accountList.ItemIndex];
    FileName := GLOBAL_DIRECTORIES_REGISTRIES + '\' + accountData + '.reg';
    if FileExists(FileName) then
    begin

      if ShellExecute(Handle, 'open', 'regedit.exe',
        PChar(Format(' /s "%s"', [FileName])), '', SW_SHOWDEFAULT) <= 32 then
      // если ошибка, то возвращаемый код <=32
      begin
        RaiseLastWin32Error();
      end
      else
      begin
        if FileExists(GLOBAL_FILES_MINES_CLIENT) then
        begin
          ShellExecute(Handle, 'open', PChar(GLOBAL_FILES_MINES_CLIENT), nil,
            nil, SW_SHOWMAXIMIZED);
        end else
        begin
          ShowMessage('Сначала выберите папку с клиентом');
          SettingsClientPath;
        end;

      end;

    end
    else
    begin
      ShowMessage('К сожалению, такого аккаунта не найдено...');
    end;
  end
  else
  begin
    ShowMessage('Не выбран аккаунт для запуска');
  end;

end;

end.
