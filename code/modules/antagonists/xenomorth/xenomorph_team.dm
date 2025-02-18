/datum/team/xenomorph
	name = "Ксеноморфы"
	antag_datum_type = /datum/antagonist/xenomorph
	var/datum/mind/current_queen
	var/datum/mind/current_empress
	var/datum/objective/xeno_get_power/xeno_power_objective
	var/datum/objective/create_queen/create_queen
	var/datum/objective/protect_queen/protect_queen
	var/datum/objective/protect_cocon/protect_cocon
	var/announce = FALSE
	var/evolves_count = 0
	var/grant_action = FALSE

/datum/team/xenomorph/New(list/starting_members)
	create_queen = new
	create_queen.owner = src
	objectives += create_queen
	. = ..()


/datum/team/xenomorph/add_member(datum/mind/new_member, add_objectives)
	var/is_queen = new_member?.current && isalienqueen(new_member.current)
	. = ..(new_member, !is_queen)
	RegisterSignal(new_member, COMSIG_ALIEN_EVOLVE, PROC_REF(on_alien_evolve))
	if(is_queen && !current_queen)
		add_queen(new_member)
	check_queen_power()

/datum/team/xenomorph/remove_member(datum/mind/new_member)
	UnregisterSignal(new_member, COMSIG_ALIEN_EVOLVE)
	. = ..()

/datum/team/xenomorph/add_objective_to_members(datum/objective/objective, member_blacklist = list(current_queen, current_empress))
	. = ..()


/datum/team/xenomorph/proc/on_alien_evolve(datum/mind/source, old_type, new_type)
	SIGNAL_HANDLER
	if(!istype(source))
		return
	if(ispath(old_type, LARVA_TYPE))
		evolves_count++
		check_announce()
		source.remove_antag_datum(/datum/antagonist/xenomorph)
		var/datum/antagonist/xenomorph/datum = new
		source.add_antag_datum(datum, type)

	if(ispath(new_type, QUEEN_TYPE))
		add_queen(source)

	if(ispath(new_type, EMPRESS_TYPE))
		current_empress = source

/datum/team/xenomorph/proc/add_queen(datum/mind/queen)
	current_queen = queen
	create_queen.completed = TRUE
	protect_queen = new
	protect_queen.owner = src
	add_objective_to_members(protect_queen)
	xeno_power_objective = new
	xeno_power_objective.owner = src
	xeno_power_objective.generate_text()
	queen.remove_antag_datum(/datum/antagonist/xenomorph)
	var/datum/antagonist/xenomorph/queen/datum = new
	datum.objectives |= xeno_power_objective
	datum.team = src
	queen.add_antag_datum(datum, type)

/datum/team/xenomorph/proc/check_queen_power()
	var/mob/queen_mob = current_queen?.current
	if(!grant_action && xeno_power_objective?.check_completion(src) && !isnull(queen_mob?.stat) && queen_mob.stat != DEAD)
		var/datum/action/innate/start_evolve_to_empress/evolve = new
		evolve.Grant(queen_mob)
		evolve.xeno_team = WEAKREF(src)
		grant_action = TRUE

/datum/team/xenomorph/proc/check_announce()
	if(announce)
		return TRUE
	var/crew_count = num_station_players()
	var/queen_exist = current_queen?.current && current_queen.current.stat != DEAD
	if(queen_exist && evolves_count > crew_count * EVOLVE_ANNOUNCE_TRIGGER)
		announce = TRUE
		announce()
		return TRUE
	return FALSE

/datum/team/xenomorph/proc/announce()
	GLOB.event_announcement.Announce("Вспышка биологической угрозы 4-го уровня зафиксирована на борту станции [station_name()]. Всему персоналу надлежит сдержать её распространение любой ценой! Особая директива распечатана на всех консолях связи.", "ВНИМАНИЕ: БИОЛОГИЧЕСКАЯ УГРОЗА.", 'sound/effects/siren-spooky.ogg')
	SSticker?.mode?.special_directive()
	SSshuttle?.emergency.cancel()
	SSshuttle?.lockdown_escape()

/datum/team/xenomorph/proc/evolve_anounce()
	GLOB.event_announcement.Announce("Вспышка биологической угрозы 4-го уровня зафиксирована на борту станции [station_name()]. Всему персоналу надлежит сдержать её распространение любой ценой! Особая директива распечатана на всех консолях связи.", "ВНИМАНИЕ: БИОЛОГИЧЕСКАЯ УГРОЗА.", 'sound/effects/siren-spooky.ogg')

/datum/team/xenomorph/proc/evolve_start(area/loc)
	protect_queen.completed = TRUE
	protect_cocon = new
	protect_cocon.owner = src
	protect_cocon.generate_text(loc)
	add_objective_to_members(protect_cocon)
	for(var/datum/mind/mind as anything in members)
		if(mind == current_queen || mind == current_empress)
			continue
		if(!mind?.current || mind.current.stat == DEAD)
			continue
		to_chat(mind.current, span_alien("Королева начала эволюционировать в [loc.name]. Она находится в стазисе внутри кокона и полностью беззащитна. Защитите её любой ценой."))

/datum/team/xenomorph/proc/evolve_end_anounce()

/datum/team/xenomorph/proc/game_end_anounce()

/proc/spawn_aliens(spawn_count)
	var/spawn_vectors = tgui_alert(usr, "Какой тип ксеноморфа заспавнить?", "Тип ксеноморфов", list("Вектор", "Грудолом")) == "Вектор"
	var/list/vents = get_valid_vent_spawns(exclude_mobs_nearby = TRUE, exclude_visible_by_mobs = TRUE)
	if(spawn_vectors)
		spawn_vectors(vents, spawn_count)
	else
		spawn_larvas(vents, spawn_count)

/proc/spawn_larvas(list/vents, spawncount)
	var/list/candidates = SSghost_spawns.poll_candidates("Вы хотите сыграть за Чужого?", ROLE_ALIEN, TRUE, source = /mob/living/carbon/alien/larva)
	var/first_spawn = TRUE
	while(spawncount && length(vents) && length(candidates))
		var/obj/vent = pick_n_take(vents)
		var/mob/C = pick_n_take(candidates)
		if(C)
			GLOB.respawnable_list -= C
			var/mob/living/carbon/alien/larva/new_xeno = new(vent.loc)
			new_xeno.evolution_points += (0.75 * new_xeno.max_evolution_points)	//event spawned larva start off almost ready to evolve.
			new_xeno.key = C.key

			if(first_spawn)
				new_xeno.queen_maximum++
				first_spawn = FALSE

			new_xeno.update_datum()

			spawncount--
			log_game("[new_xeno.key] has become [new_xeno].")

/proc/spawn_vectors(list/vents, spawncount)
	spawncount = 1
	var/list/candidates = SSghost_spawns.poll_candidates("Вы хотите сыграть за Чужого Вектора?", ROLE_ALIEN, TRUE, source = /mob/living/carbon/alien/humanoid/hunter/vector)
	var/first_spawn = TRUE
	while(spawncount && length(vents) && length(candidates))
		var/obj/vent = pick_n_take(vents)
		var/mob/C = pick_n_take(candidates)
		if(C)
			GLOB.respawnable_list -= C
			var/mob/living/carbon/alien/humanoid/hunter/vector/new_xeno = new(vent.loc)
			new_xeno.key = C.key

			if(first_spawn)
				new_xeno.queen_maximum++
				first_spawn = FALSE
			new_xeno.update_datum()

			spawncount--
			log_game("[new_xeno.key] has become [new_xeno].")
