"Scratch" by MoyTW

[ http://inform7.com/book/WI_18_31.html ]

Eight-Walled Chamber is a room. "A perfectly octagonal room whose walls are tinted in various hues."

A plinth is in the Eight-Walled Chamber. The plinth is a supporter.

An egg is a kind of thing.
The player carries two eggs.

A red basket is on the plinth. The red basket is a container.
A green basket is on the plinth. The green basket is a container.

[ Apparently, if you have two identical items it just picks one, instead of disambiguating by container! That isn't...quite the kind of behaviour we'd want for cooking, haha. ]
test egg with "put one egg in red / put one egg in green / l / get egg / l"

Understand "wall" as a direction.

Definition: a direction is matched if it fits the parse list.

Rule for asking which do you mean when everything matched is direction:
	say "In which direction?"

To decide whether (N - an object) fits the parse list:
	(- (FindInParseList({N})) -)

Include (-
[ FindInParseList obj i k marker;
	marker = 0;
	for (i=1 : i<=number_of_classes : i++) {
	while (((match_classes-->marker) ~= i) && ((match_classes-->marker) ~= -i)) marker++;
	k = match_list-->marker;
	if (k==obj) rtrue;
	}
	rfalse;
];
-)
