from keyvalues import KeyValues
import shutil
import sys
from collections import OrderedDict


def ability_special_to_value(filename):
    shutil.copyfile(filename, filename+".bak")
    kv = KeyValues(filename=filename)
    abilities = kv["DOTAAbilities"]
    for ability_name, ability_dict in abilities.items():
        if "AbilitySpecial" in ability_dict and not "AbilityValues" in ability_dict:
            ability_dict["AbilityValues"] = OrderedDict()
            for special_name, special_dict in ability_dict["AbilitySpecial"].items():
                for key, value in special_dict.items():
                    if key == "var_type":
                        continue
                    ability_dict["AbilityValues"][key] = value
            # print(f"AbilityValues for {ability_name}",ability_dict["AbilityValues"])
            del ability_dict["AbilitySpecial"]
    kv.write(filename)

if __name__ == "__main__":
    ability_special_to_value(sys.argv[1])