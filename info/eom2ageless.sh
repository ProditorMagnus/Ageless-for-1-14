#!/bin/sh

# This transforms the code of files of EoM so that it fits for AE
# Afterwards one can copy the unit files to the AE dir
# Use this on a copy (or git dir), as it destroys the EoM data

# change textdomain
find . -name \*.cfg -print0 | xargs -0 sed -i 's/#textdomain wesnoth-Era_of_Myths/#textdomain wesnoth-Ageless_Era/'

# change era präfix
find . -name \*.cfg -print0 | xargs -0 sed -i 's/EOM_/AE_myh_/g'

# change ability name - TODO: test
find . -name \*.cfg -print0 | xargs -0 sed -i 's/{ABILITY_INSPIRE}/{ABILITY_AE_GEN_INSPIRE}/'


# the image files are in the ageless era in another folder
find units/celestials -name \*.cfg -print0 | xargs -0 sed -i 's/\"celestials\//\"units\/celestials\//g'
find units/devlings*   -name \*.cfg -print0 | xargs -0 sed -i 's/\"devlings\//\"units\/devlings\//g'
find units/elementals -name \*.cfg -print0 | xargs -0 sed -i 's/\"elementals\//\"units\/elementals\//g'
find units/therians   -name \*.cfg -print0 | xargs -0 sed -i 's/\"therians\//\"units\/therians\//g'
find units/vampires   -name \*.cfg -print0 | xargs -0 sed -i 's/\"vampires\//\"units\/vampires\//g'
find units/wargs      -name \*.cfg -print0 | xargs -0 sed -i 's/\"wargs\//\"units\/wargs\//g'
find units/windsong   -name \*.cfg -print0 | xargs -0 sed -i 's/\"windsong\//\"units\/windsong\//g'

# remove trailing whitespaces (just because why not)
find . -name \*.cfg -print0 | xargs -0 sed -i 's/[[:blank:]]*$//'

# insert spaces if needed
find units -name \*.cfg -print0 | xargs -0 sed -i 's/description=_/description= _/'
find units -name \*.cfg -print0 | xargs -0 sed -i 's/description= _\"/description= _ \"/'

# Adds the unit notice
find units -name \*.cfg -print0 | xargs -0 insert_unit_notice.awk -i inplace
