package sban.simplemvc.model.proxy
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import sban.simplemvc.core.Promise;

	/**
	 *以设备内存作为存储源，封装对其操作方法  
	 * @author sban
	 * 
	 */	
	public dynamic class MemoryProxy extends Proxy
	{
		public static const single :MemoryProxy = new MemoryProxy();
		
		public function MemoryProxy()
		{
		}
		
		protected var data :Object = {};
		
		public function insert(name:String,type:Class,values:Object):Promise
		{
			// TODO Auto Generated method stub
			var item:Object = new type;
			for (var s:String in values) 
				item[s] = values[s];
			
			var items :Array = this[name+"s"];
			(items ||= []).unshift(item);
			this[name+"s"] = items;
			return new Promise(this).complete(true);
		}
		
		public function select(name:String,id:Object):Promise
		{
			// TODO Auto Generated method stub
			var vo :Object;
			var vos :Array = this[name+"s"];
			vos.some(
				function(n :Object,index:int=-1,arr:Array=null):Boolean
				{
					if(n.id == id)
					{
						vo = n;
						return true;
					}
					return false;
				}
			);
			return new Promise(this).complete(vo);
		}
		
		public function remove(name:String,id:Object):Promise
		{
			var vos :Array = this[name+"s"];
			vos.some(
				function(n:Object,index:int=-1,arr:Array=null):Boolean
				{
					if(n.id == id)
					{
						vos.splice(index,1);
						return true;
					}
					return false;
				}
			);
			this[name+"s"] = vos;
			return new Promise(this).complete(true);
		}
		
		public function update(name:String, id:Object, values:Object):Promise
		{
			// TODO Auto Generated method stub
			var vos :Array = this[name+"s"];
			vos.some(
				function(n:Object,index:int=-1,arr:Array=null):Boolean
				{
					if(n.id == id)
					{
						for (var s:String in values) 
							n[s] = values[s];
						return true;
					}
					return false;
				}
			);
			this[name+"s"] = vos;
			return new Promise(this).complete(true);
		}
		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			switch (name.toString()) {
				case 'clear':
					data = {};
					break;
				case 'remove':
					delete this.data[parameters[0]];
					break;
				default:
					break;
			}
			return this;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			// TODO Auto Generated method stub
			delete this.data[name.toString()];
			return true;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			// TODO Auto Generated method stub
			return this.data[name.toString()];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			// TODO Auto Generated method stub
			return (this.data[name.toString()]);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			// TODO Auto Generated method stub
			this.data[name.toString()] = value;
		}
		
		
	}
}