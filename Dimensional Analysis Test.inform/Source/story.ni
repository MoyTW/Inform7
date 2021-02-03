"Dimensional Analysis Test" by "MoyTW"

A generic unit is a kind of value. 1.0 gu specifies a generic unit.

The Placeholder Room is a room.

When play begins:
	say "1.0 gu :[1.0 gu].";
	say "1.0 gu + 3.7 gu: [1.0 gu + 3.7 gu].";
	[ This should be a scalar value, but it gives total nonsense! ]
	say "1.0 gu / 1.0 gu: [1 gu / 1 gu]."; [ prints 1065353216! What!? ]
	say "93.1 gu / 37.0 gu: [93.1 gu / 37.0 gu]."; [ prints 1075906992 ]
	[ As per http://inform7.com/book/WI_15_20.html we expect multiplication to fail ]
	[ say "1.0 gu * 1.0 gu: [1.0 gu * 1.0 gu]."; ]