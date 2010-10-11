package asmocha
{
   import flash.events.IEventDispatcher;
   import flash.events.EventDispatcher;
   import flash.events.Event;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.describeType;
   import asmocha.Expectation;
   
   /**
    * ...
    * @author GameClay
    */
   public dynamic class Mock extends Proxy implements IEventDispatcher
   {
      public function Mock()
      {
         _expectation = new Object();
         _dispatcher = new EventDispatcher(this);
      }
      
      override flash_proxy function callProperty(methodName:*, ... args):*
      {
         var res:*;
         var methodString:String = methodName.toString();
         switch (methodString) 
         {
            case 'expects':
               res = new Expectation(args[0].toString());
               _expectation[args[0].toString()] = res;
               break;
               
            case 'responds_like':
               // Stub all methods that the provided class exposes
               var classAsXML:XML = describeType(args[0]);
               var item:XML;
               
               // get/set 
               var accessors:XMLList = classAsXML.factory.accessor;
               for each(item in accessors)
               {
                  res = new Expectation(item.@name);
                  _expectation[item.@name] = res;
                  res.at_least(0);
               }
               
               // methods
               var methods:XMLList = classAsXML.factory.method;
               for each(item in methods)
               {
                  res = new Expectation(item.@name);
                  _expectation[item.@name] = res;
                  res.at_least(0);
               }
               
               // public variables
               var variables:XMLList = classAsXML.factory.variable;
               for each(item in variables)
               {
                  res = new Expectation(item.@name);
                  _expectation[item.@name] = res;
                  res.at_least(0);
               }
               
               res = this;
               break;
               
            case 'stubs':
               // Stub a specific method - can be called any number of times (unless modified)
               res = new Expectation(methodString);
               _expectation[methodString] = res;
               res.at_least(0);
               break;
            
            case 'addEventListener':
               _dispatcher.addEventListener(args[0], args[1], 
                  args.length > 2 ? args[2] : false, 
                  args.length > 3 ? args[3] : 0,
                  args.length > 4 ? args[4] : false
               );
               break;
               
            case 'dispatchEvent':
               res = _dispatcher.dispatchEvent(args[0]);
               break;
               
            case 'hasEventListener':
               res = _dispatcher.hasEventListener(args[0]);
               break;
               
            case 'removeEventListener':
               _dispatcher.removeEventListener(args[0], args[1], 
                  args.length > 2 ? args[2] : false
               );
               break;
               
            case 'willTrigger':
               res = _dispatcher.willTrigger(args[0]);
               break;
               
            default:
               var expe:Expectation = _expectation[methodString];
               if (expe)
               {
                  expe.got_called.apply(expe, args);
                  res = expe.get_thrown();
                  if (res)
                  {
                     if (res is Error)
                        throw res;
                     else if(res is Array)
                     {
                        for(var i:uint = 0; i < res.length; i++)
                           throw res[i];
                     }
                  }
                  res = expe.get_dispatched();
                  if (res)
                  {
                     if (res is Event)
                        _dispatcher.dispatchEvent(res);
                     else if(res is Array)
                     {
                        for(i = 0; i < res.length; i++)
                           _dispatcher.dispatchEvent(res);
                     }
                  }
                  res = expe.get_return();
               }
               else
               {
                  throw new Error("Non-mocked method/property call: '" + methodString + "'");
               }
               break;
         }
         return res;
      }

      override flash_proxy function getProperty(name:*):*
      {
         return this.callProperty(name);
      }

      override flash_proxy function setProperty(name:*, value:*):void 
      {
         this.callProperty(name, value);
      }
      
      //{ IEventDispatcher -- These shouldn't get called
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
          _dispatcher.addEventListener(type, listener, useCapture, priority);
      }

      public function dispatchEvent(evt:Event):Boolean{
          return _dispatcher.dispatchEvent(evt);
      }

      public function hasEventListener(type:String):Boolean{
          return _dispatcher.hasEventListener(type);
      }

      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
          _dispatcher.removeEventListener(type, listener, useCapture);
      }

      public function willTrigger(type:String):Boolean {
          return _dispatcher.willTrigger(type);
      }
      //}
      
      private var _expectation:Object;
      private var _dispatcher:EventDispatcher;
   }
}