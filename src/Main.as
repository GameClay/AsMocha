package 
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   import asmocha.*;
   
   /**
    * ...
    * @author GameClay
    */
   public class Main extends Sprite 
   {
      
      public function Main():void 
      {
         if (stage) init();
         else addEventListener(Event.ADDED_TO_STAGE, init);
      }
      
      private function init(e:Event = null):void 
      {
         removeEventListener(Event.ADDED_TO_STAGE, init);
         
         // Test basic stuff
         var foo:Object = new Mock();
         foo.expects('push').twice.called_with(5, 3);
         foo.expects('pop').twice.returns(5).then().returns(3);
         foo.push(5);
         foo.push(3);
         trace(foo.pop());
         trace(foo.pop());
         
         // Test events
         var bar:Object = new Mock();
         bar.addEventListener(Event.ADDED, function(e:Event):void
         {
            trace(e);
         });
         bar.expects('foo').dispatches(new Event(Event.ADDED)).returns(42);
         trace(bar.foo());
         
         Expectations.have_been_met();
      }
      
   }
   
}