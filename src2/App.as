package
{
	import flash.display.Sprite;
	
	import sban.simplemvc.core.SimpleEvent;
	
	public class App extends Sprite
	{
		public function App()
		{
			super();
			
			$.Ged.DispatchEventWith("some");
			$.Ged.addEventListener("user.request",function(e:SimpleEvent):void {
				$.Ged.DispatchEventWith("user.request.response", ".oowowooeewww");
			});
			
			$.Ged.addEventListener("user.request.response",function(result:Object):void{
				trace(result);
			});
			$.Ged.DispatchEventWith("user.request");
			trace("after..");
			
		}
		
		private function f1(arg:Object):void{
			trace(arg);
		}
		
		
	}
}