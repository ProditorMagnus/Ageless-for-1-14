#!/usr/bin/env python3
import os
from collections import defaultdict
from collectHarpyUnitIdReplacements import get_unit_type_mapping

replacements = [

	('{ABILITY_HEAL_12}','{ABILITY_AE_MAG_HEAL 12}'),
	('name= _"Harpies"','name= "AE - " + _ "Harpies"'),
	("id=Harpies","id=AE_side_agl_Harpies"),
	("id=harpy","id=AE_agl_harpy"),
	("ability=harpy","ability=AE_agl_harpy"),
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
	
	(' description=_"axe"',' description={STR_AXE}'),
	(' description=_"ballista"',' description={STR_BALLISTA}'),
	(' description=_"battle axe"',' description={STR_BATTLE_AXE}'),
	(' description=_"beak"',' description={STR_BEAK}'),
	(' description=_"bite"',' description={STR_BITE}'),
	(' description=_"bolas"',' description={STR_BOLAS}'),
	(' description=_"bow"',' description={STR_BOW}'),
	(' description=_"chill tempest"',' description={STR_CHILL_TEMPEST}'),
	(' description=_"chill wave"',' description={STR_CHILL_WAVE}'),
	(' description=_"claws"',' description={STR_CLAWS}'),
	(' description=_"cleaver"',' description={STR_CLEAVER}'),
	(' description=_"club"',' description={STR_CLUB}'),
	(' description=_"crossbow"',' description={STR_CROSSBOW}'),
	(' description=_"crush"',' description={STR_CRUSH}'),
	(' description=_"curse"',' description={STR_CURSE}'),
	(' description=_"dagger"',' description={STR_DAGGER}'),
	(' description=_"ensnare"',' description={STR_ENSNARE}'),
	(' description=_"entangle"',' description={STR_ENTANGLE}'),
	(' description=_"faerie fire"',' description={STR_FAERIE_FIRE}'),
	(' description=_"fangs"',' description={STR_FANGS}'),
	(' description=_"fireball"',' description={STR_FIREBALL}'),
	(' description=_"fist"',' description={STR_FIST}'),
	(' description=_"flail"',' description={STR_FLAIL}'),
	(' description=_"greatsword"',' description={STR_GREATSWORD}'),
	(' description=_"halberd"',' description={STR_HALBERD}'),
	(' description=_"hammer"',' description={STR_HAMMER}'),
	(' description=_"hatchet"',' description={STR_HATCHET}'),
	(' description=_"javelin"',' description={STR_JAVELIN}'),
	(' description=_"knife"',' description={STR_KNIFE}'),
	(' description=_"lance"',' description={STR_LANCE}'),
	(' description=_"lightbeam"',' description={STR_LIGHTBEAM}'),
	(' description=_"lightning"',' description={STR_LIGHTNING}'),
	(' description=_"longbow"',' description={STR_LONGBOW}'),
	(' description=_"longsword"',' description={STR_LONGSWORD}'),
	(' description=_"mace"',' description={STR_MACE}'),
	(' description=_"missile"',' description={STR_MISSILE}'),
	(' description=_"mud glob"',' description={STR_MUD_GLOB}'),
	(' description=_"net"',' description={STR_NET}'),
	(' description=_"pike"',' description={STR_PIKE}'),
	(' description=_"pitchfork"',' description={STR_PITCHFORK}'),
	(' description=_"plague staff"',' description={STR_PLAGUE_STAFF}'),
	(' description=_"ram"',' description={STR_RAM}'),
	(' description=_"saber"',' description={STR_SABER}'),
	(' description=_"scepter"',' description={STR_SCEPTER}'),
	(' description=_"scythe"',' description={STR_SCYTHE}'),
	(' description=_"shadow bolt"',' description={STR_SHADOW_BOLT}'),
	(' description=_"shadow wave"',' description={STR_SHADOW_WAVE}'),
	(' description=_"shield bash"',' description={STR_SHIELD_BASH}'),
	(' description=_"short sword"',' description={STR_SHORT_SWORD}'),
	(' description=_"sling"',' description={STR_SLING}'),
	(' description=_"spear"',' description={STR_SPEAR}'),
	(' description=_"staff"',' description={STR_STAFF}'),
	(' description=_"sword"',' description={STR_SWORD}'),
	(' description=_"tail"',' description={STR_TAIL}'),
	(' description=_"thorns"',' description={STR_THORNS}'),
	(' description=_"throwing knives"',' description={STR_THROWING_KNIVES}'),
	(' description=_"torch"',' description={STR_TORCH}'),
	(' description=_"touch"',' description={STR_TOUCH}'),
	(' description=_"trample"',' description={STR_TRAMPLE}'),
	(' description=_"trident"',' description={STR_TRIDENT}'),
	(' description=_"wail"',' description={STR_WAIL}'),
	(' description=_"water spray"',' description={STR_WATER_SPRAY}'),
	(' description=_"web"',' description={STR_WEB}'),
	
	("__DUMMY__","__DUMMY__")
]

unit_type_mapping, unit_file_mapping, unit_name_mapping = get_unit_type_mapping("./units")
for k in sorted(unit_type_mapping, key=lambda x: -len(x)):
	replacements.append((k, unit_type_mapping[k]))

replacements.append(('name= _ "AE_agl_harpies_Harpy_', 'name= _ "Harpy '))
replacements.append(('name= _ "AE_agl_harpies_Night_', 'name= _ "Night '))
replacements.append(('name= _ "AE_agl_harpies_Resplendent_', 'name= _ "Resplendent '))
replacements.append(('name= _ "AE_agl_harpies_', 'name= _ "'))
replacements.append(('name= _ "male^AE_agl_harpies_Harpy_', 'name= _ "Harpy '))
replacements.append(('name= _ "male^AE_agl_harpies_Night_', 'name= _ "Night '))
replacements.append(('name= _ "male^AE_agl_harpies_Resplendent_', 'name= _ "Resplendent '))
replacements.append(('name= _ "male^AE_agl_harpies_', 'name= _ "'))


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
			elif "-aol" in fname:
				pass
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
