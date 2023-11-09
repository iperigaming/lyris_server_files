quest Valentine2021_enter begin
	state start begin
		when 9376.chat."The story" with not ShadowZoneLIB.isActive() begin
			addimage(25, 10, "shadowzone_bg1.tga"); say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			
			say("We fight with demons in Devil's tower or Devil catacombs for years.[ENTER]But something much darker has awake.[ENTER]There is another world. Deep in shadow. Forgotten[ENTER]corridors of old Kingdoms we know only from rumors.")
			
			wait()
			addimage(25, 10, "shadowzone_bg1.tga"); say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			
			say("There aren't many of us who survived.[ENTER]Most of them are stuck in there forever.[ENTER]If we wont fight, the shadow will take control[ENTER]of most places on earth.")
		end
			
		when 9376.chat."Shadow tower" with not ShadowZoneLIB.isActive() begin
			local settings = ShadowZoneLIB.Settings();

			addimage(25, 10, "shadowzone_bg1.tga");
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say_reward("Do you really want to enter the dungeon?")
			
			if (select("Yes!", "No") == 1) then
				if ShadowZoneLIB.checkEnter() then
					ShadowZoneLIB.CreateDungeon();
				end
			end
		end
	end
end	
		
		
