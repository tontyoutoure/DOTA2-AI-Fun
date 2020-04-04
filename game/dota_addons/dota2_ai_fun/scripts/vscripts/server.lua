

-- One should change version when delete or change options!
-- All numbers should be multiplied by 100 before hand!
local version = '1'

CustomGameEventManager:RegisterListener("load_game_options", function (eventSourceIndex, args) return GameMode:OnDownloadGameOptions(eventSourceIndex, args) end)
CustomGameEventManager:RegisterListener("save_game_options", function (eventSourceIndex, args) return GameMode:OnUploadGameOptions(eventSourceIndex, args) end)

local tGameOptionLists = {'radiant_gold_multiplier','dire_gold_multiplier','radiant_xp_multiplier','dire_xp_multiplier','radiant_player_number','dire_player_number','respawn_time_percentage','buyback_cooldown','tower_power','tower_endure','max_level','imbalanced_economizer','bot_has_fun_item','universal_shop','fast_courier','bot_protection','anti_diving','enable_lottery'}

function GameMode:OnUploadGameOptions(eventSourceIndex, args)
	local req=CreateHTTPRequestScriptVM('GET', 'http://167.99.164.76:8000/d2aifun_configs/')
	req:SetHTTPRequestGetOrPostParameter('steamid', args.steamid)
	req:SetHTTPRequestGetOrPostParameter('api_key', GetDedicatedServerKeyV2(version))
	req:SetHTTPRequestGetOrPostParameter('version', version)
	req:SetHTTPRequestGetOrPostParameter('get_or_put', 'put')
	for i, v in ipairs(tGameOptionLists) do
		req:SetHTTPRequestGetOrPostParameter('data_'..tostring(i), tostring(GameMode.tGameOption[tGameOptionLists[i]]*100))
	end
	req:Send(function(res)
			if res.StatusCode == 200 then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID), 'game_option_uploaded', {})
			else 
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID), 'game_option_upload_fail', {})
			end
			--PrintTable(res)
		end
	)
end




function GameMode:OnDownloadGameOptions(eventSourceIndex, args)
	local req=CreateHTTPRequestScriptVM('GET', 'http://167.99.164.76:8000/d2aifun_configs/')
	req:SetHTTPRequestGetOrPostParameter('steamid', args.steamid)
	req:SetHTTPRequestGetOrPostParameter('api_key', GetDedicatedServerKeyV2(version))
	req:SetHTTPRequestGetOrPostParameter('version', version)
	req:SetHTTPRequestGetOrPostParameter('get_or_put', 'get')
	
	req:Send(function (res)
		PrintTable(res)
		if res.StatusCode ~= 200 then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID), 'game_option_download_fail', {})
		end
		local tDownloadOption = JSON:decode(res.Body)
		PrintTable(tDownloadOption)
		local tOptionToClient = {}
		for i, v in pairs(tGameOptionLists) do
			GameMode.tGameOption[tGameOptionLists[i]] = tonumber(tDownloadOption['data_'..tostring(i)])/100
			CustomNetTables:SetTableValue('game_options', 'loading_game_options', GameMode.tGameOption)
		end
		PrintTable (CustomNetTables:GetTableValue('game_options', 'loading_game_options'))
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.PlayerID), 'game_option_downloaded', GameMode.tGameOption)
	end)
end


