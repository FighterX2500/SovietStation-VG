/obj/structure/stool/bed/chair/fitness
	anchored = 1

/obj/structure/stool/bed/chair/fitness/weight_machine
	name = "weight machine"
	desc = "Used to keep your form."
	icon_state = "fitnesslifter"

/obj/structure/stool/bed/chair/fitness/weight_machine/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/chair/fitness/weight_machine/MouseDrop_T(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!istype(M)) return
//	var/mob/living/carbon/human/target = null
//	if(ishuman(M))
//		target = M
	if(M.handcuffed)
		user << "You can't buckle yourself."

	else
		buckle_mob(M, user)
		icon_state = "fitnesslifter1"
		M.dir = SOUTH

	return

/obj/structure/stool/bed/chair/fitness/weight_machine/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
			icon_state = "fitnesslifter"
	return

/obj/structure/stool/bed/chair/fitness/weight_machine/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] was unbuckled by [user.name]!",\
					"You were unbuckled from [src] by [user.name].",\
					"You hear metal clanking")
			else
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] unbuckled \himself!",\
					"You unbuckle yourself from [src].",\
					"You hear metal clanking")
			unbuckle()
			src.add_fingerprint(user)
			icon_state = "fitnesslifter"
	return

/obj/structure/stool/bed/chair/fitness/weight_machine
	name = "weight machine"
	desc = "Used to keep your form."
	icon_state = "fitnessweight"

/obj/structure/stool/bed/chair/fitness/weight_machine/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/chair/fitness/weight_machine/MouseDrop_T(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!istype(M)) return
//	var/mob/living/carbon/human/target = null
//	if(ishuman(M))
//		target = M
	if(M.handcuffed)
		user << "You can't buckle yourself."

	else
		buckle_mob(M, user)
		icon_state = "fitnessweight-c"
		overlays += "fitnessweight-w"
		M.dir = SOUTH

	return

/obj/structure/stool/bed/chair/fitness/weight_machine/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
			icon_state = "fitnessweight"
			overlays -= "fitnessweight-w"
	return

/obj/structure/stool/bed/chair/fitness/weight_machine/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] was unbuckled by [user.name]!",\
					"You were unbuckled from [src] by [user.name].",\
					"You hear metal clanking")
			else
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] unbuckled \himself!",\
					"You unbuckle yourself from [src].",\
					"You hear metal clanking")
			unbuckle()
			src.add_fingerprint(user)
			icon_state = "fitnessweight"
			overlays -= "fitnessweight-w"
	return