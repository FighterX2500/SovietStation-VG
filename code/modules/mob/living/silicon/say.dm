/mob/living/silicon/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "queries, \"[text]\"";
	else if (ending == "!")
		return "declares, \"[text]\"";

	return "states, \"[text]\"";

/mob/living/silicon/say(var/message)
	return ..(message, "R")

/mob/living/silicon/robot/IsVocal()
		return !config.silent_borg

/mob/living/silicon/radio(message, message_mode, datum/language/lang)
	. = ..()
	if(. != 0)
		return .
	else if(message_mode == "headset")
		if(radio)
			radio.talk_into(src, message, null, lang)
	else if(message_mode in radiochannels)
		if(radio)
			radio.talk_into(src, message, message_mode, lang)
			return ITALICS | REDUCE_RANGE
	return 0
