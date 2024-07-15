#!/bin/bash
# echo $@
cd ..
cd ..
cp ./Ageless_Era/info/convertAoA.py ./Armies_of_Amberan/
cd ./Armies_of_Amberan/
wmlindent .
./convertAoA.py
cd ..
#wmlindent ./Armies_of_Amberan/Ageless_Era

rm -r ./Ageless_Era/data/AoA_data
rm -r ./Ageless_Era/units/AoA_units
mv ./Armies_of_Amberan/Ageless_Era/data/AoA_data ./Ageless_Era/data/AoA_data
mv ./Armies_of_Amberan/Ageless_Era/units/AoA_units ./Ageless_Era/units/AoA_units

mv ./Armies_of_Amberan/Ageless_Era/factions/default/default-AoA.cfg ./Ageless_Era/factions/default/default-AoA.cfg
mv ./Armies_of_Amberan/Ageless_Era/factions/heroes/heroes-AoA.cfg ./Ageless_Era/factions/heroes/heroes-AoA.cfg
# mv ./Armies_of_Amberan/Ageless_Era/factions/RPG/RPG-AoA.cfg ./Ageless_Era/factions/RPG/RPG-AoA.cfg
