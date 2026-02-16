# Game API Notes - Undertale

This file is a working document for codebase research.

## 1. Overview

- Game: Undertale
- Engine: GameMaker Studio
- Architecture: x86 (`UNDERTALE.exe`)
- Mod approach: GameMaker-compatible tooling/hooking (not MelonLoader)

## 1.1 File Entry Points (Step 1)

- `D:\steam\steamapps\common\Undertale\data.win` (primary GameMaker data container)
- `D:\steam\steamapps\common\Undertale\UNDERTALE.exe` (runtime binary, x86)
- `D:\steam\steamapps\common\Undertale\options.ini` (runtime config)
- `D:\steam\steamapps\common\Undertale\credits.txt` (plain text resource)

## 2. Singleton Access Points

- `obj_time`:
  - Input/state bootstrap and per-frame control updates.
  - Language initialization and config loading.
- `obj_overworldcontroller`:
  - Field menu rendering and navigation state transitions.
- `obj_dialoguer`:
  - Dialog flow object tied to writer instances and skip behavior.

## 3. Game Key Bindings

- Directional movement: arrow keys (`vk_up`, `vk_down`, `vk_left`, `vk_right`).
- Confirm (`control 0`): `Z` or `Enter`.
- Cancel (`control 1`): `X` or `Shift`.
- Menu/extra (`control 2`): `C` or `Ctrl`.
- Quit hold: `Esc`.
- Fullscreen toggle: `F4`.

Primary sources:
- `decompiled/gml_Script_control_update.gml`
- `decompiled/gml_Object_obj_time_Step_1.gml`

## 4. Safe Mod Keys

- Avoid rebinding existing gameplay/menu keys:
  - Arrow keys, `Z`, `X`, `C`, `Enter`, `Shift`, `Ctrl`, `Esc`, `F4`.
- Keep accessibility triggers on non-conflicting combinations (recommended next pass: explicit scan for function-key usage in exported code before assigning any global hotkeys).

## 5. UI System

- Field menu core:
  - `global.interact == 5` enters menu mode in `obj_overworldcontroller`.
  - `global.menuno` and `global.menucoord[]` represent menu context and cursor.
- Dialog core:
  - Dialog text originates via `scr_gettext(...)`.
  - Dialog control object: `obj_dialoguer`.
  - Cancel can fast-forward text progression through writer state.

## 6. Game Mechanics

- Overworld and battle are split across dedicated objects/scripts.
- Confirm/cancel/menu controls are abstracted through `control_check*`, reducing the number of patch points needed.

## 7. Status Systems

- Menu UI reads player state from globals such as:
  - `global.hp`, `global.maxhp`, `global.lv`, `global.gold`.
- Battle/menu transitions are tracked via globals (`global.inbattle`, `global.menuno`, `global.interact`).

## 8. Event Hooks

- High-value initial hooks:
  - `scr_gettext`: centralized localization text resolver.
  - `obj_overworldcontroller` menu cursor transitions (`global.menuno` / `global.menucoord` changes).
  - `obj_dialoguer` lifecycle for dialog start/advance/skip announcements.
  - `control_check_pressed(0/1/2)` call sites for input-driven announcements.

## 9. Localization / Language System

- Multilingual mod support is required.
- Built-in game localization already exists (`en` + `ja`):
  - `global.language` controls active language.
  - English data: `global.text_data_en` from `lang/lang_en.json`.
  - Japanese data: `global.text_data_ja` from `lang/lang_ja.json`.
  - Resolver: `scr_gettext(text_id, ...)` with placeholder substitution (`\[C]`, `\[G]`, etc).
- Language persistence:
  - Stored in `config.ini` (`General/lang`).
  - Toggled by `scr_change_language()`.
