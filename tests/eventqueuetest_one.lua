EventQueue = require( "eventqueue" )
Event = EventQueue.event;

a = Event:new( nil )
b = Event:new( nil )
c = Event:new( nil )
d = Event:new( nil )
f = Event:new( nil )


a.name = "a"
a.execute_at = EventQueue.time() + 100
b.name = "b"
b.execute_at = EventQueue.time() + 300
c.name = "c"
c.execute_at = EventQueue.time() + 200
d.name = "d"
d.execute_at = EventQueue.time() + 500
f.name = "f"
f.execute_at = EventQueue.time() + 300


EventQueue.insert( d )
EventQueue.insert( c )
EventQueue.insert( a )
EventQueue.insert( b )
EventQueue.insert( f )

for i, e in ipairs( EventQueue.queue ) do
   print( i .. " " .. e.name )
end
