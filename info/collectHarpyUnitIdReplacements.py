#!/usr/bin/env python3
import os
from collections import defaultdict


def get_unit_type_mapping(source="."):
	unit_name_mapping = {}
	unit_type_mapping = {}
	unit_file_mapping = {}
	for dname, dirs, files in os.walk(source):
		if "units" not in dname:
			continue
		if "Ageless_Era" in dname or "images" in dname:
			continue

		for fname in files:
			fpath = os.path.join(dname, fname)

			with open(fpath,encoding="utf8") as f:
				unit_type = False
				unit_type_name = None
				old_type = None
				for line in f:
					if unit_type:
						if "id=" in line:
							old_type = line.split("=")[1].strip()
							if "^" in old_type:
								raise Exception("TODO")
						elif "name=" in line:
							unit_type_name = line.split("=")[1].replace('"',"").replace("_","").strip()
						else:
							raise Exception("Expected id after [unit_type]. " + line + dname + "/" + fname)
						if old_type is not None and unit_type_name is not None:
							faction = "harpies"

							visible_name = unit_type_name.title()
							new_name = visible_name.replace(" ", "_").replace("-","_").replace("ü","u").replace("ö","o")
							new_type = "AE_agl_"+faction+"_" + new_name
							unit_type_mapping[old_type] = new_type
							unit_name_mapping[old_type] = unit_type_name+"¤"+visible_name
							unit_file_mapping[fname] = new_name+".cfg"
							break


					if "[unit_type]" in line:
						unit_type=True
	#print(unit_type_mapping, unit_file_mapping, unit_name_mapping)
	#print(unit_name_mapping)
	return [unit_type_mapping, unit_file_mapping, unit_name_mapping]

# TODO renaming may overwrite existing files
if __name__ == "__main__":
	print(get_unit_type_mapping(source="../units/misc_units/harpies"))
