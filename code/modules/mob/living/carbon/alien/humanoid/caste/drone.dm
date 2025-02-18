/mob/living/carbon/alien/humanoid/drone
	name = "alien drone"
	caste = "d"
	maxHealth = 180
	health = 180
	obj_damage = 60
	icon_state = "aliend_s"
	time_to_open_doors = 0.2 SECONDS
	can_evolve = TRUE
	role_text = "Вы трутень. Ваша основная задача - помощь королеве в обустройстве гнезда. Если в улье все еще нет, вам необходимо как можно быстрее в нее эволюционировать."
	var/sterile = FALSE


/mob/living/carbon/alien/humanoid/drone/New()
	if(src.name == "alien drone")
		src.name = text("alien drone ([rand(1, 1000)])")
	src.real_name = src.name
	..()
	AddSpell(new /obj/effect/proc_holder/spell/alien_spell/break_vents)
	if(!sterile)
		AddSpell(new /obj/effect/proc_holder/spell/alien_spell/evolve/queen)


/mob/living/carbon/alien/humanoid/drone/get_caste_organs()
	. = ..()
	. += list(
		/obj/item/organ/internal/xenos/plasmavessel/drone,
		/obj/item/organ/internal/xenos/acidgland,
		/obj/item/organ/internal/xenos/resinspinner,
	)


/mob/living/carbon/alien/humanoid/drone/no_queen
	sterile = TRUE

