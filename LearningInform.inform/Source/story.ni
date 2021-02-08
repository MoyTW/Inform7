"Scratch" by MoyTW

Include Ingredients And Containers by MoyTW.

Book Definitions

Part Ingredients

Table of Ingredient Info (continued)
ingredient_id	ingredient_name
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

[ TODO: This doesn't work properly with multi-word names - see https://intfiction.org/t/inform-7-changing-the-name-of-an-object/2507 for a possible, if awfully hacky, example. ]
Understand the info_name property as describing an _Ingredient;

Check taking an _Ingredient: [ TODO: Add column for "solid" or "carryable" to ingredients ]
	say "Carrying [the info_name] in your hands would be at best messy. Try pouring [the holder of the noun] into a container, or filling a container from the [the holder of the noun].";
	stop the action.

Part Recipes

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

Part IngredientContainer

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

Book Verbs

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
	try the actor pouring the second noun into the noun instead.

Rule for supplying a missing second noun while an actor filling (this is the query player for source rule):
	say "You'll need to specify what to fill [the noun] with."

Part - Pour Verb

To pour is a verb.

Understand "pour [something] in/into/with [something]" as pouring it into.
Understand "empty [something] in/into/with [something]" as pouring it into.

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
	say "You knead [the noun]. [the holder of the noun].";
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

Section Kitchen

100 _Ingredients are in ingredient_storage.

The kitchen is a room.

The Corian countertop is in the kitchen. The countertop is a supporter. It is fixed in place.

The spoon is on the Corian countertop.
The big bowl is on the Corian countertop. It is an IngredientContainer with capacity 12 cups. In the big bowl is an _Ingredient with ingredient_info id_flour and current_volume 252 tsp.
On the Corian Countertop is an IngredientContainer called the vial with capacity 4 tsp.
On the corian countertop is an IngredientContainer called the shaker. In the shaker is an _Ingredient with ingredient_info id_salt and current_volume 1 tsp.
[
The small bowl is on the Corian countertop. It is a container.
On the Corian countertop is an IngredientContainer called the large tub. In the large tub is an Ingredient. The ingredient_info of it is id_flour.
On the corian countertop is an IngredientContainer called the well. In the well is an _Ingredient with ingredient_info id_salt and current_volume 2 tbsp.
[On the Corian countertop is an IngredientContainer called the pitcher. The capacity of it is 1 cup. In the pitcher is an Ingredient. The ingredient_info of it is id_water.]
On the Corian countertop is an IngredientContainer called the small tub. In the small tub is an Ingredient. The ingredient_info of it is id_sugar.
On the Corian countertop is an IngredientContainer called the bottle. In the bottle is an Ingredient. The ingredient_info of it is id_ady.
On the Corian countertop is an IngredientContainer called the jar.
On the Corian countertop is an ingredient. The ingredient_info of it is id_risen_dough.
]
On the Corian countertop is an IngredientContainer called the cup. In the cup is an _Ingredient with ingredient_info id_water and current_volume 96 tsp. In the cup is an _Ingredient with ingredient_info id_ady and current_volume 1 tsp. In the cup is an _Ingredient with ingredient_info id_sugar and current_volume 1 tsp.

When play begins:
	repeat with i running through _Ingredients not in ingredient_storage:
		init_ingredient i with ingredient_info of i and current_volume of i;

test game with "beat water with spoon / pour shaker into bowl / pour cup into bowl / combine ingredients in bowl / l / knead shaggy dough / knead shaggy dough / knead shaggy dough / knead shaggy dough / knead shaggy dough / knead shaggy dough"