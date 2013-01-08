package sban.simplemvc.core
{
	public class Pool
	{
		public function Pool()
		{
		}
		
		protected var _objs :Object = {};
		
		public function retrieve(name :String):Object
		{
			return _objs[name];
		}
		
		public function register(name :String, obj :Object):void
		{
			_objs[name] = obj;
		}
		
		public function remove(name:String):void
		{
			delete _objs[name];
		}
		
		public function clear():void
		{
			_objs = {};
		}
	}
}