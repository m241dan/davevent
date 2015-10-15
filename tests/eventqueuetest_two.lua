EventQueue = require( "eventqueue" )

local function repeater( init )
   while true do
      print( init )
      coroutine.yield( 2000 ) -- repeat every two seconds
   end
end

local wrap = coroutine.wrap( repeater )
local b = EventQueue.event:new( wrap )
b:setArgs( "beep, its been 2 seconds" )
b.execute_at = EventQueue.time() + 2000
b.name = "repeater"

local function myprint( myinput )
   print( myinput )
   return true
end

local func = myprint
local a = EventQueue.event:new( func )
a:setArgs( "hi, there" )
a.name = "simple print"

local function every_five()
   while true do
      print( "it's been five seconds" )
      coroutine.yield( 5000 )
   end
end

local five_func = coroutine.wrap( every_five )
local c = EventQueue.event:new( five_func, 5000, nil, "five second repeater" )

EventQueue.insert( a )
EventQueue.insert( b )
EventQueue.insert( c )

EventQueue.run()
