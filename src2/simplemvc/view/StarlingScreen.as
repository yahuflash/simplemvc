package simplemvc.view
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StarlingScreen extends Sprite
	{
		public function StarlingScreen()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected var mBackground:Image;
		protected function get self():StarlingScreen{
			return this;
		}
		
		protected function onAddedToStage(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type,arguments.callee);
			init();
		}
		
		protected function init():void{}
		
		/**滑向左边界面外*/
		public function slideToLeft():void{
			var tween:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
			tween.animate("x", 0-stage.stageWidth);
			tween.onComplete = function():void { 
				//self.parent.removeChild(self,true); 
			};
			Starling.juggler.add(tween);
		}
		/**从右边界面外滑入*/
		public function slideFromRight():void{
			x = stage.stageWidth;
			var tween:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
			tween.animate("x", 0);
			tween.onComplete = function():void { 
				//self.parent.removeChild(self,true); 
			};
			Starling.juggler.add(tween);
		}
		/**滑向右边界面外*/
		public function slideToRight():void{
			var tween:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
			tween.animate("x", 0+stage.stageWidth);
			tween.onComplete = function():void { 
				self.parent.removeChild(self,true); 
			};
			Starling.juggler.add(tween);
		}
		/**从左边界面外滑入*/
		public function slideFromLeft():void{
			x = 0-stage.stageWidth;
			var tween:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
			tween.animate("x", 0);
			tween.onComplete = function():void { 
				//self.parent.removeChild(self,true); 
			};
			Starling.juggler.add(tween);
		}
		
	}
}