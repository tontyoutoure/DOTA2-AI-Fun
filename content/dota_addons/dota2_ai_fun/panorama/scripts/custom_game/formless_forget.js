"use strict";

function ForgetUnus() {
    var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
    if (Entities.GetUnitName(hero) == "npc_dota_hero_wisp") {
        GameEvents.SendCustomGameEventToServer("formless_forget", {
            "skillname_to_forget": "formless_unus",
            "skill_index" : "0"
        });
    }
}

function ForgetDuos() {
    var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
    if (Entities.GetUnitName(hero) == "npc_dota_hero_wisp") {
        GameEvents.SendCustomGameEventToServer("formless_forget", {
            "skillname_to_forget": "formless_duos",
            "skill_index": "1"
        });
    }
}

function ForgetTertius() {
    var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
    if (Entities.GetUnitName(hero) == "npc_dota_hero_wisp") {
        GameEvents.SendCustomGameEventToServer("formless_forget", {
            "skillname_to_forget": "formless_tertius",
            "skill_index": "2"
        });
    }
}

function ForgetDenique() {
    var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
    if (Entities.GetUnitName(hero) == "npc_dota_hero_wisp") {
        GameEvents.SendCustomGameEventToServer("formless_forget", {
            "skillname_to_forget": "formless_denique",
            "skill_index": "3"
        });
    }
}

Game.AddCommand("KeyClickV", ForgetUnus, "", 0);
Game.AddCommand("KeyClickB", ForgetDuos, "", 0);
Game.AddCommand("KeyClickN", ForgetTertius, "", 0);
Game.AddCommand("KeyClickM", ForgetDenique, "", 0);