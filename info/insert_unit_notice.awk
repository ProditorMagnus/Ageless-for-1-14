#!/usr/bin/env awk -f

# helper script for eom2ageless.sh

BEGIN {
   in_unit_type = 0;
   in_attack = 0;
}

/\[unit_type\]/ {
   in_unit_type++;
}

/\[\/unit_type\]/ {
        in_unit_type--;
}

/\[attack\]/ {
        in_attack++;
}

/\[\/attack\]/ {
        in_attack--;
}

/[[:blank:]]description.?=/ {
   if (in_unit_type && (!in_attack)) {
      sub("description=" , "description= {AE_EOM_UNIT_NOTICE} + ");
   }
}

{ print }
