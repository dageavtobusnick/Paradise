/datum/objective/spider_protect
	name = "защищать гнездо"
	needs_target = FALSE
	explanation_text = "Ошибка. Текст не сгенерирован. Напишите атикет и создайте баг репорт."

/datum/objective/spider_protect/New(text, datum/team/team_to_join)
	. = ..()
	generate_text()

/datum/objective/spider_protect/proc/generate_text()
	var/list/possible_spiders = list()
	var/list/spiders = SSticker?.mode?.main_spiders
	if(!spiders)
		return
	for(var/spiter_type in spiders)
		if(spiter_type != TERROR_OTHER && LAZYLEN(spiders[spiter_type]))
			possible_spiders += spiter_type
	explanation_text = "Помогите вашему гнезду отложить яйцо Императрицы Ужаса. Это могут сделать: [possible_spiders.Join(", ")]. Защищайте их и помогите им набрать силу, чтобы они могли отложить яйцо."

/datum/objective/spider_protect/check_completion()
	. = ..()

	if(completed)
		return .

	var/datum/game_mode/mode = SSticker?.mode
	if(mode?.infect_target?.completed || \
	mode?.lay_eggs_target?.completed|| \
	mode?.prince_target?.completed)
		completed = TRUE
		return TRUE
	return .

/datum/objective/spider_protect_egg
	name = "защищайте яйцо императрицы"
	needs_target = FALSE
	explanation_text = "Ошибка. Текст не сгенерирован. Напишите атикет и создайте баг репорт."

/datum/objective/spider_protect_egg/New(text, datum/team/team_to_join)
	. = ..()
	generate_text()

/datum/objective/spider_protect_egg/proc/generate_text()
	if(!SSticker?.mode?.empress_egg)
		return
	explanation_text = "Защищайте яйцо императрицы ужаса. Оно находится в [get_area(SSticker?.mode?.empress_egg)]. Его уничтожение приведет к гибели всего гнезда."

/datum/objective/spider_get_power
	name = "spider bug"
	needs_target = FALSE
	explanation_text = "Вы не должны этого видеть. Напишите баг репорт."
	var/targets_need = 0

/datum/objective/spider_get_power/proc/generate_text()
	generate_targets_count()
	return

/datum/objective/spider_get_power/proc/generate_targets_count()
	targets_need = 2 + num_station_players() / 5
	return

/datum/objective/spider_get_power/alife_spiders
	name = "размножаться"

/datum/objective/spider_get_power/alife_spiders/generate_text()
	. = ..()
	explanation_text = "Расплодитесь. Для того, чтобы вы могли отложить яйцо императрицы в вашем гнезде должно быть [targets_need] пауков."

/datum/objective/spider_get_power/alife_spiders/check_completion()
	. = ..()

	if(completed)
		return .

	var/datum/game_mode/mode = SSticker?.mode
	var/alife_count = mode?.get_terror_spiders_alife_count()

	if(alife_count >= targets_need)
		completed = TRUE
		mode.other_target?.check_completion()
		return TRUE
	return .

/datum/objective/spider_get_power/spider_infections
	name = "заражать гуманоидов"

/datum/objective/spider_get_power/spider_infections/generate_text()
	. = ..()
	explanation_text = "Заражайте. Для того, чтобы вы могли отложить яйцо императрицы должно быть заражено [targets_need] гуманоидов."

/datum/objective/spider_get_power/spider_infections/check_completion()
	. = ..()

	if(completed)
		return .

	var/datum/game_mode/mode = SSticker?.mode

	if(mode?.terror_infections.len >= targets_need)
		completed = TRUE
		mode.other_target?.check_completion()
		return TRUE
	return .


/datum/objective/spider_get_power/eat_humans
	name = "поедать гуманоидов"

/datum/objective/spider_get_power/eat_humans/generate_text()
	. = ..()
	explanation_text = "Ешьте и набирайтесь сил. Для того, чтобы вы могли отложить яйцо императрицы вам нужно заплести в кокон [targets_need] гуманоидов. "

/datum/objective/spider_get_power/eat_humans/check_completion(human_count)
	. = ..()

	if(completed)
		return .

	if(human_count >= targets_need)
		completed = TRUE
		SSticker?.mode?.other_target?.check_completion()
		return TRUE
	return .
