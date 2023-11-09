AndunTempleLIB = {};

AndunTempleLIB.Settings = function()
	if (AndunTempleLIB.data == nil) then
		AndunTempleLIB.data = {
			----------
			--- Requirements, map info, coordinates,  etc...
			----------
			["dungeon_cooldown"] = 3600,  --- Time within players can't enter the dungeon after they finish it (or were teleported out of dungeon)			
			
			["minimumLevel"] = 100, -- Minimum level for enter the dungeon
			["minimumPartyMembers"] = 2, -- Minimum count of players (If its party, members need to be around)
			
			["onlyGroupDungeon"] = false, -- For solo dungeon, put "true" if you want only group dungeon
			
			["inside_index"] = 157, -- Dungeon index
			["1Floor_Pos"] = {36989, 22643}, -- Dungeon coordinates to 1. floor
			["2Floor_Pos"] = {37473, 22880}, -- Dungeon coordinates to 2. floor
			["3Floor_Pos"] = {37023, 23041}, -- Dungeon coordinates to 3. floor
			["4Floor_Pos"] = {37049, 23403}, -- Dungeon coordinates to 4. floor
			["5Floor_Pos"] = {37349, 23465}, -- Dungeon coordinates to 5. floor
			["6Floor_Pos"] = {37706, 23427}, -- Dungeon coordinates to 6. floor
			
			["outside_index"] = 154, -- Index of maps, where are players teleported from the dungeon (Andun catacombs)
			["outside_pos"] = {34208, 24436}, -- Coords of the maps where are players teleported from the dungeon (Andun catacombs)	
			
			--["outside_index"] = {1, 21, 41}, -- Index of maps, where are players teleported from the dungeon (Cities)
			--["outside_pos"] = {4693, 9642, 557, 1579, 9694, 2786}, -- Coords of the maps where are players teleported from the dungeon (Cities)	
			
			["Item_ticket"] = 30909,
			
			----------			
			---Potions
			----------			
			["potion_s_add_time"] = 300,  --- Small potion (30910) can increase the time by 5 minutes
			["potion_l_add_time"] = 600,  --- Small potion (30911) can increase the time by 10 minutes
						
			----------
			--- Dungeon settings (IDs, etc..)
			----------			
			["KILL_COUNT_1_WAVE"] = 127, ---- Count of monsters players need to kill in first floor
			["KILL_COUNT_2_WAVE"] = 123, ---- Count of monsters players need to kill in second floor
			["KILL_COUNT_3_WAVE"] = 159, ---- Count of monsters players need to kill in second floor
			["KILL_COUNT_4_WAVE"] = 159, ---- Count of monsters players need to kill in second floor
			["KILL_COUNT_5_WAVE"] = 139, ---- Count of monsters players need to kill in third floor
			["KILL_COUNT_6_WAVE"] = 145, ---- Count of monsters players need to kill in fourth floor
			["KILL_COUNT_7_WAVE"] = 153, ---- Count of monsters players need to kill in fourth floor
			["KILL_COUNT_8_WAVE"] = 157, ---- Count of monsters players need to kill in fourth floor
			["KILL_COUNT_9_WAVE"] = 184, --184, ---- Count of monsters players need to kill in fifth floor
			["KILL_COUNT_10_WAVE"] = 217, ---- Count of monsters players need to kill in sixth floor

			---IDs
			["Bosses"] = {4544, 4545, 4546, 4547, 4548},
			
			["items_to_remove"] = {30912, 30913, 30914, 30915, 30916, 30917},
			
			---States
			["FINAL_BOSS_HP_BASIC"] = 2500000,
			["FINAL_BOSS_HP_HIGH_1"] = 2600000,
			["FINAL_BOSS_HP_HIGH_2"] = 2700000,
			["FINAL_BOSS_HP_HIGH_3"] = 2800000,
			["FINAL_BOSS_HP_HIGH_4"] = 2900000,
			["FINAL_BOSS_HP_HIGH_5"] = 3100000,
			["FINAL_BOSS_HP_HIGH_6"] = 3200000,
			["FINAL_BOSS_HP_HIGH_7"] = 3400000,

			
			---Positions
			["2F_doorPos"] = {{551, 310, 7}, {610, 234, 5}, {664, 310, 3}},
			["2F_monumentPos"] = {{750, 296, 7}, {596, 155, 1}, {467, 321, 3}},
			["3F_stonePos"] = {{118, 560}, {127, 557}, {136, 543}, {144, 535}, {135, 526}, {127, 517}, {118, 511}, {118, 535}},
			["5F_altarPos"] =  {{508, 840, 1}, {462, 840, 1}, {469, 822, 3}, {499, 822, 7}},
			["6F_stonesPos"] =  {{842, 836}, {826, 843}, {821, 859}, {828, 872}, {842, 877}, {855, 872}, {862, 857}, {856, 844}},
			["6F_BossPos"] =  {842, 855, 5},

			----------			
			---Soul timer settings
			----------			
			["dungeon_soul"] = 900,  --- Soul timer is set to 15 minutes by default at the start of dungeon
			
			["soul_loss_third_floor"] = 240,  --- 4 minutes will be removed from the soul timer if players wont kill second boss in 3 minutes
			["soul_loss_fourth_floor"] = 300,  --- 5 minutes will be removed from the soul timer if players wont finish fourth floor in defined time
			["soul_need_sixth_floor"] = 600,  --- If players have atleast 10 minutes left in the soul timer, only bosses from first 2 stages can be spawned
			["soul_loss_sixth_floor"] = 300,  --- If players dont destroy the final pillar in defined time, 5 minutes of mana will be removed

			----------
			--- Dungeon Timers 
			----------			
			["DungeonTimer"] = 3600,  --- Time within boss or next waves of monsters are spawned in the dungeon			
			["FourthStageTimer"] = 360,  --- Time within players must finish fourth floor			
			["time_to_proceed"] = 10,  --- Time within boss or next waves of monsters are spawned in the dungeon			
			["time_to_kill_third_boss"] = 180,  --- Time within players have to kill second boss, otherwise they loose some soul mana
			["time_to_spawn_pillar"] = 30, --300,  --- Time within players have to kill final boss otherwise a protection pillar is spawned
			["time_to_kill_pillar"] = 30, --180,  --- Time within players have to destroy the pillar
			["timer_to_exit_dungeon"] = 120,  --- Time within players have to destroy second stone (8703), otherwise the finall boss is gonna have much higher defense
			
			};
	end
	
	return AndunTempleLIB.data;
end


AndunTempleLIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = AndunTempleLIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

AndunTempleLIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.kill_all();
		d.clear_regen();
		d.kill_all();
	end return false;
end

AndunTempleLIB.checkEnter = function()
	local settings = AndunTempleLIB.Settings();
	local ItemTicket = settings["Item_ticket"]	
	
	addimage(25, 10, "anduntemp_bg_1.tga"); addimage(225, 150, "andun_temp_npc1.tga");
	say("[ENTER][ENTER]")
	say_title(mob_name(9435))
	
	if party.is_party() then
		local pids = party_get_member_pids();
		local minLev, minLevCheck, itemNeed, itemNeedCheck, Timetable, TimeNeedCheck = {}, true, {}, true, {}, true;
		
		if (not party.is_leader()) then
			say("If you want to enter the dungeon,[ENTER]let me talk with the group leader first.")
			return false;
		end
		
		if (party.get_near_count() < settings["minimumPartyMembers"]) then
			say(string.format("If you want to enter the dungeon,[ENTER]there must be atleast %d players with you...", settings["minimumPartyMembers"]))
			return false;
		end
		
		if (pc.count_item(ItemTicket) < 1) then
			say("If you want to enter the dungeon, you need")
			say_item(""..item_name(ItemTicket).."", ItemTicket, "")
			say("Only you as a leader need it. Other members[ENTER]of your group dont need it")
		end
		
		for index, pid in ipairs(pids) do
			q.begin_other_pc_block(pid);
				if (pc.get_level() < settings["minimumLevel"]) then
					table.insert(minLev, pc.get_name());
					minLevCheck = false;
				end
								
				local andundung1_time_flag = game.get_event_flag("andundun1_cooldown_"..pid.."");
				local current_time = get_time();
				
				if (andundung1_time_flag > current_time) then
					table.insert(Timetable, string.format("%s - %s", pc.get_name(), get_time_format(andundung1_time_flag - current_time)));
					TimeNeedCheck = false;
				end
			q.end_other_pc_block();
		end
		
		if (not minLevCheck) then
			say(string.format("If you want to enter the dungeon,[ENTER]every each group member must be level %d.[ENTER][ENTER]The next following players don't have the necessary level:", settings["minimumLevel"]))
			for i, str in next, minLev, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		if (not itemNeedCheck) then
			say("If you wish to enter the dungeon,[ENTER]every each group memeber must have:")
			say_item(""..item_name(settings["Item_ticket"]).."", settings["Item_ticket"], "")
			say("The next following players don't have the required item:")
			for i, str in next, itemNeed, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		if (not TimeNeedCheck) then
			say(string.format("Some members of your group still has to wait:", get_time_format(settings["dungeon_cooldown"])))
			for i, str in next, Timetable, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		return true;
	end
	
	if (not settings["onlyGroupDungeon"]) then -- If its solo
	
		local ownPid = pc.get_player_id();
		local andundung1_time_flag = game.get_event_flag("andundun1_cooldown_"..ownPid.."");
		local current_time = get_time();
		
		if (andundung1_time_flag > current_time) then
			say(string.format("If you want to enter, you need to wait %s.", get_time_format(andundung1_time_flag - current_time)))
			return false;
		end

		if (pc.get_level() < settings["minimumLevel"]) then
			say(string.format("The minimum level to enter the dungeon is %d.", settings["minimumLevel"]))
			return false;
		end
		
		if (pc.count_item(ItemTicket) < 1) then
			say("If you want to enter the dungeon[ENTER]you must have:")
			say_item(""..item_name(ItemTicket).."", ItemTicket, "")
			return false;
		end
	end
	
	return true;
end

AndunTempleLIB.CreateDungeon = function()
	local settings = AndunTempleLIB.Settings();

	if party.is_party() then
		local pids = party_get_member_pids();
		
		for i, pid in next, pids, nil do
			q.begin_other_pc_block(pid);
			pc.remove_item(settings["Item_ticket"], 1);
			q.end_other_pc_block();
		end
		return d.new_jump_party(settings["inside_index"], settings["1Floor_Pos"][1], settings["1Floor_Pos"][2]);
	else
		pc.remove_item(settings["Item_ticket"], 1);	
		return d.new_jump(settings["inside_index"], settings["1Floor_Pos"][1]*100, settings["1Floor_Pos"][2]*100); 
	end
end


AndunTempleLIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = AndunTempleLIB.Settings();
	
	if empire == 1 then
		d.set_warp_location(settings["outside_index"][1], settings["outside_pos"][1], settings["outside_pos"][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"][2], settings["outside_pos"][3], settings["outside_pos"][4]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"][3], settings["outside_pos"][5], settings["outside_pos"][6]);
	end
end

AndunTempleLIB.setReward = function()
	local settings = AndunTempleLIB.Settings();
	
	if party.is_party() then
		for _, pid in pairs({party.get_member_pids()}) do
			q.begin_other_pc_block(pid);
			
			d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 1);	
			
			q.end_other_pc_block();
		end
	else
		d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 1);	
	end
end

AndunTempleLIB.setWaitingTime = function()
	local settings = AndunTempleLIB.Settings(); 
	local ownPid = pc.get_player_id();
	
	if party.is_party() then
		if (type(pids) != "table") then
			return game.set_event_flag("andundun1_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
		end
		
		for index, pid in next, pids, nil do
			return game.set_event_flag("andundun1_cooldown_"..pid.."", settings["dungeon_cooldown"] + get_time());
		end
	end
	return game.set_event_flag("andundun1_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
end

AndunTempleLIB.RemainingTimeNotice = function()
	local RemainingTime = (d.getf("AndunTemple_DungeonTimer") - get_global_time())
	local minutes = math.floor(RemainingTime / 60)
	
	d.notice("------------------------------------")
	d.notice("Andun temple: Remaining time - " ..minutes.. " minutes")
	d.notice("------------------------------------")
end

AndunTempleLIB.jumpToSecondFloor = function()
	local settings = AndunTempleLIB.Settings();
	local doorPos = settings["2F_doorPos"];
	local monumentPos = settings["2F_monumentPos"];
	
	d.setf("AndunTemple_stage", 2);
	d.setf("AndunTemple_door", 1);
	d.setf("AndunTemple_CanDestroy_1Stone", 1);
	d.setf("AndunTemple_FBossKilled", 0)
	
	table_shuffle(doorPos);
	
	for index, position in ipairs(doorPos) do
		d.set_unique("door_"..index, d.spawn_mob_dir(9448, position[1], position[2], position[3]))
	end 
	
	for index, position in ipairs(monumentPos) do
		d.set_unique("monument_"..index, d.spawn_mob_dir(9449, position[1], position[2], position[3]))
	end 
	d.spawn_mob(8723, 609, 309);

	
	d.jump_all(settings["2Floor_Pos"][1], settings["2Floor_Pos"][2]);
	
	d.notice(string.format("Andun temple: Destroy %s to get a %s!", mob_name(8723), item_name(30912)));
end

AndunTempleLIB.openDoor = function()
	if d.getf("AndunTemple_door") == 1 then
		if npc.get_vid() == d.get_unique_vid("door_1") then
			d.kill_unique("door_1")
			item.remove();
			
			d.setf("AndunTemple_door", 2); 
			d.setf("AndunTemple_UnlockMonument", 1);
			
			d.notice("Andun temple: You opened the right one!");
			d.notice(string.format("Andun temple: Activate %s now to proceed!", mob_name(9449)));
		else
			item.remove();
			d.setf("AndunTemple_CanDestroy_1Stone", 1);
			d.spawn_mob(8723, 609, 309);
			
			d.notice(string.format("Andun temple: You need to unlock other %s first!", mob_name(9448)));
		end
	
	elseif d.getf("AndunTemple_door") == 2 then
		if npc.get_vid() == d.get_unique_vid("door_2") then
			d.kill_unique("door_2")
			item.remove();
			
			d.setf("AndunTemple_door", 3); 
			d.setf("AndunTemple_UnlockMonument", 1);
			
			d.notice("Andun temple: You opened the right one!");
			d.notice(string.format("Andun temple: Activate %s now to proceed!", mob_name(9449)));
		else
			item.remove();
			d.setf("AndunTemple_CanDestroy_1Stone", 1);
			d.spawn_mob(8723, 609, 309);
			
			d.notice(string.format("Andun temple: You need to unlock other %s first!", mob_name(9448)));
		end
	
	elseif d.getf("AndunTemple_door") == 3 then
		if npc.get_vid() == d.get_unique_vid("door_3") then
			d.kill_unique("door_3")
			item.remove();
			
			d.setf("AndunTemple_UnlockMonument", 1);
			
			d.notice("Andun temple: You opened the right one!");
			d.notice(string.format("Andun temple: Activate %s now to proceed!", mob_name(9449)));
		else
			item.remove();
			d.setf("AndunTemple_CanDestroy_1Stone", 1);
			d.spawn_mob(8723, 609, 309);
			
			d.notice(string.format("Andun temple: You need to unlock other %s first!", mob_name(9448)));
		end
	end
end

AndunTempleLIB.spawnSecondBoss = function()
	local settings = AndunTempleLIB.Settings();
	
	d.setf("AndunTemple_CanKillSecondBoss", 1);
	
	d.spawn_mob(4545, 609, 309);
	
	d.notice(string.format("Andun temple: %s has showed up! Kill him!", mob_name(4545)));
end

AndunTempleLIB.activate2FMonument = function()
	if npc.get_vid() == d.get_unique_vid("monument_1") then
		d.purge_unique("monument_1");
		d.spawn_mob_dir(9450, 750, 296, 7);
		
		d.setf("AndunTemple_UnlockMonument", 0);
		d.setf("AndunTemple_2FMonument", 1);
		d.setf("AndunTemple_2w_monsters_k", 1);
		d.regen_file("data/dungeon/andun_temple/regen_2f_mobs_a.txt");
	
	elseif npc.get_vid() == d.get_unique_vid("monument_2") then
		d.purge_unique("monument_2");
		d.spawn_mob_dir(9450, 596, 155, 1);
		
		d.setf("AndunTemple_UnlockMonument", 0);
		d.setf("AndunTemple_2FMonument", 2);
		d.setf("AndunTemple_2w_monsters_k", 1);
		d.regen_file("data/dungeon/andun_temple/regen_2f_mobs_b.txt");
	
	elseif npc.get_vid() == d.get_unique_vid("monument_3") then
		d.purge_unique("monument_3");
		d.spawn_mob_dir(9450, 467, 321, 3);
		
		d.setf("AndunTemple_UnlockMonument", 0);
		d.setf("AndunTemple_2FMonument", 3);
		d.setf("AndunTemple_2w_monsters_k", 1);
		d.regen_file("data/dungeon/andun_temple/regen_2f_mobs_c.txt");
	end
end

AndunTempleLIB.jumpToThirdFloor = function()
	local settings = AndunTempleLIB.Settings();
	local position = settings["3F_stonePos"]; 
	local n = number(1,8); 			
	
	d.setf("AndunTemple_stage", 3);
	d.setf("AndunTemple_CanDestroy_2Stone", 1);
					
	table_shuffle(position);
	
	for i = 1, 8 do
		if (i != n) then
			d.set_unique("fake"..i, d.spawn_mob(8724, position[i][1], position[i][2]))
		end
	end

	d.set_unique ("real", d.spawn_mob(8724, position[n][1], position[n][2]))
	d.set_unique("SuccubusStatue", d.spawn_mob_dir(9451, 85, 535, 3))
	
	d.jump_all(settings["3Floor_Pos"][1], settings["3Floor_Pos"][2]);
	
	d.notice(string.format("Andun temple: Find correct %s and destroy it to get  %s!", mob_name(8724), item_name(30913)));
end

AndunTempleLIB.spawnThirdBoss = function()
	local settings = AndunTempleLIB.Settings();
	local TimeToKill = settings["time_to_kill_third_boss"];
	local minutes = math.floor(TimeToKill / 60)
	
	d.setf("AndunTemple_CanKillThirdBoss", 1);
	
	d.purge_unique("SuccubusStatue");
	AndunTempleLIB.clearDungeon();
	d.spawn_mob_dir(4546, 85, 535, 3);
	
	d.notice(string.format("Andun temple: %s has showed up! Kill her within %s minutes!", mob_name(4545), minutes));
	
	server_timer("AndunTemple_KillThirdBoss", TimeToKill, d.get_map_index())
end

AndunTempleLIB.jumpToFourthFloor = function()
	local settings = AndunTempleLIB.Settings();
	
	d.setf("AndunTemple_stage", 4);
	d.setf("AndunTemple_4thStage", 1);
	d.setf("AndunTemple_4FMonument", 1);
	d.setf("AndunTemple_4w_monsters_k", 1);
					

	d.regen_file("data/dungeon/andun_temple/regen_4f_mobs_a.txt");
	d.spawn_mob_dir(9452, 85, 875, 3);
	
	d.jump_all(settings["4Floor_Pos"][1], settings["4Floor_Pos"][2]);
	
	d.notice(string.format("Andun temple: Kill all monsters to get %s and be able to destroy the %s!", item_name(30915), mob_name(9452)));
	
	server_timer("AndunTemple_FourthStage", settings["FourthStageTimer"], d.get_map_index())
end

AndunTempleLIB.destroy4FMonument = function()
	item.remove();
	
	if d.getf("AndunTemple_4FMonument") == 1 then
		npc.kill();
		d.spawn_mob_dir(9453, 85, 875, 3);
		
		d.setf("AndunTemple_4FMonument", 2);
		d.setf("AndunTemple_4w_monsters_k", 1);
		
		d.regen_file("data/dungeon/andun_temple/regen_4f_mobs_b.txt");
		
	elseif d.getf("AndunTemple_4FMonument") == 2 then
		npc.kill();
		d.spawn_mob_dir(9454, 85, 875, 3);
		
		d.setf("AndunTemple_4FMonument", 3);
		d.setf("AndunTemple_4w_monsters_k", 1);
		
		d.regen_file("data/dungeon/andun_temple/regen_4f_mobs_c.txt");
		
	elseif d.getf("AndunTemple_4FMonument") == 3 then
		npc.kill();
		
		d.setf("AndunTemple_CanDestroy_3Stone", 1);
		
		d.regen_file("data/dungeon/andun_temple/regen_4f_stones.txt");
	end
end

AndunTempleLIB.jumpToFifthFloor = function()
	local settings = AndunTempleLIB.Settings();
	local altarPos = settings["5F_altarPos"]
	
	d.setf("AndunTemple_stage", 5);
	d.setf("AndunTemple_5FAltar", 1);
	d.setf("AndunTemple_5w_monsters_k", 1);
					
	table_shuffle(altarPos);
	
	for index, position in ipairs(altarPos) do
		d.set_unique("altar_"..index, d.spawn_mob_dir(9455, position[1], position[2], position[3]))
	end 
	
	d.regen_file("data/dungeon/andun_temple/regen_5f_mobs_a.txt");
	
	d.jump_all(settings["5Floor_Pos"][1], settings["5Floor_Pos"][2]);
	
	d.notice(string.format("Andun temple: Kill all monsters to get %s and be able to destroy the %s!", item_name(30916), mob_name(9455)));
	
	server_timer("AndunTemple_FourthStage", settings["FourthStageTimer"], d.get_map_index())
end

AndunTempleLIB.destroyAltar = function()
	local stoneID = 8726
	local npcID = 9455
	
	if d.getf("AndunTemple_5FAltar") == 1 then
		if npc.get_vid() == d.get_unique_vid("altar_1") then
			d.kill_unique("altar_1")
			item.remove();
			
			d.setf("AndunTemple_5FAltar", 2); 
			d.setf("AndunTemple_CanDestroy_Altar", 0);
			d.setf("AndunTemple_CanDestroy_4Stone", 1);
			
			d.notice("Andun temple: You have destroyed the right one!");
			d.notice(string.format("Andun temple: Destroy %s now to proceed!", mob_name(stoneID)));
			
			d.spawn_mob(stoneID, 485, 899);
		else
			item.remove();
			
			d.setf("AndunTemple_5w_monsters_k", 1);
			d.regen_file("data/dungeon/andun_temple/regen_5f_mobs_a.txt");
			
			d.notice(string.format("Andun temple: You need to destroy other %s first!", mob_name(npcID)));
			d.notice("Andun temple: Repeat last mission again!");
		end
	
	elseif d.getf("AndunTemple_5FAltar") == 2 then
		if npc.get_vid() == d.get_unique_vid("altar_2") then
			d.kill_unique("altar_2")
			item.remove();
			
			d.setf("AndunTemple_5FAltar", 3);
			d.setf("AndunTemple_CanDestroy_Altar", 0);
			
			d.notice("Andun temple: You have destroyed the right one!");
			d.notice("Andun temple: Kill wave of monsters now!");
			
			d.setf("AndunTemple_5w_monsters_k", 1);
			d.regen_file("data/dungeon/andun_temple/regen_5f_mobs_b.txt");
		else
			item.remove();
			d.setf("AndunTemple_CanDestroy_4Stone", 1);
			
			d.spawn_mob(stoneID, 485, 899);
		end
		
	elseif d.getf("AndunTemple_5FAltar") == 3 then
		if npc.get_vid() == d.get_unique_vid("altar_3") then
			d.kill_unique("altar_3")
			item.remove();
			
			d.setf("AndunTemple_5FAltar", 4); 
			d.setf("AndunTemple_CanDestroy_Altar", 0);
			d.setf("AndunTemple_CanDestroy_4Stone", 2);
			
			d.notice("Andun temple: You have destroyed the right one!");
			d.notice(string.format("Andun temple: Destroy all %s now to proceed!", mob_name(stoneID)));
			
			d.regen_file("data/dungeon/andun_temple/regen_5f_stones.txt");
		else
			item.remove();
			
			d.setf("AndunTemple_5w_monsters_k", 1);
			d.regen_file("data/dungeon/andun_temple/regen_5f_mobs_b.txt");
			
			d.notice(string.format("Andun temple: You need to destroy other %s first!", mob_name(npcID)));
			d.notice("Andun temple: Repeat last mission again!");
		end

	elseif d.getf("AndunTemple_5FAltar") == 4 then
		if npc.get_vid() == d.get_unique_vid("altar_4") then
			d.kill_unique("altar_4")
			item.remove();
			
			d.setf("AndunTemple_CanDestroy_Altar", 0);
			d.setf("AndunTemple_CanKillFifthBoss", 1);
			
			d.spawn_mob(4548, 485, 899);
		end	
	end
end

AndunTempleLIB.jumpToSixthFloor = function()
	local settings = AndunTempleLIB.Settings();
	local stoneID = 8727
	local stonePos = settings["6F_stonesPos"]
	local n = number(1,8)
	
	d.setf("AndunTemple_stage", 6);
	d.setf("AndunTemple_Sixthstage", 1);
	d.setf("AndunTemple_CanDestroy_5Stone", 1);
					
	table_shuffle(stonePos);
	
	for i = 1, 8 do
		if (i != n) then
			d.set_unique("fake"..i, d.spawn_mob(stoneID, stonePos[i][1], stonePos[i][2]))
		end
	end
	
	d.set_unique ("real", d.spawn_mob(stoneID, stonePos[n][1], stonePos[n][2]))
	d.spawn_mob_dir(9456, 841, 774, 1);
	d.spawn_mob_dir(9458, 841, 803, 1);
	
	d.jump_all(settings["6Floor_Pos"][1], settings["6Floor_Pos"][2]);
	
	d.notice(string.format("Andun temple: Find the correct %s to proceed!", mob_name(stoneID)));
	d.notice("Andun temple: For every wrong destroyed stone you will get negative points!");
	d.notice(string.format("Andun temple: Those points will affect HP of %s!", mob_name(4549)));
end

AndunTempleLIB.insertSymbol = function()
	local settings = AndunTempleLIB.Settings();
	local DungeonSoulLeftTime = d.get_ui_timer()
	local DungeonSoulTimeNeed = settings["soul_need_sixth_floor"]

	item.remove();
	npc.purge();
	
	d.spawn_mob_dir(9457, 841, 774, 1);
	
	if DungeonSoulLeftTime < DungeonSoulTimeNeed then
		d.setf("AndunTemple_SpawnBosses", 1);
		d.notice("Andun temple: Your soul mana is low, kill random previous boss first!");
	else
		d.notice(string.format("Andun temple: Your soul mana is high, %s is coming!", mob_name(4549)));
	end
	
	server_timer("AndunTemple_FinalBossCheck", settings["time_to_proceed"], d.get_map_index())
end

AndunTempleLIB.spawnRandomBoss = function()
	local settings = AndunTempleLIB.Settings();
	local Boss = settings["Bosses"];
	local boss_pos = settings["6F_BossPos"];
	local n = number(1,5); 			
	
	table_shuffle(Boss);

	d.set_unique ("RandomBoss", d.spawn_mob_dir(Boss[n], boss_pos[1], boss_pos[2], boss_pos[3]))
end

AndunTempleLIB.spawnFinalBoss = function()
	local settings = AndunTempleLIB.Settings();
	local boss_pos = settings["6F_BossPos"];
		
	d.set_unique ("FinalBoss", d.spawn_mob_dir(4549, boss_pos[1], boss_pos[2], boss_pos[3]))
	
	if d.getf("AndunTemple_negative_points") == 0 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_BASIC"])
	elseif d.getf("AndunTemple_negative_points") == 1 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_HIGH_1"])
	elseif d.getf("AndunTemple_negative_points") == 2 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_HIGH_2"])
	elseif d.getf("AndunTemple_negative_points") == 3 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_HIGH_3"])
	elseif d.getf("AndunTemple_negative_points") == 4 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_HIGH_4"])
	elseif d.getf("AndunTemple_negative_points") == 5 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_HIGH_5"])
	elseif d.getf("AndunTemple_negative_points") == 6 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_HIGH_6"])
	elseif d.getf("AndunTemple_negative_points") == 7 then
		d.unique_set_maxhp("ShadowReaper", settings["FINAL_BOSS_HP_HIGH_7"])
	end

	d.setf("AndunTemple_CanKillFinalBoss", 1);
	d.setf("AndunTemple_FinalBossAlive", 1);

	server_timer("AndunTemple_PillarSpawn", settings["time_to_spawn_pillar"], d.get_map_index());
end

AndunTempleLIB.spawnLastPillar = function()
	local settings = AndunTempleLIB.Settings();
	local boss_pos = settings["6F_BossPos"];
	local Time = settings["time_to_kill_pillar"]
	local minutes = math.floor(Time / 60)
	
	d.set_unique ("FinalPillar", d.spawn_mob(8728, boss_pos[1], boss_pos[2]))
	
	d.setf("AndunTemple_pillarAlive", 1);
	
	d.notice(string.format("Andun temple: Destroy %s in %s minutes, otherwise you will loose some mana!", mob_name(8728), minutes));
	
	server_timer("AndunTemple_PillarDestroy", Time, d.get_map_index());
end