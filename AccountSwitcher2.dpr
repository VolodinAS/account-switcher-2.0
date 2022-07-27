program AccountSwitcher2;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm, frm);
  Application.Run;
end.
