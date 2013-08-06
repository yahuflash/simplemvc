package
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	
	import simplemvc.view.StarlingApplication;
	import simplemvc.view.StarlingScreen;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public final class FirstScreenTest extends StarlingScreen
	{
		public function FirstScreenTest()
		{
			super();
		}
		
		protected var button:Button;
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			super.init();
			
			this.button = new Button();
			button.width=200;
			button.height=80;
			
			this.button.label = "Click Me 中文";
			
			//an event that tells us when the user has tapped the button.
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			
			//add the button to the display list, just like you would with any
			//other Starling display object. this is where the theme give some
			//skins to the button.
			this.addChild(this.button);
			
			//the button won't have a width and height until it "validates". it
			//will validate on its own before the next frame is rendered by
			//Starling, but we want to access the dimension immediately, so tell
			//it to validate right now.
			this.button.validate();
			
			//center the button
			this.button.x = (this.stage.stageWidth - this.button.width) / 2;
			this.button.y = (this.stage.stageHeight - this.button.height) / 2;
		}
		
		protected function button_triggeredHandler(event:Event):void
		{
			const label:Label = new Label();
			label.text = "Hi, I'm Feathers!\nHave a nice day.哈哈中文提示图片。";
			Callout.show(label, this.button);
			Starling.juggler.delayCall(function():void{
				StarlingApplication.navigator.popupScreen();
			},1);
		}
		
	}
}