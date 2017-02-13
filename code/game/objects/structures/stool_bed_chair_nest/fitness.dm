//ÒÐÅÍÀÆÅÐ×ÈÊÈ ÎÒ ÃÎËÓÁß + ÌÎÐÊÎÂÊÈÍÀ ÄÎÐÀÁÎÒÊÀ

/obj/structure/stool/bed/chair/fitness/lifter
	anchored = 1
	name = "Exercise machine"
	desc = "Used to keep your form."
	icon_state = "fitnesslifter"

/obj/structure/stool/bed/chair/fitness/lifter/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/chair/fitness/lifter/attack_hand(mob/user as mob)
	user << "You can't unbuckle now. Please wait."

/obj/structure/stool/bed/chair/fitness/lifter/MouseDrop_T(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!istype(M)) return
//	var/mob/living/carbon/human/target = null
//	if(ishuman(M))
//		target = M
	if(M.handcuffed)
		user << "You can't buckle yourself. You are handcuffed."

	if(M.loc != src.loc)
		user << "You can't buckle yourself. You are too far."

	else
		buckle_mob(M, user)
		icon_state = "fitnesslifter1"
		M.dir = SOUTH
		user << "\red You start doing the exercises."

		sleep(50)

		user << "\red You finish doing the exercises."
		unbuckle()

/obj/structure/stool/bed/chair/fitness/lifter/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
			icon_state = "fitnesslifter"
	return


//ÁÎÊÑÅÐÑÊÈÅ ÃÐÓØÈ
/obj/structure/punchingbag //Ñòàíäàðòíàÿ
	anchored = 1
	density = 1
	name = "Punching Bag"
	desc = "You can punch it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "punchingbagsyndie"
	var/icon_punched
	icon_punched = "punchingbagsyndie2"

/obj/structure/punchingbag/attack_hand(mob/user as mob)
	var/list/punchSound = list('sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')
	var/punch = pick(punchSound)
	playsound(get_turf(src), punch, 40, 0)
	flick(src.icon_punched,src)



/obj/structure/punchingbag/clown //Êëîóíîâñêàÿ
	anchored = 1
	density = 1
	name = "Punching Bag"
	desc = "You can punch it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bopbag"
	icon_punched = "bopbag2"

/obj/structure/punchingbag/clown/attack_hand(mob/user as mob)
	var/list/punchSound = list('sound/effects/clownstep1.ogg', 'sound/effects/clownstep2.ogg', 'sound/items/bikehorn.ogg')
	var/punch = pick(punchSound)
	playsound(get_turf(src), punch, 40, 0)
	flick(src.icon_punched,src)



/obj/structure/punchingbag/wizard //Âèçàðäîâñêàÿ
	anchored = 1
	density = 1
	name = "Punching Bag"
	desc = "You can punch it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "punchingbagwizard"
	icon_punched = "punchingbagwizard2"

/obj/structure/punchingbag/wizard/attack_hand(mob/user as mob)
	var/list/punchSound = list('sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')
	var/punch = pick(punchSound)
	playsound(get_turf(src), punch, 40, 0)
	flick(src.icon_punched,src)



/obj/structure/punchingbag/captain //Êàïèòîí
	anchored = 1
	density = 1
	name = "Punching Bag"
	desc = "You can punch it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "punchingbagcaptain"
	icon_punched = "punchingbagcaptain2"

/obj/structure/punchingbag/captain/attack_hand(mob/user as mob)
	var/list/punchSound = list('sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')
	var/punch = pick(punchSound)
	playsound(get_turf(src), punch, 40, 0)
	flick(src.icon_punched,src)
