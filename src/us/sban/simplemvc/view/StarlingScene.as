package us.sban.simplemvc.view
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class StarlingScene extends Sprite
	{
		public function StarlingScene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,
				function(e:Event):void{
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					init();
				}
			);
		}
		
		protected function get application():StarlingApplication{
			return StarlingApplication.application;
		}
		protected function get assetManager():AssetManager{
			return StarlingApplication.application.assetManager;
		}
		protected function get sceneNavigator():StarlingSceneNavigator{
			return StarlingApplication.application.sceneNavigator;
		}
		
		protected function init():void{
			
		}
	}
}