"use strict"; 

var aRamzaNameShort= ["squire", "chemist", "knight", "archer", "white_mage", "black_mage", "monk", "thief", "mystic", "time_mage", "orator", "summoner", "geomancer", "dragoon", "samurai", "ninja", "arithmetician", "mime", "dark_knight", "onion_knight"] 


function PortraitApply(keys) {
	var tInvokerRetroWearables = CustomNetTables.GetTableValue('invoker_retro', 'wearables_for_player_'+Game.GetLocalPlayerID().toString())
	if (Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), 'ramza_go_back_lua')>0) {
		var iUnitJob = CustomNetTables.GetTableValue("ramza", 'current_job_'+Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()).toString())['1']
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('portraitHUD').visible=false
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('portraitHUDOverlay').visible=false
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBackerColor').visible=true	
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBackerColor').style.backgroundColor='gradient( linear, 0% 0%, 100% 0%, from( #FFFFFF00 ), to( #000000FF ) )'
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBacker').style.backgroundImage='url("file://{images}/custom_game/ramza/square/'+aRamzaNameShort[iUnitJob-1]+'.png")'
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBacker').style.marginBottom = '0px';
	}
	else if (Entities.GetAbilityByName(Players.GetLocalPlayerPortraitUnit(), 'invoker_retro_invoke')>0 && tInvokerRetroWearables)
	{
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('portraitHUD').visible=false
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('portraitHUDOverlay').visible=false
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBackerColor').visible=true	
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBackerColor').style.backgroundColor='gradient( linear, 0% 0%, 100% 0%, from( #FFFFFF00 ),  color-stop (0.8, #00000066), to( #000000ff ) )'	

		if (tInvokerRetroWearables.head.style) {
			$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBacker').style.backgroundImage='url("file://{images}/custom_game/invoker_heads/'+tInvokerRetroWearables.head.id+'_'+tInvokerRetroWearables.head.style+'.png")'

		}
		else {	
			$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBacker').style.backgroundImage='url("file://{images}/custom_game/invoker_heads/'+tInvokerRetroWearables.head.id+'_0.png")'		
		}
	}
	else
	{
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('portraitHUD').visible=true
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('portraitHUDOverlay').visible=true
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBackerColor').visible=true
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBacker').style.backgroundImage='url("s2r://panorama/images/hud/reborn/inventory_bg_psd.vtex")'
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PortraitBacker').style.marginBottom = '0px';
	}
	if (Entities.GetLevel(Players.GetLocalPlayerPortraitUnit())>= 1000)
	{	
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('LevelLabel').style.fontSize='12px';
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('LevelLabel').style.marginBottom='15px';
	}
	else if (Entities.GetLevel(Players.GetLocalPlayerPortraitUnit()) >= 100) {
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('LevelLabel').style.fontSize='16px';
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('LevelLabel').style.marginBottom='14px';
	}
	else {
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('LevelLabel').style.fontSize='20px';
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('LevelLabel').style.marginBottom='12px';
	}
			
	
	
	
}
GameEvents.Subscribe( "dota_player_update_selected_unit", PortraitApply);
GameEvents.Subscribe( "dota_player_update_query_unit", PortraitApply);