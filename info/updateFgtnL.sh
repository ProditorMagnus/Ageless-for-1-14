#!/bin/bash
# echo $@
cd ..
cd ..
cp ./Ageless_Era/info/convertFgtnL.py ./Forgotten_Legends/
cd ./Forgotten_Legends/
./convertFgtnL.py
cd ..
wmlindent ./Forgotten_Legends/Ageless_Era

rm -r ./Ageless_Era/data/FL_data
rm -r ./Ageless_Era/units/FL_units
mv ./Forgotten_Legends/Ageless_Era/data/FL_data ./Ageless_Era/data/FL_data
mv ./Forgotten_Legends/Ageless_Era/units/FL_units ./Ageless_Era/units/FL_units

mv ./Forgotten_Legends/Ageless_Era/factions/default/default-FL.cfg ./Ageless_Era/factions/default/default-FL.cfg
mv ./Forgotten_Legends/Ageless_Era/factions/heroes/heroes-FL.cfg ./Ageless_Era/factions/heroes/heroes-FL.cfg
mv ./Forgotten_Legends/Ageless_Era/factions/RPG/RPG-FL.cfg ./Ageless_Era/factions/RPG/RPG-FL.cfg
