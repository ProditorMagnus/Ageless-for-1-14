#!/bin/sh

# This script transforms ARCHAIC code into Ageless one.
# Make a copy of the ARCHAIC code before.
# Or clone the ARCHAIC repo and clean up with git »reset --hard«.

# After transforming, copy over to Ageless the:
# - image files
# - unit files
# - race files, add _units.cfg
# - utils files
# - installed.cfg too
# - lua files to lua/ directory
# - include {ARCHAIC_EVENTS_TOP} in the [era]s
# - factions files must be created manually
# - add "Mummy Noble" if desired (not part of Archaic)

# Remove existing wml files first, so no old ones stick around.

### Main changes ###


# Change textdomain.
find . -name \*.cfg -print0 | xargs -0 sed -i 's/#textdomain wesnoth-Archaic_Era/#textdomain wesnoth-Ageless_Era/'

# Insert spaces (not really needed).
find units -name \*.cfg -print0 | xargs -0 sed -i 's/description=_/description= _/'
find units -name \*.cfg -print0 | xargs -0 sed -i 's/description= _\"/description= _ \"/'

# Add prefix for »id« in [unit_type]s and insert unit notice. Same for [race].
# The awk script keeps track of the tags it is in, in difference to the commands here.
# That way id's of inline abilites etc. aren't changed.
find units -name \*.cfg -print0 | xargs -0 insert_unit_notice_archaic.awk -i inplace

# Add prefix for »advaces_to«.
find units/*/ -name \*.cfg -print0 | xargs -0 sed -i \
    -r -e '/advances_to=/ s/(=|,) */\1AE_arc_/g'

# Add prefix for factions.
sed -i eras/base/* \
    -r -e '/type=|leader=|recruit=/ s/(=|,) */\1AE_arc_/g'

# Add prefix for factions. Problem: there are also mainline ones.
# To get an list of used races:
# grep -r race= units/ -h | sed -r -e 's/ *//' -e s/race=// | sort -u
# Solution: blacklisting used mainline races.
find units/*/ -name \*.cfg -print0 | xargs -0 sed -i \
    -r -e '/race=(goblin|gryphon|human|monster|orc|wolf)/! s/race=/race=AE_arc_/'


# Units are included differently in Ageless - remove the preprocessor directive.
sed -i units/*.cfg -e '/Include units WML directory/,$d' \
                   -e '/~add-ons\/Archaic_Era\/units/,$d'


# Movetypes need a prefix too

# - in the race files
sed -i units/archaic_units/*/*.cfg \
    -r -e '/\[movetype\]/,$ s/(name=)([A-Za-z])/\1AE_arc_\2/'

# - in the unit files
find units/archaic_units/ -name \*.cfg -print0 | xargs -0 sed -i \
    -r -e '/movement_type=/ s/(=) *("?)/\1\2AE_arc_/'

# - revert change of mainline movetypes in unit files
WESNOTH_DIR="$(wesnoth --data-path)"
MAINLINE_MOVETYPES=($(grep '        name=' $WESNOTH_DIR/data/core/units.cfg | grep -v race | cut -f 2 -d =))
for MOVETYPE in ${MAINLINE_MOVETYPES[@]}
do
sed -i units/archaic_units/*/*.cfg \
    -r -e "s/movement_type=AE_arc_$MOVETYPE/movement_type=$MOVETYPE/'"
done



# Clean up previous runs of this script and …
rm images/icons/unit-groups/race_AE_arc_*.png

# … rename the race icons.
for image in images/icons/unit-groups/*
do
    filename=$(basename $image)
    mv "$image" images/icons/unit-groups/race_AE_arc_"${filename:5}"
done



### Specific fixes ###


# Special case of base_unit - insert prefix here too.
sed -i units/phantom/Tomb_Shade.cfg \
    -r -e 's/(\{ARCHAIC_TOMB_SHADE) ([0-9])+ "/\1 \2 "AE_arc_/'

# Special case of mainline unit ID - revert change from above.
sed -i units/orcs/Frost-Goblin.cfg \
    -e 's/AE_arc_Goblin Spearman/Goblin Spearman/'

# Special case of mainline unit ID - remove unit_type.
sed -i units/orcs/Fireline.cfg \
    -e'/legacy/,/\/unit_type/d'



### Units and races are now workable. Abilites are next ###

# Adding unit type prefix also here.
# Careful, type= in a SUF needs a prefix, but not type of weapons.
sed -i utils/Archaic_abilities.cfg -e 's/type=/type=AE_arc_/'
sed -i utils/assimilation_abilities.cfg -e 's/type=/type=AE_arc_/'
sed -i installed.cfg -r -e '/type=/ s/(=|,)(")*/\1\2AE_arc_/g'
sed -i utils/vector_abilities.cfg \
    -r -e '/^#define ARCHAIC_NO_STRIKE_LIST/,/#enddef/ s/(=|,)(")*/\1\2AE_arc_/g'
sed -i utils/vector_abilities.cfg \
    -r -e '/race=(goblin|gryphon|human|monster|orc|wolf)/! s/race=/race=AE_arc_/'


# Make assimilation work with more units – use plaguable status instead of race.
# This assumes that WML allows double negations.
wml='        [not]\n                status=unplagueable\n            [/not]'
sed -i utils/assimilation_abilities.cfg \
    -e '/^#define TRI_ASS_LIST/,/#enddef/d' \
    -e "/TRI_ASS_LIST/ a\    $wml" \
    -e "/TRI_ASS_LIST/d"

# Removing this – after all Archaic is not installed. But the file cointains more.
sed -i installed.cfg -e '/^#define ARCHAIC_ERA_INSTALLED/,/#enddef/d'
sed -i installed.cfg -e 's/~add-ons\/Archaic_Era\/lua/~add-ons\/Ageless_Era\/lua/'
sed -i lua/*.lua     -e 's/~add-ons\/Archaic_Era\/lua/~add-ons\/Ageless_Era\/lua/'
sed -i lua/*.lua  -r -e '/wesnoth.get_units *\( *\{ *type *= *"/ s/("|,)([A-Za-z ]+)/\1AE_arc_\2/g'

# Fixing broken stuff:

# It's better to fix the commands above to not break this, but
# currently this script should not be re-run from scratch, nothing
# the existence of the problems here:

find units/*/ -name \*.cfg -print0 | xargs -0 sed -i \
-e 's/AE_arc_null/null/'  \
-e 's/AE_arc_"/"AE_arc_/' \
-e 'sXmisc/icon-amla-tough.pngXicons/amla-default.pngX'

# Avoiding spaces in unit names – though mainline ones have then anyway
find units/archaic_units/ -name \*.cfg -print0 | xargs -0 sed -i \
-r -e '/AE_arc/ s/(AE_arc_[_A-Za-z]+) +([ A-Za-z]+)/\1_\2/g'


### Everything required is now transformed ###


### Optional changes for better Ageless integration ###

## Goals & Aims:
# - Keeping the list of traits / abilites / specials shorter.
#   Not changing / giving an new id to them is enough for this.
#   I.e. a trait with id=elemental, but having a different
#   description will only appear once in the list.
# - Clicking on an ability / special links to other units. It's
#   nice to find other units from other factions that way.
# - Abilities doing the same behave the same.
#   Terrain code matching is one example for this.

## Traits ###

sed -i utils/Archaic_abilities.cfg \
    -e 's/aa_strong2/strong/' \
    -e 's/aa_mh_fearless/fearless/' \
    -e 's/aa_fearless/fearless/'


# Identical to many traits
find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_TRAIT_PHANTOM}/{TRAIT_ELEMENTAL}/"
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_PHANTOM/,/#enddef/d'

# Commented out, better option is to change ids of these traits

#find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_TRAIT_STRONG2}/{TRAIT_STRONG}/"
#sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_STRONG2/,/#enddef/d'

#find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_TRAIT_QUICK2}/{TRAIT_QUICK}/"
#sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_QUICK2/,/#enddef/d'

#find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_TRAIT_INTELLIGENT2}/{TRAIT_INTELLIGENT}/"
#sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_INTELLIGENT2/,/#enddef/d'

# Unused one
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_RESILIENT2/,/#enddef/d'

#find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_TRAIT_FEARLESS2}/{TRAIT_FEARLESS}/"
#sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_FEARLESS2/,/#enddef/d'

#find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_TRAIT_FEARLESS3}/{TRAIT_FEARLESS_MUSTHAVE}/"
#sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_FEARLESS3/,/#enddef/d'

quick='{ARCHAIC_TRAIT_QUICK2}\n    [+trait]\n        availability=musthave\n    [/trait]'
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_TRAIT_QUICK3/,/#enddef/{//!d}'
sed -i utils/Archaic_abilities.cfg -e "/^#define ARCHAIC_TRAIT_QUICK3/ a\    $quick"




### Share abilites with rest of Ageless ###
# They will behave the same in terms of terrain matching.

# ARCHAIC_ABILITY_ROCKHIDE         -> ABILITY_AE_CAVEAMBUSH + ABILITY_AE_MAG_MOUNTAINAMBUSH
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_ABILITY_ROCKHIDE/,/#enddef/d'
find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_ABILITY_ROCKHIDE}/{ABILITY_AE_CAVEAMBUSH}{ABILITY_AE_MAG_MOUNTAINAMBUSH}/"

# ARCHAIC_ABILITY_AQUALUNG         -> ABILITY_AE_SWAMPAMBUSH + ABILITY_SUBMERGE
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_ABILITY_AQUALUNG/,/#enddef/d'
find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_ABILITY_AQUALUNG}/{ABILITY_AE_SWAMPAMBUSH}{ABILITY_SUBMERGE}/"

# AE_ARCHAIC_ABILITY_DESERTSTALK   -> AE_ABILITY_SANDAMBUSH
sed -i utils/Archaic_abilities.cfg -e '/^#define AE_ARCHAIC_ABILITY_DESERTSTALK/,/#enddef/d'
find units -name \*.cfg -print0 | xargs -0 sed -i "s/{AE_ARCHAIC_ABILITY_DESERTSTALK}/{AE_ABILITY_SANDAMBUSH}/"


# Other very common abilites.

# ARCHAIC_ABILITY_HEALSELF         -> AE_ABILITY_REGEN
# ARCHAIC_ABILITY_SELFHEAL         -> AE_ABILITY_REGEN 4
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_ABILITY_HEALSELF/,/#enddef/d'
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_ABILITY_SELFHEAL/,/#enddef/d'
sed -i utils/vector_abilities.cfg -e 's/aa_selfheal/regenerates4/'
find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_ABILITY_HEALSELF/{AE_ABILITY_REGEN/"
find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_ABILITY_SELFHEAL}/{AE_ABILITY_REGEN 4}/"


# They probably exist already too:

# ARCHAIC_ABILITY_PENUMBRA          -> Verdunkelung
#sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_ABILITY_PENUMBRA/,/#enddef/d'
#find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_ABILITY_PENUMBRA}/{ccccccc}/"

# ARCHAIC_WEAPON_SPECIAL_SCATTER    -> >= 70%CTH
#sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_WEAPON_SPECIAL_SCATTER/,/#enddef/d'
#find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_WEAPON_SPECIAL_SCATTER}/{ccccccc}/"


# Let's replace it with a similar one, 50% instead 60%, but against all types.
# ARCHAIC_ABILITY_DANCER            -> ABILITY_DAUNTLESS
sed -i utils/Archaic_abilities.cfg -e '/^#define ARCHAIC_ABILITY_DANCER/,/#enddef/d'
find units -name \*.cfg -print0 | xargs -0 sed -i "s/{ARCHAIC_ABILITY_DANCER}/{ABILITY_DAUNTLESS}/"



### Races ###

# Unused race »phantom_wales«.
sed -i units/phantom_race.cfg -e'/will eventually be deleted/,/\/race/d'

# Unused race.
# (Rule works not)
#sed -i units/khthon_race.cfg -r -e '/\/race/,/id=AE_arc_lesser_khthon/{//!d}'
#sed -i units/khthon_race.cfg -e '/\lesser_khthon/,/\/race/d'

# There's already an Elemental race in Ageless. Why not merging them.
# (Rule works not)
#sed -i units/phantom_race.cfg -e '/\/race/,/ss_elemental/{//!d}'
#sed -i units/phantom_race.cfg -e '/\ss_elemental/,/\/race/d'
# would need to be edited too: units/south-seas/Wind_{Gale,Breeze,Gust}.cfg


# They have trait elemental - they can also use the rebranded traits.
sed -i units/menagerie_race.cfg \
    -e '/tri_avatar/,/\/race/ s/TRAIT_STRONG/TRAIT_RUBY/' \
    -e '/tri_avatar/,/\/race/ s/TRAIT_QUICK/TRAIT_EMERALD/' \
    -e '/tri_avatar/,/\/race/ s/TRAIT_RESILIENT/TRAIT_DIAMOND/' \
    -e '/tri_avatar/,/\/race/ s/TRAIT_DEXTROUS/TRAIT_AMETHYST/'



# Old code: remove ellipses.
find units/*/ -name \*.cfg -print0 | xargs -0 sed -i \
    -e '/ellipse=/d'

# Different dots for dummy text.
find units/ utils/ -name \*.cfg -print0 | xargs -0 sed -i \
    -e  's/\.\.\./…/g'


### Optional ###

#remove trailing whitespaces
find . -name \*.cfg -print0 | xargs -0 sed -i 's/[[:blank:]]*$//'

# Keeing track of not needed files:
#rm _main.cfg theme.cfg LICENSE COPYING.txt README.md _server.ign campaign.cfg
#rm -r dist images/theme
#shall use Ageless file
#rm mainline-strings.cfg

echo "TODO: wire in ART_LICENSE manually"
echo "TODO: remove unused race lesser_khthon manually"
echo "OPTIONAL: use existing elementals race"



### Finished ###
# General notes
# from writing
# this script:

# Things to be carful about:
# - Not matching »variation_id«, used by Ukian_Witch
# - Only two unit id's are from mainline, rest can be prefixed.
#   This must be done for the »id« key and the »advances_to« key.
# - Three cases of [base_unit]
#   > »Archaic_Orcish Grunt« which advances to a mainline unit.
#     -> legacy code, remove the [unit_type], handled above
#   > »Archaic_Goblin« inherits from a mainline unit
#     -> changed back, handled above
#   > Tomb_Shades use ids in a macro
#     -> is handled above
# - Sometimes abilites / amlas are in [unit_type]s.
#   Leave them untouched, don't change their ID.
# - Deleting selective [race] tags is hard.

