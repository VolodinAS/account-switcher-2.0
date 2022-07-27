object frm: Tfrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Account Switcher 2.0'
  ClientHeight = 601
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object btn_addAccount: TButton
    Left = 0
    Top = 49
    Width = 384
    Height = 49
    Align = alTop
    Caption = #1044#1054#1041#1040#1042#1048#1058#1068' '#1040#1050#1050#1040#1059#1053#1058
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    TabStop = False
    OnClick = btn_addAccountClick
    ExplicitTop = 0
    ExplicitWidth = 534
  end
  object btn_update: TButton
    Left = 0
    Top = 0
    Width = 384
    Height = 49
    Align = alTop
    Caption = #1054#1041#1053#1054#1042#1048#1058#1068' '#1057#1055#1048#1057#1054#1050
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    TabStop = False
    OnClick = btn_updateClick
    ExplicitLeft = 8
    ExplicitTop = -15
    ExplicitWidth = 534
  end
  object btn_launch: TButton
    Left = 0
    Top = 435
    Width = 384
    Height = 49
    Align = alBottom
    Caption = #1047#1040#1055#1059#1057#1058#1048#1058#1068' '#1048#1043#1056#1059
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    TabStop = False
    OnClick = btn_launchClick
    ExplicitTop = 57
    ExplicitWidth = 534
  end
  object listbox_accountList: TListBox
    Left = 0
    Top = 98
    Width = 384
    Height = 288
    TabStop = False
    Align = alClient
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemHeight = 28
    Items.Strings = (
      #1079#1072#1075#1088#1091#1079#1082#1072' '#1089#1087#1080#1089#1082#1072' '#1072#1082#1082#1072#1091#1085#1090#1086#1074'...'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10')
    ParentFont = False
    TabOrder = 3
    OnDblClick = listbox_accountListDblClick
    ExplicitHeight = 221
  end
  object btn_removeAccount: TButton
    Left = 0
    Top = 386
    Width = 384
    Height = 49
    Align = alBottom
    Caption = #1059#1044#1040#1051#1048#1058#1068' '#1040#1050#1050#1040#1059#1053#1058
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    TabStop = False
    OnClick = btn_removeAccountClick
    ExplicitTop = 57
  end
  object btn_settings: TButton
    Left = 0
    Top = 484
    Width = 384
    Height = 49
    Align = alBottom
    Caption = #1042#1067#1041#1056#1040#1058#1068' '#1055#1040#1055#1050#1059' '#1057' '#1048#1043#1056#1054#1049
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    TabStop = False
    OnClick = btn_settingsClick
    ExplicitTop = 57
    ExplicitWidth = 534
  end
  object btn_quit: TButton
    Left = 0
    Top = 533
    Width = 384
    Height = 49
    Align = alBottom
    Caption = #1042#1067#1061#1054#1044
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    TabStop = False
    OnClick = btn_quitClick
    ExplicitTop = 57
    ExplicitWidth = 534
  end
  object stbar_main: TStatusBar
    Left = 0
    Top = 582
    Width = 384
    Height = 19
    Panels = <
      item
        Text = #1056#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082': VolodinAS'
        Width = 200
      end
      item
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        Text = 'GitHub'
        Width = 50
      end>
    OnClick = stbar_mainClick
    ExplicitLeft = 192
    ExplicitTop = 536
    ExplicitWidth = 0
  end
  object tmr_focusListChecker: TTimer
    Interval = 100
    OnTimer = tmr_focusListCheckerTimer
    Left = 8
    Top = 8
  end
end
