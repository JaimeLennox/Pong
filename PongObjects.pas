unit PongObjects;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Extctrls, Forms, Dialogs;

type
  TSimpleShape =class(TGraphicControl)
    private
      FCaption:string;     // used to store a caption for the shape
      FPen: TPen;         //needed later for painting the shape
      FBrush: TBrush;
    protected
      procedure Paint; override;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function GetColour:TColor;
      procedure ChangeColour(Colour:TColor);
      procedure MoveLeft(n:integer);
      procedure MoveRight(n:integer);
      Procedure MoveUp(n : integer);
      Procedure MoveDown(n : integer);
      procedure ChangeCaption(newcaption:string);
    published
      procedure StyleChanged(Sender: TObject);
    end;

  TPaddle = class(TSimpleShape)
    public
    procedure Paint; override;
    constructor Create(AOwner:TComponent;Name:string); override;
  end;

  TBall = class(TSimpleShape)
    public
    procedure Paint; override;
    constructor Create(AOwner:TComponent;Name:string); override;
  end;

implementation

{ TSimpleShape }

constructor TSimpleShape.Create(AOwner: TComponent);
begin
  randomize;
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FPen := TPen.Create;
  FPen.OnChange := StyleChanged;
  FBrush := TBrush.Create;
  FBrush.OnChange := StyleChanged;
  Left:=100;
  Top:=100;
  Width:=100;
  Height:=100;

end;

destructor TSimpleShape.Destroy;
begin
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

procedure TSimpleShape.Paint;
begin
end;

procedure TSimpleShape.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TSimpleShape.ChangeCaption(newcaption: string);
//change the caption
begin
  FCaption:=newcaption;
  Invalidate; //forces paint
end;

procedure TSimpleShape.ChangeColour(Colour: TColor);
begin
  FBrush.color:=Colour;
end;

procedure TSimpleShape.MoveLeft(n: integer);
begin
  Left := Left - n;
end;

procedure TSimpleShape.MoveRight(n: integer);
begin
  Left := Left + n;
end;

procedure TSimpleShape.MoveUp(n: integer);
begin
  Top := Top - n;
end;

procedure TSimpleShape.MoveDown(n: integer);
begin
  Top := Top + n;
end;

function TSimpleShape.GetColour: TColor;
begin
  result:=FBrush.Color;
end;

{TPaddle}

constructor TPaddle.Create(AOwner: TComponent;Name:string);
begin
  inherited;
  FCaption:=Name;
end;

procedure TPaddle.Paint;
//display the paddle
begin
  inherited ;
  with Canvas do
  begin
    Pen := FPen;
    Brush := FBrush;
    Rectangle(0, 0, Width-50, Height);
    TextOut(10,Height div 2, FCaption);
  end;
end;

{TBall}

constructor TBall.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TBall.Paint;
begin
  inherited ;
  with Canvas do
  begin
    Pen := FPen;
    Brush := FBrush;
    Ellipse(0, 0, Width, Height);
    TextOut(10,Height div 2, Fcaption);
  end;
end;

end.
