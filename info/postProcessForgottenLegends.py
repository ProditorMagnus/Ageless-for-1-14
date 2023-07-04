#!/usr/bin/env python3
import os
from collections import defaultdict
from collectForgottenLegendsUnitIdReplacements import get_unit_type_mapping

replacements = [
	("__DUMMY__","__DUMMY__")
]

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

