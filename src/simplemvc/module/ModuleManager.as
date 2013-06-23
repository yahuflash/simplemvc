package simplemvc.module
{

	/**提供对模块的管理*/
	public final class ModuleManager{
		private static var instance:ModuleManager;
		public static function sharedModuleManager():ModuleManager{
			return (instance ||= new ModuleManager);
		}
		public function ModuleManager(){}
		protected const modules:Vector.<Module> =new Vector.<Module>();
		
		/**当模块被创建时，添加进列表*/
		public function add(module:Module):void{
			modules.push(module);
		}
		/**在其它地方拉取模块对象*/
		public function retrieve(moduleName:String):Module{
			var r:Module;
			modules.some(function(m:Module,index:int=-1,vec:Vector.<Module>=null):Boolean{
				if(m.getName() == moduleName){
					r = m;
					return true;
				}
				return false;
			});
			return r;
		}
		/**在模块释放时，调用该方法;其它模块将不能继续拉取该模块*/
		public function remove(module:Module):void{
			var index:int = modules.indexOf(module);
			if (index > -1) modules.splice(index,1);
		}
	}
}