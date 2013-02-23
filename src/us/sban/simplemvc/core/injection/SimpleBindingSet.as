package us.sban.simplemvc.core.injection
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	public class SimpleBindingSet implements IAnimatable
	{
		public function SimpleBindingSet(){}
		
		private const autoBindings:Array = [];
		private const bindings:Array = [];
		private var running:Boolean;
		private var invalidated:Array = [];

		public function invalidate(instance:Object, propertyName:String):void
		{
			var binding:SimpleBinding = getBinding(instance, propertyName);
			var alreadyInvalidated:Boolean = invalidated.indexOf(binding) != -1;

			if (binding && !alreadyInvalidated)
			{
				invalidated.push(binding);
			}
		}

		public function addBinding(binding:SimpleBinding, auto:Boolean = true):void
		{
			if (!bindingExists(binding))
			{
				if (auto)
					autoBindings.push(binding);
				else
					bindings.push(binding);
			}

			determineIfShouldRun();
			binding.apply();
		}

		public function removeBinding(binding:SimpleBinding):void
		{
			var idx:int = autoBindings.indexOf(binding);

			if (idx != -1)
				autoBindings.splice(idx, 1);

			idx = bindings.indexOf(binding);

			if (idx != -1)
				bindings.splice(idx, 1);

			determineIfShouldRun();
		}

		public function removeBindingsForTarget(target:Object):void
		{
			removeFromArrayIfUsesTarget(target, autoBindings);
			removeFromArrayIfUsesTarget(target, bindings);
			removeFromArrayIfUsesTarget(target, invalidated);

			determineIfShouldRun();
		}

		private function removeFromArrayIfUsesTarget(target:Object, collection:Array):void
		{
			for (var i:int = collection.length - 1; i >= 0; i--)
			{
				var binding:SimpleBinding = collection[i];

				if (binding.usesTarget(target))
				{
					collection.splice(i, 1);
				}
			}
		}

		private function determineIfShouldRun():void
		{
			if (autoBindings.length > 0 || bindings.length > 0)
			{
				if (!running)
				{
					Starling.juggler.add(this);
					running = true;
				}
			}
			else
			{
				if (running)
				{
					Starling.juggler.remove(this);
					running = false;
				}
			}
		}

		public function advanceTime(time:Number):void
		{
			var i:int;
			var binding:SimpleBinding;

			for (i = 0; i < autoBindings.length; i++)
			{
				binding = autoBindings[i];

				if (binding.changed)
				{
					binding.apply();
				}
			}

			for (i = invalidated.length - 1; i >= 0; i--)
			{
				binding = invalidated[i];
				binding.apply();
				invalidated.splice(i, 1);
			}
		}

		private function getBinding(instance:Object, propertyName:String):SimpleBinding
		{
			for each (var binding:SimpleBinding in bindings)
			{
				if (binding.fromTarget == instance && binding.fromPropertyName == propertyName)
				{
					return binding;
				}
			}

			return null;
		}

		private function bindingExists(bindingIn:SimpleBinding):Boolean
		{
			var binding:SimpleBinding;

			for each (binding in autoBindings)
			{
				if (areEqual(binding, bindingIn))
					return true;
			}

			for each (binding in bindings)
			{
				if (areEqual(binding, bindingIn))
					return true;
			}

			return false;
		}

		private function areEqual(bindingOne:SimpleBinding, bindingTwo:SimpleBinding):Boolean
		{
			return bindingOne.fromTarget == bindingTwo.fromTarget && bindingOne.toTarget == bindingTwo.toTarget && bindingOne.fromPropertyName == bindingTwo.fromPropertyName && bindingOne.toPropertyName == bindingTwo.toPropertyName;
		}
	}
}
