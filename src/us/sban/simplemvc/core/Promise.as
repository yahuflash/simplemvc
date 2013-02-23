package us.sban.simplemvc.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * 异步编程对象
	 * 对于异步编程，返回一个Promise对象，可以直接在该对象上进行异步编程。
	 * 例如，添加回调函数等。
	 * 
	 * 对单步异步操作已经取得结果promise对象，直接返回上次的操作结果。如果
	 * 需要刷新数据，必须重新发出请求。
	 * 
	 * 在simplemvc中，回调函数的标准写法：
	 * <pre>
	 * function(data:Object=null){...}
	 * </pre>
	 * 
	 * 假如事件名称为complete，调用方式有：
	 * 1，promise.complete()
	 * 直接派发一个complete事件
	 * 2，promise.complete(data)
	 * 如果complete括号内有参数传递，代表派发一个附有data数据的事件
	 * 3，promise.complete(func1);
	 * 添加一个func1的事件监听到complete事件上，func1形如：function(data=null):void{...}
	 * 
	 *  
	 * @author sban
	 * 
	 */	
	public dynamic class Promise extends Proxy implements IDisposable
	{
		public function Promise(source :Object)
		{
			super();
			this._source = source;
		}
		
		private var _data :Object = {};
		private var _source :Object;
		private var sed :ISimpleEventDispatcher = new SimpleEventDispatcher();
		
		/**
		 * .xxx返回操作结果，不为null代表已执行操作
		 * (.source||.s)返回执行操作的源对象
		 *  
		 * @param name
		 * @return 
		 * 
		 */		
		override flash_proxy function getProperty(name:*):*
		{
			// TODO Auto Generated method stub
			var pname:String = name.toString();
			switch(pname)
			{
				case "source":
				case "s":
				{
					return _source;
					break;
				}
				default:
				{
					return _data[pname];
				}
			}
			return null;
		}
		
		/**
		 * 移除事件监听及数据 
		 * @param name
		 * @return 
		 * 
		 */		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			// TODO Auto Generated method stub
			var eventType :String = name.toString();
			delete _data[eventType];
			sed.removeSimpleEventListeners(eventType);
			return true;
		}
		
		/**
		 * 返回异步对象本身 
		 * @param name
		 * @param parameters
		 * @return 
		 * 
		 */		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
			//事件名称
			var eventType :String = name.toString();
			
			//如果无参，默认一个参数为空数据
			if(parameters.length == 0)
				parameters = [{}];
			
			//如果方法名之后有参数
			//如果第1个参数是Function，则是匿名函数，形如function(data=null){...}
			if(parameters[0] is Function)
			{
				//如果已拿到结果，直接返回，如果没有，注册监听
				var fun :Function = parameters[0] as Function;
				if(_data[eventType])
				{
					fun.apply(null, [_data[eventType]]);
				}else{
					sed.addSimpleEventListener(eventType,
						function(e :SimpleEvent):void
						{
							e.target.removeSimpleEventListener(e.type, arguments.callee);
							_data[eventType] = e.args;
							fun.apply(null, [_data[eventType]]);
						}
					);
				}
			}else{//如果无参数，直接派发事件
				_data[eventType] = parameters[0];
				//如果第1个参数是object，在激发事件时添加参数
				sed.dispatchSimpleEventWith(eventType,parameters[0]);
			}
			
			return this;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			if(sed)
			{
				sed.release();
				sed = null;
			}
			this._source=null;
			this._data = null;
		}
		
		
	}
}