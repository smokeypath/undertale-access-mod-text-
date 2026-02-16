# Step 4: Dialog + Menu Announcement Hooks (Undertale / UTMT)

This step applies a first working accessibility layer:

- Dialog text announcements (from game dialog flow)
- Menu selection announcements (field menu and item sub-menu)
- Output channel: `accessibility_announce.txt` (game dir or `%LOCALAPPDATA%\UNDERTALE`)

## 1. Apply UTMT Patch

1. Open `UndertaleModTool.exe`.
2. Open:
   - `D:\Accessibility-mod-template-1.0.1\Accessibility-Mod-Template\artifacts\working\data.win`
3. Run script:
   - `Scripts -> Run other script...`
   - Select:
     - `D:\Accessibility-mod-template-1.0.1\Accessibility-Mod-Template\scripts\utmt\Apply-Step4-AccessibilityHooks.csx`
4. Save the modified file as:
   - `D:\Accessibility-mod-template-1.0.1\Accessibility-Mod-Template\artifacts\working\data.win`

## 2. Deploy Modified data.win to Game Directory

- Copy:
  - `D:\Accessibility-mod-template-1.0.1\Accessibility-Mod-Template\artifacts\working\data.win`
- To:
  - `D:\steam\steamapps\common\Undertale\data.win`

Keep your backup in `artifacts/original/data.win`.

## 3. Start Announcement Relay

Run in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Start-GameMakerAnnouncementRelay.ps1 -GamePath "D:\steam\steamapps\common\Undertale"
```

Then start the game. The relay reads new lines from:

- `D:\steam\steamapps\common\Undertale\accessibility_announce.txt`
- `%LOCALAPPDATA%\UNDERTALE\accessibility_announce.txt`

You can also force a custom path:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Start-GameMakerAnnouncementRelay.ps1 -GamePath "D:\steam\steamapps\common\Undertale" -AnnouncementPath "C:\path\accessibility_announce.txt"
```

## Notes

- This is an initial hook layer and intentionally minimal.
- Next iteration should add:
  - Better filtering/de-duplication
  - Battle menu announcements
  - Status announcements (HP/LV/menu context transitions)
