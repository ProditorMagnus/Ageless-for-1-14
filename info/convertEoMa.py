#!/usr/bin/env python3
import os
from collections import defaultdict

replacements = [
	('{~add-ons/Era_of_Magic/units/hide_help.cfg}',''),
	('{~add-ons/Era_of_Magic/','{~ERROR_EOMA_ABSOLUTE_PATH/'),
	('Jinni','Jinn'),

	('{EOMA_AMLA_DEFAULT_CONDITIONAL', """{AMLA_DEFAULT}
    {EOMA_AMLA_DEFAULT_CONDITIONAL"""),

	('barbarians_rpg','barbarians'),
	('darkblood_rpg','darkblood'),
	('destroyers_rpg','destroyers'),
	('kharos_rpg','kharos'),
	('runemasters_rpg','runemasters'),
	('tharis_rpg','tharis'),
	('skykingdom_rpg','skykingdom'),
	('summoners_rpg','summoners'),
	('barbarians_aoh','barbarians'),
	('darkblood_aoh','darkblood'),
	('destroyers_aoh','destroyers'),
	('kharos_aoh','kharos'),
	('runemasters_aoh','runemasters'),
	('tharis_aoh','tharis'),
	('skykingdom_aoh','skykingdom'),
	('summoners_aoh','summoners'),

	# keep EoMa translations if they are installed
	#('#textdomain wesnoth-Era_of_Magic','#textdomain wesnoth-Ageless_Era'),
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
	("AE_mag_not_rpg","AE_not_rpg"),
	("__DUMMY__","__DUMMY__")
]

def parseChangesRequired(path):
	changesRequired = []
	with open(path) as f:
		attackOpen = False
		attackName = None
		for line in f:
			line = line.strip()
			if attackOpen:
				if line.startswith("name="):
					attackName = line.split("=")[1]
				if line.startswith("damage="):
					changesRequired.append(("attackDamage¤" + attackName, line.split("=")[1]))
				if line.startswith("number="):
					changesRequired.append(("attackNumber¤" + attackName, line.split("=")[1]))
				elif line.startswith("[/attack]"):
					attackOpen = False
					attackName = None
			else:
				if line.startswith("hitpoints="):
					changesRequired.append(("hitpoints", line.split("=")[1]))
				elif line.startswith("experience="):
					changesRequired.append(("experience", line.split("=")[1]))
				elif line.startswith("cost="):
					changesRequired.append(("cost", line.split("=")[1]))
				elif line.startswith("[attack]"):
					attackOpen = True
	if changesRequired != []:
		print("changes", changesRequired)
	return changesRequired

def patchUnits(s):
	output = []
	if "[unit_type]" in s:
		path = []
		changesRequired = []
		# todo try warn when change is left unused
		attackName = None
		for origLine in s.split("\n"):
			output.append(origLine)
			line: str = origLine.strip()
			if line.startswith("[/") and "]" in line:
				path.pop()
			if line.startswith("[") and "]" in line and "[/" not in line:
				path.append(line[1:line.find("]")])
			if path == ["unit_type"]:
				if line.startswith("id="):
					id = line.strip("id=")
					if os.path.exists(os.path.join("..","Ageless_Era","info","eomaPatch", "units",id+".cfg")):
						changesRequired = parseChangesRequired(os.path.join("..","Ageless_Era","info","eomaPatch", "units",id+".cfg"))
					else:
						return s
				elif line.startswith("hitpoints="):
					for change in changesRequired:
						if change[0] == "hitpoints":
							output[-1] = "    hitpoints=" + change[1]
				elif line.startswith("experience="):
					for change in changesRequired:
						if change[0] == "experience":
							output[-1] = "    experience=" + change[1]
				elif line.startswith("cost="):
					for change in changesRequired:
						if change[0] == "cost":
							output[-1] = "    cost=" + change[1]
			elif path == ["unit_type", "attack"]:
				if changesRequired == []:
					return s
				if line.startswith("name="):
					attackName = line.split("=")[1]
				elif line.startswith("damage="):
					for change in changesRequired:
						if change[0] == ("attackDamage¤" + attackName):
							output[-1] = "        damage=" + change[1]
				elif line.startswith("number="):
					for change in changesRequired:
						if change[0] == ("attackNumber¤" + attackName):
							output[-1] = "        number=" + change[1]
			else:
				continue
		return "\n".join(output)
	return s

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
			elif "mrpg" in fname and "mrpg2" not in fname:
				eras["RPG"] += s
				eras["RPG"] += "\n"
		else:
			s = patchUnits(s)
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
