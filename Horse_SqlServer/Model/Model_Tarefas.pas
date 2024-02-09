unit Model_Tarefas;

interface
Type

  TTarefa = class
  private
    { Private declarations }
    FID           : Integer;
    FDATACRIACAO  : TDateTime;
    FNOMETAREFA   : String;
    FRESPONSAVEL  : String;
    FSTATUS       : String;
    FDATASTATUS   : TDateTime;
    FPRIORIDADE   : Integer;
    procedure SetID(const Value: Integer);
    procedure SetFDATACRIACAO(const Value: TDateTime);
    procedure SetFDATASTATUS(const Value: TDateTime);
    procedure SetFNOMETAREFA(const Value: String);
    procedure SetFPRIORIDADE(const Value: Integer);
    procedure SetFRESPONSAVEL(const Value: String);
    procedure SetFSTATUS(const Value: String);
    function GetID: Integer;
    function GetFDATACRIACAO: TDateTime;
    function GetFDATASTATUS: TDateTime;
    function GetFNOMETAREFA: String;
    function GetFPRIORIDADE: Integer;
    function GetFRESPONSAVEL: String;
    function GetFSTATUS: String;

  public
    property ID           : Integer   read  GetID             write SetID;         
    property DATACRIACAO  : TDateTime read  GetFDATACRIACAO   write SetFDATACRIACAO;
    property NOMETAREFA   : String    read  GetFNOMETAREFA    write SetFNOMETAREFA;
    property RESPONSAVEL  : String    read  GetFRESPONSAVEL   write SetFRESPONSAVEL;
    property STATUS       : String    read  GetFSTATUS        write SetFSTATUS;     
    property DATASTATUS   : TDateTime read  GetFDATASTATUS    write SetFDATASTATUS;
    property PRIORIDADE   : Integer   read  GetFPRIORIDADE    write SetFPRIORIDADE;
    
  end;
     

implementation

{ TTarefa }

function TTarefa.GetFDATACRIACAO: TDateTime;
begin
  Result := FDATACRIACAO;
end;

function TTarefa.GetFDATASTATUS: TDateTime;
begin
  Result := FDATASTATUS;
end;

function TTarefa.GetFNOMETAREFA: String;
begin
  Result := FNOMETAREFA;
end;

function TTarefa.GetFPRIORIDADE: Integer;
begin
  Result := FPRIORIDADE;
end;

function TTarefa.GetFRESPONSAVEL: String;
begin
  Result := FRESPONSAVEL;
end;

function TTarefa.GetFSTATUS: String;
begin
  Result := FSTATUS;
end;

function TTarefa.GetID: Integer;
begin
  Result := FID ;
end;

procedure TTarefa.SetFDATACRIACAO(const Value: TDateTime);
begin
  FDATACRIACAO := Value;
end;

procedure TTarefa.SetFDATASTATUS(const Value: TDateTime);
begin
  FDATASTATUS := Value;
end;

procedure TTarefa.SetFNOMETAREFA(const Value: String);
begin
  FNOMETAREFA := Value;
end;

procedure TTarefa.SetFPRIORIDADE(const Value: Integer);
begin
  FPRIORIDADE := Value;
end;

procedure TTarefa.SetFRESPONSAVEL(const Value: String);
begin
  FRESPONSAVEL := Value;
end;

procedure TTarefa.SetFSTATUS(const Value: String);
begin
  FSTATUS := Value;
end;

procedure TTarefa.SetID(const Value: Integer);
begin
  FID := Value;
end;

end.


   