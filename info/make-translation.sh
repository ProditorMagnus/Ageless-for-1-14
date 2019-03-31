#! /bin/sh

# If you run this script by »double clicking« it in the file manager…
# … if you get problems, it means that wmlxgettext wasn't found on the path.

# Era type add-ons with translations are Archaic, EoMa, EoM, MiE
# This script assumes that these ones are in the same dir like AE is.

# switch to AE base dir
cd ..

# Generate .pot
wmlxgettext --directory=. --domain=wesnoth-Ageless_Era -o AE.pot --recursive


# German:
mkdir -p translations/de/LC_MESSAGES/

msgunfmt -o de-EoM.po ../Era_of_Myths/translations/de/LC_MESSAGES/wesnoth-Era_of_Myths.mo
msgunfmt -o de-MiE.po ../Millennium_Era/translations/de/LC_MESSAGES/wesnoth-millennium-era.mo
msgunfmt -o de-EoMa.po ../Era_of_Magic/translations/de/LC_MESSAGES/wesnoth-Era_of_Magic.mo

msgmerge -m -N -o de-tmp1.po de-EoMa.po AE.pot
msgmerge -m -N -o de-tmp2.po de-MiE.po de-tmp1.po
msgmerge -m -N -o de-tmp3.po de-EoM.po de-tmp2.po

msgfmt -o translations/de/LC_MESSAGES/wesnoth-Ageless_Era.mo de-tmp3.po

# Latin
# only merging instead to copy because it leaves out unused strings (very few though)
mkdir -p translations/la/LC_MESSAGES/

msgunfmt -o la-tmp1.po ../Era_of_Myths/translations/la/LC_MESSAGES/wesnoth-Era_of_Myths.mo
msgmerge -m -N -o la-tmp2.po la-tmp1.po AE.pot
msgfmt -o translations/la/LC_MESSAGES/wesnoth-Ageless_Era.mo la-tmp2.po

# Polish
mkdir -p translations/pl/LC_MESSAGES/

msgunfmt -o pl-tmp1.po ../Era_of_Magic/translations/pl/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgmerge -m -N -o pl-tmp2.po pl-tmp1.po AE.pot
msgfmt -o translations/pl/LC_MESSAGES/wesnoth-Ageless_Era.mo pl-tmp2.po

# Russish
mkdir -p translations/ru/LC_MESSAGES/

msgunfmt -o ru-tmp1.po ../Era_of_Magic/translations/ru/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgmerge -m -N -o ru-tmp2.po ru-tmp1.po AE.pot
msgfmt -o translations/ru/LC_MESSAGES/wesnoth-Ageless_Era.mo ru-tmp2.po

# Irish
mkdir -p translations/ga/LC_MESSAGES/

msgunfmt -o ga-tmp1.po ../Era_of_Magic/translations/ga/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgmerge -m -N -o ga-tmp2.po ga-tmp1.po AE.pot
msgfmt -o translations/ga/LC_MESSAGES/wesnoth-Ageless_Era.mo ga-tmp2.po

# French
mkdir -p translations/fr/LC_MESSAGES/

msgunfmt -o fr-tmp1.po ../Archaic_Era/translations/fr/LC_MESSAGES/wesnoth-Archaic_Era.mo
msgmerge -m -N -o fr-tmp2.po fr-tmp1.po AE.pot
msgfmt -o translations/fr/LC_MESSAGES/wesnoth-Ageless_Era.mo fr-tmp2.po

# Italian
mkdir -p translations/it/LC_MESSAGES/
msgunfmt -o it-EoMa.po ../Era_of_Magic/translations/it/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgunfmt -o it-Archaic.po ../Archaic_Era/translations/it/LC_MESSAGES/wesnoth-Archaic_Era.mo

msgmerge -m -N -o it-tmp1.po it-EoMa.po AE.pot
msgmerge -m -N -o it-tmp2.po it-Archaic.po it-tmp1.po

msgfmt -o translations/it/LC_MESSAGES/wesnoth-Ageless_Era.mo it-tmp2.po

# Japanese
mkdir -p translations/ja/LC_MESSAGES/

msgunfmt -o ja-EoMa.po ../Era_of_Magic/translations/ja/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgunfmt -o ja-Archaic.po ../Archaic_Era/translations/ja/LC_MESSAGES/wesnoth-Archaic_Era.mo

msgmerge -m -N -o ja-tmp1.po ja-EoMa.po AE.pot
msgmerge -m -N -o ja-tmp2.po ja-Archaic.po ja-tmp1.po

msgfmt -o translations/ja/LC_MESSAGES/wesnoth-Ageless_Era.mo ja-tmp2.po

# Hungarian
mkdir -p translations/hu/LC_MESSAGES/

msgunfmt -o hu-EoMa.po ../Era_of_Magic/translations/hu/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgunfmt -o hu-Archaic.po ../Archaic_Era/translations/hu/LC_MESSAGES/wesnoth-Archaic_Era.mo

msgmerge -m -N -o hu-tmp1.po hu-Archaic.po AE.pot
msgmerge -m -N -o hu-tmp2.po hu-EoMa.po hu-tmp1.po

msgfmt -o translations/hu/LC_MESSAGES/wesnoth-Ageless_Era.mo hu-tmp2.po


# others from EoMa: es, ga zh_CN
mkdir -p translations/es/LC_MESSAGES/
msgunfmt -o es-EoMa.po ../Era_of_Magic/translations/es/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgmerge -m -N -o es-tmp1.po es-EoMa.po AE.pot
msgfmt -o translations/es/LC_MESSAGES/wesnoth-Ageless_Era.mo es-tmp1.po

mkdir -p translations/ga/LC_MESSAGES/
msgunfmt -o ga-EoMa.po ../Era_of_Magic/translations/ga/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgmerge -m -N -o ga-tmp1.po ga-EoMa.po AE.pot
msgfmt -o translations/ga/LC_MESSAGES/wesnoth-Ageless_Era.mo ga-tmp1.po

mkdir -p translations/zh_CN/LC_MESSAGES/
msgunfmt -o zh_CN-EoMa.po ../Era_of_Magic/translations/zh_CN/LC_MESSAGES/wesnoth-Era_of_Magic.mo
msgmerge -m -N -o zh_CN-tmp1.po zh_CN-EoMa.po AE.pot
msgfmt -o translations/zh_CN/LC_MESSAGES/wesnoth-Ageless_Era.mo zh_CN-tmp1.po



# Clean
rm -f AE.pot
rm -f de-EoMa.po de-MiE.po de-EoM.po de-tmp1.po de-tmp2.po de-tmp3.po
rm -f it-Archaic.po it-EoMa.po it-tmp1.po it-tmp2.po
rm -f ja-Archaic.po ja-EoMa.po ja-tmp1.po ja-tmp2.po
rm -f hu-Archaic.po hu-EoMa.po hu-tmp1.po hu-tmp2.po
rm -f la-tmp1.po la-tmp2.po
rm -f pl-tmp1.po pl-tmp2.po
rm -f ru-tmp1.po ru-tmp2.po
rm -f ga-tmp1.po ga-tmp2.po
rm -f fr-tmp1.po fr-tmp2.po
rm -f es-EoMa.po es-tmp1.po
rm -f ga-EoMa.po ga-tmp1.po
rm -f zh_CN-EoMa.po zh_CN-tmp1.po
