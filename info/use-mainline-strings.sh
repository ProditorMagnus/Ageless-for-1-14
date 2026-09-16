#!/bin/sh

# Looks for strings which have a translation in mainline
# and replaces them by macros defined in mainline-strings.cfg

# optional, otherwise current dir
locations=$@

function replace {
	find $locations \( -name \*.cfg -o -name \*.lua \) -print0 | xargs -0 sed -i "s/description=[[:space:]]*_*[[:space:]]*\"*$1\"*$/description=\{$2\}/i"
}

#wesnoth
replace "Bomb" STR_BOMB
replace "absorb" STR_ABSORB

#wesnoth-lib
replace "Author:" STR_AUTHOR
replace "Version:" STR_VERSION
replace "Yes" STR_YES
replace "No" STR_NO
replace "Random" STR_RANDOM
replace "Kick" STR_KICK
replace "Art Placeholder" STR_ART_PLACEHOLDER
replace "Lit" STR_LIT
replace "Beam of Light" STR_BEAM_OF_LIGHT

#wesnoth-help
replace "Immune to drain, poison, and plague" STR_NONLIVING_DESCRIPTION
replace "Zero upkeep" STR_ZERO_UPKEEP
replace "race^Human" STR_HUMAN
replace "race+female^Human" STR_HUMAN_FEMALE
replace "race^Humans" STR_HUMANS
replace "race^Dwarves" STR_DWARVES
replace "race^Monsters" STR_MONSTERS
replace "race^Monster" STR_RACE_MONSTER

replace "race+female^Monster" STR_RACE_FEMALE_MONSTER
replace "race+plural^Undead" STR_RACE_PLURAL_UNDEAD
replace "charge" STR_CHARGE
replace "poison" STR_POISON
replace "swarm" STR_SWARM
replace "Frozen" STR_FROZEN
replace "slows" STR_SLOWS
replace "stun" STR_STUN
replace "stunned" STR_STUNNED
replace "swamp lurk" STR_SWAMP_LURK
replace "female^swamp lurk" STR_FEMALE_SWAMP_LURK
replace "Max HP bonus +3, Max XP +20%" STR_MAX_HP_BONUS_3_MAX_XP_20
replace "slowed" STR_SLOWED
replace "cures" STR_CURES
replace "female^cures" STR_FEMALE_CURES
replace "regenerates" STR_REGENERATES
replace "leadership" STR_LEADERSHIP
replace "female^leadership" STR_FEMALE_LEADERSHIP
replace "drains" STR_DRAINS
replace "weak" STR_WEAK
replace "heals +12" STR_HEALS_12
replace "female^heals +12" STR_FEMALE_HEALS_12
replace "burrow" STR_BURROW
replace "poisoned" STR_POISONED

#wesnoth-units
replace "greatsword" STR_GREATSWORD
replace "saber" STR_SABER
replace "longsword" STR_LONGSWORD
replace "long sword" STR_LONGSWORD # former mainline string
replace "short sword" STR_SHORT_SWORD
replace "sword" STR_SWORD
replace "dagger" STR_DAGGER
replace "knife" STR_KNIFE
replace "throwing knives" STR_THROWING_KNIVES
replace "axe" STR_AXE
replace "battle axe" STR_BATTLE_AXE
replace "hammer" STR_HAMMER
replace "club" STR_CLUB
replace "mace" STR_MACE
replace "morning star" STR_MORNING_STAR
replace "flail" STR_FLAIL
replace "lance" STR_LANCE
replace "pike" STR_PIKE
replace "halberd" STR_HALBERD
replace "torch" STR_TORCH
replace "trident" STR_TRIDENT
replace "shield bash" STR_SHIELD_BASH
replace "berserker frenzy" STR_BERSERKER_FRENZY
replace "fist" STR_FIST
replace "sling" STR_SLING
replace "staff" STR_STAFF
replace "plague staff" STR_PLAGUE_STAFF
replace "entangle" STR_ENTANGLE
replace "ensnare" STR_ENSNARE
replace "thorns" STR_THORNS
replace "faerie fire" STR_FAERIE_FIRE
replace "fire breath" STR_FIRE_BREATH
replace "fireball" STR_FIREBALL
replace "flame blast" STR_FLAME_BLAST
replace "water spray" STR_WATER_SPRAY
replace "lightning" STR_LIGHTNING
replace "lightbeam" STR_LIGHTBEAM
replace "wail" STR_WAIL

replace "hatchet" STR_HATCHET
replace "bow" STR_BOW
replace "longbow" STR_LONGBOW
replace "composite bow" STR_COMPOSITE_BOW
# not the same, but fits the context
replace "compound bow" STR_COMPOSITE_BOW
replace "ballista" STR_BALLISTA
replace "crossbow" STR_CROSSBOW
replace "javelin" STR_JAVELIN
replace "spear" STR_SPEAR
replace "pitchfork" STR_PITCHFORK
replace "crush" STR_CRUSH
replace "touch" STR_TOUCH
replace "faerie touch" STR_FAERIE_TOUCH
replace "claws" STR_CLAWS
replace "fire claws" STR_FIRE_CLAWS
replace "battle claws" STR_BATTLE_CLAWS
replace "war blade" STR_WAR_BLADE
replace "war talon" STR_WAR_TALON
replace "beak" STR_BEAK
replace "fangs" STR_FANGS
replace "bite" STR_BITE
replace "tail" STR_TAIL
replace "tentacle" STR_TENTACLE
replace "gossamer" STR_GOSSAMER
replace "web" STR_WEB
replace "net" STR_NET
replace "ink" STR_INK
replace "sting" STR_STING
replace "pincers" STR_PINCERS
replace "jaw" STR_JAW
replace "chill wave" STR_CHILL_WAVE
replace "chill tempest" STR_CHILL_TEMPEST
replace "shadow wave" STR_SHADOW_WAVE
replace "chillwave" STR_CHILL_WAVE
replace "chilltempest" STR_CHILL_TEMPEST
replace "shadowwave" STR_SHADOW_WAVE
replace "baneblade" STR_BANEBLADE
replace "curse" STR_CURSE
replace "missile" STR_MISSILE
replace "thunderstick" STR_THUNDERSTICK
replace "dragonstaff" STR_DRAGONSTAFF
replace "ram" STR_RAM
replace "slam" STR_SLAM
replace "mud glob" STR_MUD_GLOB
replace "cleaver" STR_CLEAVER

replace "rock" STR_ROCK
replace "Snipe" STR_SNIPE
replace "chakram" STR_CHAKRAM
replace "blade" STR_BLADE
replace "falcon" STR_FALCON
replace "flamethrower" STR_FLAMETHROWER
replace "kick" STR_KICK
replace "scimitar" STR_SCIMITAR
replace "horn" STR_HORN
replace "fire" STR_FIRE
replace "dart" STR_DART
replace "shield" STR_SHIELD
replace "naia touch" STR_NAIA_TOUCH
replace "hooves" STR_HOOVES
replace "catapult" STR_CATAPULT
replace "blowgun" STR_BLOWGUN
replace "fire bash" STR_FIRE_BASH
replace "archers" STR_ARCHERS
replace "trample" STR_TRAMPLE

replace "Wolf" STR_WOLF

#wesnoth-httt
replace "holy sword" STR_HOLY_SWORD
replace "scepter" STR_SCEPTER
replace "sceptre of fire" STR_SCEPTRE_OF_FIRE
replace "raging blizzard" STR_RAGING_BLIZZARD

#wesnoth-dw
replace "storm trident" STR_STORM_TRIDENT

#wesnoth sof
replace "pick" STR_PICK

#wesnoth trow
replace "training sword" STR_TRAINING_SWORD
replace "blood kiss" STR_BLOOD_KISS

#wesnoth-utbs
replace "flaming sword" STR_FLAMING_SWORD
# replace "magic" STR_MAGIC
replace "bolas" STR_BOLAS
replace "twister" STR_TWISTER
replace "sand storm" STR_SAND_STORM
replace "shock" STR_SHOCK
replace "formation" STR_FORMATION

replace "Bandits" STR_BANDITS

#wesnoth-did
replace "Outlaws" STR_OUTLAWS

#wesnoth tsg
replace "smash" STR_SMASH
replace "gaze" STR_GAZE
replace "glaive" STR_GLAIVE

#wesnoth-l
replace "astral blade" STR_ASTRAL
replace "ice blast" STR_ICE_BLAST
replace "shadow bolt" STR_SHADOW_BOLT
replace "shadow blast" STR_SHADOW_BLAST
replace "holy ankh" STR_HOLY_ANKH

#wesnoth-tdg
replace "broadsword" STR_BROADSWORD
replace "chain" STR_CHAIN
replace "spit" STR_SPIT
replace "consume" STR_CONSUME
