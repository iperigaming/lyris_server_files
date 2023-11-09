quest ChamberWisdom_zone begin
	state start begin
		when login with ChamberWisdomLIB.isActive() begin
			local settings = ChamberWisdomLIB.Settings();			
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				server_timer("ChamberWisdom_FinalExit", settings["dungeon_timer"], d.get_map_index()) ---- Full dungeon timer
				d.set_regen_file("data/dungeon/chamber_of_wisdom/regen_books.txt");
				d.setf("ChamberWisdom_level", 1); d.setf("ChamberWisdom_1st_stone", 1); d.setf("ChamberWisdom_book_mech", 1);
				pc.setqf("ChamberWisdom_reward", 0)
						
				ChamberWisdomLIB.spawnBooks()
				ChamberWisdomLIB.setOutCoords()
				
				d.spawn_mob_dir(9346, 270, 306, 5)				
				d.spawn_mob(8480, 273, 266)
			end
		end
		
		--Destroying first stone
		when 8480.kill with ChamberWisdomLIB.isActive() and not npc.is_pc() and d.getf("ChamberWisdom_level") == 1 begin
			local settings = ChamberWisdomLIB.Settings();			
			if d.getf("ChamberWisdom_1st_stone") == 1 then
				game.drop_item(settings["Item_Key"], 1);
				d.setf("ChamberWisdom_1st_stone", 0);
			end
		end
		
		---Putting keys to locked books, if you put key to wrong book, you have to repeat the actual quest again until you unlock the right book
		when 9345.take with item.get_vnum() == 30812 and ChamberWisdomLIB.isActive() and d.getf("ChamberWisdom_level") == 1 begin
			local settings = ChamberWisdomLIB.Settings();			
			if d.getf("ChamberWisdom_book_mech") == 1 then
				if npc.get_vid() == d.get_unique_vid("protected_book_1") then
					d.kill_unique("protected_book_1")
					item.remove();
					game.drop_item(settings["Item_Books"][1], 1);
					d.setf("ChamberWisdom_book_mech", 2);
					
					d.notice("Chamber of wisdom: You have unlocked the right one!");
					d.notice("Chamber of wisdom: Be careful, monsters are coming!");
					
					timer("ChamberWisdom_1stwave_spawn", 10)
				else
					item.remove();
					d.setf("ChamberWisdom_1st_stone", 1);
					d.spawn_mob(8480, 273, 266);
					
					d.notice(string.format("Chamber of wisdom: You need to unlock other %s first!", mob_name(9345)));
				end
				
			elseif d.getf("ChamberWisdom_book_mech") == 2 then
				if npc.get_vid() == d.get_unique_vid("protected_book_2") then
					d.kill_unique("protected_book_2")
					item.remove();
					game.drop_item(settings["Item_Books"][2], 1);
					d.setf("ChamberWisdom_book_mech", 3);
					
					d.notice("Chamber of wisdom: You have unlocked the right one!");
					d.notice("Chamber of wisdom: Destroy all stones now!");
					
					timer("ChamberWisdom_2ndwave_spawn", 10)
				else
					item.remove();
					d.setf("ChamberWisdom_1st_stone", 1);
					timer("ChamberWisdom_1stwave_spawn", 10)
					
					d.notice(string.format("Chamber of wisdom: You need to unlock other %s first!", mob_name(9345)));
					d.notice("Chamber of wisdom: Monsters are coming again!");
				end
				
			elseif d.getf("ChamberWisdom_book_mech") == 3 then
				if npc.get_vid() == d.get_unique_vid("protected_book_3") then
					d.kill_unique("protected_book_3")
					item.remove();
					game.drop_item(settings["Item_Books"][3], 1);
					d.setf("ChamberWisdom_book_mech", 4);
					
					d.notice("Chamber of wisdom: You have unlocked the right one!");
					d.notice("Chamber of wisdom: Kill another wave of monsters");
					
					timer("ChamberWisdom_3rdwave_spawn", 10)
				else
					item.remove();
					timer("ChamberWisdom_2ndwave_spawn", 10)
					
					d.notice(string.format("Chamber of wisdom: You need to unlock other %s first!", mob_name(9345)));
					d.notice("Chamber of wisdom: Destroy again all stones!");
				end
				
			elseif d.getf("ChamberWisdom_book_mech") == 4 then
				if npc.get_vid() == d.get_unique_vid("protected_book_4") then
					d.kill_unique("protected_book_4")
					item.remove();
					game.drop_item(settings["Item_Books"][4], 1);
					d.setf("ChamberWisdom_level", 2); d.setf("ChamberWisdom_book_mech", 0);
					
					d.notice("Chamber of wisdom: You have unlocked the right one!");
					d.notice(string.format("Chamber of wisdom: Take all the books to %s", mob_name(9346)));
				end
			end
		end
		
		----Spawning first wave of monsters
		when ChamberWisdom_1stwave_spawn.timer begin
			d.regen_file("data/dungeon/chamber_of_wisdom/regen_1f_a.txt");			
			d.setf("ChamberWisdom_monsters_1c", d.count_monster()); d.setf("ChamberWisdom_monsters_1", 1);
		end
		
		
		---Killing first wave of monsters
		when kill with ChamberWisdomLIB.isActive() and not npc.is_pc() and d.getf("ChamberWisdom_monsters_1") == 1 begin
			local settings = ChamberWisdomLIB.Settings();			
			if pc.get_x() > 11464 and pc.get_y() > 22728 and pc.get_x() < 11604 and pc.get_y() < 22886 then				
				
				d.setf("ChamberWisdom_monsters_1c", d.getf("ChamberWisdom_monsters_1c")-1)	
				if d.getf("ChamberWisdom_monsters_1c") < 1 then
					d.setf("ChamberWisdom_monsters_1", 0); d.setf("ChamberWisdom_monsters_1c", 0);
					
					game.drop_item(settings["Item_Key"], 1);
				end
			end
		end
		
		---Spawning 8 stones
		when ChamberWisdom_2ndwave_spawn.timer begin
			d.regen_file("data/dungeon/chamber_of_wisdom/regen_1f_b.txt");			
			d.setf("ChamberWisdom_stone_2", 1);
		end
		
		----Destroying of all 8 stones
		when 8481.kill with ChamberWisdomLIB.isActive() and not npc.is_pc() and d.getf("ChamberWisdom_level") == 1 begin
			local settings = ChamberWisdomLIB.Settings(); local Stone_count = 8;
			
			if d.getf("ChamberWisdom_stone_2") == 1 then
				d.setf("ChamberWisdom_stone_2_k", d.getf("ChamberWisdom_stone_2_k")+1);
				if (d.getf("ChamberWisdom_stone_2_k") < Stone_count) then
					d.notice(string.format("Chamber of wisdom: %d stones has left!", Stone_count-d.getf("ChamberWisdom_stone_2_k")))
				else
					d.setf("ChamberWisdom_stone_2", 0); d.setf("ChamberWisdom_stone_2_k", 0);
					game.drop_item(settings["Item_Key"], 1);
				end
			end
		end
		
		---Spawning second wave of monsters
		when ChamberWisdom_3rdwave_spawn.timer begin
			d.regen_file("data/dungeon/chamber_of_wisdom/regen_1f_c.txt");			
			d.setf("ChamberWisdom_monsters_2c", d.count_monster()); d.setf("ChamberWisdom_monsters_2", 1);
		end
		
		----Killing second wave of monsters
		when kill with ChamberWisdomLIB.isActive() and not npc.is_pc() and d.getf("ChamberWisdom_monsters_2") == 1 begin
			local settings = ChamberWisdomLIB.Settings();
			
			if pc.get_x() > 11464 and pc.get_y() > 22728 and pc.get_x() < 11604 and pc.get_y() < 22886 then				
				
				d.setf("ChamberWisdom_monsters_2c", d.getf("ChamberWisdom_monsters_2c")-1)	
				if d.getf("ChamberWisdom_monsters_2c") < 1 then
					d.setf("ChamberWisdom_monsters_2", 0);
					
					game.drop_item(settings["Item_Key"], 1);
				end
			end
		end
		
		----Talking with professor, you need all 4 book items collected from locked books, after that, boss is spawned
		when 9346.chat."I have the books" with ChamberWisdomLIB.isActive() and d.getf("ChamberWisdom_level") == 2 begin
			local settings = ChamberWisdomLIB.Settings(); local Items = settings["Item_Books"];		
			
			if pc.count_item(Items[1]) < 1 or pc.count_item(Items[2]) < 1 or pc.count_item(Items[3]) < 1 or pc.count_item(Items[4]) < 1 then 
				setskin(NOWINDOW)
				syschat("Chamber of wisdom: You need all 4 books!")
			else
			
				for index = 1, table.getn(Items) do
					pc.remove_item(Items[index], pc.count_item(Items[index]));
				end
				
				addimage(25, 10, "chamber_wisdom_bg1.tga"); addimage(225, 150, "chamber_npc3.tga")
				say("[ENTER][ENTER]")
				say_title(string.format("%s:", mob_name(npc.get_race())))
				say("These books are very important! They knew why they hide it![ENTER]These books contains a special spells to avoid[ENTER]dark power on this place.[ENTER]This place was build by great magician! So they[ENTER]knew what they were doing![ENTER]I will take the books and send all[ENTER]these monsters to darkness again!")
				wait()				
				setskin(NOWINDOW)
				npc.kill()
				
				d.notice("Chamber of wisdom: They have killed him!")
				d.notice("Chamber of wisdom: Something big is coming!")
				
				timer("ChamberWisdom_boss_reveal", 10)
			end
		end
		
		----Spawn of the final boss
		when ChamberWisdom_boss_reveal.timer begin
			local settings = ChamberWisdomLIB.Settings();
			
			d.set_unique("final_boss", d.spawn_mob(settings["boss_data"][1], settings["boss_data"][2], settings["boss_data"][3]))
			d.setf("ChamberWisdom_boss_kill", 1);
		end
		
		---Killing the final boss
		when 4311.kill with ChamberWisdomLIB.isActive() and d.getf("ChamberWisdom_level") == 2 and d.getf("ChamberWisdom_boss_kill") == 1 begin
			local settings = ChamberWisdomLIB.Settings();
			
			d.setf("ChamberWisdom_boss_kill", 0); d.setf("ChamberWisdom_can_take_reward", 1);
			ChamberWisdomLIB.clearTimers()
			d.spawn_mob_dir(9347, 270, 306, 1)
			
			d.notice("Chamber of wisdom: You have killed the monster!")
			server_timer("ChamberWisdom_FinalExitOut", settings["dungeon_timer_out"], d.get_map_index()) 
		end
		
		---Taking reward from magical shelf
		when 9347.chat."What is inside?" with ChamberWisdomLIB.isActive() and d.getf("ChamberWisdom_can_take_reward") == 1 begin
			local settings = ChamberWisdomLIB.Settings();
			local Reward = settings["Item_Reward"];
			local randomNumber = number(1, table.getn(Reward));
			
			if pc.getqf("ChamberWisdom_reward") == 0 then
				if pc.count_item(settings["Item_To_Reward"]) >= 1 then
					pc.remove_item(settings["Item_To_Reward"], 1)
					addimage(25, 10, "chamber_wisdom_bg1.tga");
					say("[ENTER][ENTER]")
					say_title(string.format("%s:", mob_name(npc.get_race())))
					say("Well done! You have found something amazing[ENTER]inside!!")
					pc.give_item2(tonumber(Reward[randomNumber]))
					pc.setqf("ChamberWisdom_reward", 1)
				else
					setskin(NOWINDOW);
					syschat(string.format("You need %s to get a reward!", item_name(30817)));
				end
			else
				setskin(NOWINDOW);
				syschat("You already took your reward!")
			end
		end									
		
		--- Dungeon end timer
		when ChamberWisdom_FinalExit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Chamber of wisdom: You have failed!")
				server_timer("ChamberWisdom_FinalExitOut", 5, d.get_map_index()) 
			end
		end
		
		--- After that timer, whole dungeon is closed
		when ChamberWisdom_FinalExitOut.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all()
			end
		end
		
		------------
		--Dungeon enter
		------------
		when 9341.chat."Chamber of wisdom" with not ChamberWisdomLIB.isActive() begin
			say_size(350,350); addimage(25, 10, "chamber_wisdom_bg1.tga"); addimage(220, 200, "chamber_npc1.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Hey warrior![ENTER]Can i borrow you for a second?[ENTER]I've been studying with my friends in our university[ENTER]when something bad happened![ENTER]All books in the library started came to life.[ENTER]And that's not even the worst thing. Big monster[ENTER]occupied our library and school. We need help!")
			say_reward("Could you do that?")
			if (select("Yes, sure", "No, sorry") == 1) then
				if ChamberWisdomLIB.checkEnter() then
					say_size(350,350); addimage(25, 10, "chamber_wisdom_bg1.tga"); addimage(225, 200, "chamber_npc1.tga")
					say_reward("[ENTER]You must finish the dungeon in 15 minutes.[ENTER]Otherwise you will be teleported out[ENTER]of the dungeon.[ENTER][ENTER]I wish you best luck!")
					wait()
					ChamberWisdomLIB.CreateDungeon();
				end
			end
		end
		
		----Picking the key to be able to get reward in the dungeon. Possible only once per defined time (1 day by deafult)
		when 9341.chat."Special key" with not ChamberWisdomLIB.isActive() begin
			local settings = ChamberWisdomLIB.Settings();
			
			addimage(25, 10, "chamber_wisdom_bg1.tga"); addimage(225, 150, "chamber_npc1.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:", mob_name(npc.get_race())))
			
			if ((get_global_time() - pc.getf("chamber_reward","chamber_reward_time")) < settings["reward_cooldown"]) then
			
				local remaining_wait_time = (pc.getf("chamber_reward","chamber_reward_time") - get_global_time() + settings["reward_cooldown"])
				say("You have to wait until you can pick the")
				say_item(""..item_name(settings["Item_To_Reward"]).."", settings["Item_To_Reward"], "")
				say("again.[ENTER]")
				say_reward("You can pick it again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
				return
			else
				say(string.format("This special key is for %s[ENTER]It allows you to open it and see[ENTER]what is inside. Sometimes, really cool stuff are there.", mob_name(9347)))
				say_reward("Here we go!")
				say_item(""..item_name(settings["Item_To_Reward"]).."", settings["Item_To_Reward"], "")
				pc.give_item2(settings["Item_To_Reward"], 1)
				
				pc.setf("chamber_reward","chamber_reward_time", get_global_time())
				pc.setqf("chamber_reward", get_time() + settings["reward_cooldown"])
			end
		end
		------------
		--Time reset - ONLY FOR GM 
		------------
		when 9341.chat."Time reset" with pc.is_gm() and not ChamberWisdomLIB.isActive() begin
			local settings = ChamberWisdomLIB.Settings();
			addimage(25, 10, "chamber_wisdom_bg1.tga"); addimage(225, 150, "chamber_npc1.tga")
			say("[ENTER][ENTER]")
			if select("Reset time","Close") == 2 then return end
				addimage(25, 10, "chamber_wisdom_bg1.tga"); addimage(225, 150, "chamber_npc1.tga")
				say("[ENTER][ENTER]")
				say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
				say("[ENTER]The time has been reseted.")
				pc.setf("pyramid_dungeon","exit_pyramid_dungeon_time", 0)
				pc.setqf("rejoin_time", get_time() - settings["dungeon_cooldown"])
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with ChamberWisdomLIB.isActive() begin
			local settings = ChamberWisdomLIB.Settings(); local Items = settings["Item_Books"];		
						
			for index = 1, table.getn(Items) do
				pc.remove_item(Items[index], pc.count_item(Items[index]));
			end
			
			if not pc.is_gm() then
				pc.setf("chamber_of_wisdom","exit_chamber_of_wisdom_time", get_global_time())
				pc.setqf("chamber_of_wisdom", get_time() + settings["dungeon_cooldown"])
			end
		end
	end
end	
		
		
