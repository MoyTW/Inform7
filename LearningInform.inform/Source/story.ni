"Scratch" by MoyTW

Section Definitions

A volume is a kind of value. 1.0 tsp (in US units, in tsp) or 1 teaspoon (in tsp, singular) or 2 teaspoons (in tsp, plural) specifies a volume.

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
id_dry_ingredients	"dry ingredients"
id_wet_ingredients	"wet ingredients"
id_loaf_of_bread	"loaf of bread" [ Isn't REALLY an ingredient but ok ]

An Ingredient is a kind of thing.
An Ingredient has an IngredientInfo called ingredient_info. The ingredient_info of an Ingredient is usually id_uninitualized.
An Ingredient has a text called info_name.
An Ingredient has a volume called current_volume.
An Ingredient has a list of Ingredients called the ingredients_list.
An Ingredient has a list of volumes called the volumes_list.

To init_ingredient target (ingredient - an Ingredient) with (info - an IngredientInfo):
	choose the row with ingredient_id of info in the Table of Ingredient Info;
	now the ingredient_info of the ingredient is the info;
	now the info_name of the ingredient is the ingredient_name entry;

Rule for printing the name of an ingredient:
	say "[the info_name]";

[ TODO: This doesn't work properly with multi-word names - see https://intfiction.org/t/inform-7-changing-the-name-of-an-object/2507 for a possible, if awfully hacky, example. ]
Understand the info_name property as describing an Ingredient;

An IngredientMixture is a kind of thing.
An IngredientMixture has a list of Ingredients called the ingredients_list.
An IngredientMixture has a list of volumes called the volumes_list.

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

Section Verbs

To combine is a verb.

Understand "combine [container]" as combining it. Combining it is an action applying to one thing.

To decide what IngredientInfo is the id of (ing - an Ingredient) (this is getting the id of):
	decide on the ingredient_info of ing;

Carry out combining it:
	let candidate_ids be getting the id of applied to the list of things held by the noun;
	if there is a product corresponding to required_ingredient_ids of candidate_ids in the Table of Recipes:
		choose the row with the required_ingredient_ids of candidate_ids in the Table of Recipes;
		if the transformations entry is empty:
			say "TODO: Combined to create [product entry].";
			repeat with i running through the list of things held by the noun:
				now i is nowhere;
			let result be a random off-stage Ingredient;
			now result is in the noun;
			init_ingredient target result with the product entry;
		else:
			say "Needs transformation(s): [transformations entry]";
	else:
		say "No such combination found for [candidate_ids].";

Section Kitchen

10 Ingredients are in ingredient_storage.

The kitchen is a room.

The Corian countertop is in the kitchen. The countertop is a supporter. It is fixed in place.

The big bowl is on the Corian countertop. It is a container.
The small bowl is on the Corian countertop. It is a container.
On the Corian countertop is an Ingredient. The ingredient_info of it is id_flour.
On the Corian countertop is an Ingredient. The ingredient_info of it is id_salt.
On the Corian countertop is an Ingredient. The ingredient_info of it is id_water.
On the Corian countertop is an Ingredient. The ingredient_info of it is id_sugar.
On the Corian countertop is an Ingredient. The ingredient_info of it is id_ady.

When play begins:
	repeat with i running through the list of Ingredients:
		init_ingredient target i with ingredient_info of i;

test game with "put one flour in big bowl / put one salt in big bowl / combine big bowl / x big bowl / put one flour in small bowl / put one salt in small bowl / combine small bowl / x small bowl"