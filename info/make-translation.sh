#! /bin/sh

# If you run this script by »double clicking« it in the file manager…
# … if you get problems, it means that wmlxgettext wasn't found on the path.

# Era type add-ons with translations are Archaic, EoMa, EoM, MiE
# This script assumes that these ones are in the same dir like AE is.

# switch to AE base dir
cd ..

# Generate .pot
#wmlxgettext --directory=. --domain=wesnoth-Ageless_Era -o AE.pot --recursive

python info/crear_pot.py wesnoth-Ageless_Era
mv wesnoth-Ageless_Era.pot AE.pot

# German:
mkdir -p translations/de/LC_MESSAGES/

msgunfmt -o de-AE.po translations/de/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o de-EoM.po ../Era_of_Myths/translations/de/LC_MESSAGES/wesnoth-Era_of_Myths.mo
msgunfmt -o de-MiE.po ../Millennium_Era/translations/de/LC_MESSAGES/wesnoth-millennium-era.mo
msgunfmt -o de-EoMa.po ../Era_of_Magic/translations/de/LC_MESSAGES/wesnoth-Era_of_Magic.mo

# Copy the .pot file to tmp.po so that it is always present
# and prevent the workflow from breaking if some of the other .po files are unavailable
cp AE.pot de-tmp.po

msgmerge -m -N -o de-tmp.po de-AE.po de-tmp.po
msgmerge -m -N -o de-tmp.po de-EoMa.po de-tmp.po
msgmerge -m -N -o de-tmp.po de-MiE.po de-tmp.po
msgmerge -m -N -o de-tmp.po de-EoM.po de-tmp.po

msgfmt -o translations/de/LC_MESSAGES/wesnoth-Ageless_Era.mo de-tmp.po

# Latin
# only merging instead to copy because it leaves out unused strings (very few though)
mkdir -p translations/la/LC_MESSAGES/

msgunfmt -o la-AE.po translations/la/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o la-EoM.po ../Era_of_Myths/translations/la/LC_MESSAGES/wesnoth-Era_of_Myths.mo

cp AE.pot la-tmp.po
msgmerge -m -N -o la-tmp.po la-AE.po la-tmp.po
msgmerge -m -N -o la-tmp.po la-EoM.po la-tmp.po
msgfmt -o translations/la/LC_MESSAGES/wesnoth-Ageless_Era.mo la-tmp.po

# Polish
mkdir -p translations/pl/LC_MESSAGES/

msgunfmt -o pl-AE.po translations/pl/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o pl-EoMa.po ../Era_of_Magic/translations/pl/LC_MESSAGES/wesnoth-Era_of_Magic.mo

cp AE.pot pl-tmp.po
msgmerge -m -N -o pl-tmp.po pl-AE.po pl-tmp.po
msgmerge -m -N -o pl-tmp.po pl-EoMa.po pl-tmp.po
msgfmt -o translations/pl/LC_MESSAGES/wesnoth-Ageless_Era.mo pl-tmp.po

# Russish
mkdir -p translations/ru/LC_MESSAGES/

msgunfmt -o ru-AE.po translations/ru/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o ru-EoMa.po ../Era_of_Magic/translations/ru/LC_MESSAGES/wesnoth-Era_of_Magic.mo

cp AE.pot ru-tmp.po
msgmerge -m -N -o ru-tmp.po ru-AE.po ru-tmp.po
msgmerge -m -N -o ru-tmp.po ru-EoMa.po ru-tmp.po
msgfmt -o translations/ru/LC_MESSAGES/wesnoth-Ageless_Era.mo ru-tmp.po

# Irish
mkdir -p translations/ga/LC_MESSAGES/

msgunfmt -o ga-AE.po translations/ga/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o ga-EoMa.po ../Era_of_Magic/translations/ga/LC_MESSAGES/wesnoth-Era_of_Magic.mo

cp AE.pot ga-tmp.po
msgmerge -m -N -o ga-tmp.po ga-AE.po ga-tmp.po
msgmerge -m -N -o ga-tmp.po ga-EoMa.po ga-tmp.po
msgfmt -o translations/ga/LC_MESSAGES/wesnoth-Ageless_Era.mo ga-tmp.po

# French
mkdir -p translations/fr/LC_MESSAGES/

msgunfmt -o fr-AE.po translations/fr/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o fr-Archaic.po ../Archaic_Era/translations/fr/LC_MESSAGES/wesnoth-Archaic_Era.mo
msgunfmt -o fr-AoA.po ../Armies_of_Amberan/translations/fr/LC_MESSAGES/armies_of_amberan.mo

cp AE.pot fr-tmp.po
msgmerge -m -N -o fr-tmp.po fr-AE.po fr-tmp.po
msgmerge -m -N -o fr-tmp.po fr-Archaic.po fr-tmp.po
msgmerge -m -N -o fr-tmp.po fr-AoA.po fr-tmp.po
msgmerge -m -N -o fr-tmp.po ../Harpies/translations/wesnoth-Harpies/fr.po fr-tmp.po
msgfmt -o translations/fr/LC_MESSAGES/wesnoth-Ageless_Era.mo fr-tmp.po

# Italian
mkdir -p translations/it/LC_MESSAGES/

msgunfmt -o it-AE.po translations/it/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o it-EoMa.po ../Era_of_Magic/translations/it/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgunfmt -o it-Archaic.po ../Archaic_Era/translations/it/LC_MESSAGES/wesnoth-Archaic_Era.mo

cp AE.pot it-tmp.po
msgmerge -m -N -o it-tmp.po it-AE.po it-tmp.po
msgmerge -m -N -o it-tmp.po it-EoMa.po it-tmp.po
msgmerge -m -N -o it-tmp.po it-Archaic.po it-tmp.po

msgfmt -o translations/it/LC_MESSAGES/wesnoth-Ageless_Era.mo it-tmp.po

# Japanese
mkdir -p translations/ja/LC_MESSAGES/

msgunfmt -o ja-AE.po translations/ja/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o ja-EoMa.po ../Era_of_Magic/translations/ja/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgunfmt -o ja-Archaic.po ../Archaic_Era/translations/ja/LC_MESSAGES/wesnoth-Archaic_Era.mo

cp AE.pot ja-tmp.po
msgmerge -m -N -o ja-tmp.po ja-AE.po ja-tmp.po
msgmerge -m -N -o ja-tmp.po ja-EoMa.po ja-tmp.po
msgmerge -m -N -o ja-tmp.po ja-Archaic.po ja-tmp.po

msgfmt -o translations/ja/LC_MESSAGES/wesnoth-Ageless_Era.mo ja-tmp.po

# Hungarian
mkdir -p translations/hu/LC_MESSAGES/

msgunfmt -o hu-AE.po translations/hu/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o hu-EoMa.po ../Era_of_Magic/translations/hu/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgunfmt -o hu-Archaic.po ../Archaic_Era/translations/hu/LC_MESSAGES/wesnoth-Archaic_Era.mo

cp AE.pot hu-tmp.po
msgmerge -m -N -o hu-tmp.po hu-AE.po hu-tmp.po
msgmerge -m -N -o hu-tmp.po hu-Archaic.po hu-tmp.po
msgmerge -m -N -o hu-tmp.po hu-EoMa.po hu-tmp.po

msgfmt -o translations/hu/LC_MESSAGES/wesnoth-Ageless_Era.mo hu-tmp.po


# Spanish
mkdir -p translations/es/LC_MESSAGES/

msgunfmt -o es-AE.po translations/es/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o es-EoMa.po ../Era_of_Magic/translations/es/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgunfmt -o es-EoM.po ../Era_of_Myths/translations/es/LC_MESSAGES/wesnoth-Era_of_Myths.mo
msgunfmt -o es-Imperial.po ../Imperial_Era/translations/es/LC_MESSAGES/wesnoth-Imperial_Era.mo
msgunfmt -o es-EoC.po ../Era_of_Chaos/translations/es/LC_MESSAGES/wesnoth-Era_of_Chaos.mo

cp AE.pot es-tmp.po
msgmerge -m -N -o es-tmp.po es-AE.po es-tmp.po
msgmerge -m -N -o es-tmp.po es-EoMa.po es-tmp.po
msgmerge -m -N -o es-tmp.po es-EoM.po es-tmp.po
msgmerge -m -N -o es-tmp.po es-Imperial.po es-tmp.po
msgmerge -m -N -o es-tmp.po es-EoC.po es-tmp.po
msgmerge -m -N -o es-tmp.po ../War_of_Legends/translations/wesnoth-War_of_Legends/es.po es-tmp.po
msgfmt -o translations/es/LC_MESSAGES/wesnoth-Ageless_Era.mo es-tmp.po

# Chinese (zh_CN)

mkdir -p translations/zh_CN/LC_MESSAGES/
msgunfmt -o zh_CN-AE.po translations/zh_CN/LC_MESSAGES/wesnoth-Ageless_Era.mo
msgunfmt -o zh_CN-EoMa.po ../Era_of_Magic/translations/zh_CN/LC_MESSAGES/wesnoth-Era_of_Magic.mo

cp AE.pot zh_CN-tmp.po
msgmerge -m -N -o zh_CN-tmp.po zh_CN-AE.po zh_CN-tmp.po
msgmerge -m -N -o zh_CN-tmp.po zh_CN-EoMa.po zh_CN-tmp.po
msgfmt -o translations/zh_CN/LC_MESSAGES/wesnoth-Ageless_Era.mo zh_CN-tmp.po



# Clean
#rm -f AE.pot
mv -f AE.pot translations/
rm -f *-EoMa.po *-MiE.po *-EoM.po *-tmp.po *-Archaic.po *-AE.po *-Imperial.po *-EoC.po *-AoA.po
