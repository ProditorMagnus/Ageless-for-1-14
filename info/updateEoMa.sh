#!/bin/bash
# echo $@
cd ..
cd ..
cp ./Ageless_Era/info/convertEoMa.py ./Era_of_Magic/
cd ./Era_of_Magic/
./convertEoMa.py
cd ..
wmlindent ./Era_of_Magic/Ageless_Era

rm -r ./Ageless_Era/data/EoMa_data
rm -r ./Ageless_Era/units/EoMa_units
mv ./Era_of_Magic/Ageless_Era/data/EoMa_data ./Ageless_Era/data/EoMa_data
mv ./Era_of_Magic/Ageless_Era/units/EoMa_units ./Ageless_Era/units/EoMa_units

mv ./Era_of_Magic/Ageless_Era/factions/default/default-EoMa.cfg ./Ageless_Era/factions/default/default-EoMa.cfg
mv ./Era_of_Magic/Ageless_Era/factions/heroes/heroes-EoMa.cfg ./Ageless_Era/factions/heroes/heroes-EoMa.cfg
mv ./Era_of_Magic/Ageless_Era/factions/RPG/RPG-EoMa.cfg ./Ageless_Era/factions/RPG/RPG-EoMa.cfg

rm -r ./Era_of_Magic/Ageless_Era
rm ./Era_of_Magic/convertEoMa.py
