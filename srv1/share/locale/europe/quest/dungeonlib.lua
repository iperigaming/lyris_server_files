dungeonLib = {}

function dungeonLib.CheckEnter(questname, cooldown, requirements)
	if questname == nil or requirements == nil or cooldown == nil then
		return false
	end

	local value = game.get_dungeon_cooldown_event(pc.get_empire())
	if value != -1 then
		cooldown = cooldown - (cooldown * value) / 100
	end

	if party.is_party() then
		local pids = { party.get_member_pids() };
		local levelCheckNameList, levelNeedCheck, itemCheckNameList, itemNeedCheck, timeCheckNameList, timeNeedCheck = {}, false, {}, false, {}, false
		
		if (not party.is_leader()) then
			say(locale_quest(1331))
			return false
		end
		
		if (party.get_near_count() < requirements["min_party_members"]) then
			say(string.format(locale_quest(91740), requirements["min_party_members"]))
			return false
		end
		
		for _, pid in ipairs(pids) do
			q.begin_other_pc_block(pid);
				if (pc.getf(questname, "enter_time") + cooldown) > get_global_time() and pc.get_gm_level() < 5 then
					table.insert(timeCheckNameList, pc.get_name())
					timeNeedCheck = true
				end

				if requirements["min_level"] > requirements["max_level"] then
					say("syntax error: min_level cant be lower than max_level.")
					return false
				end

				if requirements["min_level"] > 120 then
					if pc.get_conqueror_level() < (requirements["min_level"] - 120) then
						levelNeedCheck = true;
					end
				else
					if pc.get_level() < requirements["min_level"] then
						levelNeedCheck = true;
					end
				end

				if requirements["max_level"] > 120 then
					if pc.get_conqueror_level() > (requirements["max_level"] - 120) then
						levelNeedCheck = true;
					end
				else
					if pc.get_level() > requirements["max_level"] then
						levelNeedCheck = true;
					end
				end

				if levelNeedCheck == true then
					table.insert(levelCheckNameList, pc.get_name())
				end
				
				if (pc.count_item(requirements["ticket"]) < 1) then
					table.insert(itemCheckNameList, string.format("%s", pc.get_name()));
					itemNeedCheck = true;
				end
			q.end_other_pc_block();
		end

		if timeNeedCheck == true then
			say(locale_quest(91741))
			for _, name in ipairs(levelCheckNameList) do
				say_reward(string.format("- %s", name))
			end

			return false
		end
		
		if levelNeedCheck == true then
			say(string.format(locale_quest(91742), requirements["min_level"], requirements["max_level"]))
			for _, name in ipairs(levelCheckNameList) do
				say_reward(string.format("- %s", name))
			end

			return false
		end
		
		if itemNeedCheck == true then
			say(locale_quest(91743))
			say_item(""..item_name(requirements["ticket"]).."", requirements["ticket"], "")
			say(locale_quest(91744))
			for _, name in ipairs(itemCheckNameList) do
				say_reward(string.format("- %s", name))
			end
			return false
		end
		
	elseif requirements["party"] == false then
		if (pc.getf(questname, "enter_time") + cooldown) > get_global_time() and pc.get_gm_level() < 5 then
			local remaining_wait_time = (pc.getf(questname, "enter_time") - get_global_time() + cooldown)
			say(locale_quest(91745))
			say_reward(locale_quest(91746)..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return false
		end

		local levelNeedCheck = false

		if requirements["min_level"] > 120 then
			if pc.get_conqueror_level() < (requirements["min_level"] - 120) then
				levelNeedCheck = true;
			end
		else
			if pc.get_level() < requirements["min_level"] then
				levelNeedCheck = true;
			end
		end

		if requirements["max_level"] > 120 then
			if pc.get_conqueror_level() > (requirements["max_level"] - 120) then
				levelNeedCheck = true;
			end
		else
			if pc.get_level() > requirements["max_level"] then
				levelNeedCheck = true;
			end
		end

		if levelNeedCheck == true then
			say(string.format(locale_quest(91747), requirements["min_level"], requirements["max_level"]))
			return false
		end
		
		if (pc.count_item(requirements["ticket"]) < 1) then
			say(locale_quest(91748))
			say_item(""..item_name(requirements["ticket"]).."", requirements["ticket"], "")
			return false
		end
	else
		return false
	end

	return true
end

function dungeonLib.GetUnique(name, count)
	for i = 1, count do
		if not d.is_unique_dead(string.format(name, i)) then
			return string.format(name, i)
		end
	end
end