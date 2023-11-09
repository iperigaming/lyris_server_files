ChamberWisdomLIB = {};

ChamberWisdomLIB.Settings = function()
	if (ChamberWisdomLIB.data == nil) then
		ChamberWisdomLIB.data = {
			-- [[ Requirements, Items, Map info ]]
			["minimumLevel"] = 70, -- Minimum level for enter the dungeon
			["minimumPartyMembers"] = 2, -- Minimum count of players (If its party)
			
			["inside_pos"] = {11534, 22752}, -- Dungeon coordinates
			["inside_index"] = 77, -- Dungeon index
			
			["outside_index"] = {1, 21, 41}, -- Index of maps, where are players teleported from the dungeon (Cities)
			["outside_pos"] = {4693, 9642, 557, 1579, 9694, 2786}, -- Coords of the maps where are players teleported from the dungeon (Cities)	
			
			["wisdom_ticket"] = 30811,
			["Item_Key"] = 30812,
			["Item_Books"] = {30813, 30814, 30815, 30816},
			["Item_To_Reward"] = 30817,
			["Item_Reward"] = {72726, 72730, 25040},
			
			["locked_book_pos"] = {{299, 246, 7}, {299, 283, 7}, {244, 246, 3}, {241, 283, 3}}, --- Position and rotation of locked books
			
			["boss_data"] = {4311, 271, 286},

			["dungeon_cooldown"] = 3600,
			
			["dungeon_timer"] = 1200,
			
			["dungeon_timer_out"] = 120,
			
			["reward_cooldown"] = 60, --86400
						
			};
	end
	
	return ChamberWisdomLIB.data;
end


ChamberWisdomLIB.clearTimers = function()
	clear_server_timer("ChamberWisdom_FinalExit", get_server_timer_arg())
	clear_server_timer("ChamberWisdom_FinalExitOut", get_server_timer_arg())
end

ChamberWisdomLIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = ChamberWisdomLIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

ChamberWisdomLIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.clear_regen();
		d.kill_all();
	end return false;
end

ChamberWisdomLIB.checkEnter = function()
	local settings = ChamberWisdomLIB.Settings();
	say_size(350,350)
	addimage(25, 10, "chamber_wisdom_bg1.tga"); addimage(225, 200, "chamber_npc1.tga")
	say("[ENTER][ENTER]")
	say_title(mob_name(9341))
	
	if party.is_party() then
		local pids = party_get_member_pids();
		local minLev, minLevCheck, itemNeed, itemNeedCheck = {}, true, {}, true;
		
		if not party.is_map_member_flag_lt("exit_chamber_of_wisdom_time", get_global_time() - settings["dungeon_cooldown"] ) then
			say_reward("Some members still have to wait[ENTER]until they can join the dungeon again.")
			return false;
		end
		
		if (not party.is_leader()) then
			say("If you want to enter Chamber of wisdom,[ENTER]let me talk with the group leader first.")
			return false;
		end
		
		if (party.get_near_count() < settings["minimumPartyMembers"]) then
			say(string.format("If you want to enter the Chamber of wisdom,[ENTER]there must be atleast %d players with you...", settings["minimumPartyMembers"]))
			return false;
		end
		
		for index, pid in ipairs(pids) do
			q.begin_other_pc_block(pid);
				if (pc.get_level() < settings["minimumLevel"]) then
					table.insert(minLev, pc.get_name());
					minLevCheck = false;
				end
				
				if (pc.count_item(settings["wisdom_ticket"]) < 1) then
					table.insert(itemNeed, string.format("%s", pc.get_name()));
					itemNeedCheck = false;
				end
			q.end_other_pc_block();
		end
		
		if (not minLevCheck) then
			say(string.format("If you want to enter the Chamber of wisdom,[ENTER]every each group member must be level %d.[ENTER][ENTER]The next following players don't have the necessary level:", settings["minimumLevel"]))
			for i, str in next, minLev, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		if (not itemNeedCheck) then
			say("If you wish to enter the Chamber of wisdom,[ENTER]every each group memeber must have:")
			say_item(""..item_name(settings["wisdom_ticket"]).."", settings["wisdom_ticket"], "")
			say("The next following players don't have the required item:")
			for i, str in next, itemNeed, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		return true;
	else  --- if its solo
	
		if ((get_global_time() - pc.getf("chamber_of_wisdom","exit_chamber_of_wisdom_time")) < settings["dungeon_cooldown"]) then
		
			local remaining_wait_time = (pc.getf("chamber_of_wisdom","exit_chamber_of_wisdom_time") - get_global_time() + settings["dungeon_cooldown"])
			say("You have to wait until you can enter the dungeon again.")
			say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return
		end

		if (pc.get_level() < settings["minimumLevel"]) then
			say(string.format("The minimum level to enter the dungeon is %d.", settings["minimumLevel"]))
			return false;
		end
		
		if (pc.count_item(settings["wisdom_ticket"]) < 1) then
			say("If you want to enter the Chamber of wisdom[ENTER]you must have:")
			say_item(""..item_name(settings["wisdom_ticket"]).."", settings["wisdom_ticket"], "")
			return false;
		end
	end
	
	return true;
end

ChamberWisdomLIB.CreateDungeon = function()
	local settings = ChamberWisdomLIB.Settings();
	
	if party.is_party() then
		local pids = party_get_member_pids();
		
		for i, pid in next, pids, nil do
			q.begin_other_pc_block(pid);
			pc.remove_item(settings["wisdom_ticket"], 1);
			q.end_other_pc_block();
		end
		return d.new_jump_party(settings["inside_index"], settings["inside_pos"][1], settings["inside_pos"][2]);
	else
		pc.remove_item(settings["wisdom_ticket"], 1);	
		return d.new_jump(settings["inside_index"], settings["inside_pos"][1]*100, settings["inside_pos"][2]*100); 
	end
end

ChamberWisdomLIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = ChamberWisdomLIB.Settings();
	
	if empire == 1 then
		d.set_warp_location(settings["outside_index"][1], settings["outside_pos"][1], settings["outside_pos"][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"][2], settings["outside_pos"][3], settings["outside_pos"][4]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"][3], settings["outside_pos"][5], settings["outside_pos"][6]);
	end
end

ChamberWisdomLIB.spawnBooks = function()
	local settings = ChamberWisdomLIB.Settings();
	local books = settings["locked_book_pos"];

	table_shuffle(books);

	for index, position in ipairs(books) do
		d.set_unique("protected_book_"..index, d.spawn_mob_dir(9345, position[1], position[2], position[3]))
	end 
end
