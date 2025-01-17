
/mob/living/simple_animal/hostile/poison/terror_spider/Topic(href, href_list)
	if(href_list["activate"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			humanize_spider(ghost)

/mob/living/simple_animal/hostile/poison/terror_spider/attack_ghost(mob/user)
	humanize_spider(user)

/mob/living/simple_animal/hostile/poison/terror_spider/proc/humanize_spider(mob/user)
	if(key)//Someone is in it
		return
	var/error_on_humanize = ""
	var/humanize_prompt = "Управлять пауком ужеса [src]?"
	humanize_prompt += " Роль: [spider_intro_text]"
	if(user.ckey in GLOB.ts_ckey_blacklist)
		error_on_humanize = "В этом раунде вы не можете управлять пауками ужаса."
	else if(cannotPossess(user))
		error_on_humanize = "Вы включили Antag HUD и не можете повторно войти в раунд.."
	else if(spider_awaymission)
		error_on_humanize = "Пауки Ужаса из гейтов не могут управляться игроками."
	else if(!ai_playercontrol_allowtype)
		error_on_humanize = "Этот конкретный тип паука ужаса не может управляться игроком."
	else if(degenerate)
		error_on_humanize = "Умирающими пауками нельзя управлять."
	else if(stat == DEAD)
		error_on_humanize = "Мертвыми пауками невозможно управлять."
	else if(!(user in GLOB.respawnable_list))
		error_on_humanize = "Вы не можете повторно присоединиться к раунду."
	if(jobban_isbanned(user, ROLE_SYNDICATE) || jobban_isbanned(user,	ROLE_TERROR_SPIDER))
		to_chat(user,"Вы имеете джоббан на антагонистов и/или пауков ужаса.")
		return
	if(error_on_humanize == "")
		var/spider_ask = tgui_alert(user, humanize_prompt, "Управлять Пауком Ужаса?", list("Да", "Нет"))
		if(spider_ask != "Да" || !src || QDELETED(src))
			return
	else
		to_chat(user, "Нельзя управлять пауком: [error_on_humanize]")
		return
	if(key)
		to_chat(user, span_notice("Кто-то другой уже управляет этим пауком."))
		return
	key = user.key
	add_datum_if_not_exist()
	for(var/mob/dead/observer/G in GLOB.player_list)
		G.show_message("<i>Призрак взял управление <b>[declent_ru(INSTRUMENTAL)]</b>. ([ghost_follow_link(src, ghost=G)]).</i>")


/mob/living/simple_animal/hostile/poison/terror_spider/proc/add_datum_if_not_exist()
	if(mind && !mind.has_antag_datum(/datum/antagonist/terror_spider))
		mind.add_antag_datum(datum_type)
