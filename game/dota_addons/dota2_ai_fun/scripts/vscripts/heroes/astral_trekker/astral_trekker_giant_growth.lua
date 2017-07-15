function astral_trekker_giant_growth_activate(keys)
	local hCaster = keys.caster
	for i = 1, 30 do
		Timers(i/24, function ()
			print(hCaster:GetModelScale())
			hCaster:SetModelScale(hCaster:GetModelScale()*1.02) 			
			
		end)
	end	
end

function astral_trekker_giant_growth_deactivate(keys)
	local hCaster = keys.caster
	for i = 1, 30 do
		Timers(i/24, function () 
			hCaster:SetModelScale(hCaster:GetModelScale()/1.02) 
			print(hCaster:GetModelScale()) end)
	end
	
end