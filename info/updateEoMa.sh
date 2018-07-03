#!/bin/bash
# echo $@
cp ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/info/convertEoMa.py ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/
cd ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/
~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/convertEoMa.py
wmlindent ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/Ageless_Era

rm -r ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/data/EoMa_data
rm -r ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/units/EoMa_units
mv ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/Ageless_Era/data/EoMa_data ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/data/EoMa_data
mv ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/Ageless_Era/units/EoMa_units ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/units/EoMa_units

mv ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/Ageless_Era/factions/default/default-EoMa.cfg ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/factions/default/default-EoMa.cfg
mv ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/Ageless_Era/factions/heroes/heroes-EoMa.cfg ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/factions/heroes/heroes-EoMa.cfg
mv ~/wesnoth/userdata_1_14/data/add-ons/Era_of_Magic/Ageless_Era/factions/RPG/RPG-EoMa.cfg ~/wesnoth/userdata_1_14/data/add-ons/Ageless_Era/factions/RPG/RPG-EoMa.cfg


