package simplemvc.module
{
	import flash.utils.getQualifiedClassName;
	
	import simplemvc.common.IDisposable;
	import simplemvc.event.DispatcherManager;
	import simplemvc.event.SimpleEventDispatcher;
	import simplemvc.parser.ModuleXMLData;
	
	/**
	 * 模块基类
	 * 每一个模块作为一个可以独立提供一部分功能的整体而存在，
	 * 当模块被释放时，建立在之上的事情监听、连接等皆被回收
	 * 
	 * 如何实现对模块相关资源的回收：
	 * 在模块被Application释放时，在全局对象上派发一个moduleDisposed事件，
	 * 相关管理者对象监听该事件，进行模块相关资源的批量移除
	 *  
	 * @author sban
	 * 
	 */	
	public class Module implements IModule,IDisposable{
		/**在模块释放后派发，args:{name:String}*/
		public static const MODULE_DISPOSED:String = "moduleDisposed";
		
		public function Module(){}
		protected var name:String="default";
		
		public function getName():String{return name;}
		
		public function getDefinination():String{
			return getQualifiedClassName(this);
		}
		
		public function init(data:ModuleXMLData):void{
			ModuleManager.sharedModuleManager().add(this);
			name = data.name;
		}
		
		public final function moduleDispatcher():SimpleEventDispatcher{
			return DispatcherManager.sharedDispatcherManager().retrieveNew(getName());
		}
		
		public function dispose():void{
			SimpleEventDispatcher.sharedSimpleDispatcher().dispatchWith(MODULE_DISPOSED,{name:getName()});
		}
	}
}