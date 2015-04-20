//bitflag #defines for radio returns.
#define ITALICS 1
#define REDUCE_RANGE 2
#define NOPASS 4

//message modes. you're not supposed to mess with these.

#define SAY_MINIMUM_PRESSURE 10
var/list/department_radio_keys = list(
	  "r" = "right ear",
	  "l" = "left ear",
	  "i" = "intercom",
	  "h" = "department",
	  "c" = "Command",
	  "n" = "Science",
	  "m" = "Medical",
	  "e" = "Engineering",
	  "s" = "Security",
	  "w" = "whisper",
	  "t" = "Syndicate",
	  "u" = "Supply",
	  "d" = "Service",
	  "R" = "right ear",
	  "L" = "left ear",
	  "I" = "intercom",
	  "H" = "department",
	  "C" = "Command",
	  "N" = "Science",
	  "M" = "Medical",
	  "E" = "Engineering",
	  "S" = "Security",
	  "W" = "whisper",
	  "T" = "Syndicate",
	  "U" = "Supply",
	  "D" = "Service",
	  "к" = "right ear",
	  "д" = "left ear",
	  "ш" = "intercom",
	  "р" = "department",
	  "с" = "Command",
	  "т" = "Science",
	  "ь" = "Medical",
	  "у" = "Engineering",
	  "ы" = "Security",
	  "ц" = "whisper",
	  "е" = "Syndicate",
	  "й" = "Supply",
	  "в" = "Service",


	  "\[" = "Right hand",
	  "]" = "Left hand",
)
var/list/special_chat_symbols = list(":" = 1,"#" = 1,"." = 1)
/mob/living/proc/binarycheck()
	return 0


// /vg/edit: Added forced_by for handling braindamage messages and meme stuff
/mob/living/say(var/message, bubble_type)
	var/datum/language/speak_lang = current_language_speak //Говорим на выбранном языке
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	message = capitalize(message)

	if(!message) return

	if(silent)
		src << "\red You can't speak while silenced."
		return

	if (stat == DEAD) // Dead.
		say_dead(message)
		return
	if (stat) // Unconcious.
		return
	if(check_emote(message))
		return
	if(!can_speak_basic(message))
		return
	//Проверяем способ разговора (Говорим ли мы в наушник)
	var/message_mode = get_message_mode(message)
	if(message_mode == "headset")
		message = copytext(message, 2)
	else if(message_mode && message_mode != "holopad")
		message = copytext(message, 3)
	if(findtext(message, " ",1, 2))
		message = copytext(message, 2)
	//Проверяем, пытается ли моб сказать что-нибудь на недефолтном языке. (Проверяем только из тех, на которых он умеет говорить)
	if(copytext(message, 1, 2) in special_chat_symbols)
		if(universal_speak)
			var/key = copytext(message, 2, 3)
			for(var/lang_name in all_languages)
				var/datum/language/lang = all_languages[lang_name]
				if(lang.key == key)
					speak_lang = lang
					break
			message = copytext(message, 3)
		else
			var/key = copytext(message, 2, 3)
			for(var/datum/language/lang in languages)
				if(lang.key == key)
					speak_lang = lang
					break
			message = copytext(message, 3)
	if(!speak_lang)
		src << "<span class = 'warning'>You can't speak! Teach language!</span>" // Не умеешь говорить
		return
	if(speak_lang.flags & HIVEMIND)
		speak_lang.broadcast(src,message,0)
		return
	if(isMoMMI(src))
		src:mommi_talk(message)
		return
	if(!can_speak_vocal(message))
		return
	message = treat_message(message)

	var/message_range = 7
	var/radio_return = radio(message, message_mode, speak_lang)
	if(radio_return & NOPASS) //There's a whisper() message_mode, no need to continue the proc if that is called
		return
	if(radio_return & ITALICS)
		message = "<i>[message]</i>"
	if(radio_return & REDUCE_RANGE)
		message_range = 1

	send_speech(message, message_range, src, bubble_type, speak_lang)

	log_say("[name]/[key] : [message]")

	return 1


/mob/living/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, need_to_render = 1)
	if(!client)
		return
	var/deaf_message
	var/deaf_type
	if(speaker != src)
		if(!radio_freq) //These checks have to be seperate, else people talking on the radio will make "You can't hear yourself!" appear when hearing people over the radio while deaf.
			deaf_message = "<span class='name'>[speaker]</span> talks but you cannot hear them."
			deaf_type = 1
	else
		deaf_message = "<span class='notice'>You can't hear yourself!</span>"
		deaf_type = 2 // Since you should be able to hear yourself without looking
	if(need_to_render)
		message = compose_message(speaker, message_langs, raw_message, radio_freq)
	show_message(message, 2, deaf_message, deaf_type)
	return message

/mob/living/send_speech(message, message_range = 7, obj/source = src, bubble_type, language = current_language_speak)
	var/list/listening = get_hearers_in_view(message_range, source)
	var/list/listening_dead = list()
	for(var/mob/M in player_list)
		if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTEARS) && client) // client is so that ghosts don't have to listen to mice
			listening_dead |= M

	listening -= listening_dead //so ghosts dont hear stuff twice

	var/rendered = compose_message(src, language, message)
	for(var/atom/movable/AM in listening)
		AM.Hear(rendered, src, language, message)

	for(var/mob/M in listening_dead)
		M.Hear(rendered, src, language, message)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in (listening + listening_dead))
		if(M.client)
			speech_bubble_recipients.Add(M.client)
	spawn(0)
		flick_overlay(image('icons/mob/talk.dmi', src, "h[bubble_type][say_test(message)]",MOB_LAYER+1), speech_bubble_recipients, 30)

/mob/living/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

/mob/living/can_speak(message) //For use outside of Say()
	if(can_speak_basic(message) && can_speak_vocal(message))
		return 1

/mob/living/proc/can_speak_basic(message) //Check BEFORE handling of xeno and ling channels
	if(!message || message == "")
		return

	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "<span class='danger'>You cannot speak in IC (muted).</span>"
			return
		if(client.handle_spam_prevention(message,MUTE_IC))
			return

	return 1


/mob/living/proc/can_speak_vocal(message) //Check AFTER handling of xeno and ling channels
	if(!message)
		return

	if(sdisabilities & MUTE)
		return

	if(is_muzzled())
		return

	if(!IsVocal())
		return

	return 1
/mob/living/proc/handle_inherent_channels(message, message_mode)
	return 0
/mob/living/proc/check_emote(message)
	if(copytext(message, 1, 2) == "*")
		emote(copytext(message, 2))
		return 1


/mob/living/proc/get_message_mode(message)
	// ";" в любом случае означает разговор в основной радиоканал
	if(copytext(message, 1, 2) == ";")
		return "headset"
	//Узнаем в какой канал базарим.
	//Если сначала проверять на наличие нужного символа, то выходит быстрее. Серъезно.
	else if((copytext(message, 1, 2) in special_chat_symbols) && (copytext(message, 2, 3) in department_radio_keys))
		return department_radio_keys[copytext(message, 2, 3)]

/mob/living/proc/treat_message(message)
	if(getBrainLoss() >= 60)
		message = derpspeech(message, stuttering)

	if(stuttering)
		message = stutter(message)

	return message

/mob/living/proc/radio(message, message_mode, datum/language/lang = current_language_speak)
	switch(message_mode)
		if("Right hand")
			if (r_hand)
				r_hand.talk_into(src, message, lang)
			return ITALICS | REDUCE_RANGE
		if("Right hand")
			if (l_hand)
				l_hand.talk_into(src, message, lang)
			return ITALICS | REDUCE_RANGE
		if("intercom")
			for (var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, message, lang)
			return ITALICS | REDUCE_RANGE
		if("whisper")
			src.whisper(message, lang)//Не должен шепот обрабатываться здесь. Но что поделать?
			return NOPASS
	return 0
/mob/living/lingcheck()
	if(mind && mind.changeling && !issilicon(src))
		return 1

/mob/living/say_quote()
	if (stuttering)
		return "stammers, \"[text]\""
	if (getBrainLoss() >= 60)
		return "gibbers, \"[text]\""
	return ..()

/mob/proc/addSpeechBubble(image/speech_bubble)
	if(client)
		client.images += speech_bubble
		spawn(30)
			if(client) client.images -= speech_bubble

/obj/effect/speech_bubble
	var/mob/parent