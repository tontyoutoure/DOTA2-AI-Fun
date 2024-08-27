from keyvalues import KeyValues
import shutil
import sys
from collections import OrderedDict
import os
import glob

class ability_special_to_value_converter():
    def __init__(self, filename):
        print(f"Processing {filename}")
        self.filename = filename
        with open(filename, "r") as f:
            lines = f.readlines()
            if lines[0].startswith('#base'):
                self.is_index = True
                return
            else:
                self.is_index = False
            
        if os.path.exists(filename+".bak"):
            self.kv = KeyValues(filename=filename+".bak")
        else:
            self.kv = KeyValues(filename=filename)
            shutil.copyfile(filename, filename+".bak")
        self.abilities = self.kv["DOTAAbilities"]

    def convert_all(self):
        if self.is_index:
            print("Index file, skip")
            return
        for self.ability_name, ability_dict in self.abilities.items():
            if "AbilitySpecial" in ability_dict and not "AbilityValues" in ability_dict:
                ability_dict["AbilityValues"] = OrderedDict()
                for self.special_name, special_dict in ability_dict["AbilitySpecial"].items():
                    self.special2value(special_dict, ability_dict["AbilityValues"])
                # print(f"AbilityValues for {ability_name}",ability_dict["AbilityValues"])
                del ability_dict["AbilitySpecial"]
        self.kv.write(self.filename)

    def special2value_Scepter(self, special_dict, value_dict):
        if len(special_dict) != 3:
            print(f"scepter value of {self.filename} {self.ability_name} has more than 3 keys!")
            # exit(1)

        for key, value in special_dict.items():
            if key == "var_type":
                continue
            if key != "RequiresScepter":
                value_dict[key] = OrderedDict()
                value_dict[key]["value"] = value
                this_key = key
            else:
                value_dict[this_key]["RequiresScepter"] = value

    def special2value_LinkedSpecialBonus(self, special_dict, value_dict):
        for key, value in special_dict.items():
            if key == "var_type":
                continue
            if key != "LinkedSpecialBonus" and key != "LinkedSpecialBonusOperation":
                value_dict[key] = OrderedDict()
                value_dict[key]["value"] = value
                this_key = key
            if key == "LinkedSpecialBonus":
                print(self.filename, self.ability_name, "has LinkedSpecialBonus", value)
                special_value = self.abilities[value]["AbilitySpecial"]["01"]["value"]
                if "LinkedSpecialBonusOperation" in special_dict and special_dict["LinkedSpecialBonusOperation"] == "SPECIAL_BONUS_MULTIPLY":
                    assert(int(special_value) == float(special_value))
                    special_value = str((int(special_value) - 1) * 100) + "%"
                value_dict[this_key][value] = "+" + special_value
            if key == "LinkedSpecialBonusOperation":
                continue

    def special2value(self, special_dict, value_dict):
        if self.ability_name.find("special_bonus") >= 0 and not self.ability_name.find("special_bonus_unique") >= 0:
            print(f"\t\t\t\t\t\t\t{self.ability_name[:-2]}\t\t\t{self.ability_name[:-2].replace('special_bonus_', 'special_bonus_unique_')}")
        if len(special_dict) == 2:
            for key, value in special_dict.items():
                if key == "var_type":
                    continue
                value_dict[key] = value
        elif "RequiresScepter" in special_dict:
            self.special2value_Scepter(special_dict, value_dict)
        elif "LinkedSpecialBonus" in special_dict:
            self.special2value_LinkedSpecialBonus(special_dict, value_dict)
        else:
            print(self.filename, self.ability_name, "has something else")
            exit(1)



if __name__ == "__main__":
    file_list = glob.glob(sys.argv[1] + "/*.txt")
    for file in file_list:
        converter = ability_special_to_value_converter(file)
        converter.convert_all()