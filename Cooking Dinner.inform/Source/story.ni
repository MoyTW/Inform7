"This Kitchen Is Too Cluttered" by MoyTW

[ Includes ]

Volume - Setup

Book - Value Definitions

Part - Units

A volume is a kind of value. 1.0 tsp (in US units, in tsp) or 1 teaspoon (in tsp, singular) or 2 teaspoons (in tsp, plural) specifies a volume.

The max volume is a volume that varies. The max volume is 2147483647 tsp.

1 tbsp (in US units, in tbsp) or 1 tablespoon (in tbsp, singular) or 2 tablespoons (in tbsp, plural) specifies a volume scaled up by 3.

1 fl oz (in US units, in fl oz) or 1 fluid ounce (in fl oz, singular) or 2 fluid ounces (in fl oz, plural) specifies a volume scaled up by 6.

1 cup (in cups, singular) or 1 c (in US units, in cups) or 2 cups (in cups, plural) specifies a volume scaled up by 48.

1 qt (in US units, in quarts) 1 quart (in quarts, singular) or 2 quarts (in quarts, plural) specifies a volume scaled up by 192.

1 gal (in US units, in gallons) or 1 gallon (in gallons, singular) or 2 gallons (in gallons, plural) specifies a volume scaled up by 768.

A temperature is a kind of value. 1 degree farenheit (singular) or 2 degrees farenheit (plural) or 1 F specifies a temperature.

The room temperature is always 70 F.

Part - Ingredients

An IngredientInfo is a kind of value. The IngredientInfo are defined by the Table of Ingredient Info.

Table of Ingredient Info
ingredient_id	ingredient_name
id_uninitualized	"UNINITUALIZED INGREDIENT"
id_flour	"flour"
id_salt	"salt"
id_water	"water"
id_sugar	"sugar"
id_ady	"active dry yeast"
id_bread_dough	"bread dough"
id_risen_dough	"risen dough"
id_unrisen_dough	"unrisen dough"
id_shaggy_dough	"shaggy dough"
id_dry_ingredients	"dry ingredients"
id_wet_ingredients	"wet ingredients"
id_loaf_of_bread	"loaf of bread" [ Isn't REALLY an ingredient but ok ]

An IngredientTag is a kind of value. The IngredientTag are defined by the Table of Ingredient Tags.

Table of Ingredient Tags
ingredient_tag
TAG_BEATEN
TAG_COMBINE
TAG_HAND_KNEADED

An _Ingredient is a kind of thing.
An _Ingredient has an IngredientInfo called ingredient_info. The ingredient_info of an _Ingredient is usually id_uninitualized.
An _Ingredient has a text called info_name.
An _Ingredient has a volume called current_volume. The current_volume of an _Ingredient is usually 1.0 tsp.
An _Ingredient has a list of IngredientTags called ingredient_tags.
An _Ingredient has a time called created_at.

To init_ingredient (ingredient - an _Ingredient) with (info - an IngredientInfo) and (volume - a volume):
	choose the row with ingredient_id of info in the Table of Ingredient Info;
	now the ingredient_info of the ingredient is the info;
	now the info_name of the ingredient is the ingredient_name entry;
	now the current_volume of the ingredient is the volume;
	now the created_at of the ingredient is the time of day;

Rule for printing the name of an _Ingredient:
	say "[the info_name] ([current_volume])";

[
TODO: This fails to comprehend that identically-named objects should be treated as distinct. For example, if you have pour water into a small bowl then pour water into a big bowl, and then `x water`, it will arbitrarily select one (it might be ordered, but that's not really helpful) whereas I'd like it to ask the player to disambiguate. This is kind of an issue with the fact that the objects don't have unique names, but the issue with unique names are that they're extremely unwieldy, and - argh, yeah, it's like, you have four different 'sugar' objects and you don't want to have to write "fill the 4-cup with the sugar in the 1-tsp spoon" because that's awful but there's no way around it at this level of granularity is there...
Yeah. I don't think you can get around that level of granularity if you're dealing with <ingredient in container>, that's just part of The Deal of going down to that water. You certainly can't get around it with water for your sauce versus water for steaming, for example.
I think I *could* end up hacking something together - I can very easily change `info_name` to be <name + container name> but then the mere act of "get 1 tsp of sugar into this water" is awful, because you by necessity have to full-name the container! It also means you can't easily do single-word Understand commands because you'd run right into that same issue...
]
[ TODO: This doesn't work properly with multi-word names - see https://intfiction.org/t/inform-7-changing-the-name-of-an-object/2507 for a possible, if awfully hacky, example. ]
Understand the info_name property as describing an _Ingredient;

Check taking an _Ingredient: [ TODO: Add column for "solid" or "carryable" to ingredients ]
	say "Carrying [the info_name] in your hands would be at best messy. Try pouring [the holder of the noun] into a container, or filling a container from the [the holder of the noun].";
	stop the action.

Chapter - Ingredients Setup

100 _Ingredients are in ingredient_storage.

When play begins:
	repeat with i running through _Ingredients not in ingredient_storage:
		init_ingredient i with ingredient_info of i and current_volume of i;

Part - Recipes

A RequiredTransformation is a kind of value. The RequiredTransformation are defined by the Table of Required Transformations.

Table of Required Transformations
name	duration_min	duration_max	temperature
REQ_BAKE_450F_20-25	20	25	450
REQ_RISE_90	80	100	--
REQ_KNEAD_8	6	10	--
REQ_COMBINE	--	--	--
REQ_BEAT	--	--	--

A recipe is a kind of value. The recipes are defined by the Table of Recipes.

Table of Recipes
name	product	required_ingredient_ids	ratios	required_transformations
r_lob	id_loaf_of_bread	{ id_bread_dough }	{ 1 }	{ REQ_BAKE_450F_20-25 }
r_rd	id_risen_dough	{ id_unrisen_dough }	{ 1 }	{ REQ_RISE_90 }
r_urd	id_unrisen_dough	{ id_shaggy_dough }	{ 1 }	{ REQ_KNEAD_8 }
r_sd	id_shaggy_dough	{ id_dry_ingredients, id_wet_ingredients }	{ 253, 98 }	{ REQ_COMBINE }
r_di	id_dry_ingredients	{ id_flour, id_salt }	{ 252, 1 }	--
r_wi	id_wet_ingredients	{ id_water, id_sugar, id_ady }	{ 96, 1, 1 }	{ REQ_BEAT }

Part - IngredientContainer

An IngredientContainer is a kind of container.

An IngredientContainer is either graduated or ungraduated. An IngredientContainer is usually ungraduated.
An IngredientContainer has a volume called capacity. The capacity of an IngredientContainer is usually 4 cups.
An IngredientContainer can be a ingredient_source. An IngredientContainer is usually not an ingredient_source.

Check inserting something into an IngredientContainer (this is the can't put objects an ingredient container rule):
	say "The [second noun] [hold] only ingredients." instead.

[ TODO: Modify descriptions to fit & graduated/ungraduated ]
Rule after printing the name of an IngredientContainer (called container) when printing the locale description:
	let n be the number of things held by the container;
	if n > 1:
		say " (containing a mixture of [list of things held by the container])";
	else if n is 1:
		say " (containing some [list of things held by the container])";
	omit contents in listing;

Instead of examining an IngredientContainer (called container):
	say "[The noun] ";
	let n be the number of things held by the container;
	if n is 0:
		say "is empty.";
	else if n is 1:
		say "contains some [list of things held by the container].";
	else:
		say "contains a mixture of [list of things held by the container] .";

Book 2 - Verb Definitions

Part - Proceess Function

To decide what IngredientInfo is the id of (ing - an _Ingredient) (this is getting the id of):
	decide on the ingredient_info of ing;

To decide what text is the name of (ing - an _Ingredient) (this is getting the name of):
	decide on the info_name of ing;

To transform the ingredients of (container - an IngredientContainer) into (new_info - an IngredientInfo):
	let src_ingredients be the list of things held by the container;
	let result be a random off-stage _Ingredient;
	[ Build the new ingredient ]
	let new_volume be 0 tsp;
	repeat with i running through src_ingredients:
		increase new_volume by the current_volume of i;
	init_ingredient result with new_info and new_volume;
	[ Physically swap them ]
	repeat with i running through the src_ingredients:
		now i is in the ingredient_storage;
	now result is in the container;

To decide whether (requirement - a RequiredTransformation) with (container - an IngredientContainer) is failed:
	let success be true;
	if the requirement is REQ_BEAT:
		repeat with i running through the list of things held by the container:
			if TAG_BEATEN is not listed in the ingredient_tags of i:
				now success is false;
		[ There's GOT to be a way to reverse truth value, what the hell. http://inform7.com/book/WI_11_5.html doesn't explain and 'not' doesn't work. ]
	else if the requirement is REQ_COMBINE:
		repeat with i running through the list of things held by the container:
			if TAG_COMBINE is not listed in the ingredient_tags of i:
				now success is false;
	else if the requirement is REQ_KNEAD_8:
		repeat with i running through the list of things held by the container:
			let times_hand_kneaded be 0;
			repeat with t running through the ingredient_tags of i:
				if t is TAG_HAND_KNEADED:
					increase times_hand_kneaded by 1;
			if times_hand_kneaded is less than 5:
				now success is false;
	else if the requirement is REQ_RISE_90:
		repeat with i running through the list of things held by the container:
			let done_time be created_at of i + 80 minutes;
			if done_time is greater than time of day:
				now success is false;
	else:
		now success is false;
	if success is true:
		decide on false;
	else:
		decide on true;

To attempt to process (container - an IngredientContainer) by recipe:
	let candidate_ids be getting the id of applied to the list of things held by the container;
	sort candidate_ids;
	if there is a product corresponding to required_ingredient_ids of candidate_ids in the Table of Recipes:
		choose the row with the required_ingredient_ids of candidate_ids in the Table of Recipes;
		let candidate_names be getting the name of applied to the list of things held by the container;
		if the required_transformations entry is empty:
			transform the ingredients of the container into the product entry;
			[ say "You combined the [candidate_names] to create [the list of things in the container]."; ]
		else:
			let success be true;
			repeat with r running through required_transformations entry:
				if r with container is failed:
					now success is false;
					[ say "Failed to fulfill [r]."; ]
			if success is true:
				transform the ingredients of the container into the product entry;
				[ say "You combined the [candidate_names] to create [the list of things in the container]."; ]
			[ else:
				say "Transformation failed."; ]
	[ else:
		say "No such combination found for [candidate_ids]."; ]

An every turn rule (this is the transform ingredients in world every turn rule):
	repeat with c running through the IngredientContainers:
		if c contains something:
			attempt to process c by recipe;

Part - Stir/Mix/Combine Verb

To combine is a verb.

Understand "combine [_Ingredient] with/and [_Ingredient]" as combining it with.
Understand "mix [_Ingredient] with/and [_Ingredient]" as combining it with.
Understand "stir [_Ingredient] with/and [_Ingredient]" as combining it with.

Combining it with is an action applying to two things. 

Check combining _Ingredient (called left) with _Ingredient (called right) (this is the ingredients must be in same container rule):
	if the holder of left is not the holder of right:
		say "The two ingredients have to be in the same container!";
		stop the action.

Carry out combining it with (this is the standard combining it with rule):
	try combining ingredients in the container the holder of the noun;

Understand "combine ingredients in [something]" as combining ingredients in the container.
Understand "mix ingredients in [something]" as combining ingredients in the container.
Understand "stir ingredients in [something]" as combining ingredients in the container.

Combining ingredients in the container is an action applying to one thing.

Check combining ingredients in the container (this is the can only combine in IngredientContainer rule):
	if the noun is not an IngredientContainer:
		say "[the noun] isn't appropriate for combining ingredients in!";
		stop the action.

Check combining ingredients in the container (this is the can only combine if ingredients present rule):
	if the list of things held by the noun is empty:
		say "There are no ingredients in [the noun].";
		stop the action.

[ TODO: Add failure case! ]
Carry out combining ingredients in the container (this is the standard combining ingredients in it rule):
	say "You combine [the list of _Ingredients held by the noun] in [the noun].";
	repeat with adjacent running through the _Ingredients held by the noun:
		add TAG_COMBINE to the ingredient_tags of adjacent;

Part - Fill Verb

To fill is a verb.

Understand "fill [something] with/from [something]" as filling it with.

Filling it with is an action applying to two things.

Carry out an actor filling something with something (this is the convert filling to pouring rule):
	if the second noun is an _Ingredient:
		try the actor pouring the holder of the second noun into the noun instead;
	else:
		try the actor pouring the second noun into the noun instead.

Rule for supplying a missing second noun while an actor filling (this is the query player for source rule):
	say "You'll need to specify what to fill [the noun] with."

Part - Pour Verb

To pour is a verb.

Understand "pour [something] in/into [something]" as pouring it into.
Understand "empty [something] in/into [something]" as pouring it into.

[ TODO: Discourage the player pouring something into an ingredient source container ]

Pouring it into is an action applying to two things.
The pouring it into action has a list of _Ingredients called the ingredients_poured.
The pouring it into action has a list of volumes called the amounts_poured.

Setting action variables for pouring something into something (this is the setting ingredients poured rule):
	if the noun is an IngredientContainer:
		now the ingredients_poured is the list of _Ingredients held by the noun.

Setting action variables for pouring something (called the source) into something (called the target) (this is the setting amounts poured rule):
	if the source is an IngredientContainer and the target is an IngredientContainer:
		[ target capacity ]
		let target_remaining_capacity be capacity of target;
		repeat with held running through the list of _Ingredients held by the target:
			decrease target_remaining_capacity by the current_volume of held;
		[ source total ]
		let source_total_amount be 0 tsp;
		repeat with poured running through the list of _Ingredients held by the source:
			increase source_total_amount by current_volume of poured;
		[ amount poured ]
		if target_remaining_capacity is greater than the source_total_amount:
			repeat with poured running through the list of _Ingredients held by the source:
				add current_volume of poured to amounts_poured;
		otherwise:
			let scalar be target_remaining_capacity / source_total_amount;
			repeat with poured running through the list of _Ingredients held by the source:
				add scalar * the current_volume of poured to amounts_poured;

[ TODO: can't pour two untouched things rule ]

Check an actor pouring something into something (this is the can't pour out of a non-IngredientContainer rule):
	if the noun is not an IngredientContainer:
		say "You can't pour out of that.";
		stop the action.

Check an actor pouring something into something (this is the can't pour into a non-IngredientContainer rule):
	if the second noun is not an IngredientContainer:
		say "That's not an appropriate container for cooking with!";
		stop the action.

Check an actor pouring something into something (this is the can't pour something into itself rule):
	if the noun is the second noun:
		say "No point pouring something into itself.";
		stop the action.

Check an actor pouring something into something (this is the can't pour out of empty containers rule):
	let total_taken_capacity be 0 tsp;
	repeat with held running through the list of _Ingredients held by the noun:
		increase total_taken_capacity by current_volume of held;
	if total_taken_capacity is 0 tsp:
		say "[The noun] [are] empty.";
		stop the action.

Check an actor pouring something into something (this is the can't pour into a full container rule):
	let total_taken_capacity be 0 tsp;
	repeat with poured running through the list of _Ingredients held by the second noun:
		increase total_taken_capacity by current_volume of poured;
	if total_taken_capacity is the capacity of the second noun:
		say "[The second noun] [are] full!";
		stop the action.

Check an actor pouring something into something (this is the ingredient pool not exhausted rule):
	let new_ingredient be a random off-stage _Ingredient;
	if new_ingredient is nothing:
		say "Failed to pour - no remaining ingredients in ingredient pool.";
		stop the action.

test pouring with "pour shaker into pitcher / x shaker / x pitcher";

[test pouring_checks with "pour salt into stand mixer / pour stand mixer into salt / pour salt into salt / x salt / pour salt into 4-cup / x salt / pour salt into 1-cup / x 1-cup"]

Carry out an actor pouring something (called source) into something (called target) (this is the standard carry out pouring rule):
	let src_idx be 1;
	repeat with poured_ingredient running through ingredients_poured:
		let poured_volume be the entry src_idx of the amounts_poured;
		[ Remove the appropriate volume from source container ]
		decrease current_volume of poured_ingredient by poured_volume;
		if current_volume of poured_ingredient is 0 tsp:
			now poured_ingredient is in the ingredient_storage;
		[ Add the appropriate volume to the target container ]
		let matching_ingredient be poured_ingredient;
		repeat with candidate running through the list of _Ingredients held by the target:
			if ingredient_info of poured_ingredient is ingredient_info of candidate:
				now matching_ingredient is candidate;
				break;
		if matching_ingredient is not poured_ingredient:
			increase current_volume of matching_ingredient by poured_volume;
		else:
			let new_ingredient be a random off-stage _Ingredient;
			now new_ingredient is in the target;
			init_ingredient new_ingredient with ingredient_info of the poured_ingredient and poured_volume;
		[ Increment loop ]
		increment src_idx;

Report an actor pouring something (called source) into something (called target) (this is the standard report someone pouring rule):
	if the capacity of the source is greater than the capacity of the target:
		say "[The actor] [fill] [the target] from [the source].";
	else:
		say "[The actor] [pour] [the source] into [the target].";

Part - Beat verb

To beat is a verb.

Understand "beat [_Ingredient]" as beating it with.
Understand "beat [_Ingredient] with [something]" as beating it with.
Beating it with is an action applying to two things.

Rule for supplying a missing second noun while beating:
	say "You have to specify an implement to beat [the noun] with.";

Carry out beating something (called ingredient) with something (called the beater):
	let container be the holder of the ingredient;
	if the container is an IngredientContainer:
		say "You beat [the list of _Ingredients held by the container] in [the container] with [the beater].";
		repeat with adjacent running through the _Ingredients held by container:
			add TAG_BEATEN to the ingredient_tags of adjacent;
	else:
		say "You beat [the ingredient] with [the beater]."; 
		add TAG_BEATEN to the ingredient_tags of the ingredient;

Test beat with "beat water with bottle"; 
[Test beat with "fill 4-cup from sink / beat asdf / beat water / beat water with mixing spoon / beat 4-cup with mixing spoon / fill 1-cup from sink / beat water"]

Part - Knead verb

To knead is a verb.

Understand "knead [something]" as kneading an ingredient.
Kneading an ingredient is an action applying to one thing.

Check kneading an ingredient (this is the can only knead ingredients rule):
	if the noun is not an _Ingredient:
		say "You can't knead that!";
		stop the action.

[ TODO: Restrict kneading to sane ingredients. ]
[ TODO: Contemplate how to make this work with turning it out onto the countertop. ]
Carry out kneading an ingredient (this is the standard kneading rule):
	say "You knead [the noun].";
	add TAG_HAND_KNEADED to the ingredient_tags of the noun;

Part - Wait verb

Waiting for a time period is an action applying to one number.

Understand "wait [a time period]" or "wait for [a time period]" or "wait for a/an [a time period]" or "wait a/an [a time period]" as waiting for a time period.

Check waiting for a time period:
    if the time understood is greater than two hours, say "That's really quite a long time." instead. 

Carry out waiting for a time period:
	let the target time be the time of day plus the time understood;
	decrease the target time by one minute;
	while the time of day is not the target time:
		follow the turn sequence rules.

Report waiting for a time period:
    say "It is now [time of day + 1 minute]." 

Book 3 - Object Definitions

Part - StandMixer

[ Ok, so...if you just write "zero, stir, two..." it will interpret "two" not to mean the string two but the numerical value two, and then throw an error due to mixed string/number types. Hence setting_number. ]
StandMixerStatus is a kind of value. The StandMixerStatuses are speed 0, stir, speed 2, speed 4, speed 6, speed 8 and speed 10.

A StandMixer is a kind of container.
A StandMixer has a StandMixerStatus called status. The status of a StandMixer is usually speed 0.

A StandMixerBowl is a kind of IngredientContainer. The capacity of a StandMixerBowl is usually 6 quarts.

A MixerAttachment is a kind of thing.

[ Inserting/attaching ]

Check inserting something into a StandMixer:
	if the noun is not an StandMixerBowl and the noun is not an MixerAttachment:
		say "You can't put that into the stand mixer!" instead;
	otherwise if the noun is a MixerAttachment and the second noun contains a MixerAttachment:
		say "There's already an attachment!" instead;

Instead of putting an MixerAttachment on a StandMixer:
	try inserting the noun into the second noun.
Instead of tying an MixerAttachment to a StandMixer:
	try inserting the noun into the second noun.
Instead of putting a StandMixerBowl on a StandMixer:
	try inserting the noun into the second noun.
Instead of tying a StandMixerBowl to a StandMixer:
	try inserting the noun into the second noun.

[ Status ]

Understand "set [StandMixer] to [a number]" as setting it by number. Setting it by number is an action applying to one thing and one number.
Understand "set [StandMixer] to [StandMixerStatus]" as setting it by StandMixerStatus. Setting it by StandMixerStatus is an action applying to one thing and one StandMixerStatus.

Instead of setting a StandMixer to something:
	say "The settings on the stand mixer are 0, stir, 2, 4, 6, 8, and 10.";

Check setting StandMixer by number (this is the only valid number settings rule):
	let valid_mixer_numbers be {0, 2, 4, 6, 8, 10};
	if the number understood is not listed in valid_mixer_numbers:
		say "The settings on the stand mixer are 0, stir, 2, 4, 6, 8, and 10.";
		stop the action.

Carry out setting StandMixer by number:
	if the number understood is:
		-- 0: try setting the noun by StandMixerStatus speed 0;
		-- 2: try setting the noun by StandMixerStatus speed 2;
		-- 4: try setting the noun by StandMixerStatus speed 4;
		-- 6: try setting the noun by StandMixerStatus speed 6;
		-- 8: try setting the noun by StandMixerStatus speed 8;
		-- 10: try setting the noun by StandMixerStatus speed 10;

Check setting a StandMixer by StandMixerStatus (this is the never set to current status rule):
	if the StandMixerStatus understood is the status of the noun:
		say "The stand mixer is already set to [the StandMixerStatus understood].";
		stop the action.

Check setting a StandMixer by StandMixerStatus (this is the stop if no attachment present by status rule):
	if the noun does not contain a MixerAttachment:
		say "[The noun] has no attachment mounted. Turning it on would accomplish nothing.";
		stop the action.

Check setting a StandMixer by StandMixerStatus (this is the do not start stand mixer if no bowl present rule):
	if the noun does not contain a StandMixerBowl:
		say "[The noun] has no bowl mounted. Turning it on now would accomplish nothing.";
		stop the action.

Carry out setting StandMixer by StandMixerStatus:
	now the status of the noun is the StandMixerStatus understood;

Report setting a StandMixer by StandMixerStatus:
	say "You set [the noun] to [the status of the noun]."

Test stand with "set stand mixer to asdf / set stand mixer to 0 / set stand mixer to zero"

Part - Oven

[ Oven states:
	OFF
	SET TEMP <Bake/Broil> AT <Temperature>
	Temperature of [X] degrees, if temperature < X then PREHEATING
  Oven usage:
	set oven to bake <- requests that you specify a temperature
	set oven to bake at 400 degrees farenheit
	set oven to broil <- requests that you specify a temperature.
	set oven to 400 degrees farenheit <- asks if you you want to bake or broil
	x oven <- to see the current settings and temperature
	set timer to 15 minutes
	stop oven
	turn oven off / turn off oven
]
OvenStatus is a kind of value. The OvenStatuses are off, bake, and broil.

An AbstractOven is a kind of container. It is openable. It is usually closed.
An AbstractOven has a temperature called current_temperature. The current_temperature of an AbstractOven is usually 0 F.
An AbstractOven has a temperature called target_temperature. The target_temperature of an AbstractOven is usually 0 F.
An AbstractOven has an OvenStatus called target_status. The target_status of an AbstractOven is usually OFF.

Instead of setting an AbstractOven to something:
	say "You can set the oven to bake, broil, or off, or you can set it to a target_temperature, in degrees farenheit."

Understand "set [AbstractOven] to [OvenStatus]" as setting it by OvenStatus. Setting it by OvenStatus is an action applying to one thing and one OvenStatus.

Carry out setting an AbstractOven by OvenStatus:
	if the OvenStatus understood is off:
		if the target_status of the noun is off:
			say "It's already off.";
		otherwise:
			say "You hit the OFF button on the oven, clearing the [target_status of the noun] and resetting the target_temperature to 0 F.";
			now the target_status of the noun is off;
			now the target_temperature of the noun is 0 F;
	otherwise if the OvenStatus understood is bake:
		if the target_temperature of the noun is 0 F:
			say "You hit the bake button, but the oven buzzes with complaint. It needs a target_temperature first.";
		otherwise if the target_status of the noun is off:
			say "You hit the bake button and press start, beginning to heat the oven.";
			now the target_status of the noun is bake;
		otherwise if the target_status of the noun is bake:
			say "It's already set to bake.";
		otherwise if the target_status of the noun is broil:
			say "You switch the oven from broil to bake.";
			now the target_status of the noun is bake;
	otherwise if the OvenStatus understood is broil:
		if the target_temperature of the noun is 0 F:
			say "You hit the broil button, but the oven buzzes with complaint. It needs a target_temperature first.";
		otherwise if the target_status of the noun is off:
			say "You hit the broil button and press start, beginning to heat the oven.";
			now the target_status of the noun is broil;
		otherwise if the target_status of the noun is bake:
			say "You switch the oven from bake to broil.";
			now the target_status of the noun is broil;
		otherwise if the target_status of the noun is broil:
			say "The oven is already set to broil.";

Understand "set [AbstractOven] to [temperature]" as setting it by temperature. Setting it by temperature is an action applying to one thing and one temperature.

Check setting an AbstractOven by temperature:
	if the temperature understood is less than 200 F:
		say "The minimum temperature for the oven is 200 F." instead;
	otherwise if the temperature understood is greater than 500 F:
		say "The dial only goess to 500 F." instead;

Carry out setting an AbstractOven by temperature:
	now the target_temperature of the noun is the temperature understood.

Report setting an AbstractOven by temperature:
	say "You set [the noun] to [temperature understood]."

Every turn:
	repeat with instance running through AbstractOvens:
		if target_status of instance is not OFF:
			if target_temperature of instance is greater than current_temperature of instance:
				now current_temperature of instance is current_temperature of the instance + 23 F;
			if current_temperature of instance is greater than target_temperature of instance:
				now current_temperature of instance is target_temperature of instance;
				say "[The instance] plays a jaunty tune, indicating that it's finished preheating.";
		if target_status of the instance is OFF:
			if current_temperature of instance is greater than room temperature:
				now current_temperature of instance is current_temperature of the instance - 23 F;
			if current_temperature of instance is less than room temperature:
				now current_temperature of instance is room temperature;

Test oven with "
set upper oven to asdf/
set upper oven to bake/
set upper oven to broil/
set upper oven to off/
set upper oven to 3/
set upper oven to 3 F/
set upper oven to 9999 F/
set upper oven to 250 degrees farenheit/
set upper oven to bake/
set upper oven to broil/
set upper oven to broil/
set upper oven to bake/
set upper oven to off/
set upper oven to off
"

[ Mixing test - we should be able to combine sugar and raisins. ]
Test mixing with "pour raisins into half-cup / pour half-cup into 4-cup / x 4-cup / pour white sugar into quarter-cup / pour quarter-cup into 4-cup / x 4-cup"

Book 3 - Time

When play begins: now the right hand status line is "[time of day]".

[ See http://inform7.com/book/RB_4_1.html for the example this is taken from. ]

Examining something is acting fast. Looking is acting fast.

The take visual actions out of world rule is listed before the every turn stage rule in the turn sequence rules.

This is the take visual actions out of world rule: if acting fast, rule succeeds.

Volume 2 - Content

When play begins:
	say "Special verbs are [italic type]fill[roman type] and [italic type]pour[roman type]."

Book 1 - Rooms

A bread recipe is carried by the player. The description is "Dead-Easy Bread[line break]
1 1/2 lb (about 5 1/4 cups) all-purpose flour[line break]
1 tsp salt[line break]
2 cups water[line break]
1 tsp sugar[line break]
1 tsp active dry yeast[line break]
Pour flour and salt into the mixer bowl. In another bowl, beat the sugar and yeast into the water. Pour the liquids into the dry ingredients and stir until it comes together into a dough. Using the dough hook for the mixer, put it to speed 2 and leave it on for ~8 minutes-ish. Cover with a towel and leave it to rise for an hour and a half.[line break]
After it rises, prep the baking sheet by putting some parchment paper on it. Take out the dough, flour a board and gently knead it a bit then shape it into an oval. Stick it on the sheet and cover it with a cloth and leave to rise for another 45-minutes-ish. Preheat the oven when appropriate (about 20 minutes before the rise is done with our oven) at 450 degrees.[line break]
Bake for ~20-25 minutes at 450 degrees, then remove and cool.
"

test happy with "
put 3-qt on corian /
pour all-purpose into 4-cup /
pour 4-cup into 3-qt /
fill 1-cup with all-purpose /
pour 1-cup into 3-qt /
fill quarter-cup with all-purpose /
pour quarter-cup into 3-qt /
fill 1-tsp with salt /
pour 1-tsp into 3-qt /
fill 1-cup from sink /
pour 1-cup into 4-cup /
fill 1-cup from sink /
pour 1-cup into 4-cup /
fill 1-tsp with active dry yeast /
pour 1-tsp into 4-cup /
fill 1-tsp with sugar /
pour 1-tsp into 4-cup /
x 4-cup /
x 3-qt /
beat water with mixer bowl /
pour 3-qt into mixer bowl /
pour 4-cup into mixer bowl /
stir mixer bowl /
x mixer bowl /
attach paddle to stand mixer /
set stand mixer to 2 /
z /
z /
z /
x mixer bowl /
z /
z /
z /
x mixer bowl /
z /
z /
set mixer to off /
x mixer bowl
"

Part 1 - Kitchen

The Kitchen is a room. "Objectively, your kitchen has a fair amount of counter space, but it never feels that way! Most of west wall is taken up by a [bold type]long Corian countertop[roman type] over various [bold type]drawers[roman type], with a [bold type]kitchen sink[roman type] and a [bold type]washing machine[roman type] cutting through the center. The east wall houses a [bold type]gas stovetop[roman type], a [bold type]double wall oven[roman type], a [bold type]small tile countertop[roman type], and the [bold type]fridge[roman type]. Above and below the countertops, crammed wherever there is space, are a profusion of [bold type]cabinets[roman type]. Morning light shines through the glass sliding door to the north, through which you can see the patio. To the south lies the dining room."

Chapter 1 - West Wall

[ Sink ]

A kitchen sink is in Kitchen. It is fixed in place. It is scenery. It is an IngredientContainer with capacity 8 gallons. It is an ingredient_source. In it is an _Ingredient with ingredient_info id_water and current_volume 8 gallons.

[ Dish washer ]

A dishwashing machine is a supporter in the Kitchen. It is fixed in place and scenery.

Understand "washing machine" as dishwashing machine.

A drying rack is on the dishwashing machine. It is scenery. It is a container.

[ Large counter ]

A large Corian countertop is a supporter in the Kitchen. It is fixed in place. It is scenery.

Understand "large Corian counter" as large Corian countertop.

A StandMixer called the stand mixer is on the large Corian countertop.

A StandMixerBowl called the mixer bowl is in the stand mixer.

A plastic attachments tub is a container on the large Corian countertop.

An MixerAttachment called the paddle attachment is in the plastic attachments tub.

An MixerAttachment called dough hook attachment is in the plastic attachments tub.

An MixerAttachment called whisk attachment is in the plastic attachments tub.

Chapter 2 - East wall

[ Stove & fume hood ]

A fume hood is in the kitchen. It is fixed in place. It is scenery.

A gas stovetop is in the kitchen. It is fixed in place. It is scenery.

The upper-left burner, the upper-right burner, the lower-left burner, and the lower-right burner are parts of the stovetop.

Understand "stove" as gas stovetop.

[ Tall double wall oven ]

A tall double wall oven is in the kitchen. It is fixed in place. It is scenery.
The upper oven is an AbstractOven. It is part of the double wall oven.
The lower oven is an AbstractOven. It is part of the double wall oven.

[ Small tile countertop ]

A small tile countertop is a supporter in the Kitchen. It is fixed in place. It is scenery.

Understand "small tile counter" as small tile countertop.

[ Refrigerator ]

A refrigerator is in the kitchen. It is fixed in place. It is scenery. It is a container.

Understand "fridge" as refrigerator.

A small glass bottle is in the refrigerator. It is an IngredientContainer with capacity 4 fl oz. It is an ingredient_source. In it is an _Ingredient with ingredient_info id_ady and current_volume 2.4 fl oz.

Chapter 3 - Drawers

A drawers is in the kitchen. It is fixed in place. It is scenery. "You list off the drawers in your head. Dinnerware is in the [bold type]utensil drawer[roman type] on the left of the washing machine, and instruments are in the [bold type]instrument drawer[roman type] to the right of the sink."

[ Utensil drawer ]

A utensil drawer is in the kitchen. It is fixed in place. It is scenery.

[ Small instrument drawer ]

An instrument cabinet is in the kitchen. It is fixed in place. It is scenery. It is a container.

A 1/4-tsp measuring spoon is in the instrument cabinet. It is an IngredientContainer with capacity 0.25 tsp.
Understand "quarter-teaspoon measuring spoon" as 1/4-tsp measuring spoon. Understand "quarter-teaspoon" as 1/4-tsp measuring spoon.

A 1/2-tsp measuring spoon is in the instrument cabinet. It is an IngredientContainer with capacity 0.5 tsp.
Understand "half-teaspoon measuring spoon" as 1/2-tsp measuring spoon. Understand "half-teaspoon" as 1/2-tsp measuring spoon.

A 1-tsp measuring spoon is in the instrument cabinet. It is an IngredientContainer with capacity 1 tsp.
Understand "teaspoon measuring spoon" as 1-tsp measuring spoon. Understand "teaspoon" as 1-tsp measuring spoon.

A 1/4-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 2 fl oz.
Understand "quarter-cup dry measuring cup" as 1/4-cup dry measuring cup. Understand "quarter-cup" as 1/4-cup dry measuring cup.

A 1/3-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 16 tsp.
Understand "third-cup dry measuring cup" as 1/3-cup dry measuring cup. Understand "third-cup" as 1/3-cup dry measuring cup.

A 1/2-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 4 fl oz.
Understand "half-cup dry measuring cup" as 1/2-cup dry measuring cup. Understand "half-cup" as 1/2-cup dry measuring cup.

A 1-cup dry measuring cup is in the instrument cabinet. It is an IngredientContainer with capacity 8 fl oz.
Understand "cup dry measuring cup" as 1-cup dry measuring cup. Understand "cup" as 1-cup dry measuring cup.

A 12-inch wooden mixing spoon is in the instrument cabinet.

A 12-inch wooden slotted spoon is in the instrument cabinet.

Chapter 4 - Cabinets

A cabinets is in the kitchen. It is fixed in place. It is scenery. "You list off the cabinets in your head. The [bold type]spice rack[roman type] is over to the right of the sink, and the [bold type]mixing bowl cabinet[roman type] (which also has the liquid measuring cups) is the one next to it. The [bold type]pantry[roman type]'s down under the L-countertop near the dining room. Pans and saucepans are in the [bold type]under-stove cabinet[roman type], and pots proper are in the [bold type]pot cabinet[roman type] near the sliding door. Cleaning supplies (hopefully unnecessary) are in the [bold type]under-sink cabinet.[roman type] Good thing you know where everything is, right?"

[ Bowl cabinet ]

A mixing bowl cabinet is in the kitchen. It is fixed in place. It is scenery. It is a container.

A 1.5-qt mixing bowl is in the bowl cabinet. It is a IngredientContainer with capacity 1.5 quarts.

A 3-qt mixing bowl is in the bowl cabinet. It is a IngredientContainer with capacity 3 quarts.

A 5-qt mixing bowl is in the bowl cabinet. It is a IngredientContainer with capacity 5 quarts.

A 4-cup wet measuring cup is in the bowl cabinet. It is an IngredientContainer with capacity 32 fl oz. It is graduated.

[ Towel cabinet ]

A towel cabinet is in the kitchen. It is fixed in place. It is scenery.

[ Spice rack ]

A spice rack is in the kitchen. It is fixed in place. It is scenery.

A 500g cardboard cylinder is in the spice rack. It is an IngredientContainer with capacity 30 tbsp.  In it is an _Ingredient with ingredient_info id_salt and current_volume 19 tbsp. It is an ingredient_source.

[ Pantry ]

A pantry cabinet is in the kitchen. It is fixed in place. It is scenery.

A all-purpose flour bin is in the pantry cabinet. It is an IngredientContainer with capacity 4 quarts. It is an ingredient_source. In it is an _Ingredient with ingredient_info id_flour and current_volume 3.1 quarts.

[ A bread flour bin is in the pantry cabinet. It is an IngredientContainer with capacity 4 quarts and ingredients_list {bread flour} and volumes_list {1.4 cups}. It is an ingredient_source. ]

[ A cake flour bin is in the pantry cabinet. It is an IngredientContainer with capacity 4 quarts and ingredients_list {cake flour} and volumes_list {2.7 cups}. It is an ingredient_source. ]

A white cardboard box is in the pantry cabinet. It is an IngredientContainer with capacity 2.5 cups. It is an ingredient_source. In it is an _Ingredient with ingredient_info id_sugar and current_volume 1.9 cups.

[ A raisins bag is in the pantry cabinet. It is an IngredientContainer with capacity 30 fl oz. It is an ingredient_source. In it is an _Ingredient with ingredient_info id_raisins and current_volume 22 fl oz. ]

[ Spoon & spatula rack ]

A instrument wall hook rack is a supporter in the Kitchen. It is fixed in place. It is scenery.

[ Saucepan rack ]

A saucepan wall hook rack is in the kitchen. It is fixed in place. It is scenery.

Part 2 - Dining Room

The Dining Room is a room. It is north of the Kitchen. "Dining room description."