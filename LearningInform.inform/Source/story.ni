"LearningInform" by MoyTW

[ https://en.wikibooks.org/wiki/Beginner%27s_Guide_to_Interactive_Fiction_with_Inform_7/Getting_Started_with_Inform_7 ]

When play begins:
say "[italic type]You are once again lost in a jungle far from home. You are ready to give up and go home, disappointed in yet another failed archaeological expedition. Just as you decide to turn back to camp, you suddenly stumble upon something...[roman type]".

The Forest is a room. "You stand in a clearing in the deep jungle. Obscured by centuries of overgrowth and dim sunlight is a ruined temple of some sort. Whatever details there may have been on the stone blocks have long since been worn away.
[if we have examined the temple]There is a single, solitary entryway leading downward.
[end if]"

[ A mushroom is here. It is edible. "Hmm. A mushroom. Curious." The description is "It's really boring, actually." ]

[ Here be a comment. ]
[ So, apparently, examine/look are synonyms? ]

After taking the mushroom:
  say "Text for taking the mushroom goes here"

After dropping the mushroom:
  say "It's on the ground now, RIP"

[ Note that "get" and "take" are synonyms, apparently. Also, taking plays on every take not the first one (as one might expect) - I wonder how to play it on only the first take? ]

After eating the mushroom:
	say "Don't eat strange mushrooms! You are poisoned, to death.";
	end the story saying "RIP You"

[ Inform say you have to have taken something to eat it, and that's a hard rule (unless I guess you override it?). Also - semicolons after multiple commands in an "After" clause. Is there a "before" clause? ]

Before eating the mushroom:
	say "That was a bad decision!"

[ There is! Cool. Oh, the next section of the tutorial covers IF statements. ]

A mushroom is here. It is edible. "Hmm. A mushroom. Curious." The description is "[if we have not examined the mushroom]Hey this is poisonous.[otherwise]Don't eat it![end if][if we have taken the mushroom]You should probably drop it[end if]" 

[ Hmm. As written if you x it twice it's "Don't eat it!You should probably drop it" - well for one, I need a period, but secondly, I need to figure out how to put a space in front of the second clause. ]

[ Ugh that if statement is gonna be a friggin' nightmare to read, can we... ]

A phone is here. The description is
"[if we have not examined the phone]Huh who left this phone here?
  [otherwise]It's a phone. Boring.
[end if]
[if we have not taken the phone]You should pick this up!
  [otherwise]You're not even sure why you picked this up.
[end if]
"

[ I'm not...super pleased about the way that the 'if' statement gets formatted, I'd prefer doing the traditional format of dropping the logic line off the condition line but when I tried that, it didn't reduce the whitespace and so the description looked really wonky. Maybe I should read some other games' source code.

Note that apparently a line break 'counts' as two spaces (?) in the output - if you open the quotation mark on "The description is" line you end up with whitespace in front of "Hey".

I mean, yes, I definitely should do that. ]

Understand "poisonous mushroom" as the mushroom;

After examining the mushroom for the second time:
	now the printed name of the mushroom is "poisonous mushroom".

The temple is here. It is scenery. The description is "It's a temple and there's stairs."

[ The scenery makes it so that it's not listed as an object in the text. I think a bunch of games I've played just flat-out didn't like listing things as objects? It makes it very dissonant - unless it's something you've taken and dropped. Which I guess is good, because that means Inform handles it for you, hmm? ]

The Dark Passage is a room. It is down from the forest. "It's a passage. EXITS does not work, because it hasn't been implemented, but you can leave to the north."

[ Exits are by default symmetric. Also note that the Dark Passage isn't locked from the initial area - you can go to it without examining the temple. ]

The Last Room is a room. It is north from the Dark Passage. "A nice room, huh?"

Treasure is a kind of thing. It has a number called worth. The worth of a treasure is usually 9.

A ceremonial krater is in the Dark Passage. It is treasure with worth 500. "A ceremonial krater is held in a niche on the east side of the passage." The description is "It's a krater, and it's ceremonial."

[ We definitely would want to keep away from "is in <room name> and keep towards "is in here" - otherwise your rooms will fragment across your source code! ]

Posting is an action applying to one thing. Understand "post [something]" as posting.

Dunking is an action applying to one thing. Understand "dunk [something]" as dunking.

use scoring;

[ Before posting the temple:
	  say "*click*[line break]Oh, that's how line breaks work!";
	  increase the score by 5. ]

[ Hmm. You'd have to enumerate everything? Oh, that's literally what the next part of the tutorial's on. ]

Things have a number called likes. The likes of a thing is usually 0. The temple has likes 5.

Check posting:
	  if the likes of the noun is 0, say "You won't go viral with that!" instead;
	  if the likes of the noun is -1, say "You already posted that." instead.

Carry out posting:
	say "You post a shot of the [printed name].";
	increase the score by the likes of the noun;
	now the likes of the noun is -1.

[ So the 'check' rule is a pre-action if, with 'instead' indicating a replacement of the normal logic; the carry out is called if all checks pass and it isn't insteaded. ]

[ Ok, sweet, that's enough to start randomly flailing, I think. ]