/obj/item/reagent_containers/food/snacks/bait
	name = "worm"
	ru_names = list(
		NOMINATIVE = "червяк",
		GENITIVE = "червяков",
		DATIVE = "червяку",
		ACCUSATIVE = "червяка",
		INSTRUMENTAL = "червяком",
		PREPOSITIONAL = "червякам",
	) //actually, only two of them are actually used in game, so...
	desc = "Тестовая наживка, если вы это видите, пингуйте зюзю."
	icon = 'icons/obj/lavaland/lava_fishing.dmi'
	icon_state = "ash_eater"
	lefthand_file = 'icons/mob/inhands/lavaland/bait_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/lavaland/bait_righthand.dmi'
	item_state = "ash_eater"
	list_reagents = list("protein" = 1) //mmmm tasty
	tastes = list("ash" = 5, "hopelessness" = 1)
	bitesize = 1
	foodtype = MEAT
	/// This will be visually shown on fishing rod.
	var/rod_overlay  = "ash_eater_rod"

/obj/item/reagent_containers/food/snacks/bait/examine(mob/user)
	. = ..()
	. += span_notice("Вы можете использовать [declent_ru(ACCUSATIVE)] в качестве наживки.")

/obj/item/reagent_containers/food/snacks/bait/ash_eater
	name = "ash eater"
	ru_names = list(
		NOMINATIVE = "пожиратель пепла",
		GENITIVE = "пожирателя пепла",
		DATIVE = "пожирателю пепла",
		ACCUSATIVE = "пожирателя пепла",
		INSTRUMENTAL = "пожирателем пепла",
		PREPOSITIONAL = "пожирателе пепла",
	)
	desc = "Маленький червячок со множеством невероятно острых зубов, покрывающим его ротовую полость. Ходят слухи, что эти крохи способны вырастать до размеров целого города. Пепел должен течь рекой."
	icon_state = "ash_eater"
	rod_overlay = "ash_eater_rod"

/obj/item/reagent_containers/food/snacks/bait/bloody_leach
	name = "bloody leach"
	ru_names = list(
		NOMINATIVE = "кровавая пиявка",
		GENITIVE = "кровавой пиявки",
		DATIVE = "кровавой пиявке",
		ACCUSATIVE = "кровавую пиявку",
		INSTRUMENTAL = "кровавой пиявкой",
		PREPOSITIONAL = "кровавой пиявке",
	)
	desc = "Паразитическая форма жизни Лазис Ардакса, которая цепляется к оголённым участкам кожи и питается своими жертвами. Её брюшко краснеет от количества выпитой ею крови."
	icon_state = "bloody_leach"
	item_state = "bloody_leach"
	rod_overlay = "bloody_leach_rod"

/obj/item/reagent_containers/food/snacks/bait/goldgrub_larva
	name = "goldgrub larva"
	ru_names = list(
		NOMINATIVE = "личинка златожора",
		GENITIVE = "личинки златожора",
		DATIVE = "личинке златожора",
		ACCUSATIVE = "личинку златожора",
		INSTRUMENTAL = "личинкой златожора",
		PREPOSITIONAL = "личинке златожора",
	)
	desc = "Небольшой червячок, который питается минералами, закопанными в пепле. Он так же пуглив, как и его более старшие сородичи."
	icon_state = "goldgrub_larva"
	item_state = "goldgrub_larva"
	rod_overlay = "goldgrub_larva_rod"

/obj/item/reagent_containers/food/snacks/charred_krill
	name = "charred krill"
	ru_names = list(
		NOMINATIVE = "обугленная креветка",
		GENITIVE = "обугленной креветки",
		DATIVE = "обугленной креветке",
		ACCUSATIVE = "обугленную креветку",
		INSTRUMENTAL = "обугленной креветкой",
		PREPOSITIONAL = "обугленной креветке",
	)
	desc = "Одна из самых редких обиталей Лазис Ардакса, множество лет признанная вымершей. Эта креветка - одно из самых любимых угощений для местной \"подводной\" фауны."
	icon = 'icons/obj/lavaland/lava_fishing.dmi'
	icon_state = "charred_krill"
	item_state = "charred_krill"
	list_reagents = list("protein" = 1)
	bitesize = 1
	tastes = list("ash" = 5, "wasted opportunity" = 1)
	var/in_lava = FALSE

/obj/item/reagent_containers/food/snacks/charred_krill/examine(mob/user)
	. = ..()
	. += span_notice("Вы можете бросить [declent_ru(ACCUSATIVE)]  в лаву, чтобы привлечь рыбу к поверхности.")

/obj/item/reagent_containers/food/snacks/charred_krill/can_be_pulled(atom/movable/user, force, show_message)
	if(in_lava)
		if(show_message)
			to_chat(user, span_warning("[declent_ru(NOMINATIVE)] почти утонула в лаве!"))
			return

/obj/item/reagent_containers/food/snacks/charred_krill/attack_hand(mob/user, pickupfireoverride)
	if(in_lava)
		return
	else
		return ..()

/obj/item/reagent_containers/food/snacks/charred_krill/suicide_act(mob/user) //I forbid you to translate it.
	user.visible_message(span_suicide("[user] is going to krill himself! Oh god..."))
	user.say("goodbye krill world.")
	sleep(20)
	var/obj/item/reagent_containers/food/snacks/charred_krill/krill = new /obj/item/reagent_containers/food/snacks/charred_krill(drop_location())
	krill.desc += " Look's like someone KRILLED himself."
	qdel(user)
	return OBLITERATION
