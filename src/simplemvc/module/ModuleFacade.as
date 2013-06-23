package simplemvc.module
{
	public final class ModuleFacade{
		public function ModuleFacade(){}
		public function defaultModule():Module{ return ModuleManager.sharedModuleManager().retrieve("default");}
	}
}