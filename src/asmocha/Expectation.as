package asmocha
{
   import flash.utils.getQualifiedClassName;
   import flash.utils.ByteArray;
   
   /**
    * ...
    * @author GameClay
    */
   public class Expectation
   {
      public function Expectation(fn_name:String)
      {
         _got_called_with = new Array();
         
         _with = new Array();
         _throws = new Array();
         _dispatches = new Array();
         _returns = new Array();
         
         _fn_name = fn_name;
         
         Expectations.add(this);
      }
      
      //{ Mocha-like interface
         
      /**
       * Returns this expectation without modification.
       * Syntactical sugar.
       */
      public function get and():Expectation
      {
         return this;
      }
      
      /**
       * Modifies this Expectation so that the expected method must
       * be called at least a minimum number of times.
       * 
       * @param   n The minimum number of times 
       * @return This Expectation modified accordingly.
       */
      public function at_least(n:uint):Expectation
      {
         _n = n;
         _call = CALL_AT_LEAST;
         return this;
      }
      
      /**
       * Modifies this Expectation so that the expected method
       * must be called at least once.
       */
      public function get at_least_once():Expectation
      {
         return at_least(1);
      }
      
      /**
       * Modifies this Expectation so that the expected method must
       * be called at most a maximum number of times.
       * 
       * @param   n The maximum number of times 
       * @return This Expectation modified accordingly.
       */
      public function at_most(n:uint):Expectation
      {
         _n = n;
         _call = CALL_AT_MOST;
         return this;
      }
      
      /**
       * Modifies this Expectation so that the expected method
       * must be called at most once.
       */
      public function get at_most_once():Expectation
      {
         return at_most(1);
      }
      
      /**
       * Modifies expectation so that when the expected method is called, 
       * it dispatches the specified Event.
       */
      public function dispatches(... args):Expectation
      {
         for (var i:uint = 0; i < args.length; i++)
            _dispatches.push(args[i]);
         return this;
      }
      
      /**
       * Constrains this expectation it must be invoked at the
       * current point in the sequence. 
       */
      public function in_sequence(sequence:Object):Expectation
      {
         // TODO
         return this;
      }
      
      /**
       * Modifies this expectation so that the expected method
       * must never be called.
       */
      public function get never():Expectation
      {
         return at_most(0);
      }
      
      /**
       * Modifies this expectation so that the expected method
       * must be called exactly once.
       *
       * This is the default behavior for the Expectation object.
       */
      public function get once():Expectation
      {
         return times(1);
      }
      
      /**
       * Modifies expectation so that when the expected method is called, 
       * it throws the specified Errors.
       */
      public function throws(... args):Expectation
      {
         for (var i:uint = 0; i < args.length; i++)
            _throws.push(args[i]);
         return this;
      }
      
      /**
       * Modifies expectation so that when the expected method is called, 
       * it returns the specified value.
       */
      public function returns(... args):Expectation
      {
          for (var i:uint = 0; i < args.length; i++)
             _returns.push(args[i]);
          return this;
      }
      /**
       * With no arguments, this method only serves to improve redability.
       *
       * Called with an argument, this expectaion will be modified
       * so that when the expected method is called, a state-machine
       * change is executed.
       */
      public function then(state_change:Object = null):Expectation
      {
         // Just syntactical sugar
         if (state_change != null)
         {
            // When the expected method is invoked, change the 
            // state on a state machine.

            // Create a StateChange object which references a 
            // StateMachine and state to change it to, then
            // invoke that
         }
         return this;
      }
      
      /**
       * Modifies this expectation so that the number of calls
       * to the expected method must be within a specific range.
       *
       */
      public function times(... range):Expectation
      {
         _n = range[0];
         if (range.length == 1)
            _n2 = _n;
         _call = CALL_RANGE;
         return this;
      }
      
      /**
       * Modifies this expectation so that the expected method
       * must be called exactly twice.
       */
      public function get twice():Expectation
      {
         return times(2);
      }
      
      /**
       * Constrains the expectation to occur only when the 
       * StateMachine is in the named state.
       */
      public function when(state_machine:Object):Expectation
      {
         return this;
      }
      
      /**
       * Modifies expectation so that the expected method must be called 
       * with expected_parameters.
       */
      public function called_with(... args):Expectation
      {
         for (var i:uint = 0; i < args.length; i++)
            _with.push(args[i]);
         return this;
      }
      //}
      
      // Helper
      private function timesString(n:uint):String
      {
         switch(n)
         {
            case 0: return "never";
            case 1: return "once";
            case 2: return "twice";
         }
         
         return n.toString() + " times";
      }
      
      /**
       * Converts to a string.
       * @return String representation of the Expectation.
       */
      public function toString():String
      {
         var ret:String = "[Expectation: '" + _fn_name + "' to be called ";
         var i:uint = 0;
         
         switch (_call)
         {
            case CALL_RANGE:
               if (_n != _n2)
                  ret += "between " + _n.toString + " and " + _n2.toString() + " times";
               else
                  ret += "exactly " + timesString(_n);
               break;
               
            case CALL_AT_LEAST:
               ret += "at least " + timesString(_n);
               break;
               
            case CALL_AT_MOST:
               ret += "at most " + timesString(_n);
               break;
         }
         
         if (_got_called_with.length > 0 )
            ret += " (called " + timesString(_got_called_with.length) + ")";
         
         if (_sequence != null)
         {
            // In sequence
         }
         
         // Called with...
         if( _with.length > 0)
         {
            ret += " with arguments:";
            for (i = 0; i < _with.length; i++)
            {
               ret += "\n\t[" + _with[i].toString() + "]";
               if (_got_called_with.length > i)
                  ret += " (" + _got_called_with[i].toString() + ")";
            }
            ret += "\n";
         }
         
         // ...throwing exceptions...
         if (_throws.length > 0)
         {
            ret += " which will throw:";
            for (i = 0; i < _throws.length; i++)
            {
               ret += "\n\t[" + _throws[i].toString() + "]";
            }
            ret += "\n";
         }
         
         // ...and returning...
         if (_returns.length > 0)
         {
            ret += " and will return:";
            for (i = 0; i < _returns.length; i++)
            {
               ret += "\n\t[" + _returns[i].toString() + "]";
            }
            ret += "\n";
         }
         
         ret += "]";
         
         return ret;
      }
      
      /**
       * The expected method is being called.
       */
      internal function got_called(... params):void
      {
         if (params.length < 1)
            params.push(undefined);
         
         for (var i:uint = 0; i < params.length; i++)
            _got_called_with.push(params[i]);
      }
      
      /**
       * Get the next value to return from a mocked call.
       */
      internal function get_return():*
      {
         return _returns[_got_called_with.length - 1];
      }
      
      /**
       * The expected method has thrown an exception.
       */
      internal function get_thrown():Error
      {
         return _throws[_got_called_with.length - 1];
      }
      
      /**
       * Get the next event to trigger from a mocked call.
       */
      internal function get_dispatched():*
      {
         return _dispatches[_got_called_with.length - 1];
      }
      
      public static function byteCompare(obj1:Object, obj2:Object):Boolean
      {
         // Type mismatch? Fail.
         if (typeof(obj1) != typeof(obj2))
            return false;
         
         // If native type, use built-in compare.
         switch(typeof(obj1))
         {
            case 'boolean':
            case 'function':
            case 'number':
            case 'string':
               return (obj1 == obj2);
         }
         
         // Attempt magic...
         var buffer1:ByteArray = new ByteArray();
         buffer1.writeObject(obj1);
         var buffer2:ByteArray = new ByteArray();
         buffer2.writeObject(obj2);

         if (buffer1.length == buffer2.length) 
         {
            buffer1.position = 0;
            buffer2.position = 0;

            while (buffer1.position < buffer1.length) 
            {
               if (buffer1.readByte() != buffer2.readByte())
                  return false;
            }
            
            return true;
         }
         
         return false;
      }
      
      /**
       * Validate the Expectation
       */
      internal function has_been_met():Boolean
      {
         var ret:Boolean = true;
         var i:uint = 0;
         
         // Validate invocation count restrictions
         switch (_call)
         {
            case CALL_RANGE:
               ret &&= (_got_called_with.length >= _n);
               ret &&= (_got_called_with.length <= _n2);
               break;
               
            case CALL_AT_LEAST:
               ret &&= (_got_called_with.length >= _n);
               break;
               
            case CALL_AT_MOST:
               ret &&= (_got_called_with.length <= _n);
               break;
         }
         
         // Validate sequence 
         if (_sequence != null)
         {
            // TODO
         }
         
         // Validate that it has been called with proper parameters
         for (i = 0; i < _with.length; i++)
         {
            if (_got_called_with.length > i)
            {
               ret &&= byteCompare(_with[i], _got_called_with[i]);
            }
            else
            {
               // didn't get called enough times?
               ret = false;
            }
         }
         
         _was_met = ret;
         return ret;
      }
      
      internal function get was_met():Boolean
      {
         return _was_met;
      }
      
      //{ Constants
      private static const CALL_RANGE:uint = 0;
      private static const CALL_AT_LEAST:uint = 1;
      private static const CALL_AT_MOST:uint = 2;
      
      //{ Data
      private var _n:uint = 1;
      private var _n2:uint = 1;
      private var _call:uint = CALL_RANGE;
      
      private var _sequence:Object = null;
      
      private var _returns:Array;
      private var _with:Array;
      private var _throws:Array;
      private var _dispatches:Array;
      
      private var _got_called_with:Array;
      
      private var _was_met:Boolean = false;
      private var _fn_name:String;
      //}
   }
}