package simplemvc.animation
{
	/**将动画、周期运行的对象(实现了IAnimation接口)推入该管理器中，simplemvc负责定期调用每个对象的update方法*/
	public final class AnimationManager{
		private static var instance:AnimationManager;
		public static function sharedAnimationManager():AnimationManager{
			return (instance ||= new AnimationManager);
		}
		public function AnimationManager(){}
		
		private var animations:Vector.<IAnimation> = new Vector.<IAnimation>();
		
		public function update(delta:Number):void{
			for each(var ani:Animation in animations){
				ani.update(delta);
			}
		}
		
		public function push(animation:IAnimation):void{
			animations.push(animation);
		}
		public function remove(animation:IAnimation):void{
			var index:int = animations.indexOf(animation);
			if (index > -1) animations.splice(index,1);
		}
		public function clear():void{
			animations.length=0;
		}
	}
}