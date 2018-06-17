import os
from collections import defaultdict

replacements = [
	('{~add-ons/Era_of_Magic/units/hide_help.cfg}',''),
	('{~add-ons/Era_of_Magic/','{~ERROR_EOMA_ABSOLUTE_PATH/'),
	('Jinni','Jinn'),
	
	('barbarians_rpg','barbarians'),
	('darkblood_rpg','darkblood'),
	('destroyers_rpg','destroyers'), # this one is not destroyers_rpg though
	('kharos_rpg','kharos'),
	('runemasters_rpg','runemasters'),
	('tharis_rpg','tharis'),
	('skykingdom_rpg','skykingdom'),
	('alkamija_rpg','summoners'),
	('barbarians_aoh','barbarians'),
	('darkblood_aoh','darkblood'),
	('destroyers_aoh','destroyers'),
	('kharos_aoh','kharos'),
	('runemasters_aoh','runemasters'),
	('tharis_aoh','tharis'),
	('skykingdom_aoh','skykingdom'),
	('summoners_aoh','summoners'),

	("{MAGENTA_IS_THE_TEAM_COLOR}",""),
	('#textdomain wesnoth-Era_of_Magic','#textdomain wesnoth-Ageless_Era'),
	('_"gaze"','{STR_GAZE}'),
	('_"bolas"','{STR_BOLAS}'),
	('_"tail"','{STR_TAIL}'),
	('_"magic"','{STR_MAGIC}'),
	('_"trample"','{STR_TRAMPLE}'),
	('_"smash"','{STR_SMASH}'),
	('_"lightning"','{STR_LIGHTNING}'),
	('_"fire breath"','{STR_FIRE_BREATH}'),
	(' _ "flame blast"','{STR_FLAME_BLAST}'),

	("EoMa_","AE_mag_"),
	("eoma_","AE_mag_"),
	("eomaprecision","AE_mag_id_precision"),
	("TLU_","AE_mag_"),
	("i8 ","AE_mag_"),
	("i8","AE_mag_"),
	("I8 ","AE_MAG_"),
	("I8","AE_MAG_"),
	("EOMA","AE_MAG"),
	("race=tharis","race=AE_mag_tharis"),
	(" id=tharis"," id=AE_mag_tharis"),
	("race=roc","race=AE_mag_roc"),
	(" id=roc"," id=AE_mag_roc"),
	("race=summoner","race=AE_mag_summoner"),
	(" id=summoner"," id=AE_mag_summoner"),
	("race=salamander","race=AE_mag_salamander"),
	(" id=salamander"," id=AE_mag_salamander"),
	("race=cyclops","race=AE_mag_cyclops"),
	(" id=cyclops"," id=AE_mag_cyclops"), # must not match variation_id

	("""
    description= _ ""","""
    description={AE_EOMA_UNIT_NOTICE}+ _ """),
	("""
    description=_ ""","""
    description={AE_EOMA_UNIT_NOTICE}+ _ """),
	("""
    description=_""","""
    description={AE_EOMA_UNIT_NOTICE}+ _ """),
	("""
    description={NO_DESCR_AVAILABLE}""","""
    description={AE_EOMA_UNIT_NOTICE}+{NO_DESCR_AVAILABLE}"""),
	("__DUMMY__","__DUMMY__")
]

def getAgelessPath(dname, fname):
	if "factions" in dname:
		return os.path.join(".","Ageless_Era","factions","EoMa",fname)
	if "units" in dname:
		basename = os.path.basename(dname)
		if basename == "units":
			basename = ""
		return os.path.join(".","Ageless_Era","units","EoMa_units",basename,fname)
	if "utils" in dname:
		return os.path.join(".","Ageless_Era","data","EoMa_data",fname)
	raise Exception("Unhandled folder {}".format(dname))

eras = defaultdict(str)
for dname, dirs, files in os.walk("."):
	if "factions" not in dname and "units" not in dname and "utils" not in dname:
		continue
	if "Ageless_Era" in dname:
		continue
	print(dname)
	for fname in files:
		fpath = os.path.join(dname, fname)
		afpath = getAgelessPath(dname, fname)
		# print(fpath, afpath)
		with open(fpath,encoding="utf8") as f:
			s = f.read()
		for (find, replace) in replacements:
			s = s.replace(find, replace)
		if "factions" in dname:
			s = s.replace(', _', ', "EoMa - " + _')
			if "default" in fname:
				eras["default"] += s
				eras["default"] += "\n"
			elif "aoh" in fname:
				eras["heroes"] += s
				eras["heroes"] += "\n"
			elif "mrpg" in fname:
				eras["RPG"] += s
				eras["RPG"] += "\n"
		else:
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)

with open("Ageless_Era/units/EoMa_units/units.cfg", "a", encoding="utf8") as f:
	f.write("""

{GET_AE_UNITS EoMa_units/Barbarians}
{GET_AE_UNITS EoMa_units/Dark_Blood_Alliance}
{GET_AE_UNITS EoMa_units/Destroyers}
{GET_AE_UNITS EoMa_units/Kharos}
{GET_AE_UNITS EoMa_units/Runemasters}
{GET_AE_UNITS EoMa_units/Sky_Kingdom}
{GET_AE_UNITS EoMa_units/Summoners}
{GET_AE_UNITS EoMa_units/Tharis}
""")

# factions to file
for era in eras:
	os.makedirs(os.path.dirname("Ageless_Era/factions/{}/".format(era)), exist_ok=True)
	with open("Ageless_Era/factions/{}/{}-EoMa.cfg".format(era, era), "w", encoding="utf8") as f:
		f.write(eras[era])
