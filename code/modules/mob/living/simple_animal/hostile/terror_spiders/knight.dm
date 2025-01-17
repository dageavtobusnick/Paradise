

// --------------------------------------------------------------------------------
// ----------------- TERROR SPIDERS: T1 KNIGHT TERROR --------------------------------
// --------------------------------------------------------------------------------
// -------------: ROLE: generic attack spider
// -------------: AI: uses very powerful fangs to wreck people in melee
// -------------: SPECIAL: the more you hurt it, the harder it bites you
// -------------: TO FIGHT IT: shoot it from range. Kite it.
// -------------: SPRITES FROM: FoS, https://www.paradisestation.org/forum/profile/335-fos

/mob/living/simple_animal/hostile/poison/terror_spider/knight
	name = "Knight of Terror"
	desc = "Зловещий на вид красный паук, c восемь. красными глазами-бусинками и ужасными, большими, заостренными клыками! Похоже, у него порочная полоса шириной в милю."
	ru_names = list(
		NOMINATIVE = "рыцарь Ужаса",
		GENITIVE = "рыцаря Ужаса",
		DATIVE = "рыцарю Ужаса",
		ACCUSATIVE = "рыцаря Ужаса",
		INSTRUMENTAL = "рыцарем Ужаса",
		PREPOSITIONAL = "рыцаре Ужаса",
	)
	ai_target_method = TS_DAMAGE_BRUTE
	icon_state = "terror_red"
	icon_living = "terror_red"
	icon_dead = "terror_red_dead"
	maxHealth = 220
	health = 220
	damage_coeff = list(BRUTE = 0.6, BURN = 1.1, TOX = 1, CLONE = 0, STAMINA = 0, OXY = 0.2)
	melee_damage_lower = 15
	melee_damage_upper = 15
	obj_damage = 60
	environment_smash = ENVIRONMENT_SMASH_WALLS
	attack_sound = 'sound/creatures/terrorspiders/bite2.ogg'
	death_sound = 'sound/creatures/terrorspiders/death1.ogg'
	armour_penetration = 25
	move_to_delay = 10 // at 20ticks/sec, this is 2 tile/sec movespeed
	speed = 0.8
	spider_opens_doors = 2
	move_resist = MOVE_FORCE_STRONG // no more pushing a several hundred if not thousand pound spider
	web_type = /obj/structure/spider/terrorweb/knight
	spider_intro_text = "Будучи Рыцарем Ужаса, ваша задача - создавать места для прорыва, или же оборонять гнездо. Несмотря на медлительность, вы живучи и опасны вблизи, используйте свою силу и выносливость, чтобы другие пауки могли выполнять свои функции! Ваши способности позволяют вам переключаться между режимом атаки и обороны, первый - увеличивает скорость, а также наносимый и получаемый урон, второй - уменьшает скорость, получаемый и наносимый урон."
	gender = MALE
	tts_seed = "Chu"
	var/last_attack_mode = 0
	var/last_defence_mode = 0
	var/attack_mode_av = 1
	var/defence_mode_av = 1
	var/last_mode = 0
	var/current_mode = 0
	var/mode_cooldown = 300
	var/mode_duration = 100
	var/datum/action/innate/terrorspider/knight/defaultm/defaultmaction
	var/datum/action/innate/terrorspider/knight/attackm/attackmaction
	var/datum/action/innate/terrorspider/knight/defencem/defencemaction

/mob/living/simple_animal/hostile/poison/terror_spider/knight/New()
	..()
	attackmaction = new()
	attackmaction.Grant(src)
	defencemaction = new()
	defencemaction.Grant(src)

/mob/living/simple_animal/hostile/poison/terror_spider/knight/Life(seconds, times_fired)
	. = ..()
	if(stat != DEAD) // Can't use if(.) for this due to the fact it can sometimes return FALSE even when mob is alive.
		if(ckey)
			if (current_mode)
				if (world.time > (last_mode + mode_duration))
					activate_mode(0)
			if(world.time > (last_attack_mode + mode_cooldown))
				attack_mode_av = 1
			if(world.time > (last_defence_mode + mode_cooldown))
				defence_mode_av = 1

//MODE CHANGING. Knight has 3 modes, first - default, always active. Second - attack, grants increased speed and damage, but also increases damage you recieve.
//Third - defence, grants even slower movement speed then default, but you recieve much less damage.
//Both attack and defence mod lasts for 10 seconds and has a cd of 30. When you are out of non default modes your mode is set to default.
/mob/living/simple_animal/hostile/poison/terror_spider/knight/proc/activate_mode(n)
	var/t = world.time
	if	(n==0)
		playsound(src, 'sound/creatures/terrorspiders/keratosis_out.ogg', 150)
		to_chat(src, span_notice("Ваше тело расслабляется!"))
		set_varspeed(0.8)
		damage_coeff = list(BRUTE = 0.6, BURN = 1.1, TOX = 1, CLONE = 0, STAMINA = 0, OXY = 0.2)
		melee_damage_lower = 15
		melee_damage_upper = 15
		regeneration = 2
		current_mode = 0
		return TRUE
	if	(n==1)
		if(attack_mode_av)
			last_attack_mode = t
			last_mode = t
			attack_mode_av = 0
			playsound(src, 'sound/creatures/terrorspiders/mod_attack.ogg', 120)
			to_chat(src, span_notice("Вы впадаете ярость"))
			set_varspeed(0)
			damage_coeff = list(BRUTE = 0.8, BURN = 1.2, TOX = 1, CLONE = 0, STAMINA = 0, OXY = 0.2)
			melee_damage_lower = 30
			melee_damage_upper = 30
			regeneration = 0
			current_mode = 1
			return TRUE
		to_chat(src, span_notice("Вы пока не можете этого сделать!"))
		return FALSE
	if	(n==2)
		if(defence_mode_av)
			last_defence_mode = t
			last_mode = t
			defence_mode_av = 0
			playsound(src, 'sound/creatures/terrorspiders/keratosis_in.ogg', 150)
			to_chat(src, span_notice("Вы покрываетесь кератозисом!"))
			set_varspeed(1.6)
			damage_coeff = list(BRUTE = 0.4, BURN = 0.7, TOX = 1, CLONE = 0, STAMINA = 0, OXY = 0.2)
			melee_damage_lower = 10
			melee_damage_upper = 10
			regeneration = 6
			current_mode = 2
			return TRUE
		to_chat(src, span_notice("Вы пока не можете этого сделать!"))
		return FALSE

/obj/structure/spider/terrorweb/knight
	max_integrity = 30
	name = "reinforced web"
	desc = "Эта паутина усилена дополнительными нитями для дополнительной прочности."
	ru_names = list(
		NOMINATIVE = "укрепленная паутина",
		GENITIVE = "укрепленной паутины",
		DATIVE = "укрепленной паутине",
		ACCUSATIVE = "укрепленную паутину",
		INSTRUMENTAL = "укрепленной паутиной",
		PREPOSITIONAL = "укрепленной паутине",
	)
