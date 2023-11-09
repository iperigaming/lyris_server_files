quest AndunTemple_potions begin
	state start begin
		when 30910.use begin
			if AndunTempleLIB.isActive() then
				local settings = AndunTempleLIB.Settings();
				local LeftTime = d.get_ui_timer()
				local AddTime = settings["potion_s_add_time"]

				item.remove();
				d.set_ui_timer(LeftTime+AddTime)				
			else
				syschat("You can not use this potion outside of the Andun temple");
			end
		end
		
		when 30911.use begin
			if AndunTempleLIB.isActive() then
				local settings = AndunTempleLIB.Settings();
				local LeftTime = d.get_ui_timer()
				local AddTime = settings["potion_l_add_time"]

				item.remove();
				d.set_ui_timer(LeftTime+AddTime)				
			else
				syschat("You can not use this potion outside of the Andun temple");
			end
		end
	end
end	
		
		
