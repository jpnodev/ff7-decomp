# Fonctions SDK & PsyQ (Ne pas décompiler)

Ce fichier recense les fonctions identifiées comme appartenant au SDK PlayStation (PsyQ/libapi/libgpu/libspu/etc.).
Ces fonctions ne doivent **pas** être décompilées en C. Elles sont conservées en `hasm` (assembleur manuel) ou restent dans les blocs `asm` bruts.

**Dans Ghidra : ne pas explorer l'arbre d'appels à l'intérieur de ces fonctions.**

---

## Interrupts & Callbacks (`libapi`)

| Fonction | VRAM | Description |
|---|---|---|
| `StopCallback` | `0x8003D0B0` | Arrête le système de callbacks |
| `ResetCallback` | `0x8003CFBC` | Réinitialise le système de callbacks |
| `VSyncCallback` | `0x8003D04C` | Enregistre un callback VSync |
| `DMACallback` | `0x8003D01C` | Enregistre un callback DMA |
| `InterruptCallback` | `0x8003CFEC` | Enregistre un callback d'interruption |
| `startIntr` | `0x8003D154` | Démarre le système d'interruptions |
| `stopIntr` | `0x8003D56C` | Arrête le système d'interruptions |
| `restartIntr` | `0x8003D618` | Redémarre le système d'interruptions |
| `trapIntr` | `0x8003D230` | Piège les interruptions |
| `HookEntryInt` | `0x800429F4` | Hook d'entrée d'interruption |
| `ResetEntryInt` | `0x800429E4` | Reset d'entrée d'interruption |
| `SetIntrMask` | `0x8003D138` | Configure le masque d'interruptions |
| `startIntrVSync` | `0x8003D6CC` | Démarre les interruptions VSync |
| `startIntrDMA` | `0x8003D7F4` | Démarre les interruptions DMA |
| `trapIntrVSync` | `0x8003D724` | Piège les interruptions VSync |
| `trapIntrDMA` | `0x8003D844` | Piège les interruptions DMA |
| `setIntr` | `0x8003D418` | Configure une interruption |
| `setIntrVSync` | `0x8003D79C` | Configure l'interruption VSync |
| `setIntrDMA` | `0x8003D9C8` | Configure l'interruption DMA |
| `ReturnFromException` | `0x800429D4` | Retour depuis une exception |
| `ChangeClearPAD` | `0x80042AC4` | Change/clear pour le PAD |
| `ChangeClearRCnt` | `0x80042AD4` | Change/clear pour les root counters |

## Events (`libapi`)

| Fonction | VRAM | Description |
|---|---|---|
| `OpenEvent` | `0x80042924` | Ouvre un event handler |
| `EnableEvent` | `0x80042964` | Active un event handler |
| `DeliverEvent` | `0x80042914` | Délivre un événement |

## Graphiques (`libgpu` / `libgs`)

| Fonction | VRAM | Description |
|---|---|---|
| `VSync` | `0x8003CDD8` | Synchronisation verticale |
| `GPU_cw` | `0x80046458` | Envoie une commande word au GPU |

## Géométrie (`libgte`)

| Fonction | VRAM | Description |
|---|---|---|
| `InitGeom` | `0x80039DD8` | Initialise le moteur GTE |
| `_patch_gte` | `0x8003CC98` | Patche le coprocesseur GTE |
| `RotMatrix` | `0x8003BE88` | Calcul de matrice de rotation |
| `ScaleMatrix` | `0x8003B258` | Calcul de matrice de mise à l'échelle |
| `SetRotMatrix` | `0x8003B388` | Applique la matrice de rotation |
| `SetTransMatrix` | `0x8003B418` | Applique la matrice de translation |
| `RotTransPers` | `0x8003BAD8` | Rotation + translation + perspective |
| `gte_ldv0` | — | Charge un vecteur dans le GTE |
| `gte_stsxy` | — | Stocke les coordonnées écran |
| `gte_stdp` | — | Stocke la profondeur |

## SPU / Son (`libspu`)

| Fonction | VRAM | Description |
|---|---|---|
| `SpuInit` | `0x80036194` | Initialise le SPU (wrapper FF7) |
| `_SpuInit` | `0x800361B4` | Initialisation interne du SPU |
| `SpuStart` | `0x800362AC` | Démarrage du SPU |
| `_spu_init` | `0x80036328` | Init bas-niveau du SPU |
| `_spu_writeByIO` | `0x800365BC` | Écriture I/O vers le SPU |
| `_spu_FiDMA` | `0x80036788` | DMA du SPU |
| `_spu_FsetRXX` | `0x80036C94` | Configuration registres SPU |
| `_spu_FwaitFs` | `0x80036E74` | Attente FIFO SPU |
| `_SpuDataCallback` | `0x80036ED4` | Callback de données SPU |

## Libc / Utilitaires

| Fonction | VRAM | Description |
|---|---|---|
| `printf` | `0x80042CEC` | Impression formatée |
| `memcpy` | `0x80042CBC` | Copie mémoire |
| `memclr` | `0x8003D6A0` | Nettoyage mémoire |
| `setjmp` | `0x80042C7C` | Sauvegarde du contexte |
| `FlushCache` | `0x800428C4` | Vidage du cache |

## BIOS

| Fonction | VRAM | Description |
|---|---|---|
| `SUB_000000b0` | — | Appel BIOS B(0) |

## Lecteur CD (`libcd`)

| Fonction | VRAM | Description |
|---|---|---|
| `CdInit` | `0x8003DAF4` | Initialise le lecteur CD |
| `CdRead2` | `0x800404B8` | Lit des secteurs CD (variante) |
| `CdControlB` | `0x8003E024` | Envoie une commande au lecteur CD (bloquant) |
| `CheckCallback` | `0x8003D110` | Vérifie les callbacks du CD |
| `def_cbsync` | `0x8003DB84` | Callback CD sync par défaut |
| `def_cbready` | `0x8003DBAC` | Callback CD ready par défaut |
| `def_cbread` | `0x8003DBD4` | Callback CD read par défaut |
