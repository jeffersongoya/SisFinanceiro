unit uAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, ShellAPI, Vcl.Imaging.jpeg;

type
  TAbout = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    LinkLabel1: TLinkLabel;
    LinkLabel2: TLinkLabel;
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation

{$R *.dfm}

procedure TAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  About := nil;
end;

procedure TAbout.FormCreate(Sender: TObject);
begin
  LinkLabel1.Caption := '<a href="https://github.com/jeffersongoya">https://github.com/jeffersongoya</a>';
  LinkLabel2.Caption := '<a href="https://api.whatsapp.com/send?phone=5511998400223&text=Ol%C3%A1">(11) 99840-0223</a>';
end;

procedure TAbout.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
end;

end.
