unit main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, rlgl, utils, kraft;

type

  { TItem }

  TItem = class
  protected
    m_physics: TKraft;

  public
    constructor Create(physics: TKraft); virtual;
    procedure Draw; virtual; abstract;
    procedure Step(delta: double); virtual; abstract;
  end;

  { TPlane }

  TPlane = class(TItem)
  private
    m_body: TKraftRigidBody;
    m_shape: TKraftShapePlane;

  public
    constructor Create(physics: TKraft); override;
    destructor Destroy; override;
    procedure Draw; override;
    procedure Step(delta: double); override;
  end;

  { TBox }

  TBox = class(TItem)
  private
    m_body: TKraftRigidBody;
    m_shape: TKraftShapeBox;
    m_x, m_y, m_z, m_size: double;

  public
    constructor Create(physics: TKraft); override;
    destructor Destroy; override;
    procedure Draw; override;
    procedure Step(delta: double); override;
    procedure SetTranslate(x, y, z: double);

    property X: double read m_x;
    property Y: double read m_y;
    property Z: double read m_z;
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

{ TItem }

constructor TItem.Create(physics: TKraft);
begin
  m_physics := physics;
end;

{ TPlane }

constructor TPlane.Create(physics: TKraft);
begin
  inherited Create(physics);

  m_body := TKraftRigidBody.Create(m_physics);
  m_body.SetRigidBodyType(krbtSTATIC);

  m_shape := TKraftShapePlane.Create(m_physics, m_body,
    Plane(Vector3Norm(Vector3(0.0, 1.0, 0.0)), 0.0));
  m_shape.Restitution := 0.3;
  m_body.Finish;
  m_body.SetWorldTransformation(Matrix4x4Translate(0.0, 0.0, 0.0));
  m_body.CollisionGroups := [0];
end;

destructor TPlane.Destroy;
begin
  m_shape.Free;
  m_body.Free;

  inherited Destroy;
end;

procedure TPlane.Draw;
begin
  DrawPlane(Vec3(0, 0, 0), Vec2(100, 100), YELLOW);
end;

procedure TPlane.Step(delta: double);
begin
  //
end;

{ TBox }

constructor TBox.Create(physics: TKraft);
begin
  inherited Create(physics);

  m_size := 2;

  m_body := TKraftRigidBody.Create(m_physics);
  m_body.SetRigidBodyType(krbtDYNAMIC);

  m_shape := TKraftShapeBox.Create(m_physics, m_body, Vector3(m_size, m_size, m_size));
  m_shape.Restitution := 0.3;
  m_shape.Density := 100;

  m_body.Finish;
  m_body.SetWorldTransformation(Matrix4x4Translate(m_x, m_y, m_z));
  m_body.CollisionGroups := [0];
end;

destructor TBox.Destroy;
begin
  inherited Destroy;
end;

procedure TBox.Draw;
begin
  rlPushMatrix;

  rlLoadIdentity;
  rlMultMatrixf(@m_body.WorldTransform);
  DrawCube(Vec3(0, 0, 0), m_size * 2, m_size * 2, m_size * 2, RED);

  rlPopMatrix;
end;

procedure TBox.Step(delta: double);
begin
end;

procedure TBox.SetTranslate(x, y, z: double);
begin
  m_x := x;
  m_y := y;
  m_z := z;
  m_body.SetWorldTransformation(Matrix4x4Translate(m_x, m_y, m_z));
end;

{ TGame }

constructor TGame.Create;
const
  BOX_X = -8;
  BOX_Y = 24;
  BOX_Z = 2;

begin
  Randomize;

  m_camera.position := Vec3(0, 2, 32);
  m_camera.target := Vec3(BOX_X, BOX_Y, BOX_Z);
  m_camera.up := Vec3(0, 1, 0);
  m_camera.fovy := 60;
  m_camera.projection := CAMERA_PERSPECTIVE;

  DisableCursor;

  m_physics := TKraft.Create(-1);
  m_physics.SetFrequency(120);
  m_physics.VelocityIterations := 8;
  m_physics.PositionIterations := 3;
  m_physics.SpeculativeIterations := 8;
  m_physics.TimeOfImpactIterations := 20;
  m_physics.Gravity.y := -9.81;

  m_plane := TPlane.Create(m_physics);
  m_box := TBox.Create(m_physics);
  m_box.SetTranslate(BOX_X, BOX_Y, BOX_Z);
end;

destructor TGame.Destroy;
begin
  m_box.Free;
  m_plane.Free;

  m_physics.Free;

  inherited Destroy;
end;

procedure TGame.Update;
var
  mx, my, mz, delta: double;

begin
  delta := GetFrameTime;

  m_physics.Step(delta);
  m_plane.Step(delta);
  m_box.Step(delta);

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

