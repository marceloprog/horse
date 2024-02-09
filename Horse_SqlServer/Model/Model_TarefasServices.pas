unit Model_TarefasServices;

interface                                             
   
uses
  System.SysUtils,
  System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCBase, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet,
   Model_Tarefas,  Model_Conexao;

type
  TModel_TarefasService = class
  private
    { Private declarations }
    FQry : TFDQuery;

    Conexao : TConexao;
    
  public
    Tarefa : TTarefa;
    constructor Create;
    destructor Destroy; 
  
    { Public declarations }
    function InserirTarefa():TJSONArray;
    function ListarTarefas():TJSONArray;
    function ApagarTarefa():TJSONArray;
    function AlterarStatus():TJSONArray;
    function ListarTarefasEstatistica():TJSONArray;
                       
  end;

implementation
uses
  Funcoes,Dataset.Serialize;

{ TModel_TarefasService }

function TModel_TarefasService.AlterarStatus:TJSONArray;
begin
    Result:=Nil; 
    if TRIM(Tarefa.STATUS)='' then
    begin
        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Status informado é invalido"}]'),0 ) as TJSONArray;
        exit;
    end;  
    try
        with Fqry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('update tarefas set DATASTATUS=CAST(CURRENT_TIMESTAMP AS DATE), STATUS=:PSTATUS');
            SQL.Add('where id=:ID_TAREFA');
            ParamByName('PSTATUS').Value := Tarefa.STATUS;
            ParamByName('ID_TAREFA').Value := Tarefa.ID;
            ExecSQL;

        end;

        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"sStatus alterado"}]'),0 ) as TJSONArray;

    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
end;

function TModel_TarefasService.ApagarTarefa: TJSONArray;
begin
    Result:=Nil; 
    if Tarefa.ID=0 then
    begin
        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ID da tarefa não  informado"}]'),0 ) as TJSONArray;
        exit;
    end;  
    
    try
        with Fqry do
        begin
            Active := false;
            sql.Clear;

            SQL.Add('delete from tarefas where id=:ID_TAREFA');
            ParamByName('ID_TAREFA').Value := Tarefa.ID;
            ExecSQL;

        end;
        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Registro excluido"}]'),0 ) as TJSONArray;
                
    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
end;


constructor TModel_TarefasService.Create;
begin
   Conexao := TConexao.create;

   Fqry := TFDQuery.Create(nil);
   Fqry.Connection := Conexao.FDConn;
   Tarefa := TTarefa.create;
   
end;

destructor TModel_TarefasService.Destroy;
begin
  Fqry.DisposeOf;
  Tarefa.DisposeOf;
  Conexao.DisposeOf;
  
  inherited;
  
end;

function TModel_TarefasService.InserirTarefa():TJSONArray;
begin
    Result:=Nil; 
    if trim(Tarefa.NOMETAREFA)='' then
    begin
        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Dados insuficientes para cadastro"}]'),0 ) as TJSONArray;
        exit;
    end;  
    try
        with Fqry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('insert into tarefas (DATACRIACAO,NOMETAREFA,RESPONSAVEL,STATUS,DATASTATUS,PRIORIDADE)');
            SQL.Add('values (CURRENT_TIMESTAMP,:PNOMETAREFA,:PRESPONSAVEL,:PSTATUS,CAST(CURRENT_TIMESTAMP AS DATE),:PPRIORIDADE)');

            ParamByName('PNOMETAREFA').Value  := Tarefa.NOMETAREFA;
            ParamByName('PRESPONSAVEL').Value := Tarefa.RESPONSAVEL;
            ParamByName('PSTATUS').Value      := Tarefa.STATUS;
            ParamByName('PPRIORIDADE').Value  := Tarefa.PRIORIDADE;

            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID_TAREFA FROM TAREFAS');
            active := true;

            Tarefa.ID := FieldByName('ID_TAREFA').AsInteger;
        end;

        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Tarefa inserida"}]'),0 ) as TJSONArray;

    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
end;

function TModel_TarefasService.ListarTarefas: TJSONArray;
begin    
    Result:=nil;
    try
        with Fqry do
        begin
            Active := false;
            sql.Clear;

            SQL.Add('select id,datacriacao,nometarefa,responsavel,status,'+
            'prioridade,datastatus from tarefas order by datastatus');

            active := true;

            if RecordCount > 0 then
            begin
                Result:= Fqry.ToJSONArray() ;
            end
            else
                Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Nenhum registro encontrado"}]'),0 ) as TJSONArray;
        end;

    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
     
end;

function TModel_TarefasService.ListarTarefasEstatistica: TJSONArray;
begin   
    Result:=nil;
    
  // STATUS= F  indica tarefa finalizada 
    try
        with Fqry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('with tbtarefas as ( ');
            SQL.Add('SELECT distinct PRIORIDADE,');
            SQL.Add('coalesce((select count(*) from tarefas),0) as NumeroTotalTarefas,');
            SQL.Add('coalesce((select count(*) from tarefas WHERE status<>'+Quotedstr('F')+'),0) as TotalTarefasPendentes,');
            SQL.Add('coalesce((select count(*) from tarefas WHERE status='+Quotedstr('F')+' and cast(datastatus as date)>cast(DATEADD(DAY, -7,Getdate()) as Date) ),0) as TotalTarefasConcluidas');
            SQL.Add(' FROM TAREFAS ) ');
            SQL.Add(' select prioridade,');
            SQL.Add('	   CASE prioridade ');
            SQL.Add('			WHEN 1 THEN '+Quotedstr('é possível esperar') );
            SQL.Add('			WHEN 2 THEN '+Quotedstr('pouco urgente') );
            SQL.Add('			WHEN 3 THEN '+Quotedstr('requer atenção em curto prazo, urgência') );
            SQL.Add('			WHEN 4 THEN '+Quotedstr('muito urgente') );
            SQL.Add('			WHEN 4 THEN '+Quotedstr('exige atenção imediata') );
            SQL.Add('			ELSE '+Quotedstr('Sem prioridade')  );
            SQL.Add('	       END AS DescricaoPrioridade, ');
            SQL.Add(' NumeroTotalTarefas,   ');
            SQL.Add('TotalTarefasPendentes, ');
            SQL.Add('TotalTarefasConcluidas, ');
            SQL.Add('coalesce((select count(*) from tarefas WHERE status<>'+Quotedstr('F')+' and prioridade =tbtarefas.prioridade group by prioridade),0) as PendentePorPrioridade, ');
            SQL.Add(' iif( coalesce(tbtarefas.TotalTarefasPendentes,0)>0, ');
            SQL.Add('   concat(  ');
            SQL.Add('      cast(  ');
            SQL.Add('       (coalesce((select count(*) from tarefas WHERE status<>'+Quotedstr('F')+' and prioridade =tbtarefas.prioridade group by prioridade),0)');
            SQL.Add('       /cast(tbtarefas.TotalTarefasPendentes as numeric(9,2)) *100)');
            SQL.Add('    as numeric(9,2) ),'+Quotedstr(' %')+'),  ');
            SQL.Add('	concat(0.00,'+Quotedstr(' %')+')) as MediaPrioridadeTarefasPendentes');
            SQL.Add('from tbtarefas   ');
            SQL.Add('  order by prioridade ');
            active := true;

            if RecordCount > 0 then
            begin
                Result:= Fqry.ToJSONArray() ;
            end
            else
                Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Nenhum registro encontrado para estatistica "}]'),0 ) as TJSONArray;
            
        end;
    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
     
end;


end.
