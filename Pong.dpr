program Pong;

uses
  Forms,
  fPong in 'fPong.pas' {PongForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPongForm, PongForm);
  Application.Run;
end.
