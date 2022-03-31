unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.Menus,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    SimularFinanciamento1: TMenuItem;
    Sair1: TMenuItem;
    ImageList1: TImageList;
    Calcular1: TMenuItem;
    Sair2: TMenuItem;
    Sobre1: TMenuItem;
    N1: TMenuItem;
    procedure Sair2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Calcular1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

uses
  uCalculo, uAbout;

procedure TPrincipal.Calcular1Click(Sender: TObject);
var
  fCalculo: TCalculo;
begin
  fCalculo := TCalculo.Create(Calculo);
  fCalculo.Show;
end;


procedure TPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TPrincipal.Sair2Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja realmente sair?', 'Aviso', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = mrYes then
    Application.Terminate;
end;

procedure TPrincipal.Sobre1Click(Sender: TObject);
var
  fAbout: TAbout;
begin
  fAbout := TAbout.Create(About);
  fAbout.Show;
end;

end.
