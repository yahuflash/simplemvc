package sban.simplemvc.model
{
	import sban.simplemvc.command.SimpleCommand;
	import sban.simplemvc.core.Application;
	import sban.simplemvc.core.Promise;
	
	public class ModelOperation extends SimpleCommand
	{
		public function ModelOperation(name:String, ...args)
		{
			super();
			this.name = name;
			this.args = args;
		}
		
		protected var name:String;
		protected var args :Array;
		
		override public function execute():Promise
		{
			// TODO Auto Generated method stub
			var model :SimpleModel = Application.application.model;
			return model[name].apply(model, args);
		}
		
		
	}
}