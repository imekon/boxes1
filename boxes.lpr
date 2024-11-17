program boxes;

{$mode objfpc}{$H+}

uses 
  cmem,
  {uncomment if necessary}
  //raymath,
  rlgl,
  raylib, main, utils;

const
  screenWidth = 1024;
  screenHeight = 768;

var
  game: TGame;

begin
  // Initialization
  InitWindow(screenWidth, screenHeight, 'raylib - simple project with boxes');
  SetTargetFPS(60);// Set our game to run at 60 frames-per-second

  game := TGame.Create;

  // Main game loop
  while not WindowShouldClose() do
    begin
      // Update
      game.Update;

      // Draw
      BeginDrawing();
        ClearBackground(RAYWHITE);

        // Draw3D
        game.Draw3D;

        // Draw2D
        game.Draw2D;
      EndDrawing();
    end;

  game.Free;

  // De-Initialization
  CloseWindow();        // Close window and OpenGL context
end.

