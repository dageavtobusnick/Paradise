/datum/game_mode/proc/delay_terror_win()
	delay_terror_end = TRUE

/datum/game_mode/proc/return_terror_win()
	delay_terror_end = FALSE

/datum/game_mode/proc/declare_terror_completion()
	if(station_was_nuked && !terror_stage == TERROR_STAGE_POST_END)
		to_chat(world, "<BR><FONT size = 3><B>Частичная победа Пауков Ужаса!</B></FONT>")
		to_chat(world, "<B>Станция была уничтожена!</B>")
		to_chat(world, "<B>Устройство самоуничтожения сработало, предотвращая распространение Пауков Ужаса.</B>")
	else if(protect_egg.check_completion())
		to_chat(world, "<BR><FONT size = 3><B>Полная победа Пауков Ужаса!</B></FONT>")
		to_chat(world, "<B>Пауки захватили станцию!</B>")
		to_chat(world, "<B>Императрица ужаса появилась на свет, превратив всю станцию в гнездо.</B>")
	else if(!check_main_spiders())
		to_chat(world, "<BR><FONT size = 3><B>Полная победа персонала станции!</B></FONT>")
		to_chat(world, "<B>Экипаж защитил станцию от Пауков Ужаса!</B>")
		to_chat(world, "<B>Пауки Ужаса были истреблены.</B>")
	else
		to_chat(world, "<BR><FONT size = 3><B>Ничья!</B></FONT>")
		to_chat(world, "<B>Экипаж эвакуирован!</B>")
		to_chat(world, "<B>Пауки Ужаса не были истреблены.</B>")
	to_chat(world, "<B>Целями Пауков Ужаса было:</B>")
	if(prince_target)
		to_chat(world, "<br/>Цель Принца: [prince_target.explanation_text] [prince_target.completed?"<font color='green'><B>Успех!</B></font>": "<font color='red'>Провал.</font>"]")
		SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[prince_target.type]", prince_target.completed? "SUCCESS" : "FAIL"))
	if(infect_target)
		to_chat(world, "<br/>Цель Осквернителя: [infect_target.explanation_text] [infect_target.completed?"<font color='green'><B>Успех!</B></font>": "<font color='red'>Провал.</font>"]")
		SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[infect_target.type]", infect_target.completed? "SUCCESS" : "FAIL"))
	if(lay_eggs_target)
		to_chat(world, "<br/>Цель Принцессы/Королевы: [lay_eggs_target.explanation_text] [lay_eggs_target.completed?"<font color='green'><B>Успех!</B></font>": "<font color='red'>Провал.</font>"]")
		SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[lay_eggs_target.type]", lay_eggs_target.completed? "SUCCESS" : "FAIL"))
	if(other_target)
		to_chat(world, "<br/>Цель Пауков Ужаса: [other_target.explanation_text] [other_target.completed?"<font color='green'><B>Успех!</B></font>": "<font color='red'>Провал.</font>"]")
		SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[other_target.type]", other_target.completed? "SUCCESS" : "FAIL"))
	if(protect_egg)
		var/completed = protect_egg.completed && (!station_was_nuked || terror_stage == TERROR_STAGE_POST_END)
		to_chat(world, "<br/>Защита яйца: [protect_egg.explanation_text] [completed ?"<font color='green'><B>Успех!</B></font>": "<font color='red'>Провал.</font>"]")
		SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[protect_egg.type]", completed ? "SUCCESS" : "FAIL"))
	return TRUE


/datum/game_mode/proc/auto_declare_completion_terror()
	var/list/terror_queens = main_spiders[TERROR_QUEEN]
	var/list/terror_princes = main_spiders[TERROR_PRINCE]
	var/list/terror_princesses = main_spiders[TERROR_PRINCESS]
	var/list/terror_defilers = main_spiders[TERROR_DEFILER]
	
	if(terror_queens.len || terror_princes.len || terror_princesses.len || terror_defilers.len)
		declare_terror_completion()
		var/text = "<br/><FONT size = 2><B>Основа гнезда:</B></FONT>"
		text += "<br/><FONT size = 1><B>Королев[(terror_queens?.len > 1 ? "ами были" : "ой был")]:</B></FONT>"
		for(var/datum/mind/spider in terror_queens)
			text += "<br/><b>[spider.key]</b> был <b>[spider.name]</b>"
		text += "<br/><FONT size = 1><B>Принц[(terror_queens?.len > 1 ? "ами были" : "ем был")]:</B></FONT>"
		for(var/datum/mind/spider in terror_princes)
			text += "<br/><b>[spider.key]</b> был <b>[spider.name]</b>"
		text += "<br/><FONT size = 1><B>Принцесс[(terror_queens?.len > 1 ? "ами были" : "ой был")]:</B></FONT>"
		for(var/datum/mind/spider in terror_princesses)
			text += "<br/><b>[spider.key]</b> был <b>[spider.name]</b>"
		text += "<br/><FONT size = 1><B>Осквернител[(terror_queens?.len > 1 ? "ями были" : "ем был")]:</B></FONT>"
		for(var/datum/mind/spider in terror_defilers)
			text += "<br/><b>[spider.key]</b> был <b>[spider.name]</b>"
		text += "<br/><FONT size = 2><B>Паук[(terror_spiders?.len > 1 ? "ами Ужаса были" : "ом Ужаса был")]:</B></FONT>"
		for(var/datum/mind/spider in terror_spiders)
			text += "<br/><b>[spider.key]</b> был <b>[spider.name]</b>"
		to_chat(world, text)
	return TRUE

