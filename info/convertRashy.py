#!/usr/bin/env python3
import os
from collections import defaultdict
from collectRashyUnitIdReplacements import get_unit_type_mapping

replacements = [
	('{~add-ons/Rashy_Era/','{~ERROR_RE_ABSOLUTE_PATH/'),

	("VRAq Warrior_Swordman", "AE_rhy_aq_Warrior_Swordsman"),
	(",VRAq Warrior,", ",AE_rhy_aq_Warrior_Swordsman,"),
	("units/undead/ghost", "units/{GHOST_IMAGE_FOLDER}/ghost"),
	("units/undead/nightgaunt", "units/{GHOST_IMAGE_FOLDER}/nightgaunt"),
	("units/undead/shadow", "units/{GHOST_IMAGE_FOLDER}/shadow"),
	("units/undead/spectre", "units/{GHOST_IMAGE_FOLDER}/spectre"),
	("units/undead/wraith", "units/{GHOST_IMAGE_FOLDER}/wraith"),
	("units/undead-spirit/ghost", "units/{GHOST_IMAGE_FOLDER}/ghost"),
	("units/undead-spirit/nightgaunt", "units/{GHOST_IMAGE_FOLDER}/nightgaunt"),
	("units/undead-spirit/shadow", "units/{GHOST_IMAGE_FOLDER}/shadow"),
	("units/undead-spirit/spectre", "units/{GHOST_IMAGE_FOLDER}/spectre"),
	("units/undead-spirit/wraith", "units/{GHOST_IMAGE_FOLDER}/wraith"),
	("VR_", "AE_RHY_"),
	("vr-", "AE_rhy_"),

	("""
    description= _ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
	description= _ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
    description=_ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
	description=_ ""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
    description=_""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
	description=_""","""
    description={AE_RHY_UNIT_NOTICE}+ _ """),
	("""
    description={NO_DESCR_AVAILABLE}""","""
    description={AE_RHY_UNIT_NOTICE}+{NO_DESCR_AVAILABLE}"""),
	("__DUMMY__","__DUMMY__")
]

unit_type_mapping = get_unit_type_mapping()
for k in sorted(unit_type_mapping, key=lambda x: -len(x)):
	replacements.append((k, unit_type_mapping[k]))



def getAgelessPath(dname, fname):
	if "factions" in dname:
		return os.path.join(".","Ageless_Era","factions","RE",fname)
	if "units" in dname:
		basename = os.path.basename(dname)
		if basename == "units":
			basename = ""
		return os.path.join(".","Ageless_Era","units","RE_units",basename,fname)
	if "macros" in dname:
		return os.path.join(".","Ageless_Era","data","RE_data",fname)
	raise Exception("Unhandled folder {}".format(dname))

eras = defaultdict(str)
for dname, dirs, files in os.walk("."):
	if "factions" not in dname and "units" not in dname and "macros" not in dname:
		continue
	if "Ageless_Era" in dname or "images" in dname:
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
			s = s.replace("{AE_RHY_UNIT_NOTICE}+", "")
			s = s.replace('name= _"', 'name= "RE - " + _"')
			s = s.replace('name=_"', 'name= "RE - " + _"')
			if "default" in fname:
				eras["default"] += s
				eras["default"] += "\n"
			elif "aoh" in fname:
				eras["heroes"] += s
				eras["heroes"] += "\n"
			elif "mrpg" in fname:
				eras["RPG"] += s
				eras["RPG"] += "\n"
			# TODO no rpg era
		else:
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)

if eras["RPG"] == "":
	rpg_era = ""
	for line in eras["default"].split("\n"):
		if "type=" in line or "leader=" in line or "ai]" in line or "recruitment_pattern=" in line:
			continue
		line = line.replace("recruit=","leader=")
		rpg_era += line + "\n"
	eras["RPG"] = rpg_era

with open("Ageless_Era/units/RE_units/units.cfg", "a", encoding="utf8") as f:
	f.write("""

{GET_AE_UNITS RE_units/aquana}
{GET_AE_UNITS RE_units/dwarves}
{GET_AE_UNITS RE_units/elves-dark}
{GET_AE_UNITS RE_units/elyser}
{GET_AE_UNITS RE_units/gnomes}
{GET_AE_UNITS RE_units/human-chevalier}
{GET_AE_UNITS RE_units/human-dardo}
{GET_AE_UNITS RE_units/human-forest}
{GET_AE_UNITS RE_units/human-luz}
{GET_AE_UNITS RE_units/human-mountain}
{GET_AE_UNITS RE_units/human-regis}
{GET_AE_UNITS RE_units/marashy}
{GET_AE_UNITS RE_units/ships}
{GET_AE_UNITS RE_units/trarashy}
{GET_AE_UNITS RE_units/undead}
{GET_AE_UNITS RE_units/vixens}
""")

# factions to file
for era in eras:
	os.makedirs(os.path.dirname("Ageless_Era/factions/{}/".format(era)), exist_ok=True)
	with open("Ageless_Era/factions/{}/{}-RE.cfg".format(era, era), "w", encoding="utf8") as f:
		f.write(eras[era])
