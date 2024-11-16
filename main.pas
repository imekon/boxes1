unit main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, raylib, utils, kraft;

type

  { TPlane }

  TPlane = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw;
  end;

  { TBox }

  TBox = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw;
  end;

  { TGame }

  TGame = class
  private
    m_physics: TKraft;
    m_camera: TCamera;
    m_plane: TPlane;
    m_box: TBox;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update;
    procedure Draw3D;
    procedure Draw2D;
  end;

implementation

{ TPlane }

constructor TPlane.Create;
begin

end;

destructor TPlane.Destroy;
begin
  inherited Destroy;
end;

procedure TPlane.Draw;
begin
  DrawPlane(Vec3(0, 0, 0), Vec2(100, 100), YELLOW);
end;

{ TBox }

constructor TBox.Create;
begin

end;

destructor TBox.Destroy;
begin
  inherited Destroy;
end;

procedure TBox.Draw;
begin
  DrawCube(Vec3(-8, 12, 2), 4, 4, 4, RED);
end;

{ TGame }

constructor TGame.Create;
begin
  Randomize;

  m_camera.position := Vec3(0, 2, 4);
  m_camera.target := Vec3(0, 2, 0);
  m_camera.up := Vec3(0, 1, 0);
  m_camera.fovy := 60;
  m_camera.projection := CAMERA_PERSPECTIVE;

  m_plane := TPlane.Create;
  m_box := TBox.Create;

  DisableCursor;
end;

destructor TGame.Destroy;
begin
  m_box.Free;
  m_plane.Free;

  inherited Destroy;
end;

procedure TGame.Update;
var
  mx, my, mz: double;

begin
  mx := 0;
  my := 0;
  mz := 0;

  if (IsKeyDown(KEY_W) or IsKeyDown(KEY_UP)) then
    mx := mx + 0.1;

  if (IsKeyDown(KEY_S) or IsKeyDown(KEY_DOWN)) then
    mx := mx - 0.1;

  if (IsKeyDown(KEY_D) or IsKeyDown(KEY_RIGHT)) then
    my := my + 0.1;

  if (IsKeyDown(KEY_A) or IsKeyDown(KEY_LEFT)) then
    my := my - 0.1;

  if IsKeyDown(KEY_PAGE_UP) then
    mz := mz + 0.02;

  if IsKeyDown(KEY_PAGE_DOWN) then
    mz := mz - 0.02;

  UpdateCameraPro(@m_camera,
    Vec3(mx, my, mz),
    Vec3(GetMouseDelta().x * 0.05, GetMouseDelta().y * 0.05, 0),
    GetMouseWheelMove * 0.5);
end;

procedure TGame.Draw3D;
begin
  BeginMode3D(m_camera);
    m_plane.Draw;
    m_box.Draw;
  EndMode3D;
end;

procedure TGame.Draw2D;
begin
  DrawFPS(10, 10);
end;

end.

