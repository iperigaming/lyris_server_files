quest AndunTemple_enter begin
	state start begin
		---Info about dungeon
		when 9447.chat."Who are you?" with not AndunTempleLIB.isActive() begin
			addimage(25, 10, "anduntemp_bg_1.tga"); addimage(225, 150, "andun_temp_npc1.tga");
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say("Hello! Who am I, you ask? I used to be[ENTER]a proud guard of Andun before the Empire was destroyed.[ENTER]I used to guard the main temple, where the emperor[ENTER]and all the dignitaries resided.[ENTER]My soul was saved after the destruction[ENTER]of Andun and was not attacked by the evil that[ENTER]entered the empire. We are not many,[ENTER]but there are a few of us.[ENTER]Since then, I have protected anyone from entering that[ENTER]vile place. Just being here is rare.")
		end		
			
		----Dungeon enter
		when 9447.chat."Andun temple" with not AndunTempleLIB.isActive() begin
			local settings = AndunTempleLIB.Settings();

			addimage(25, 10, "anduntemp_bg_1.tga"); addimage(225, 150, "andun_temp_npc1.tga");			
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say_reward("Do you really want to enter the dungeon?")
			
			if (select("Yes!", "No") == 1) then
				if AndunTempleLIB.checkEnter() then
					AndunTempleLIB.CreateDungeon();
				end
			end
		end
	end
end	
		
		
