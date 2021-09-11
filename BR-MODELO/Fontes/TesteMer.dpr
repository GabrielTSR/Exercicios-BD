program TesteMer;

uses
  Forms,
  UtesteMer in '..\Testes\UtesteMer.pas' {Form1},
  mer in 'mer.pas',
  uAux in 'uAux.pas',
  att in 'att.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
