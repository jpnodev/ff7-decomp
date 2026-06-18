# Overlays

Final Fantasy VII PSX relies heavily on executable overlays to manage memory efficiently, as the PSX only has 2MB of RAM.

## Detected Overlays

The following overlay-like files have been detected:
- `BATINI.X`
- `BATRES.X`
- `BATTLE.X`
- `BROM.X`
- `DSCHANGE.X`
- `ENDING.X`

## Reverse Engineering Goals

For each overlay, we need to understand:
- The base load address in RAM.
- The entry point or exported function table.
- Shared memory regions with the main executable (`SCES_008.68`).
- The specific module that triggers the loading of the overlay.
