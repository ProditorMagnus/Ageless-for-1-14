#!/usr/bin/env python3
import os
from collections import defaultdict
from collectForgottenLegendsUnitIdReplacements import get_unit_type_mapping

replacements = [
	("{WEAPON_SPECIAL_ATTACKONLY}","{WEAPON_SPECIAL_ATTACK_ONLY}"),
	("{WEAPON_SPECIAL_NOCOUNTERATTACK}","{WEAPON_SPECIAL_AE_MAG_NOCOUNTERATTACK}"),
	("{WEAPON_SPECIAL_AE_FGTN_BERSERK}","{WEAPON_SPECIAL_RAGE_5}"),
	("{ABILITY_FURY}","{ABILITY_AE_MAG_FURY}"),
	("{WEAPON_SPECIAL_MISTIC}","{WEAPON_SPECIAL_AE_UBIQUITOUS}"),
	("{WEAPON_SPECIAL_PRECISION}","{WEAPON_SPECIAL_AE_MAG_PRECISION}"),
	("{ABILITY_REGENERATES+4}","{ABILITY_AE_MAG_REGENERATE 4}"),
	("{ABILITY_REGENERATES+6}","{ABILITY_AE_MAG_REGENERATE 6}"),
	("{WEAPON_SPECIAL_ALWAYS_HIT}","{WEAPON_SPECIAL_AE_MAG_ALWAYSHITS}"),
	("{ABILITY_MA}","{ABILITY_AE_MAG_MOUNTAINAMBUSH}"),
	("{WEAPON_SPECIAL_GOODEYE","{AE_FL_WEAPON_SPECIAL_GOODEYE"),
	("{ABILITY_BROTHER","{AE_FL_ABILITY_BROTHER"),
	("{ABILITY_STEELSKIN","{AE_FL_ABILITY_STEELSKIN"),
	("{ABILITY_DEFENDER","{AE_FL_ABILITY_DEFENDER"),
	("{ABILITY_LEADERSHIP_MONSTERS_2","{AE_FL_ABILITY_LEADERSHIP_MONSTERS_2"),
	("{ABILITY_LEADERSHIP_MONSTERS_3","{AE_FL_ABILITY_LEADERSHIP_MONSTERS_3"),
	("{ABILITY_MASTERHEAL","{ABILITY_AE_MAG_HEAL 10"),
	("{ABILITY_ULTIMATEHEAL","{ABILITY_AE_MAG_HEAL 12"),
	("{ABILITY_SHADOWAURA","{AE_FL_ABILITY_SHADOWAURA"),
	("{ABILITY_AURA_OF_LIFE","{AE_FL_ABILITY_AURA_OF_LIFE"),
	("{WEAPON_SPECIAL_EAGLE_EYE","{AE_FL_WEAPON_SPECIAL_EAGLE_EYE"),
	("{ABILITY_SUMMON_GOLEM","{AE_FL_ABILITY_SUMMON_GOLEM"),
	("{SUMMON_GOLEM_MENU","{AE_FL_SUMMON_GOLEM_MENU"),
	("{ABILITY_SUMMON_REPLICATE0","{AE_FL_ABILITY_SUMMON_REPLICATE0"),
	("{SUMMON_REPLICATE0_MENU","{AE_FL_SUMMON_REPLICATE0_MENU"),
	("{ABILITY_SUMMON_REPLICATE","{AE_FL_ABILITY_SUMMON_REPLICATE"),
	("{SUMMON_REPLICATE_MENU","{AE_FL_SUMMON_REPLICATE_MENU"),
	("{ABILITY_SUMMON_REPLICATE2","{AE_FL_ABILITY_SUMMON_REPLICATE2"),
	("{SUMMON_REPLICATE2_MENU","{AE_FL_SUMMON_REPLICATE2_MENU"),
	("__DUMMY__","__DUMMY__")
]

for k,v in replacements:
	if k[0] == "{" and v[0] == "{" and " " not in k+v:
		if k[-1] == "}" and v[-1] == "}":
			replacements.append(("#define "+k[1:-1], "#define "+v[1:-1]))
		else:
			replacements.append(("#define "+k[1:], "#define "+v[1:]))

unit_type_mapping = get_unit_type_mapping("../units/FL_units")
for k in unit_type_mapping:
	replacements.append((k, unit_type_mapping[k]))

eras = defaultdict(str)
for dname, dirs, files in os.walk(".."):
	if "FL_units" not in dname and "FL_data" not in dname and "factions" not in dname:
		continue
	print(dname)
	for fname in files:
		fpath = os.path.join(dname, fname)
		afpath = fpath
		# print(fpath, afpath)
		with open(fpath,encoding="utf8") as f:
			s = f.read()
		for (find, replace) in replacements:
			s = s.replace(find, replace)
		else:
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)

