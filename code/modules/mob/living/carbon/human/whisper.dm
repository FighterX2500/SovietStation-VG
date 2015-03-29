// NOTE THAT HEARD AND UNHEARD USE GENDER_REPLACE SYNTAX SINCE BYOND IS STUPID
/mob/living/carbon/human/whisper(var/message as text, datum/language/lang)
	if(!IsVocal())
		return

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	message = trim(copytext(strip_html_simple(message), 1, MAX_MESSAGE_LEN))
	message = sanitize(message)
	if(!can_speak(message))
		return

	message = "<i>[message]</i>"
	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			src << "<span class='danger'>You cannot whisper (muted).</span>"
			return

	log_whisper("[src.name]/[src.key] : [message]")

	var/alt_name = get_alt_name()

	var/whispers = "whispers"
	var/critical = InCritical()

	// We are unconscious but not in critical, so don't allow them to whisper.
	if(stat == UNCONSCIOUS && (!critical || said_last_words))
		return

	// If whispering your last words, limit the whisper based on how close you are to death.
	if(critical && !said_last_words)
		var/health_diff = round(-config.health_threshold_dead + health)
		// If we cut our message short, abruptly end it with a-..
		var/message_len = length(message)
		message = copytext(message, 1, health_diff) + "[message_len > health_diff ? "-.." : "..."]"
		message = Ellipsis(message, 10, 1)
		whispers = "whispers in their final breath"
		said_last_words = src.stat

	message = treat_message(message)

	var/list/listening_dead = list()
	for(var/mob/M in player_list)
		if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTEARS) && client)
			listening_dead |= M

	var/list/listening = get_hearers_in_view(1, src)
	listening |= listening_dead
	var/list/eavesdropping = get_hearers_in_view(2, src)
	eavesdropping -= listening
	var/list/watching  = hearers(5, src)
	watching  -= listening
	watching  -= eavesdropping

	var/rendered

	rendered = "<span class='game say'><span class='name'>[src.name]</span> <span class='[lang.colour]'>[whispers] something.</span></span>"
	for(var/mob/M in watching)
		M.show_message(rendered, 2)

	for(var/mob/M in listening)
		rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] [whispers], [M.lang_treat(src,lang,message,0)]</span>"
		M.Hear(rendered, src, languages, message, 0)
	for(var/mob/M in eavesdropping)
		message = stars(message)
		rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] [whispers], [M.lang_treat(src,lang,message,0)]</span>"
		M.Hear(rendered, src, languages, message, 0)

	if(said_last_words) //Dying words.
		succumb(1)