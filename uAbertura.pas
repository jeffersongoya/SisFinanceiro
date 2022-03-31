unit uAbertura;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, ShellAPI;

type
  TAbertura = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LinkLabel1: TLinkLabel;
    LinkLabel2: TLinkLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Abertura: TAbertura;

implementation

{$R *.dfm}

procedure TAbertura.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TAbertura.FormCreate(Sender: TObject);
begin
  LinkLabel1.Caption := '<a href="https://github.com/jeffersongoya">https://github.com/jeffersongoya</a>';
  LinkLabel2.Caption := '<a href="https://api.whatsapp.com/send?phone=5511998400223&text=Ol%C3%A1">(11) 99840-0223</a>';
end;

procedure TAbertura.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
end;

end.
