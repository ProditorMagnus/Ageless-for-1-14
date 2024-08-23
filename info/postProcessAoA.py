#!/usr/bin/env python3
import os
from collections import defaultdict
from collectAoAUnitIdReplacements import get_unit_type_mapping

folder_to_faction = {
	"empire": "finn_empire",
	"far_nains": "farengarian_dwarves_counties",
	"farengar": "farengarians_kingdoms",
	"federation": "mauve_islands_federation",
	"galianos": "galianos",
	"gobmon": "mountain_goblins",
	"mork-darf": "morkenost_darfenlend",
	"nord": "norse_jarldoms",
	"rov_elf": "rovahrian_elves",
	"rovahr": "kingdoms_rovahr"
}

replacements = [
	("__DUMMY__","__DUMMY__")
]

for k,v in replacements:
	if k[0] == "{" and v[0] == "{" and " " not in k+v:
		if k[-1] == "}" and v[-1] == "}":
			replacements.append(("#define "+k[1:-1], "#define "+v[1:-1]))
		else:
			replacements.append(("#define "+k[1:], "#define "+v[1:]))

unit_type_mapping, unit_file_mapping, unit_name_mapping = get_unit_type_mapping("../units/AoA_units")
for k in sorted(unit_type_mapping, key=lambda x: -len(x)):
	replacements.append((k, unit_type_mapping[k]))

eras = defaultdict(str)
for dname, dirs, files in os.walk(".."):
	if "AoA_units" not in dname and "AoA_data" not in dname and "factions" not in dname:
		continue
	directory_name = dname.split("\\")[-1]
	print(dname, directory_name)
	for fname in files:
		fpath = os.path.join(dname, fname)
		afpath = fpath
		if directory_name in folder_to_faction:
			afpath = afpath.replace(directory_name, folder_to_faction[directory_name])
		# print(fpath, afpath)
		with open(fpath,encoding="utf8") as f:
			s = f.read()
		for (find, replace) in replacements:
			if find in s:
				s = s.replace(find, replace)
				old_name, new_name = unit_name_mapping[find].split("¤")
				s = s.replace(old_name, new_name)

		else:
			if fname in unit_file_mapping:
				afpath = afpath.replace(fname, unit_file_mapping[fname])
				os.remove(fpath)
			os.makedirs(os.path.dirname(afpath), exist_ok=True)
			with open(afpath, "w", encoding="utf8") as f:
				f.write(s)
