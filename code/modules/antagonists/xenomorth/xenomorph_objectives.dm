/datum/objective/xeno_get_power
	name = "Размножаться"
	needs_target = FALSE
	explanation_text = "Вы не должны этого видеть. Напишите баг репорт."
	var/targets_need = 0

/datum/objective/xeno_get_power/proc/generate_text()
	targets_need = EMPRESS_EVOLVE_TARGET_COUNT
	explanation_text = "Расплодитесь. Для того, чтобы вы могли эволюционировать в вашем улье должно быть [targets_need] ксеноморфов."
	return

/datum/objective/xeno_get_power/check_completion(datum/team/xenomorph/xeno_team)
	. = ..()

	if(completed)
		return .

	var/alife_count = xeno_team?.members.len

	if(alife_count >= targets_need)
		completed = TRUE
		return TRUE
	return .

/datum/objective/create_queen
	name = "Создать королеву"
	needs_target = FALSE
	explanation_text = "У улья должна появится королева. Для этого один из грудоломов должен эволюционировать сначала в дрона, а затем в королеву."

/datum/objective/protect_queen
	name = "Защитить"
	needs_target = FALSE
	explanation_text = "У улья появилась королева. Необходимо защищать ее любой ценой. Помимо этого необходимо увеличить численость улья. Чем больше улей, тем быстрее Королева сможет эволюционировать в Императрицу."

/datum/objective/protect_cocon
	name = "Защитить кокон"
	needs_target = FALSE
	explanation_text = "ОШИБКА "

/datum/objective/protect_cocon/proc/generate_text(area/location)
	explanation_text = "Королева начала эволюционировать в [location.name]. Она находится в стазисе внутри кокона и полностью беззащитна. Защитите её любой ценой."
	return
