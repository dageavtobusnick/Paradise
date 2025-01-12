/datum/action/innate/lay_empress_egg
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon = 'icons/mob/actions/actions.dmi'
	background_icon_state = "block"
	button_icon_state = "bg_default"
	name = "Отложить яйцо императрицы"
	desc = "Отложить яйцо Имератрицы ужаса."
	check_flags = AB_CHECK_CONSCIOUS|AB_TRANSFER_MIND

/datum/action/innate/lay_empress_egg/Activate()
	. = ..()
	var/obj/structure/spider/eggcluster/terror_eggcluster/C = new /obj/structure/spider/eggcluster/terror_eggcluster(get_turf(owner), lay_type)