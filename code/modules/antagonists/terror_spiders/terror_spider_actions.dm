/datum/action/innate/lay_empress_egg
	button_icon =  'icons/mob/actions/actions_animal.dmi'
	button_icon = 'icons/mob/actions/actions.dmi'
	background_icon_state = "bg_default"
	button_icon_state = "lay_eggs_terror"
	name = "Отложить яйцо императрицы"
	desc = "Отложить яйцо Имератрицы ужаса."
	check_flags = AB_CHECK_CONSCIOUS|AB_TRANSFER_MIND

/datum/action/innate/lay_empress_egg/Activate()
	. = ..()
	if(SSticker?.mode?.empress_egg)
		to_chat(usr, span_warning("Кто-то и вашего гнезда уже отложил яйцо."))
		return
	if(SSticker?.mode?.global_degenerate)
		to_chat(usr, span_warning("Яйцо было уничтожено. Отложить новое невозможно."))
		return
	var/obj/structure/spider/eggcluster/terror_eggcluster/C = new /obj/structure/spider/eggcluster/terror_eggcluster/empress(get_turf(owner))
	C.spiderling_number = 1
	C.spider_mymother = owner
	SSticker.mode.on_empress_egg_layed(C)
