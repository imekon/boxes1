unit utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Raylib;

function Vec2(x, y: double): TVector2;
function Vec3(x, y, z: double): TVector3;

implementation

function Vec2(x, y: double): TVector2;
begin
  result.x := x;
  result.y := y;
end;

function Vec3(x, y, z: double): TVector3;
begin
  result.x := x;
  result.y := y;
  result.z := z;
end;

end.

