#!/bin/bash
# echo $@
cd ..
cd ..
cp ./Ageless_Era/info/convertRashy.py ./Rashy_Era/
cp ./Ageless_Era/info/collectRashyUnitIdReplacements.py ./Rashy_Era/
cd ./Rashy_Era/
wmlindent .
chmod +x convertRashy.py
./convertRashy.py
cd ..
wmlindent ./Rashy_Era/Ageless_Era

rm -r ./Ageless_Era/data/RE_data
rm -r ./Ageless_Era/units/RE_units
mv ./Rashy_Era/Ageless_Era/data/RE_data ./Ageless_Era/data/RE_data
mv ./Rashy_Era/Ageless_Era/units/RE_units ./Ageless_Era/units/RE_units

mv ./Rashy_Era/Ageless_Era/factions/default/default-RE.cfg ./Ageless_Era/factions/default/default-RE.cfg
mv ./Rashy_Era/Ageless_Era/factions/heroes/heroes-RE.cfg ./Ageless_Era/factions/heroes/heroes-RE.cfg
mv ./Rashy_Era/Ageless_Era/factions/RPG/RPG-RE.cfg ./Ageless_Era/factions/RPG/RPG-RE.cfg
