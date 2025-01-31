/*****************Pickaxes & Drills & Shovels****************/
/obj/item/pickaxe
	name = "pickaxe"
	ru_names = list(
		NOMINATIVE = "кирка",
		GENITIVE = "кирки",
		DATIVE = "кирке",
		ACCUSATIVE = "кирку",
		INSTRUMENTAL = "киркой",
		PREPOSITIONAL = "кирке"
	)
	desc = "Стандартная кирка, предназначенная для разрушения камней."
	icon = 'icons/obj/items.dmi'
	icon_state = "pickaxe"
	flags = CONDUCT
	slot_flags = ITEM_SLOT_BELT
	force = 15
	throwforce = 10
	item_state = "pickaxe"
	w_class = WEIGHT_CLASS_BULKY
	materials = list(MAT_METAL=2000) //one sheet, but where can you make them?
	origin_tech = "materials=2;engineering=3"
	attack_verb = list("ударил", "проколол", "атаковал")
	var/drill_verb = "picking"
	sharp = 1
	embed_chance = 15
	embedded_ignore_throwspeed_threshold = TRUE
	var/excavation_amount = 100
	usesound = 'sound/effects/picaxe1.ogg'
	toolspeed = 0.8


/obj/item/pickaxe/emergency
	name = "emergency disembarkation tool"
	ru_names = list(
		NOMINATIVE = "инструмент для экстренной раскопки",
		GENITIVE = "инструмента для экстренной раскопки",
		DATIVE = "инструменту для экстренной раскопки",
		ACCUSATIVE = "инструмент для экстренной раскопки",
		INSTRUMENTAL = "инструментом для экстренной раскопки",
		PREPOSITIONAL = "инструменте для экстренной раскопки"
	)
	desc = "Кирка, предназначенная для спасения из затруднительных ситуаций."
	icon_state = "emergency_disembarkation_tool"
	item_state = "emergency_disembarkation_tool"

/obj/item/pickaxe/safety
	name = "safety pickaxe"
	ru_names = list(
		NOMINATIVE = "безопасная кирка",
		GENITIVE = "безопасной кирки",
		DATIVE = "безопасной кирке",
		ACCUSATIVE = "безопасную кирку",
		INSTRUMENTAL = "безопасной киркой",
		PREPOSITIONAL = "безопасной кирке"
	)
	desc = "Кирка, специально спроектированная исключительно для добычи ресурсов. Крайне неэффективна в качестве оружия."
	icon_state = "safety_pickaxe"
	item_state = "safety_pickaxe"
	force = 1
	throwforce = 1
	attack_verb = list("неэффективно ударил")

/obj/item/pickaxe/mini
	name = "compact pickaxe"
	ru_names = list(
		NOMINATIVE = "компактная кирка",
		GENITIVE = "компактной кирки",
		DATIVE = "компактной кирке",
		ACCUSATIVE = "компактую кирку",
		INSTRUMENTAL = "компактной киркой",
		PREPOSITIONAL = "компактной кирке"
	)
	desc = "Сильно уменьшенная версия стандартной кирки."
	icon_state = "compact_pickaxe"
	item_state = "compact_pickaxe"
	force = 10
	throwforce = 7
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL = 1000)

/obj/item/pickaxe/silver
	name = "silver-plated pickaxe"
	ru_names = list(
		NOMINATIVE = "кирка с серебрянным наконечником",
		GENITIVE = "кирки с серебрянным наконечником",
		DATIVE = "кирке с серебрянным наконечником",
		ACCUSATIVE = "кирку с серебрянным наконечником",
		INSTRUMENTAL = "киркой с серебрянным наконечником",
		PREPOSITIONAL = "кирке с серебрянным наконечником"
	)
	icon_state = "spickaxe"
	item_state = "spickaxe"
	belt_icon = "silver-plated pickaxe"
	origin_tech = "materials=3;engineering=4"
	toolspeed = 0.4 //mines faster than a normal pickaxe, bought from mining vendor
	desc = "Кирка, сделанная из серебра. Она показывает себя слегка лучше в добыче ресурсов, чем стандартная."
	force = 17

/obj/item/pickaxe/gold
	name = "gold-tipped pickaxe"
	ru_names = list(
		NOMINATIVE = "кирка с золотым наконечником",
		GENITIVE = "кирки с золотым наконечником",
		DATIVE = "кирке с золотым наконечником",
		ACCUSATIVE = "кирку с золотым наконечником",
		INSTRUMENTAL = "киркой с золотым наконечником",
		PREPOSITIONAL = "кирке с золотым наконечником"
	)
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	belt_icon = "golden pickaxe"
	origin_tech = "materials=4;engineering=4"
	toolspeed = 0.3
	desc = "Кирка, сделанная из золота. Она показывает себя значительно лучше в добыче ресурсов, чем стандартная."
	force = 18

/obj/item/pickaxe/diamond
	name = "diamond-tipped pickaxe"
	ru_names = list(
		NOMINATIVE = "кирка с алмазным наконечником",
		GENITIVE = "кирки с алмазным наконечником",
		DATIVE = "кирке с алмазным наконечником",
		ACCUSATIVE = "кирку с алмазным наконечником",
		INSTRUMENTAL = "киркой с алмазным наконечником",
		PREPOSITIONAL = "кирке с алмазным наконечником"
	)
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	belt_icon = "diamond-tipped pickaxe"
	origin_tech = "materials=5;engineering=4"
	toolspeed = 0.2
	desc = "Кирка с алмазным наконечником. Крайне эффективна в добыче камня и вскапывании земли."
	force = 19

/obj/item/pickaxe/drill
	name = "mining drill"
	ru_names = list(
		NOMINATIVE = "шахтерская дрель",
		GENITIVE = "шахтерской дрели",
		DATIVE = "шахтерской дрели",
		ACCUSATIVE = "шахтерскую дрель",
		INSTRUMENTAL = "шахтерской дрелью",
		PREPOSITIONAL = "шахтерской дрели"
	)
	icon_state = "handdrill"
	item_state = "jackhammer"
	toolspeed = 0.4 //available from roundstart, faster than a pickaxe.
	hitsound = 'sound/weapons/drill.ogg'
	usesound = 'sound/weapons/drill.ogg'
	origin_tech = "materials=2;powerstorage=2;engineering=3"
	desc = "An electric mining drill for the especially scrawny."
	desc = "Электрическая буровая дрелль, используемая теми, для кого кирка слишком тяжела в обращении."

/obj/item/pickaxe/drill/cyborg
	name = "cyborg mining drill"
	ru_names = list(
		NOMINATIVE = "шахтерская дрель киборга",
		GENITIVE = "шахтерской дрели киборга",
		DATIVE = "шахтерской дрели киборга",
		ACCUSATIVE = "шахтерскую дрель киборга",
		INSTRUMENTAL = "шахтерской дрелью киборга",
		PREPOSITIONAL = "шахтерской дрели киборга"
	)
	desc = "Встроенная электрическая буровая дрелль."


/obj/item/pickaxe/drill/cyborg/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)


/obj/item/pickaxe/drill/diamonddrill
	name = "diamond-tipped mining drill"
	ru_names = list(
		NOMINATIVE = "алмазная шахтерская дрель",
		GENITIVE = "алмазной шахтерской дрели",
		DATIVE = "алмазной шахтерской дрели",
		ACCUSATIVE = "алмазную шахтерскую дрель",
		INSTRUMENTAL = "алмазной шахтерской дрелью",
		PREPOSITIONAL = "алмазной шахтерской дрели"
	)
	icon_state = "diamonddrill"
	origin_tech = "materials=6;powerstorage=4;engineering=4"
	desc = "У тебя есть дрелль, которая пронзит небеса!"
	toolspeed = 0.1

/obj/item/pickaxe/drill/cyborg/diamond //This is the BORG version!
	name = "diamond-tipped cyborg mining drill" //To inherit the NODROP trait, and easier to change borg specific drill mechanics.
	ru_names = list(
		NOMINATIVE = "алмазная шахтерская дрель киборга",
		GENITIVE = "алмазной шахтерской дрели киборга",
		DATIVE = "алмазной шахтерской дрели киборга",
		ACCUSATIVE = "алмазную шахтерскую дрель киборга",
		INSTRUMENTAL = "алмазной шахтерской дрелью киборга",
		PREPOSITIONAL = "алмазной шахтерской дрели киборга"
	)
	icon_state = "diamonddrill"
	toolspeed = 0.1

/obj/item/pickaxe/drill/jackhammer
	name = "sonic jackhammer"
	ru_names = list(
		NOMINATIVE = "звуковой отбойный молот",
		GENITIVE = "звукового отбойного молота",
		DATIVE = "звуковому отбойному молоту",
		ACCUSATIVE = "звуковой отбойный молот",
		INSTRUMENTAL = "звуковым отбойным молотом",
		PREPOSITIONAL = "звуковом отбойным молоте"
	)
	icon_state = "jackhammer"
	item_state = "jackhammer"
	origin_tech = "materials=6;powerstorage=4;engineering=5;magnets=4"
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	desc = "Уничтожает камни с использованием звука, может использоваться как инструмент для сноса стен."
	toolspeed = 0.0 //the epitome of powertools, literally instant
	var/wall_toolspeed = 0.1 //instant wall breaking is bad.

/obj/item/shovel
	name = "shovel"
	ru_names = list(
		NOMINATIVE = "лопата",
		GENITIVE = "лопаты",
		DATIVE = "лопате",
		ACCUSATIVE = "лопату",
		INSTRUMENTAL = "лопатой",
		PREPOSITIONAL = "лопате"
	)
	desc = "Массивный инструмент для вскапывания и перемещения земли."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = ITEM_SLOT_BELT
	force = 8
	throwforce = 4
	item_state = "shovel"
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=50)
	origin_tech = "materials=2;engineering=2"
	attack_verb = list("ударил", "огрел")
	hitsound = 'sound/effects/Shovel_hitting_sound.ogg'
	usesound = 'sound/effects/shovel_dig.ogg'
	toolspeed = 0.8

/obj/item/shovel/spade
	name = "spade"
	ru_names = list(
		NOMINATIVE = "лопатка",
		GENITIVE = "лопатки",
		DATIVE = "лопатке",
		ACCUSATIVE = "лопатку",
		INSTRUMENTAL = "лопаткой",
		PREPOSITIONAL = "лопатке"
	)
	desc = "Маленький инструмент для вскапывания и перемещения земли."
	icon_state = "spade"
	item_state = "spade"
	belt_icon = "spade"
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL

/obj/item/shovel/spade/wooden
	name = "wooden spade"
	ru_names = list(
		NOMINATIVE = "деревянная лопатка",
		GENITIVE = "деревянной лопатки",
		DATIVE = "деревянной лопатке",
		ACCUSATIVE = "деревянную лопатку",
		INSTRUMENTAL = "деревянной лопаткой",
		PREPOSITIONAL = "деревянной лопатке"
	)
	desc = "Маленький инструмент для вскапывания и перемещения земли. Эта модель сделана из древесины."

/obj/item/shovel/safety
	name = "safety shovel"
	ru_names = list(
		NOMINATIVE = "безопасная лопата",
		GENITIVE = "безопасной лопаты",
		DATIVE = "безопасной лопате",
		ACCUSATIVE = "безопасную лопату",
		INSTRUMENTAL = "безопасной лопатой",
		PREPOSITIONAL = "безопасной лопате"
	)
	icon_state = "safety_shovel"
	item_state = "safety_shovel"
	desc = "Массивный инструмент для вскапывания и перемещения земли. Данная версия была модифицирована для большей безопасности и крайне неэффективна в качестве оружия."
	force = 1
	throwforce = 1
	attack_verb = list("неэффективно ударил")
