/datum/action/innate/terrorspider/lay_empress_egg
	name = "Отложить яйцо Императрицы"
	desc = "Отложить яйцо Имератрицы ужаса."
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "eggs"
	check_flags = AB_CHECK_CONSCIOUS|AB_TRANSFER_MIND

/datum/action/innate/terrorspider/lay_empress_egg/Activate()
	. = ..()
	if(SSticker?.mode?.empress_egg)
		to_chat(usr, span_warning("Вы или кто-то из вашего гнезда уже отложили яйцо Императрицы."))
		return
	if(SSticker?.mode?.global_degenerate)
		to_chat(usr, span_warning("Яйцо было уничтожено. Отложить новое невозможно."))
		return
	if(tgui_alert(usr, "Вы действительно готовы отложить яйцо Имератрицы Ужаса?", "", list("Да", "Нет")) != "Да")
		return
	var/obj/structure/spider/eggcluster/terror_eggcluster/C = new /obj/structure/spider/eggcluster/terror_eggcluster/empress(get_turf(owner))
	C.spiderling_number = 1
	C.spider_mymother = owner
	SSticker.mode.on_empress_egg_layed(C)
	var/mob/living/simple_animal/hostile/poison/terror_spider/spider = owner
	if(istype(spider))
		spider.msg_terrorspiders("Яйцо императрицы ужаса отложено в [get_area(owner)]. Защищайте его любой ценой.")
