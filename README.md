# TrueVision for Steam

A standalone tactical Steam interface with four Tensura skill profiles, created by **Golden**.
For issues or fixes, message **daddysxgold** on Discord.

Choose Raphael / Ciel, Great Sage, Luminous / Asmodeus or Veldora / Lord of Storms in **TrueVision > Configuration > TrueVision > Skill profile**. Library Home, Collections and Downloads live in the side rail; global Store/Library/Community navigation stays at the top. The duplicate Home/Collections strip is hidden. The tactical rail, squared panels, segmented navigation and game-list status icons are shared across all four profiles. Each profile has its own palette, artwork and panel texture across the Library, Store, Community, Steam Settings, Millennium Settings and bottom bar. Installed games remain brighter and heavier than uninstalled games; a filled dot marks installed games and a hollow dot marks uninstalled games. **What's New shelf** is hidden by default; set it to **Shown** in the same configuration tab to restore it. Background options are Still, Animated and Plain; animation follows window activity and reduced-motion preferences.

## Install

1. Install [Millennium](https://steambrew.app/). TrueVision 2.0 needs no other theme.
2. Download **TrueVision.zip** from the [latest release](https://github.com/SxGoldenxS/TrueVision-Steam/releases/latest), extract it, and run **INSTALL.cmd**. It backs up an existing copy and preserves your selected profile and settings.
3. Select **TrueVision** in **Steam > Millennium > Themes**, then reload Steam's UI.

For manual installation, copy the release's whole `Raphael-Ciel` folder into `Steam/millennium/themes`. Keep this folder name when upgrading an existing installation. The release includes the commit metadata needed for update tracking. A plain GitHub source ZIP does not include that installed-state file.

## Updates

Double-click **UPDATE.cmd** in the extracted package or in your installed `Steam/millennium/themes/Raphael-Ciel` folder. It checks this repository, downloads the exact latest commit over HTTPS, validates the archive and theme identity, backs up the previous copy, then replaces only TrueVision. Your Steam account, active theme and profile settings are preserved. After a successful update, the updater requests a UI-only reload through Millennium's local debugger. Steam and games remain running. If that interface is unavailable, use Easy Restart / Reload > Reload UI. Already-current checks and failed downloads do not reload anything.

Updates follow this repository's **main** branch. If you are current, the updater exits without reinstalling. There is no background service, scheduled task or polling loop. No GitHub sign-in, Git, Node.js or paid subscription is needed on recipients' PCs. Backups are kept in `Steam/millennium/backups/TrueVision`.

Existing recipients need this new package once to get the updater. Keep `UPDATE.cmd`, `Update-Theme.ps1` and `Install-Theme.ps1` together; the installed theme includes its own copies. Local theme-file edits may be overwritten by an update.

Millennium-compatible GitHub/commit metadata is included too. **Millennium's native update feed currently requires the theme to be listed in SteamBrew's catalog; this repository is not listed there. Use UPDATE.cmd.** Listing it later can enable Millennium's native path without changing the theme ID.

## Files and credits

The repository root is a ready-to-use Millennium theme: `skin.json`, CSS, JavaScript and SVG assets. No build tools are needed to use it. `metadata.json` is installation state, written by Millennium or included in the release; it is intentionally not committed here.

TrueVision is unofficial Tensura fan styling. See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md), the included font license, and the profile reference notes. The former Minimal Dark dependency was removed in 2.0. No AI-generated character artwork is used.
