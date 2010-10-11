package asmocha
{
   /**
    * ...
    * @author GameClay
    */
   public class Expectations
   {
      /**
       * Validates all expectations within the system.
       * 
       * @return True if your wildest dreams have come true.
       */
      public static function have_been_met():Boolean
      {
         var ret:Boolean = true;
         var met:Array = new Array();
         var failed:Array = new Array();
         
         for (var i:uint = 0; i < expectations.length; i++)
         {
            var res:Boolean = expectations[i].has_been_met();
            if (res)
               met.push(expectations[i]);
            else
               failed.push(expectations[i]);
            ret &&= res;
         }
         
         if (!ret)
         {
            if (failed.length)
            {
               trace("Expectations failed:");
               for (i = 0; i < failed.length; i++)
               {
                  trace(failed[i]);
               }
            }
            
            if (met.length)
            {
               trace("Expectations met:");
               for (i = 0; i < met.length; i++)
               {
                  trace(met[i]);
               }
            }
         }
         
         return ret;
      }
      
      /**
       * Increases the number of expecations.
       * @param   expectation Expectation to add.
       */
      internal static function add(expectation:Expectation):void
      {
         expectations.push(expectation);
      }
      
      private static function get expectations():Array
      {
         if (_expectations == null)
            _expectations = new Array();
            
         return _expectations;
      }
      
      private static var _expectations:Array;
   }

}