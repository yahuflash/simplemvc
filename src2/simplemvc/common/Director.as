package simplemvc.common
{
	import simplemvc.animation.AnimationManager;
	import simplemvc.animation.IAnimation;
	
	use namespace simplemvc_internal;

	public final class Director implements IDirector,IAnimation{
		private static var instance:Director;
		public static function sharedDirector():Director{
			return (instance ||= new Director);
		}
		public function Director(){}
		
		simplemvc_internal var playing:Boolean = false;
		
		public function isPlaying():Boolean{
			return playing;
		}
		
		public function resume():Object{
			playing=true;
			return this;
		}
		
		public function stop():Object{
			playing=false;
			return this;
		}
		
		public function update(delta:Number):void{
			if (playing){
				AnimationManager.sharedAnimationManager().update(delta);
				DelayCallManager.sharedDelayCallManager().callAll();
			}
		}
		
	}
}