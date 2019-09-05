--[[ ============================================================================================================
	Author: Rook
	Date: February 20, 2015
	Called when Levitation is cast.  Applies the levitating modifier with a duration dependent on Quas, Wex, and Exort.
================================================================================================================= ]]
function invoker_retro_levitation_on_spell_start(keys)	
	--Levitate's duration is dependent on the levels of Quas, Wex, and Exort.
	local iQuasLevel
	if keys.caster:HasScepter() then
		iQuasLevel = keys.caster.iQuasLevel+1
	else
		iQuasLevel = keys.caster.iQuasLevel
	end
	
	local iExortLevel
	if keys.caster:HasScepter() then
		iExortLevel = keys.caster.iExortLevel+1
	else
		iExortLevel = keys.caster.iExortLevel
	end
	
	local iWexLevel
	if keys.caster:HasScepter() then
		iWexLevel = keys.caster.iWexLevel+1
	else
		iWexLevel = keys.caster.iWexLevel
	end
	
	keys.caster:EmitSound("Brewmaster_Storm.Cyclone")
	

	
	local levitation_duration = keys.ability:GetSpecialValueFor("duration_level_quas_wex_exort")*(iQuasLevel+iWexLevel+iExortLevel)	
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_invoker_retro_levitation", {duration = levitation_duration})
	

end
function LevitationStopSound(keys)
	keys.caster:StopSound("Brewmaster_Storm.Cyclone")
end

--[[
	Author: Noya, edited by Rook
	Date: 08.02.2015.
	Progressively sends the target at a max height, then up and down between an interval, and finally back to the original ground position.
]]
function TornadoHeight( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
--	for k, v in pairs(keys) do print(k) end
	
	local iQuasLevel
	if keys.caster:HasScepter() then
		iQuasLevel = keys.caster.iQuasLevel+1
	else
		iQuasLevel = keys.caster.iQuasLevel
	end
	
	local iExortLevel
	if keys.caster:HasScepter() then
		iExortLevel = keys.caster.iExortLevel+1
	else
		iExortLevel = keys.caster.iExortLevel
	end
	
	local iWexLevel
	if keys.caster:HasScepter() then
		iWexLevel = keys.caster.iWexLevel+1
	else
		iWexLevel = keys.caster.iWexLevel
	end
	
	-- Position variables
	local target_origin = target:GetAbsOrigin()
	local target_initial_x = target_origin.x
	local target_initial_y = target_origin.y
	local target_initial_z = target_origin.z
	local position = Vector(target_initial_x, target_initial_y, target_initial_z)  --This is updated whenever the target has their position changed.
	
	local duration = ability:GetSpecialValueFor("duration_level_quas_wex_exort")*(iQuasLevel+iWexLevel+iExortLevel)	

	local ground_position = GetGroundPosition(position, target)
	local cyclone_initial_height = ability:GetSpecialValueFor("cyclone_initial_height_base") + ability:GetSpecialValueFor("cyclone_initial_height_level_quas_wex_exort")*(iQuasLevel+iWexLevel+iExortLevel)	 + ground_position.z
	local cyclone_min_height = ability:GetSpecialValueFor("cyclone_min_height_base") + ability:GetSpecialValueFor("cyclone_min_height_level_quas_wex_exort")*(iQuasLevel+iWexLevel+iExortLevel)	 + ground_position.z
	local cyclone_max_height = ability:GetSpecialValueFor("cyclone_max_height_base") + ability:GetSpecialValueFor("cyclone_max_height_level_quas_wex_exort")*(iQuasLevel+iWexLevel+iExortLevel)	 + ground_position.z
	local tornado_start = GameRules:GetGameTime()

	-- Height per time calculation
	local time_to_reach_initial_height = duration / 10  --1/10th of the total Levitation duration will be spent ascending and descending to and from the initial height.
	local initial_ascent_height_per_frame = ((cyclone_initial_height - position.z) / time_to_reach_initial_height) * .03  --This is the height to add every frame when Levitation is first cast, and applies until the caster reaches their max height.
	
	local up_down_cycle_height_per_frame = initial_ascent_height_per_frame / 3  --This is the height to add or remove every frame while the caster is in up/down cycle mode.
	if up_down_cycle_height_per_frame > 7.5 then  --Cap this value so the unit doesn't jerk up and down for short-duration levitations.
		up_down_cycle_height_per_frame = 7.5
	end
	
	local final_descent_height_per_frame = nil  --This is calculated when the unit begins descending.

	-- Time to go down
	local time_to_stop_fly = duration - time_to_reach_initial_height

	-- Loop up and down
	local going_up = true

	-- Loop every frame for the duration
	Timers:CreateTimer(function()
		if not caster:HasModifier('modifier_invoker_retro_levitation') then return end
		local time_in_air = GameRules:GetGameTime() - tornado_start
		
		-- First send the target to the cyclone's initial height.
		if position.z < cyclone_initial_height and time_in_air <= time_to_reach_initial_height then
			--print("+",initial_ascent_height_per_frame,position.z)
			
			position.z = position.z + initial_ascent_height_per_frame
			target:SetAbsOrigin(position)
			return 0.03

		-- Go down until the target reaches the ground.
		elseif time_in_air > time_to_stop_fly and time_in_air <= duration then
			--Since the unit may be anywhere between the cyclone's min and max height values when they start descending to the ground,
			--the descending height per frame must be calculated when that begins, so the unit will end up right on the ground when the duration is supposed to end.
			if final_descent_height_per_frame == nil then
				local descent_initial_height_above_ground = position.z - ground_position.z
				--print("ground position: " .. GetGroundPosition(position, target).z)
				--print("position.z : " .. position.z)
				final_descent_height_per_frame = (descent_initial_height_above_ground / time_to_reach_initial_height) * .03
			end
			
			--print("-",final_descent_height_per_frame,position.z)
			
			position.z = position.z - final_descent_height_per_frame
			target:SetAbsOrigin(position)
			return 0.03

		-- Do Up and down cycles
		elseif time_in_air <= duration then
			-- Up
			if position.z < cyclone_max_height and going_up then 
				--print("going up")
				position.z = position.z + up_down_cycle_height_per_frame
				target:SetAbsOrigin(position)
				return 0.03

			-- Down
			elseif position.z >= cyclone_min_height then
				going_up = false
				--print("going down")
				position.z = position.z - up_down_cycle_height_per_frame
				target:SetAbsOrigin(position)
				return 0.03

			-- Go up again
			else
				--print("going up again")
				going_up = true
				return 0.03
			end

		-- End
		else
			--print(GetGroundPosition(target:GetAbsOrigin(), target))
			--print("End TornadoHeight")
		end
	end)
end