unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Registry, Vcl.StdCtrls, ShellApi, Vcl.ExtCtrls, FileCtrl, IniFiles,
  Vcl.ComCtrls, TlHelp32;

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
    btn_updateRegistry: TButton;
    btn_launchClient: TButton;
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
    procedure btn_updateRegistryClick(Sender: TObject);
    procedure btn_launchClientClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateList;
    procedure SettingsClientPath;
    procedure LaunchGame;
    function CopyDir(const fromDir, toDir: string): Boolean;
  end;

var
  frm: Tfrm;
  GLOBAL_APPLICATIION_PATH: string; // ����� ����������
  GLOBAL_DIRECTORIES_REGISTRIES: string; // ����� � ���������
  GLOBAL_DIRECTORIES_CONFIG: string; // ����� � ��������
  GLOBAL_FILES_CONFIG: string; // ���� � ��������
  GLOBAL_FILES_CLIENT_NAME: string;
  GLOBAL_FILES_DATA_NAME: string;
  GLOBAL_REGISTRY_PATH_MINES: string; // ���� �������
  GLOBAL_FILES_MINES_CLIENT: string; // ���� �� ������� ����

  GLOBAL_INI_CLIENT_SECTION: string; // ������ � ���
  GLOBAL_INI_CLIENT_PARAMETER: string; // �������� ������ � ���
  GLOBAL_INI_CLIENT_EXE_NAME_PARAMETER: string;
  GLOBAL_INI_CLIENT_REGISTR_PATH_PARAMETER: string;

  IniFile: TIniFile;

implementation

{$R *.dfm}

uses
  StringAndHWND;

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
      ('������ ������� (�������� ������ ��� ��� ������)',
      '������� ������ �������� (���, ��, ��� ������):', '');
    if accountData.Length > 0 then
    begin
      FileName := GLOBAL_DIRECTORIES_REGISTRIES + '\' + accountData + '.reg';
      Key := 'HKEY_CURRENT_USER' + GLOBAL_REGISTRY_PATH_MINES;
      if ShellExecute(Handle, 'open', 'regedit.exe',
        PChar(Format('/e "%s" "%s"', [FileName, Key])), '', SW_SHOWDEFAULT) <= 32
      then // ���� ������, �� ������������ ��� <=32
      begin
        RaiseLastWin32Error();
      end
      else
      begin
        ShowMessage('������� ������� ��������');
        UpdateList;
      end;
    end
    else
    begin
      ShowMessage('��� �� ����� ���� ������. ������...');
    end;

  end
  else
  begin
    ShowMessage('�� ��� �� ��������������. ������� ������������� ���� �� ���!');
  end;
end;

procedure Tfrm.btn_launchClick(Sender: TObject);
begin
  LaunchGame;
end;

procedure Tfrm.btn_launchClientClick(Sender: TObject);
begin
  if FileExists(GLOBAL_FILES_MINES_CLIENT) then
  begin
    { GamePath := ExtractFilePath(GLOBAL_FILES_MINES_CLIENT);
      GameClient := GLOBAL_FILES_MINES_CLIENT;
      GameData := GamePath + 'Mines3_Data';

      if DirectoryExists(GameData) then
      begin
      GameClient := GamePath + '\' + accountData + '.exe';
      if CopyFile(PChar(GLOBAL_FILES_MINES_CLIENT), PChar(GameClient),
      false) then
      begin
      GameTwinksData := GamePath + '\' + accountData + '_Data';
      if CopyDir(PChar(GameData), PChar(GameTwinksData)) then
      begin
      // ShowMessage('123123');
      ShellExecute(Handle, 'open', PChar(GameClient),
      nil, nil, SW_SHOWMAXIMIZED);
      end;

      end;
      end; }

    ShellExecute(Handle, 'open', PChar(GLOBAL_FILES_MINES_CLIENT), nil,
      nil, SW_SHOWMAXIMIZED);
  end
  else
  begin
    ShowMessage('������� �������� ����� � ��������');
    SettingsClientPath;
  end;
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

    isRemove := MessageDlg('�� ������������� ������ ������� ������� "' +
      accountName + '"?', TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo);
    if isRemove = mrYes then
    begin
      RemovePath := GLOBAL_DIRECTORIES_REGISTRIES + '\' + accountName + '.reg';
      if FileExists(RemovePath) then
      begin
        if DeleteFile(RemovePath) then
        begin
          ShowMessage('������� "' + accountName + '" ������� ������!');
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
    ShowMessage('�� ������ ������� ��� ��������');
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

procedure Tfrm.btn_updateRegistryClick(Sender: TObject);
var
  Reg: TRegistry;
  RegistryItems: TStringList;
  accountData: string;
  FileName, Key: string;
  currentAccount: Integer;
begin
  Reg := TRegistry.Create;
  RegistryItems := TStringList.Create;

  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey(GLOBAL_REGISTRY_PATH_MINES, false);
  Reg.GetValueNames(RegistryItems);

  if RegistryItems.Count > 0 then
  begin

    if listbox_accountList.ItemIndex >= 0 then
    begin
      currentAccount := listbox_accountList.ItemIndex;
      accountData := listbox_accountList.Items[currentAccount];
      FileName := GLOBAL_DIRECTORIES_REGISTRIES + '\' + accountData + '.reg';
      Key := 'HKEY_CURRENT_USER' + GLOBAL_REGISTRY_PATH_MINES;
      if ShellExecute(Handle, 'open', 'regedit.exe',
        PChar(Format('/e "%s" "%s"', [FileName, Key])), '', SW_SHOWDEFAULT) <= 32
      then // ���� ������, �� ������������ ��� <=32
      begin
        RaiseLastWin32Error();
      end
      else
      begin
        ShowMessage('������� ������� �������!');
        UpdateList;
      end;
    end
    else
    begin
      ShowMessage('������� �������� ������� �� ������ ��� ����������!');
    end;
  end
  else
  begin
    ShowMessage('�� ��� �� ��������������. ������� ������������� ���� �� ���!');
  end;
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
  GLOBAL_FILES_DATA_NAME := '';
  GLOBAL_INI_CLIENT_SECTION := 'MinesClient';
  GLOBAL_INI_CLIENT_PARAMETER := 'Path';
  GLOBAL_FILES_CLIENT_NAME := 'Fodinae.exe';

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

  //GLOBAL_FILES_CLIENT_NAME := IniFile.ReadString(GLOBAL_INI_CLIENT_SECTION, GLOBAL_INI_CLIENT_EXE_NAME_PARAMETER, 'Mines3.exe');
  //GLOBAL_REGISTRY_PATH_MINES := IniFile.ReadString(GLOBAL_INI_CLIENT_SECTION, GLOBAL_INI_CLIENT_REGISTR_PATH_PARAMETER, '\Software\MyachinInc\Mines3');

  //IniFile.WriteString(GLOBAL_INI_CLIENT_SECTION, GLOBAL_INI_CLIENT_EXE_NAME_PARAMETER, GLOBAL_FILES_CLIENT_NAME);
  //IniFile.WriteString(GLOBAL_INI_CLIENT_SECTION, GLOBAL_INI_CLIENT_REGISTR_PATH_PARAMETER, GLOBAL_REGISTRY_PATH_MINES);


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
    btn_updateRegistry.Enabled := true;
  end
  else
  begin
    btn_removeAccount.Enabled := false;
    btn_launch.Enabled := false;
    btn_updateRegistry.Enabled := false;
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
    listbox_accountList.Items.Add('� ��� ��� ����������� ���������');
  end
  else
  begin
    listbox_accountList.Enabled := true;
  end;

end;

procedure Tfrm.SettingsClientPath;
begin
  if not SelectDirectory('�������� ����� � MINES.EXE', '',
    GLOBAL_FILES_MINES_CLIENT) then
    Exit;
  if GLOBAL_FILES_MINES_CLIENT <> '' then
  begin
    GLOBAL_FILES_MINES_CLIENT := GLOBAL_FILES_MINES_CLIENT + '\' +
      GLOBAL_FILES_CLIENT_NAME;
    if FileExists(GLOBAL_FILES_MINES_CLIENT) then
    begin
      ShowMessage('������ ������ ����. ���������!');
      IniFile.WriteString(GLOBAL_INI_CLIENT_SECTION,
        GLOBAL_INI_CLIENT_PARAMETER, GLOBAL_FILES_MINES_CLIENT);
    end
    else
    begin
      ShowMessage('�� ������ ���� ����� �� ����������!')
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
  FileName, accountData, GamePath, GameClient, GameData, GameTwinks,
    GameTwinksClient, GameTwinksData: string;
begin
  if listbox_accountList.ItemIndex >= 0 then
  begin
    accountData := listbox_accountList.Items[listbox_accountList.ItemIndex];
    FileName := GLOBAL_DIRECTORIES_REGISTRIES + '\' + accountData + '.reg';
    if FileExists(FileName) then
    begin
      if ShellExecute(Handle, 'open', 'regedit.exe',
        PChar(Format(' /s "%s"', [FileName])), '', SW_SHOWDEFAULT) <= 32 then
      // ���� ������, �� ������������ ��� <=32
      begin
        RaiseLastWin32Error();
      end
      else
      begin
        if FileExists(GLOBAL_FILES_MINES_CLIENT) then
        begin
          { GamePath := ExtractFilePath(GLOBAL_FILES_MINES_CLIENT);
            GameClient := GLOBAL_FILES_MINES_CLIENT;
            GameData := GamePath + 'Mines3_Data';

            if DirectoryExists(GameData) then
            begin
            GameClient := GamePath + '\' + accountData + '.exe';
            if CopyFile(PChar(GLOBAL_FILES_MINES_CLIENT), PChar(GameClient),
            false) then
            begin
            GameTwinksData := GamePath + '\' + accountData + '_Data';
            if CopyDir(PChar(GameData), PChar(GameTwinksData)) then
            begin
            // ShowMessage('123123');
            ShellExecute(Handle, 'open', PChar(GameClient),
            nil, nil, SW_SHOWMAXIMIZED);
            end;

            end;
            end; }

          ShellExecute(Handle, 'open', PChar(GLOBAL_FILES_MINES_CLIENT), nil,
            nil, SW_SHOWMAXIMIZED);
        end
        else
        begin
          ShowMessage('������� �������� ����� � ��������');
          SettingsClientPath;
        end;

      end;

    end
    else
    begin
      ShowMessage('� ���������, ������ �������� �� �������...');
    end;
  end
  else
  begin
    ShowMessage('�� ������ ������� ��� �������');
  end;

end;

// ������� ����������� ��������
function Tfrm.CopyDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc := FO_COPY;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom := PChar(fromDir + #0);
    pTo := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

end.
