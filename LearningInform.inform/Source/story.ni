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
id_dry_ingredients	"dry ingredients"
id_wet_ingredients	"wet ingredients"
id_loaf_of_bread	"loaf of bread" [ Isn't REALLY an ingredient but ok ]

An Ingredient is a kind of thing.
An Ingredient has an IngredientInfo called ingredient_info. The ingredient_info of an Ingredient is usually id_uninitualized.
An Ingredient has a text called info_name.
An Ingredient has a volume called current_volume. The current_volume of an Ingredient is usually 1.0 tsp.
An Ingredient has a list of Ingredients called the ingredients_list.

To init_ingredient target (ingredient - an Ingredient) with (info - an IngredientInfo):
	choose the row with ingredient_id of info in the Table of Ingredient Info;
	now the ingredient_info of the ingredient is the info;
	now the info_name of the ingredient is the ingredient_name entry;

Rule for printing the name of an Ingredient:
	say "[the info_name] ([current_volume])";

[ TODO: This doesn't work properly with multi-word names - see https://intfiction.org/t/inform-7-changing-the-name-of-an-object/2507 for a possible, if awfully hacky, example. ]
Understand the info_name property as describing an Ingredient;

Check taking an Ingredient: [ TODO: Add column for "solid" or "carryable" to ingredients ]
	say "Carrying [the info_name] in your hands would be at best messy. Try pouring [the holder of the noun] into a container, or filling a container from the [the holder of the noun].";
	stop the action.

Part Recipes

A transformation is a kind of value. The transformations are defined by the Table of Transformations.

Table of Transformations
name	duration_min	duration_max	temperature
BAKE_450F_20-25	20	25	450
RISE_90	80	100	--
KNEAD_8	6	10	--
BEAT	--	--	--

A recipe is a kind of value. The recipes are defined by the Table of Recipes.

Table of Recipes
name	product	required_ingredient_ids	ratios	transformations
r_lob	id_loaf_of_bread	{ id_bread_dough }	{ 1 }	{ BAKE_450F_20-25 }
r_rd	id_risen_dough	{ id_unrisen_dough }	{ 1 }	{ RISE_90 }
r_urd	id_unrisen_dough	{ id_dry_ingredients, id_wet_ingredients }	{ 1, 1 }	--
r_di	id_dry_ingredients	{ id_flour, id_salt }	{ 252, 1 }	--
r_wi	id_wet_ingredients	{ id_water, id_sugar, id_ady }	{ 96, 1, 1 }	{ BEAT }

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

Part - Combine Verb

To combine is a verb.

Understand "combine [container]" as combining it. Combining it is an action applying to one thing.

To decide what IngredientInfo is the id of (ing - an Ingredient) (this is getting the id of):
	decide on the ingredient_info of ing;

To decide what text is the name of (ing - an Ingredient) (this is getting the name of):
	decide on the info_name of ing;

Carry out combining it:
	let candidate_ids be getting the id of applied to the list of things held by the noun;
	if there is a product corresponding to required_ingredient_ids of candidate_ids in the Table of Recipes:
		choose the row with the required_ingredient_ids of candidate_ids in the Table of Recipes;
		if the transformations entry is empty:
			let candidate_names be getting the name of applied to the list of things held by the noun;
			repeat with i running through the list of things held by the noun:
				now i is nowhere;
			let result be a random off-stage Ingredient;
			now result is in the noun;
			init_ingredient target result with the product entry;
			say "You combied the [candidate_names] to create [the info_name of result].";
		else:
			say "Needs transformation(s): [transformations entry]";
	else:
		say "No such combination found for [candidate_ids].";

Part - Fill Verb

To fill is a verb.

Understand "fill [something] with/from [something]" as filling it with.
Understand "fill [something]" as filling it with.

Filling it with is an action applying to two things.

Carry out an actor filling something with something (this is the convert filling to pouring rule):
	try the actor pouring the second noun into the noun instead.

Rule for supplying a missing second noun while an actor filling (this is the query player for source rule):
	say "You'll need to specify what to fill [the noun] with."

Part 2 - Pour Verb

To pour is a verb.

Understand "pour [something] in/into/with [something]" as pouring it into.
Understand "empty [something] in/into/with [something]" as pouring it into.

[ TODO: Discourage the player pouring something into an ingredient source container ]

Pouring it into is an action applying to two things.
The pouring it into action has a list of ingredients called the ingredients_poured.
The pouring it into action has a list of volumes called the amounts_poured.

Setting action variables for pouring something into something (this is the setting ingredients poured rule):
	if the noun is an IngredientContainer:
		now the ingredients_poured is the list of ingredients held by the noun.

Setting action variables for pouring something (called the source) into something (called the target) (this is the setting amounts poured rule):
	if the source is an IngredientContainer and the target is an IngredientContainer:
		[ target capacity ]
		let target_remaining_capacity be capacity of target;
		repeat with held running through the list of ingredients held by the target:
			decrease target_remaining_capacity by the current_volume of held;
		[ source total ]
		let source_total_amount be 0 tsp;
		repeat with poured running through the list of ingredients held by the source:
			increase source_total_amount by current_volume of poured;
		[ amount poured ]
		if target_remaining_capacity is greater than the source_total_amount:
			repeat with poured running through the list of ingredients held by the source:
				add current_volume of poured to amounts_poured;
		otherwise:
			let scalar be target_remaining_capacity / source_total_amount;
			repeat with poured running through the list of ingredients held by the source:
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
	repeat with held running through the list of ingredients held by the noun:
		increase total_taken_capacity by current_volume of held;
	if total_taken_capacity is 0 tsp:
		say "[The noun] [are] empty.";
		stop the action.

Check an actor pouring something into something (this is the can't pour into a full container rule):
	let total_taken_capacity be 0 tsp;
	repeat with poured running through the list of ingredients held by the second noun:
		increase total_taken_capacity by current_volume of poured;
	if total_taken_capacity is the capacity of the second noun:
		say "[The second noun] [are] full!";
		stop the action.

Check an actor pouring something into something (this is the ingredient pool not exhausted rule):
	let new_ingredient be a random off-stage Ingredient;
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
			now poured_ingredient is nowhere;
		[ Add the appropriate volume to the target container ]
		let matching_ingredient be poured_ingredient;
		repeat with candidate running through the list of ingredients held by the target:
			if ingredient_info of poured_ingredient is ingredient_info of candidate:
				now matching_ingredient is candidate;
				break;
		if matching_ingredient is not poured_ingredient:
			increase current_volume of matching_ingredient by poured_volume;
		else:
			let new_ingredient be a random off-stage Ingredient;
			now new_ingredient is in the target;
			init_ingredient target new_ingredient with the ingredient_info of the poured_ingredient;
			now the current_volume of the new_ingredient is the poured_volume;
		[ Increment loop ]
		increment src_idx;

Report an actor pouring something (called source) into something (called target) (this is the standard report someone pouring rule):
	if the capacity of the source is greater than the capacity of the target:
		say "[The actor] [fill] [the target] from [the source].";
	else:
		say "[The actor] [pour] [the source] into [the target].";

Section Kitchen

10 Ingredients are in ingredient_storage.

The kitchen is a room.

The Corian countertop is in the kitchen. The countertop is a supporter. It is fixed in place.

The big bowl is on the Corian countertop. It is a container.
The small bowl is on the Corian countertop. It is a container.
On the Corian countertop is an IngredientContainer called the large tub. In the large tub is an Ingredient. The ingredient_info of it is id_flour.
On the corian countertop is an IngredientContainer called the shaker. In the shaker is an Ingredient with ingredient_info id_salt and current_volume 3 cups.
On the Corian countertop is an IngredientContainer called the pitcher. The capacity of it is 1 cup. In the pitcher is an Ingredient. The ingredient_info of it is id_water.
On the Corian countertop is an IngredientContainer called the small tub. In the small tub is an Ingredient. The ingredient_info of it is id_sugar.
On the Corian countertop is an IngredientContainer called the bottle. In the bottle is an Ingredient. The ingredient_info of it is id_ady.
On the Corian countertop is an IngredientContainer called the jar.

When play begins:
	repeat with i running through Ingredients:
		init_ingredient target i with ingredient_info of i;

test game with "put one flour in big bowl / put one salt in big bowl / combine big bowl / x big bowl / l"