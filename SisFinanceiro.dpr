program SisFinanceiro;

uses
  Vcl.Forms,
  System.SysUtils,
  uPrincipal in 'uPrincipal.pas' {Principal},
  uCalculo in 'uCalculo.pas' {Calculo},
  uAbout in 'uAbout.pas' {About},
  uAbertura in 'uAbertura.pas' {Abertura};

{$R *.res}

begin
  Application.Initialize;

  Abertura := TAbertura.Create(Abertura);
  Abertura.Show;
  Application.ProcessMessages;
  Sleep(3500);

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPrincipal, Principal);

  Abertura.Close;
  Abertura.Free;

  Application.Run;
end.
