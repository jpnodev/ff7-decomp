# Final Fantasy VII PSX EU (SCES_008.68) - Main Executable

This document contains notes and reverse engineering progress for the main game executable (`SCES_008.68`).

## General Information

- **Region**: Europe / PAL
- **Disc**: 1
- **Entry PC**: `0x800110C0`
- **Text Address**: `0x80010000`
- **Text Size**: `0x00060800`
- **Text End**: `0x800707FF`
- **Stack Pointer**: `0x801FFFF0`

## Structure

- **Startup**: `start` at `0x800110C0`. Clears BSS and initializes heap, then calls `main`.
- **Main Game Loop**: TBD

## Function map

| Address | Name | Module | Status | Notes |
|---|---|---|---|---|
| 0x800110C0 | start | crt/psyq | identified | PsyQ startup / 2MBYTE.OBJ |
| TBD | main | ff7 | pending | Main entry after runtime startup |
