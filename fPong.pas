unit fPong;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus;

type
  TPongForm = class(TForm)
    Timer1: TTimer;
    Score1: TLabel;
    Score2: TLabel;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Help2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Help2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  speedHolder: integer = 10;
  ballSpeed: integer = 10;

var
  PongForm: TPongForm;
  Player1, Player2, Ball: TShape;
  x, y, speed1, speed2, sc1, sc2: integer;
  n, n2, start: boolean;

implementation

{$R *.lfm}

procedure TPongForm.About1Click(Sender: TObject);
begin
  ShowMessage('A simple pong game.');
end;

procedure TPongForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TPongForm.FormCreate(Sender: TObject);
const
  pwidth: integer = 10;
  pheight: integer = 150;
begin
  // Set initial variables.
  x := ballspeed;
  y := -ballspeed;
  start := false;

  // Initialise main form.
  doublebuffered := true;
  Left   := 0;
  Top    := 0;
  Width  := 1600;
  Height := 750;
  Color  := clBlack;

  // Initialise score counters.
  Score1.Font.Color := clLime;
  Score1.Font.Size  := 20;
  Score2.Font.Color := clLime;
  Score2.Font.Size  := 20;
  Score1.Left := PongForm.Width div 4;
  Score1.Top  := PongForm.Top + 50;
  Score2.Left := (PongForm.Width * 3) div 4;
  Score2.Top  := PongForm.Top + 50;

  // Initialise player paddles.
  Player1 := TShape.Create(self);
  with Player1 do
  begin
    Height := pheight;
    Width  := pwidth;
    Left   := 100;
    Top    := PongForm.Height div 2 - height div 2;
    Parent := self;
  end;

  Player2 := TShape.Create(self);
  with Player2 do
  begin
    Height := pheight;
    Width  := pwidth;
    Left   := PongForm.Width - Player2.Width - 30 - 100;
    Top    := PongForm.Height div 2 - height div 2;
    parent := self;
  end;

  // Initialise ball.
  Ball := TShape.Create(self);
  with Ball do
  begin
    shape  := stCircle;
    height := 20;
    width  := height;
    Left   := PongForm.Width div 2;
    Top    := PongForm.Height div 2;
    parent := self;
    brush.Color := clWhite;
  end;
end;

procedure TPongForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
  87:       begin
              if Player1.Top > PongForm.Top then
              begin
                n      := true;
                speed1 := speedholder;
              end;
            end;

  83:       begin
              if Player1.Top < (PongForm.Height - Player1.Height - 40) then
              begin
                n      := false;
                speed1 := speedholder;
              end;
            end;

  VK_UP:    begin
              if Player2.Top > PongForm.Top then
              begin
                n2     := true;
                speed2 := speedholder;
              end;
            end;

  VK_DOWN:  begin
              if Player2.Top < PongForm.Height - Player1.Height-40 then
              begin
                n2     := false;
                speed2 := speedholder;
              end;
            end;

  VK_F8:    begin
              Start1.Click;
            end;

  VK_F9:    begin
              Stop1.Click;
            end;
  end;
end;

procedure TPongForm.Help2Click(Sender: TObject);
begin
  ShowMessage('Controls: Player 1 uses W and S to move their paddle. ' +
    'Player 2 uses the Up and Down arrows. The game can be started with F8 ' +
    'and stopped with F9.');
end;

procedure TPongForm.Start1Click(Sender: TObject);
begin
  start := true;
end;

procedure TPongForm.Stop1Click(Sender: TObject);
begin
  start := false;
  sc1   := 0;
  sc2   := 0;
  Player1.Top := PongForm.Height div 2 - Player1.height div 2;
  Player2.Top := PongForm.Height div 2 - Player1.height div 2;
  Ball.Left   := PongForm.Width div 2;
  Ball.Top    := PongForm.Height div 2
end;

procedure TPongForm.Timer1Timer(Sender: TObject);
begin
  if start then
  begin

    // Keep the ball within the form.

    if (Ball.Top >= PongForm.Height-Ball.Height - 75) OR (Ball.Top <= PongForm.Top) then
    y := -y;
    if (Ball.Left <= PongForm.Left) then
    begin
      x := -x;
      inc(sc2);
    end;
    if (Ball.Left >= PongForm.Width-Ball.Width - 15) then
    begin
      x := -x;
      inc(sc1);
    end;

    // Alter ball's trajectory if it hits a paddle.

    if (ball.Left = Player1.Left+Player1.Width-20) AND ((Ball.Top <= Player1.Top+Player1.Height)
      AND (Ball.Top >= Player1.Top)) then
    x := -x;
    if (ball.Left = Player2.Left) AND ((Ball.Top <= Player2.Top+Player2.Height)
      AND (Ball.Top >= Player2.Top)) then
    x := -x;

    // Move the ball 1 unit in its current direction.

    Ball.Left := Ball.Left + x;
    Ball.Top  := Ball.Top - y;

    // Move paddle in its current direction

    if n then
      Player1.Top    := Player1.Top - speed1
    else Player1.Top := Player1.Top + speed1;
    if n2 then
      Player2.Top    := Player2.Top - speed2
    else Player2.Top := Player2.Top + speed2;

    // Keep the paddles within the form.

    if (Player1.Top >= PongForm.Height - Player1.Height - 40) then
    speed1 := 0
    else if (Player1.Top <= PongForm.Top) then
    speed1 := 0
    else speed1 := speedholder;
    if (Player2.Top >= PongForm.Height-Player1.Height-40) then
    speed2 := 0
    else if (Player2.Top <= PongForm.Top) then
    speed2 := 0
    else speed2 := speedholder;

  end;

  // Update the scores.
    Score1.Caption := inttostr(sc1);
    Score2.Caption := inttostr(sc2);

end;

end.
