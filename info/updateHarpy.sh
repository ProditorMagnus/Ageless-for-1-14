#!/bin/bash
# echo $@
cd ..
cd ..
cp ./Ageless_Era/info/collectHarpyUnitIdReplacements.py ./Harpies/
cp ./Ageless_Era/info/convertHarpy.py ./Harpies/
cd ./Harpies/
rm -r data
mkdir data
cp amlas.cfg ./data
cp utils.cfg ./data
cp recruit_lists.cfg ./data
cp units.cfg ./data
wmlindent .
./convertHarpy.py
cd ..

rm -r ./Ageless_Era/data/harpy_data
rm -r ./Ageless_Era/units/misc_units/harpies
mv ./Harpies/Ageless_Era/units/misc_units/harpies ./Ageless_Era/units/misc_units/harpies
mv ./Harpies/Ageless_Era/data/harpy_data/units.cfg ./Ageless_Era/units/misc_units/harpies.cfg
mv ./Harpies/Ageless_Era/data/harpy_data ./Ageless_Era/data/harpy_data
mv ./Harpies/Ageless_Era/factions/default/fragment-AE/harpies.cfg ./Ageless_Era/factions/default/fragment-AE/harpies.cfg
mv ./Harpies/Ageless_Era/factions/heroes/fragment-AE/harpies.cfg ./Ageless_Era/factions/heroes/fragment-AE/harpies.cfg
mv ./Harpies/Ageless_Era/factions/RPG/fragment-AE/harpies.cfg ./Ageless_Era/factions/RPG/fragment-AE/harpies.cfg

#mv ./Harpies/Ageless_Era/factions/default/default-AoA.cfg ./Ageless_Era/factions/default/default-AoA.cfg
#mv ./Harpies/Ageless_Era/factions/heroes/heroes-AoA.cfg ./Ageless_Era/factions/heroes/heroes-AoA.cfg
# mv ./Armies_of_Amberan/Ageless_Era/factions/RPG/RPG-AoA.cfg ./Ageless_Era/factions/RPG/RPG-AoA.cfg
