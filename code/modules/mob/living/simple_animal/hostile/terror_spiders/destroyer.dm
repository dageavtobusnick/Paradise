// --------------------------------------------------------------------------------
// ----------------- TERROR SPIDERS: T2 DESTROYER TERROR ------------------------------
// --------------------------------------------------------------------------------
// -------------: ROLE: breaking vents
// -------------: AI: ventcrawls a lot, breaks open vents
// -------------: SPECIAL: ventsmash
// -------------: TO FIGHT IT: blast it before it can get away!
// -------------: SPRITES FROM: IK3I

/mob/living/simple_animal/hostile/poison/terror_spider/destroyer
	name = "Destroyer of Terror"
	desc = "Зловещего вида паук, коричневый, как земля, из которой он выполз. На предплечьях имеются острые когти."
	ru_names = list(
		NOMINATIVE = "разрушитель Ужаса",
		GENITIVE = "разрушителя Ужаса",
		DATIVE = "разрушителю Ужаса",
		ACCUSATIVE = "разрушителя Ужаса",
		INSTRUMENTAL = "разрушителем Ужаса",
		PREPOSITIONAL = "разрушителе Ужаса",
	)
	ai_target_method = TS_DAMAGE_BRUTE
	icon_state = "terror_brown"
	icon_living = "terror_brown"
	icon_dead = "terror_brown_dead"
	gender = MALE
	maxHealth = 120
	health = 120
	speed = -0.1
	melee_damage_lower = 10
	melee_damage_upper = 15
	obj_damage = 100 //for effective breaching
	move_to_delay = 20
	spider_opens_doors = 2 // Breach specialist.
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	spider_tier = TS_TIER_2
	ai_ventbreaker = 1
	freq_ventcrawl_combat = 600 // Ventcrawls very frequently, breaking open vents as it goes.
	freq_ventcrawl_idle =  1800
	can_wrap = FALSE
	web_type = null
	tts_seed = "Zuljin"
	special_abillity = list(/obj/effect/proc_holder/spell/emplosion/terror_emp,
							/obj/effect/proc_holder/spell/explosion/terror_burn)
	spider_intro_text = "Будучи Разрушителем Ужаса, ваша цель - саботировать станцию. Выбивайте заваренную вентиляцию, ломайте канистры с опасными газами, уничтожайте АПЦ и любое оборудование, до которого доберётесь. Помните, вы - не боевой паук, хоть вы и можете справиться с небольшой угрозой, убийства это не ваша забота!"
	var/datum/action/innate/terrorspider/ventsmash/ventsmash_action

/mob/living/simple_animal/hostile/poison/terror_spider/destroyer/New()
	..()
	ventsmash_action = new()
	ventsmash_action.Grant(src)

/mob/living/simple_animal/hostile/poison/terror_spider/destroyer/death(gibbed)
	if(can_die())
		if(!gibbed)
			empulse(src.loc, 6, 3, TRUE, cause = src)
	return ..()
