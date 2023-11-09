quest AndunTemple_zone begin
	state start begin
		when login with AndunTempleLIB.isActive() begin
			local settings = AndunTempleLIB.Settings();			
			local DungeonTimer = settings["DungeonTimer"]
			local DungeonSoulTime = settings["dungeon_soul"]
			local DungeonSoulLeftTime = d.get_ui_timer()
		
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				d.setf("AndunTemple_DungeonTimer", get_global_time() + DungeonTimer);
				d.setf("AndunTemple_stage", 1);
				d.setf("AndunTemple_1w_monsters_k", 1);
				
				AndunTempleLIB.setReward();
				d.set_warp_location(settings["outside_index"], settings["outside_pos"][1], settings["outside_pos"][2]);
								
				d.regen_file("data/dungeon/andun_temple/regen_1f_mobs.txt");
				
				d.notice("Andun temple: Kill all monsters to proceed")
				
				-- Soul Timer
				d.set_ui_timer(DungeonSoulTime)
				
				server_loop_timer("AndunTemple_soul_time", 1, d.get_map_index())
				server_timer("AndunTemple_dungeon_time", DungeonTimer, d.get_map_index())
			end
			local DungeonSoulLeftTime = d.get_ui_timer()
			cmdchat("dungeonui "..DungeonSoulLeftTime)
		end
		
---------------------------
---------------------------
----------- 1. Floor
---------------------------
---------------------------

		---------
		-- Players kill first wave of monsters to spawn a boss
		-------------
		when kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 1 and d.getf("AndunTemple_1w_monsters_k") == 1 begin
			local settings = AndunTempleLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_1_WAVE"];
			local n = d.getf("AndunTemple_1w_monsters_c") + 1
			
			d.setf("AndunTemple_1w_monsters_c", n)
				
			if n >= KILL_COUNT then
			
				d.setf("AndunTemple_1w_monsters_k", 0);
				d.setf("AndunTemple_CanKillFirstBoss", 1);
				
				d.spawn_mob(4544, 125, 155);
				
				d.notice(string.format("Andun temple: %s showed up, kill him!", mob_name(4544)));					
			end
		end

		-------------
		-- Players kill first boss
		-------------
		when 4544.kill with AndunTempleLIB.isActive()  and d.getf("AndunTemple_CanKillFirstBoss") == 1  or d.getf("AndunTemple_SpawnBosses") == 1 begin
			local settings = AndunTempleLIB.Settings();
			
			if d.getf("AndunTemple_stage") == 1 then 
				AndunTempleLIB.clearDungeon();
							
				d.notice("Andun temple: Excellent job!");
				d.notice("Andun temple: You will proceed in a moment.");
				
				server_timer("AndunTemple_SecondFloor_jump", settings["time_to_proceed"], d.get_map_index())
			
			elseif d.getf("AndunTemple_stage") == 2 then
				local n = d.getf("AndunTemple_FBossKilled") + 1
			
				d.setf("AndunTemple_FBossKilled", n)

				if d.getf("AndunTemple_FBossKilled") >= 3 then
				
					AndunTempleLIB.spawnSecondBoss();
					
				else
					d.setf("AndunTemple_CanDestroy_1Stone", 1);
					d.spawn_mob(8723, 609, 309);
					
					d.notice(string.format("Andun temple: %s was spawned. Destroy it!", mob_name(8723)));
				end
			
			elseif d.getf("AndunTemple_stage") == 6 then
				d.setf("AndunTemple_SpawnBosses", 0);
				
				server_timer("AndunTemple_FinalBossCheck", settings["time_to_proceed"], d.get_map_index())
			end
		end
		
		-------------
		-- Second floor jump
		-------------
		when AndunTemple_SecondFloor_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				AndunTempleLIB.RemainingTimeNotice();
				AndunTempleLIB.jumpToSecondFloor();				
			end
		end	
---------------------------
---------------------------
----------- 2. Floor
---------------------------
---------------------------
		-------------
		-- Players destroy a stone to get a key
		-------------
		when 8723.kill with AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 2  and d.getf("AndunTemple_CanDestroy_1Stone") == 1 begin
			local settings = AndunTempleLIB.Settings();
			
			d.setf("AndunTemple_CanDestroy_1Stone", 0);
			d.setf("AndunTemple_CanOpenDoor", 1);
			
			game.drop_item(30912, 1);
						
			d.notice(string.format("Andun temple: You can open the %s now.", mob_name(9448)));
		end
		
		-------------
		-- Players put key on the door and open it
		-------------
		when 9448.take with item.get_vnum() == 30912 and AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 2 and d.getf("AndunTemple_CanOpenDoor") == 1 begin
			AndunTempleLIB.openDoor();
		end
		
		-------------
		-- Players activate the monument to spawn a wave of monsters
		-------------
		when 9449.click with AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 2 and d.getf("AndunTemple_UnlockMonument") == 1 begin
			if party.is_party() and not party.is_leader() then
				say("Only leader of your group can open it.")
				return
			end

			AndunTempleLIB.activate2FMonument();
		end

		---------
		-- Players kill first wave of monsters to spawn a boss
		-------------
		when kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 2 and d.getf("AndunTemple_2w_monsters_k") == 1 begin
			local settings = AndunTempleLIB.Settings();		
			local KILL_COUNT_1 = settings["KILL_COUNT_2_WAVE"];
			local KILL_COUNT_2 = settings["KILL_COUNT_3_WAVE"];
			local KILL_COUNT_3 = settings["KILL_COUNT_4_WAVE"];
			local n = d.getf("AndunTemple_2w_monsters_c") + 1
			
			d.setf("AndunTemple_2w_monsters_c", n)
				
			if d.getf("AndunTemple_2FMonument") == 1 then 
				if n >= KILL_COUNT_1 then
				
					d.setf("AndunTemple_2w_monsters_k", 0);
					d.setf("AndunTemple_2w_monsters_c", 0);
					d.setf("AndunTemple_CanKillFirstBoss", 1);
					
					d.spawn_mob(4544, 731, 295);
					
					d.notice(string.format("Andun temple: %s showed up, kill him!", mob_name(4544)));					
				end
			
			elseif d.getf("AndunTemple_2FMonument") == 2 then 
				if n >= KILL_COUNT_2 then
				
					d.setf("AndunTemple_2w_monsters_k", 0);
					d.setf("AndunTemple_2w_monsters_c", 0);
					d.setf("AndunTemple_CanKillFirstBoss", 1);
					
					d.spawn_mob(4544, 595, 175);
					
					d.notice(string.format("Andun temple: %s showed up, kill him!", mob_name(4544)));					
				end
			
			elseif d.getf("AndunTemple_2FMonument") == 3 then 
				if n >= KILL_COUNT_3 then
				
					d.setf("AndunTemple_2w_monsters_k", 0);
					d.setf("AndunTemple_2w_monsters_c", 0);
					d.setf("AndunTemple_CanKillFirstBoss", 1);
					
					d.spawn_mob(4544, 485, 325);
					
					d.notice(string.format("Andun temple: %s showed up, kill him!", mob_name(4544)));					
				end
			end
		end
		
		-------------
		-- Players kill second boss
		-------------
		when 4545.kill with AndunTempleLIB.isActive() and d.getf("AndunTemple_CanKillSecondBoss") == 1 begin
			local settings = AndunTempleLIB.Settings();
			
			if d.getf("AndunTemple_stage") == 2 then
				d.setf("AndunTemple_CanKillSecondBoss", 0);
				clear_server_timer("AndunTemple_KillSecondBoss", d.get_map_index());
				AndunTempleLIB.clearDungeon();
				
				server_timer("AndunTemple_ThirdFloor_jump", settings["time_to_proceed"], d.get_map_index())
				
				d.notice("Andun temple: You will proceed to next stage in a moment.");
			
			elseif d.getf("AndunTemple_stage") == 6 then
				d.setf("AndunTemple_SpawnBosses", 0);
				
				server_timer("AndunTemple_FinalBossCheck", settings["time_to_proceed"], d.get_map_index())
			end
		end

		-------------
		-- Third floor jump
		-------------
		when AndunTemple_ThirdFloor_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				AndunTempleLIB.RemainingTimeNotice();
				AndunTempleLIB.jumpToThirdFloor();				
			end
		end	
---------------------------
---------------------------
----------- 3. Floor
---------------------------
---------------------------
		-------------
		-- Players destroy stones in 3rd floor
		-------------
		when 8724.kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 3 begin
			local settings = AndunTempleLIB.Settings(); 
			
			if d.getf("AndunTemple_CanDestroy_2Stone") == 1 then
				if npc.get_vid() == d.get_unique_vid("real") then
					d.purge_area(3691600, 2299700, 3704700, 2313300);
					d.setf("AndunTemple_CanDestroy_2Stone", 0);
					d.setf("AndunTemple_CanUseScroll", 1);
					
					game.drop_item(30913, 1);
					
					d.notice(string.format("Andun temple: Use the %s to spawn monsters!", item_name(30913)));
					
				else
					d.notice("Andun temple: This was not the right stone.")
				end
			end
		end

		-------------
		-- Players use scroll item to spawn wave of monsters
		-------------
		when 30913.use with AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 3 and d.getf("AndunTemple_CanUseScroll") == 1 begin
			item.remove();
			
			d.setf("AndunTemple_CanUseScroll", 0);
			d.setf("AndunTemple_3w_monsters_k", 1);
			
			d.regen_file("data/dungeon/andun_temple/regen_3f_mobs.txt");
			
			d.notice("Andun temple: Kill all monsters to proceed!");
		end
		
		---------
		-- Players kill  wave of monsters to get a key to spawn a boss
		-------------
		when kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 3 and d.getf("AndunTemple_3w_monsters_k") == 1 begin
			local settings = AndunTempleLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_5_WAVE"];
			local n = d.getf("AndunTemple_3w_monsters_c") + 1
			
			d.setf("AndunTemple_3w_monsters_c", n)
				
			if n >= KILL_COUNT then
			
				d.setf("AndunTemple_3w_monsters_k", 0);
				d.setf("AndunTemple_3w_monsters_c", 0);
				d.setf("AndunTemple_CanUseSucubbAmulet", 1);
				
				game.drop_item(30914, 1);
				
				d.notice(string.format("Andun temple: Use %s to call %s!", item_name(30914), mob_name(4544)));					
			end
		end
			
		-------------
		-- Players use amulet to spawn third boss
		-------------
		when 30914.use with AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 3 and d.getf("AndunTemple_CanUseSucubbAmulet") == 1 begin
			item.remove();			
			d.setf("AndunTemple_CanUseSucubbAmulet", 0);
			AndunTempleLIB.spawnThirdBoss();
		end
		
		-------------
		-- Players kill second boss
		-------------
		when 4546.kill with AndunTempleLIB.isActive() and d.getf("AndunTemple_CanKillThirdBoss") == 1  or d.getf("AndunTemple_SpawnBosses") == 1 begin
			local settings = AndunTempleLIB.Settings();
			
			if d.getf("AndunTemple_stage") == 3 then
				d.setf("AndunTemple_CanKillThirdBoss", 0);
				clear_server_timer("AndunTemple_KillThirdBoss", d.get_map_index())
				
				AndunTempleLIB.clearDungeon();
				
				server_timer("AndunTemple_FourthFloor_jump", settings["time_to_proceed"], d.get_map_index())
				
				d.notice("Andun temple: You will proceed to next stage in a moment.");
			
			elseif d.getf("AndunTemple_stage") == 6 then
				d.setf("AndunTemple_SpawnBosses", 0);
				
				server_timer("AndunTemple_FinalBossCheck", settings["time_to_proceed"], d.get_map_index())
			end
		end

		-------------
		-- If players wont kill second boss in limited time, some time will be removed from the timer
		-------------
		when AndunTemple_KillThirdBoss.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("AndunTemple_CanKillThirdBoss") == 1 then
					local settings = AndunTempleLIB.Settings();
					local DungeonSoulLeftTime = d.get_ui_timer()
					local DungeonSoulTimeRemove = settings["soul_loss_third_floor"]
					
					d.set_ui_timer(DungeonSoulLeftTime-DungeonSoulTimeRemove)
				end
			end
		end

		-------------
		-- Fourth floor jump
		-------------
		when AndunTemple_FourthFloor_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				AndunTempleLIB.RemainingTimeNotice();
				AndunTempleLIB.jumpToFourthFloor();				
			end
		end	
		
---------------------------
---------------------------
----------- 4. Floor
---------------------------
---------------------------
		---------
		-- Players kill  wave of monsters to get a key to destroy a monument
		-------------
		when kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 4 and d.getf("AndunTemple_4w_monsters_k") == 1 begin
			local settings = AndunTempleLIB.Settings();		
			local KILL_COUNT_1 = settings["KILL_COUNT_6_WAVE"];
			local KILL_COUNT_2 = settings["KILL_COUNT_7_WAVE"];
			local KILL_COUNT_3 = settings["KILL_COUNT_8_WAVE"];
			local n = d.getf("AndunTemple_4w_monsters_c") + 1
			
			d.setf("AndunTemple_4w_monsters_c", n)
				
			if d.getf("AndunTemple_4FMonument") == 1 then 
				if n >= KILL_COUNT_1 then
				
					d.setf("AndunTemple_4w_monsters_k", 0);
					d.setf("AndunTemple_4w_monsters_c", 0);
					d.setf("AndunTemple_CanDestroy_Monument", 1);
					
					game.drop_item(30915, 1);
					
					d.notice(string.format("Andun temple: Use %s to destroy the %s!", item_name(30915),mob_name(9452)));					
				end
			
			elseif d.getf("AndunTemple_4FMonument") == 2 then 
				if n >= KILL_COUNT_2 then
				
					d.setf("AndunTemple_4w_monsters_k", 0);
					d.setf("AndunTemple_4w_monsters_c", 0);
					d.setf("AndunTemple_CanDestroy_Monument", 1);
					
					game.drop_item(30915, 1);
					
					d.notice(string.format("Andun temple: Use %s to destroy the %s!", item_name(30915),mob_name(9452)));					
				end
			
			elseif d.getf("AndunTemple_4FMonument") == 3 then 
				if n >= KILL_COUNT_3 then
				
					d.setf("AndunTemple_4w_monsters_k", 0);
					d.setf("AndunTemple_4w_monsters_c", 0);
					d.setf("AndunTemple_CanDestroy_Monument", 1);
					
					game.drop_item(30915, 1);
					
					d.notice(string.format("Andun temple: Use %s to destroy the %s!", item_name(30915),mob_name(9452)));					
				end
			end
		end	

		-------------
		-- Players destroy the monument in 3 phases
		-------------
		when 9452.take or 9453.take or 9454.take with item.get_vnum() == 30915 and AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 4 and d.getf("AndunTemple_CanDestroy_Monument") == 1 begin
			AndunTempleLIB.destroy4FMonument();
		end

		-------------
		-- Players must destroy 5x stone
		-------------
		when 8725.kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 4 and d.getf("AndunTemple_CanDestroy_3Stone") == 1 begin
			local settings = AndunTempleLIB.Settings(); 
			local Stone_count = 5;
			
			d.setf("AndunTemple_stone_1", d.getf("AndunTemple_stone_1")+1);
			if (d.getf("AndunTemple_stone_1") < Stone_count) then
			
				d.notice(string.format("Andun temple: %d stones has left!", Stone_count-d.getf("AndunTemple_stone_1")))
			else
				d.setf("AndunTemple_CanDestroy_3Stone", 0);
				d.setf("AndunTemple_CanKillFourthBoss", 1);
				
				d.notice(string.format("Andun temple: Get ready! %s is coming!", mob_name(4547)));
				
				server_timer("AndunTemple_FourthBoss_spawn", settings["time_to_proceed"], d.get_map_index())
			end
		end
		
		-------------
		-- Fourth Boss spawn
		-------------
		when AndunTemple_FourthBoss_spawn.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.spawn_mob(4547, 141, 875);				
			end
		end	
		
		-------------
		-- Players kill fourth boss
		-------------
		when 4547.kill with AndunTempleLIB.isActive() and d.getf("AndunTemple_CanKillFourthBoss") == 1 or d.getf("AndunTemple_SpawnBosses") == 1 begin
			local settings = AndunTempleLIB.Settings();
			
			if d.getf("AndunTemple_stage") == 4 then
				d.setf("AndunTemple_CanKillFourthBoss", 0);
				d.setf("AndunTemple_4thStage", 0);
				clear_server_timer("AndunTemple_FourthStage", d.get_map_index());
				
				AndunTempleLIB.clearDungeon();
				
				server_timer("AndunTemple_FifthFloor_jump", settings["time_to_proceed"], d.get_map_index())
				
				d.notice("Andun temple: You will proceed to next stage in a moment.");
			
			elseif d.getf("AndunTemple_stage") == 6 then
				d.setf("AndunTemple_SpawnBosses", 0);
				
				server_timer("AndunTemple_FinalBossCheck", settings["time_to_proceed"], d.get_map_index())
			end
		end

		---------
		-- If players wont finish the fourth floor in defined time, some time will be removed from the timer
		-------------
		when AndunTemple_FourthStage.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("AndunTemple_4thStage") == 1 then
					local settings = AndunTempleLIB.Settings();
					local DungeonSoulLeftTime = d.get_ui_timer()
					local DungeonSoulTimeRemove = settings["soul_loss_fourth_floor"]
					
					d.set_ui_timer(DungeonSoulLeftTime-DungeonSoulTimeRemove)
				end
			end
		end

		-------------
		-- Fifth floor jump
		-------------
		when AndunTemple_FifthFloor_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				AndunTempleLIB.RemainingTimeNotice();
				AndunTempleLIB.jumpToFifthFloor();				
			end
		end	
---------------------------
---------------------------
----------- 5. Floor
---------------------------
---------------------------
		-------------
		-- Players destroy altars one by one
		-------------
		when 9455.take with item.get_vnum() == 30916 and AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 5 and d.getf("AndunTemple_CanDestroy_Altar") == 1 begin
			AndunTempleLIB.destroyAltar();
		end
		
		---------
		-- Players kill  wave of monsters to get a key to destroy an altar
		-------------
		when kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 5 and d.getf("AndunTemple_5w_monsters_k") == 1 begin
			local settings = AndunTempleLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_9_WAVE"];
			local n = d.getf("AndunTemple_5w_monsters_c") + 1
			
			d.setf("AndunTemple_5w_monsters_c", n)
				
			if n >= KILL_COUNT then
			
				d.setf("AndunTemple_5w_monsters_k", 0);
				d.setf("AndunTemple_5w_monsters_c", 0);
				d.setf("AndunTemple_CanDestroy_Altar", 1);
				
				game.drop_item(30916, 1);
				
				d.notice(string.format("Andun temple: Use %s to destroy the %s!", item_name(30916),mob_name(9455)));					
			end			
		end
		
		-------------
		-- Players must destroy 5x stone
		-------------
		when 8726.kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 5  begin
			local settings = AndunTempleLIB.Settings(); 
			local Stone_count = 6;
			
			if d.getf("AndunTemple_CanDestroy_4Stone") == 1 then
				d.setf("AndunTemple_CanDestroy_Altar", 1);
				
				game.drop_item(30916, 1);
				
				d.notice(string.format("Andun temple: Destroy next %s", mob_name(9455)));
				
			elseif d.getf("AndunTemple_CanDestroy_4Stone") == 2 then
				d.setf("AndunTemple_stone_2", d.getf("AndunTemple_stone_2")+1);
				
				if (d.getf("AndunTemple_stone_2") < Stone_count) then
				
					d.notice(string.format("Andun temple: %d stones has left!", Stone_count-d.getf("AndunTemple_stone_2")))
				else
					d.setf("AndunTemple_CanDestroy_4Stone", 0);
					d.setf("AndunTemple_CanDestroy_Altar", 1);
					
					game.drop_item(30916, 1);
					
					d.notice(string.format("Andun temple: Destroy the last %s!", mob_name(9455)));
				end
			end
		end

		-------------
		-- Players kill fifth boss
		-------------
		when 4548.kill with AndunTempleLIB.isActive() and d.getf("AndunTemple_CanKillFifthBoss") == 1  or d.getf("AndunTemple_SpawnBosses") == 1 begin
			local settings = AndunTempleLIB.Settings();
			
			if d.getf("AndunTemple_stage") == 5 then
				d.setf("AndunTemple_CanKillFifthBoss", 0);
				
				AndunTempleLIB.clearDungeon();
				
				server_timer("AndunTemple_SixthFloor_jump", settings["time_to_proceed"], d.get_map_index())
				
				d.notice("Andun temple: You will proceed to next stage in a moment.");
			
			elseif d.getf("AndunTemple_stage") == 6 then
				d.setf("AndunTemple_SpawnBosses", 0);
				
				server_timer("AndunTemple_FinalBossCheck", settings["time_to_proceed"], d.get_map_index())
			end
		end


		-------------
		-- Sixth floor jump
		-------------
		when AndunTemple_SixthFloor_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				AndunTempleLIB.RemainingTimeNotice();
				AndunTempleLIB.jumpToSixthFloor();				
			end
		end	
		
		
---------------------------
---------------------------
----------- 6. Floor
---------------------------
---------------------------
		-------------
		-- Players destroy stones in 3rd floor
		-------------
		when 8727.kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 6 begin
			local settings = AndunTempleLIB.Settings(); 
			local n = d.getf("AndunTemple_negative_points") + 1
			
			if d.getf("AndunTemple_CanDestroy_5Stone") == 1 then
				if npc.get_vid() == d.get_unique_vid("real") then
					d.purge_area(3762700, 2326500, 3779300, 2345100);
					d.setf("AndunTemple_CanDestroy_5Stone", 0);
					d.setf("AndunTemple_6w_monsters_k", 1);
					
					d.notice("Andun temple: This was the correct one!");
					d.notice(string.format("Andun temple: Kill all monsters to be able to pick up %s!", item_name(9458)));
					
					d.regen_file("data/dungeon/andun_temple/regen_6f_mobs.txt");
					
				else
					d.notice("Andun temple: This was not the right stone.")
					d.notice(string.format("Andun temple: You have %s negative points", d.getf("AndunTemple_negative_points")+1));
					d.setf("AndunTemple_negative_points", n)
				end
			end
		end
		
		---------
		-- Players kill  wave of monsters to be able to pick up the symbol
		-------------
		when kill with AndunTempleLIB.isActive() and not npc.is_pc() and d.getf("AndunTemple_stage") == 6 and d.getf("AndunTemple_6w_monsters_k") == 1 begin
			local settings = AndunTempleLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_10_WAVE"];
			local n = d.getf("AndunTemple_6w_monsters_c") + 1
			
			d.setf("AndunTemple_6w_monsters_c", n)
				
			if n >= KILL_COUNT then
			
				d.setf("AndunTemple_6w_monsters_k", 0);
				d.setf("AndunTemple_6w_monsters_c", 0);
				d.setf("AndunTemple_CanPickUp_Symbol", 1);
				
				d.notice(string.format("Andun temple: You can pick up %s now to activate %s!", mob_name(9458),mob_name(9457)));					
			end			
		end
		
		---------
		-- Players pick symbol
		-------------
		when 9458.click with d.getf("AndunTemple_stage") == 6 and d.getf("AndunTemple_CanPickUp_Symbol") == 1 begin
			npc.purge();
			pc.give_item2(30917, 1);
			
			d.setf("AndunTemple_CanPickUp_Symbol", 0);
			d.setf("AndunTemple_CanPut_Symbol", 1);
		end
		
		-------------
		-- Players put Andun symbol to the NPC
		-------------
		when 9456.take with item.get_vnum() == 30917 and AndunTempleLIB.isActive() and d.getf("AndunTemple_stage") == 6 and d.getf("AndunTemple_CanPut_Symbol") == 1 begin
			AndunTempleLIB.insertSymbol();
		end

		-------------
		-- Random or Final boss is spawned
		-------------
		when AndunTemple_FinalBossCheck.server_timer begin
			if d.select(get_server_timer_arg()) then
				AndunTempleLIB.RemainingTimeNotice();
				
				if d.getf("AndunTemple_SpawnBosses") == 1 then
					AndunTempleLIB.spawnRandomBoss();
				else
					AndunTempleLIB.spawnFinalBoss();
				end
			end
		end	
		
		-------------
		-- If Final boss is not dead, pillar is spawned and must be destroyed
		-------------
		when AndunTemple_PillarSpawn.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("AndunTemple_FinalBossAlive") == 1 then
					AndunTempleLIB.spawnLastPillar();
				end
			end
		end	
		
		-------------
		-- If the pillar is not destroyed, soul mana will be removed from players
		-------------
		when AndunTemple_PillarDestroy.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("AndunTemple_pillarAlive") == 1 then
					local settings = AndunTempleLIB.Settings();
					local DungeonSoulLeftTime = d.get_ui_timer()
					local DungeonSoulTimeRemove = settings["soul_loss_sixth_floor"]
					
					d.setf("AndunTemple_pillarAlive", 0);
					d.set_ui_timer(DungeonSoulLeftTime-DungeonSoulTimeRemove)
					
					d.notice(string.format("Andun temple: You didn't destroy %s in limited time, you lost some soul mana!", mob_name(8728)));
				end
			end
		end	
		
		-------------
		-- Players destroy the pillar
		-------------
		when 8728.kill with AndunTempleLIB.isActive() and d.getf("AndunTemple_pillarAlive") == 1  or d.getf("AndunTemple_stage") == 6 begin
			d.setf("AndunTemple_pillarAlive", 0);			
			clear_server_timer("AndunTemple_PillarDestroy", d.get_map_index())
			
			d.notice(string.format("Andun temple: You destroyed the %s in limited time.", mob_name(8728)));			
			d.notice("Andun temple: No Soul mana will be removed.");			
		end
		
		-------------
		-- Players kill Final boss
		-------------
		when 4549.kill with AndunTempleLIB.isActive() and d.getf("AndunTemple_FinalBossAlive") == 1  or d.getf("AndunTemple_stage") == 6 begin
			local settings = AndunTempleLIB.Settings();
			
			d.setf("AndunTemple_FinalBossAlive", 0);			
			d.setf("AndunTemple_pillarAlive", 0);
			d.setf("AndunTemple_canGetReward", 1);

			AndunTempleLIB.clearDungeon();
			
			clear_server_timer("AndunTemple_PillarSpawn", d.get_map_index());
			clear_server_timer("AndunTemple_PillarDestroy", d.get_map_index());
			clear_server_timer("AndunTemple_dungeon_time", d.get_map_index());
			clear_server_timer("AndunTemple_soul_time", d.get_map_index());
			
			d.set_ui_timer(0)
			
			d.spawn_mob_dir(9459, 841, 776, 1);
			
			d.notice("Andun temple: You did it! Spectacular job!");			
			d.notice("Andun temple: You can pick your reward now!");

			server_timer("AndunTemple_final_exit", settings["timer_to_exit_dungeon"], d.get_map_index());			
		end

		when 9459.chat."Take reward" with AndunTempleLIB.isActive() and d.getf("AndunTemple_canGetReward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(30918, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Andun temple: You already took the reward!")
			end 
		end
		-------------
		-- Soul timer check, if its 0 dungeon is ended
		-------------
		when AndunTemple_soul_time.server_timer begin
			if d.select(get_server_timer_arg()) then
				local DungeonSoulLeftTime = d.get_ui_timer()
				if DungeonSoulLeftTime <= 0 then
					clear_server_timer("AndunTemple_soul_time", d.get_map_index())
					d.notice("Andun temple: Your soul is not protected anymore. You are leaving this place.");
					
					d.exit_all()
				end
			end
		end
		
		-------------
		-- Time out
		-------------
		when AndunTemple_dungeon_time.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all();
			end
		end
		
		-------------
		-- Final exit
		-------------
		when AndunTemple_final_exit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all();
			end
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with AndunTempleLIB.isActive() begin
			local settings = AndunTempleLIB.Settings();
			local Items = settings["items_to_remove"];

			for index = 1, table.getn(Items) do
				pc.remove_item(Items[index], pc.count_item(Items[index]));
			end			
			
			if not pc.is_gm() then
				AndunTempleLIB.setWaitingTime()
			end
		end
	end
end	
		
		
