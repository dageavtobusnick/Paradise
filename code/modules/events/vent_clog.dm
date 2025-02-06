/datum/event/vent_clog
	announceWhen	= 0
	startWhen		= 5
	endWhen			= 35
	var/interval 	= 2
	var/list/vents  = list()

/datum/event/vent_clog/announce()
	GLOB.event_announcement.Announce("Зафиксирован скачок обратного давления в системе вытяжных труб. Возможен выброс содержимого.", "ВНИМАНИЕ: АТМОСФЕРНАЯ ТРЕВОГА.")

/datum/event/vent_clog/setup()
	endWhen = rand(25, 100)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/temp_vent in GLOB.machines)
		if(is_station_level(temp_vent.loc.z))
			if(temp_vent.parent.other_atmosmch.len > 50)
				vents += temp_vent

/datum/event/vent_clog/tick()
	if(activeFor % interval == 0)
		var/obj/vent = pick_n_take(vents)

		var/list/gunk = list("water","carbon","flour","radium","toxin","cleaner","nutriment","condensedcapsaicin","psilocybin","lube",
							"atrazine","banana","charcoal","space_drugs","methamphetamine","holywater","ethanol","hot_coco","facid",
							"blood","morphine","ether","fluorine","mutadone","mutagen","hydrocodone","fuel",
							"haloperidol","lsd","syndicate_nanites","lipolicide","frostoil","salglu_solution","beepskysmash",
							"omnizine", "amanitin", "neurotoxin", "synaptizine", "rotatium")
		var/datum/reagents/R = new (2500)
		R.my_atom = vent
		R.add_reagent(pick(gunk), 2450)

		var/datum/effect_system/fluid_spread/smoke/chem/smoke = new
		smoke.set_up(range = 3, location = vent, carry = R, silent = TRUE)
		playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
		smoke.start()
		add_game_logs("Smoke at [COORD(vent)] spread including [R.reagent_list]")
		qdel(R)
