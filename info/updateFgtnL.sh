#!/bin/bash
# echo $@
cd ..
cd ..
cp ./Ageless_Era/info/convertFgtnL.py ./Forgotten_Legends/
cd ./Forgotten_Legends/
./convertFgtnL.py
cd ..
wmlindent ./Forgotten_Legends/Ageless_Era

rm -r ./Ageless_Era/data/FgtnL_data
rm -r ./Ageless_Era/units/FgtnL_units
mv ./Forgotten_Legends/Ageless_Era/data/FgtnL_data ./Ageless_Era/data/FgtnL_data
mv ./Forgotten_Legends/Ageless_Era/units/FgtnL_units ./Ageless_Era/units/FgtnL_units

mv ./Forgotten_Legends/Ageless_Era/factions/default/default-FgtnL.cfg ./Ageless_Era/factions/default/default-FgtnL.cfg
mv ./Forgotten_Legends/Ageless_Era/factions/heroes/heroes-FgtnL.cfg ./Ageless_Era/factions/heroes/heroes-FgtnL.cfg
mv ./Forgotten_Legends/Ageless_Era/factions/RPG/RPG-FgtnL.cfg ./Ageless_Era/factions/RPG/RPG-FgtnL.cfg
