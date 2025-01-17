/datum/game_mode
	var/list/terror_spiders = list()
	var/list/main_spiders = list(TERROR_QUEEN = list(), TERROR_PRINCE = list(), TERROR_PRINCESS = list(), TERROR_DEFILER = list())
	var/list/terror_infections = list()
	var/list/terror_eggs = list()
	var/datum/objective/spider_get_power/eat_humans/prince_target
	var/datum/objective/spider_get_power/alife_spiders/lay_eggs_target
	var/datum/objective/spider_get_power/spider_infections/infect_target
	var/datum/objective/spider_protect/other_target
	var/obj/structure/spider/eggcluster/terror_eggcluster/empress/empress_egg
	var/global_degenerate = FALSE
	var/terror_announce = FALSE

/datum/game_mode/proc/create_terror_spiders(type, count)
	var/spider_type = get_spider_type(type)
	if(!spider_type)
		to_chat(usr, "Некорректный тип паука ужаса.")
		return FALSE
	var/list/candidates = SSghost_spawns.poll_candidates("Вы хотите занять роль Паука Ужаса?", ROLE_TERROR_SPIDER, TRUE, 60 SECONDS, source = spider_type)
	if(length(candidates) < count)
		message_admins("Warning: not enough players volunteered to be terrors. Could only spawn [length(candidates)] out of [count]!")
		return FALSE
	var/successSpawn = FALSE
	while(count && length(candidates))
		var/mob/living/simple_animal/hostile/poison/terror_spider/S = new spider_type(pick(GLOB.xeno_spawn))
		var/mob/M = pick_n_take(candidates)
		S.key = M.key
		S.add_datum_if_not_exist()
		count--
		successSpawn = TRUE
		log_game("[S.key] has become [S].")
	return successSpawn


/datum/game_mode/proc/spider_announce()
	GLOB.command_announcement.Announce("Вспышка биологической угрозы 3-го уровня зафиксирована на борту станции [station_name()]. Всему персоналу надлежит сдержать её распространение любой ценой! Особая директива распечатана на всех консолях связи.", "ВНИМАНИЕ: БИОЛОГИЧЕСКАЯ УГРОЗА.", 'sound/effects/siren-spooky.ogg')
	special_directive()
	SSshuttle?.emergency.cancel()
	SSshuttle?.lockdown_escape()

/datum/game_mode/proc/egg_announce()
	GLOB.command_announcement.Announce("На борту станции [station_name()] зафиксирован биологическая сигнатура яйца Императрицы Ужаса в [get_area(empress_egg)]. Уничтожите его для вырождения станционного выводка, пока не стало слишком поздно.", "ВНИМАНИЕ: БИОЛОГИЧЕСКАЯ УГРОЗА.", 'sound/effects/siren-spooky.ogg')

/datum/game_mode/proc/spider_win_announce()
	GLOB.command_announcement.Announce("Зафиксировано проявление Императрицы Ужаса на борту станции [station_name()], станция переклассифицированна в гнездо S класса. Взведение устройства самоуничтожения персоналом или внешними силами в данный момент не представляется возможным. Активация протоколов изоляции.", "Отчет об объекте [station_name()]")

/datum/game_mode/proc/get_spider_type(text_type)
	switch(text_type)
		if(TERROR_DEFILER)
			return /mob/living/simple_animal/hostile/poison/terror_spider/defiler
		if(TERROR_PRINCESS)
			return /mob/living/simple_animal/hostile/poison/terror_spider/queen/princess
		if(TERROR_QUEEN)
			return /mob/living/simple_animal/hostile/poison/terror_spider/queen
		if(TERROR_PRINCE)
			return /mob/living/simple_animal/hostile/poison/terror_spider/prince
		else
			return null

/datum/game_mode/proc/get_main_spiders()
	return main_spiders[TERROR_QUEEN] + \
			main_spiders[TERROR_PRINCE] + \
			main_spiders[TERROR_PRINCESS] + \
			main_spiders[TERROR_DEFILER]

/datum/game_mode/proc/check_main_spiders()
	var/list/major_spiders = get_main_spiders()
	for(var/datum/mind/spider as anything in major_spiders)
		if(!QDELETED(spider) && spider?.current?.stat != DEAD)
			return TRUE
	return FALSE


/datum/game_mode/proc/on_terror_infection_created(eggs)
	terror_infections |= eggs
	check_announce()
	if(infect_target.check_completion())
		for(var/datum/spider in main_spiders[TERROR_DEFILER])
			SEND_SIGNAL(spider, COMSIG_SPIDER_CAN_LAY)

/datum/game_mode/proc/on_minor_spider_created(mind)
	terror_spiders |= mind
	check_announce()
	if(lay_eggs_target?.check_completion())
		for(var/datum/spider in (main_spiders[TERROR_QUEEN] + main_spiders[TERROR_PRINCESS]))
			SEND_SIGNAL(spider, COMSIG_SPIDER_CAN_LAY)

/datum/game_mode/proc/get_terror_spiders_alife_count()
	var/alife_count = 0
	for(var/datum/mind/mind as anything in terror_spiders)
		if(!QDELETED(mind.current) && mind.current.stat != DEAD)
			alife_count++
	return alife_count

/datum/game_mode/proc/on_major_spider_created(mind, type)
	if(type == TERROR_OTHER)
		return
	var/list/spiders = main_spiders[type]
	spiders |= mind
	other_target?.generate_text()

/datum/game_mode/proc/check_announce()
	if(terror_announce)
		return TRUE
	var/crew_count = num_station_players()
	var/result = FALSE

	if(length(main_spiders[TERROR_PRINCE]))
		result = TRUE

	var/main_spider_exist = check_main_spiders()

	if(main_spider_exist && terror_infections.len > crew_count * 0.1)
		result = TRUE

	if(main_spider_exist && get_terror_spiders_alife_count() > crew_count * 0.07)
		result = TRUE

	if(result)
		terror_announce = TRUE
		addtimer(CALLBACK(src, PROC_REF(spider_announce)), 10 SECONDS)
	return result

/datum/game_mode/proc/on_major_spider_died(mind, type)
	other_target?.generate_text()
	if(!check_main_spiders())
		SSshuttle.stop_lockdown()


/datum/game_mode/proc/on_terror_infection_removed(eggs)
	terror_infections -= eggs

/datum/game_mode/proc/on_empress_egg_layed(egg)
	for(var/datum/spider as anything in terror_spiders)
		SEND_SIGNAL(spider, COMSIG_EMPRESS_EGG_LAYED)
	empress_egg = egg
	addtimer(CALLBACK(src, PROC_REF(egg_announce)), 10 SECONDS)


/datum/game_mode/proc/on_empress_egg_burst()
	empress_egg = null


/datum/game_mode/proc/on_empress_egg_destroyed()
	global_degenerate = TRUE
	for(var/mob/spider in GLOB.ts_spiderlist)
		if(spider)
			to_chat(spider, span_danger("Вы чувствуесте невообразимую боль. Яйцо императрицы уничтожено."))
	erase_eggs()

/datum/game_mode/proc/erase_eggs()
	for(var/infection in terror_infections)
		qdel(infection)
	for(var/egg in terror_eggs)
		qdel(egg)
