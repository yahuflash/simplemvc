package us.sban.simplemvc.core
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class SimpleViewManager
	{
		private var srcClip:Sprite;
		private var view:DisplayObject;
		private var stack:Array = [];

		public function SimpleViewManager(srcClip:Sprite)
		{
			this.srcClip = srcClip;
		}

		public function addView(view:DisplayObject):DisplayObject
		{
			if (stack.indexOf(view) == -1)
			{
				stack.push(view);

				srcClip.addChild(view);
			}

			return view;
		}

		public function removeView(view:DisplayObject, dispose:Boolean = false):void
		{
			var idx:int = stack.indexOf(view);

			if (idx != -1)
			{
				srcClip.removeChild(view, dispose);

				stack.splice(idx, 1);
			}
		}

		public function popView(dispose:Boolean = false):void
		{
			removeView(stack[stack.length - 1], dispose);
		}

		public function removeAll(dispose:Boolean = false):void
		{
			for each(var s:DisplayObject in stack)
			{
				removeView(s, dispose);
			}
		}

		public function setView(ViewClass:Class, params:Object = null, disposeOfLast:Boolean = false):DisplayObject
		{
			removeExistingView(disposeOfLast);

			view = DisplayObject(new ViewClass());

			removeAll();

			srcClip.addChild(view);

			return view;
		}

		private function removeExistingView(dispose:Boolean):void
		{
			if (view)
			{
				srcClip.removeChild(view, dispose);
			}
		}
	}

}
