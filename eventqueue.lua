local socket = require( "socket" )
local Time = require( "time" )
-- .getMiliseconds()
-- .getMicroSeconds()
-- .getTime()
-- .getDiff()
-- .getSeconds()

local EQ = {}

----------------------------------------------
-- EventQueue Module Constants and Globals --
-- Written by Daniel R. Koris(aka Davenge)  --
----------------------------------------------

EQ.queue = {}
EQ.running = false
EQ.default_tick = 250 -- 250 = .25 seconds || 250 milliseconds

EQ.event = {}

---------------------------------------------------
-- EventQueue.event Methods                      --
-- Written by Daniel R. Koris(aka Davenge)       --
---------------------------------------------------

---------------------------------------------------
-- Event execute functions or wrapped coroutines --
-- You can add args with :args()                 --
---------------------------------------------------
function EQ.event:new( func )
   local event = {}

   setmetatable( event, self )
   self.__index = self
   event.func = func
   event.execute_at = EQ.time() -- by default events execute asap
   event.queued = false
   return event
end

function EQ.event:args( ... )
   self.args = { ... }
end

---------------------------------------------
-- EventQueue Module Functions             --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

--queue functions

function EQ.tick()
   return nil -- need to write the tick in as a standard measurement or "next tick" sort of function
end

-- return the time in...? Milliseconds!
function EQ.time()
   return ( Time.getMiliseconds() * 1000 )
end

EQ.second = 1000
EQ.milisecond = 1

-- eventqueuetest_one tests the insert||insertSort code

function EQ.insertSort( event, index )
   local next
   if( index < 1 ) then index = 1; end -- precautionary check

   if( event.execute_at < EQ.queue[index].execute_at ) then
      -- what to do if the current execute time is less than the event at this index
      if( index == 1 ) then
         table.insert( EQ.queue, 1, event ) -- we're at the bottom of the array, insert it
      elseif( event.execute_at >= EQ.queue[index - 1].execute_at ) then
         table.insert( EQ.queue, index, event ) -- this event is less than the index but greater than the index -1, insert it at the index
      else
         next = math.floor( index / 2 )
         return EQ.insertSort( event, next )
      end
   elseif( event.execute_at > EQ.queue[index].execute_at ) then
      -- what to do if the current execute timeis greater than the event at thisindex
      if( not EQ.queue[index + 1] or event.execute_at <= EQ.queue[index + 1].execute_at ) then
         table.insert( EQ.queue, index + 1, event ) -- we're at the top of array, insert it there or we're less than index +1, either way, insert at index+1
      else
         next = math.floor( #EQ.queue - index ) + index
         return EQ.insertSort( event, next )
      end
   else
      table.insert( EQ.queue, index, event ) -- if its to be executed at the same time(which is unlikely) you can just stick it in the same place )
   end
   return true
end

function EQ.insert( event )
   -- if there's nothing in the queue, it's the first, duh!
   if( not EQ.queue[1] ) then
      EQ.queue[1] = event
   else
      EQ.insertSort( event, math.floor( #EQ.queue / 2 ) )
   end
   event.queued = true
end

-- eventqueuetest_two tests the run and main code

function EQ.main()

   while EQ.running do
      ::mainloop::
      if( not EQ.queue[1] ) then -- should never have an empty queue, but if we do, its time to end
         print( "Program Exiting, nothing in Queue." )
         return false
      end

      local CEvent = EQ.queue[1]

      if( CEvent.execute_at <= EQ.time() ) then
         -- non-dead coroutine events should return a time at which to "requeue" in milliseconds
         local requeue_at
         if( not CEvent.args ) then
            requeue_at = assert( CEvent.func() )
         else
            print( CEvent.name )
            requeue_at = assert( CEvent.func( table.unpack( CEvent.args ) ) )
         end

         table.remove( EQ.queue, 1 ) 
         print( "Size of Event Queue = " .. #EQ.queue )
         if( type( requeue_at ) ~= "number" ) then
            CEvent.queued = false
         else
            CEvent.execute_at = EQ.time() + requeue_at -- requeue time will be current time in milliseconds + the millseconds returned by the yield
            EQ.insert( CEvent ) 
         end
         goto mainloop
      else
         socket.sleep( ( EQ.queue[1].execute_at - EQ.time() ) / 1000 )
      end
   end
end 

function EQ.run()
   EQ.running = true;
   EQ.main()
end

return EQ
