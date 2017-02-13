/mob/living/carbon/alien/say(var/message)
	. = ..(message, "A")
	if(.)
		playsound(loc, "hiss", 25, 1, 1)