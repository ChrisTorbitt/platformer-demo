# Platform Wonder Demo (Godot 4.3)

A single-level 2D platformer prototype: run, jump (with coyote time +
jump buffering), a Wonder-style double jump, one stompable enemy, a
main menu, and an Options screen with working Music/SFX volume
sliders.

## Important correction on the build process

This is a **Godot** project, not raw Android Studio source. Godot
builds the APK itself — Android Studio isn't actually part of the
pipeline unless you want to hand-edit native Android/Java code later.
Here's the real flow:

1. **Install Godot 4.3** (the engine, free): https://godotengine.org/download
2. **Install the Android SDK command-line tools + build-tools + platform-tools.**
   The easiest way is to install Android Studio just to get its SDK
   Manager, then point Godot at that SDK path — so Android Studio is
   useful here as an SDK installer, not as the thing that compiles
   the game.
3. In Godot: **Editor > Manage Export Templates** → download/install
   templates for 4.3.
4. In Godot: **Editor > Editor Settings > Export > Android** → set the
   path to your Android SDK, and a debug keystore (Godot can
   auto-generate one).
5. Open this project (`project.godot`), then **Project > Export** →
   the "Android" preset is already configured (see
   `export_presets.cfg`) → click **Export Project** → you get a real
   `.apk` you can install on a phone or emulator.

If you specifically want to open this in Android Studio instead (e.g.
to add custom native plugins), use **Project > Export > Android >
Export As > Gradle Build project**, which generates a full Android
Studio project. That's the one case where Android Studio compiles it
directly. For a demo like this, plain Godot export is simpler and
faster.

## Project structure

```
PlatformerDemo/
├── project.godot            # engine config, input map, autoload
├── default_bus_layout.tres  # Master/Music/SFX audio buses
├── export_presets.cfg       # pre-filled Android export preset
├── icon.svg                 # placeholder app icon
├── autoload/
│   ├── GameSettings.gd      # persists + applies volume settings
│   └── SFX.gd                # procedural beep generator (no audio files needed)
├── assets/
│   └── CartoonTheme.tres    # old-timey cartoon UI theme (cream/black/red)
└── scenes/
    ├── MainMenu.tscn/.gd    # Start / Options / Exit
    ├── Options.tscn/.gd     # Music + SFX sliders, Back
    ├── Game.tscn/.gd        # the single test level
    ├── Player.tscn/.gd      # movement, jump, double jump, stomp
    └── Enemy.tscn/.gd       # simple patrolling enemy
```

## About the placeholder art & sound

- **Sprites** are plain colored rectangles (cream/black/red palette,
  loosely inspired by early Mickey Mouse-era cartoons: heavy black
  outlines implied by dark shapes, warm cream background, red
  accents). Easy to select in the Godot editor and swap for real
  sprite textures later — just replace the `ColorRect` nodes with
  `Sprite2D`/`AnimatedSprite2D` and assign a texture.
- **Sound effects** (jump, stomp, slider tick) are generated in code
  at runtime via `autoload/SFX.gd` — no external audio files needed
  for the demo to make noise. Swap in real `.ogg`/`.wav` files later
  by loading them into an `AudioStreamPlayer.stream`.
- **Music** has an `AudioStreamPlayer` already wired to the "Music"
  bus on the main menu (`MainMenu.tscn > MusicPlayer`) — it's silent
  until you drop a looping track into its Stream property.

## Controls (demo defaults)

- Move: `A` / `D` (or arrow keys, if you add them to the input map)
- Jump: `Space` (double-tap in the air for the Wonder-style double jump)
- Back to menu from the level: `Esc`

Touch input isn't wired up yet — for a phone build you'll want to add
on-screen buttons (Godot's `TouchScreenButton` node) mapped to the
same `move_left` / `move_right` / `jump` input actions already defined
in `project.godot`.

## Editing the level

`Game.tscn` is a normal Godot scene — open it in the editor and you
can drag the platform `StaticBody2D` nodes around, resize their
`CollisionShape2D`, duplicate them, etc. For a bigger level later,
converting the platforms to a `TileMap` is the natural next step.
