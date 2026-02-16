# GameMaker Toolchain (Undertale)

This document defines Step 2 for the Undertale workflow.

## Goal

- Use a GameMaker-native toolchain.
- Keep `data.win` backup immutable.
- Perform all edits on a working copy.

## Required Tools

- UndertaleModTool (primary `data.win` editor)
  - Official repository: https://github.com/UnderminersTeam/UndertaleModTool
  - Releases: https://github.com/UnderminersTeam/UndertaleModTool/releases
- xdelta3 (optional, for distributing binary patches instead of full files)
  - Reference: https://github.com/jmacd/xdelta

## Project Layout

- `artifacts/original/data.win` - untouched backup
- `artifacts/working/data.win` - file to edit
- `artifacts/metadata/setup.json` - setup metadata and hash
- `patches/` - generated patch files

## Commands

Run from repository root:

```powershell
.\scripts\Initialize-GameMakerWorkspace.ps1 -GamePath "D:\steam\steamapps\common\Undertale"
.\scripts\Test-GameMakerSetup.ps1 -GamePath "D:\steam\steamapps\common\Undertale"
```

If UndertaleModTool is not in PATH, pass explicit path:

```powershell
.\scripts\Test-GameMakerSetup.ps1 -GamePath "D:\steam\steamapps\common\Undertale" -UtmtPath "C:\Tools\UndertaleModTool\UndertaleModTool.exe"
```

## First Analysis Targets in UndertaleModTool

- Strings and dialog resources (for multilingual output mapping)
- Input-related scripts/objects (movement, menu, battle selection)
- Menu and battle UI scripts (announcement hook points)

## Safety Rules

- Never edit `artifacts/original/data.win`.
- Keep checksums for every baseline.
- Build patches from `original -> working`.
