unit uCalculo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Grids, System.ImageList,
  Vcl.ImgList, System.Generics.Collections, System.Math, StrUtils;

type
  TPrazo = class(TObject)
    private
      fPgto, fSaldo, fJuros, fAmortizacao: Extended;
      fPrazo: Integer;
      fValor: Boolean;
    public
      property Prazo: Integer read fPrazo write fPrazo;
      property Pagamento: Extended read fPgto write fPgto;
      property SaldoDevedor: Extended read fSaldo write fSaldo;
      property Juros: Extended read fJuros write fJuros;
      property Amortizacao: Extended read fAmortizacao write fAmortizacao;
      property ExibeValor: Boolean read fValor write fValor;
  end;

  TFinanciamento = class(TObject)
    private
      fPrazoPagamento: Integer;
      fCapitalInicial, fAliquotaJurosMensal: Extended;
      fListPrazo: TObjectList<TPrazo>;
    protected

    public
      constructor Create;
      destructor Destroy;
      property CapitalInicial: Extended read fCapitalInicial write fCapitalInicial;
      property AliquotaJurosMensal: Extended read fAliquotaJurosMensal write fAliquotaJurosMensal;
      property PrazoPagamento: Integer read fPrazoPagamento write fPrazoPagamento;
      property ListPrazo: TObjectList<TPrazo> read fListPrazo write fListPrazo;
  end;

  TCalculo = class(TForm)
    Panel1, Panel2, Panel3: TPanel;
    Label1, Label2, Label3: TLabel;
    edtPrazo: TSpinEdit;
    edtValorCapital: TMaskEdit;
    edtTaxaJuros: TMaskEdit;
    grdCalculo: TStringGrid;
    btnCalculo: TBitBtn;
    ImageList1: TImageList;
    Panel4: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnCalculoClick(Sender: TObject);
    procedure edtValorCapitalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtTaxaJurosKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtTaxaJurosKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorCapitalKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorCapitalExit(Sender: TObject);
    procedure edtTaxaJurosExit(Sender: TObject);
    procedure edtTaxaJurosEnter(Sender: TObject);
    procedure edtValorCapitalEnter(Sender: TObject);
    procedure edtTaxaJurosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtValorCapitalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPrazoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetNumericValue(AValor: String): Extended;
    procedure FormatCurrency(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NumbersOnly(Sender: TObject; var Key: Char);
    procedure InsertDecimals(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Calculo: TCalculo;

implementation

{$R *.dfm}

procedure TCalculo.btnCalculoClick(Sender: TObject);
var
  Col, Row, I, vPrazo: Integer;
  Financiamento: TFinanciamento;
  Total, Prazo: TPrazo;
  vCapital, vTaxa, JurosAcumulado, SaldoDevedor, ValorParcela,
  AmortizacaoAcumulado, PgtoAcumulado, SaldoDevedorInicial: Extended;
begin
  vCapital := GetNumericValue(edtValorCapital.Text);
  vTaxa := GetNumericValue(edtTaxaJuros.Text);
  vPrazo := StrToInt(edtPrazo.Text);
  if (vCapital <= 0) then
  begin
    Application.MessageBox('O Valor Capital tem que ser maior do que zero', 'Aviso', MB_OK + MB_ICONERROR);
    edtValorCapital.SetFocus;
    Exit;
  end;

  if (vTaxa <= 0) then
  begin
    Application.MessageBox('A Taxa de Juros tem que ser maior do que zero', 'Aviso', MB_OK + MB_ICONERROR);
    edtTaxaJuros.SetFocus;
    Exit;
  end;

  if (vPrazo <= 0) then
  begin
    Application.MessageBox('O Prazo tem que ser maior do que zero', 'Aviso', MB_OK + MB_ICONERROR);
    edtPrazo.SetFocus;
    Exit;
  end;

  for Col := 0 to Pred(grdCalculo.ColCount) do
    for Row := 1 to Pred(grdCalculo.RowCount) do
      grdCalculo.Cells[Col, Row] := '';

  JurosAcumulado := 0;
  Financiamento := TFinanciamento.Create;
  try
    Financiamento.fListPrazo.Clear;
    Financiamento.PrazoPagamento := vPrazo + 1;

    for I := 0 to edtPrazo.Value do
    begin
      SaldoDevedor := vCapital * Power((1 + (vTaxa / 100)), I);
      ValorParcela := SaldoDevedor - vCapital - JurosAcumulado;
      JurosAcumulado := JurosAcumulado + ValorParcela;
      Financiamento.fListPrazo.Add(TPrazo.Create);
      Financiamento.fListPrazo[I].Prazo := I;
      Financiamento.fListPrazo[I].Juros := ValorParcela;
      Financiamento.fListPrazo[I].ExibeValor := (I = 0) or (I = Pred(Financiamento.PrazoPagamento));
      if (I = Pred(Financiamento.PrazoPagamento)) then
      begin
        Financiamento.fListPrazo[I].Amortizacao  := vCapital;
        Financiamento.fListPrazo[I].Pagamento := vCapital + JurosAcumulado;
        Financiamento.fListPrazo[I].SaldoDevedor := 0;
      end
      else
      begin
        Financiamento.fListPrazo[I].Amortizacao  := 0;
        Financiamento.fListPrazo[I].Pagamento := 0;
        Financiamento.fListPrazo[I].SaldoDevedor := vCapital + JurosAcumulado;
      end;
    end;

    Total := TPrazo.Create();
    JurosAcumulado := 0;
    AmortizacaoAcumulado := 0;
    PgtoAcumulado := 0;
    SaldoDevedorInicial := Financiamento.fListPrazo[0].SaldoDevedor;
    SaldoDevedor := SaldoDevedorInicial;
    for I := 0 to Pred(Financiamento.PrazoPagamento) do
    begin
      Prazo := Financiamento.fListPrazo[I];
      JurosAcumulado := JurosAcumulado + Prazo.Juros;
      amortizacaoAcumulado := AmortizacaoAcumulado + Prazo.Amortizacao;
      PgtoAcumulado := PgtoAcumulado + Prazo.Pagamento;
      SaldoDevedor := SaldoDevedorInicial + JurosAcumulado - PgtoAcumulado;
    end;
    Total.Juros := JurosAcumulado;
    Total.ExibeValor := True;
    Total.Amortizacao := AmortizacaoAcumulado;
    Total.Pagamento := PgtoAcumulado;
    Total.SaldoDevedor := SaldoDevedor;

    for I := 0 to Pred(Financiamento.ListPrazo.Count) do
    begin
      Total := TPrazo(Financiamento.ListPrazo[I]);
      Row := I + 1;
      grdCalculo.RowCount := Row + 1;
      grdCalculo.Cells[0, Row] := FormatFloat('###0', Total.Prazo);
      grdCalculo.Cells[1, Row] := FormatFloat('###,###,##0.00', Total.Juros);
      if (Total.ExibeValor) then
      begin
        grdCalculo.Cells[2, Row] := FormatFloat('###,###,##0.00', Total.Amortizacao);
        grdCalculo.Cells[3, Row] := FormatFloat('###,###,##0.00', Total.Pagamento);
      end;
      grdCalculo.Cells[4, Row] := FormatFloat('###,###,##0.00', Total.SaldoDevedor);
    end;

    grdCalculo.RowCount := grdCalculo.RowCount + 1;
    grdCalculo.Cells[0, Pred(grdCalculo.RowCount)] := 'Totais';
    grdCalculo.Cells[1, Pred(grdCalculo.RowCount)] := FormatFloat('###,###,##0.00', Total.Juros);
    grdCalculo.Cells[2, Pred(grdCalculo.RowCount)] := FormatFloat('###,###,##0.00', Total.Amortizacao);
    grdCalculo.Cells[3, Pred(grdCalculo.RowCount)] := FormatFloat('###,###,##0.00', Total.Pagamento);
    grdCalculo.Cells[4, Pred(grdCalculo.RowCount)] := '';
  finally
    FreeAndNil(Financiamento);
  end;
end;

function TCalculo.GetNumericValue(AValor: String): Extended;
var
  new: String;
  I: Integer;
begin
  Result := 0;
  new := '';
  if (Length(AValor) > 0) then
  begin
    for I := 0 to Length(AValor) do
    begin
      if (AValor[I] in ['0'..'9',',']) then
        new := new + AValor[I];
    end;
    if (new <> '') then
      Result := StrToFloat(new)
    else
      Result := 0;
  end;
end;

procedure TCalculo.InsertDecimals(Sender: TObject);
begin
  if not AnsiContainsStr(TEdit(Sender).Text, ',') then
    TEdit(Sender).Text := TEdit(Sender).Text + ',00';
end;

procedure TCalculo.NumbersOnly(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', ',']) then
    Key := #0
  else
  if ((Key = ',') and (Pos(Key, TEdit(Sender).Text) > 0)) then
    Key := #0;
end;

procedure TCalculo.FormatCurrency(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  S: String;
begin
  if (Key in [96..107]) or (Key in [48..57]) then
  begin
    S := TEdit(Sender).Text;
    S := StringReplace(S,',','',[rfReplaceAll]);
    S := StringReplace(S,'.','',[rfReplaceAll]);
    if Length(s) = 3 then
    begin
      s := Copy(s,1,1)+','+Copy(S,2,15);
      TEdit(Sender).Text := S;
      TEdit(Sender).SelStart := Length(S);
    end
    else
    if (Length(s) > 3) and (Length(s) < 6) then
    begin
      s := Copy(s,1,length(s)-2)+','+Copy(S,length(s)-1,15);
      TEdit(Sender).Text := s;
      TEdit(Sender).SelStart := Length(S);
    end
    else
    if (Length(s) >= 6) and (Length(s) < 9) then
    begin
      s := Copy(s,1,length(s)-5)+'.'+Copy(s,length(s)-4,3)+','+Copy(S,length(s)-1,15);
      TEdit(Sender).Text := s;
      TEdit(Sender).SelStart := Length(S);
    end
    else
    if (Length(s) >= 9) and (Length(s) < 12) then
    begin
      s := Copy(s,1,length(s)-8)+'.'+Copy(s,length(s)-7,3)+'.'+
           Copy(s,length(s)-4,3)+','+Copy(S,length(s)-1,15);
      TEdit(Sender).Text := s;
      TEdit(Sender).SelStart := Length(S);
    end
    else
    if (Length(s) >= 12) and (Length(s) < 15)  then
    begin
      s := Copy(s,1,length(s)-11)+'.'+Copy(s,length(s)-10,3)+'.'+
           Copy(s,length(s)-7,3)+'.'+Copy(s,length(s)-4,3)+','+Copy(S,length(s)-1,15);
      TEdit(Sender).Text := s;
      TEdit(Sender).SelStart := Length(S);
    end;
  end;
end;

procedure TCalculo.edtPrazoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCalculo.edtTaxaJurosEnter(Sender: TObject);
begin
  edtTaxaJuros.Clear;
end;

procedure TCalculo.edtTaxaJurosExit(Sender: TObject);
begin
  InsertDecimals(Sender);
end;

procedure TCalculo.edtTaxaJurosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCalculo.edtTaxaJurosKeyPress(Sender: TObject; var Key: Char);
begin
  NumbersOnly(Sender, Key);
end;

procedure TCalculo.edtTaxaJurosKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FormatCurrency(Sender, Key, Shift);
end;

procedure TCalculo.edtValorCapitalEnter(Sender: TObject);
begin
  edtValorCapital.Clear;
end;

procedure TCalculo.edtValorCapitalExit(Sender: TObject);
begin
  InsertDecimals(Sender);
end;

procedure TCalculo.edtValorCapitalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCalculo.edtValorCapitalKeyPress(Sender: TObject; var Key: Char);
begin
  NumbersOnly(Sender, Key);
end;

procedure TCalculo.edtValorCapitalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FormatCurrency(Sender, Key, Shift);
end;

procedure TCalculo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Calculo := nil;
end;

procedure TCalculo.FormShow(Sender: TObject);
begin
  grdCalculo.Cells[0, 0] := 'Prazo';
  grdCalculo.Cells[1, 0] := 'Juros';
  grdCalculo.Cells[2, 0] := 'Amortização';
  grdCalculo.Cells[3, 0] := 'Pagamento';
  grdCalculo.Cells[4, 0] := 'Saldo Devedor';
end;

constructor TFinanciamento.Create;
begin
  Self.fListPrazo := TObjectList<TPrazo>.Create;
end;

destructor TFinanciamento.Destroy;
var
  I: Integer;
begin
  for I := 0 to Self.ListPrazo.Count - 1 do
  begin
    FreeAndNil(Self.ListPrazo[I]);
    Self.ListPrazo.Delete(I);
  end;
end;

end.
