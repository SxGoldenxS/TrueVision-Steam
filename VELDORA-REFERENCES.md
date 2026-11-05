# Veldora / Lord of Storms

Version 1.8.1, 5 November 2026. Created by Golden. Support: Discord **daddysxgold**.

The user requested a skill/summoning theme without showing Veldora physically, then supplied the anime skill card as the visual authority. The theme uses SVG paths, gradients and font outlines; no physical dragon, portrait, screenshot or generated bitmap art is bundled. The unused image-generation attempt is not a build or package input.

## Reference and reconstruction

- [User-supplied anime reference: Veldora, Lord of Storm](https://static.wikia.nocookie.net/tensei-shitara-slime-datta-ken/images/7/77/Veldora_Lord_of_Storm.png/revision/latest?cb=20241020200541).
- The corresponding supplied screenshot is retained only in project research as `research/veldora/skill-reference.png`, SHA256 `DD883E878FA48E69D24E80857E851E52C726BE9FA8408D1B3A3D9CA0E66C0E7E`.
- The cyan inscription wheel, bright inner aperture, prismatic fragments, fine gold rectangular frame, black summoning banner and bottom black/gold diamond plaque follow that composition. The wheel is shifted right to accommodate Steam's library sidebar.
- `tools/trace-veldora-reference.ps1` traces the visible upper-left cyan inscription arc. Its cleaned vector contours are saved in `src/artwork/veldora-reference.mjs`. The visible arc is repeated around the wheel: the hidden full circumference cannot be recovered from this frame, so this is not an exact full-seal transcription.
- The Japanese titles **暴風竜召喚**, **発動しますか？** and **暴風之王** use Noto Serif JP vector outlines under the included SIL OFL. Font outlines approximate the reference typography; they do not reproduce the exact original lettering.
- `src/veldora-art.mjs` reconstructs the frame and remaining geometry in code. The character occupying the original scene is intentionally omitted. Atmosphere and motion are additions for the interface, not new lore.

## Skill identity

[Veldora, Lord of Storms](https://tensura.fandom.com/wiki/Veldora_(skill)) is **Rimuru's Ultimate Skill**, with **Storm Dragon Summon**, **Storm Dragon Restoration** and **Storm Magic** at the relevant stage. Later descriptions distinguish Storm Dragon Release from the earlier Summon ability. This profile references the summoning presentation; its labels are artwork, not live statuses.

[Faust, Lord of Investigation](https://tensura.fandom.com/wiki/Faust) belongs to Veldora himself. It is not merged into this summoning profile. The [official character page](https://www.ten-sura.com/character/veldora) was consulted during earlier research, but the supplied skill card now governs the visual composition and cyan/ivory/gold palette.

## Motion and integration

Still mode retains the complete card and has no animation nodes. Animated mode adds nine grouped effects: two mist drifts, one wind drift, two rotating inscription groups, prismatic fragment rotation, a core pulse and two slow local lightning pulses. There is no full-screen flash, blur filter, canvas or JavaScript frame loop.

Existing focus/visibility/fullscreen/maximized and reduced-motion gates apply, including in the separate Store browser view. The animated scene is loaded only when the selected profile and activity settings request it. No CPU/FPS measurement or zero-overhead claim is made. Library and Store surfaces reuse the profile palette and etching. Notifications retain native sizing and dismissal behavior. Installed games keep brighter/heavier names and a pale gold marker; uninstalled entries remain muted.
