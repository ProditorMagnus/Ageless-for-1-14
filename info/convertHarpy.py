#!/usr/bin/env python3
import os
from collections import defaultdict
from collectHarpyUnitIdReplacements import get_unit_type_mapping

replacements = [

	('{ABILITY_HEAL_12}','{ABILITY_AE_MAG_HEAL 12}'),
	('name= _"Harpies"','name= "AE - " + _ "Harpies"'),
	("id=Harpies","id=AE_side_agl_Harpies"),
	("id=harpy","id=AE_agl_harpy"),
	("race=harpy","race=AE_agl_harpy"),
	("movement_type=harpy","movement_type=AE_agl_harpy"),
	("name=harpy","name=AE_agl_harpy"),

	("""
    description= _ ""","""
    description={AE_HARPY_UNIT_NOTICE}+ _ """),
	("""
    description=_ ""","""
    description={AE_HARPY_UNIT_NOTICE}+ _ """),
	("""
    description=_""","""
    description={AE_HARPY_UNIT_NOTICE}+ _ """),
	
	("__DUMMY__","__DUMMY__")
]

unit_type_mapping, unit_file_mapping, unit_name_mapping = get_unit_type_mapping("./units")
for k in sorted(unit_type_mapping, key=lambda x: -len(x)):
	replacements.append((k, unit_type_mapping[k]))

replacements.append(('name= _ "AE_agl_harpies_Harpy_', 'name= _ "Harpy '))
replacements.append(('name= _ "AE_agl_harpies_Night_', 'name= _ "Night '))
replacements.append(('name= _ "AE_agl_harpies_Resplendent_', 'name= _ "Resplendent '))
replacements.append(('name= _ "AE_agl_harpies_', 'name= _ "'))


def getAgelessPath(dname, fname):
	if "faction" in dname:
		return os.path.join(".","Ageless_Era","factions","Harpy",fname)
	if "units" in dname:
		basename = os.path.basename(dname)
		if basename == "units":
			basename = ""
		return os.path.join(".","Ageless_Era","units","misc_units","harpies",fname)
	if "data" in dname:
		return os.path.join(".","Ageless_Era","data","harpy_data",fname)
	raise Exception("Unhandled folder {}".format(dname))

eras = defaultdict(str)
for dname, dirs, files in os.walk("."):
	if "faction" not in dname and "units" not in dname and "data" not in dname:
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
		if "faction" in dname:
			s = s.replace('name=_"', 'name= _ "AE - ')
			if "aoh" in fname:
				eras["heroes"] += s
				eras["heroes"] += "\n"
			elif "RPG" in fname:
				eras["RPG"] += s
				eras["RPG"] += "\n"
			else:
				eras["default"] += s
				eras["default"] += "\n"
		else:
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)
				print("updated",afpath)

if "RPG" not in eras:
	eras["RPG"] = """
#textdomain wesnoth-Harpies
[multiplayer_side]
    id=AE_side_agl_Harpies
    name= "AE - " + _ "Harpies"
    image="captivator/harpy-captivator.png"

    leader={HARPIES_ERA_RECRUIT_LIST}
    terrain_liked=Mm
[/multiplayer_side]
"""

# factions to file
for era in eras:
	os.makedirs("Ageless_Era/factions/{}/fragment-AE".format(era, era), exist_ok=True)
	with open("Ageless_Era/factions/{}/fragment-AE/harpies.cfg".format(era, era), "w", encoding="utf8") as f:
		f.write(eras[era])
