program APIServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Horse.HandleException,
  Horse.BasicAuthentication,
  Controller_Tarefas in 'Controller\Controller_Tarefas.pas',
  Funcoes in 'Utils\Funcoes.pas',
  Model_Tarefas in 'Model\Model_Tarefas.pas',
  Model_Conexao in 'Model\Model_Conexao.pas',
  Model_TarefasServices in 'Model\Model_TarefasServices.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse
   .Use(Jhonson())
   .Use(HandleException)
   .Use(CORS);

  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('tarefa') and APassword.Equals(FormatDateTime('yyyymmdd', Date()));
    end));
   
    Controller_Tarefas.Registry;

  THorse.Listen(9000,
    procedure
    begin
       writeln('****************************************************************');
       writeln('  Servidor API-Horse (Marcelo Vidal), Aguardando requisicao .....');
       Writeln(Format('  Porta %d', [THorse.Port]));
       writeln('****************************************************************') ;
   end);
end.


