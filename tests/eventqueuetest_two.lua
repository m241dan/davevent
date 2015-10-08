EventQueue = require( "eventqueue" )

local function repeater( input )
   while true do
      print( input )
      coroutine.yield( 2000 ) -- repeat every two seconds
   end
end

local thread2 = coroutine.create( repeater )
local b = EventQueue.event:new( thread2 )
b:args( "beep, its been 2 seconds" )
b.execute_at = EventQueue.time() + 2000
b.name = "repeater"

local function myprint( myinput )
   print( myinput )
end

local thread1 = coroutine.create( myprint )
local a = EventQueue.event:new( thread1 )
a:args( "hi, there" )
a.name = "simple print"

EventQueue.insert( a )
EventQueue.insert( b )

EventQueue.run()
