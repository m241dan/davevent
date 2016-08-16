# davevent
An event queue written by Daniel R. Koris in Lua.

This is a Lua Event Queue. It sleeps when it has nothing to do but must always have some action coming in the future.
It uses Insert Sort to add new events to the Queue. Is capable of handling up to Microseconds.

This library requires [lua-time](https://github.com/m241dan/lua-time)
