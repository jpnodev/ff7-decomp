# Norme de nommage

Le nommage doit rester cohérent, même quand le rôle n’est pas encore certain.

## Fonctions

Préfixes recommandés :

```text
psyq_*
  Wrapper PsyQ ou fonction reconnue mais ambiguë.
  **Note :** Pour les fonctions SDK standards et certaines (ex: InitHeap, ResetGraph, DrawSync), garder le nom officiel sans le préfixe psyq_ si l'identification est certaine.

bios_*
  Fonction BIOS ou syscall PSX.

crt_*
  Runtime C / startup / init générique.

ff7_*
  Fonction propre au jeu mais module encore inconnu.

field_*
  Fonction liée au module field.

battle_*
  Fonction liée au module battle.

menu_*
  Fonction liée au menu.

world_*
  Fonction liée à la world map.

sound_*
  Fonction liée au son.

movie_*
  Fonction liée aux vidéos.

cd_*
  Fonction liée au chargement CD ou filesystem.

gpu_*
  Fonction liée au GPU ou au rendu.

gte_*
  Fonction liée à la GTE.

overlay_*
  Fonction liée au chargement ou dispatch d’overlays.

debug_*
  Fonction de debug, log, assert ou écran développeur.
```

Exemples :

```text
psyq_2mbyte_start
crt_clear_bss_and_start_main
ff7_main
ff7_init_game_systems
cd_load_overlay
battle_init_context
field_update_script_vm
menu_draw_window
world_update_player_position
```

### Fonctions inconnues

Si le rôle est inconnu, ne pas utiliser un nom trop affirmatif.

Utiliser :

```text
ff7_maybe_<role>
ff7_unknown_<short_context>
ff7_init_unknown_<index>
```

Exemples :

```text
ff7_maybe_init_save_system
ff7_unknown_main_sub_80012340
ff7_init_unknown_01
```

Quand le rôle devient clair, renommer.

## Règle spéciale matching

Quand une fonction n'est pas encore comprise, conserver l'adresse dans le nom :

```text
ff7_unknown_80012340
field_unknown_80045678
battle_unknown_800ABCDE
```

Quand le rôle devient clair, renommer sans perdre l'adresse dans le commentaire Ghidra.

## Variables globales

Préfixes recommandés :

```text
g_
  Variable globale propre au jeu.

s_
  Variable statique locale à un module.

D_
  Donnée globale encore mal comprise, avec adresse.

PTR_
  Pointeur global non typé.

ARRAY_
  Tableau global non typé.

STR_
  Chaîne globale.
```

Exemples :

```text
g_game_state
g_current_field_id
g_active_overlay_id
g_cd_file_table
g_battle_context

D_80062DC0
PTR_8009FFAC
ARRAY_800A1234
STR_80045678
```

Pour une variable globale encore inconnue, garder l’adresse dans le nom :

```text
D_80062DC0
```

Quand le rôle est compris :

```text
g_runtime_saved_ra
```

## Structures

Types recommandés :

```text
typedef struct FF7GameState FF7GameState;
typedef struct FF7CdFileEntry FF7CdFileEntry;
typedef struct FF7OverlayDesc FF7OverlayDesc;
typedef struct FF7BattleContext FF7BattleContext;
typedef struct FF7FieldScriptState FF7FieldScriptState;
```

Convention :

```text
FF7<Module><Role>
```

Exemples :

```text
FF7GameState
FF7BattleActor
FF7FieldEntity
FF7MenuWindow
FF7CdFileEntry
FF7OverlayHeader
```

## Champs de structure

Tant que le rôle est inconnu :

```text
unk_00
unk_04
unk_08
```

Quand le type est connu mais pas le rôle exact :

```text
flags_00
count_04
ptr_08
index_0c
```

Quand le rôle est clair :

```text
current_field_id
active_party_id
battle_actor_count
script_pc
```

## Variables locales

Éviter les noms Ghidra bruts comme :

```text
iVar1
uVar2
puVar3
```

Préférer :

```text
i
j
count
index
offset
size
addr
dst
src
file_id
status
result
```

Pour les pointeurs :

```text
ctx
state
entry
buffer
dst
src
actor
entity
```

Pour une variable locale inconnue :

```text
unk_value
unk_ptr
unk_index
```

## Labels

Pour les labels de contrôle :

```text
loop_clear_bss
loop_copy_table
loop_wait_cd
case_state_init
case_state_update
return_error
return_success
```

Éviter :

```text
LAB_80012340
```

sauf si le rôle est vraiment inconnu.
