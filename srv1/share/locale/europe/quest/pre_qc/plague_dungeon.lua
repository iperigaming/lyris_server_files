quest plague_dungeon begin
	state start begin
	------------------------------
	--QUEST FUNCTIONS AND SETTINGS
	------------------------------
	function settings()
		return
		{
			["plague_dungeon_index"] = 30, ---- Dungeon index
			["plague_dungeon_index_out"] = 61, ---- Map index, where players will be teleported from dungeon [Sohan]
			["out_pos"] = {4996, 2335}, ---- Coordinations, where players will be teleported from dungeon [Sohan]
			["plague_dungeon_pos"] = { ----- Dungeon coords
				[1] = {19803, 1135},
				[2] = {20313, 1820}
			},
			["level_check"] = {
				["minimum"] = 45,
				["maximum"] = 120
			},
			["pass"] = 30734, --- Pass
			["Items"] = {30735, 30736, 30737, 30738, 30739}, 
			-- First floor
			["door1"] = 9252, 				
			["door1_pos"] = {
				[1] = {233, 280, 5},
				[2] = {672, 621, 1}
			},
			["door2"] = 9253, 				
			["door2_pos"] = {
				[1] = {356, 461, 5},
				[2] = {347, 684, 5},
				[3] = {458, 796, 7},
				[4] = {741, 440, 1}
			},
			["guard"] = 9251, 				
			["guard_pos"] = {543, 804},
			["first_metin"] = 8010, 				
			["first_metin_pos"] = {191, 227},
			["second_metin"] = 8437, 				
			["second_metin_pos"] = {345, 607, 677, 696},
			["plague_warrior"] = 9254, 				
			["plague_warrior_pos"] = {370, 590},
			["firstboss"] = 1204, 				
			["firstboss_pos"] = {521, 801},
			["plague_dragon"] = 1205, 				
			["plague_dragon_pos"] = {
				[1] = {678, 695},
				[2] = {739, 378}
			},
			["plague_shaman"] = 9256, 				
			["plague_shaman_pos"] = {755, 416},
			["plague_finalboss"] = 1206, 				
			["plague_finalboss_pos"] = {739, 357},
		};
	end	
	--------PARTY AND ENTER
	function party_get_member_pids()
		local pids = {party.get_member_pids()}
		
		return pids
	end
	
	function is_plagued()
		local pMapIndex = pc.get_map_index();
		local data = plague_dungeon.settings();
		local map_index = data["plague_dungeon_index"];

		return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
	end
	
	function clear_plaguedungeon()
		d.clear_regen();
		d.kill_all();
	end
	
	function clear_plaguetimers()
		clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
		clear_server_timer("plague_dungeon_60min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_45min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_30min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_15min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_10min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_5min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_1min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_0min_left", get_server_timer_arg())
		clear_server_timer("plague_dungeon_final_exit", get_server_timer_arg())
	end
	
	function check_enter()
		addimage(25, 10, "plague_dungeon01.tga")
		addimage(225, 150, "plague_guard.tga")
		say("")
		say("")
		say("")
		say_title(mob_name(9251))
		local settings = plague_dungeon.settings()
		
		if ((get_global_time() - pc.getf("plague_dungeon","exit_plague_dungeon_time")) < 60*60) then
		
			local remaining_wait_time = (pc.getf("plague_dungeon","exit_plague_dungeon_time") - get_global_time() + 60*60)
			say("You have to wait until you can enter the dungeon again.")
			say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return
		end
		
		if party.is_party() then			
			if not party.is_leader() then
				say_reward("Let me talk with your leader first.")
				return
			end

			if party.get_near_count() < 2 then
				say_reward("Your group must have atleast 2 players and")
				say_reward("they have to be around.")
				say_reward("Otherwise i can not let you there. ")
				return false;
			end
			
			local levelCheck = true
			local passCheck = true
			local MemberHaveLowLevel = {}
			local MemberHaveHighLevel = {}
			local MemberHaveNoTicket = {}
			local pids = {party.get_member_pids()}
			
			if not party.is_map_member_flag_lt("exit_plague_dungeon_time", get_global_time() - 60 * 60 ) then
				say_reward("Some people of the group still")
				say_reward("have to wait.")
				return false;
			end
						
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				if pc.get_level() < settings["level_check"]["minimum"] then
					table.insert(MemberHaveLowLevel, pc.get_name())
					levelCheck = false
				end

				q.end_other_pc_block()
			end

			if not levelCheck then
				say_reward("If you want to enter the dungeon,")
				say_reward("every each member must have atleast level 45.")
				say_reward("")
				say_reward("These members has not required level: ")
				for i, n in next, MemberHaveLowLevel, nil do
					say_title("- "..n)
				end
				return
			end
			
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				if pc.get_level() > settings["level_check"]["maximum"] then
					table.insert(MemberHaveHighLevel, pc.get_name())
					levelCheck = false
				end

				q.end_other_pc_block()
			end

			if not levelCheck then
				say_reward("If you want to enter the dungeon,")
				say_reward("every each member must have maximum level 75.")
				say("")
				say_reward("Next members do not have enough level:")
				for i, n in next, MemberHaveHighLevel, nil do
					say_title("- "..n)
				end
				return
			end
			
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				if pc.count_item(settings.pass) < 1 then
					table.insert(MemberHaveNoTicket, pc.get_name())
					passCheck = false
				end

				q.end_other_pc_block()
			end

			if not passCheck then
				say_reward("If you want to enter the dungeon,")
				say_reward("every each member must have:")
				say_item("Plague stone", settings.pass, "")
				say("")
				say_reward("These members don't have the pass:")
				for i, n in next, MemberHaveNoTicket, nil do
					say_title("- "..n)
				end
				return
			end
	
		else
		
			if ((get_global_time() - pc.getf("plague_dungeon","exit_plague_dungeon_time")) < 60*60) then
			
				local remaining_wait_time = (pc.getf("plague_dungeon","exit_plague_dungeon_time") - get_global_time() + 60*60)
				say("You have to wait until you can enter the dungeon again.")
				say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
				return
			end
			
			if (pc.get_level() < settings["level_check"]["minimum"]) then
				say(string.format("The minimum level to enter the dungeon is %d.", settings["level_check"]["minimum"]))
				return false;
			end
			
			if (pc.get_level() > settings["level_check"]["maximum"]) then
				say(string.format("The maximum level to enter the dungeon is %d.", settings["level_check"]["maximum"]))
				return false;
			end
			
			if (pc.count_item(settings["pass"]) < 1) then
				say_reward("If you want to enter the dungeon")
				say_reward("you must have ")
				say_item("Plague stone", settings.pass, "")
				return false;
			end
		end
		
		return true;
	end
	
	------------CREATE DUNGEON
	function create_dungeon()
		local setting = plague_dungeon.settings()
		local pids = {party.get_member_pids()}
		
		if party.is_party() then
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				pc.remove_item(setting["pass"], 1)
				q.end_other_pc_block()
			end
			d.new_jump_party(setting["plague_dungeon_index"], setting["plague_dungeon_pos"][1][1], setting["plague_dungeon_pos"][1][2])
			d.setf("plague_dungeon_level", 1)
			d.regen_file("data/dungeon/plague_dungeon/regen_1a.txt")
			d.spawn_mob_dir(setting["door1"], setting["door1_pos"][1][1], setting["door1_pos"][1][2], setting["door1_pos"][1][3])
			server_timer("plague_dungeon_60min_left", 15*60, d.get_map_index())
			server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
		else
			pc.remove_item(setting["pass"], 1)
			d.new_jump(setting["plague_dungeon_index"], setting["plague_dungeon_pos"][1][1]*100, setting["plague_dungeon_pos"][1][2]*100)
			d.setf("plague_dungeon_level", 1)
			d.regen_file("data/dungeon/plague_dungeon/regen_1a.txt")
			d.spawn_mob_dir(setting["door1"], setting["door1_pos"][1][1], setting["door1_pos"][1][2], setting["door1_pos"][1][3])
			server_timer("plague_dungeon_60min_left", 15*60, d.get_map_index())
			server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
		end
	end
		
-----------LOGIN IN Map
		when login with plague_dungeon.is_plagued() begin
			local settings = plague_dungeon.settings()
						
			d.set_warp_location(settings["plague_dungeon_index_out"], settings["out_pos"][1], settings["out_pos"][2]);
			if not pc.is_gm() then
				if not pc.in_dungeon() then
					pc.warp(settings["plague_dungeon_index_out"], settings["out_pos"][1]*100, settings["out_pos"][2]*100)
				end
			end
		end


		--DUNGEON ENTER
		when 9251.chat."Plague dungeon" with not plague_dungeon.is_plagued() begin
			local settings = plague_dungeon.settings()
			addimage(25, 10, "plague_dungeon01.tga")
			addimage(225, 150, "plague_guard.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9251))
			say("")
			say("I think you saw the plague monsters")
			say("here on Sohan. It's normal..")
			say("But now, the infection they have is")
			say("attacks to all creatures. I'm infected")
			say("aswell. And it is worse.")
			say("We've discovered this entrance.")
			say("You can get into corridors full of ")
			say("plagued monsters.")
			wait()
			addimage(25, 10, "plague_dungeon01.tga")
			addimage(225, 150, "plague_guard.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9251))
			say("")
			say("The infection is everywhere. We have to")
			say("stop it!")
			say("")
			say_title("Do you really want to enter this place? ")
			if (select ("Yes", "No") == 1) then
				if plague_dungeon.check_enter() then
					say("")
					say_reward("You have 60 minutes to finish this dungeon!!")
					say_reward("Otherwise you will be teleported back here.")
					wait()
					plague_dungeon.create_dungeon()
				end
			end
		end
		
		when 9251.chat."Time reset" with pc.is_gm() begin
			addimage(25, 10, "plague_dungeon01.tga")
			say("")
			say("")
			say("")
			if select('Reset time','Close') == 2 then return end
				addimage(25, 10, "plague_dungeon01.tga")
				say("")
				say("")
				say("")
				say_title(mob_name(9251))
				say("")
				say("Time has been reseted.")
				pc.setf('plague_dungeon','exit_plague_dungeon_time', 0)
				
				-- Dungeon Info
				pc.setqf("rejoin_time", get_time() - 3600)
		end	
-----------------------------------------------------------------------------
---------Dungeon
-----------------------------------------------------------------------------

---------DOOR OPENING

		----SMALL DOOR
		when 9252.take with item.get_vnum() == 30735 and plague_dungeon.is_plagued() begin
			local settings = plague_dungeon.settings()
			-----1. FLOOR
			if d.getf("plague_dungeon_level") == 3 then
				addimage(25, 10, "plague_dungeon02.tga")
				say("")
				say("")
				say("")
				say_title("Second floor")
				say("")
				say("Good job!")
				say("That was pretty easy.")
				say("Next floor looks easy aswell.")
				say("But be ready! The beasts are waiting")
				say("in the deep.")
				wait()
				d.kill_all()
				pc.remove_item(settings["Items"][1], 1)
				d.setf("plague_dungeon_level", 4)
				d.notice("Plague dungeon: The door into plagued corridors are open!")
				d.regen_file("data/dungeon/plague_dungeon/regen_2a.txt")
				d.spawn_mob_dir(settings["door2"], settings["door2_pos"][1][1], settings["door2_pos"][1][2], settings["door2_pos"][1][3])
				server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
			elseif d.getf("plague_dungeon_level") == 26 then
				d.kill_all()
				pc.remove_item(settings["Items"][1], 1)
				d.setf("plague_dungeon_level", 27)
				d.notice("Plague dungeon: Kill the monsters until you drop a key!")
				d.set_regen_file("data/dungeon/plague_dungeon/regen_6a.txt")
				d.spawn_mob_dir(settings["door2"], settings["door2_pos"][4][1], settings["door2_pos"][4][2], settings["door2_pos"][4][3])
			end
		end
		
		----- BIG DOOR
		when 9253.take with item.get_vnum() == 30736 and plague_dungeon.is_plagued() begin 
			local settings = plague_dungeon.settings()
			-----2. FLOOR
			if d.getf("plague_dungeon_level") == 6 then
				d.kill_all()
				d.notice("Plague dungeon: Oh look! Warrior is lying there!")
				pc.remove_item(settings["Items"][2], 1)
				d.setf("plague_dungeon_level", 7)
				d.spawn_mob(settings["plague_warrior"], settings["plague_warrior_pos"][1], settings["plague_warrior_pos"][2])
				d.spawn_mob_dir(settings["door2"], settings["door2_pos"][2][1], settings["door2_pos"][2][2], settings["door2_pos"][2][3])
			----3. FLOOR
			elseif d.getf("plague_dungeon_level") == 11 then
				d.kill_all()
				d.notice("Plague dungeon: This place is starting to be dangerous..")
				pc.remove_item(settings["Items"][2], 1)
				d.setf("plague_dungeon_level", 12)
				d.regen_file("data/dungeon/plague_dungeon/regen_4a.txt")
				d.spawn_mob_dir(settings["door2"], settings["door2_pos"][3][1], settings["door2_pos"][3][2], settings["door2_pos"][3][3])
				server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
			elseif d.getf("plague_dungeon_level") == 14 then
				d.kill_all()
				d.notice("Plague dungeon: Kill this disgusting beast!")
				pc.remove_item(settings["Items"][2], 1)
				d.setf("plague_dungeon_level", 15)
				d.spawn_mob(settings["firstboss"], settings["firstboss_pos"][1], settings["firstboss_pos"][2])
			elseif d.getf("plague_dungeon_level") == 28 then
				plague_dungeon.clear_plaguedungeon()
				d.notice("Plague dungeon: This is the nest!")
				d.notice("Plague dungeon: Look! Shaman right there!")
				pc.remove_item(settings["Items"][2], 1)
				d.setf("plague_dungeon_level", 29)
				d.spawn_mob(settings["plague_shaman"], settings["plague_shaman_pos"][1], settings["plague_shaman_pos"][2])
			end
		end
		
-----------1. FLOOR
		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and npc.get_race() == 8010 begin
			local settings = plague_dungeon.settings()
			if d.getf("plague_dungeon_level") == 2 then
				d.setf("plague_dungeon_level", 3)
				game.drop_item(settings["Items"][1], 1)
				d.notice("Plague dungeon: Open the door into plagued corridors!")
----------2. FLOOR
			elseif d.getf("plague_dungeon_level") == 5 then
				local kills = 5;
				d.setf("plague_dungeon_metin1", d.getf("plague_dungeon_metin1")+1);
				if (d.getf("plague_dungeon_metin1") < kills) then
					d.notice(string.format("Plague dungeon: %d stones has left!", kills-d.getf("plague_dungeon_metin1")))
				else
					d.notice("Plague dungeon: All stones are destroyed!")
					d.notice("Plague dungeon: Let's open the door!")
					d.setf("plague_dungeon_level", 6)
					game.drop_item(settings["Items"][2], 1)
				end -- if/else
			end
		end
		
-----------3. FLOOR
		when 9254.chat."What happened?" with plague_dungeon.is_plagued() and d.getf("plague_dungeon_level") == 7 begin
			local settings = plague_dungeon.settings()
			addimage(25, 10, "plague_dungeon02.tga")
			say("")
			say("")
			say("")
			say_title("Plagued warrior")
			say("")
			if party.is_party() then
				if not party.is_leader() then
					say_reward("I need to talk with your leader!")
					return
				end
			end
			say("We were on exploration of these corrdiors.")
			say("But they are everywhere!")
			say("They are hiding, but they are everywhere!")
			say("Be really careful!")
			wait()
			addimage(25, 10, "plague_dungeon02.tga")
			say("")
			say("")
			say("")
			say_title("Plagued warrior")
			say("")
			say("Help me please!")
			say("Bring me ")
			say_item("Taint potion", settings["Items"][3], "")
			say("Maybe it's too late but we can try it")
			wait()
			d.regen_file("data/dungeon/plague_dungeon/regen_3a.txt")
		end
		
		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and npc.get_race() == 993 and d.getf("plague_dungeon_level") == 7 begin
			local settings = plague_dungeon.settings()
			local kills = 11;
			d.setf("plague_dungeon_nosic1", d.getf("plague_dungeon_nosic1")+1);
			if (d.getf("plague_dungeon_nosic1") < kills) then
				d.notice(string.format("Plague dungeon: %d %s has left!", kills-d.getf("plague_dungeon_nosic1"), mob_name(993)))
			else
				d.notice(string.format("Plague dungeon: You've succefuly killed all %s!", mob_name(993)))
				d.notice("Plague dungeon: Be careful! Monsters are coming!")
				d.setf("plague_dungeon_level", 8)
				d.regen_file("data/dungeon/plague_dungeon/regen_3b.txt")
				server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
			end -- if/else
		end -- when
		
		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and npc.get_race() == 8437 begin
			local settings = plague_dungeon.settings()
			if d.getf("plague_dungeon_level") == 9 then
				d.setf("plague_dungeon_level", 10)
				game.drop_item(settings["Items"][3], 1)
				d.notice("Plague dungeon: Give the potion to plagued warrior!")
			----4. FLOOR
			elseif d.getf("plague_dungeon_level") == 13 then
				local kills1 = 2;
				d.setf("plague_dungeon_metin2", d.getf("plague_dungeon_metin2")+1);
				if (d.getf("plague_dungeon_metin2") < kills1) then
					d.notice(string.format("Plague dungeon: %d stone has left!", kills1-d.getf("plague_dungeon_metin2")))
				else
					d.notice("Plague dungeon: Perfect!")
					d.notice("Plague dungeon: Let's open next door!")
					d.setf("plague_dungeon_level", 14)
					game.drop_item(settings["Items"][2], 1)
				end -- if/else
			elseif d.getf("plague_dungeon_level") == 17 then
				game.drop_item(settings["Items"][4], 1)
				d.notice("Plague dungeon: Open first seal!")
			elseif d.getf("plague_dungeon_level") == 23 then
				game.drop_item(settings["Items"][4], 1)
				d.notice("Plague dungeon: Open next seal!")
			end
		end

		when 9254.take with item.get_vnum() == 30737 and plague_dungeon.is_plagued() and d.getf("plague_dungeon_level") == 10 begin
			local settings = plague_dungeon.settings()
			addimage(25, 10, "plague_dungeon02.tga")
			say("")
			say("")
			say("")
			say_title("Plagued warrior")
			say("")
			say("Ohh... It's too late..")
			say("I'm dying.. here is key for")
			say("next door.")
			say("Good luck!")
			wait()
			pc.remove_item(settings["Items"][3], 1)
			pc.give_item2(settings["Items"][2], 1)
			d.setf("plague_dungeon_level", 11)
			npc.kill()
		end

-----------5.FLOOR
		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and npc.get_race() == 1204 begin
			local settings = plague_dungeon.settings()
			if d.getf("plague_dungeon_level") == 15 then
				d.notice(string.format("Plague dungeon: You've succefuly killed %s!", mob_name(1204)))
				d.notice("Plague dungeon: You will jump to next level in 10 seconds.")
				d.setf("plague_dungeon_level", 16)
				server_timer("plague_jumper", 10, d.get_map_index())
			elseif d.getf("plague_dungeon_level") == 20 then
				local kills_4 = 2;
				d.setf("plague_dungeon_boss1b", d.getf("plague_dungeon_boss1b")+1);
				if (d.getf("plague_dungeon_boss1b") < kills_4) then
					d.notice(string.format("Plague dungeon: %d %s has left!", kills_4-d.getf("plague_dungeon_boss1b"), mob_name(1204)))
				else
					d.notice("Plague dungeon: Let's open next seal!!")
					d.setf("plague_dungeon_level", 21)
					game.drop_item(settings["Items"][4], 1)
				end -- if/else
			end
		end -- when

-----------6.FLOOR

		when 9255.take with item.get_vnum() == 30738 and plague_dungeon.is_plagued() begin
			local settings = plague_dungeon.settings()
			if d.getf("plague_dungeon_level") == 17 then
				addimage(25, 10, "plague_dungeon04.tga")
				say("")
				say("")
				say("")
				say_title("Sixth floor")
				say("")
				say("Good job.")
				say("Destroy all metin stones to get next")
				say("ancient stone.")
				wait()
				npc.kill()
				pc.remove_item(settings["Items"][4], 1)
				d.setf("plague_dungeon_level", 18)
				d.regen_file("data/dungeon/plague_dungeon/regen_5c.txt")
			elseif d.getf("plague_dungeon_level") == 19 then
				addimage(25, 10, "plague_dungeon05.tga")
				say("")
				say("")
				say("")
				say_title("Sixth floor")
				say("")
				say("You're doing well!")
				say("Be careful now!")
				say("Evil creatures are still waiting")
				say("in the shadows!")
				wait()
				npc.kill()
				pc.remove_item(settings["Items"][4], 1)
				d.setf("plague_dungeon_level", 20)
				d.regen_file("data/dungeon/plague_dungeon/regen_5d.txt")
			elseif d.getf("plague_dungeon_level") == 21 then
				addimage(25, 10, "plague_dungeon06.tga")
				say("")
				say("")
				say("")
				say_title("Sixth floor")
				say("")
				say("Another wave of monsters is coming!")
				say("It seems like endless floor.")
				wait()
				npc.kill()
				pc.remove_item(settings["Items"][4], 1)
				d.setf("plague_dungeon_level", 22)
				d.regen_file("data/dungeon/plague_dungeon/regen_5e.txt")
				server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
			elseif d.getf("plague_dungeon_level") == 23 then
				addimage(25, 10, "plague_dungeon07.tga")
				say("")
				say("")
				say("")
				say_title("Sixth floor")
				say("")
				say("Monsters are gone..")
				say("But something bigger is coming!")
				wait()
				npc.kill()
				pc.remove_item(settings["Items"][4], 1)
				d.setf("plague_dungeon_level", 24)
				d.spawn_mob(settings["plague_dragon"], settings["plague_dragon_pos"][1][1], settings["plague_dragon_pos"][1][2])
			elseif d.getf("plague_dungeon_level") == 25 then
				npc.kill()
				pc.remove_item(settings["Items"][4], 1)
				game.drop_item(settings["Items"][1], 1)
				d.notice("Plague dungeon: You have a key to next floor")
				d.setf("plague_dungeon_level", 26)
			end
		end
		
		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and npc.get_race() == 8438 and d.getf("plague_dungeon_level") == 18 begin
			local settings = plague_dungeon.settings()
			local kills_3 = 6;
			d.setf("plague_dungeon_metin3", d.getf("plague_dungeon_metin3")+1);
			if (d.getf("plague_dungeon_metin3") < kills_3) then
				d.notice(string.format("Plague dungeon: %d stones has left!", kills_3-d.getf("plague_dungeon_metin3")))
			else
				d.notice("Plague dungeon: You've succefuly destroyed all stones!")
				d.setf("plague_dungeon_level", 19)
				game.drop_item(settings["Items"][4], 1)
			end -- if/else
		end -- when


		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and npc.get_race() == 1205 begin
			local settings = plague_dungeon.settings()
			if d.getf("plague_dungeon_level") == 24 then
				d.setf("plague_dungeon_level", 25)
				game.drop_item(settings["Items"][4], 1)
				d.notice("Plague dungeon: Open the final seal!")
			elseif d.getf("plague_dungeon_level") == 30 then
				d.setf("plague_dungeon_level", 31)
				game.drop_item(settings["Items"][5], 1)
				d.notice("Plague dungeon: You got the crystal!!")
				d.notice("Plague dungeon: Give it to plague shaman!")
			end
		end
		
-----------7.FLOOR
		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and d.getf("plague_dungeon_level") == 27 begin
			local settings = plague_dungeon.settings()
			if number(1,120) == 1 then
				game.drop_item(settings["Items"][2], 1);
				d.setf("plague_dungeon_level", 28)
				d.clear_regen();
			end
		end

----------8.FLOOR
		when 9256.chat."Are you alive?" with plague_dungeon.is_plagued() and d.getf("plague_dungeon_level") == 29 begin
			local settings = plague_dungeon.settings()
			addimage(25, 10, "plague_dungeon08.tga")
			say("")
			say("")
			say("")
			say_title("Plagued shaman")
			say("")
			if party.is_party() then
				if not party.is_leader() then
					say_reward("I need to talk with your leader!")
					say_reward("Plea....")
					say("")
					say("")
					say_reward("Please....")
					return
				end
			end
			say("Evil power is controling me.")
			say("I can not do anything.")
			say("This place is diseased!")
			say("I heard that")
			say_item("Plague crystal", settings["Items"][5], "")
			say("can remove all symptoms of plague.")
			wait()
			addimage(25, 10, "plague_dungeon08.tga")
			say("")
			say("")
			say("")
			say_title("Plagued shaman")
			say("")
			say("I have no idea if it works, but we")
			say("ha...")
			say("have to try it")
			say("PLEASE!!")
			wait()
			d.regen_file("data/dungeon/plague_dungeon/regen_7a.txt")
			server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
		end

		when 9256.take with item.get_vnum() == 30739 and plague_dungeon.is_plagued() and d.getf("plague_dungeon_level") == 31 begin
			local settings = plague_dungeon.settings()
			addimage(25, 10, "plague_dungeon08.tga")
			say("")
			say("")
			say("")
			say_title("Plagued shaman")
			say("")
			say("It..")
			say("It's not working...")
			say("Noooo....!!!!")
			say("Thank you!")
			say("Good bye!!")
			wait()
			pc.remove_item(settings["Items"][5], 1)
			d.setf("plague_dungeon_level", 32)
			npc.kill()
			d.notice("Plague dungeon: Shaman is dead")
			d.notice(string.format("Plague dungeon: %s is coming!", mob_name(settings["plague_finalboss"])))
			d.spawn_mob(settings["plague_finalboss"], settings["plague_finalboss_pos"][1], settings["plague_finalboss_pos"][2])			
		end
		 
		when kill with plague_dungeon.is_plagued() and not npc.is_pc() and npc.get_race() == 1206 and d.getf("plague_dungeon_level") == 32 begin
			local settings = plague_dungeon.settings()
			plague_dungeon.clear_plaguetimers()
			server_timer("plague_dungeon_final_exit", 2*60, d.get_map_index())
			d.setf("plague_dungeon_level", 33)
			d.notice("Plague dungeon: You did it!")
			d.notice(string.format("Plague dungeon: You beated %s!", mob_name(settings["plague_finalboss"])))
			d.notice("You will be teleported out of dungeon in 2 minutes")
		end

------- TIMERS
		when plague_dungeon_wave_kill.server_timer begin
			local settings = plague_dungeon.settings()
			if d.select(get_server_timer_arg()) then
				if d.getf("plague_dungeon_level") == 1 then
					if d.count_monster() == 0 then
						clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
						d.setf("plague_dungeon_level", 2)
						d.notice("Plague dungeon: You've killed all monsters!")
						d.notice("Plague dungeon: Now destroy the metin stone!")
						d.spawn_mob(settings["first_metin"], settings["first_metin_pos"][1], settings["first_metin_pos"][2])
					else
						d.notice(string.format("Plague dungeon: You still have to defeat %d monsters to move on.", d.count_monster()));
					end
				elseif d.getf("plague_dungeon_level") == 4 then
					if d.count_monster() == 0 then
						clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
						d.setf("plague_dungeon_level", 5)
						d.notice("Plague dungeon: You've killed all monsters!")
						d.notice("Plague dungeon: Destroy all metinstones to get a key!")
						d.regen_file("data/dungeon/plague_dungeon/regen_2b.txt")
					else
						d.notice(string.format("Plague dungeon: You still have to defeat %d monsters to move on.", d.count_monster()));
					end
				elseif d.getf("plague_dungeon_level") == 8 then
					if d.count_monster() == 0 then
						clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
						d.setf("plague_dungeon_level", 9)
						d.notice("Plague dungeon: You've killed all monsters!")
						d.notice("Plague dungeon: Look, what a wierd stone!!")
						d.notice("Plague dungeon: Destroy it!!")
						d.spawn_mob(settings["second_metin"], settings["second_metin_pos"][1], settings["second_metin_pos"][2])
					else
						d.notice(string.format("Plague dungeon: You still have to kill %d monsters to move on.", d.count_monster()));
					end
				elseif d.getf("plague_dungeon_level") == 12 then
					if d.count_monster() == 0 then
						clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
						d.setf("plague_dungeon_level", 13)
						d.notice("Plague dungeon: You've killed all monsters!")
						d.notice("Plague dungeon: The wierd stone again....")
						d.regen_file("data/dungeon/plague_dungeon/regen_4b.txt")
					else
						d.notice(string.format("Plague dungeon: You still have to kill %d monsters to move on.", d.count_monster()));
					end
				elseif d.getf("plague_dungeon_level") == 16 then
					if d.count_monster() == 0 then
						clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
						d.setf("plague_dungeon_level", 17)
						d.notice("Plague dungeon: You've killed all monsters!")
						d.notice("Plague dungeon: Destroy the metin to get an Ancient stone!")
						d.spawn_mob(settings["second_metin"], settings["second_metin_pos"][3], settings["second_metin_pos"][4])
					else
						d.notice(string.format("Plague dungeon: You still have to kill %d monsters to move on.", d.count_monster()));
					end
				elseif d.getf("plague_dungeon_level") == 22 then
					if d.count_monster() == 0 then
						clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
						d.setf("plague_dungeon_level", 23)
						d.notice("Plague dungeon: You've killed all monsters!")
						d.notice("Plague dungeon: Destroy the metin to get the Ancient stone!")
						d.spawn_mob(settings["second_metin"], settings["second_metin_pos"][3], settings["second_metin_pos"][4])
					else
						d.notice(string.format("Plague dungeon: You still have to kill %d monsters to move on.", d.count_monster()));
					end
				elseif d.getf("plague_dungeon_level") == 29 then
					if d.count_monster() == 0 then
						clear_server_timer("plague_dungeon_wave_kill", get_server_timer_arg())
						d.setf("plague_dungeon_level", 30)
						d.notice("Plague dungeon: Oh my Lord! It's not the end..")
						d.notice(string.format("Plague dungeon: Another %s is coming!", mob_name(1205)))
						d.spawn_mob(settings["plague_dragon"], settings["plague_dragon_pos"][2][1], settings["plague_dragon_pos"][2][2])
					else
						d.notice(string.format("Plague dungeon: You still have to liquidate %d monsters to move on.", d.count_monster()));
					end
				end
			end
		end
		
		when plague_jumper.server_timer begin
			local settings = plague_dungeon.settings()
			if d.select(get_server_timer_arg()) then
				d.jump_all(settings["plague_dungeon_pos"][2][1], settings["plague_dungeon_pos"][2][2])
				d.notice("Plague dungeon: You will need to open all seals.")
				d.notice("Plague dungeon: This is the only way.")
				d.notice("Plague dungeon: At first, kill all those monsters!")
				d.regen_file("data/dungeon/plague_dungeon/regen_5a.txt")
				d.regen_file("data/dungeon/plague_dungeon/regen_5b.txt")
				d.spawn_mob_dir(settings["door1"], settings["door1_pos"][2][1], settings["door1_pos"][2][2], settings["door1_pos"][2][3])
				server_loop_timer("plague_dungeon_wave_kill", 15, d.get_map_index())
			end
		end
		
		when plague_dungeon_60min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Plague dungeon: 45 minutes left!!!")
				server_timer("plague_dungeon_45min_left", 15*60, d.get_map_index())
			end
		end
		
		when plague_dungeon_45min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Plague dungeon: 30 minutes left!!!")
				server_timer("plague_dungeon_30min_left", 15*60, d.get_map_index())
			end
		end
		
		when plague_dungeon_30min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Plague dungeon: 15 minutes left!!!")
				server_timer("plague_dungeon_15min_left", 5*60, d.get_map_index())
			end
		end
		
		when plague_dungeon_15min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Plague dungeon: 10 minutes left!!! The time is running out!")
				server_timer("plague_dungeon_10min_left", 5*60, d.get_map_index())
			end
		end
		
		when plague_dungeon_10min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Plague dungeon: 5 minutes left!!! Hurry up!!")
				server_timer("plague_dungeon_5min_left", 4*60, d.get_map_index())
			end
		end
		
		when plague_dungeon_5min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Plague dungeon: 1 minute left!!! You almost failder!!")
				server_timer("plague_dungeon_1min_left", 60, d.get_map_index())
			end
		end
		
		when plague_dungeon_1min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Plague dungeon: The time is out. You will be teleported")
				server_timer("plague_dungeon_final_exit", 3, d.get_map_index())
			end
		end
		
		when plague_dungeon_final_exit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all()
			end
		end
		
		when logout with plague_dungeon.is_plagued() begin 
			pc.setf("plague_dungeon","exit_plague_dungeon_time", get_global_time())
			pc.setqf("plague_dungeon", get_time() + 3600)
		end		
	end
end	
		
		
