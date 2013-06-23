package simplemvc.common
{
	/***/
	public final class DelayCallManager{
		private static var instance:DelayCallManager;
		public static function sharedDelayCallManager():DelayCallManager{
			return (instance ||= new DelayCallManager);
		}
		public function DelayCallManager(){}
		private var delayCalls:Vector.<HandlerObject> = new Vector.<HandlerObject>();
		
		public function push(handler:HandlerObject):void{
			delayCalls.push( handler );
		}
		
		public function callAll():void{
			for each(var delayCall:HandlerObject in delayCalls){
				delayCall.call().release();
			}
			delayCalls.length=0;
		}
	}
}