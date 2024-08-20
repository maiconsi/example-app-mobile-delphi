unit cLancamento;

interface

uses FireDAC.Comp.Client, FireDAC.DApt, System.SysUtils, FMX.Graphics;

type
    TLancamento = class
    private
        Fconn: TFDConnection;
        FID_CATEGORIA: Integer;
        FDESCRICAO: string;
        FVALOR: double;
        FDATA: TDateTime;
        FID_LANCAMENTO: Integer;
    public
        constructor Create(conn: TFDConnection);
        property ID_LANCAMENTO: Integer read FID_LANCAMENTO write FID_LANCAMENTO;
        property ID_CATEGORIA: Integer read FID_CATEGORIA write FID_CATEGORIA;
        property VALOR: double read FVALOR write FVALOR;
        property DATA: TDateTime read FDATA write FDATA;
        property DESCRICAO: string read FDESCRICAO write FDESCRICAO;

        function ListarLancamento(out erro: string): TFDQuery;
        function Inserir(out erro: string): Boolean;
        function Alterar(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
end;

implementation

{ TCategoria }

constructor TLancamento.Create(conn: TFDConnection);
begin
    Fconn := conn;
end;


function TLancamento.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_CATEGORIA <= 0 then
    begin
        erro := 'Informe a categoria do lan�amento';
        Result := false;
        exit;
    end;

    if DESCRICAO = '' then
    begin
        erro := 'Informe a descri��o do lan�amento';
        Result := false;
        exit;
    end;


    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('INSERT INTO TAB_LANCAMENTO(ID_CATEGORIA, VALOR, DATA, DESCRICAO)');
                SQL.Add('VALUES(:ID_CATEGORIA, :VALOR, :DATA, :DESCRICAO)');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ParamByName('VALOR').Value := VALOR;
                ParamByName('DATA').Value := DATA;
                ParamByName('DESCRICAO').Value := DESCRICAO;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao inserir lan�amento: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;


function TLancamento.Alterar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_LANCAMENTO <= 0 then
    begin
        erro := 'Informe o lan�amento';
        Result := false;
        exit;
    end;

    if ID_CATEGORIA <= 0 then
    begin
        erro := 'Informe a categoria do lan�amento';
        Result := false;
        exit;
    end;

    if DESCRICAO = '' then
    begin
        erro := 'Informe a descri��o do lan�amento';
        Result := false;
        exit;
    end;


    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('UPDATE TAB_LANCAMENTO SET ID_CATEGORIA=:ID_CATEGORIA, VALOR=:VALOR, ');
                SQL.Add('DATA=:DATA, DESCRICAO=:DESCRICAO ');
                SQL.Add('WHERE ID_LANCAMENTO = :ID_LANCAMENTO');
                ParamByName('ID_LANCAMENTO').Value := ID_LANCAMENTO;
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ParamByName('VALOR').Value := VALOR;
                ParamByName('DATA').Value := DATA;
                ParamByName('DESCRICAO').Value := DESCRICAO;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao alterar lan�amento: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;


function TLancamento.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_LANCAMENTO <= 0 then
    begin
        erro := 'Informe o lan�amento';
        Result := false;
        exit;
    end;

    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('DELETE FROM TAB_LANCAMENTO');
                SQL.Add('WHERE ID_LANCAMENTO = :ID_LANCAMENTO');
                ParamByName('ID_LANCAMENTO').Value := ID_LANCAMENTO;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao excluir o lan�amento: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;


function TLancamento.ListarLancamento(out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            sql.Add('SELECT L.*, C.DESCRICAO AS DESCRICAO_CATEGORIA, C.ICONE');
            sql.Add('FROM TAB_LANCAMENTO L');
            sql.Add('JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = L.ID_CATEGORIA)');
            sql.Add('WHERE 1 = 1');

            if ID_CATEGORIA > 0 then
            begin
                SQL.Add('AND L.ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
            end;

            Active := true;
        end;

        Result := qry;
        erro := '';

    except on ex:exception do
    begin
        Result := nil;
        erro := 'Erro ao consultar categorias: ' + ex.Message;
    end;
    end;
end;


end.
