EventQueue = require( "eventqueue" )

local function repeater( init )
   while true do
      print( init )
      coroutine.yield( 2000 ) -- repeat every two seconds
   end
end

local wrap = coroutine.wrap( repeater )
local b = EventQueue.event:new( wrap )
b:args( "beep, its been 2 seconds" )
b.execute_at = EventQueue.time() + 2000
b.name = "repeater"

local function myprint( myinput )
   print( myinput )
   return true
end

local func = myprint
local a = EventQueue.event:new( func )
a:args( "hi, there" )
a.name = "simple print"

EventQueue.insert( a )
EventQueue.insert( b )

EventQueue.run()
